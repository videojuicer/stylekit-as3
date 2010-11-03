package org.stylekit.css.parse
{
	
	/**
	* This is the class responsible for lexical parsing of CSS code. After a successful parsing operation,
	* a <code>StyleSheet</code> is returned by the parser.
	*/
	import flash.events.EventDispatcher;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.selector.MediaSelector;
	import org.stylekit.css.style.Animation;
	import org.stylekit.css.style.AnimationKeyFrame;
	import org.stylekit.css.style.FontFace;
	import org.stylekit.css.style.Import;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.value.AnimationCompoundValue;
	import org.stylekit.css.value.AnimationDirectionValue;
	import org.stylekit.css.value.AnimationIterationCountValue;
	import org.stylekit.css.value.BackgroundCompoundValue;
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.CornerCompoundValue;
	import org.stylekit.css.value.CursorValue;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.FloatValue;
	import org.stylekit.css.value.FontCompoundValue;
	import org.stylekit.css.value.FontStyleValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;
	import org.stylekit.css.value.InheritValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ListStyleCompoundValue;
	import org.stylekit.css.value.ListStylePositionValue;
	import org.stylekit.css.value.ListStyleTypeValue;
	import org.stylekit.css.value.NumericValue;
	import org.stylekit.css.value.OverflowValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TextAlignValue;
	import org.stylekit.css.value.TextDecorationValue;
	import org.stylekit.css.value.TextTransformValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.TransitionCompoundValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.VisibilityValue;
	import org.utilkit.util.StringUtil;
	
	public class StyleSheetParser extends EventDispatcher
	{
		// All possible states for the parser as it works through the CSS string.
		protected static var SELECTOR:uint 		= 1; // Parsing a selector
		protected static var PROPERTY:uint 		= 2; // Parsing a property name
		protected static var VALUE:uint 		= 3; // Parsing a property value
		protected static var STRING:uint 		= 4; // Parsing a quoted string
		protected static var COMMENT:uint 		= 5; // Parsing a comment
		protected static var MEDIA:uint 		= 6; // Parsing an @media statement
		protected static var IMPORT:uint 		= 7; // Parsing an @import statement
		protected static var FONTFACE:uint 		= 8; // Parsing an @font-face statement
		protected static var ANIMATION:uint 	= 9; // Parsing an @keyframes block
		protected static var KEYFRAME:uint 		= 10; // Parsing a keyframe description within an @keyframes block
		
		// Subparsers
		
		protected var _elementSelectorParser:ElementSelectorParser;
		protected var _valueParser:ValueParser;
		
		// Parser state
		// --------------------------------------------------------------
		
		/**
		* The StyleSheet instance currently being built by the parser.
		*/
		protected var _styleSheet:StyleSheet;
		
		/**
		* The current lexer index, held during parsing
		*/
		protected var _lexerIndex:uint;
		
		/**
		* The token currently being collected by the parser
		*/
		protected var _token:String;
		
		/**
		* Keeps track of the CSS code's nesting as a series of nested states.
		*/
		protected var _stateStack:Vector.<uint>;
		
		/**
		* Maintains a list of parsed Style objects.
		*/
		protected var _styleStack:Vector.<Style>;
		
		/** 
		* Maintains a list of parsed Animation objects.
		*/
		protected var _animationStack:Vector.<Animation>;
				
		/**
		* Maintains a list of parsed FontFace objects.
		*/
		protected var _fontFaceStack:Vector.<FontFace>;
		
		/**
		* Maintains a list of parsed Import objects.
		*/
		protected var _importStack:Vector.<Import>;
		
		/**
		* When parsing a quoted string, this variable holds the quote character used to enter the string state - the same character
		* will be required in order to exit the string state.
		*/	
		protected var _stringStateExitChar:String;
		
		/**
		* Maintains the property name for the corresponding value, while the value is being parsed.
		*/
		protected var _currentProperty:String;
		
		/**
		* Maintains the importance of the value currently being parsed.
		*/
		protected var _currentValueIsImportant:Boolean;
		
		/**
		* Populated by an @media declaration setting the media scope for any containing styles.
		*/
		protected var _mediaSelectorStack:Vector.<MediaSelector>;
		
		/**
		* A flag used to indicate whether or not we are in a statement that includes nested braces - e.g. an @media or @keyframes block.
		* When zero, we are not nested. When > 0, we are nested at N tiers.
		*/
		protected var _nesting:uint;
		
		// Option flags
		// --------------------------------------------------------------
		
		
		
		/**
		* Creates a new StyleSheetParser instance.
		* @constructor
		*/
		public function StyleSheetParser()
		{
			this._elementSelectorParser = new ElementSelectorParser();
			this._valueParser = new ValueParser();
		}
		
		/**
		* Begins parsing a chunk of CSS code. In the event an external stylesheet being parsed, an optional second argument <code>url</code> may be given.
		* The <code>url</code> argument should be set to the URL from which the CSS was loaded and will be used for resolving relative paths for any external
		* assets mentioned in the CSS code.
		*
		* The parser treats the CSS code as a series of nested states. In each case a scope is responsible for detecting child scopes and for affecting a return
		* to the parent state. As a special case, when any state throws the parser into the property/value pair detection cycle, the property state is responsible
		* for detecting a closing brace and exiting to the parent state.
		*
		* In most cases the parser iterates over the "root" level of the CSS file in the "selector" state, accumulating raw text to use as a selector and watching
		* for an opening brace to throw it into the property/value cycle. Again, when the property/value cycle detects a closing brace the property scope is exited
		* and the parser is returned to its previous state - this works nicely for syntax blocks with nested closing brackets.
		* 
		* There is a special rule for @font-face declarations. As these contain no identifying information in the "selector" portion of the code (which simply reads
		* "@font-face" before the opening brace), when the property/value cycle detects a closing brace the parser state will be returned to at-font-face rather
		* than being correctly nulled. To cope with this behaviour the font-face state delegates to the property/value state loop on encountering an open brace,
		* and exits when encountering any other character within its own state. Additionally the loop is rewound to allow the null state loop to use the found
		* character when determining the next state.
		*
		* Likewise if the selector state encounters a closing bracket, a decision is given to the parent scope to determine how to handle the exception.
		*/
		public function parse(css:String, url:String=""):StyleSheet
		{
			this.resetState();
			
			// Do some basic filtering on the css string
			css = css.replace(/\\(n|t|r)/g, " ");
			
			// Token collectors
			var currentProperty:String = "";
			var currentPropertyValue:String = "";
			
			// Start a character-by-character loop over the given CSS.
			for(this._lexerIndex=0; this._lexerIndex < css.length; this._lexerIndex++) {
				var i:uint = this._lexerIndex;
				var char:String = css.charAt(i);
				
				if(this.currentState != StyleSheetParser.COMMENT && this.currentState != StyleSheetParser.STRING)
				{
					// Entering a comment state
					if(css.substr(i, 2) == "/*") {
						i++; // We don't need to scan the next character so let's just skip it
						//StyleKit.logger.debug("Encountered comment start, entering comment state", this);
						this.enterState(StyleSheetParser.COMMENT);
						continue;
					}
					// Entering a string state
					else if(char == "'" || char == '"' || char == "(")
					{
						this.enterState(StyleSheetParser.STRING);
						this._stringStateExitChar = (char == "(")? ")" : char;
						this._token += char;
						//StyleKit.logger.debug("Encountered string start, entering string state", this);
						continue;
					}
				}
				
				switch(this.currentState)
				{
					// During a comment block
					case StyleSheetParser.COMMENT:
						// During a comment block, all content is ignored until we encounter the */ signal.
						if(css.substr(i,2) == "*/")
						{
							this._lexerIndex++; // We don't need to scan the next character so let's just skip it
							//StyleKit.logger.debug("Encountered comment end", this);
							this.exitState();
						}
						break;
					// During a string block
					case StyleSheetParser.STRING:
						// During a string block, all content is appended to the current token.
						// If we meet the current _stringStateExitChar, then the string block state is exited.
						if(char == this._stringStateExitChar)
						{
							//StyleKit.logger.debug("Encountered string end character during string state", this);
							this.exitState();							
						}
						this._token += char;
						break;
					// During a selector state
					case StyleSheetParser.SELECTOR:
						// SELECTOR is something of a default state for the parser, so this case mainly contains exit criteria for going to other states.
						if(char == "{")
						{
							// Entering the property block
							//StyleKit.logger.debug("Found selector '"+this._token+"'. Entering selector's property array, switching to property state. ", this);
							
							// Let's actually create the Style object ready to have properties injected
							var style:Style = new Style(this._styleSheet);
								style.mediaSelector = this.currentMediaSelector;
								style.elementSelectorChains = this._elementSelectorParser.parseSelector(this._token);
							this._styleStack.push(style);
							
							this._token = "";
							this.enterState(StyleSheetParser.PROPERTY);
						}
						else if(char == "@")
						{
							// Entering a special selector. Exit the state and rewind the loop.
							this._token = "";
							//StyleKit.logger.debug("Selector state encountered an at-selector, rewinding loop and entering special case", this);
							this.delegateToParentState();
						}
						else if(char == "}")
						{
							this._token = "";
							//StyleKit.logger.debug("Selector state found closing brace, delegating to parent", this);
							this.delegateToParentState();
						}
						else
						{
							// Continuing the selector block
							this._token += char;
						}
						break;
					// During a property state
					case StyleSheetParser.PROPERTY:
						// Properties can belong to a number of objects - we must use the state stack to determine
						// which property-inheritable state has been entered more recently.
						// Properties are supported on selectors, font-faces, and keyframe descriptors.
						if(char == ":")
						{
							// On encountering a colon, we've reached the end of the property key and can start parsing the value.
							//StyleKit.logger.debug("Found property '"+this._token+"'. about to enter value state to parse property value", this);
							currentProperty = this._token;
							this._token = "";
							this.enterState(StyleSheetParser.VALUE);
						}
						else if(char == "}")
						{
							// When exiting from a value state, we may encounter the end of this block.
							//StyleKit.logger.debug("Found closing brace, about to exit property state and return control to parent state", this);
							currentProperty = "";
							this._token = "";
							this.delegateToParentState();
						}
						else
						{
							this._token += char;
						}
						break;
					// During a value state
					case StyleSheetParser.VALUE:
						if(char == ";" || char == "}") // We allow a closing brace to end the value statement
						{
							//StyleKit.logger.debug("Found property value for property '"+currentProperty+"'. Setting on property target and exiting value state", this);

							// Grab the property key and route it to the current property target
							this.appendPropertyValue(currentProperty, this._token, this._currentValueIsImportant);
							
							currentProperty = "";
							this._currentValueIsImportant = false;

							this._token = "";
							this.exitState();
							if(char == "}")
							{
								// However if the exit character was a closing brace then we exit twice to get back to the selector state.
								this.exitState();
							}
						}
						else if(css.substr(i, 10) == "!important")
						{
							// Special value exit - the !important flag is registered but not appended to the value token.
							//StyleKit.logger.debug("Found !important property value '"+this._token+"'. about to exit value state", this);
							this._currentValueIsImportant = true;
							this._lexerIndex += 10;
						}
						else
						{
							this._token += char;
						}
						break;
					// During an import statement
					case StyleSheetParser.IMPORT:
						// In an import statement, we let the token build until the statement is terminated with a semicolon.
						if(char == ";")
						{
							// Ending the import statement. 
							// Kill the token and exit the state
							//StyleKit.logger.debug("Ending import state, about to clear token", this);
														
							var extImport:Import = new Import(this._styleSheet, this._styleStack.length, this._animationStack.length, this._fontFaceStack.length);
							var argParserResult:Array = this._valueParser.parseImportArguments(this._token);
							
							var uVal:URLValue = (argParserResult[0] as URLValue);
							extImport.urlValue = uVal;
							
							var mSel:MediaSelector;
							if(argParserResult[1] != null)
							{
								mSel = (argParserResult[1] as MediaSelector);
							}
							extImport.mediaSelector = mSel;
							
							this._importStack.push(extImport);
							
							this._token = "";
							this.exitState();
						}
						else
						{
							// Not ending the import statement just yet. Keep building the token.
							this._token += char;
						}
						break;
					// During a font-face statement
					case StyleSheetParser.FONTFACE:
						// @font-face statements are blocks much like regular selector statements, but they have no selector 
						// text - therefore no token accumulation needs to happen here. We simply watch for the { character
						// and enter the property state when it arrives.
						if(char == "{")
						{
							// Entering the property descriptor block, switch to property state
							//StyleKit.logger.debug("Found entering brace for at-font-face block, about to enter property state", this);
							
							var fontFace:FontFace = new FontFace(this._styleSheet);
								fontFace.mediaSelector = this.currentMediaSelector;
							
							this._fontFaceStack.push(fontFace);
							
							this._token = "";
							this.enterState(StyleSheetParser.PROPERTY);
						}
						else if(char == "}")
						{
							// Exiting property descriptor block for the @font-face
							// This is a special case - see method description for details.
							//StyleKit.logger.debug("Found closing brace for at-font-face block, about to exit state", this);
							this._token = "";
							this.exitState();
						}
						break;
					// During an @media rule
					case StyleSheetParser.MEDIA:
						if(char == "{")
						{
							//StyleKit.logger.debug("Entering at-media rule for '"+this._token+"', parsing token and appending new MediaSelector to stack", this);
							
							// Parse the list into the MediaSelector stack							
							this._mediaSelectorStack.push(this._valueParser.parseMediaSelector(this._token));
							
							this._token = "";
							this._nesting += 2;
							this.enterState(StyleSheetParser.SELECTOR);
						}
						else if(char == "}")
						{
							this._nesting--;
							if(this.isNested)
							{
								//StyleKit.logger.debug("at-media rule finished internal selector, now re-entering selector state", this);
								this.enterState(StyleSheetParser.SELECTOR);
							}
							else
							{
								//StyleKit.logger.debug("Exiting at-media rule, popping MediaSelector stack", this);
								
								this._mediaSelectorStack.pop();
								
								this._token = "";
								this._lexerIndex++;
								this.exitState();
							}
						}
						else
						{
							this._token += char;
						}
						break;
					// During an @keyframes state
					case StyleSheetParser.ANIMATION:
						// Accumulate the keyframeset name, then expect an opening brace. Then expect a keyframe name followed by another opening brace.
						if(char == "{")
						{
							// Found the keyframes block name
							//StyleKit.logger.debug("Found at-keyframe set '"+this._token+"'. About to look for keyframe descriptors.", this);
							
							var anim:Animation = new Animation(this._styleSheet);
								anim.animationName = this._token;
								anim.mediaSelector = this.currentMediaSelector;
							this._animationStack.push(anim);
							
							this._token = "";
							this._nesting += 2;
							this.enterState(StyleSheetParser.KEYFRAME);
						}
						else if(char == "}")
						{
							this._nesting--;
							if(this.isNested)
							{
								//StyleKit.logger.debug("at-keyframes block finished internal keyframe, now re-entering keyframe state", this);
								this.enterState(StyleSheetParser.KEYFRAME);
							}
							else
							{
								//StyleKit.logger.debug("Exiting at-keyframes block", this);
								this._token = "";
								this._lexerIndex++;
								this.exitState();
							}
						}
						else
						{
							this._token += char;
						}
						break;
					// During a keyframe state within an @keyframes state
					case StyleSheetParser.KEYFRAME:
						if(char == "{")
						{
							// Finished collecting a keyframe descriptor
							//StyleKit.logger.debug("Found individual keyframe descriptor '"+this._token+"', about to look for properties", this);
							
							var keyFrame:AnimationKeyFrame = new AnimationKeyFrame(this._styleSheet);
								keyFrame.timeSelector = this._token;
							this.currentAnimation.addKeyFrame(keyFrame);
							
							this._token = "";
							this.enterState(StyleSheetParser.PROPERTY);
						}
						else if(char == "}")
						{
							// finished a keyframe descriptor block
							//StyleKit.logger.debug("Found exit brace for keyframe descriptor.", this);
							this.delegateToParentState(); // Exit the keyframe
						}
						else
						{
							this._token += char;
						}
						break;
					default:
						// Whitespace is skipped
						if(char != " ")
						{
							// Entering an @keyframes block
							if(css.substr(i, 10) == "@keyframes")
							{
								//StyleKit.logger.debug("Encountered at-keyframes statement, entering keyframes state", this);
								this.enterState(StyleSheetParser.ANIMATION);
								this._lexerIndex += 10;
								continue;
							}
							// Entering an @media rule
							else if(css.substr(i, 6) == "@media")
							{
								//StyleKit.logger.debug("Encountered at-media statement, entering at-media state", this);
								this.enterState(StyleSheetParser.MEDIA);
								this._lexerIndex += 6;
								continue;
							}
							// Entering an @import statement
							else if(css.substr(i, 7) == "@import")
							{
								//StyleKit.logger.debug("Encountered at-import statement, entering at-import state", this);
								this.enterState(StyleSheetParser.IMPORT);
								this._lexerIndex += 7;
								continue;
							}
							// Entering a font-face statement
							else if(css.substr(i, 10) == "@font-face")
							{
								//StyleKit.logger.debug("Encountered at-font-face statement, entering at-font-face state", this);
								this.enterState(StyleSheetParser.FONTFACE);
								this._lexerIndex += 10;
								continue;
							}
							// Default of defaults: Look for a selector!
							else
							{
								this.enterState(StyleSheetParser.SELECTOR);
							}
						}
						// Keep building the token according to the blacklist
						if(char != "{" && char != "}")
						{
							this._token += char;
						}
						break;
				}
			}
			
			// Append all the collected values to the stylesheet
			var a:uint = 0;			
			for(a=0; a < this._styleStack.length; a++)
			{
				this._styleSheet.addStyle(this._styleStack[a]);
			}
			StyleKit.logger.debug("StyleSheet build: Found "+this._styleStack.length+" styles", this);
			
			for(a=0; a < this._importStack.length; a++)
			{
				this._styleSheet.addImport(this._importStack[a]);
			}
			StyleKit.logger.debug("StyleSheet build: Found "+this._importStack.length+" @import statements", this);
			
			for(a=0; a < this._animationStack.length; a++)
			{
				this._styleSheet.addAnimation(this._animationStack[a]);
			}
			StyleKit.logger.debug("StyleSheet build: Found "+this._animationStack.length+" @keyframe blocks", this);
			
			for(a=0; a < this._fontFaceStack.length; a++)
			{
				this._styleSheet.addFontFace(this._fontFaceStack[a]);
			}
			StyleKit.logger.debug("StyleSheet build: Found "+this._fontFaceStack.length+" @font-face declarations", this);
			
			return this._styleSheet;
		}
		
		
		protected function resetState():void
		{
			//StyleKit.logger.debug("Resetting parser state for new parse operation", this);
			this._mediaSelectorStack = new Vector.<MediaSelector>();
			this._styleSheet = new StyleSheet();			
			this._stateStack = new Vector.<uint>();
			this._styleStack = new Vector.<Style>();
			this._importStack = new Vector.<Import>();
			this._animationStack = new Vector.<Animation>();
			this._fontFaceStack = new Vector.<FontFace>();
			this._currentValueIsImportant = false;
			this._nesting = 0;
			this._token = "";
		}
		
		/**
		 * Unsupported CSS properties:
		 * 
		 * azimuth, clip, content, counter-increment, counter-reset, cue, cue-after, cue-before, 
		 * direction, caption-side, elevation, empty-cells, orphans, page-break-after, page-break-before,
		 * page-break-inside, pause-after, pause-before, pause, pitch-range, pitch, play-during, richness,
		 * speak-header, speak-numeral, speak-punctuation, speak, speech-rate, stress, table-layout,
		 * unicode-bidi, voice-family, volume, widows
		 */
		protected function appendPropertyValue(propertyName:String, unparsedPropertyValue:String, valueIsImportant:Boolean = false):void
		{
			var propN:String = StringUtil.trim(propertyName.toLowerCase());
			var property:Property = new Property(propN);
			
			if (InheritValue.identify(unparsedPropertyValue))
			{
				// we pass the property name to the inherit value so we 
				// know what to inherit
				property.value = new InheritValue(propN);
			}
			else
			{
				switch(propN)
				{
					// Complex Compound values
					case "background":
						property.value = BackgroundCompoundValue.parse(unparsedPropertyValue);
						break;
					case "border":
						var borderValue:BorderCompoundValue = BorderCompoundValue.parse(unparsedPropertyValue);
						var edgeValue:EdgeCompoundValue = new EdgeCompoundValue();
						edgeValue.topValue = edgeValue.leftValue = edgeValue.rightValue = edgeValue.bottomValue = borderValue;
						
						property.value = edgeValue;
						break;
					case "float":
						property.value = FloatValue.parse(unparsedPropertyValue);
						break;
					case "box-flex":
						property.value = NumericValue.parse(unparsedPropertyValue);
						break;
					case "box-flex-group":
						property.value = NumericValue.parse(unparsedPropertyValue);
						break;
					case "box-align":
					//case "box-ordinal-group":
					//case "box-direction":
					//case "box-orient":
					case "box-pack":
					case "box-lines":
					case "font":
						property.value = FontCompoundValue.parse(unparsedPropertyValue);
						break;
					case "font-family":
						property.value = Value.parse(unparsedPropertyValue);
						break;
					case "font-size":
						property.value = SizeValue.parse(unparsedPropertyValue);
						break;
					case "font-style":
						property.value = FontStyleValue.parse(unparsedPropertyValue);
						break;
					case "font-variant":
						property.value = FontVariantValue.parse(unparsedPropertyValue);
						break;
					case "font-weight":
						property.value = FontWeightValue.parse(unparsedPropertyValue);
						break;
					case "list-style":
						property.value = ListStyleCompoundValue.parse(unparsedPropertyValue);
						break;
					case "display":
						property.value = DisplayValue.parse(unparsedPropertyValue);
						break;
					case "text-transform":
						property.value = TextTransformValue.parse(unparsedPropertyValue);
						break;
					case "text-decoration":
						property.value = TextDecorationValue.parse(unparsedPropertyValue);
						break;
					case "text-align":
						property.value = TextAlignValue.parse(unparsedPropertyValue);
						break;
					case "cursor":
						property.value = CursorValue.parse(unparsedPropertyValue);
						break;
					case "opacity":
						property.value = NumericValue.parse(unparsedPropertyValue);
						break;
					case "visibility":
						property.value = VisibilityValue.parse(unparsedPropertyValue);
						break;
					case "background-image":
						property.value = URLValue.parse(unparsedPropertyValue);
						break;
					case "background-repeat":
						property.value = RepeatValue.parse(unparsedPropertyValue);
						break;
					case "padding": case "margin": case "border-width": case "border-radius":
						property.value = this._valueParser.parseEdgeSizeCompoundValue(unparsedPropertyValue);
						break;
					case "border-top": case "border-left": case "border-right": case "border-bottom":
						property.value = BorderCompoundValue.parse(unparsedPropertyValue);
						break;
					case "border-top-right-radius": case "border-bottom-right-radius": case "border-bottom-left-radius": case "border-top-left-radius":
						property.value = SizeValue.parse(unparsedPropertyValue);
						break;
					case "left": case "right": case "top": case "bottom":
						property.value = SizeValue.parse(unparsedPropertyValue);
						break;
					case "border-radius":
						property.value = CornerCompoundValue.parse(unparsedPropertyValue);
						break;
					case "list-style-position":
						property.value = ListStylePositionValue.parse(unparsedPropertyValue);
						break;
					case "list-style-type":
						property.value = ListStyleTypeValue.parse(unparsedPropertyValue);
						break;
					case "list-style-image":
						property.value = URLValue.parse(unparsedPropertyValue);
						break;
					case "animation":
						property.value = AnimationCompoundValue.parse(unparsedPropertyValue);
						break;
					case "animation-name":
						property.value = ValueArray.parse(unparsedPropertyValue, Value)
						break;
					case "animation-iteration-count":
						property.value = ValueArray.parse(unparsedPropertyValue, AnimationIterationCountValue)
						break;
					case "animation-direction":
						property.value = ValueArray.parse(unparsedPropertyValue, AnimationDirectionValue)
						break;
					case "transition":
						property.value = TransitionCompoundValue.parse(unparsedPropertyValue);
						break;
					case "transition-property":
						property.value = PropertyListValue.parse(unparsedPropertyValue);
						break;
					default:
						// overflow, overflow-x, overflow-y, text-overflow
						if (propN.indexOf("overflow") > -1)
						{
							property.value = OverflowValue.parse(unparsedPropertyValue);
						}
						// padding-left, margin-right etc.
						else if(propN.indexOf("padding") == 0 || propN.indexOf("margin") == 0)
						{
							property.value = SizeValue.parse(unparsedPropertyValue);
						}
						// position, ruby-position, text-underline-position
						else if (propN.indexOf("position") > -1)
						{
							property.value = PositionValue.parse(unparsedPropertyValue);
						}
						// border-style, outline-style
						else if (propN.indexOf("style") > -1)
						{
							property.value = LineStyleValue.parse(unparsedPropertyValue);
						}
						// background-color, border-color, color, outline-color, scrollbar-arrow-color
						else if (propN.indexOf("color") > -1)
						{
							property.value = ColorValue.parse(unparsedPropertyValue);
						}
						else if (propN.indexOf("width") > -1 || propN.indexOf("height") > -1)
						{
							property.value = SizeValue.parse(unparsedPropertyValue);
						}
						else if(propN.indexOf("delay") > -1 || propN.indexOf("duration") > -1)
						{
							property.value = ValueArray.parse(unparsedPropertyValue, TimeValue);
						}
						else if(propN.indexOf("timing-function") > -1)
						{
							property.value = ValueArray.parse(unparsedPropertyValue, TimingFunctionValue);
						}
						else
						{
							property.value = new Value();
							property.value.rawValue = property.value.stringValue = (unparsedPropertyValue);
						}
						break;
				}
			}
			
			// Set the !important flag if it was found
			if(valueIsImportant)
			{
				property.value.important = true;
			}
			
			this.currentPropertyTarget.addProperty(property);
		}
		
		/**
		* Parses a local style fragment such as "border: 1px solid red;", and outputs a style object with no style selector
		*/
		public function parseLocalStyleFragment(str:String):Style
		{
			str = "_local { "+str+"}";
			var styleSheet:StyleSheet = this.parse(str);
			return styleSheet.styles[0];
		}
		
		protected function enterState(state:uint):void
		{
			// Duplicate states are not allowed to stack
			if(this.currentState != state) 
			{
				this._stateStack.push(state);
			}
		}
		
		protected function exitState():void
		{
			//Logger.debug("About to exit state, state stack before exit is "+this._stateStack.join(", "), this);
			this._stateStack.pop();
		}
		
		/**
		* Exits the current parser state and also rewinds by one character to allow the parent state to lex the current character
		*/
		protected function delegateToParentState():void
		{
			this._lexerIndex--;
			this.exitState();
		}
		
		protected function get currentState():uint
		{
			if(this._stateStack.length < 1) return 0;
			return this._stateStack[this._stateStack.length-1];
		}
		
		protected function get previousState():uint
		{
			if(this._stateStack.length <= 1) return 0;
			return this._stateStack[this._stateStack.length-2];
		}
		
		/**
		* Returns true if the state stack contains the given state (i.e. if we are activey processing in, or nested within, the specified state)
		*/
		protected function inState(state:uint):Boolean
		{
			return (this._stateStack.indexOf(state) > -1);
		}
		
		/**
		* examines the _nesting variable to determine if we are nested at 1 tier or higher.
		*/
		protected function get isNested():Boolean
		{
			return (this._nesting >= 1);
		}
		
		protected function get currentMediaSelector():MediaSelector
		{
			if(this._mediaSelectorStack.length < 1)
			{
				return null;
			}
			return this._mediaSelectorStack[this._mediaSelectorStack.length - 1];
		}
		
		/**
		* Called during the property/value parser cycle. The current property recipient is determined from the parser's stateStack
		* and is the lowest-hanging Style, AnimationKeyFrame, or FontFace object.
		*/
		protected function get currentPropertyTarget():PropertyContainer
		{
			// Loop backwards over state stack
			for(var i:int=this._stateStack.length-1; i>=0; i--)
			{
				var state:uint = this._stateStack[i];
				if(state == StyleSheetParser.KEYFRAME)
				{
					return this.currentAnimationKeyFrame;
				}
				else if(state == StyleSheetParser.FONTFACE)
				{
					return this.currentFontFace;
				}
				else if(state == StyleSheetParser.SELECTOR)
				{
					return this.currentStyle;
				}
			}
			return null;
		}
		
		protected function get currentStyle():Style
		{
			return this._styleStack[this._styleStack.length-1];
		}
		
		protected function get currentAnimation():Animation
		{
			return this._animationStack[this._animationStack.length-1];
		}
		
		protected function get currentAnimationKeyFrame():AnimationKeyFrame
		{
			return this.currentAnimation.keyFrames[this.currentAnimation.keyFrames.length-1];
		}
		
		protected function get currentFontFace():FontFace
		{
			return this._fontFaceStack[this._fontFaceStack.length-1];
		}
		
		protected function get currentImport():Import
		{
			return this._importStack[this._importStack.length-1];
		}
		
		// TODO DELETEME when adam adds UtilKit to the mix
		public var logs:Vector.<String>;
		protected function debug(message:String, target:Object):void
		{
			if(!this.logs) this.logs = new Vector.<String>();
			this.logs.push(message);
		}
	}
	
}
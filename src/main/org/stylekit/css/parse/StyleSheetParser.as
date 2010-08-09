package org.stylekit.css.parse
{
	
	/**
	* This is the class responsible for lexical parsing of CSS code. After a successful parsing operation,
	* a vector of <code>StyleSheet</code> objects is made available on the parser.
	*
	* CSS Parsing is an asynchronous operation.
	*/
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.Style;
	
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
		protected static var KEYFRAMES:uint 	= 9; // Parsing an @keyframes block
		protected static var KEYFRAME:uint 		= 10; // Parsing a keyframe description within an @keyframes block
		
		// Parser state
		// --------------------------------------------------------------
		
		/**
		* The StyleSheet instance currently being built by the parser.
		*/
		protected var _styleSheet:StyleSheet;
		
		/**
		* The Style instance currently being built by the parser.
		*/
		
		protected var _currentStyle:Style;
		
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
		* When parsing a quoted string, this variable holds the quote character used to enter the string state - the same character
		* will be required in order to exit the string state.
		*/	
		protected var _stringStateExitChar:String;
		
		// Option flags
		// --------------------------------------------------------------
		
		
		
		/**
		* Creates a new StyleSheetParser instance.
		* @constructor
		*/
		public function StyleSheetParser()
		{
		}
		
		/**
		* Begins parsing a chunk of CSS code. In the event an external stylesheet being parsed, an optional second argument <code>url</code> may be given.
		* The <code>url</code> argument should be set to the URL from which the CSS was loaded and will be used for resolving relative paths for any external
		* assets mentioned in the CSS code.
		*/
		public function parse(css:String, url:String=""):void
		{
			this.resetState();
			
			// Start a character-by-character loop over the given CSS.
			for(var i:uint=0; i < css.length; i++) {
				var char:String = css.charAt(i);
				
				if(this.currentState != StyleSheetParser.COMMENT && this.currentState != StyleSheetParser.STRING)
				{
					// Entering a comment state
					if(css.substr(i, 2) == "/*") {
						i++; // We don't need to scan the next character so let's just skip it
						this.enterState(StyleSheetParser.COMMENT);
						continue;
					}
					// Entering a string state
					else if(char == "'" || char == '"' || char == "(")
					{
						this.enterState(StyleSheetParser.STRING);
						this._stringStateExitChar = (char == "(")? ")" : char;
						this._token += char;
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
							i++; // We don't need to scan the next character so let's just skip it
							this.exitState();
						}
						break;
					// During a string block
					case StyleSheetParser.STRING:
						// During a string block, all content is appended to the current token.
						// If we meet the current _stringStateExitChar, then the string block state is exited.
						if(char == this._stringStateExitChar)
						{
							this.exitState();
							
						}
						this._token += char;
						break;
					// During an import statement
					case StyleSheetParser.IMPORT:
						// In an import statement, we let the token build until the statement is terminated with a semicolon.
						if(char == ";")
						{
							// Ending the import statement. 
							// TODO Throw the token into an Import object at the current style index.
							// Kill the token and exit the state
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
						// @font-face statements are blocks much like regular selector statements
						if(char == "{")
						{
							// Entering the property descriptor block, switch to property state
							// TODO
						}
						else if(char == "}")
						{
							// Leaving the property descriptor block. Exit the FONTFACE state.
							// TODO
						}
						break;
					// During an @rule
					case StyleSheetParser.MEDIA:
						break;
					// During a selector state
					case StyleSheetParser.SELECTOR:
						// SELECTOR is something of a default state for the parser, so this case mainly contains exit criteria for going to other states.
						
						break;
					// During a property state
					case StyleSheetParser.PROPERTY:
						break;
					// During a value state
					case StyleSheetParser.VALUE:
						break;
					// During an @keyframes state
					case StyleSheetParser.KEYFRAMES:
						break;
					// During a keyframe state within an @keyframes state
					case StyleSheetParser.KEYFRAME:
						break;
					default:
						// Whitespace is skipped
						if(char != " ")
						{
							// Entering an @keyframes block
							if(css.substr(i, 10) == "@keyframes")
							{
								this.enterState(StyleSheetParser.KEYFRAMES);
								i = i+10;
							}
							// Entering an @media rule
							else if(css.substr(i, 6) == "@media")
							{
								this.enterState(StyleSheetParser.MEDIA);
								i = i+6;
							}
							// Entering an @import statement
							else if(css.substr(i, 7) == "@import")
							{
								this.enterState(StyleSheetParser.IMPORT);
								i = i+7;
							}
							// Entering a font-face statement
							else if(css.substr(i, 10) == "@font-face")
							{
								this.enterState(StyleSheetParser.FONTFACE);
								i = i+10;
							}
							// Default of defaults: Look for a selector!
							else
							{
								this.enterState(StyleSheetParser.SELECTOR);
							}
						}
						break;
				}
			}
		}
		
		protected function resetState():void
		{
			this._styleSheet = new StyleSheet();			
			this._stateStack = new Vector.<String>;
			this._token = "";
		}
		
		protected function enterState(state:uint):void
		{
			// Duplicate states are not allowed to stack
			if(this.currentState != state) 
			{
				this.debug("Entering state: "+state, this);
				this._stateStack.push(state);
			}
		}
		
		protected function exitState():void
		{
			this.debug("Exiting state, new state is "+this.currentState, this);
			this._stateStack.pop();
		}
		
		public function get currentState():uint
		{
			return this._stateStack[this._stateStack.length-1];
		}
		
		public function get previousState():uint
		{
			return this._stateStack[this._stateStack.length-2];
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
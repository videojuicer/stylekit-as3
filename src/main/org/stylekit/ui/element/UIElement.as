package org.stylekit.ui.element
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.errors.StackOverflowError;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.selector.ElementSelector;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.AnimationCompoundValue;
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.CornerCompoundValue;
	import org.stylekit.css.value.CursorValue;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.FloatValue;
	import org.stylekit.css.value.IntegerValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.NumericValue;
	import org.stylekit.css.value.OverflowValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TextAlignValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.TransitionCompoundValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.events.TransitionWorkerEvent;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.layout.FlowControlLine;
	import org.stylekit.ui.element.paint.UIElementPainter;
	import org.stylekit.ui.element.worker.TransitionWorker;
	import org.utilkit.util.ObjectUtil;
	
	/**
	 * Dispatched when the effective dimensions are changed on the UI element.
	 *
	 * @eventType org.stylekit.events.UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED
	 */
	[Event(name="uiElementEffectiveDimensionsChanged", type="org.stylekit.events.UIElementEvent")]
	
	/**
	 * Dispatched when the evaluated/computed styles for this element are changed by any mechanism.
	 *
	 * @eventType org.stylekit.events.UIElementEvent.EVALUATED_STYLES_MODIFIED
	 */
	[Event(name="uiElementEvaluatedStylesModified", type="org.stylekit.events.UIElementEvent")]
	
	
	public class UIElement extends Sprite
	{
		
		protected static var EFFECTIVE_CONTENT_DIMENSION_CSS_PROPERTIES:Array = [
			"width", "height", 
			"max-width", "max-height", "min-width", "min-height"
		];
		protected static var EFFECTIVE_DIMENSION_CSS_PROPERTIES:Array = [
			"padding-left", "padding-right", "padding-top", "padding-bottom", 
			"margin-top", "margin-bottom", "margin-left", "margin-right",
			"border-top-style", "border-left-style", "border-right-style", "border-bottom-style",
			"border-top-width", "border-left-width", "border-right-width", "border-bottom-width"
		];
		protected static var REDRAW_CSS_PROPERTIES:Array = [
			"border-top-color", "border-left-color", "border-right-color", "border-bottom-color",
			"border-top-style", "border-left-style", "border-right-style", "border-bottom-style",
			"background-color", "background-image", "background-position",
			"font-family", "font-size", "color"
		];
		protected static var LAYOUT_CSS_PROPERTIES:Array = [
			"float", "position", "display", 
			"top", "left", "bottom", "right"
		];
		
		/**
		* The child UIElement objects contained by the UIElement.
		*/
		protected var _children:Vector.<UIElement>;
		
		/**
		* The Style objects currently being used to draw this UIElement.
		*/
		protected var _styles:Vector.<Style>;
		
		/**
		* The ElementSelectorChains that were used to match the Style objects found in _styles.
		* Parity is maintained between the two vectors, such that _styleSelectors[x] is always the
		* selector that was used to match the style at _styles[x].
		*/
		protected var _styleSelectors:Vector.<ElementSelectorChain>;
		
		/**
		* The evaluated (sometimes referred to as *computed*) styles for this element, as a flat object
		* containing primitive Value types. By the time styles have been evaluated into this object, all
		* "inherit" values have been resolved and replaced with the value they refer to, and all compound/shorthand
		* statements have been made atomic. E.g. the "border-left" property will have been broken down into
		* border-left-width, border-left-style, border-left-color.
		*/
		protected var _evaluatedStyles:Object;
		
		/**
		* Tracks the first time evaluated styles are set on this element. Transitions and some other operations
		* are skipped on the first evaluation.
		*/
		protected var _runTransitions:Boolean = false;
		
		/**
		* Determines if this UIElement is eligible to receive styles.
		*/
		protected var _styleEligible:Boolean = true;
		
		/**
		* The total horizontal extent of this element, including content area, padding, borders and margins. It is the amount of
		* space this element consumes within a layout.
		*
		* This value is recalculated when evaluating styles, and sometimes after a layout operation. See _contentWidth for details of this.
		*
		* A change to this value will result in the EFFECTIVE_DIMENSIONS_CHANGED event being dispatched.
		* 
		* @see org.stylekit.ui.element.UIElement._contentWidth
		*/
		protected var _effectiveWidth:int;
		
		/**
		* The effective height of this element. Same behaviour as effectiveWidth.
		* @see org.stylekit.ui.element.UIElement._effectiveWidth
		*/ 
		protected var _effectiveHeight:int;
		
		/**
		* Just as each element has effective dimensions, so do each element's child elements. The contentWidth property on an element is defined
		* as the total effective extent of an element's children, calculated by taking the furthest right-hand effective edge as the width, and 
		* the furthest effective edge toward the bottom as the height. Recalculated after a layout operation.
		* If the value changes after a layout operation and the width and height properties on this element are not fixed, this element's
		* effectiveWidth and effectiveHeight will be recalculated and the element will be redrawn.
		* 
		* If this value changes after a layout operation AND the width or height properties on this element *are* fixed AND the overflow
		* properties on this element demand the use of scrollbars, this element may be partially redrawn to add or remove scrollbars to the
		* content area.
		*/
		protected var _contentWidth:int;
		
		/**
		* The effective height of the content rendered within this element. Same behaviour as _contentWidth.
		* @see org.stylekit.ui.element.UIElement._contentWidth
		*/
		protected var _contentHeight:int;
		
		/**
		* The current width of the content area on this element - the area inside the element's padding into which content
		* may be rendered. This is not necessarily the size of the *content itself* within the element.
		*
		* Depending on the overflow, width and height properties on this element, the effectiveContentWidth may be recalculated
		* after a layout operation, triggering a full or partial redrawing of this element. See _contentWidth for details.
		*
		* The effectiveContentWidth is reduced by the presence of the vertical scrollbar.
		*
		* @see org.stylekit.ui.element.UIElement._contentWidth
		*/
		protected var _effectiveContentWidth:int;
		
		/**
		* The height of the content area on this element. Same behaviour as _effectiveContentWidth.
		* @see org.stylekit.ui.element.UIElement._effectiveContentWidth
		*/
		protected var _effectiveContentHeight:int;

		protected var _parentIndex:uint = 0;
		protected var _parentElement:UIElement;
		
		protected var _baseUI:BaseUI;
		
		protected var _elementName:String;
		protected var _elementId:String;
		
		protected var _elementClassNames:Vector.<String>;
		protected var _elementPseudoClasses:Vector.<String>;
		
		protected var _controlLines:Vector.<FlowControlLine>;
		protected var _controlLinesUnsorted:Vector.<FlowControlLine>;
		
		protected var _painter:UIElementPainter;
		
		// An associative set of transition workers and the properties they relate to.
		protected var _transitionWorkers:Vector.<TransitionWorker>;
		protected var _transitionWorkerProperties:Vector.<String>;
		
		protected var _rawContentWidth:int = 0;
		protected var _rawContentHeight:int = 0;
		
		protected var _listensForHover:Boolean = false;
		protected var _redrawDeferredUntilHasParent:Boolean = false;
		
		/**
		* A reference to the Style object used to store this element's local styles. This Style is treated with a higher 
		* priority than styles sourced from the BaseUI's stylesheet collection.
		*/ 
		protected var _localStyle:Style;
		
		protected var _contentContainer:Sprite;
		protected var _contentSprites:Vector.<DisplayObject>;
		
		// Element state caches
		protected var _descendants:Vector.<UIElement>; // All descendants. Updated when elements are added/removed to/from this tree.
		protected var _descendantsByClass:Object; // All descendants mapped by classname.
		protected var _descendantsById:Object; // All descendants mapped by element ID
		protected var _descendantsByName:Object; // All descendants mapped by element name
		protected var _descendantsByPseudoClass:Object; // All descendants mapped by pseudo
		
		// Evaluated style cache
		protected var _evaluatedNetworkStyleCache:Object;
		protected var _evaluatedStyleCurrentCacheKey:String = "THIS_CACHE_KEY_SHOULD_NEVER_BE_MATCHED_WIBBLE_WIBBLE_BOING";
		
		// Evaluated size cache
		protected var _computedSizes:Object;
		
		protected var _decoratingChildren:Boolean = false;
		protected var _requiresAnotherDecorate:Boolean = false;
		
		// Deferred style keys modified during a BaseUI style allocation transaction
		protected var _deferredModifiedStyleKeys:Vector.<String>;
		
		public function UIElement(baseUI:BaseUI = null)
		{
			super();
			
			this._baseUI = baseUI;
			this.evaluatedStyles = {};
			this._runTransitions = false;
			
			this._children = new Vector.<UIElement>();
			this._controlLines = new Vector.<FlowControlLine>();
			
			this._elementClassNames = new Vector.<String>();
			this._elementPseudoClasses = new Vector.<String>();

			
			this._transitionWorkers = new Vector.<TransitionWorker>();
			this._transitionWorkerProperties = new Vector.<String>();
			
			this._contentSprites = new Vector.<DisplayObject>();
			this._contentContainer = new Sprite();
			
			this._painter = new UIElementPainter(this);
			
			this._evaluatedNetworkStyleCache = {};
			this._computedSizes = {};
			
			this._styles = new Vector.<Style>();
			this._styleSelectors = new Vector.<ElementSelectorChain>();
			
			this.resetDescendantRegistry();
			
			this.addEventListener(FocusEvent.FOCUS_IN, this.onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusOut);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			
			this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
		
		public function get parentElement():UIElement
		{
			return this._parentElement;
		}
		
		public function set parentElement(parent:UIElement):void
		{
			var prev:UIElement = this._parentElement;
			if(prev != null)
			{
				this._parentElement.removeEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, this.onParentElementEvaluatedStylesModified);
			}
			this._parentElement = parent;
			this._parentElement.addEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, this.onParentElementEvaluatedStylesModified);
			this.movedToNewAncestorTree(prev, this._parentElement);
			
			if (this._redrawDeferredUntilHasParent)
			{
				this.redraw();
				
				this._redrawDeferredUntilHasParent = false;
			}
		}
		
		public function get baseUI():BaseUI
		{
			return this._baseUI;
		}
		
		public function get localStyle():Style
		{
			return this._localStyle;
		}
		
		public function set localStyle(s:Style):void
		{
			this._localStyle = s;
			this.evaluateStyles();
		}
		
		public function set localStyleString(s:String):void
		{
			var style:Style = (new StyleSheetParser()).parseLocalStyleFragment(s);
			this.localStyle = style;
		}
		
		public function get styleEligible():Boolean
		{
			return this._styleEligible;
		}
		
		public function set styleEligible(styleEligible:Boolean):void
		{
			this._styleEligible = styleEligible;
		}
		
		public function get elementClassNames():Vector.<String>
		{
			return this._elementClassNames;
		}
		
		public function get elementPseudoClasses():Vector.<String>
		{
			return this._elementPseudoClasses;
		}
		
		public function get listensForHover():Boolean
		{
			return this._listensForHover;
		}
		
		public function set listensForHover(b:Boolean):void
		{
			this._listensForHover = b;
		}
		
		public function get descendants():Vector.<UIElement>
		{
			return this._descendants;
		}
		
		public function get descendantsByClass():Object
		{
			return this._descendantsByClass;
		}
		
		public function get descendantsById():Object
		{
			return this._descendantsById;
		}
		
		public function get descendantsByName():Object
		{
			return this._descendantsByName;
		}
		
		public function get descendantsByPseudoClass():Object
		{
			return this._descendantsByPseudoClass;
		}
		
		public function get styles():Vector.<Style>
		{
			return this._styles;
		}
		
		public function get styleSelectors():Vector.<ElementSelectorChain>
		{
			return this._styleSelectors;
		}
		
		public function get effectiveWidth():int
		{
			return this._effectiveWidth;
		}
		
		public function get contentSprites():Vector.<DisplayObject>
		{
			return this._contentSprites;
		}
		
		public function get contentContainer():Sprite
		{
			return this._contentContainer;
		}
		
		public function get rawContentWidth():int
		{
			return this._rawContentWidth;
		}
		
		public function set rawContentWidth(value:int):void
		{
			this._rawContentWidth = value;
		}
		
		public function get rawContentHeight():int
		{
			return this._rawContentHeight;
		}
		
		public function set rawContentHeight(value:int):void
		{
			this._rawContentHeight = value;
		}
		
		/**
		* Sets the effectiveWidth on this element, dispatching an event in the event that the value has changed.
		* @see org.stylekit.ui.element.UIElement._effectiveWidth
		*/
		public function set effectiveWidth(e:int):void
		{
			var dispatch:Boolean = (e != this._effectiveWidth);
			this._effectiveWidth = e;
			
			if(dispatch) this.onEffectiveDimensionsModified();
		}
		
		public function get effectiveHeight():int
		{
			return this._effectiveHeight;
		}
		
		/**
		* Sets the effectiveHeight on this element, dispatching an event in the event that the value has changed.
		* @see org.stylekit.ui.element.UIElement._effectiveHeight
		*/
		public function set effectiveHeight(e:int):void
		{
			var dispatch:Boolean = (e != this._effectiveHeight);
			this._effectiveHeight = e;
			
			if(dispatch) this.onEffectiveDimensionsModified();
		}
		
		/**
		 * The <code>FlowControlLine</code>s used to layout the contents of the <code>UIElement</code>.
		 * 
		 * Should not be used to access the contents of the <code>UIElement</code> as the <code>Vector</code>
		 * could be empty (even with children present) or change completely on the next paint operation as the line
		 * content will change if the <code>UIElement</code> has its dimensions modified.
		 */
		public function get controlLines():Vector.<FlowControlLine>
		{
			return this._controlLines;
		}
		
		/**
		* Sets both the effectiveWidth and the effectiveHeight in one call, dispatching only a single event in the event that either has changed.
		* @see org.stylekit.ui.element.UIElement._effectiveWidth
		* @see org.stylekit.ui.element.UIElement._effectiveHeight
		*/
		public function setEffectiveDimensions(w:int, h:int):void
		{
			var dispatch:Boolean = (w != this._effectiveWidth || h != this._effectiveHeight);
			this._effectiveWidth = w;
			this._effectiveHeight = h;
			
			if(dispatch) this.onEffectiveDimensionsModified();
		}
		
		public function get contentWidth():int
		{
			return this._contentWidth;
		}
		
		/**
		* Sets the calculated effective extend of this element's children as they are currently laid out.
		* If the new value differs from the old, then the need to redraw or add/remove scrollbars will be
		* examined.
		* @see org.stylekit.ui.element.UIElement._contentWidth
		*/
		public function set contentWidth(w:int):void
		{
			var dispatch:Boolean = (w != this._contentWidth);
			this._contentWidth = w;
			
			if(dispatch) this.onContentDimensionsModified();
		}
		
		public function get contentHeight():int
		{
			return this._contentHeight;
		}
		
		/**
		* Sets the calculated effective extend of this element's children as they are currently laid out.
		* If the new value differs from the old, then the need to redraw or add/remove scrollbars will be
		* examined.
		* @see org.stylekit.ui.element.UIElement._contentHeight
		*/
		public function set contentHeight(h:int):void
		{
			var dispatch:Boolean = (h != this._contentHeight);
			this._contentHeight = h;
			
			if(dispatch) this.onContentDimensionsModified();
		}
		
		/**
		* Set both the contentWidth and contentHeight in one step, dispatching only one event if either
		* value has changed.
		*/
		public function setContentDimensions(w:int, h:int):void
		{
			var dispatch:Boolean = (w != this._contentWidth || h != this._contentHeight);
			this._contentWidth = w;
			this._contentHeight = h;
			
			if(dispatch) this.onContentDimensionsModified();
		}
		
		public function get effectiveContentWidth():int
		{
			return this._effectiveContentWidth;
		}
		
		/**
		* Set the width of the content area for this element, triggering an internal dispatch if the value is modified.
		* @see org.stylekit.ui.element.UIElement._effectiveContentWidth
		*/
		public function set effectiveContentWidth(w:int):void
		{
			var dispatch:Boolean = (w != this._effectiveContentWidth);
			this._effectiveContentWidth = w;
			
			if(dispatch) this.onEffectiveContentDimensionsModified();
		}
		
		public function get effectiveContentHeight():int
		{
			return this._effectiveContentHeight;
		}
		
		/**
		* Set the height of the content area for this element, triggering an internal dispatch if the value is modified.
		* @see org.stylekit.ui.element.UIElement._effectiveContentHeight
		*/
		public function set effectiveContentHeight(h:int):void
		{
			var dispatch:Boolean = (h != this._effectiveContentHeight);
			this._effectiveContentHeight = h;
			
			if(dispatch) this.onEffectiveContentDimensionsModified();
		}
		
		/**
		* Set the width of the content area for this element, triggering an internal dispatch if the value is modified.
		* @see org.stylekit.ui.element.UIElement._effectiveContentWidth
		*/
		public function setEffectiveContentDimensions(w:int, h:int):void
		{
			var dispatch:Boolean = (w != this._effectiveContentWidth || h != this._effectiveContentHeight);
			this._effectiveContentWidth = w;
			this._effectiveContentHeight = h;
			
			if(dispatch) this.onEffectiveContentDimensionsModified();
		}
		
		public function get children():Vector.<UIElement>
		{
			return this._children;
		}
		
		public override function get numChildren():int
		{
			return this._children.length;
		}
		
		public function get firstChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[0];
			}
			
			return null;
		}
		
		public function get lastChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[this._children.length - 1];
			}
			
			return null;
		}
		
		public function get styleParent():UIElement
		{
			if(this.parentElement == null)
			{
				return null;
			}
			
			if (this.parentElement.styleEligible)
			{
				return this.parentElement;
			}
			
			return this.parentElement.styleParent;
		}
		
		public function get elementName():String
		{
			return this._elementName;
		}
		
		public function set elementName(elementName:String):void
		{
			var prev:String = this._elementName;
			this._elementName = elementName;
			
			if(this.parentElement != null)
			{
				this.parentElement.descendantNameModified(elementName, prev, this);
			}
		}
		
		public function get elementId():String
		{
			return this._elementId;
		}
		
		public function set elementId(s:String):void
		{
			var prev:String = this._elementId;
			this._elementId = s;
			if(this.parentElement != null)
			{
				this.parentElement.descendantIdModified(s, prev, this);
			}
		}
		
		public function get isFirstChild():Boolean
		{
			return (this.parentIndex == 0);
		}
		
		public function get isLastChild():Boolean
		{
			return (this.parentIndex == this.parent.numChildren);
		}
		
		public function get parentIndex():uint
		{
			return this._parentIndex;
		}
		
		public function get evaluatedStyles():Object
		{
			return this._evaluatedStyles;
		}
		
		/**
		* Sets a new object instance as the evaluated style hash for this object. Performs a comparison
		* of the new object to the old and dispatches an EVALUATED_STYLES_MODIFIED UIElementEvent if there has been a change.
		*/		
		public function set evaluatedStyles(newEvaluatedStyles:Object):void
		{
			// Store old value locally and set new value
			var previousEvaluatedStyles:Object = this.evaluatedStyles;
			this._evaluatedStyles = ObjectUtil.merge(PropertyContainer.defaultStyles, newEvaluatedStyles);
			
			// Perform comparison
			// A change is counted if:
			// 1. The new styles contain a value not present on the old styles
			// 2. The new styles are missing a value that is present on the old styles
			// 3. Values present on both objects for the same key are not equivalent
			
			var changeFound:Boolean = false;
			var alteredKeys:Vector.<String> = new Vector.<String>();
			
			
			// Find new and modified keys
			for(var newKey:String in newEvaluatedStyles)
			{
				if((previousEvaluatedStyles[newKey] == null && newEvaluatedStyles[newKey] != null) || (newEvaluatedStyles[newKey] != null && !newEvaluatedStyles[newKey].isEquivalent(previousEvaluatedStyles[newKey])))
				{
					StyleKit.logger.debug("Found new or modified style prop for "+newKey+" ("+previousEvaluatedStyles[newKey]+" > "+newEvaluatedStyles[newKey]+")", this)
					changeFound = true;
					alteredKeys.push(newKey);
				}
			}
			// Find missing keys
			for(var prevKey:String in previousEvaluatedStyles)
			{
				if(newEvaluatedStyles[prevKey] == null && previousEvaluatedStyles[prevKey] != null)
				{
					StyleKit.logger.debug("Found deleted style prop for "+prevKey+" ("+previousEvaluatedStyles[prevKey]+" > "+newEvaluatedStyles[prevKey]+")", this)
					changeFound = true;
					alteredKeys.push(prevKey);
				}
			}

			// check which altered keys require transitions:
			// if the key requires a transition then the original value is restored and a transition
			// worker is created to action the change.
			// you might think that it's a bit odd to do this retroactively once the evaluatedStyles hash 
			// has been saved against the element - however, it allows any new styles to set transition
			// properties before the changed attributes are modified.
			for(var i:int = alteredKeys.length-1; i >= 0; i--)
			{
				var k:String = alteredKeys[i];
				if(this.shouldTransitionProperty(k))
				{
					// restore original value
					var endValue:Value = this._evaluatedStyles[k];
					this._evaluatedStyles[k] = previousEvaluatedStyles[k]
					// start transition
					this.beginPropertyTransition(k, this._evaluatedStyles[k], endValue);
					// remove from alteredKeys
					alteredKeys.splice(i, 1);
				}
			}
			
			// Dispatch and perform local actions
			if(changeFound)
			{
				this.onStylePropertyValuesChanged(alteredKeys);
				this.dispatchEvent(new UIElementEvent(UIElementEvent.EVALUATED_STYLES_MODIFIED, this));
			}
			this._runTransitions = true;
		}
		
		public function overwriteEvaluatedStyle(propertyName:String, value:Value):void
		{
			this.evaluatedStyles[propertyName] = value;
			var v:Vector.<String> = new Vector.<String>();
				v.push(propertyName);
			this.onStylePropertyValuesChanged(v);
		}
		
		/**
		* Called when new evaluted styles are set. A vector of altered value keys
		* (e.g. ["border-left-width", "float"]) is handed to this method, which then splits the keys out by whitelist
		* and reacts appropriately.
		*/
		protected function onStylePropertyValuesChanged(alteredKeys:Vector.<String>):void
		{
			if(this._baseUI == null || !this.baseUI.styleAllocationInProgress)
			{
				// If there's no BaseUI attached, or if there's no transaction in progress, push through immediately
				this.execCallbacksForModifiedStyleKeys(alteredKeys);
			}
			else
			{
				// Otherwise, log the keys on the deferred keys stack.
				if(this._deferredModifiedStyleKeys == null)
				{
					this._deferredModifiedStyleKeys = alteredKeys;
				}
				else
				{
					this._deferredModifiedStyleKeys = this._deferredModifiedStyleKeys.concat(alteredKeys);
				}
				
				// Register with the BaseUI to be notified when the style allocation is complete
				this._baseUI.registerElementWithDeferredStyleModifications(this);
			}
		}
		
		/** 
		* Actually executes the callbacks (recalculations, redraws, layout requests, whatever)
		*/
		protected function execCallbacksForModifiedStyleKeys(alteredKeys:Vector.<String>):void
		{
			var effectiveContentDimensionsRecalcKeys:Array = [];
			var effectiveDimensionsRecalcKeys:Array = [];
			var parentLayoutKeys:Array = [];
			var redrawKeys:Array = [];
			var setOpacity:Boolean = false;

			
			for(var i:uint=0; i < alteredKeys.length; i++)
			{
				var k:String = alteredKeys[i];
				if(UIElement.EFFECTIVE_CONTENT_DIMENSION_CSS_PROPERTIES.indexOf(k) > -1)
				{
					effectiveContentDimensionsRecalcKeys.push(k);
				}
				else if(UIElement.LAYOUT_CSS_PROPERTIES.indexOf(k) > -1)
				{
					parentLayoutKeys.push(k);
				}
				else if(UIElement.EFFECTIVE_DIMENSION_CSS_PROPERTIES.indexOf(k) > -1)
				{
					effectiveDimensionsRecalcKeys.push(k);
				}
				else if(UIElement.REDRAW_CSS_PROPERTIES.indexOf(k) > -1)
				{
					redrawKeys.push(k);
				}
				else if(k == "opacity")
				{
					setOpacity = true;
				}
			}
			
			// Handle easy properties

			if(setOpacity)
			{
				this.alpha = (this.getStyleValue("opacity") as NumericValue).value
			}
			if(effectiveContentDimensionsRecalcKeys.length > 0) 
			{
				StyleKit.logger.debug("A property was modified that requires the effectiveContentDimensions to be recalced. ("+effectiveContentDimensionsRecalcKeys.join(", ")+")", this);
				this.recalculateEffectiveContentDimensions();
			}
			if(parentLayoutKeys.length > 0 && (this.parentElement != null)) 
			{
				StyleKit.logger.debug("A layout property was modified ("+parentLayoutKeys.join(", ")+") calling to the parent's layoutChildren method", this);
				this.parentElement.layoutChildren();
			}
			if(effectiveDimensionsRecalcKeys.length > 0)
			{
				StyleKit.logger.debug("A property was modified that requires the effectiveContentDimensions to be recalced. ("+effectiveDimensionsRecalcKeys.join(", ")+")", this);
				this.recalculateEffectiveDimensions();
			}
			if(redrawKeys.length > 0)
			{
				StyleKit.logger.debug("A property was modified that requires a redraw. ("+redrawKeys.join(", ")+")", this);
				this.redraw();
			}
			
			// TODO react to changes in animation and transition (change to transition-property, animation)
		}
		
		/** 
		* Executes any pending deferred style modification callbacks that were logged by #onStylePropertyValuesChanged
		* while the BaseUI was in a style allocation transaction state.
		*/
		public function execCallbacksForDeferredStyleKeyModifications():void
		{
			if(this._deferredModifiedStyleKeys != null)
			{
				this.execCallbacksForModifiedStyleKeys(_deferredModifiedStyleKeys);
				this._deferredModifiedStyleKeys = null;
			}
		}
		
		/**
		* Recalculates the effective extent dimensions for this element.
		*/
		protected function recalculateEffectiveDimensions():void
		{
			var w:int = 0;
			var h:int = 0;
			
			// TODO
			// margins + borders + padding + effective content dimensions + scrollbars
			
			// margin
			var marginTop:SizeValue = (this.getStyleValue("margin-top") as SizeValue);
			var marginBottom:SizeValue = (this.getStyleValue("margin-bottom") as SizeValue);
			var marginLeft:SizeValue = (this.getStyleValue("margin-left") as SizeValue);
			var marginRight:SizeValue = (this.getStyleValue("margin-right") as SizeValue);
			
			var mTop:int = (marginTop != null ? marginTop.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var mBottom:int = (marginBottom != null ? marginBottom.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var mLeft:int = (marginLeft != null ? marginLeft.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			var mRight:int = (marginRight != null ? marginRight.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			
			// borders
			var borderTop:SizeValue = (this.getStyleValue("border-top-width") as SizeValue);
			var borderBottom:SizeValue = (this.getStyleValue("border-bottom-width") as SizeValue);
			var borderLeft:SizeValue = (this.getStyleValue("border-left-width") as SizeValue);
			var borderRight:SizeValue = (this.getStyleValue("border-right-width") as SizeValue);
			
			var borderTopStyle:LineStyleValue = (this.getStyleValue("border-top-style") as LineStyleValue);
			var borderBottomStyle:LineStyleValue = (this.getStyleValue("border-bottom-style") as LineStyleValue);
			var borderLeftStyle:LineStyleValue = (this.getStyleValue("border-left-style") as LineStyleValue);
			var borderRightStyle:LineStyleValue = (this.getStyleValue("border-right-style") as LineStyleValue);
			
			var bTop:int = (borderTop != null && borderTopStyle != null && borderTopStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderTop.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var bBottom:int = (borderBottom != null && borderBottomStyle != null && borderBottomStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderBottom.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var bLeft:int = (borderLeft != null && borderLeftStyle != null && borderLeftStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderLeft.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			var bRight:int = (borderRight != null && borderRightStyle != null && borderRightStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderRight.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			
			// padding
			var paddingTop:SizeValue = (this.getStyleValue("padding-top") as SizeValue);
			var paddingBottom:SizeValue = (this.getStyleValue("padding-bottom") as SizeValue);
			var paddingLeft:SizeValue = (this.getStyleValue("padding-left") as SizeValue);
			var paddingRight:SizeValue = (this.getStyleValue("padding-right") as SizeValue);
			
			var pTop:int = (paddingTop != null ? paddingTop.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var pBottom:int = (paddingBottom != null ? paddingBottom.evaluateSize(this, SizeValue.DIMENSION_HEIGHT) : 0);
			var pLeft:int = (paddingLeft != null ? paddingLeft.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			var pRight:int = (paddingRight != null ? paddingRight.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			
			// scrollbars
			
			w = this.effectiveContentWidth + (pLeft + pRight) + (bLeft + bRight) + (mLeft + mRight);
			h = this.effectiveContentHeight + (pTop + pBottom) + (bTop + bBottom) + (mTop + mBottom);
			
			this.setEffectiveDimensions(w, h);
		}
		
		/**
		* Called when the effective dimensions on this element are modified, by a new value being set in either direction
		* or in both directions with setEffectiveDimensions.
		*/ 
		protected function onEffectiveDimensionsModified():void
		{
			this.redraw();
			StyleKit.logger.debug("effective dimensions modified: "+this.effectiveWidth+","+this.effectiveHeight, this);
			this.dispatchEvent(new UIElementEvent(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this));
		}
		
		/**
		* Recalculates the effective extent of this element's children. Called after a layout operation and ONLY valid after a layout operation.
		*/
		protected function recalculateContentDimensions():void
		{
			var w:int = this._rawContentWidth;
			var h:int = this._rawContentHeight;
			
			/* TODO
				Width:
					Search children to find greatest _x + effectiveWidth
				Height:
					Search children to find greatest _y + effectiveHeight
			*/
			
			if(this.controlLines != null)
			{
				for (var i:int = 0; i < this.controlLines.length; i++)
				{
					var line:FlowControlLine = this.controlLines[i];
				
					if (line.width > w)
					{
						w = line.width;
					}
				
					h += line.height;
				}
			}
			
			/*for (var i:int = 0; i < this.children.length; i++)
			{
				var child:UIElement = this.children[i];
				
				if ((child.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_LEFT || (child.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_RIGHT)
				{
					continue;
				}
				
				if ((child.x + child.effectiveWidth) > w)
				{
					w = child.x + child.effectiveWidth;
				}
				
				if ((child.y + child.effectiveHeight) > h)
				{
					h = child.y + child.effectiveHeight;
				}
			}*/
			
			this.setContentDimensions(w, h);
		}

		/**
		 * Calculates the flex size for the specified child (the child should exist on the UIElement).
		 * 
		 * The flex size is calculated by adding up the children that exist without any flexibility, the number of flex's
		 * across all the children is added up and the free space is split up between the flexable children.
		 */
		protected function calculateBoxFlexSize(child:UIElement):Number
		{
			var flexibles:Vector.<Object> = new Vector.<Object>();
			var usedSpace:Number = 0;

			// calculate how much space we have used on the non-flexi elements
			for (var i:int = 0; i < this.children.length; i++)
			{
				var uiElement:UIElement = this.children[i];
				var numericValue:IntegerValue = (uiElement.getStyleValue("box-flex") as IntegerValue);
				
				if ((uiElement.getStyleValue("display") as DisplayValue).display != DisplayValue.DISPLAY_NONE)
				{
					if (uiElement.hasStyleProperty("box-flex") && numericValue.value > 0)
					{
						flexibles.push({ flex: numericValue.value, element: uiElement  });
					}
					else
					{
						usedSpace += uiElement.effectiveWidth;
					}
				}
			}
			
			var availableSpace:Number = this.effectiveContentWidth - usedSpace;
			var flexCounts:int = 0;
			
			// counts the number of flex's on all the found children, if a uielement has a flex value of 2, this counts as 
			// 2 flexes, this allows us to split up the un-used space between the number of flexes. 
			for (var j:int = 0; j < flexibles.length; j++)
			{
				var flex:Object = flexibles[j];
				
				var numeric:Number = flex.flex;
				var element:UIElement = flex.element;
				
				flexCounts += numeric;
			}
			
			var flexCost:Number = availableSpace / flexCounts;
			
			// find the flexible element that we want, then take the cost of 1 flex and find the cost
			// the element requires
			for (var k:int = 0; k < flexibles.length; k++)
			{
				var flux:Object = flexibles[k];
				
				var fluxCost:Number = flexCost * flux.flex;
				
				if ((flux.element as UIElement) == child)
				{
					return fluxCost;
				}
			}
			
			return 0;
		}
		
		/**
		* Called when the content of this element changes dimensions, by a new value being set in either direction
		* or in both directions with setContentDimensions.
		*/
		protected function onContentDimensionsModified():void
		{
			// TODO update scrollbars
			StyleKit.logger.debug("content dimensions modified: "+this.contentWidth+","+this.contentHeight, this);
			this.recalculateEffectiveContentDimensions();
		}
		
		/**
		* Recalculates the size of the content area for this element.
		*/
		public function recalculateEffectiveContentDimensions():void
		{
			var w:int = 0;
			var h:int = 0;
			
			var borderLeft:SizeValue = (this.getStyleValue("border-left-width") as SizeValue);
			var borderRight:SizeValue = (this.getStyleValue("border-right-width") as SizeValue);
			
			var borderLeftStyle:LineStyleValue = (this.getStyleValue("border-left-style") as LineStyleValue);
			var borderRightStyle:LineStyleValue = (this.getStyleValue("border-right-style") as LineStyleValue);
			
			var bLeft:int = (borderLeft != null && borderLeftStyle != null && borderLeftStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderLeft.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			var bRight:int = (borderRight != null && borderRightStyle != null && borderRightStyle.lineStyle != LineStyleValue.LINE_STYLE_NONE ? borderRight.evaluateSize(this, SizeValue.DIMENSION_WIDTH) : 0);
			
			// the flex cost is the amount 
			
			var extraEffectiveWidth:Number = 0;
			
			extraEffectiveWidth += (bLeft + bRight);
			extraEffectiveWidth += (this.evalStyleSize("margin-left", SizeValue.DIMENSION_WIDTH) + this.evalStyleSize("margin-right", SizeValue.DIMENSION_WIDTH));
			extraEffectiveWidth += (this.evalStyleSize("padding-left", SizeValue.DIMENSION_WIDTH) + this.evalStyleSize("padding-right", SizeValue.DIMENSION_WIDTH));
			
			/* TODO
				After:
					Width:
				 		subtract vertical scrollbar if vertical scrollbar required
					Height:
						subtract horizontal scrollbar if horizontal scrollbar required
			*/

			// Width
			if (this.hasStyleProperty("box-flex") && (this.getStyleValue("box-flex") as IntegerValue).value > 0)
			{				
				var flexCost:Number = this.parentElement.calculateBoxFlexSize(this);

				// flexxxxxo
				w = flexCost - extraEffectiveWidth;
			}
			else if (this.hasStyleProperty("width") && (this.getStyleValue("width") as SizeValue).auto)
			{
				if (this.hasStyleProperty("float") && ((this.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_LEFT || (this.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_RIGHT))
				{
					w = this.contentWidth;
				}
				else if (this.parentElement != null)
				{
					w = this.parentElement.contentWidth - extraEffectiveWidth;
				}
			}
			else if(this.hasStyleProperty("width") && !isNaN((this.getStyleValue("width") as SizeValue).value)) 
			{				
				w = this.evalStyleSize("width", SizeValue.DIMENSION_WIDTH);
			}
			else if((this.getStyleValue("display") as DisplayValue).display == DisplayValue.DISPLAY_BLOCK) // todo also trigger if float is set
			{
				w = this.parentElement.effectiveContentWidth;
			}
			else
			{
				w = this.contentWidth;
			}
			
			// Apply width constraints
			if(this.hasStyleProperty("min-width")) w = Math.max(w, this.evalStyleSize("min-width", SizeValue.DIMENSION_WIDTH));
			if(this.hasStyleProperty("max-width")) w = Math.min(w, this.evalStyleSize("max-width", SizeValue.DIMENSION_WIDTH));
			
			// Height
			if(this.hasStyleProperty("height") && !isNaN((this.getStyleValue("height") as SizeValue).value))
			{
				h = this.evalStyleSize("height", SizeValue.DIMENSION_HEIGHT);
			}
			else
			{
				h = this.contentHeight;
			}
			// Apply height constraints
			if(this.hasStyleProperty("min-height")) h = Math.max(h, this.evalStyleSize("min-height", SizeValue.DIMENSION_HEIGHT));
			if(this.hasStyleProperty("max-height")) h = Math.min(h, this.evalStyleSize("max-height", SizeValue.DIMENSION_HEIGHT));	
			
			this.setEffectiveContentDimensions(w, h);
		}
		
		/**
		* Called when the content area of this element changes dimensions, by a new value being set in either direction
		* or in both directions with setEffectiveContentDimensions.
		*/
		protected function onEffectiveContentDimensionsModified():void
		{
			this._controlLines = null;
			StyleKit.logger.debug("effective content dimensions modified: "+this.effectiveContentWidth+","+this.effectiveContentHeight, this);
			
			for(var i:uint=0; i < this._children.length; i++)
			{
				this._children[i].recalculateEffectiveContentDimensions();
			}
			//this.layoutChildren(); // warning: potential INFINITE LOOP OF DEATH
			this.recalculateEffectiveDimensions();
		}
		
		/**
		* Evaluates a SizeValue within the scope of this element, and returns 0 by default.
		*/
		public function evalSize(s:SizeValue, dimension:String = null):Number
		{
			if(s == null)
			{
				return 0;
			}
			else
			{
				return s.evaluateSize(this, dimension);
			}
		}
		
		/**
		* Evaluates a size for a given CSS property key.
		*/
		public function evalStyleSize(key:String, dimension:String = null):Number
		{
			return this.evalSize((this.getStyleValue(key) as SizeValue), dimension);
		}
		
		public function hasElementClassName(className:String):Boolean
		{
			return (this._elementClassNames.indexOf(className) > -1);
		}
		
		public function addElementClassName(className:String):Boolean
		{
			if (this.hasElementClassName(className))
			{
				return false;
			}
			
			this._elementClassNames.push(className);
			
			if(this.parentElement != null)
			{
				this.parentElement.registerDescendantClassName(className, this);
			}
			else if (this is BaseUI)
			{
				this.registerDescendantClassName(className, this);
			}
			
			return true;
		}
		
		public function removeElementClassName(className:String):Boolean
		{
			if (this.hasElementClassName(className))
			{
				this._elementClassNames.splice(this._elementClassNames.indexOf(className), 1);
				
				if(this.parentElement != null)
				{
					this.parentElement.unregisterDescendantClassName(className, this);
				}
				else if (this is BaseUI)
				{
					this.unregisterDescendantClassName(className, this);
				}
				
				return true;
			}
			
			return false;
		}
		
		public function hasElementPseudoClass(pseudoClass:String):Boolean
		{
			return (this._elementPseudoClasses.indexOf(pseudoClass) > -1);
		}
		
		public function addElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				return false;
			}
			
			this._elementPseudoClasses.push(pseudoClass);

			if(this.parentElement != null)
			{
				this.parentElement.registerDescendantPseudoClass(pseudoClass, this);
			}
			
			return true;
		}
		
		public function removeElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				this._elementPseudoClasses.splice(this._elementClassNames.indexOf(pseudoClass), 1);
				
				if(this.parentElement != null)
				{
					this.parentElement.unregisterDescendantPseudoClass(pseudoClass, this);
				}
				
				return true;
			}
			
			return false;
		}
		
		protected function refreshControlLines():void
		{
			this._controlLines = new Vector.<FlowControlLine>();
			this._controlLinesUnsorted = null;
			
			var textAlign:TextAlignValue = (this.getStyleValue("text-align") as TextAlignValue);

			// create a new line
			this.newControlLine(textAlign);
			
			for (var i:int = 0; i < this.children.length; i++)
			{
				var child:UIElement = this.children[i];
				
				if (!this.currentControlLine.appendElement(child))
				{
					this.newControlLine(textAlign);
					
					if (!this.currentControlLine.appendElement(child))
					{
						// this element won't fit on a new line so something is wrong
						throw new StackOverflowError("Found a FlowControlLine that isnt able to accept our UIElement after exhausting the stack of lines");
					}
				}
			}
			
			this._controlLinesUnsorted = this._controlLines.concat();
			
			this._controlLines.sort(function(line1:FlowControlLine, line2:FlowControlLine):int
			{
				if (line1.highestZIndex < line2.highestZIndex)
				{
					return -1;
				}
				else if (line1.highestZIndex > line2.highestZIndex)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			});
			
			//this._controlLines.reverse();

			StyleKit.logger.debug("Added "+this._controlLines.length+" control lines");
		}
		
		protected function newControlLine(textAlign:TextAlignValue):void
		{
			this._controlLines.push(
				     new FlowControlLine(this.effectiveContentWidth, (textAlign.leftAlign ? "left" : (textAlign.rightAlign ? "right" : (textAlign.centerAlign ? "center" : "left"))))
			  );
		}
		
		protected function get currentControlLine():FlowControlLine
		{
			return this._controlLines[this._controlLines.length - 1];
		}
		
		public function calculateOutsideBorderOriginPoint():Point
		{
			var point:Point = new Point(0,0);
			
			point.x = this.evalStyleSize("margin-left", SizeValue.DIMENSION_WIDTH);
			point.y = this.evalStyleSize("margin-top", SizeValue.DIMENSION_HEIGHT);
			
			return point;			
		}
		
		public function calculateInsideBorderOriginPoint():Point
		{
			var point:Point = this.calculateOutsideBorderOriginPoint();
			
			if ((this.getStyleValue("border-left-style") as LineStyleValue).lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				point.x += this.evalStyleSize("border-left-width", SizeValue.DIMENSION_WIDTH);
			}
			
			if ((this.getStyleValue("border-top-style") as LineStyleValue).lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				point.y += this.evalStyleSize("border-top-width", SizeValue.DIMENSION_HEIGHT);
			}
			
			return point;
		}
		
		public function calculateContentOriginPoint():Point
		{
			var point:Point = this.calculateInsideBorderOriginPoint();

			point.x += this.evalStyleSize("padding-left", SizeValue.DIMENSION_WIDTH);
			point.y += this.evalStyleSize("padding-top", SizeValue.DIMENSION_HEIGHT);
			
			return point;
		}
		
		public function calculateContentExtentPoint():Point
		{
			var point:Point = this.calculateContentOriginPoint();
			
			point.x += this.effectiveContentWidth;
			point.y += this.effectiveContentHeight;
			
			return point;
		}
		
		/**
		* Returns the extent point (bottom right) for absolutely-positioned contents in this element. Excludes padding.
		*/
		public function calculateInsideBorderExtentPoint():Point
		{
			var point:Point = this.calculateContentExtentPoint();
			
			point.x += this.evalStyleSize("padding-right", SizeValue.DIMENSION_WIDTH);
			point.y += this.evalStyleSize("padding-bottom", SizeValue.DIMENSION_HEIGHT);
			
			return point;
		}
		
		public function layoutChildren():void
		{
			if (!this._decoratingChildren)
			{
				this.decorateChildren();
				
				if (this._requiresAnotherDecorate)
				{
					this._requiresAnotherDecorate = false;
					
					this.decorateChildren();
				}
			}
			else
			{
				this._requiresAnotherDecorate = true;
			}
		}
		
		protected function decorateChildren():void
		{
			this._decoratingChildren = true;
			
			for (var k:int = 0; k < super.numChildren; k++)
			{
				super.removeChildAt(k);
			}
			
			if (this._contentContainer != null && this._contentContainer.parent != null)
			{
				this.removeChild(this._contentContainer);
			}
			
			this._contentContainer = new Sprite();
			
			// calculate the effective dimensions of this object so we can layout the children correctly
			//this.recalculateEffectiveDimensions();
			
			this.refreshControlLines();
			
			this._contentContainer.x = this.calculateContentOriginPoint().x;
			this._contentContainer.y = this.calculateContentOriginPoint().y;
			
			super.addChild(this._contentContainer);
			
			if (this.controlLines != null && this.controlLines.length > 0)
			{				
				// only we do now is stack the FlowControlLines onto the UIElements content space
				// the FlowControlLines take care of laying out the indiviual UIElement children.
				
				// as were only dealing with lines all we need to do is stack the lines one by one
				// with each line taking up the entire width, so we only need to think about stacking
				// the lines with there height.
				var y:Number = 0;
				
				for (var l:int = 0; l < this._controlLinesUnsorted.length; l++)
				{
					var flow:FlowControlLine = this._controlLinesUnsorted[l];
					
					if(flow.occupiedByAbsoluteElement)
					{
						flow.y = 0;
					}
					else
					{
						flow.y = y;
						y += flow.lineHeight;
					}
				}
				
				for (var i:int = 0; i < this.controlLines.length; i++)
				{
					var line:FlowControlLine = this.controlLines[i];
					
					this._contentContainer.addChild(line);
					line.layoutElements();
					
				}
			}

			if (this._contentSprites != null)
			{
				for (var j:int = 0; j < this._contentSprites.length; j++)
				{
					this._contentContainer.addChild(this._contentSprites[j]);
				}
			}
			
			this.recalculateContentDimensions();

			this._decoratingChildren = false;
		}
		
		public function get flexible():Boolean
		{
			var flexValue:IntegerValue = this.getStyleValue("box-flex") as IntegerValue;
			var widthValue:SizeValue = this.getStyleValue("width") as SizeValue;
			
			if (flexValue.value >= 1)
			{
				return true;
			}
			
			if (widthValue.auto || (widthValue.units == SizeValue.UNIT_PERCENTAGE))
			{
				return true;
			}
			
			return false;
		}
		
		public function redraw():void
		{
			if (this.parentElement == null && this != this.baseUI)
			{
				this._redrawDeferredUntilHasParent = true;
			}
			else
			{
				this._painter.paint();
			}
		}
		
		protected function updateParentIndex(index:uint):void
		{
			this._parentIndex = index;
		}
		
		protected function updateChildrenIndex():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				this.children[i].updateParentIndex(i);
			}
		}
		
		public function addElement(child:UIElement):UIElement
		{
			return this.addElementAt(child, this._children.length);
		}
		
		public function addElementAt(child:UIElement, index:int):UIElement
		{
			if (child.baseUI != null && child.baseUI != this.baseUI)
			{
				throw new IllegalOperationError("Child belongs to a different BaseUI, cannot add to this UIElement");
			}
			
			if (index < this._children.length)
			{
				this._children.splice(index, 0, child);
			}
			else
			{
				this._children.push(child);
			}
			
			child.parentElement = this;
			child._baseUI = this.baseUI;
			
			child.addEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			child.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			child.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			
			this.updateChildrenIndex();
			this.layoutChildren();
			
			return child;
		}
		
		public function removeElement(child:UIElement):UIElement
		{
			var index:int = this._children.indexOf(child);
			
			return this.removeElementAt(index);
		}
		
		public function removeElementAt(index:int):UIElement
		{
			if (index == -1)
			{
				throw new IllegalOperationError("Child does not exist within the UIElement");
			}
			
			var child:UIElement = this._children[index];
			
			child.removeEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			child.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			child.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			
			child._parentElement = null;
			child._baseUI = null;
			
			this._children.splice(index, 1);
			
			this.updateChildrenIndex();
			this.layoutChildren();
			
			return child;
		}
		
		public function hasStyleProperty(propertyName:String):Boolean
		{
			if (this.getStyleValue(propertyName) != null)
			{
				return true;
			}
			
			return false;
		}
		
		public function getStyleValue(propertyName:String):Value
		{
			var value:Value = null;
			
			// TODO compile compound values
			switch (propertyName)
			{
				case "border":
					var border:EdgeCompoundValue = new EdgeCompoundValue();
					
					border.leftValue = this.getStyleValue("border-left");
					border.rightValue = this.getStyleValue("border-right");
					border.topValue = this.getStyleValue("border-top");
					border.bottomValue = this.getStyleValue("border-bottom");
					
					value = border;
					break;
				case "border-left":
					var borderLeft:BorderCompoundValue = new BorderCompoundValue();
					
					borderLeft.colorValue = this.getStyleValue("border-left-color") as ColorValue;
					borderLeft.lineStyleValue = this.getStyleValue("border-left-style") as LineStyleValue;
					borderLeft.sizeValue = this.getStyleValue("border-left-width") as SizeValue;
					
					if (borderLeft.lineStyleValue == null)
					{
						borderLeft = null;
					}
					
					value = borderLeft;
					break;
				case "border-right":
					var borderRight:BorderCompoundValue = new BorderCompoundValue();
					
					borderRight.colorValue = this.getStyleValue("border-right-color") as ColorValue;
					borderRight.lineStyleValue = this.getStyleValue("border-right-style") as LineStyleValue;
					borderRight.sizeValue = this.getStyleValue("border-right-width") as SizeValue;
					
					if (borderRight.lineStyleValue == null)
					{
						borderRight = null;
					}
					
					value = borderRight;
					break;
				case "border-bottom":
					var borderBottom:BorderCompoundValue = new BorderCompoundValue();
					
					borderBottom.colorValue = this.getStyleValue("border-bottom-color") as ColorValue;
					borderBottom.lineStyleValue = this.getStyleValue("border-bottom-style") as LineStyleValue;
					borderBottom.sizeValue = this.getStyleValue("border-bottom-width") as SizeValue;
					
					if (borderBottom.lineStyleValue == null)
					{
						borderBottom = null;
					}
					
					value = borderBottom;
					break;
				case "border-top":
					var borderTop:BorderCompoundValue = new BorderCompoundValue();
					
					borderTop.colorValue = this.getStyleValue("border-top-color") as ColorValue;
					borderTop.lineStyleValue = this.getStyleValue("border-top-style") as LineStyleValue;
					borderTop.sizeValue = this.getStyleValue("border-top-width") as SizeValue;
					
					if (borderTop.lineStyleValue == null)
					{
						borderTop = null;
					}
					
					value = borderTop;
					break;
				case "border-radius":
					var radius:CornerCompoundValue = new CornerCompoundValue();
					
					radius.topRightValue = this.getStyleValue("border-top-right-radius") as SizeValue;
					radius.bottomRightValue = this.getStyleValue("border-bottom-right-radius") as SizeValue;
					radius.bottomLeftValue = this.getStyleValue("border-bottom-left-radius") as SizeValue;
					radius.topLeftValue = this.getStyleValue("border-top-left-radius") as SizeValue;
					
					value = radius;
					break;
				case "animation":
					var anim:AmimationCompoundValue = new AnimationCompoundValue();
					
					anim.animationNameValue = this.getStyleValue("animation-name") as ValueArray;
					anim.animationDurationValue = this.getStyleValue("animation-duration") as ValueArray;
					anim.animationTimingFunctionValue = this.getStyleValue("animation-timing-function") as ValueArray;
					anim.animationDelayValue = this.getStyleValue("animation-delay") as ValueArray;
					anim.animationIterationCountValue = this.getStyleValue("animation-iteration-count") as ValueArray;
					anim.animationDirectionValue = this.getStyleValue("animation-direction") as ValueArray;
				
					value = anim;
					break;
				case "transition":
					var tran:TransitionCompoundValue = new TransitionCompoundValue();
					
					tran.transitionPropertyValue = this.getStyleValue("transition-property") as PropertyListValue;
					tran.transitionDurationValue = this.getStyleValue("transition-duration") as ValueArray;
					tran.transitionTimingFunctionValue = this.getStyleValue("transition-timing-function") as ValueArray;
					tran.transitionDelayValue = this.getStyleValue("transition-delay") as ValueArray;
				
					break;
				default:
					value = this._evaluatedStyles[propertyName];
					break;
			}
			
			return value;
		}
		
		/**
		* Returns a local state vector for this element.
		*/
		public function generateStateVector():Array
		{
			return [this.elementId, this.elementName, this._elementClassNames.join(","), this._elementPseudoClasses.join(","), this._parentIndex];
		}
		
		/**
		* Returns a state vector for this element, to be used as a cache key.
		*/
		public function generateStateVectorKey():String
		{
			return this.generateStateVector().join("/");
		}
		
		/**
		* Resets the descendant registry to a fresh state.
		*/
		public function resetDescendantRegistry():void
		{
			this._descendants = new Vector.<UIElement>(); // All descendants. Updated when elements are added/removed to/from this tree.
			this._descendantsByClass = {} // All descendants mapped by classname.
			this._descendantsById = {}; // All descendants mapped by element ID
			this._descendantsByName = {}; // All descendants mapped by element name
			this._descendantsByPseudoClass = {}; // All descendants mapped by pseudo
		}
		
		public function registerDescendantClassName(name:String, originatingElement:UIElement):void
		{
			if(name != null)
			{
				if(this._descendantsByClass[name] == null)
				{
					this._descendantsByClass[name] = new Vector.<UIElement>();
				}
			
				var desc:Vector.<UIElement> = this._descendantsByClass[name] as Vector.<UIElement>;
				if(desc.indexOf(originatingElement) < 0)
				{
					desc.push(originatingElement);
				}
				this._descendantsByClass[name] = desc;
			
				if(this.parentElement != null)
				{
					this.parentElement.registerDescendantClassName(name, originatingElement);
				}
			}
		}
		
		public function unregisterDescendantClassName(name:String, originatingElement:UIElement):void
		{
			if(name != null)
			{
				var desc:Vector.<UIElement> = this._descendantsByClass[name] as Vector.<UIElement>;
				var i:int = desc.indexOf(originatingElement);
				if(i < 0)
				{
					StyleKit.logger.error("Unregistering descendant class name, but descendant was never registered. The descendant cache has lost sync.", this);
				}
				else
				{
					desc.splice(i, 1);
					this._descendantsByClass[name] = desc;
				}
			
				if(this.parentElement != null)
				{
					this.parentElement.unregisterDescendantClassName(name, originatingElement);
				}
			}
		}
		
		public function registerDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			if(name != null)
			{
				if(this._descendantsByPseudoClass[name] == null)
				{
					this._descendantsByPseudoClass[name] = new Vector.<UIElement>();
				}
				
				var desc:Vector.<UIElement> = this._descendantsByPseudoClass[name] as Vector.<UIElement>;
				if(desc.indexOf(originatingElement) < 0)
				{
					desc.push(originatingElement);
				}
				this._descendantsByPseudoClass[name] = desc;
			
				if(this.parentElement != null)
				{
					this.parentElement.registerDescendantPseudoClass(name, originatingElement);
				}
			}
		}
		
		public function unregisterDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			if(name != null)
			{
				var desc:Vector.<UIElement> = this._descendantsByPseudoClass[name] as Vector.<UIElement>;
				var i:int = desc.indexOf(originatingElement);
				if(i < 0)
				{
					StyleKit.logger.error("Unregistering descendant pseudoclass, but descendant was never registered. The descendant cache has lost sync.", this);
				}
				else
				{
					desc.splice(i, 1);
					this._descendantsByPseudoClass[name] = desc;
				}
			
				if(this.parentElement != null)
				{
					this.parentElement.unregisterDescendantPseudoClass(name, originatingElement);
				}
			}
		}
		
		public function descendantNameModified(newName:String, previousName:String, originatingElement:UIElement):void
		{
			// Register new name
			if(newName != null)
			{
				if(this._descendantsByName[newName] == null)
				{
					this._descendantsByName[newName] = new Vector.<UIElement>();
				}
				
				var n:Vector.<UIElement> = this._descendantsByName[newName] as Vector.<UIElement>;
				if(n.indexOf(originatingElement) < 0)
				{
					n.push(originatingElement);
				}
			}
			
			// Unregister previous name
			if(previousName != null)
			{
				var d:Vector.<UIElement> = this._descendantsByName[previousName] as Vector.<UIElement>;
				if(d != null)
				{
					var i:int = d.indexOf(originatingElement);
					if(i >= 0)
					{
						d.splice(i, 1);
						this._descendantsByName[previousName] = d;
					}
				}
			}
			
			if(this.parentElement != null)
			{
				this.parentElement.descendantNameModified(newName, previousName, originatingElement);
			}
		}
		
		public function descendantIdModified(newId:String, previousId:String, originatingElement:UIElement):void
		{
			// Register new name
			if(newId != null)
			{
				if(this._descendantsById[newId] == null)
				{
					this._descendantsById[newId] = new Vector.<UIElement>();
				}
				
				var n:Vector.<UIElement> = this._descendantsById[newId] as Vector.<UIElement>;
				if(n.indexOf(originatingElement) < 0)
				{
					n.push(originatingElement);
				}
			}
			
			// Unregister previous name
			if(previousId != null)
			{
				var d:Vector.<UIElement> = this._descendantsById[previousId] as Vector.<UIElement>;
				if(d != null)
				{
					var i:int = d.indexOf(originatingElement);
					if(i >= 0)
					{
						d.splice(i, 1);
						this._descendantsById[previousId] = d;
					}
				}
			}
			
			if(this.parentElement != null)
			{
				this.parentElement.descendantIdModified(newId, previousId, originatingElement);
			}
		}
		
		/**
		* Registers a descendant to this element and all elements above it.
		*/
		public function descendantAdded(descendant:UIElement):void
		{
			// Add to main descendant list
			if(this._descendants.indexOf(descendant) < 0)
			{
				this._descendants.push(descendant);
			
				// Add to ID hash
				this.descendantIdModified(descendant.elementId, null, descendant);
				// Add to name hash
				this.descendantNameModified(descendant.elementName, null, descendant);
				// Register classes
				for(var i:uint=0; i < descendant.elementClassNames.length; i++)
				{
					this.registerDescendantClassName(descendant.elementClassNames[i], descendant);
				}
				// Register pseudoclasses
				for(i=0; i < descendant.elementPseudoClasses.length; i++)
				{
					this.registerDescendantPseudoClass(descendant.elementPseudoClasses[i], descendant);
				}
			
				if(this.parentElement != null)
				{
					this.parentElement.descendantAdded(descendant);
				}
			}
		}
		
		/**
		* Unregisters a descendant from this element and all elements above it.
		*/
		public function descendantRemoved(descendant:UIElement):void
		{
			// Add to main descendant list
			this._descendants.splice(this._descendants.indexOf(descendant), 1);
			
			// Strip from ID hash
			this.descendantIdModified(null, descendant.elementId, descendant);
			// Strip from name hash
			this.descendantNameModified(null, descendant.elementName, descendant);
			// DE-register classes
			for(var i:uint=0; i < descendant.elementClassNames.length; i++)
			{
				this.unregisterDescendantClassName(descendant.elementClassNames[i], descendant);
			}
			// DE-register pseudoclasses
			for(i=0; i < descendant.elementPseudoClasses.length; i++)
			{
				this.unregisterDescendantPseudoClass(descendant.elementPseudoClasses[i], descendant);
			}
			if(this.parentElement != null)
			{
				this.parentElement.descendantRemoved(descendant);
			}
		}
		
		/**
		* Called when this element is removed from an ancestor and added to a new one. Descends the tree and unregisters all descendants of this node.
		*/
		public function movedToNewAncestorTree(removedFrom:UIElement, addedTo:UIElement):void
		{
			if(removedFrom != null)
			{
				removedFrom.descendantRemoved(this);
			}
			if(addedTo != null)
			{
				addedTo.descendantAdded(this);
			}
			
			for(var i:uint=0; i < this._children.length; i++)
			{
				this._children[i].movedToNewAncestorTree(removedFrom, addedTo);
			}
		}
		
		/**
		* Traverses the descendants of this element by selector chain and returns all the matches.
		*/
		public function getElementsBySelectorSet(selectors:Vector.<ElementSelector>):Vector.<UIElement>
		{
			var reducedSet:Vector.<UIElement> = new Vector.<UIElement>();
			selectors = selectors.concat(); // clone the vector
			var selector:ElementSelector = selectors.shift();
			var elementSets:Array = [];
			
				// for each criterion specified by the selector (a class, an id, a pseudo, whatever)
				// we'll grab the set of descendants for that set, and calculate the intersection.
				if(selector.elementNameMatchRequired)
				{
					elementSets.push(this.descendantsByName[selector.elementName]);
				}
				if(selector.elementID != null)
				{
					elementSets.push(this.descendantsById[selector.elementID]);
				}
				if(selector.elementClassNames.length > 0)
				{
					for(var n:uint = 0; n < selector.elementClassNames.length; n++)
					{
						elementSets.push(this.descendantsByClass[selector.elementClassNames[n]]);
					}
				}
				if(selector.elementPseudoClasses.length > 0)
				{
					for(var p:uint = 0; p < selector.elementPseudoClasses.length; p++)
					{
						elementSets.push(this.descendantsByPseudoClass[selector.elementPseudoClasses[p]]);
					}
				}
			
			// Calculate the intersection of elements in the elementSets
			for(var es:uint = 0; es < elementSets.length; es++)
			{
				if(elementSets[es] != null)
				{
					var eSet:Vector.<UIElement> = elementSets[es] as Vector.<UIElement>;
					// Loop set and add to the reducedSet only if it appears on all elementSets
					for(var s:uint = 0; s < eSet.length; s++)
					{
						var elem:UIElement = eSet[s];
						var foundCount:int = 0;
						
						for(var ss:uint = 0; ss < elementSets.length; ss++)
						{
							if(elementSets[ss] != null && (elementSets[ss] as Vector.<UIElement>).indexOf(elem) >= 0)
							{
								foundCount++;
							}
						}
						
						if(foundCount >= elementSets.length && reducedSet.indexOf(elem) < 0)
						{
							reducedSet.push(elem);
						}
					}
				}
			}
			
			// If the selector was prefixed with the ">" character, it requires the reduced set to only contain direct parents of the 
			// calling element.
			var c_red:int = reducedSet.length;
			
			if(selector.parentSelector != null)
			{
				reducedSet = reducedSet.filter(function(elem:UIElement, index:int, set:Vector.<UIElement>):Boolean {
					return (elem.parentElement == this);
				}, this);
				
			}
				
			// Reduced set now contains the set of descendant elements matching the current candidate selector.
			if(selectors.length == 0)
			{
				// If we've reached the end of the selector chain, there is no need to recurse further.
				return reducedSet;
			}
			else
			{
				// If there are more selectors, we need to reduce the set again by recursing into this tier's reduced set.
				var recursedSet:Vector.<UIElement> = new Vector.<UIElement>();
				
				for(var r:uint = 0; r < reducedSet.length; r++)
				{
					var subRec:Vector.<UIElement> = reducedSet[r].getElementsBySelectorSet(selectors);
						for(var sr:uint = 0; sr < subRec.length; sr++)
						{
							if(recursedSet.indexOf(subRec[sr]) < 0)
							{
								recursedSet.push(subRec[sr]);
							}
						}
				}
				
				return recursedSet;
				
			}
			return null;
		}
		
		public function flushStyles():void
		{
			this._styles = new Vector.<Style>();
			this._styleSelectors = new Vector.<ElementSelectorChain>();
		}
		
		public function pushStyle(style:Style, matchedSelectorChain:ElementSelectorChain):void
		{
			if(this._styles.length != this._styleSelectors.length)
			{
				StyleKit.logger.error("Lost style sync on matched style pair.", this);
			}
			if(this._styles.indexOf(style) < 0)
			{
				this._styles.push(style);
				this._styleSelectors.push(matchedSelectorChain);
			}
		}
		
		public function commitStyles():void
		{
			this.evaluateStyles();
		}
		
		protected function cacheKeyForSelectorsAndStyles(styles:Vector.<Style>, selectors:Vector.<ElementSelectorChain>, local:Style):String
		{
			var styleSetCacheKeys:Vector.<String> = new Vector.<String>();
			for(var s:int = 0; s < selectors.length; s++)
			{
				styleSetCacheKeys.push(selectors[s].selectorId);
			}
			if(local != null)
			{
				styleSetCacheKeys.push(local.elementSelectorChains[0].selectorId);
			}
			return styleSetCacheKeys.join(",");
		}
		
		protected function evaluateStyles():void
		{
			
			// Build a cache key based on the styles currently applied to this element
			var styleSetCacheKey:String = this.cacheKeyForSelectorsAndStyles(this._styles, this._styleSelectors, this._localStyle);
			var previousStyleSetCacheKey:String;
			
			// This var will store all the styles sourced from the CSS objects 
			var evaluatedNetworkStyles:Object;
			
			if(styleSetCacheKey == this._evaluatedStyleCurrentCacheKey)
			{
				//StyleKit.logger.debug("Evaluating styles: cache key for selector set matches current cache key, using existing values: "+styleSetCacheKey, this);
			}
			else if(this._evaluatedNetworkStyleCache[styleSetCacheKey] != null)
			{
				StyleKit.logger.debug("Evaluating styles: retrieving cached computed styles for cache key: "+styleSetCacheKey, this);
				this._evaluatedStyleCurrentCacheKey = styleSetCacheKey;
				this.evaluatedStyles = this._evaluatedNetworkStyleCache[styleSetCacheKey] as Object;
			}
			else
			{

				// Set up initial values
				evaluatedNetworkStyles = PropertyContainer.defaultStyles;

				// Merge in the styles in order of specificity
				for(var i:int = 0; i < this._styles.length; i++)
				{
					evaluatedNetworkStyles = this._styles[i].evaluate(evaluatedNetworkStyles, this);
				}
				
				if(this._localStyle != null)
				{
					evaluatedNetworkStyles = this._localStyle.evaluate(evaluatedNetworkStyles, this);
				}
				
				// Cache it
				StyleKit.logger.debug("Evaluating styles: caching newly-computed styles for selector set: "+styleSetCacheKey, this);
				this._evaluatedNetworkStyleCache[styleSetCacheKey] = evaluatedNetworkStyles;
				this._evaluatedStyleCurrentCacheKey = styleSetCacheKey; // Set the current cache key
				
				// Compare it
				this.evaluatedStyles = evaluatedNetworkStyles;
			}
		}
		
		public function beginPropertyTransition(propertyName:String, initialValue:Value, endValue:Value):void
		{
			var pList:PropertyListValue = (this.getStyleValue("transition-property") as PropertyListValue);
			var pInd:int = pList.indexOfProperty(propertyName);
			if(pInd < 0)
			{
				return;
			}
			else
			{
				var durValue:TimeValue = ((this.getStyleValue("transition-duration") as ValueArray).valueAt(pInd) as TimeValue);
				var delValue:TimeValue = ((this.getStyleValue("transition-delay") as ValueArray).valueAt(pInd) as TimeValue);
				var tfValue:TimingFunctionValue = ((this.getStyleValue("transition-timing-function") as ValueArray).valueAt(pInd) as TimingFunctionValue);
				
				// Build the worker
				var worker:TransitionWorker = new TransitionWorker(this, initialValue, endValue, delValue, durValue, tfValue);
				
				// Cancel any currently-running workers on this property
				this.cancelPropertyTransition(propertyName);
				
				// Bind to events on the new worker
				worker.addEventListener(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, this.onTransitionIntermediateValueGenerated);
				worker.addEventListener(TransitionWorkerEvent.FINAL_VALUE_GENERATED, this.onTransitionFinalValueGenerated);
				
				// Append to the vectors
				this._transitionWorkers.push(worker);
				this._transitionWorkerProperties.push(propertyName);
				
				// Kick it
				worker.start();
				
				this.dispatchEvent(new UIElementEvent(UIElementEvent.TRANSITION_STARTED, this));
			}
		}
		
		public function cancelPropertyTransition(propertyName:String, restoreValue:Value = null):void
		{
			var pInd:int = this._transitionWorkerProperties.indexOf(propertyName);
			if(pInd > -1)
			{
				this._transitionWorkers[pInd].cancel();
				
				this._transitionWorkers[pInd].removeEventListener(
					TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, this.onTransitionIntermediateValueGenerated
					);
				this._transitionWorkers[pInd].removeEventListener(
					TransitionWorkerEvent.FINAL_VALUE_GENERATED, this.onTransitionFinalValueGenerated
					);
				
				this._transitionWorkers.splice(pInd, 1);
				this._transitionWorkerProperties.splice(pInd, 1);
				
				if(restoreValue != null)
				{
					this.overwriteEvaluatedStyle(propertyName, restoreValue);
				}
			}
		}
		
		public function shouldTransitionProperty(p:String):Boolean
		{
			if(this._runTransitions == false)
			{
				return false;
			}
			
			var pList:PropertyListValue = (this.getStyleValue("transition-property") as PropertyListValue);
			var pInd:int = pList.indexOfProperty(p);
			if(pInd < 0)
			{
				return false;
			}
			else
			{
				var durValue:TimeValue = ((this.getStyleValue("transition-duration") as ValueArray).valueAt(pInd) as TimeValue);
				var delValue:TimeValue = ((this.getStyleValue("transition-delay") as ValueArray).valueAt(pInd) as TimeValue);
				
				return ((durValue.millisecondValue > 0) || (delValue.millisecondValue > 0));
			}
		}
		
		protected function onTransitionIntermediateValueGenerated(e:TransitionWorkerEvent):void
		{
			var pInd:int = this._transitionWorkers.indexOf(e.worker);
			var pName:String = this._transitionWorkerProperties[pInd];
			
			this.overwriteEvaluatedStyle(pName, e.value);
		}
		
		protected function onTransitionFinalValueGenerated(e:TransitionWorkerEvent):void
		{
			var pInd:int = this._transitionWorkers.indexOf(e.worker);
			var pName:String = this._transitionWorkerProperties[pInd];
			
			this.onTransitionIntermediateValueGenerated(e);
			this.cancelPropertyTransition(pName);
			
			this.dispatchEvent(new UIElementEvent(UIElementEvent.TRANSITION_FINISHED, this));
		}
		
		protected function onParentElementEvaluatedStylesModified(e:UIElementEvent):void
		{
			this.evaluateStyles();
		}
		
		protected function onChildDimensionsChanged(e:UIElementEvent):void
		{
			this.layoutChildren();
		}
		
		protected function onFocusIn(e:FocusEvent):void
		{
			this.addElementPseudoClass("focus");
		}
		
		protected function onFocusOut(e:FocusEvent):void
		{
			this.removeElementPseudoClass("focus");
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			if(this._listensForHover)
			{
				StyleKit.logger.debug("Hoverin'", this);
				this.addElementPseudoClass("hover");
			}
			
			this.refreshCursor();
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			this.removeElementPseudoClass("hover");
			this.removeElementPseudoClass("active");
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			StyleKit.logger.debug("MouseClick", this);
		}
		
		protected function onMouseDoubleClick(e:MouseEvent):void
		{
			StyleKit.logger.debug("MouseDoubleClick", this);
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			this.addElementPseudoClass("active");
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			this.removeElementPseudoClass("active");
		}
		
		private function refreshCursor():void
		{
			var cursor:int = this.getMouseCursorTypeId();
			var flashCursor:String;
			
			switch (cursor)
			{
				case CursorValue.CURSOR_POINTER:
					flashCursor = MouseCursor.BUTTON;
					break;
				default: 
					flashCursor = MouseCursor.ARROW;
					break;
			}
			
			if(Mouse.cursor != flashCursor)
			{
				Mouse.cursor = flashCursor;
			}
		}
		
		/**
		* Returns the cursor that should be used for this element as a CursorValue static ID.
		* Walks up the parent chain until a special cursor is found, or the top of the tree is encountered.
		*/
		public function getMouseCursorTypeId():int
		{
			var cursorElement:UIElement = this;
			var cursor:int = cursorElement.getLocalMouseCursorTypeId();
			
			while(cursor == CursorValue.CURSOR_DEFAULT && cursorElement != null)
			{
				cursor = cursorElement.getLocalMouseCursorTypeId();
				cursorElement = cursorElement.parentElement;
			}
			
			return cursor;
		}
		
		/**
		* Returns the cursor associated with this element as a CursorValue static ID.
		*/
		public function getLocalMouseCursorTypeId():int
		{
			var cursorStyleValue:CursorValue = (this.getStyleValue("cursor") as CursorValue);
			return (cursorStyleValue == null)? CursorValue.CURSOR_DEFAULT : cursorStyleValue.cursor;
		}
		
		/* Overrides to block the Flash methods when they called outside of this class */
		
		/**
		 * @see UIElement.addElementAt
		 */
		/*public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new IllegalOperationError("Method addChildAt not accessible on a UIElement");
		}*/
		
		/**
		 * @see UIElement.removeElementAt
		 */
		/*public override function removeChildAt(index:int):DisplayObject
		{
			throw new IllegalOperationError("Method removeChildAt not accessible on a UIElement");
		}*/
	}
}
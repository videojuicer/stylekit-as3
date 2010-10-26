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
	
	import flashx.textLayout.formats.Float;
	
	import mx.skins.Border;
	
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
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.FloatValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.TransitionCompoundValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.events.StyleSheetEvent;
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
		
		protected static var EFFECTIVE_CONTENT_DIMENSION_CSS_PROPERTIES:Array = ["width", "height", "max-width", "max-height", "min-width", "min-height", "display"];
		
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
		
		protected var _painter:UIElementPainter;
		
		// An associative set of transition workers and the properties they relate to.
		protected var _transitionWorkers:Vector.<TransitionWorker>;
		protected var _transitionWorkerProperties:Vector.<String>;
		
		/**
		* A reference to the Style object used to store this element's local styles. This Style is treated with a higher 
		* priority than styles sourced from the BaseUI's stylesheet collection.
		*/ 
		protected var _localStyle:Style;
		
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
			
			this._painter = new UIElementPainter(this);
			
			if (this.baseUI != null && this.baseUI.styleSheetCollection != null)
			{
				this.baseUI.styleSheetCollection.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);
			}
			
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
			if(this._parentElement != null)
			{
				this._parentElement.removeEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, this.onParentElementEvaluatedStylesModified);
			}
			this._parentElement = parent;
			this._parentElement.addEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, this.onParentElementEvaluatedStylesModified);
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
		
		public function get effectiveWidth():int
		{
			return this._effectiveWidth;
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
		
		public function get styles():Vector.<Style>
		{
			return this._styles;
		}
		
		public function get elementName():String
		{
			return this._elementName;
		}
		
		public function set elementName(elementName:String):void
		{
			this._elementName = elementName;
			
			this.updateStyles();
		}
		
		public function get elementId():String
		{
			return this._elementId;
		}
		
		public function set elementId(s:String):void
		{
			this._elementId = s;
			this.updateStyles();
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
				if(previousEvaluatedStyles[newKey] == null || (newEvaluatedStyles[newKey] != null && !newEvaluatedStyles[newKey].isEquivalent(previousEvaluatedStyles[newKey])))
				{
					changeFound = true;
					alteredKeys.push(newKey);
				}
			}
			// Find missing keys
			if(!changeFound)
			{
				for(var prevKey:String in previousEvaluatedStyles)
				{
					if(newEvaluatedStyles[prevKey] == null)
					{
						changeFound = true;
						alteredKeys.push(prevKey);
					}
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
				//trace(">>> CHANGE FOUND ON ", this, this.toString(), this.elementId, this.elementName);
				
				this.onStylePropertyValuesChanged(alteredKeys);
				this.dispatchEvent(new UIElementEvent(UIElementEvent.EVALUATED_STYLES_MODIFIED, this));
			}
			this._runTransitions = true;
		}
		
		protected function overwriteEvaluatedStyle(propertyName:String, value:Value):void
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
			var effectiveContentDimensionsRecalcNeeded:Boolean = false;
						
			for(var i:uint=0; i < alteredKeys.length; i++)
			{
				var k:String = alteredKeys[i];
				if(UIElement.EFFECTIVE_CONTENT_DIMENSION_CSS_PROPERTIES.indexOf(k) > -1)
				{
					effectiveContentDimensionsRecalcNeeded = true;
					break;
				}
			}
			
			if(effectiveContentDimensionsRecalcNeeded) this.recalculateEffectiveContentDimensions();
			
			// TODO react to changes that require a redraw (border, width, etc.)
			// TODO react to changes that require a re-layout of the parent's children (change to float, position)
			// TODO react to changes in animation and transition (change to transition-property, animation)
				// sub-TODO: this requires the implementation of local styles
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
			
			this.dispatchEvent(new UIElementEvent(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this));
		}
		
		/**
		* Recalculates the effective extent of this element's children. Called after a layout operation and ONLY valid after a layout operation.
		*/
		protected function recalculateContentDimensions():void
		{
			var w:int = 0;
			var h:int = 0;

			/* TODO
				Width:
					Search children to find greatest _x + effectiveWidth
				Height:
					Search children to find greatest _y + effectiveHeight
			*/
			
			for (var i:int = 0; i < this.children.length; i++)
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
			}
			
			this.setContentDimensions(w, h);
		}
		
		/**
		* Called when the content of this element changes dimensions, by a new value being set in either direction
		* or in both directions with setContentDimensions.
		*/
		protected function onContentDimensionsModified():void
		{
			// TODO update scrollbars
			this.recalculateEffectiveContentDimensions();
		}
		
		/**
		* Recalculates the size of the content area for this element.
		*/
		public function recalculateEffectiveContentDimensions():void
		{
			var w:int = 0;
			var h:int = 0;
			
			/* TODO
				After:
					Width:
						subtract vertical scrollbar if vertical scrollbar required
					Height:
						subtract horizontal scrollbar if horizontal scrollbar required
			*/
			
			// Width			
			if(this.hasStyleProperty("width")) 
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
			if(this.hasStyleProperty("width"))
			{
				h = this.evalStyleSize("height", SizeValue.DIMENSION_HEIGHT);
			}
			else {
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
			
			this.layoutChildren(); // warning: potential INFINITE LOOP OF DEATH
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
		
		public function getElementsBySelector(selector:*):Vector.<UIElement>
		{
			var elements:Vector.<UIElement> = new Vector.<UIElement>();
			
			var elementSelector:ElementSelector = null;
			var chainSelector:ElementSelectorChain = null;
			
			if (selector is String)
			{
				var parser:ElementSelectorParser = new ElementSelectorParser();
				
				chainSelector = parser.parseElementSelectorChain(selector);
			}
			else if (selector is ElementSelector)
			{
				elementSelector = selector as ElementSelector;
			}
			else if (selector is ElementSelectorChain)
			{
				chainSelector = selector as ElementSelectorChain;
			}
			else
			{
				throw new IllegalOperationError("Illegal selector type defined as '"+selector.toString()+"' used when calling 'getElementsBySelector'");
			}
			
			for (var i:int = 0; i < this.children.length; i++)
			{
				if (elementSelector != null && this.children[i].matchesElementSelector(elementSelector))
				{
					elements.push(this.children[i]);
				}
				
				if (chainSelector != null && this.children[i].matchesElementSelectorChain(chainSelector))
				{
					elements.push(this.children[i]);
				}
			}
			
			if (elements.length > 0)
			{
				return elements;
			}
			
			return null;
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
			
			this.updateStyles();
			
			return true;
		}
		
		public function removeElementClassName(className:String):Boolean
		{
			if (this.hasElementClassName(className))
			{
				this._elementClassNames.splice(this._elementClassNames.indexOf(className), 1);
				
				this.updateStyles();
				
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
			
			StyleKit.logger.debug("Added "+pseudoClass, this);
			
			this.updateStyles();
			this.redraw();
			
			return true;
		}
		
		public function removeElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				this._elementPseudoClasses.splice(this._elementClassNames.indexOf(pseudoClass), 1);
				
				StyleKit.logger.debug("Removed "+pseudoClass, this);
				
				this.updateStyles();
				this.redraw();
				
				return true;
			}
			
			return false;
		}
		
		protected function refreshControlLines():void
		{
			this._controlLines = new Vector.<FlowControlLine>();
			
			var textAlign:AlignmentValue = (this.getStyleValue("text-align") as AlignmentValue);
			
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
			
			trace("Added "+this._controlLines.length+" control lines");
		}
		
		protected function newControlLine(textAlign:AlignmentValue):void
		{
			this._controlLines.push(
				     new FlowControlLine(this.effectiveContentWidth, (textAlign.leftAlign ? "left" : (textAlign.rightAlign ? "right" : "left")))
			  );
		}
		
		protected function get currentControlLine():FlowControlLine
		{
			return this._controlLines[this._controlLines.length - 1];
		}
		
		public function calculateContentPoint():Point
		{
			var point:Point = new Point();
			
			point.x = this.evalStyleSize("padding-left") + this.evalStyleSize("margin-left");
			point.y = this.evalStyleSize("padding-top") + this.evalStyleSize("margin-top");
			
			if ((this.getStyleValue("border-left-style") as LineStyleValue).lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				point.x += this.evalStyleSize("border-left-width");
			}
			
			if ((this.getStyleValue("border-top-style") as LineStyleValue).lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				point.y += this.evalStyleSize("border-top-width");
			}
			
			return point;
		}
		
		public function layoutChildren():void
		{
			for (var k:int = 0; k < super.numChildren; k++)
			{
				super.removeChildAt(i);
			}
			
			this.refreshControlLines();
			
			if (this.controlLines != null)
			{
				// only we do now is stack the FlowControlLines onto the UIElements content space
				// the FlowControlLines take care of laying out the indiviual UIElement children.
				
				// as were only dealing with lines all we need to do is stack the lines one by one
				// with each line taking up the entire width, so we only need to think about stacking
				// the lines with there height.
				var y:Number = this.calculateContentPoint().y;
				var x:Number = this.calculateContentPoint().x;
				
				for (var i:int = 0; i < this.controlLines.length; i++)
				{
					var line:FlowControlLine = this.controlLines[i];
					
					line.x = x;
					line.y = y;
					
					line.layoutElements();
					
					trace("Adding FlowControlLine at "+x+"/"+y);
					
					y += line.lineHeight;
					
					
					super.addChild(line);
				}
			}
			
			this.recalculateContentDimensions();
		}
		
		public function redraw():void
		{
			this._painter.paint();
		}
		
		protected function updateParentIndex(index:uint):void
		{
			this._parentIndex = index;
			
			//this.updateStyles();
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
			
			child.parentElement = this;
			child._baseUI = this.baseUI;
			
			child.addEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			if (index < this._children.length)
			{
				this._children.splice(index, 0, child);
			}
			else
			{
				this._children.push(child);
			}
			
			this.updateChildrenIndex();
			
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
			
			child._parentElement = null;
			child._baseUI = null;
			
			this._children.splice(index, 1);
			
			this.updateChildrenIndex();
			
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
		
		public function updateStyles():void
		{
			// TODO remove listeners
			// BUG: somewhere here the evalulatedStyles on the UIElement are reset to the defaults
			
			this._styles = new Vector.<Style>();
			this._styleSelectors = new Vector.<ElementSelectorChain>();
			
			if (this.baseUI != null && this.baseUI.styleSheetCollection != null)
			{
				for (var i:int = 0; i < this.baseUI.styleSheetCollection.length; ++i)
				{
					var sheet:StyleSheet = this.baseUI.styleSheetCollection.styleSheets[i];
					
					for (var j:int = 0; j < sheet.styles.length; ++j)
					{
						var style:Style = sheet.styles[j];
						
						for (var k:int = 0; k < style.elementSelectorChains.length; ++k)
						{
							var chain:ElementSelectorChain = style.elementSelectorChains[k];
							
							if (this.matchesElementSelectorChain(chain))
							{
								if (this._styles.indexOf(style) == -1)
								{
									// TODO add listener
									this._styles.push(style);
									this._styleSelectors.push(chain);
								}
								
								break;
							}
						}
					}
				}
			}
			
			// Evaluate the new styles
			this.evaluateStyles();
		}
		
		protected function evaluateStyles():void
		{
			
			// Begin specificity sort			
			// Sort matched selectors by specificity
			if(this._styleSelectors != null)
			{
				var sortedSelectorChains:Vector.<ElementSelectorChain> = this._styleSelectors.concat();
				var sortedStyles:Vector.<Style> = new Vector.<Style>(sortedSelectorChains.length, true);
				
					sortedSelectorChains.sort(
						function(x:ElementSelectorChain, y:ElementSelectorChain):Number
						{
							if(x.specificity > y.specificity)
							{
								return 1;
							}
							else if(x.specificity < y.specificity)
							{
								return -1;
							}
							else
							{
								return 0;
							}
						}
					);
				// Loop over sorted selectors and use found index to sort corresponding style.
				// The created vector is fixed in length.

				for(var i:uint=0; i < this._styles.length; i++)
				{
					var sortCandidateStyle:Style = this._styles[i];
					// loop over style's selector chains and find index of any in the sorted selector vector, spector.
					// the found index is the insertion index for this style.
					for(var j:uint=0; j<sortCandidateStyle.elementSelectorChains.length; j++)
					{
						var fI:int = sortedSelectorChains.indexOf(sortCandidateStyle.elementSelectorChains[j]);
						if(fI > -1)
						{
							sortedStyles[fI] = sortCandidateStyle;
						}
					}
				}
			}
			// End specificity sort
			
			// Set up initial values
			var newEvaluatedStyles:Object = PropertyContainer.defaultStyles;
			
			// Merge in the styles in order of specificity
			if(this._styleSelectors != null)
			{
				for(i=0; i < sortedStyles.length; i++)
				{
					// if you get a runtime error here saying that one of these styles is null, then the _styleSelectors and _styles variables
					// went out of sync before or during this method's execution.

					var evalCandidateStyle:Style = sortedStyles[i];
					newEvaluatedStyles = evalCandidateStyle.evaluate(newEvaluatedStyles, this);
				}
			}
			
			// Include local styles
			if(this._localStyle != null)
			{
				newEvaluatedStyles = this._localStyle.evaluate(newEvaluatedStyles, this);
			}
			
			// Setter carries the comparison check and event dispatch
			this.evaluatedStyles = newEvaluatedStyles;
			
			// reset our control lines
			this._controlLines = null;
		}
		
		public function matchesElementSelector(selector:ElementSelector):Boolean
		{
			if (selector.elementNameMatchRequired && selector.elementName != null)
			{
				if (selector.elementName != this.elementName)
				{
					return false;
				}
			}
			
			if (selector.elementID != null)
			{
				if (selector.elementID != this.elementId)
				{
					return false;
				}
			}
			
			if (selector.elementClassNames.length > 0)
			{
				for (var i:int = 0; i < selector.elementClassNames.length; i++)
				{
					if (!this.hasElementClassName(selector.elementClassNames[i]))
					{
						return false;
					}
				}
			}
			
			if (selector.elementPseudoClasses.length > 0)
			{
				for (var j:int = 0; j < selector.elementPseudoClasses.length; j++)
				{
					if (!this.hasElementPseudoClass(selector.elementPseudoClasses[j]))
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function matchesElementSelectorChain(chain:ElementSelectorChain):Boolean
		{
			var collection:Vector.<ElementSelector> = chain.elementSelectors.reverse();
			var parent:UIElement = this;
			
			for (var i:int = 0; i < collection.length; i++)
			{
				var selector:ElementSelector = collection[i];
				
				if (parent != null && parent.matchesElementSelector(selector))
				{
					parent = parent.styleParent;
				}
				else
				{
					return false;
				}
			}
			
			return true;
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
		}
		
		protected function onParentElementEvaluatedStylesModified(e:UIElementEvent):void
		{
			this.evaluateStyles();
		}
		
		protected function onChildDimensionsChanged(e:UIElementEvent):void
		{
			this.layoutChildren();
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent):void
		{
			this.updateStyles();
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
			this.addElementPseudoClass("hover");
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			this.removeElementPseudoClass("hover");
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			
		}
		
		protected function onMouseDoubleClick(e:MouseEvent):void
		{
			
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			this.addElementPseudoClass("active");
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			this.removeElementPseudoClass("active");
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
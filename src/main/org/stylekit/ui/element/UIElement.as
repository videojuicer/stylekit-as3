package org.stylekit.ui.element
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.selector.ElementSelector;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.value.Value;
	import org.stylekit.events.StyleSheetEvent;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.ui.BaseUI;
	
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
		protected var _children:Vector.<UIElement>;
		protected var _styles:Vector.<Style>;
		protected var _styleSelectors:Vector.<ElementSelectorChain>;
		protected var _evaluatedStyles:Object;
		
		protected var _styleEligible:Boolean = false;
		
		protected var _effectiveWidth:int;
		protected var _effectiveHeight:int;
		protected var _contentWidth:int;
		protected var _contentHeight:int;

		protected var _parentIndex:uint = 0;
		protected var _parentElement:UIElement;
		
		protected var _baseUI:BaseUI;
		protected var _localStyle:Style;
		
		protected var _elementName:String;
		protected var _elementId:String;
		
		protected var _elementClassNames:Vector.<String>;
		protected var _elementPseudoClasses:Vector.<String>;
		
		public function UIElement(baseUI:BaseUI = null)
		{
			super();
			
			this._baseUI = baseUI;
			this._evaluatedStyles = {};
			
			this._children = new Vector.<UIElement>();
			
			this._elementClassNames = new Vector.<String>();
			this._elementPseudoClasses = new Vector.<String>();
			
			if (this.baseUI != null && this.baseUI.styleSheetCollection != null)
			{
				this.baseUI.styleSheetCollection.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);
			}
		}
		
		public function get parentElement():UIElement
		{
			return this._parentElement;
		}
		
		public function set parentElement(parent:UIElement):void
		{
			this._parentElement = parent;
		}
		
		public function get baseUI():BaseUI
		{
			return this._baseUI;
		}
		
		public function get localStyle():Style
		{
			return this._localStyle;
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
		
		public function get effectiveHeight():int
		{
			return this._effectiveHeight;
		}
		
		public function get contentWidth():int
		{
			return this._contentWidth;
		}
		
		public function get contentHeight():int
		{
			return this._contentHeight;
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
			this._evaluatedStyles = newEvaluatedStyles;
			
			// Perform comparison
			// A change is counted if:
			// 1. The new styles contain a value not present on the old styles
			// 2. The new styles are missing a value that is present on the old styles
			// 3. Values present on both objects for the same key are not equivalent
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
			
			this.updateStyles();
			
			return true;
		}
		
		public function removeElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				this._elementPseudoClasses.splice(this._elementClassNames.indexOf(pseudoClass), 1);
				
				this.updateStyles();
				
				return true;
			}
			
			return false;
		}
		
		public function layoutChildren():void
		{
			
		}
		
		public function redraw():void
		{
			
		}
		
		protected function updateParentIndex(index:uint):void
		{
			this._parentIndex = index;
			
			this.updateStyles();
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
			
			child._parentElement = this;
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
			if (this.getStyleProperty(propertyName) != null)
			{
				return true;
			}
			
			return false;
		}
		
		public function getStyleProperty(propertyName:String):Property
		{
			for (var i:int = 0; i < this.styles.length; i++)
			{
				for (var j:int = 0; j < this.styles[i].properties.length; j++)
				{
					if (this.styles[i].properties[j].name == propertyName)
					{
						return this.styles[i].properties[j];
					}
				}
			}
			
			return null;
		}
		
		public function updateStyles():void
		{
			// TODO remove listeners
			
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
			var sortedSelectorChains:Vector.<ElementSelectorChain> = this._styleSelectors.concat();
				sortedSelectorChains.sort(
					function(x:ElementSelectorChain, y:ElementSelectorChain):Number
					{
						if(x.specificity > y.specificity)
						{
							return -1;
						}
						else if(x.specificity > y.specificity)
						{
							return 1;
						}
						else
						{
							return 0;
						}
					}
				);
			
			// Loop over sorted selectors and use found index to sort corresponding style.
			// The created vector is fixed in length.
			var sortedStyles:Vector.<Style> = new Vector.<Style>(sortedSelectorChains.length, true);
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
			// End specificity sort
			
			var newEvaluatedStyles:Object = {};
			for(i=0; i < sortedStyles.length; i++)
			{
				// if you get a runtime error here saying that one of these styles is null, then the _styleSelectors and _styles variables
				// went out of sync before or during this method's execution.
				
				var evalCandidateStyle:Style = sortedStyles[i];
				newEvaluatedStyles = evalCandidateStyle.evaluate(newEvaluatedStyles, this);
			}
			// Setter carries the comparison check and event dispatch
			this.evaluatedStyles = newEvaluatedStyles;
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
		
		protected function onChildDimensionsChanged(e:UIElementEvent):void
		{
			this.layoutChildren();
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent):void
		{
			this.updateStyles();
		}
		
		/* Overrides to block the Flash methods when they called outside of this class */
		
		/**
		 * @see UIElement.addElement
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method addChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.addElementAt
		 */
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new IllegalOperationError("Method addChildAt not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElement
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method removeChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElementAt
		 */
		public override function removeChildAt(index:int):DisplayObject
		{
			throw new IllegalOperationError("Method removeChildAt not accessible on a UIElement");
		}
	}
}
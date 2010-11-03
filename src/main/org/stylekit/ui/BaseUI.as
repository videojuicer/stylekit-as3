package org.stylekit.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.StyleSheetEvent;
	import org.stylekit.ui.element.UIElement;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.selector.ElementSelector;
	
	public class BaseUI extends UIElement
	{
		protected var _styleSheetCollection:StyleSheetCollection;
		protected var _root:DisplayObject;
		
		/**
		* A flattened vector of styles present on the StyleSheetCollection
		*/
		protected var _collapsedStyles:Vector.<Style>;
		
		/**
		* A vector of element selector chains from the current collapsed style set that 
		* describe elements which require a listener for the :hover state.
		*/
		protected var _hoverSelectorChains:Vector.<ElementSelectorChain>;
		
		public function BaseUI(styleSheetCollection:StyleSheetCollection = null, root:DisplayObject = null)
		{
			this._styleSheetCollection = styleSheetCollection;
			if(this._styleSheetCollection != null)
			{
				this._styleSheetCollection.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);				
			}

			this.collapseStyles();
			
			this._root = root;
			
			this._hoverSelectorChains = new Vector.<ElementSelectorChain>();
			
			super();
			
			if (this._root != null && this._root.stage != null)
			{
				this._root.stage.addEventListener(Event.RESIZE, this.onRootResized, false, 1);
			}
		}
		
		public override function get baseUI():BaseUI
		{
			return this;
		}
		
		public override function get styleEligible():Boolean
		{
			return true;
		}
		
		public override function get styleParent():UIElement
		{
			return this;
		}
		
		public function get stageRoot():DisplayObject
		{
			return this._root;
		}
		
		public function get styleSheetCollection():StyleSheetCollection
		{
			return this._styleSheetCollection;
		}
		
		public function createUIElement():UIElement
		{
			return new UIElement(this);
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent):void
		{
			// Update styles flatlist
			StyleKit.logger.debug("BaseUI caught stylesheet modification, recollapsing styles into flattened list.", this);
			this.collapseStyles();
			this.allocateStyles(this);
		}
		
		/**
		* Retrieves all the styles from the current StyleSheetCollection and flattens them into an ordered list
		*/
		public function collapseStyles():void
		{
			this._collapsedStyles = new Vector.<Style>();
			
			// Flatten
			if(this.styleSheetCollection != null)
			{
				for(var i:uint = 0; i < this.styleSheetCollection.length; i++)
				{
					var sheet:StyleSheet = this.styleSheetCollection.styleSheets[i];
					
					for(var j:uint = 0; j < sheet.styles.length; j++)
					{
						var style:Style = sheet.styles[j];
						this._collapsedStyles.push(style);
					}
				}	
			}
			
			this.populateHoverListeners();
			this.allocateHoverListeners();
		}
		
		public override function registerDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantClassName(name, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		public override function unregisterDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantClassName(name, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		public override function registerDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantPseudoClass(name, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		public override function unregisterDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantPseudoClass(name, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		public override function descendantNameModified(newName:String, previousName:String, originatingElement:UIElement):void
		{
			super.descendantNameModified(newName, previousName, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		public override function descendantIdModified(newId:String, previousId:String, originatingElement:UIElement):void
		{
			super.descendantIdModified(newId, previousId, originatingElement);
			this.allocateHoverListeners();
			this.allocateStyles(originatingElement);
		}
		
		public override function descendantAdded(descendant:UIElement):void
		{
			super.descendantAdded(descendant);
			this.allocateHoverListeners();
			this.allocateStyles(descendant);
		}
		
		/**
		* Examines the list of collapsed styles to build a set of selectors that target elements which need to have the :hover pseudoclass applied to them.
		*/
		public function populateHoverListeners():void
		{
			this._hoverSelectorChains = new Vector.<ElementSelectorChain>();
			
			allStylesLoop:for(var i:int = 0; i < this._collapsedStyles.length; i++)
			{
				var s:Style = this._collapsedStyles[i];
				
				allChainsLoop:for(var j:int = 0; j < s.elementSelectorChains.length; j++)
				{
					var c:ElementSelectorChain = s.elementSelectorChains[j];
					var hI:int = c.stringValue.indexOf(":hover")
					
					if(hI > -1)
					{
						// Pick apart the chain
						var newChain:ElementSelectorChain = new ElementSelectorChain();
						singleChainLoop:for(var k:int = 0; k < c.elementSelectors.length; k++)
						{
							var sel:ElementSelector = c.elementSelectors[k];
							if(sel.hasElementPseudoClass("hover"))
							{
								if((k == 0) && (!sel.elementNameMatchRequired) && (sel.elementClassNames.length == 0) && (sel.elementID == null))
								{
									// If it has no element name, id, or classes, then ignore it. It's a wildcard that applies to all elements and we don't allow it.
									break singleChainLoop;
								}
								else
								{
									// If the selector references hover, then break it up, add it to the newChain and terminate.
									var newSel:ElementSelector = new ElementSelector();
										newSel.elementID = sel.elementID;
										newSel.elementName = sel.elementName;
										newSel.elementClassNames = sel.elementClassNames;
										newChain.addElementSelector(newSel);
										break singleChainLoop;
								}
							}
							else
							{
								// Else, just append the selector to the newChain
								newChain.addElementSelector(sel);
							}
						}
						if(newChain.elementSelectors.length > 0)
						{
							this._hoverSelectorChains.push(newChain);
						}
					}
				}
			}
			
			StyleKit.logger.debug("Analysed style selectors and found "+this._hoverSelectorChains.length+" selectors for elements that require the :hover listener", this);
		}
		
		public function allocateHoverListeners():void
		{
			var i:int;
			var enabled:int = 0;
			
			if(this.descendants == null || this.descendants.length == 0)
			{
				return;
			}
			
			for(i = 0; i < this.descendants.length; i++)
			{
				this.descendants[i].listensForHover = false;
			}
			for(i = 0; i < this._hoverSelectorChains.length; i++)
			{
				var matches:Vector.<UIElement> = this.getElementsBySelectorSet(this._hoverSelectorChains[i].elementSelectors);
				for(var j:int = 0; j < matches.length; j++)
				{
					if(!matches[j].listensForHover)
					{
						matches[j].listensForHover = true;
						enabled++;
					}
				}
			}
			StyleKit.logger.debug("Enabled hover on "+enabled+"/"+this.descendants.length+" elements as required by styles.", this);
		}
		
		public function allocateStyles(mutatedElement:UIElement):void
		{
			StyleKit.logger.debug("Allocating styles after a mutation on "+mutatedElement, this);
			
			var encounteredElements:Vector.<UIElement> = new Vector.<UIElement>();
			
			for(var i:uint = 0; i < this._collapsedStyles.length; i++)
			{
				var style:Style = this._collapsedStyles[i];
				for(var j:uint = 0; j < style.elementSelectorChains.length; j++)
				{
					var selectorChain:ElementSelectorChain = style.elementSelectorChains[j];
				
					// Get all elements matching this selector
					if(selectorChain.elementSelectors.length > 0)
					{
						var matched:Vector.<UIElement> = this.getElementsBySelectorSet(selectorChain.elementSelectors);

						// Add self as a candidate for matching styles
						if(this.selectorChainApplicable(selectorChain))
						{
							matched.push(this);
						}
						if(matched.length == 0)
						{
							// Skip if no matches
							continue;
						}
						
						var reducedMatch:Vector.<UIElement>;
						if(mutatedElement == this)
						{
							reducedMatch = matched;
						}
						else
						{
							reducedMatch = matched.filter(function(item:UIElement, index:int, set:Vector.<UIElement>):Boolean {
								return (mutatedElement.parentElement.descendants.indexOf(item) > -1)
							}, this);
							
							if(reducedMatch.length == 0)
							{
								continue;
							}
						} 
						
						for(var k:int = 0; k < reducedMatch.length; k++)
						{
							var thisMatch:UIElement = reducedMatch[k];
							// If they're not in the encounteredElement list, flush the styles and put them there.
							if(encounteredElements.indexOf(thisMatch) < 0)
							{
								thisMatch.flushStyles();
								encounteredElements.push(thisMatch);
							}
							
							// Push the style and the matching selector chain to the element
							thisMatch.pushStyle(style, selectorChain);
						}
					}
				}
			}
			
			// Commit the styles on all encountered elements.
			if(encounteredElements.length > 0)
			{
				StyleKit.logger.debug("Committing new styles on "+encounteredElements.length+" encountered elements.", this);
				for(var l:int = 0; l < encounteredElements.length; l++)
				{
					encounteredElements[l].commitStyles();
				}
			}
		}
		
		protected function selectorChainApplicable(chain:ElementSelectorChain):Boolean
		{
			var selectors:Vector.<ElementSelector> = chain.elementSelectors;
			
			if(selectors.length > 1)
			{
				return false;
			}
			
			var selector:ElementSelector = selectors[0];
			var i:int = 0;
			
			if(selector.elementNameMatchRequired && (selector.elementName != this.elementName))
			{
				return false;
			}
			if(selector.elementID != null && (selector.elementID != this.elementId))
			{
				return false;
			}
			if(selector.elementClassNames.length > 0)
			{
				for(i = 0; i < selector.elementClassNames.length; i++)
				{
					if(!this.hasElementClassName(selector.elementClassNames[i]))
					{
						return false;
					}
				}
			}
			if(selector.elementPseudoClasses.length > 0)
			{
				for(i = 0; i < selector.elementPseudoClasses.length; i++)
				{
					if(!this.hasElementPseudoClass(selector.elementPseudoClasses[i]))
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		protected function onRootResized(e:Event):void
		{
			trace("BaseUI resizing from "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
			
			this.recalculateEffectiveContentDimensions();
			
			trace("BaseUI parent -> "+this.stageRoot.stage.width+"/"+this.stageRoot.stage.height);
			trace("BaseUI resized to "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
		}
	}
}
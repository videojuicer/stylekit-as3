/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is the StyleKit library.
 *
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 *
 * ***** END LICENSE BLOCK ***** */
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
		* A flattened vector of selector chains from the styles, sorted by specificity.
		* For styles that use multiple comma-seperated selector chains, an entry will be created for each
		* selector and the corresponding style will be re-added to the _collapsedStyles vector as a duplicate pointer.
		*/
		protected var _collapsedSelectorChains:Vector.<ElementSelectorChain>;
		
		/**
		* A flattened vector of styles present on the StyleSheetCollection
		*/
		protected var _collapsedStyles:Vector.<Style>;
		
		/**
		* A vector of element selector chains from the current collapsed style set that 
		* describe elements which require a listener for the :hover state.
		*/
		protected var _hoverSelectorChains:Vector.<ElementSelectorChain>;
		
		protected var _domTransactionInProgress:Boolean = false;
		protected var _domTransactionMutatedElements:Vector.<UIElement>;
		
		/**
		* Set during the execution of #allocateStyles.
		* Prevents elements from reacting to their newly-evaluated style properties until all styles have been pushed to
		* all elements in the allocation push.
		*/
		protected var _styleAllocationInProgress:Boolean = false;
		/**
		* Stores a list of all elements which deferred their recalculations and redraws until the style allocation
		* has concluded.
		*/
		protected var _styleAllocationDeferredElements:Vector.<UIElement>;
		
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
		
		public function get styleAllocationInProgress():Boolean
		{
			return this._styleAllocationInProgress;
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
			this.domModified(this);
			
			Platform.gc();
		}
		
		/**
		* Retrieves all the styles from the current StyleSheetCollection and flattens them into a specificity-sorted pair of vectors.
		*/
		public function collapseStyles():void
		{
			this._collapsedStyles = new Vector.<Style>();
			this._collapsedSelectorChains = new Vector.<ElementSelectorChain>();
			
			// Flatten
			if(this.styleSheetCollection != null)
			{
				for(var i:uint = 0; i < this.styleSheetCollection.length; i++)
				{
					var sheet:StyleSheet = this.styleSheetCollection.styleSheets[i];
					
					for(var j:uint = 0; j < sheet.styles.length; j++)
					{
						var style:Style = sheet.styles[j];
						
						for(var k:uint = 0; k < style.elementSelectorChains.length; k++)
						{
							var chain:ElementSelectorChain = style.elementSelectorChains[k];
							
							this._collapsedSelectorChains.push(chain);
							this._collapsedStyles.push(style);
						}
					}
				}	
			}
			
			// Sort
			// Do a litle bubble sort thingy, since AS3's sort won't cut it for sorting multiple lists
			var n:int = this._collapsedSelectorChains.length-1;
			for(var a:uint = 0; a <= n; a++)
			{
				for(var b:uint = n; b > a; b--)
				{
					if(this._collapsedSelectorChains[b-1].specificity > this._collapsedSelectorChains[b].specificity)
					{
						// Swap j-1 to j in both vectors
						
						// Selector swap
						var prevChain:ElementSelectorChain = this._collapsedSelectorChains[b-1];
							this._collapsedSelectorChains[b-1] = this._collapsedSelectorChains[b];
							this._collapsedSelectorChains[b] = prevChain;
						// Style swap
						var prevStyle:Style = this._collapsedStyles[b-1];
							this._collapsedStyles[b-1] = this._collapsedStyles[b];
							this._collapsedStyles[b] = prevStyle;
					}
				}
			}
			// End specificity sort
			
			
			// Now refresh the hover listeners
			this.populateHoverListeners();
			this.allocateHoverListeners();
		}
		
		public override function addElementClassName(name:String):Boolean
		{
			var b:Boolean = super.addElementClassName(name);
			if(b) this.domModified(this);
			return b;
		}
		
		public override function removeElementClassName(name:String):Boolean
		{
			var b:Boolean = super.removeElementClassName(name);
			if(b) this.domModified(this);
			return b;
		}
		
		public override function addElementPseudoClass(name:String):Boolean
		{
			var b:Boolean = super.addElementPseudoClass(name);
			if(b) this.domModified(this);
			return b;
		}
		
		public override function removeElementPseudoClass(name:String):Boolean
		{
			var b:Boolean = super.removeElementPseudoClass(name);
			if(b) this.domModified(this);
			return b;
		}
		
		public override function registerDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantClassName(name, originatingElement);
			this.domModified(originatingElement);
		}
		public override function unregisterDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantClassName(name, originatingElement);
			this.domModified(originatingElement);
		}
		public override function registerDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantPseudoClass(name, originatingElement);
			this.domModified(originatingElement);
		}
		public override function unregisterDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantPseudoClass(name, originatingElement);
			this.domModified(originatingElement);
		}
		public override function descendantNameModified(newName:String, previousName:String, originatingElement:UIElement):void
		{
			super.descendantNameModified(newName, previousName, originatingElement);
			this.domModified(originatingElement);
		}
		public override function descendantIdModified(newId:String, previousId:String, originatingElement:UIElement):void
		{
			super.descendantIdModified(newId, previousId, originatingElement);
			this.domModified(originatingElement);
		}
		
		public override function descendantAdded(descendant:UIElement):void
		{
			super.descendantAdded(descendant);
			this.domModified(descendant);
		}
		
		protected function domModified(element:UIElement):void
		{
			if(this._domTransactionInProgress == true)
			{
				if(this._domTransactionMutatedElements.indexOf(element) < 0)
				{
					this._domTransactionMutatedElements.push(element);
				}
			}
			else
			{
				this.allocateHoverListeners();
				this.allocateStyles(element);
			}
		}
		
		/** 
		* Allows a series of DOM tree manipulations to take place without firing the selector-based allocation routines.
		* Usage:
		* baseUIInstance.domTransaction(function(baseUI:BaseUI) {
		*
		* }, scope);
		*
		* The <code>thisObj</code> parameter determines the scope of "this" during the transaction function.
		*/
		public function runDomTransaction(routine:Function, mutatingElement:UIElement, thisObj:*):void
		{
			this.enterDomTransaction();
			routine.apply(thisObj, [this]);
			this.commitDomTransaction(mutatingElement);
		}
		
		public function enterDomTransaction():void
		{
			this._domTransactionInProgress = true;
			this._domTransactionMutatedElements = new Vector.<UIElement>();
		}
		
		public function commitDomTransaction(mutatingElement:UIElement = null):void
		{
			this._domTransactionInProgress = false;


			if(this._domTransactionMutatedElements.length > 0)
			{
				StyleKit.logger.debug("Committing DOM transaction with "+this._domTransactionMutatedElements.length+" elements modified during transaction.", this);
				this.domModified(this);//((mutatingElement == null)? this : mutatingElement);
			}
			else
			{
				StyleKit.logger.debug("Committing DOM transaction with no changes encountered during the transaction.", this);
			}
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
										newSel.parentSelector = sel.parentSelector;
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
		}
		
		/**
		* Appends an element to the list of elements with deferred property modifications encountered
		* during a style allocation - see #allocateStyles
		*/
		public function registerElementWithDeferredStyleModifications(e:UIElement):void
		{
			if(this._styleAllocationDeferredElements == null)
			{
				this._styleAllocationDeferredElements = new Vector.<UIElement>();
			}
			if(this._styleAllocationDeferredElements.indexOf(e) < 0)
			{
				this._styleAllocationDeferredElements.push(e);
			}
		}
		
		public function allocateStyles(mutatedElement:UIElement):void
		{
			StyleKit.logger.debug("Allocating styles after a mutation on "+mutatedElement, this);
			
			var encounteredElements:Vector.<UIElement> = new Vector.<UIElement>();
			
			// Reset the allocation transaction
			this._styleAllocationInProgress = true;
			
			for(var i:uint = 0; i < this._collapsedSelectorChains.length; i++)
			{
				var style:Style = this._collapsedStyles[i];
				var selectorChain:ElementSelectorChain = this._collapsedSelectorChains[i];
			
				// Get all elements matching this selector
				if(selectorChain.elementSelectors.length > 0)
				{
					var matched:Vector.<UIElement> = this.getElementsBySelectorSet(selectorChain.elementSelectors);

					// Add self as a candidate for matching styles
					if(this.selectorChainApplicable(selectorChain))
					{
						matched.unshift(this);
					}
					if(matched.length == 0)
					{
						// Skip if no matches
						continue;
					}
					
					// Reduce the matches to those within the modified tree: the mutated element and it's descendants.
					var reducedMatch:Vector.<UIElement>;
					reducedMatch = matched.filter(function(item:UIElement, index:int, set:Vector.<UIElement>):Boolean {
						return (item == mutatedElement || mutatedElement.descendants.indexOf(item) > -1)
					}, this);
					
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
			
			// Commit the styles on all encountered elements.
			if(encounteredElements.length > 0)
			{
				// Pre-sort the list by tree position; we want to style higher-order objects first.
				encounteredElements = encounteredElements.sort(function(x:UIElement, y:UIElement):Number {
					return y.descendants.length - x.descendants.length; 
				});
				
				StyleKit.logger.debug("Committing new styles on "+encounteredElements.length+" encountered elements.", this);
				for(var l:int = 0; l < encounteredElements.length; l++)
				{
					encounteredElements[l].commitStyles();
				}
			}
			
			// Now that the transaction is complete, run through the deferred list and tell everything to start reacting to 
			// any modified keys
			if(this._styleAllocationDeferredElements != null)
			{
				for(var d:uint = 0; d < this._styleAllocationDeferredElements.length; d++)
				{
					this._styleAllocationDeferredElements[d].execCallbacksForDeferredStyleKeyModifications();
				}
			}
			// Reset the deferred list and the transaction state now.
			this._styleAllocationDeferredElements = null;
			this._styleAllocationInProgress = false;
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
			StyleKit.logger.info("BaseUI resizing from "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
			
			this.recalculateEffectiveContentDimensions();
			
			StyleKit.logger.debug("Stage size -> "+this.stageRoot.stage.width+"/"+this.stageRoot.stage.height);
			StyleKit.logger.info("BaseUI resized to "+this.effectiveContentWidth+"/"+this.effectiveContentHeight);
			
			Platform.gc();
		}
	}
}
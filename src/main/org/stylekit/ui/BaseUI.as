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
		
		public function BaseUI(styleSheetCollection:StyleSheetCollection = null, root:DisplayObject = null)
		{
			this._styleSheetCollection = styleSheetCollection;
			if(this._styleSheetCollection != null)
			{
				this._styleSheetCollection.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);				
			}

			this.collapseStyles();
			
			this._root = root;
			
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
			
			// Sort
		}
		
		public override function registerDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantClassName(name, originatingElement);
			this.allocateStyles(originatingElement);
		}
		public override function unregisterDescendantClassName(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantClassName(name, originatingElement);
			this.allocateStyles(originatingElement);
		}
		public override function registerDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.registerDescendantPseudoClass(name, originatingElement);
			this.allocateStyles(originatingElement);
		}
		public override function unregisterDescendantPseudoClass(name:String, originatingElement:UIElement):void
		{
			super.unregisterDescendantPseudoClass(name, originatingElement);
			this.allocateStyles(originatingElement);
		}
		public override function descendantNameModified(newName:String, previousName:String, originatingElement:UIElement):void
		{
			super.descendantNameModified(newName, previousName, originatingElement);
			this.allocateStyles(originatingElement);
		}
		public override function descendantIdModified(newId:String, previousId:String, originatingElement:UIElement):void
		{
			super.descendantIdModified(newId, previousId, originatingElement);
			this.allocateStyles(originatingElement);
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
		
		protected function onRootResized(e:Event):void
		{
			trace("BaseUI resizing from "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
			
			this.recalculateEffectiveContentDimensions();
			
			trace("BaseUI parent -> "+this.stageRoot.stage.width+"/"+this.stageRoot.stage.height);
			trace("BaseUI resized to "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
		}
	}
}
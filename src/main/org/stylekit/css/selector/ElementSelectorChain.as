package org.stylekit.css.selector
{
	
	import org.stylekit.css.selector.ElementSelector;
	
	/**
	* An <code>ElementSelectorChain</code> is, as the name suggests, an ordered chain of <code>ElementSelector</code> instances.
	* While an individual CSS selector "p:last-child" is expressed within SMILKit as an <code>ElementSelector</code>, a chain of
	* selectors such as "div p" or "div > h1:first-child" is expressed as an <code>ElementSelectorChain</code>.
	*
	* @see org.stylekit.css.style.selector.ElementSelector
	*/
	
	public class ElementSelectorChain
	{
		
		protected var _elementSelectors:Vector.<ElementSelector>;
		
		public function ElementSelectorChain()
		{
			this._elementSelectors = new Vector.<ElementSelector>();
		}
		
		public function addElementSelector(e:ElementSelector, atIndex:int=-1):void
		{
			this._elementSelectors.splice(((atIndex > -1)? atIndex : this.elementSelectors.length ), 0, e);
		}
		
		public function get elementSelectors():Vector.<ElementSelector>
		{
			return this._elementSelectors;
		}
		
		public function get specificity():uint
		{
			var score:uint = 0;
			for(var i:uint=0; i < this._elementSelectors.length; i++)
			{
				score += this._elementSelectors[i];
			}
			return score;
		}
		
	}
	
}
package org.stylekit.css.style.selector
{
	
	import org.stylekit.css.style.selector.ElementSelector;
	
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
		
	}
	
}
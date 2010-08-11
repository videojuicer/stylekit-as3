package org.stylekit.css.parse
{
	
	import org.stylekit.css.style.selector.ElementSelectorChain;
	import org.stylekit.css.style.selector.ElementSelector;
	
	/**
	* The <code>ElementSelectorParser</code> is responsible for parsing an individual CSS selector statement such as
	* "div h1" or "p > a:last-child", and returning an ElementSelectorChain as the result.
	*/
	
	public class ElementSelectorParser
	{
		
		// Parser states
		protected static var ELEMENT_NAME:uint = 1;
		protected static var ELEMENT_ID:uint = 2;
		protected static var ELEMENT_CLASS:uint = 3;
		
		public function ElementSelectorParser()
		{
			
		}
		
		/**
		* Parses a full CSS selector statement, which may include multiple selector chains seperated by commas, e.g. "div h2, div h1:first-child"
		*/
		public function parseSelector(selector:String):Vector.<ElementSelectorChain>
		{
			var chainList:Vector.<ElementSelectorChain> = new Vector.<ElementSelectorChain>();
			
			return chainList;
		}
		
		/**
		* Parses a CSS selector chain consisting of space-delimited element selectors, e.g. "div h1:first-child"
		*/
		public function parseElementSelectorChain(selector:String):ElementSelectorChain
		{
			var selectorChain:ElementSelectorChain = new ElementSelectorChain();
			
			return selectorChain;
		}
		
		/**
		* Parses a CSS element selector consisting of a single element matcher e.g. "h1:first-child"
		*/ 
		public function parseElementSelector(selector:String):ElementSelector
		{
			var elementSelector:ElementSelector = new ElementSelector();
			
			return elementSelector;
		}
		
	}
	
}
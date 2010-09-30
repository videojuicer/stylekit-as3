package org.stylekit.css.parse
{
	import org.utilkit.util.StringUtil;
	import org.utilkit.logger.Logger;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.selector.ElementSelector;
	
	/**
	* The <code>ElementSelectorParser</code> is responsible for parsing an individual CSS selector statement such as
	* "div h1" or "p > a:last-child", and returning an ElementSelectorChain as the result.
	*/
	
	public class ElementSelectorParser
	{
		
		// Parser states
		protected static var ELEMENT_NAME:uint = 1;
		protected static var ELEMENT_ID:uint = 2;
		protected static var ELEMENT_CLASSNAME:uint = 3;
		protected static var ELEMENT_PSEUDOCLASS:uint = 4;
		
		public function ElementSelectorParser()
		{
			
		}
		
		/**
		* Parses a full CSS selector statement, which may include multiple selector chains seperated by commas, e.g. "div h2, div h1:first-child"
		*/
		public function parseSelector(selector:String):Vector.<ElementSelectorChain>
		{
			var chainList:Vector.<ElementSelectorChain> = new Vector.<ElementSelectorChain>();
			
			var selectorChains:Array = StringUtil.trim(selector).split(",");
			for(var i:uint = 0; i < selectorChains.length; i++)
			{
				chainList.push(this.parseElementSelectorChain(selectorChains[i]));
			}
			
			return chainList;
		}
		
		/**
		* Parses a CSS selector chain consisting of N element selectors, e.g. "div h1:first-child"
		* Allows spaces, ">" characters or a mix thereof to act as seperators.
		*/
		public function parseElementSelectorChain(selectorChainStr:String):ElementSelectorChain
		{
			selectorChainStr = StringUtil.trim(selectorChainStr);
			var selectorChain:ElementSelectorChain = new ElementSelectorChain();
			var token:String = "";
			var tokenOpened:Boolean = false; // Set to true when the opening character for a token is encountered
			var tokenClosed:Boolean = false; // Set to true when the closing character for a token is encountered
			var commitToken:Boolean = false; // Set to true when the string END or the start of a new token is encountered.
			
			var parentSelector:ElementSelector;
			var stowSelectorAsParentForNext:Boolean = false;
			
			for(var i:uint = 0; i < selectorChainStr.length+1; i++)
			{
				var char:String;
				if(i < selectorChainStr.length)
				{
					char = selectorChainStr.charAt(i);
				}
				else
				{
					char = "END";
				}
				
				if(char == " ")
				{
					if(tokenOpened) tokenClosed = true;
				}
				else if(char == ">")
				{
					// We know to use this selector as a parent requirement for the next selector
					stowSelectorAsParentForNext = true;
					if(tokenOpened) tokenClosed = true;
				}
				else if(char == "END")
				{
					if(tokenOpened) 
					{
						commitToken = true;
					}
				}
				else 
				{
					tokenOpened = true;
					if(tokenClosed)
					{
						commitToken = true;
						i--;
					}
					else
					{
						token += char;
					}
				}
				
				if(commitToken)
				{
					var selector:ElementSelector = parseElementSelector(token);
					
					if(parentSelector != null)
					{
						selector.parentSelector = parentSelector;
						parentSelector = null;
					}
					
					if(stowSelectorAsParentForNext == true)
					{
						parentSelector = selector;
						stowSelectorAsParentForNext = false;
					}
					
					selectorChain.addElementSelector(selector);
					token = "";
					tokenOpened = false;
					tokenClosed = false;
					commitToken = false;
				}
			}

			return selectorChain;
		}
		
		/**
		* Parses a CSS element selector consisting of a single element matcher e.g. "h1:first-child"
		*/ 
		public function parseElementSelector(selector:String):ElementSelector
		{
			var elementSelector:ElementSelector = new ElementSelector();
			
			var str:String = StringUtil.trim(selector);
			var parserPreviousState:uint = 0;
			var parserCurrentState:uint = ElementSelectorParser.ELEMENT_NAME;
			var token:String = "";
			var tokenBuilt:Boolean = false;
			
			for(var i:uint = 0; i <= str.length; i++) //  Loop deliberately overruns
			{
				var char:String;
				if(i < str.length) {
					char = str.charAt(i);
				}
				else
				{
					char = "END";
				}
				
				// Send parser into state for this token
				if(char == "#")
				{
					if(i > 0) tokenBuilt = true;
					parserPreviousState = parserCurrentState;
					parserCurrentState = ElementSelectorParser.ELEMENT_ID;
				}
				else if(char == ".")
				{
					if(i > 0) tokenBuilt = true;
					parserPreviousState = parserCurrentState;
					parserCurrentState = ElementSelectorParser.ELEMENT_CLASSNAME;
				}
				else if(char == ":")
				{
					if(i > 0) tokenBuilt = true;
					parserPreviousState = parserCurrentState;
					parserCurrentState = ElementSelectorParser.ELEMENT_PSEUDOCLASS;
				}
				else if(char == "END")
				{
					if(i > 0) tokenBuilt = true;
					parserPreviousState = parserCurrentState;
				}
				else if(char != " ")
				{
					// Keep building the token
					token += char;
				}
				
				if(tokenBuilt && token.length > 0)
				{
					switch(parserPreviousState)
					{
						case ElementSelectorParser.ELEMENT_NAME:
							// End the element name state
							StyleKit.logger.debug("Parsing element selector '"+str+"', built element name '"+token+"'", this);
							elementSelector.elementName = token;
							break;
						case ElementSelectorParser.ELEMENT_ID:
							StyleKit.logger.debug("Parsing element selector '"+str+"', built element ID '"+token+"'", this);
							elementSelector.elementID = token;
							break;
						case ElementSelectorParser.ELEMENT_CLASSNAME:
							StyleKit.logger.debug("Parsing element selector '"+str+"', built class name '"+token+"'", this);
							elementSelector.addElementClassName(token);
							break;
						case ElementSelectorParser.ELEMENT_PSEUDOCLASS:
							StyleKit.logger.debug("Parsing element selector '"+str+"', built pseudoclass '"+token+"'", this);
							elementSelector.addElementPseudoClass(token);
							break;
						default:
							break;
					}
					
					// Reset the token
					token = "";
					tokenBuilt = false;
				}
				
			}
			return elementSelector;
		}
		
	}
	
}
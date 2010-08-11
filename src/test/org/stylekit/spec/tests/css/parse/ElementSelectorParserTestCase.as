package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.spec.Fixtures;
	
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.style.selector.ElementSelectorChain;
	import org.stylekit.css.style.selector.ElementSelector;
	
	public class ElementSelectorParserTestCase
	{
		
		protected var _parser:ElementSelectorParser;
		protected var _parserResult:Vector.<ElementSelectorChain>;
		
		[Before]
		public function setUp():void
		{
			this._parser = new ElementSelectorParser();
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Ensures that a single selector is parsed correctly")]
		public function basicSingleSelectorParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("foo");
			Assert.assertEquals(1, this._parserResult.length);
		}
		
		[Test(description="Ensures that a chain of simple selectors is parsed correctly")]
		public function basicSelectorChainParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("foo bar");
			Assert.assertEquals(2, this._parserResult.length);
		}
		
	}
}
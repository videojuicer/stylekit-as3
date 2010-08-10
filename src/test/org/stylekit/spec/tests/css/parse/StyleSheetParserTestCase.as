package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.spec.Fixtures;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.parse.StyleSheetParser;
	
	public class StyleSheetParserTestCase
	{
		protected var _parser:StyleSheetParser;
		
		[Before]
		public function setUp():void
		{
			this._parser = new StyleSheetParser();
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Test parsing of the CSS_MIXED fixture and ensure that the resulting StyleSheet's content matches expectations")]
		public function mixedCSSParsesCorrectly():void
		{
			this._parser.parse(Fixtures.CSS_MIXED);
			Assert.assertEquals("", this._parser.logs.join("\n\r"));
		}
		
		
		
	}
}
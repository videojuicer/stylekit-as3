package org.stylekit.spec.tests.css
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
		
		
		
	}
}
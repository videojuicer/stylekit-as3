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
		protected var _parserResult:StyleSheet;
		
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
			this._parserResult = this._parser.parse(Fixtures.CSS_MIXED);
			
			// Correct number of styles
			Assert.assertEquals(6, this._parserResult.styles.length);
				// Correct properties on styles
				for(var i:uint=0; i < this._parserResult.styles.length; i++)
				{
					
				}
			// Correct number of font faces
			
			
				// Correct properties on fontfaces
			// Correct number of imports
			// Media block - correct number of styles marked with media restriction
			// Correct number of animations
				// Correct number of keyframes
		}
		
		
		
	}
}
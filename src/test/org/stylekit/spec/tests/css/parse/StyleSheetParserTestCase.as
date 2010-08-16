package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.spec.Fixtures;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.style.Animation;
	
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
			// Correct number of font faces
			Assert.assertEquals(1, this._parserResult.fontFaces.length);		
			// Correct number of imports
			Assert.assertEquals(2, this._parserResult.imports.length);
			
			// Media block - correct number of styles marked with media restriction
			var printStyles:uint = 0;
			for(var prn:uint=0; prn<this._parserResult.styles.length; prn++)
			{
				var s:Style = this._parserResult.styles[prn];
				if(s.mediaSelector != null)
				{
					if(s.mediaSelector.hasMedia("print"))
					{
						printStyles++;
					}
				}
			}
			Assert.assertEquals(2, printStyles);
			
			// Media block - correct number of styles with no restriction
			var allMediaStyles:uint = 0;
			for(var allMediaI:uint=0; allMediaI<this._parserResult.styles.length; allMediaI++)
			{
				var t:Style = this._parserResult.styles[allMediaI];
				if(t.mediaSelector == null)
				{
					allMediaStyles++;
				}
			}
			Assert.assertEquals(4, allMediaStyles);
			
			// Correct number of animations and keyframes
			Assert.assertEquals(1, this._parserResult.animations.length);
			Assert.assertEquals(2, (this._parserResult.animations[0] as Animation).keyFrames.length);
		}
		
		
		
	}
}
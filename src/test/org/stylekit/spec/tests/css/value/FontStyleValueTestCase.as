package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.FontStyleValue;

	public class FontStyleValueTestCase {
		
		protected var _result:FontStyleValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontStyleValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontStyleValue;
			
			result = FontStyleValue.parse("italic");
			Assert.assertEquals(result.fontStyle, FontStyleValue.FONT_STYLE_ITALIC);
			
			result = FontStyleValue.parse("nonsense");
			Assert.assertEquals(result.fontStyle, FontStyleValue.FONT_STYLE_NORMAL);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a FontStyleValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(FontStyleValue.identify("OBLIQUE"));
			Assert.assertTrue(FontStyleValue.identify("italic   "));
			Assert.assertFalse(FontStyleValue.identify("nonsense"));
		}
		
	}
}
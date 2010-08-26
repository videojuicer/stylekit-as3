package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.FontCompoundValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;

	public class FontCompoundValueTestCase {
		
		protected var _result:FontCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontCompoundValue;
			
			result = FontCompoundValue.parse("3.4em");
			Assert.assertEquals(3.4, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			
			result = FontCompoundValue.parse("5px red arial small-caps 700");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("px", result.sizeValue.units);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("arial", result.fontFaceValue.stringValue);
			Assert.assertEquals(FontVariantValue.FONT_VARIANT_SMALL_CAPS, result.fontVariantValue.fontVariant);
			Assert.assertEquals(FontWeightValue.FONT_WEIGHT_BOLD, result.fontWeightValue.fontWeight);
		}
		
	}
}
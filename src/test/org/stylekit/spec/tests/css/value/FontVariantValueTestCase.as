package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.FontVariantValue;

	public class FontVariantValueTestCase {
		
		protected var _result:FontVariantValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontVariantValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontVariantValue;
			
			result = FontVariantValue.parse("small-caps");
			Assert.assertEquals(result.fontVariant, FontVariantValue.FONT_VARIANT_SMALL_CAPS);
			
			result = FontVariantValue.parse("nonsense");
			Assert.assertEquals(result.fontVariant, FontVariantValue.FONT_VARIANT_NORMAL);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a FontVariantValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(FontVariantValue.identify("SMALL-CAPS"));
			Assert.assertTrue(FontVariantValue.identify("normal   "));
			Assert.assertFalse(FontVariantValue.identify("nonsense"));
		}
		
	}
}
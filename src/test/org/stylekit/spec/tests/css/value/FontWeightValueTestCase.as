package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.FontWeightValue;

	public class FontWeightValueTestCase {
		
		protected var _result:FontWeightValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontWeightValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontWeightValue;
			
			result = FontWeightValue.parse("bold");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_BOLD);
			
			result = FontWeightValue.parse("700");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_BOLD);
			
			result = FontWeightValue.parse("nonsense");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_NORMAL);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a FontWeightValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(FontWeightValue.identify("normal"));
			Assert.assertTrue(FontWeightValue.identify("800   "));
			Assert.assertFalse(FontWeightValue.identify("nonsense"));
			Assert.assertFalse(FontWeightValue.identify("650"));
		}
		
	}
}
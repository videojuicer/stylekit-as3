package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.SizeValue;

	public class SizeValueTestCase {
		
		protected var _result:SizeValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid SizeValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:SizeValue;
			
			result = SizeValue.parse("3.4em");
			Assert.assertEquals(3.4, result.value);
			Assert.assertEquals("em", result.units);
			
			result = SizeValue.parse("3000%");
			Assert.assertEquals(3000, result.value);
			Assert.assertEquals("%", result.units);
			
			result = SizeValue.parse("3.1 em");
			Assert.assertEquals(3.1, result.value);
			Assert.assertEquals("em", result.units);
			
			result = SizeValue.parse("0");
			Assert.assertEquals(0, result.value);
			Assert.assertEquals("px", result.units);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a SizeValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(SizeValue.identify("30px"));
			Assert.assertTrue(SizeValue.identify("50%"));
			Assert.assertTrue(SizeValue.identify("3em"));
			Assert.assertFalse(SizeValue.identify("px"));
			Assert.assertFalse(SizeValue.identify("5"));
		}
		
	}
}
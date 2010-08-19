package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.BackgroundCompoundValue;

	public class BackgroundCompoundValueTestCase {
		
		protected var _result:BackgroundCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			var result:BackgroundCompoundValue;
			
			result = BackgroundCompoundValue.parse("red");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals(null, result.urlValue);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);

			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\")");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\") repeat-x");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\") repeat bottom right");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertTrue(result.repeatValue.verticalRepeat);
			Assert.assertTrue(result.alignmentValue.bottomAlign);
			Assert.assertTrue(result.alignmentValue.rightAlign);
			
			result = BackgroundCompoundValue.parse("url(\"foo.css\") no-repeat");
			Assert.assertEquals(null, result.colorValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertFalse(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid BackgroundCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			
		}
		
	}
}
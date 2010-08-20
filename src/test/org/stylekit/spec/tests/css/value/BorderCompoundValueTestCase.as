package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ColorValue;

	import org.stylekit.css.value.BorderCompoundValue;

	public class BorderCompoundValueTestCase {
		
		protected var _result:BorderCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid BorderCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:BorderCompoundValue;
			
			result = BorderCompoundValue.parse("5em dashed red");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			Assert.assertEquals(LineStyleValue.LINE_STYLE_DASHED, result.lineStyleValue.lineStyle);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			
			result = BorderCompoundValue.parse("red");
			Assert.assertEquals(null, result.sizeValue);
			Assert.assertEquals(null, result.lineStyleValue);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			
			result = BorderCompoundValue.parse("5em red");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			Assert.assertEquals(null, result.lineStyleValue);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
		}
		
	}
}//
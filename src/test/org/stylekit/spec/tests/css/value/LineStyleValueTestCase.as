package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.LineStyleValue;

	public class LineStyleValueTestCase {
		
		protected var _result:LineStyleValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid LineStyleValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:LineStyleValue;
			
			result = LineStyleValue.parse("double");
			Assert.assertEquals(result.lineStyle, LineStyleValue.LINE_STYLE_DOUBLE);
			
			result = LineStyleValue.parse("nonsense");
			Assert.assertEquals(result.lineStyle, LineStyleValue.LINE_STYLE_NONE);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a LineStyleValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(LineStyleValue.identify("NONE"));
			Assert.assertTrue(LineStyleValue.identify("double   "));
			Assert.assertFalse(LineStyleValue.identify("nonsense"));
		}
		
	}
}
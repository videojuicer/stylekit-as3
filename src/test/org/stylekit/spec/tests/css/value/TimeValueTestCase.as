package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.TimeValue;
	import org.stylekit.ui.element.UIElement;

	public class TimeValueTestCase {
		
		protected var _result:TimeValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid TimeValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TimeValue;
			
			result = TimeValue.parse("10ms");
			Assert.assertEquals(TimeValue.UNIT_MILLISECONDS, result.units);
			Assert.assertEquals(10, result.millisecondValue);
			
			result = TimeValue.parse("10s");
			Assert.assertEquals(TimeValue.UNIT_SECONDS, result.units);
			Assert.assertEquals(10*1000, result.millisecondValue);
			
			result = TimeValue.parse("5m");
			Assert.assertEquals(TimeValue.UNIT_MINUTES, result.units);
			Assert.assertEquals(5*60*1000, result.millisecondValue);
			
			result = TimeValue.parse("0.1h");
			Assert.assertEquals(TimeValue.UNIT_HOURS, result.units);
			Assert.assertEquals(0.1*60*60*1000, result.millisecondValue);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TimeValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertFalse(TimeValue.identify("0.1"));
			Assert.assertFalse(TimeValue.identify("10px"));
			
			Assert.assertTrue(TimeValue.identify("0.1s"));
			Assert.assertTrue(TimeValue.identify("0.1ms"));
			Assert.assertTrue(TimeValue.identify("10h"));
		}
		
	}
}
package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.ui.element.UIElement;

	public class TimingFunctionValueTestCase {
		
		protected var _result:TimingFunctionValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid TimingFunctionValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TimingFunctionValue;
			
			result = TimingFunctionValue.parse("ease-in");
			Assert.assertEquals(TimingFunctionValue.EASING_EASE_IN, result.timingFunction);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TimingFunctionValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(TimingFunctionValue.identify("ease-in"));
			Assert.assertFalse(TimingFunctionValue.identify("nonsense"));
		}
		
	}
}
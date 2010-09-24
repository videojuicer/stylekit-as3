package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.ui.element.UIElement;
	
	import flash.geom.Point;

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
			
			result = TimingFunctionValue.parse("cubic-bezier(0.1,0.2,0.3,0.4)");
			Assert.assertEquals(TimingFunctionValue.EASING_CUSTOM, result.timingFunction);
			Assert.assertEquals(result.p1.x, 0.1);
			Assert.assertEquals(result.p1.y, 0.2);
			Assert.assertEquals(result.p2.x, 0.3);
			Assert.assertEquals(result.p2.y, 0.4);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TimingFunctionValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(TimingFunctionValue.identify("ease-in"));
			Assert.assertTrue(TimingFunctionValue.identify("cubic-bezier(1,2,3,4)"));
			Assert.assertFalse(TimingFunctionValue.identify("nonsense"));
		}
		
	}
}
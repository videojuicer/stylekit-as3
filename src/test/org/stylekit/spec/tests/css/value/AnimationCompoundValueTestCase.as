package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.AnimationCompoundValue;
	import org.stylekit.ui.element.UIElement;
	
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.AnimationIterationCountValue;
	import org.stylekit.css.value.AnimationDirectionValue;
	import org.stylekit.css.value.TimeValue;

	public class AnimationCompoundValueTestCase {
		
		protected var _result:AnimationCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid AnimationCompoundValueTestCase object.")]
		public function stringParsesCorrectly():void
		{
			var result:AnimationCompoundValue;
			
			/*
			foo 1s ease-in 2s 0
			*/
			
			result = AnimationCompoundValue.parse("anim1 1s ease-in 2s 0 alternate anim2 3s ease-out 0 normal");
			Assert.assertEquals(2, result.animationNameValue.values.length);
			Assert.assertEquals("anim1", result.animationNameValue.valueAt(0).stringValue);
			Assert.assertEquals("anim2", result.animationNameValue.valueAt(1).stringValue);
			
			Assert.assertEquals(2, result.animationDurationValue.values.length);
			Assert.assertEquals(1000, (result.animationDurationValue.valueAt(0) as TimeValue).millisecondValue);
			Assert.assertEquals(3000, (result.animationDurationValue.valueAt(1) as TimeValue).millisecondValue);
			
			Assert.assertEquals(2, result.animationTimingFunctionValue.values.length);
			Assert.assertEquals(TimingFunctionValue.EASING_EASE_IN, (result.animationTimingFunctionValue.valueAt(0) as TimingFunctionValue).timingFunction);
			Assert.assertEquals(TimingFunctionValue.EASING_EASE_OUT, (result.animationTimingFunctionValue.valueAt(1) as TimingFunctionValue).timingFunction);
			
			Assert.assertEquals(1, result.animationDelayValue.values.length);
			Assert.assertEquals(2000, (result.animationDelayValue.valueAt(0) as TimeValue).millisecondValue);
			Assert.assertEquals(2000, (result.animationDelayValue.valueAt(1) as TimeValue).millisecondValue);
			
			Assert.assertEquals(2, result.animationDirectionValue.values.length);
			Assert.assertEquals(AnimationDirectionValue.DIRECTION_ALTERNATE, (result.animationDirectionValue.valueAt(0) as AnimationDirectionValue).direction);
			Assert.assertEquals(AnimationDirectionValue.DIRECTION_NORMAL, (result.animationDirectionValue.valueAt(1) as AnimationDirectionValue).direction);
			
			Assert.assertEquals(2, result.animationIterationCountValue.values.length);
			Assert.assertEquals(0, (result.animationIterationCountValue.valueAt(0) as AnimationIterationCountValue).iterationCount);
			Assert.assertEquals(0, (result.animationIterationCountValue.valueAt(1) as AnimationIterationCountValue).iterationCount);
		}
	}
}

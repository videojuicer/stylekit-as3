package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.TransitionCompoundValue;
	import org.stylekit.ui.element.UIElement;

	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.TimeValue;

	public class TransitionCompoundValueTestCase {
		
		protected var _result:TransitionCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid TransitionCompoundValueTestCase object.")]
		public function stringParsesCorrectly():void
		{
			var result:TransitionCompoundValue;
			
			
			result = TransitionCompoundValue.parse("padding-left 5s ease 10s");
			// transition-property
			Assert.assertEquals(1, result.transitionPropertyValue.properties.length);
			Assert.assertTrue(result.transitionPropertyValue.hasProperty("padding-left"));
			Assert.assertFalse(result.transitionPropertyValue.hasProperty("padding-right"));
			// transition-duration
			Assert.assertEquals(1, result.transitionDurationValue.values.length)
			Assert.assertEquals(5000, (result.transitionDurationValue.valueAt(0) as TimeValue).millisecondValue);
			// transition-timing-function
			Assert.assertEquals(1, result.transitionTimingFunctionValue.values.length);
			Assert.assertEquals(TimingFunctionValue.EASING_EASE, (result.transitionTimingFunctionValue.valueAt(0) as TimingFunctionValue).timingFunction);
			// transition-delay
			Assert.assertEquals(1, result.transitionDelayValue.values.length);
			Assert.assertEquals(10000, (result.transitionDelayValue.valueAt(0) as TimeValue).millisecondValue);
			
			result = TransitionCompoundValue.parse("padding-left 5s ease");
			// transition-delay
			Assert.assertEquals(1, result.transitionDelayValue.values.length);
			Assert.assertEquals(0, (result.transitionDelayValue.valueAt(0) as TimeValue).millisecondValue);
			
			result = TransitionCompoundValue.parse("padding-left 1s ease-in 2s padding-right 3s ease-out 4s");
			// transition-property
			Assert.assertEquals(2, result.transitionPropertyValue.properties.length);
			Assert.assertTrue(result.transitionPropertyValue.hasProperty("padding-left"));
			Assert.assertTrue(result.transitionPropertyValue.hasProperty("padding-right"));
			Assert.assertFalse(result.transitionPropertyValue.hasProperty("top"));
			// transition-duration
			Assert.assertEquals(2, result.transitionDurationValue.values.length)
			Assert.assertEquals(1000, (result.transitionDurationValue.valueAt(0) as TimeValue).millisecondValue);
			Assert.assertEquals(3000, (result.transitionDurationValue.valueAt(1) as TimeValue).millisecondValue);
			// transition-timing-function
			Assert.assertEquals(2, result.transitionTimingFunctionValue.values.length);
			Assert.assertEquals(TimingFunctionValue.EASING_EASE_IN, (result.transitionTimingFunctionValue.valueAt(0) as TimingFunctionValue).timingFunction);
			Assert.assertEquals(TimingFunctionValue.EASING_EASE_OUT, (result.transitionTimingFunctionValue.valueAt(1) as TimingFunctionValue).timingFunction);
			// transition-delay
			Assert.assertEquals(2, result.transitionDelayValue.values.length);
			Assert.assertEquals(2000, (result.transitionDelayValue.valueAt(0) as TimeValue).millisecondValue);
			Assert.assertEquals(4000, (result.transitionDelayValue.valueAt(1) as TimeValue).millisecondValue);
		}
		
	}
}
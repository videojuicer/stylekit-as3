/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is the StyleKit library.
 *
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 *
 * ***** END LICENSE BLOCK ***** */
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
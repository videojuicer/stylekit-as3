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

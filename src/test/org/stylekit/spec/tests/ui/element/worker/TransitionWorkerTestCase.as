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
package org.stylekit.spec.tests.ui.element.worker
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.ui.element.worker.TransitionWorker;
	import org.stylekit.events.TransitionWorkerEvent;
	import org.stylekit.ui.element.UIElement;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.Value;

	public class TransitionWorkerTestCase {
		
		
		protected var _worker:TransitionWorker;
		protected var _element:UIElement;
		
		protected var _iColor:ColorValue;
		protected var _eColor:ColorValue;
		protected var _iSize:SizeValue;
		protected var _eSize:SizeValue;
		
		protected var _events:Vector.<TransitionWorkerEvent>;
		protected var _cValues:Vector.<ColorValue>;
		protected var _sValues:Vector.<SizeValue>;
		
		[Before]
		public function setUp():void
		{
			this._element = new UIElement();
			this._element.evaluatedStyles = {
				"display": DisplayValue.parse("block"), 
				"width": SizeValue.parse("500px"), 
				"height": SizeValue.parse("500px")
			};
			
			this._iColor = ColorValue.parse("#0000FF");
			this._eColor = ColorValue.parse("#FF0000");
			
			this._iSize = SizeValue.parse("50px");
			this._eSize = SizeValue.parse("-100px");
			
			this._events = new Vector.<TransitionWorkerEvent>();
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(async, description="Ensures that the delay is run before any new values are computed")]
		public function delayAllowedToRunBeforeTimerActivated():void
		{
			var worker:TransitionWorker = new TransitionWorker(
				this._element, this._iColor, this._eColor, 
				TimeValue.parse("1s"), TimeValue.parse("3s"), TimingFunctionValue.parse("linear")
			);
			var async:Function = Async.asyncHandler(
				this, this.onDelayedWorkerIntermediateValue, 2000, 
				{ "worker": worker, "baseline": new Date() }, 
				this.onDelayedWorkerTimeout
			);
			
			worker.addEventListener(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, async);
			worker.start();
			
		}
				// Async
				public function onDelayedWorkerIntermediateValue(e:TransitionWorkerEvent, passthru:Object):void
				{
					var delta:Number = (new Date()).getTime() - (passthru.baseline as Date).getTime();
					Assert.assertTrue(delta >= 1000);
					
					// Kill everything
					(passthru.worker as TransitionWorker).cancel();
				}
				public function onDelayedWorkerTimeout(passThru:Object):void
				{
					Assert.fail("Timed out waiting for delay timer to expire");
				}
			

		
		[Test(async, description="Ensures that a proper selection of values is generated during a ColorValue transition")]
		public function intermediateColorValuesAreGenerated():void
		{
			var worker:TransitionWorker = new TransitionWorker(
				this._element, this._iColor, this._eColor, 
				TimeValue.parse("0s"), TimeValue.parse("3s"), TimingFunctionValue.parse("linear")
			);
			var fAsync:Function = Async.asyncHandler(
				this, this.onColorValueTransitionFinalValue, 3500, 
				{ "worker": worker }, 
				this.onColorValueTransitionTimeout
			);
			
			worker.addEventListener(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, this.onColorValueTransitionIntermediateValue);
			worker.addEventListener(TransitionWorkerEvent.FINAL_VALUE_GENERATED, fAsync);
			worker.start();
			this._cValues = new Vector.<ColorValue>();
		}
			public function onColorValueTransitionIntermediateValue(e:TransitionWorkerEvent):void
			{
				Assert.assertTrue(e.value is ColorValue);
				Assert.assertTrue(e.value != this._eColor);
				if(this._cValues.length > 0)
				{
					Assert.assertTrue((e.value as ColorValue).hexValue > this._cValues[this._cValues.length-1].hexValue); 
					// ^^ change from pure blue to pure red means a straight increase in integer color value	
				}
				this._cValues.push(e.value as ColorValue);
			}
			public function onColorValueTransitionFinalValue(e:TransitionWorkerEvent, passthru:Object):void
			{
				Assert.assertEquals(e.value, this._eColor);
				Assert.assertTrue(passthru.worker.runningTimerOffset >= 3000);
				Assert.assertTrue(passthru.worker.frameCount == this._cValues.length+1);
			}
			public function onColorValueTransitionTimeout(passthru:Object):void
			{
				Assert.fail("Timed out waiting for color transition to end")
			}
		
		// ensure cancelling emits the latest computed value
		// ensure finishing early emits the final value
	}
}
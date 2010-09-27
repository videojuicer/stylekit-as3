package org.stylekit.ui.element.worker
{
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	// tweenables
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.NumericValue;
	
	// events
	import org.stylekit.events.TransitionWorkerEvent;
	
	// consumed
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.ui.element.UIElement;
	
	/**
	* A TransitionWorker instance is responsible for animating a change to a single style property on a single element.
	* Over time, the TransitionWorker generates new intermediate values which the receiving element may apply.
	*/
	public class TransitionWorker extends EventDispatcher
	{
		
		protected static var FRAMERATE:Number = 10;
		
		protected var _element:UIElement;
		protected var _initialValue:Value;
		protected var _endValue:Value;
		
		protected var _delay:TimeValue;
		protected var _duration:TimeValue;
		protected var _timingFunction:TimingFunctionValue;
		
		protected var _delayTimer:Timer;
		protected var _runningTimer:Timer;
		protected var _runningTimerBaseline:Date;
		protected var _runningTimerOffset:int = 0;
		
		protected var _t:Number = 0.0;
		protected var _maxT:Number = 1.0;
		
		protected var _intermediateValue:Value; // stores the last-generated intermediate value
		protected var _frameCount:int = 0;
		
		public function TransitionWorker(element:UIElement, initialValue:Value, endValue:Value, delay:TimeValue, duration:TimeValue, timingFunction:TimingFunctionValue)
		{
			this._element = element;
			this._initialValue = initialValue;
			this._endValue = endValue;
			
			this._delay = delay;
			this._duration = duration;
			this._timingFunction = timingFunction;
		}
		
		public function get runningTimerOffset():int
		{
			return this._runningTimerOffset;
		}
		
		public function get frameCount():int
		{
			return this._frameCount;
		}
		
		/**
		* Waits the specified delay and then starts generating intermediate values based on the timer, easing function and constraining values.
		*/
		public function start():void
		{
			if(this._delay.millisecondValue <= 0)
			{
				this.initRunningTimer();
			}
			else
			{
				// set up the delay timer as a once-only execution
				this._delayTimer = new Timer(this._delay.millisecondValue, 1);
				this._delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onDelayTimerCompleted);
				this._delayTimer.start();
			}
		}
		
		/**
		* Terminates the transition
		*/
		public function cancel():void
		{
			this.killTimers();
		}
		
		/**
		* Terminates the transition, emitting the endValue as the final value; effectively commands the transition to finish early.
		*/
		public function finish():void
		{
			this.killTimers();
			this.dispatchEvent(new TransitionWorkerEvent(TransitionWorkerEvent.FINAL_VALUE_GENERATED, this._endValue));
		}
		
		/**
		* Sets up and begins the transition itself
		*/
		protected function initRunningTimer():void
		{
			this.killTimers();
			this._runningTimerBaseline = new Date();
			this._frameCount = 0;
			this._runningTimerOffset = 0;
			this._runningTimer = new Timer(1000/TransitionWorker.FRAMERATE);
			this._runningTimer.addEventListener(TimerEvent.TIMER, this.onRunningTimerTick);
			this._runningTimer.start();
		}
		
		protected function killTimers():void
		{
			if(this._runningTimer)
			{
				this._runningTimer.stop();
				this._runningTimer.removeEventListener(TimerEvent.TIMER, this.onRunningTimerTick);
				this._runningTimer = null;
			}
			if(this._delayTimer)
			{
				this._delayTimer.stop();
				this._delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onDelayTimerCompleted);
				this._delayTimer = null;
			}
		}
		
		protected function onDelayTimerCompleted(e:TimerEvent = null):void
		{
			this.killTimers();
			this.initRunningTimer();
		}
		
		protected function onRunningTimerTick(e:TimerEvent):void
		{
			// calculate elapsed time
			var delta:Date = new Date();
			var deltaOffset:Number = (delta.getTime() - this._runningTimerBaseline.getTime());
			this._runningTimerOffset += deltaOffset;
			this._frameCount++;
			
			if(this._runningTimerOffset >= this._duration.millisecondValue)
			{
				// finish
				this.finish();
			}
			else
			{
				// calculate t value
				var t:Number = (this._runningTimerOffset as Number)/(this._duration.millisecondValue as Number);
				var tValue:Number = this._timingFunction.compute(t);
				// generate a new intermediate value
				if((this._initialValue is ColorValue) && (this._endValue is ColorValue))
				{
					// compute intermediate color value
					var iColorVal:ColorValue = new ColorValue();
					
						var initC:ColorValue = this._initialValue as ColorValue;
						var endC:ColorValue = this._endValue as ColorValue;
						var startR:int 	= (initC.hexValue & 0xFF0000) >> 16;
						var startG:int 	= (initC.hexValue & 0x00FF00) >> 8;
						var startB:int 	= (initC.hexValue & 0x0000FF);
						var endR:int 	= (endC.hexValue & 0xFF0000) >> 16;
						var endG:int 	= (endC.hexValue & 0x00FF00) >> 8;
						var endB:int 	= (endC.hexValue & 0x0000FF);
						
						var iColor:Number = (startR+((endR-startR)*tValue) << 16)+ // red
											(startG+((endG-startG)*tValue) << 8)+ // green
											(startB+((endB-startB)*tValue)); // blue
						iColorVal.hexValue = iColor;
						
					this._intermediateValue = iColorVal;
					this.dispatchEvent(new TransitionWorkerEvent(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, iColorVal));
				}
				else if((this._initialValue is SizeValue) && (this._endValue is SizeValue))
				{
					// compute intermediate size based on given element
					var iSizeVal:SizeValue = new SizeValue();
					iSizeVal.units = SizeValue.UNIT_PIXELS;
					
						// calcualte intermediate size value
						var startSize:Number = (this._initialValue as SizeValue).evaluateSize(this._element);
						var endSize:Number = (this._endValue as SizeValue).evaluateSize(this._element);
						
					iSizeVal.value = startSize+((endSize-startSize)*tValue);
					
					this._intermediateValue = iSizeVal;
					this.dispatchEvent(new TransitionWorkerEvent(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, iSizeVal));
				}
				else if((this._initialValue is NumericValue) && (this._endValue is NumericValue))
				{
					var iNumVal:NumericValue = new NumericValue();
					
						// calcualte intermediate size value
						var startVal:Number = (this._initialValue as NumericValue).value;
						var endVal:Number = (this._endValue as SizeValue).value;
					
					iNumVal.value = startVal+((endVal-startVal)*tValue);
				
					this._intermediateValue = iNumVal;
					this.dispatchEvent(new TransitionWorkerEvent(TransitionWorkerEvent.INTERMEDIATE_VALUE_GENERATED, iNumVal));
				}
				else
				{
					// values are not tweenable or not intertwinglable, don't generate intermediate values
					// instead just let the loop run until the duration has concluded - the final value will be emitted at that point.
				}
			}
		}
		
	}
}
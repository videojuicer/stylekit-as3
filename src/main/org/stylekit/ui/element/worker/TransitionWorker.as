package org.stylekit.ui.element.worker
{
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	// tweenables
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	
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
		
		protected var _element:UIElement;
		protected var _initialValue:Value;
		protected var _endValue:Value;
		
		protected var _delay:TimeValue;
		protected var _duration:TimeValue;
		protected var _timingFunction:TimingFunctionValue;
		
		protected var _t:Number = 0.0;
		protected var _maxT:Number = 1.0;
		
		public function TransitionWorker(element:UIElement, initialValue:Value, endValue:Value, delay:TimeValue, duration:TimeValue, timingFunction:TimingFunctionValue)
		{
			this._element = element;
			this._initialValue = initialValue;
			this._endValue = endValue;
			
			this._delay = delay;
			this._duration = duration;
			this._timingFunction = timingFunction;
		}
		
		/**
		* Waits the specified delay and then starts generating intermediate values based on the timer, easing function and constraining values.
		*/
		public function start():void
		{
			
		}
		
		/**
		* Terminates the transition, emitting the initialValue as the final value.
		*/
		public function cancel():void
		{
			
		}
		
		/**
		* Terminates the transition, emitting the endValue as the final value; effectively commands the transition to finish early.
		*/
		public function finish():void
		{
			
		}
		
		protected function onDelayTimer(e:TimerEvent):void
		{
			
		}
		
		protected function onIntervalTimer(e:TimerEvent):void
		{
			// generate a new timer
		}
		
	}
}
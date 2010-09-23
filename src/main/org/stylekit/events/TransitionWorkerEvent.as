package org.stylekit.events
{
	import flash.events.Event;
	import org.stylekit.css.value.Value;
	
	public class TransitionWorkerEvent extends Event
	{
		public static var INTERMEDIATE_VALUE_GENERATED:String = "transitionWorkerIntermediateValueGenerated";
		public static var FINAL_VALUE_GENERATED:String = "transitionWorkerFinalValueGenerated";
		
		protected var _value:Value;
		
		public function TransitionWorkerEvent(type:String, value:Value, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get value():Value
		{
			return this._value;
		}
	}
}
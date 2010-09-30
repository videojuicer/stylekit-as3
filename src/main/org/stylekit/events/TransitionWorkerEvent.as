package org.stylekit.events
{
	import flash.events.Event;
	import org.stylekit.css.value.Value;
	import org.stylekit.ui.element.worker.TransitionWorker;
	
	public class TransitionWorkerEvent extends Event
	{
		public static var INTERMEDIATE_VALUE_GENERATED:String = "transitionWorkerIntermediateValueGenerated";
		public static var FINAL_VALUE_GENERATED:String = "transitionWorkerFinalValueGenerated";
		
		protected var _value:Value;
		protected var _worker:TransitionWorker;
		
		public function TransitionWorkerEvent(type:String, value:Value, worker:TransitionWorker, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._value = value;
			this._worker = worker;
		}
		
		public function get value():Value
		{
			return this._value;
		}
		
		public function get worker():TransitionWorker
		{
			return this._worker;
		}
	}
}
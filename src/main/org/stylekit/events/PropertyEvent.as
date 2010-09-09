package org.stylekit.events
{
	import flash.events.Event;
	
	public class PropertyEvent extends Event
	{
		public static var PROPERTY_MODIFIED:String = "propertyModified";
		
		protected var _valueEvent:ValueEvent;
		
		public function PropertyEvent(type:String, valueEvent:ValueEvent = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._valueEvent = valueEvent;
		}
		
		public function get valueEvent():ValueEvent
		{
			return this._valueEvent;
		}
		
		public function get previousEvent():Event
		{
			return this.valueEvent;
		}
	}
}
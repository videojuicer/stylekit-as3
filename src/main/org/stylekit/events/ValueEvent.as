package org.stylekit.events
{
	import flash.events.Event;
	
	public class ValueEvent extends Event
	{
		public static var VALUE_MODIFIED:String = "valueModified";
		
		public function ValueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
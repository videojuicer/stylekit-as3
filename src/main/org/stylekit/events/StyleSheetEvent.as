package org.stylekit.events
{
	import flash.events.Event;
	
	public class StyleSheetEvent extends Event
	{
		public static var STYLESHEET_MODIFIED:String = "styleSheetModified";
		
		public function StyleSheetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
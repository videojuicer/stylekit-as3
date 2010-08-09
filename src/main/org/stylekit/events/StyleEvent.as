package org.stylekit.events
{
	
	import flash.events.Event;
	import org.stylekit.css.style.Style;
	
	public class StyleEvent extends Event
	{
		
		public static var MUTATION:String = "styleMutation";
		
		protected var _style:Style;
		
		public function StyleEvent(type:String, style:Style, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._style = style;
		}
		
		public function get style():Style
		{
			return this._style;
		}
		
	}
	
}
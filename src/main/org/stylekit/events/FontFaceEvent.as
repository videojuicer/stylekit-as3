package org.stylekit.events
{
	
	import flash.events.Event;
	import org.stylekit.css.style.FontFace;
	
	public class FontFaceEvent extends Event
	{
		
		public static var MUTATION:String = "fontFaceMutation";
		
		protected var _fontFace:FontFace;
		
		public function FontFaceEvent(type:String, fontFace:FontFace, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._fontFace = fontFace;
		}
		
		public function get fontFace():FontFace
		{
			return this._fontFace;
		}
		
	}
	
}
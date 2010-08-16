package org.stylekit.css.style
{
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.PropertyContainer;
	
	public class AnimationKeyFrame extends PropertyContainer
	{
		
		/**
		* The time variable on the keyframe block. In the declaration '@keyframes foo { 0% { ... }}', the time selector on the keyframe is "0%".
		*/
		protected var _timeSelector:String;
		
		public function AnimationKeyFrame(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
		}
		
		public function get timeSelector():String
		{
			return this._timeSelector;
		}
		
		public function set timeSelector(ts:String):void
		{
			this._timeSelector = ts;
		}
	}
	
}
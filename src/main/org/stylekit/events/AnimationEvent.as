package org.stylekit.events
{
	
	import flash.events.Event;
	import org.stylekit.css.style.Animation;
	
	public class AnimationEvent extends Event
	{
		
		public static var MUTATION:String = "animationMutation";
		
		protected var _animation:Animation;
		
		public function AnimationEvent(type:String, animation:Animation, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._animation = animation;
		}
		
		public function get animation():Animation
		{
			return this._animation;
		}
		
	}
	
}
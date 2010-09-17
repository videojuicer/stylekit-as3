package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class AnimationDirectionValue extends Value
	{
		
		public static var DIRECTION_NORMAL:String = "normal";
		public static var DIRECTION_ALTERNATE:String = "alternate";
		
		protected var _direction:String = "normal";
		
		public function AnimationDirectionValue()
		{
			super();
		}
		
		public function get direction():String
		{
			return this._direction;
		}
		
		public function set direction(d:String):void
		{
			this._direction = d;
			this.modified();
		}
		
		public static function parse(str:String):AnimationDirectionValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var val:AnimationDirectionValue = new AnimationDirectionValue();
				// parser code here
				if(str == AnimationDirectionValue.DIRECTION_NORMAL || str == AnimationDirectionValue.DIRECTION_ALTERNATE)
				{
					val.direction = str;
				}
				
			return val;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			return (str == AnimationDirectionValue.DIRECTION_NORMAL || str == AnimationDirectionValue.DIRECTION_ALTERNATE);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is AnimationDirectionValue)
			{
				return (this.direction == (other as AnimationDirectionValue).direction);
			}
			return false;
		}
	}
}
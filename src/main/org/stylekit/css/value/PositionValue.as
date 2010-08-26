package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class PositionValue extends Value
	{
		public static var POSITION_STATIC:uint = 0;
		public static var POSITION_RELATIVE:uint = 1;
		public static var POSITION_ABSOLUTE:uint = 2;
		public static var POSITION_FIXED:uint = 3;
		public static var POSITION_INHERIT:uint = 4;
		
		protected var _position:uint = PositionValue.POSITION_STATIC;
		
		protected static var validStrings:Array = [
			"static", "relative", "absolute", "fixed", "inherit"
		];
		
		public function PositionValue()
		{
			super();
		}
		
		public function get position():uint
		{
			return this._position;
		}
		
		public function set position(position:uint):void
		{
			this._position = position;
		}
		
		public static function parse(str:String):PositionValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:PositionValue = new PositionValue();
			value.rawValue = str;
			
			value.position = Math.max(0, PositionValue.validStrings.indexOf(str));
			
			return value;
		}
	}
}
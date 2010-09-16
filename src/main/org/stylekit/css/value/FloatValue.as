package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class FloatValue extends Value
	{
		public static var FLOAT_LEFT:uint = 0;
		public static var FLOAT_RIGHT:uint = 1;
		public static var FLOAT_NONE:uint = 2;
		
		protected var _float:uint = FloatValue.FLOAT_NONE;
		
		protected static var validStrings:Array = [
			"left", "right", "none"
		];
		
		public function FloatValue()
		{
			super();
		}
		
		public function get float():uint
		{
			return this._float;
		}
		
		public function set float(float:uint):void
		{
			this._float = float;
			
			this.modified();
		}
		
		public static function parse(str:String):FloatValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:FloatValue = new FloatValue();
			value.rawValue = str;
			
			value.float = Math.max(0, FloatValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (FloatValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FloatValue)
			{
				return (this.float == (other as FloatValue).float);
			}
			
			return super.isEquivalent(other);
		}
	}
}
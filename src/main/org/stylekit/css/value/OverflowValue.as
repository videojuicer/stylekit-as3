package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class OverflowValue extends Value
	{
		public static var OVERFLOW_VISIBLE:uint = 0;
		public static var OVERFLOW_HIDDEN:uint = 1;
		public static var OVERFLOW_SCROLL:uint = 2;
		public static var OVERFLOW_AUTO:uint = 3;
		
		protected var _overflow:uint = OverflowValue.OVERFLOW_VISIBLE;
		
		protected static var validStrings:Array = [
			"visible", "hidden", "scroll", "auto"
		];
		
		public function OverflowValue()
		{
			super();
		}
		
		public function get overflow():uint
		{
			return this._overflow;
		}
		
		public function set overflow(overflow:uint):void
		{
			this._overflow = overflow;
		}
		
		public static function parse(str:String):OverflowValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:OverflowValue = new OverflowValue();
			value.rawValue = str;
			
			value.overflow = Math.max(0, OverflowValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (OverflowValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is OverflowValue)
			{
				return (this.overflow == (other as OverflowValue).overflow);
			}
			
			return super.isEquivalent(other);
		}
	}
}
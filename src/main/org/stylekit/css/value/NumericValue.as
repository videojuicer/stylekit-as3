package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class NumericValue extends Value
	{
		protected var _value:Number = 1;
		
		public function NumericValue()
		{
			super();
		}
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(value:Number):void
		{
			this._value = value;
		}
		
		public static function parse(str:String):NumericValue
		{
			str = StringUtil.trim(str.toLowerCase());
			
			var v:NumericValue = new NumericValue();
			v.rawValue = str;
			
			var f:Number = Math.max(0, Math.min(1, parseFloat(str)));
			
			v.value = f;
			
			return v;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str);
			
			var pattern:RegExp = /[0-1].[0-1.]+/i;
			var index:int = str.search(pattern);
			
			return index == 0;
		}
	}
}
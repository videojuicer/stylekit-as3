package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;
	
	public class IntegerValue extends Value
	{
		protected var _value:int = 0;
		
		public function IntegerValue()
		{
			super();
		}
		
		public function get value():int
		{
			return this._value;
		}
		
		public function set value(value:int):void
		{
			this._value = value;
		}
		
		public static function parse(str:String):IntegerValue
		{
			str = StringUtil.trim(str.toLowerCase());
			
			var v:IntegerValue = new IntegerValue();
			v.rawValue = str;
			
			var f:int = parseInt(str);
			
			v.value = f;
			
			return v;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str);
			
			var pattern:RegExp = /[0-9.]+/i;
			var index:int = str.search(pattern);
			
			return index == 0;
		}
	}
}
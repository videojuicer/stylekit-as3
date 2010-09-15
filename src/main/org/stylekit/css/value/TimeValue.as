package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class TimeValue extends Value
	{
		
		public static var UNIT_MILLISECONDS:String = "ms";
		public static var UNIT_SECONDS:String = "s";
		public static var UNIT_MINUTES:String = "m";
		public static var UNIT_HOURS:String = "h";
		
		protected var _value:Number = 0;
		protected var _units:String;
		
		public function TimeValue()
		{
			super();
		}
		
		public static function parse(str:String):TimeValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var tVal:TimeValue = new TimeValue();
				tVal.rawValue = str;
				
			var unitPattern:RegExp = new RegExp("[a-zA-Z]+");
			var unitIndex:int = str.search(unitPattern);

			tVal.value = parseFloat(str);

			if(unitIndex >= 0)
			{
				tVal.units = str.substring(unitIndex);
			}

			return tVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			var unitPattern:RegExp = new RegExp("[0-9.]+(ms|s|m|h){1}");
			var unitIndex:int = str.search(unitPattern);
			return (unitIndex == 0);
		}
		
		public function get units():String
		{
			return this._units;
		}
		
		public function set units(u:String):void
		{
			this._units = u;
		}
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(v:Number):void
		{
			this._value = v;
		}
		
		public function get millisecondValue():int
		{
			switch(this.units)
			{
				case TimeValue.UNIT_MILLISECONDS:
					return this.value;
					break;
				case TimeValue.UNIT_SECONDS:
					return this.value * 1000;
					break;
				case TimeValue.UNIT_MINUTES:
					return this.value * 60 * 1000;
					break;
				case TimeValue.UNIT_HOURS:
					return this.value * 60 * 60 * 1000;
					break;
			}
			return 0;
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is TimeValue)
			{
				return (this.units == (other as TimeValue).units && this.value == (other as TimeValue).value);
			}
			
			return super.isEquivalent(other);
		}
		
	}
}
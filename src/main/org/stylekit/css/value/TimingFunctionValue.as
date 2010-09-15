package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;
	import org.stylekit.css.value.Value;
	
	public class TimingFunctionValue extends Value
	{
		
		public static var EASING_EASE:String = "ease";
		public static var EASING_LINEAR:String = "linear";
		public static var EASING_EASE_IN:String = "ease-in";
		public static var EASING_EASE_OUT:String = "ease-out";
		public static var EASING_EASE_IN_OUT:String = "ease-in-out";
		
		public static var VALID_TIMING_FUNCTIONS:Array = ["ease", "linear", "ease-in", "ease-out", "ease-in-out"];
		
		protected var _timingFunction:String = "linear";
		
		public function TimingFunctionValue()
		{
			super();
		}
		
		public function get timingFunction():String
		{
			return this._timingFunction;
		}
		
		public function set timingFunction(f:String):void
		{
			this._timingFunction = f;
			this.modified();
		}
		
		public static function parse(str:String):TimingFunctionValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var tfVal:TimingFunctionValue = new TimingFunctionValue();
				tfVal.rawValue = str;
				tfVal.timingFunction = str;
			return tfVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			return (TimingFunctionValue.VALID_TIMING_FUNCTIONS.indexOf(str) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is TimingFunctionValue)
			{
				return (this.timingFunction == (other as TimingFunctionValue).timingFunction);
			}
			
			return super.isEquivalent(other);
		}
	}
}
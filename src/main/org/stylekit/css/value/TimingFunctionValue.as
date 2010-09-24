package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.parse.ValueParser;
	
	import flash.geom.Point;
	
	public class TimingFunctionValue extends Value
	{
		
		public static var EASING_EASE:String = "ease";
		public static var EASING_LINEAR:String = "linear";
		public static var EASING_EASE_IN:String = "ease-in";
		public static var EASING_EASE_OUT:String = "ease-out";
		public static var EASING_EASE_IN_OUT:String = "ease-in-out";
		public static var EASING_CUSTOM:String = "bicubic";
		
		public static var VALID_TIMING_FUNCTIONS:Array = ["ease", "linear", "ease-in", "ease-out", "ease-in-out"];
		
		protected var _timingFunction:String = "linear";
		
		// cubic values - p0 is always 0,0 and p3 is always 1,1
		protected var _p1:Point;
		protected var _p2:Point;
		
		public function TimingFunctionValue()
		{
			super();
		}
		
		public function get p1():Point
		{
			return this._p1;
		}
		
		public function set p1(p:Point):void
		{
			this._p1 = p;
		}
		
		public function get p2():Point
		{
			return this._p2;
		}
		
		public function set p2(p:Point):void
		{
			this._p2 = p;
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
				
				var customExp:RegExp = /^cubic-bezier\(([0-9.,\s\t]*)\)$/;
				if(str.search(customExp) == 0)
				{
					// parse values
					var values:Vector.<String> = ValueParser.parseCommaDelimitedString(str.substring(str.indexOf("(")+1, str.indexOf(")")));
					
					tfVal.p1 = new Point();
					tfVal.p1.x = Math.max(0.0, Math.min(1.0, parseFloat(values[0])));
					tfVal.p1.y = Math.max(0.0, Math.min(1.0, parseFloat(values[1])));
					
					tfVal.p2 = new Point();
					tfVal.p2.x = Math.max(0.0, Math.min(1.0, parseFloat(values[2])));
					tfVal.p2.y = Math.max(0.0, Math.min(1.0, parseFloat(values[3])));
					
					tfVal.timingFunction = TimingFunctionValue.EASING_CUSTOM;
				}
				else
				{
					tfVal.timingFunction = str;
				}
			return tfVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			return (TimingFunctionValue.VALID_TIMING_FUNCTIONS.indexOf(str) > -1 || str.search(/^cubic-bezier\((.*)\)$/) == 0);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is TimingFunctionValue)
			{
				return (this.timingFunction == (other as TimingFunctionValue).timingFunction);
			}
			
			return super.isEquivalent(other);
		}
		
		// Computes the float value of Y for this bezier function given a t-value between 0 and 1.
		public function compute(t:Number=0.0):Number
		{
			switch(this._timingFunction)
			{
				default:
					// LINEAR
					return t;
					break;
			}
			return 0;
		}
	}
}
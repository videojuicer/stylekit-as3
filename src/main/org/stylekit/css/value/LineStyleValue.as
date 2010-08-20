package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	
	import org.utilkit.util.StringUtil;
	
	public class LineStyleValue extends Value
	{
		
		public static var LINE_STYLE_NONE:uint = 1;
		public static var LINE_STYLE_HIDDEN:uint = 1; // deliberately the same as "none"
		public static var LINE_STYLE_DOTTED:uint = 2;
		public static var LINE_STYLE_DASHED:uint = 3;
		public static var LINE_STYLE_SOLID:uint = 4;
		public static var LINE_STYLE_DOUBLE:uint = 5;
		public static var LINE_STYLE_GROOVE:uint = 6;
		public static var LINE_STYLE_RIDGE:uint = 7;
		public static var LINE_STYLE_INSET:uint = 8;
		public static var LINE_STYLE_OUTSET:uint = 9;
		
		protected static var validStrings:Array = [
			"none", "hidden", "dotted", "dashed", "solid", "double", "groove", "ridge", "inset", "outset"
		];
		
		protected var _lineStyle:uint = 1;
		
		public function LineStyleValue()
		{
			super();
		}
		
		public static function parse(str:String):LineStyleValue
		{
			str = StringUtil.trim(str).toLowerCase();
			var lsVal:LineStyleValue = new LineStyleValue();
			lsVal.lineStyle = Math.max(1, LineStyleValue.validStrings.indexOf(str));
			return lsVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (LineStyleValue.validStrings.indexOf(str) > -1);
		}
		
		public function get lineStyle():uint
		{
			return this._lineStyle;
		}
		
		public function set lineStyle(l:uint):void
		{
			this._lineStyle = l;
		}
	}
}
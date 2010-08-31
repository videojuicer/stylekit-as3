package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class ListStyleTypeValue extends Value
	{
		public static var LISTSTYLE_NONE:uint = 0;
		public static var LISTSTYLE_DISC:uint = 1;
		public static var LISTSTYLE_CIRCLE:uint = 2;
		public static var LISTSTYLE_SQUARE:uint = 3;
		public static var LISTSTYLE_DECIMAL:uint = 4;
		public static var LISTSTYLE_DECIMAL_LEADING_ZERO:uint = 5;
		public static var LISTSTYLE_ARMENIAN:uint = 6;
		public static var LISTSTYLE_GEORGIAN:uint = 7;
		public static var LISTSTYLE_LOWER_ALPHA:uint = 8;
		public static var LISTSTYLE_UPPER_ALPHA:uint = 9;
		public static var LISTSTYLE_LOWER_GREEK:uint = 10;
		public static var LISTSTYLE_LOWER_LATIN:uint = 11;
		public static var LISTSTYLE_UPPER_LATIN:uint = 12;
		public static var LISTSTYLE_LOWER_ROMAN:uint = 13;
		public static var LISTSTYLE_UPPER_ROMAN:uint = 14;
		public static var LISTSTYLE_INHERIT:uint = 15;
		
		protected var _type:uint = ListStyleTypeValue.LISTSTYLE_DISC;
		
		protected static var validStrings:Array = [
			"none", "disc", "circle", "square", "decimal", "decimal-leading-zero", "armenian", "georgian", "lower-alpha",
			"upper-alpha", "lower-greek", "lower-latin", "upper-latin", "lower-roman", "upper-roman", "inherit"
		];
		
		public function ListStyleTypeValue()
		{
			super();
		}
		
		public function get type():uint
		{
			return this._type;
		}
		
		public function set type(type:uint):void
		{
			this._type = type;
		}
		
		public static function parse(str:String):ListStyleTypeValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:ListStyleTypeValue = new ListStyleTypeValue();
			value.rawValue = str;
			
			value.type = Math.max(0, ListStyleTypeValue.validStrings.indexOf(str));
			
			return value; 
		}
		
		public static function identify(str:String):Boolean
		{
			return (ListStyleTypeValue.validStrings.indexOf(str) > -1);
		}
	}
}
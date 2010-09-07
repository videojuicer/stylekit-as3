package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class TextDecorationValue extends Value
	{
		public static var TEXT_DECORATION_NONE:uint = 0;
		public static var TEXT_DECORATION_UNDERLINE:uint = 1;
		public static var TEXT_DECORATION_OVERLINE:uint = 2;
		public static var TEXT_DECORATION_LINE_THROUGH:uint = 3;
		public static var TEXT_DECORATION_BLINK:uint = 4;
		
		protected var _textDecoration:uint = TextDecorationValue.TEXT_DECORATION_NONE;
		
		public static var validStrings:Array = [
			"none", "underline", "overline", "line-through", "blink"
		];
		
		public function TextDecorationValue()
		{
			super();
		}
		
		public function get textDecoration():uint
		{
			return this._textDecoration;
		}
		
		public function set textDecoration(textDecoration:uint):void
		{
			this._textDecoration = textDecoration;
		}
		
		public static function parse(str:String):TextDecorationValue
		{
			var fvVal:TextDecorationValue = new TextDecorationValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textDecoration = Math.max(0, TextDecorationValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextDecorationValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
	}
}
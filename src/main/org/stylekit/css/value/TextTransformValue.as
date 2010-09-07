package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class TextTransformValue extends Value
	{
		public static var TEXT_TRANSFORM_CAPITALIZE:uint = 0;
		public static var TEXT_TRANSFORM_UPPERCASE:uint = 1;
		public static var TEXT_TRANSFORM_LOWERCASE:uint = 2;
		public static var TEXT_TRANSFORM_NONE:uint = 3;
		
		protected var _textTransform:uint = TextTransformValue.TEXT_TRANSFORM_NONE;
		
		public static var validStrings:Array = [
			"capitalize", "uppercase", "lowercase", "none"
		];
		
		public function TextTransformValue()
		{
			super();
		}
		
		public function get textTransform():uint
		{
			return this._textTransform;
		}
		
		public function set textTransform(textTransform:uint):void
		{
			this._textTransform = textTransform;
		}
		
		public static function parse(str:String):TextTransformValue
		{
			var fvVal:TextTransformValue = new TextTransformValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textTransform = Math.max(0, TextTransformValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextTransformValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
	}
}
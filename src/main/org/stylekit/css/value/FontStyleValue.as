package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class FontStyleValue extends Value
	{
		
		public static var FONT_STYLE_NORMAL:uint = 1;
		public static var FONT_STYLE_ITALIC:uint = 2;
		public static var FONT_STYLE_OBLIQUE:uint = 3;
		
		public static var validStrings:Array = [
			"normal", "italic", "oblique"
		];
		
		protected var _fontStyle:uint = 1;
		
		public function FontStyleValue()
		{
			super();
		}
		
		public static function parse(str:String):FontStyleValue
		{
			var fsVal:FontStyleValue = new FontStyleValue();
				fsVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fsVal.fontStyle = Math.max(1, FontStyleValue.validStrings.indexOf(str)+1);
			
			return fsVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (FontStyleValue.validStrings.indexOf(str) > -1);
		}
		
		public function get fontStyle():uint
		{
			return this._fontStyle;
		}
		
		public function set fontStyle(fs:uint):void
		{
			this._fontStyle = fs;
		}
	}
}
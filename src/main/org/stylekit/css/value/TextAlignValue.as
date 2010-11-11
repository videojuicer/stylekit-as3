package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class TextAlignValue extends Value
	{
		public static var TEXT_ALIGN_LEFT:uint = 0;
		public static var TEXT_ALIGN_RIGHT:uint = 1;
		public static var TEXT_ALIGN_CENTER:uint = 2;
		public static var TEXT_ALIGN_JUSTIFY:uint = 3;
		
		protected var _textAlign:uint = TextAlignValue.TEXT_ALIGN_LEFT;
		
		public static var validStrings:Array = [
			"left", "right", "center", "justify"
		];
		
		public function TextAlignValue()
		{
			super();
		}
		
		public function get textAlign():uint
		{
			return this._textAlign;
		}
		
		public function set textAlign(textAlign:uint):void
		{
			this._textAlign = textAlign;
			
			this.modified();
		}
		
		public function get leftAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_LEFT);
		}
		
		public function get rightAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_RIGHT);
		}
		
		public function get centerAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_CENTER);
		}
		
		public static function parse(str:String):TextAlignValue
		{
			var fvVal:TextAlignValue = new TextAlignValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textAlign = Math.max(0, TextAlignValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextAlignValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is TextAlignValue)
			{
				return (this.textAlign == (other as TextAlignValue).textAlign);
			}
			
			return super.isEquivalent(other);
		}
	}
}
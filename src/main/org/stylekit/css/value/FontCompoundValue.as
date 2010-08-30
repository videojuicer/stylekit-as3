package org.stylekit.css.value
{
	import org.stylekit.css.value.FontStyleValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;
	import org.stylekit.css.value.Value;
	
	public class FontCompoundValue extends Value
	{
		
		protected var _fontStyleValue:FontStyleValue;
		protected var _fontWeightValue:FontWeightValue;
		protected var _fontVariantValue:FontVariantValue;
		protected var _fontFaceValue:Value;
		
		protected var _sizeValue:SizeValue;
		
		public function FontCompoundValue()
		{
			super();
		}
		
		public function get styleValue():FontStyleValue
		{
			return this._fontStyleValue;
		}
		
		public function set styleValue(value:FontStyleValue):void
		{
			this._fontStyleValue = value;
		}
		
		public function get weightValue():FontWeightValue
		{
			return this._fontWeightValue;
		}
		
		public function set weightValue(value:FontWeightValue):void
		{
			this._fontWeightValue = value;
		}
		
		public function get variantValue():FontVariantValue
		{
			return this._fontVariantValue;
		}
		
		public function set variantValue(value:FontVariantValue):void
		{
			this._fontVariantValue = value;
		}
		
		public function get faceValue():Value
		{
			return this._fontFaceValue;
		}
		
		public function set faceValue(value:Value):void
		{
			this._fontFaceValue = value;
		}
		
		public function get sizeValue():SizeValue
		{
			return this._sizeValue;
		}
		
		public function set sizeValue(value:SizeValue):void
		{
			this._sizeValue = value;
		}
		
		public static function parse(str:String):FontCompoundValue
		{
			var fcVal:FontCompoundValue = new FontCompoundValue();
				fcVal.rawValue = str;
				
			return fcVal;
		}
	}
}
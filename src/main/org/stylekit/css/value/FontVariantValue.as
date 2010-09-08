package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class FontVariantValue extends Value
	{
		public static var FONT_VARIANT_NORMAL:uint = 1;
		public static var FONT_VARIANT_SMALL_CAPS:uint = 2;
		
		public static var validStrings:Array = [
			"normal", "small-caps"
		];
		
		protected var _fontVariant:uint = 1;
		
		public function FontVariantValue()
		{
			super();
		}
		
		public static function parse(str:String):FontVariantValue
		{
			var fvVal:FontVariantValue = new FontVariantValue();
				fvVal.rawValue = str;
				
			str = StringUtil.trim(str).toLowerCase();
			fvVal.fontVariant = Math.max(1, FontVariantValue.validStrings.indexOf(str)+1);
				
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (FontVariantValue.validStrings.indexOf(str) > -1);
		}
		
		public function get fontVariant():uint
		{
			return this._fontVariant;
		}

		public function set fontVariant(fs:uint):void
		{
			this._fontVariant = fs;
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FontVariantValue)
			{
				return (this.fontVariant == (other as FontVariantValue).fontVariant);
			}
			
			return super.isEquivalent(other);
		}
	}
}
package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	
	import org.stylekit.css.value.FontStyleValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;
	
	public class FontCompoundValue extends Value
	{
		
		protected var _fontStyleValue:FontStyleValue;
		protected var _fontWeightValue:FontWeightValue;
		protected var _fontVariantValue:FontVariantValue;
		protected var _fontFaceValue:Value;
		
		public function FontCompoundValue()
		{
			super();
		}
		
		public static function parse(str:String):FontCompoundValue
		{
			var fcVal:FontCompoundValue = new FontCompoundValue();
				fcVal.rawValue = str;
				
			return fcVal;
		}
	}
}
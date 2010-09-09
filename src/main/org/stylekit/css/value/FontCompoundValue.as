package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;
	
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.FontStyleValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;
	import org.stylekit.css.value.Value;
	
	public class FontCompoundValue extends Value
	{
		
		protected var _fontStyleValue:FontStyleValue;
		protected var _fontWeightValue:FontWeightValue;
		protected var _fontVariantValue:FontVariantValue;
		protected var _sizeValue:SizeValue;
		protected var _colorValue:ColorValue;
		protected var _fontFaceValue:Value;

		public function FontCompoundValue()
		{
			super();
		}
		public static function parse(str:String):FontCompoundValue
		{
			var fcVal:FontCompoundValue = new FontCompoundValue();
				fcVal.rawValue = str;
				
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			for(var i:uint=0; i<tokens.length; i++)
			{
				var t:String = tokens[i];
				
				if(FontStyleValue.identify(t))
				{
					fcVal.fontStyleValue = FontStyleValue.parse(t);
				}
				else if(FontWeightValue.identify(t))
				{
					fcVal.fontWeightValue = FontWeightValue.parse(t);
				}
				else if(FontVariantValue.identify(t))
				{
					fcVal.fontVariantValue = FontVariantValue.parse(t);
				}
				else if(SizeValue.identify(t))
				{
					fcVal.sizeValue = SizeValue.parse(t);
				}
				else if(ColorValue.identify(t))
				{
					fcVal.colorValue = ColorValue.parse(t);
				}
				else
				{
					fcVal.fontFaceValue = Value.parse(t);
				}
			}
				
			return fcVal;
		}
		
		public function get colorValue():ColorValue
		{
			return this._colorValue;
		}
		
		public function set colorValue(v:ColorValue):void
		{
			this._colorValue = v;
			
			this.modified();
		}
		public function get sizeValue():SizeValue
		{
			return this._sizeValue;
		}
		
		public function set sizeValue(v:SizeValue):void
		{
			this._sizeValue = v;
			
			this.modified();
		}
		
		public function get fontStyleValue():FontStyleValue
		{
			return this._fontStyleValue;
		}
		
		public function set fontStyleValue(v:FontStyleValue):void
		{
			this._fontStyleValue = v;
			
			this.modified();
		}
		
		public function get fontWeightValue():FontWeightValue
		{
			return this._fontWeightValue;
		}
		
		public function set fontWeightValue(v:FontWeightValue):void
		{
			this._fontWeightValue = v;
			
			this.modified();
		}
		
		public function get fontVariantValue():FontVariantValue
		{
			return this._fontVariantValue;
		}
		
		public function set fontVariantValue(v:FontVariantValue):void
		{
			this._fontVariantValue = v;
			
			this.modified();
		}
		
		public function get fontFaceValue():Value
		{
			return this._fontFaceValue;
		}
		
		public function set fontFaceValue(v:Value):void
		{
			this._fontFaceValue = v;
			
			this.modified();
		}
	}
}
package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class FontWeightValue extends Value
	{
		
		public static var FONT_WEIGHT_NORMAL:uint = 400;
		public static var FONT_WEIGHT_BOLD:uint = 700;
		public static var FONT_WEIGHT_BOLDER:uint = 900;
		public static var FONT_WEIGHT_LIGHTER:uint = 200;
		
		public static var validStrings:Array = [
			"normal", "bold", "bolder", "lighter"
		];
		
		protected var _fontWeight:uint = 400;
		
		public function FontWeightValue()
		{
			super();
		}
		
		public static function parse(str:String):FontWeightValue
		{
			var fwVal:FontWeightValue = new FontWeightValue();
				fwVal.rawValue = str;
				
			str = StringUtil.trim(str).toLowerCase();
			
			switch(str)
			{
				case "normal":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_NORMAL;
					break;
				case "bold":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_BOLD;
					break;
				case "bolder":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_BOLDER;
					break;
				case "lighter":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_LIGHTER;
					break;
				default:
					var pVal:uint = parseInt(str);
					if(!isNaN(pVal) && (pVal > 0) && (pVal % 100 == 0))
					{
						fwVal.fontWeight = pVal;
					}
					break;
			}
			
			return fwVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			
			// Check string values
			if(FontWeightValue.validStrings.indexOf(str) > -1)
			{
				return true;
			}
			
			// Check numeric values
			var pVal:uint = parseInt(str);
			if(!isNaN(pVal) && (pVal > 0) && (pVal % 100 == 0))
			{
				return true;
			}
			
			return false;
		}
		
		public function get fontWeight():uint
		{
			return this._fontWeight;
		}

		public function set fontWeight(fs:uint):void
		{
			this._fontWeight = fs;
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FontWeightValue)
			{
				return (this.fontWeight == (other as FontWeightValue).fontWeight);
			}
			
			return super.isEquivalent(other);
		}
	}
}
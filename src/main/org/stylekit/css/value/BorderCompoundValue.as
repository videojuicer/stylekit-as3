package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ColorValue;
	
	import org.stylekit.css.parse.ValueParser;
	
	public class BorderCompoundValue extends Value
	{
		
		protected var _sizeValue:SizeValue;
		protected var _lineStyleValue:LineStyleValue;
		protected var _colorValue:ColorValue;
		
		public function BorderCompoundValue()
		{
			super();
		}
		
		/**
		* Parses a shorthand border, border-(top|left|right|bottom) property such as "3px solid red" or "5px red" and 
		* returns the resulting BorderCompoundValue object.
		*/
		public static function parse(str:String):BorderCompoundValue
		{
			var bVal:BorderCompoundValue = new BorderCompoundValue();
				bVal.rawValue = str;
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			for(var i:uint=0; i < tokens.length; i++)
			{
				var t:String = tokens[i];
				// Identify as weight
				if(SizeValue.identify(t))
				{
					bVal.sizeValue = SizeValue.parse(t);
				}
				// Identify as style
				else if(LineStyleValue.identify(t))
				{
					bVal.lineStyleValue = LineStyleValue.parse(t);
				}
				// Identify as color
				else if(ColorValue.identify(t))
				{
					bVal.colorValue = ColorValue.parse(t);
				}
			}
			return bVal;
		}
		
		public function get sizeValue():SizeValue
		{
			return this._sizeValue;
		}
		
		public function set sizeValue(s:SizeValue):void
		{
			this._sizeValue = s;
			
			this.modified();
		}
		
		public function get lineStyleValue():LineStyleValue
		{
			return this._lineStyleValue;
		}
		
		public function set lineStyleValue(l:LineStyleValue):void
		{
			this._lineStyleValue = l;
			
			this.modified();
		}
		
		public function get colorValue():ColorValue
		{
			return this._colorValue;
		}
		
		public function set colorValue(c:ColorValue):void
		{
			this._colorValue = c;
			
			this.modified();
		}
	}
}
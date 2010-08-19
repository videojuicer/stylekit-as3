package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ColorValue;
	
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
			
			return bVal;
		}
		
	}
}
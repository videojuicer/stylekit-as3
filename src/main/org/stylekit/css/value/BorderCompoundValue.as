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
		
	}
}
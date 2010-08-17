package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.stylekit.ui.element.UIElement;
	
	/**
	* A <code>SizeValue</code> represents any unit of spatial measurement expressed in a CSS value. 
	* 10px, 3%, 2em are among the examples of an acceptable size value.
	*/
	public class SizeValue extends Value
	{
		public static var UNIT_PIXELS:String = "px";
		public static var UNIT_FONTSIZE:String = "em";
		public static var UNIT_PERCENTAGE:String = "%";
		
		protected var _units:String = "px";
		protected var _value:Number;
		
		public function SizeValue()
		{
		}
		
		public function get units():String
		{
			return this._units;
		}
		
		public function set units(u:String):void
		{
			this._units = u;
		}
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(n:Number):void
		{
			this._value = n;
		}
		
		/**
		* Calculates the actual pixel size of this SizeValue instance.
		* Pass a UIElement instance to the method to allow relative percentage or fontsize-based calculations.
		*/
		public function evaluateSize(onElement:UIElement = null):void
		{
			
		}
	}
	
}
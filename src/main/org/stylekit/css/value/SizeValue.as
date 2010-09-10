package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.stylekit.ui.element.UIElement;
	import org.utilkit.util.StringUtil;
	
	/**
	* A <code>SizeValue</code> represents any unit of spatial measurement expressed in a CSS value. 
	* 10px, 3%, 2em are among the examples of an acceptable size value.
	*/
	public class SizeValue extends Value
	{
		public static var UNIT_PIXELS:String = "px";
		public static var UNIT_FONTSIZE:String = "em";
		public static var UNIT_PERCENTAGE:String = "%";
		
		public static var DIMENSION_WIDTH:String = "w";
		public static var DIMENSION_HEIGHT:String = "h";
		
		protected var _units:String = "px";
		protected var _value:Number = 0;
		
		public function SizeValue()
		{
			super();
		}
		
		public static function parse(str:String):SizeValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var sVal:SizeValue = new SizeValue();
				sVal.rawValue = str;
			var unitPattern:RegExp = new RegExp("[%a-zA-Z]+");
			var unitIndex:int = str.search(unitPattern);

			sVal.value = parseFloat(str);
			
			if(unitIndex >= 0)
			{
				sVal.units = str.substring(unitIndex);
			}
			
			return sVal;
		}
		
		/**
		* Identifies a string as a valid candidate AlignmentValue string. Returns true if the string appears valid.
		*/
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			var unitPattern:RegExp = new RegExp("[0-9.]+[%a-zA-Z]+");
			var unitIndex:int = str.search(unitPattern);
			return (unitIndex == 0);
		}
		
		public function get units():String
		{
			return this._units;
		}
		
		public function set units(u:String):void
		{
			this._units = u;
			
			this.modified();
		}
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(n:Number):void
		{
			this._value = n;
			
			this.modified();
		}
		
		/**
		* Calculates the actual pixel size of this SizeValue instance.
		* Pass a UIElement instance to the method to allow relative percentage or fontsize-based calculations.
		*/
		public function evaluateSize(e:UIElement = null, dimension:String = null):int
		{
			if(dimension == null) dimension = SizeValue.DIMENSION_WIDTH;
			
			switch(this.units)
			{
				case SizeValue.UNIT_FONTSIZE:
					break;
				case SizeValue.UNIT_PERCENTAGE:
					var baseVal:int = (dimension == SizeValue.DIMENSION_WIDTH)? e.parentElement.effectiveContentWidth : e.parentElement.effectiveContentHeight;
				
					return baseVal * (this.value / 100);
					break;
				default:
					return this.value;
					break;
			}
			return 0;
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is SizeValue)
			{
				return (this.units == (other as SizeValue).units);
			}
			
			return super.isEquivalent(other);
		}
	}
	
}
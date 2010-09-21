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
		
		public static var BASE_EM_ABS_VALUE:Number = 12; // 1em == 12px for our purposes.
		
		public static var WORD_VALUE_MAP:Object = {
			"xx-small": "0.3em",
			"x-small": "0.4em",
			"small": "0.6em",
			"medium": "1em",
			"large": "1.3em",
			"x-large": "1.6em",
			"xx-large": "2em"
		};
		
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
			
			// Substitute word sizings
			if(SizeValue.WORD_VALUE_MAP[str])
			{
				str = SizeValue.WORD_VALUE_MAP[str];
			}
			
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
			var unitPattern:RegExp = new RegExp("[0-9.]+(px|em|%)+");
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
		public function evaluateSize(e:UIElement = null, dimension:String = null):Number
		{
			if(dimension == null) dimension = SizeValue.DIMENSION_WIDTH;
			var baseVal:Number;
			
			switch(this.units)
			{
				case SizeValue.UNIT_PERCENTAGE:
					if (e.parentElement == null && e.baseUI == e)
					{
						baseVal = (dimension == SizeValue.DIMENSION_WIDTH)? e.parent.width : e.parent.height;
					}
					else
					{
						baseVal = (dimension == SizeValue.DIMENSION_WIDTH)? e.parentElement.effectiveContentWidth : e.parentElement.effectiveContentHeight;
					}
					return baseVal * (this.value / 100);
					break;
				case SizeValue.UNIT_FONTSIZE:
					// Find baseline fontsize and resolve to pixel value
					baseVal = SizeValue.BASE_EM_ABS_VALUE;
					
					// Loop up the element tree, starting with the given element's parent, and use the nearest font-size style.
					var p:UIElement = e.parentElement;
					while (p != null && !p.hasStyleProperty("font-size"))
					{
						p = p.parentElement;
					}
					// At this point either p is null or we've found an item
					if (p != null && p.hasStyleProperty("font-size"))
					{
						baseVal = (p.getStyleValue("font-size") as SizeValue).evaluateSize(p, SizeValue.DIMENSION_HEIGHT);
					}
					
					// Factor with the value
					return this.value * baseVal;
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
				return (this.units == (other as SizeValue).units && this.value == (other as SizeValue).value);
			}
			
			return super.isEquivalent(other);
		}
	}
	
}
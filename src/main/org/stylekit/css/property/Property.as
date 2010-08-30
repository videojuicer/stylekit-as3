package org.stylekit.css.property
{
	
	import mx.controls.List;
	
	import org.stylekit.css.value.BackgroundCompoundValue;
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.FontCompoundValue;
	import org.stylekit.css.value.Value;
	
	/**
	* The Property class represents a CSS value given a property name. For instance, the padding property 
	* would be represented by a Property instance with name "padding" and an EdgeCompoundValue containing four size values.
	*/
	
	public class Property
	{
		
		protected var _name:String;
		protected var _value:Value;
		
		public function Property(name:String, value:Value = null)
		{
			this.name = name;
			this.value = value;
		}
		
		public function get name():String
		{
			return this._name;
		}
		
		public function set name(n:String):void
		{
			this._name = n;
		}
		
		public function get value():Value
		{
			return this._value;
		}
		
		public function set value(v:Value):void
		{
			this._value = v;
		}
		
		/**
		* Evaluates a property into a flattened hash, merged with an optional mergeParent:Object argument.
		* most properties evaluate into a hash with a single key:
		* <code>Property(name="padding-left", value=SizeValue(...)).evaluateStyle() => {"padding-left": SizeValue(...)}</code>
		* However, some properties evaluate into more complex arrangements:
		* <code>Property(name="padding", value=EdgeCompoundValue(...)).evaluateStyle() => {"padding-top": SizeValue(...), "padding-right": SizeValue(...), "padding-bottom": SizeValue(...), "padding-left": SizeValue(...)}</code>
		*/ 
		public function evaluateProperty(mergeParent:Object = null):Object
		{
			if (mergeParent == null)
			{
				mergeParent = new Object();
			}
			
			switch (this.name)
			{
				case "background":
					var backgroundValue:BackgroundCompoundValue = (this.value as BackgroundCompoundValue)
					
					if (backgroundValue.colorValue != null) mergeParent["background-color"] = backgroundValue.colorValue;
					if (backgroundValue.urlValue != null) mergeParent["background-image"] = backgroundValue.urlValue;
					if (backgroundValue.alignmentValue != null) mergeParent["background-position"] = backgroundValue.alignmentValue;
					if (backgroundValue.repeatValue != null) mergeParent["background-repeat"] = backgroundValue.repeatValue;
					
					break;
				case "border":
					var borderValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					if (borderValue.colorValue != null) mergeParent["border-color"] = borderValue.colorValue;
					if (borderValue.lineStyleValue != null) mergeParent["border-style"] = borderValue.lineStyleValue;
					if (borderValue.sizeValue != null) mergeParent["border-width"] = borderValue.sizeValue;

					break;
				case "font":
					var fontValue:FontCompoundValue = (this.value as FontCompoundValue);
					
					if (fontValue.fontFaceValue != null) mergeParent["font-family"] = fontValue.fontFaceValue;
					if (fontValue.fontStyleValue != null) mergeParent["font-style"] = fontValue.fontStyleValue;
					if (fontValue.fontVariantValue != null) mergeParent["font-variant"] = fontValue.fontVariantValue;
					if (fontValue.fontWeightValue != null) mergeParent["font-weight"] = fontValue.fontWeightValue;
					if (fontValue.sizeValue != null) mergeParent["font-size"] = fontValue.sizeValue;
					
					break;
				case "outline":
					var outlineValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					if (outlineValue.colorValue != null) mergeParent["outline-color"] = outlineValue.colorValue;
					if (outlineValue.lineStyleValue != null) mergeParent["outline-style"] = outlineValue.lineStyleValue;
					if (outlineValue.sizeValue != null) mergeParent["outline-width"] = outlineValue.sizeValue;
					
					break;
				case "margin":
					var marginValue:EdgeCompoundValue = (this.value as EdgeCompoundValue);
					
					if (marginValue.topValue != null) mergeParent["margin-top"] = marginValue.topValue;
					if (marginValue.rightValue != null) mergeParent["margin-right"] = marginValue.rightValue;
					if (marginValue.bottomValue != null) mergeParent["margin-bottom"] = marginValue.bottomValue;
					if (marginValue.leftValue != null) mergeParent["margin-left"] = marginValue.leftValue;
					
					break;
				case "padding":
					var paddingValue:EdgeCompoundValue = (this.value as EdgeCompoundValue);
					
					if (paddingValue.topValue != null) mergeParent["padding-top"] = paddingValue.topValue;
					if (paddingValue.rightValue != null) mergeParent["padding-right"] = paddingValue.rightValue;
					if (paddingValue.bottomValue != null) mergeParent["padding-bottom"] = paddingValue.bottomValue;
					if (paddingValue.leftValue != null) mergeParent["padding-left"] = paddingValue.leftValue;
					
					break;
				case "list-style":
					
					
					break;
				default:
					if (this.value != null)
					{
						mergeParent[this.name] = this.value;
					}
					break;
			}
			
			return mergeParent;
		}
		
	}
	
}
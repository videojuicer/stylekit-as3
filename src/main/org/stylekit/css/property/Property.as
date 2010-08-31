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
					
					mergeParent["background-color"] = backgroundValue.colorValue;
					mergeParent["background-image"] = backgroundValue.urlValue;
					mergeParent["background-position"] = backgroundValue.alignmentValue;
					mergeParent["background-repeat"] = backgroundValue.repeatValue;
					
					break;
				case "border":
					var borderValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["border-left-color"] = mergeParent["border-right-color"] = mergeParent["border-top-color"] = mergeParent["border-bottom-color"] = borderValue.colorValue;
					mergeParent["border-left-style"] = mergeParent["border-right-style"] = mergeParent["border-top-style"] = mergeParent["border-bottom-style"] = borderValue.lineStyleValue;
					mergeParent["border-left-width"] = mergeParent["border-right-width"] = mergeParent["border-top-width"] = mergeParent["border-bottom-width"] = borderValue.sizeValue;

					break;
				case "border-left":
					var borderLeftValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["border-left-color"] = borderLeftValue.colorValue;
					mergeParent["border-left-style"] = borderLeftValue.lineStyleValue;
					mergeParent["border-left-width"] = borderLeftValue.sizeValue;
					
					break;
				case "border-right":
					var borderRightValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["border-right-color"] = borderRightValue.colorValue;
					mergeParent["border-right-style"] = borderRightValue.lineStyleValue;
					mergeParent["border-right-width"] = borderRightValue.sizeValue;
					
					break;
				case "border-top":
					var borderTopValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["border-top-color"] = borderTopValue.colorValue;
					mergeParent["border-top-style"] = borderTopValue.lineStyleValue;
					mergeParent["border-top-width"] = borderTopValue.sizeValue;
					
					break;
				case "border-bottom":
					var borderBottomValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["border-bottom-color"] = borderBottomValue.colorValue;
					mergeParent["border-bottom-style"] = borderBottomValue.lineStyleValue;
					mergeParent["border-bottom-width"] = borderBottomValue.sizeValue;
					
					break;
				case "font":
					var fontValue:FontCompoundValue = (this.value as FontCompoundValue);
					
					mergeParent["font-family"] = fontValue.fontFaceValue;
					mergeParent["font-style"] = fontValue.fontStyleValue;
					mergeParent["font-variant"] = fontValue.fontVariantValue;
					mergeParent["font-weight"] = fontValue.fontWeightValue;
					mergeParent["font-size"] = fontValue.sizeValue;
					
					break;
				case "outline":
					var outlineValue:BorderCompoundValue = (this.value as BorderCompoundValue);
					
					mergeParent["outline-color"] = outlineValue.colorValue;
					mergeParent["outline-style"] = outlineValue.lineStyleValue;
					mergeParent["outline-width"] = outlineValue.sizeValue;
					
					break;
				case "margin":
					var marginValue:EdgeCompoundValue = (this.value as EdgeCompoundValue);
					
					mergeParent["margin-top"] = marginValue.topValue;
					mergeParent["margin-right"] = marginValue.rightValue;
					mergeParent["margin-bottom"] = marginValue.bottomValue;
					mergeParent["margin-left"] = marginValue.leftValue;
					
					break;
				case "padding":
					var paddingValue:EdgeCompoundValue = (this.value as EdgeCompoundValue);
					
					mergeParent["padding-top"] = paddingValue.topValue;
					mergeParent["padding-right"] = paddingValue.rightValue;
					mergeParent["padding-bottom"] = paddingValue.bottomValue;
					mergeParent["padding-left"] = paddingValue.leftValue;
					
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
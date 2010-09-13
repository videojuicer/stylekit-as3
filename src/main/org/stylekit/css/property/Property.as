package org.stylekit.css.property
{
	
	import flash.events.EventDispatcher;
	
	import mx.controls.List;
	
	import org.stylekit.css.value.BackgroundCompoundValue;
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.CornerCompoundValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.FontCompoundValue;
	import org.stylekit.css.value.InheritValue;
	import org.stylekit.css.value.ListStyleCompoundValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.events.PropertyEvent;
	import org.stylekit.events.ValueEvent;
	import org.stylekit.ui.element.UIElement;
	
	/**
	* The Property class represents a CSS value given a property name. For instance, the padding property 
	* would be represented by a Property instance with name "padding" and an EdgeCompoundValue containing four size values.
	*/
	
	public class Property extends EventDispatcher
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
			if (this._value != null && this._value != v)
			{
				this._value.removeEventListener(ValueEvent.VALUE_MODIFIED, this.onValueModified);
			}
			
			if (v != null)
			{
				v.addEventListener(ValueEvent.VALUE_MODIFIED, this.onValueModified);
			}
			
			this._value = v;
		}
		
		/**
		* Evaluates a property into a flattened hash, merged with an optional mergeParent:Object argument.
		* most properties evaluate into a hash with a single key:
		* <code>Property(name="padding-left", value=SizeValue(...)).evaluateStyle() => {"padding-left": SizeValue(...)}</code>
		* However, some properties evaluate into more complex arrangements:
		* <code>Property(name="padding", value=EdgeCompoundValue(...)).evaluateStyle() => {"padding-top": SizeValue(...), "padding-right": SizeValue(...), "padding-bottom": SizeValue(...), "padding-left": SizeValue(...)}</code>
		*/ 
		public function evaluateProperty(mergeParent:Object, uiElement:UIElement):Object
		{
			var val:Value = this.value;
			// Store the !important flag for this value.
			// Stored this way because compound values that are !important should lend their importance to all their sub-values.
			var importance:Boolean = val.important;
			
			if (val is InheritValue)
			{
				val = (val as InheritValue).resolveValue(uiElement);
			}

			switch (this.name)
			{
				case "background":
					var backgroundValue:BackgroundCompoundValue = (val as BackgroundCompoundValue)
					
					mergePropertyWithImportance(mergeParent, ["background-color"], backgroundValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["background-image"], backgroundValue.urlValue, importance);
					mergePropertyWithImportance(mergeParent, ["background-position"], backgroundValue.alignmentValue, importance);
					mergePropertyWithImportance(mergeParent, ["background-repeat"], backgroundValue.repeatValue, importance);
										
					break;
				case "border":
					var borderValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["border-left-color", "border-right-color", "border-top-color", "border-bottom-color"], 	
												borderValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-left-style", "border-right-style", "border-top-style", "border-bottom-style"], 	
												borderValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-left-width", "border-right-width", "border-top-width", "border-bottom-width"], 	
												borderValue.sizeValue, importance);
					
					break;
				case "border-radius":
					var radiusValue:SizeValue = (val as SizeValue);
					
					mergePropertyWithImportance(mergeParent, ["border-top-right-radius", "border-bottom-right-radius", "border-bottom-left-radius", "border-top-left-radius"], 	
						radiusValue, importance);
					
					break;
				case "border-left":
					var borderLeftValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["border-left-color"], borderLeftValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-left-style"], borderLeftValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-left-width"], borderLeftValue.sizeValue, importance);
					
					break;
				case "border-right":
					var borderRightValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["border-right-color"], borderRightValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-right-style"], borderRightValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-right-width"], borderRightValue.sizeValue, importance);
					
					break;
				case "border-top":
					var borderTopValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["border-top-color"], borderTopValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-top-style"], borderTopValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-top-width"], borderTopValue.sizeValue, importance);
					
					break;
				case "border-bottom":
					var borderBottomValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["border-bottom-color"], borderBottomValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-bottom-style"], borderBottomValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["border-bottom-width"], borderBottomValue.sizeValue, importance);
					
					break;
				case "font":
					var fontValue:FontCompoundValue = (val as FontCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["font-family"], fontValue.fontFaceValue, importance);
					mergePropertyWithImportance(mergeParent, ["font-style"], fontValue.fontStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["font-variant"], fontValue.fontVariantValue, importance);
					mergePropertyWithImportance(mergeParent, ["font-weight"], fontValue.fontWeightValue, importance);
					mergePropertyWithImportance(mergeParent, ["font-size"], fontValue.sizeValue, importance);
					
					break;
				case "outline":
					var outlineValue:BorderCompoundValue = (val as BorderCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["outline-color"], outlineValue.colorValue, importance);
					mergePropertyWithImportance(mergeParent, ["outline-style"], outlineValue.lineStyleValue, importance);
					mergePropertyWithImportance(mergeParent, ["outline-width"], outlineValue.sizeValue, importance);
					
					break;
				case "margin":
					var marginValue:EdgeCompoundValue = (val as EdgeCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["margin-top"], marginValue.topValue, importance);
					mergePropertyWithImportance(mergeParent, ["margin-right"], marginValue.rightValue, importance);
					mergePropertyWithImportance(mergeParent, ["margin-bottom"], marginValue.bottomValue, importance);
					mergePropertyWithImportance(mergeParent, ["margin-left"], marginValue.leftValue, importance);
					
					break;
				case "padding":
					var paddingValue:EdgeCompoundValue = (val as EdgeCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["padding-top"], paddingValue.topValue, importance);
					mergePropertyWithImportance(mergeParent, ["padding-right"], paddingValue.rightValue, importance);
					mergePropertyWithImportance(mergeParent, ["padding-bottom"], paddingValue.bottomValue, importance);
					mergePropertyWithImportance(mergeParent, ["padding-left"], paddingValue.leftValue, importance);
					
					break;
				case "list-style":
					var listValue:ListStyleCompoundValue = (val as ListStyleCompoundValue);
					
					mergePropertyWithImportance(mergeParent, ["list-style-type"], listValue.typeValue, importance);
					mergePropertyWithImportance(mergeParent, ["list-style-position"], listValue.positionValue, importance);
					mergePropertyWithImportance(mergeParent, ["list-style-image"], listValue.urlValue, importance);
					
					break;
				default:
					mergePropertyWithImportance(mergeParent, [this.name], val, importance);
					break;
			}
			
			return mergeParent;
		}
		
		// Merges a value into the mergeParent object, following the rules for !important overrides.
		// Only performs the merge if:
		// 1. The previous value is not set OR
		// 2. The previous value isn't important OR
		// 3. The new value is important
		protected function mergePropertyWithImportance(mergeParent:Object, keys:Array, newValue:Value, newValueIsImportant:Boolean):Object
		{
			for(var i:uint=0; i<keys.length; i++)
			{
				var key:String = (keys[i] as String);
				var prevValue:Value = mergeParent[key];

				if(prevValue == null || !prevValue.important || newValueIsImportant)
				{
					mergeParent[key] = newValue;
				}
			}
			return mergeParent;
		}
		
		protected function onValueModified(e:ValueEvent):void
		{
			this.dispatchEvent(new PropertyEvent(PropertyEvent.PROPERTY_MODIFIED, e));
		}
	}	
}
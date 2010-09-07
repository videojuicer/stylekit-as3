package org.stylekit.css.value
{
	import org.stylekit.css.property.Property;
	import org.stylekit.css.style.Style;
	import org.stylekit.ui.element.UIElement;

	public class InheritValue extends Value
	{
		protected var _propertyName:String;
		
		public function InheritValue(propertyName:String, rawValue:String = "inherit")
		{
			super();
			
			this._propertyName = propertyName;
			this._rawValue = rawValue;
		}
		
		public function resolveValue(uiElement:UIElement):Value
		{
			var value:Value = null;
			var styleParent:UIElement = uiElement.styleParent;
			
			do
			{
				var property:Property = styleParent.getStyleProperty(this._propertyName);
				
				if (property != null)
				{
					if (property.value is InheritValue)
					{
						// keep going
					}
					else
					{
						value = property.value;
					}
				}

				styleParent = styleParent.styleParent;
			}
			while (value == null && styleParent != null);
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (str == "inherit");
		}
	}
}
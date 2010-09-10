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
				var pVal:Value = styleParent.getStyleValue(this._propertyName);
				
				if (pVal != null)
				{
					if (pVal is InheritValue)
					{
						// keep going
					}
					else
					{
						value = pVal;
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
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is InheritValue)
			{
				return (this.stringValue == other.stringValue);
			}
			
			return super.isEquivalent(other);
		}
	}
}
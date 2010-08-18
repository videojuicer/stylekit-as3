package org.stylekit.css.property
{
	
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
			return {};
		}
		
	}
	
}
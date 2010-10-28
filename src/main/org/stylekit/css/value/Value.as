package org.stylekit.css.value {
	import flash.events.EventDispatcher;
	
	import org.stylekit.events.ValueEvent;
	
	/**
	* The Value class represents any value attached to a CSS property. There are several specialised value types such as ColorValue and URLValue,
	* but the basic Value class may be used to store basic string values for any property where a specialised Value type is not required.
	*/
	public class Value extends EventDispatcher
	{
		protected var _rawValue:String;
		protected var _stringValue:String;
		protected var _important:Boolean = false;
		
		public function Value()
		{
			
		}
		
		public static function parse(str:String):Value
		{
			var val:Value = new Value();
				val.stringValue = str;
			return val;
		}
		
		public function get important():Boolean
		{
			return this._important;
		}
		
		public function set important(i:Boolean):void
		{
			this._important = i;
			
			this.modified();
		}
		
		public function get stringValue():String
		{
			return this._stringValue;
		}
		
		public function set stringValue(s:String):void
		{
			this._stringValue = s;
		}
		
		public function get rawValue():String
		{
			return this._rawValue;
		}

		public function set rawValue(s:String):void
		{
			this._rawValue = s;
		}
		
		protected function modified():void
		{
			this.dispatchEvent(new ValueEvent(ValueEvent.VALUE_MODIFIED));
		}
		
		public function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is Value)
			{
				return (this._rawValue == other._rawValue || this._stringValue == other._stringValue);
			}
			
			return false;
		}
	}
}
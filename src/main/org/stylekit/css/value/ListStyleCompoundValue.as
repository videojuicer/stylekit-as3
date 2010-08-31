package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;

	public class ListStyleCompoundValue extends Value
	{
		protected var _positionValue:ListStylePositionValue;
		protected var _urlValue:URLValue;
		protected var _typeValue:ListStyleTypeValue;
		
		public function ListStyleCompoundValue()
		{
			super();
		}
		
		public function get positionValue():ListStylePositionValue
		{
			return this._positionValue;
		}
		
		public function set positionValue(value:ListStylePositionValue):void
		{
			this._positionValue = value;
		}
		
		public function get urlValue():URLValue
		{
			return this._urlValue;
		}
		
		public function set urlValue(value:URLValue):void
		{
			this._urlValue = value;
		}
		
		public function get typeValue():ListStyleTypeValue
		{
			return this._typeValue;
		}
		
		public function set typeValue(value:ListStyleTypeValue):void
		{
			this._typeValue = value;
		}
		
		public static function parse(str:String):ListStyleCompoundValue
		{
			var value:ListStyleCompoundValue = new ListStyleCompoundValue();
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			for (var i:uint = 0; i < tokens.length; ++i)
			{
				var token:String = tokens[i];
				
				if (ListStylePositionValue.identify(token))
				{
					value.positionValue = ListStylePositionValue.parse(token);
				}
				else if (ListStyleTypeValue.identify(token))
				{
					value.typeValue = ListStyleTypeValue.parse(token);
				}
				else if (URLValue.identify(token))
				{
					value.urlValue = URLValue.parse(token);
				}
			}
			
			return value;
		}
	}
}
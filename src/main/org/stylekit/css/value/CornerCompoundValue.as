package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;

	public class CornerCompoundValue extends Value
	{
		protected var _topRightValue:Value;
		protected var _bottomRightValue:Value;
		protected var _bottomLeftValue:Value;
		protected var _topLeftValue:Value;
		
		public function CornerCompoundValue()
		{
			super();
		}
		
		public function get topRightValue():Value
		{
			return this._topRightValue;
		}
		
		public function set topRightValue(v:Value):void
		{
			this._topRightValue = v;
			
			this.modified();
		}
		
		public function get bottomRightValue():Value
		{
			return this._bottomRightValue;
		}
		
		public function set bottomRightValue(v:Value):void
		{
			this._bottomRightValue = v;
			
			this.modified();
		}
		
		public function get bottomLeftValue():Value
		{
			return this._bottomLeftValue;
		}
		
		public function set bottomLeftValue(v:Value):void
		{
			this._bottomLeftValue = v;
			
			this.modified();
		}
		
		public function get topLeftValue():Value
		{
			return this._topLeftValue;
		}
		
		public function set topLeftValue(v:Value):void
		{
			this._topLeftValue = v;
			
			this.modified();
		}
		
		public static function parse(str:String):CornerCompoundValue
		{
			var sizeStrings:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			var val:CornerCompoundValue = new CornerCompoundValue();
			
			var sizeValues:Vector.<SizeValue> = new Vector.<SizeValue>();
			
			for(var i:uint = 0; i < sizeStrings.length; i++)
			{
				sizeValues.push(SizeValue.parse(sizeStrings[i]));
			}
			
			switch (sizeValues.length)
			{
				case 1:
					val.topRightValue = val.bottomRightValue = val.bottomLeftValue = val.topLeftValue = sizeValues[0];
					break;
				case 2:
					val.topRightValue = val.bottomLeftValue = sizeValues[0];
					val.bottomRightValue = val.topLeftValue = sizeValues[1];
					break;
				case 3:
					val.topRightValue = sizeValues[0];
					val.bottomRightValue = sizeValues[3];
					val.topLeftValue = val.bottomLeftValue = sizeValues[2];
					break;
				case 4:
					val.topRightValue = sizeValues[0];
					val.bottomRightValue = sizeValues[1];
					val.bottomLeftValue = sizeValues[2];
					val.topLeftValue = sizeValues[3];
					break;
			}
			
			return val;
		}
	}
}
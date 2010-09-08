package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class ListStylePositionValue extends Value
	{
		public static var LISTSTYLE_INSIDE:uint = 0;
		public static var LISTSTYLE_OUTSIDE:uint = 1;
		public static var LISTSTYLE_INHERIT:uint = 2;
		
		protected var _position:uint = ListStylePositionValue.LISTSTYLE_OUTSIDE;
		
		protected static var validStrings:Array = [
			"inside", "outside", "inherit"
		];
		
		public function ListStylePositionValue()
		{
			super();
		}
		
		public function get position():uint
		{
			return this._position;
		}
		
		public function set position(position:uint):void
		{
			this._position = position;
		}
		
		public static function parse(str:String):ListStylePositionValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:ListStylePositionValue = new ListStylePositionValue();
			value.rawValue = str;
			
			value.position = Math.max(0, ListStylePositionValue.validStrings.indexOf(str));
			
			return value; 
		}
		
		public static function identify(str:String):Boolean
		{
			return (ListStylePositionValue.validStrings.indexOf(str) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is ListStylePositionValue)
			{
				return (this.position == (other as ListStylePositionValue).position);
			}
			
			return super.isEquivalent(other);
		}
	}
}
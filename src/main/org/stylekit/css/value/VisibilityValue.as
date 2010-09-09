package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class VisibilityValue extends Value
	{
		public static var VISIBILITY_VISIBLE:uint = 0;
		public static var VISIBILITY_HIDDEN:uint = 1;
		public static var VISIBILITY_COLLAPSE:uint = 2;
		
		protected var _visibility:uint = VisibilityValue.VISIBILITY_VISIBLE;
		
		protected static var validStrings:Array = [
			"visible", "hidden", "collapse"
		];
		
		public function VisibilityValue()
		{
			super();
		}
		
		public function get visibility():uint
		{
			return this._visibility;
		}
		
		public function set visibility(value:uint):void
		{
			this._visibility = value;
			
			this.modified();
		}
		
		public static function parse(str:String):VisibilityValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:VisibilityValue = new VisibilityValue();
			value.rawValue = str;
			
			value.visibility = Math.max(0, VisibilityValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (VisibilityValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is VisibilityValue)
			{
				return (this.visibility == (other as VisibilityValue).visibility);
			}
			
			return super.isEquivalent(other);
		}
	}
}
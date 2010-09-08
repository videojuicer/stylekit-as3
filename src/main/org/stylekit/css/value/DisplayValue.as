package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;
	
	public class DisplayValue extends Value
	{
		public static var DISPLAY_INLINE:uint = 0;
		public static var DISPLAY_NONE:uint = 1;
		public static var DISPLAY_BLOCK:uint = 2;
		public static var DISPLAY_INLINE_BLOCK:uint = 3;
		public static var DISPLAY_LIST_ITEM:uint = 4;
		public static var DISPLAY_MARKER:uint = 5;
		public static var DISPLAY_COMPACT:uint = 6;
		public static var DISPLAY_RUN_IN:uint = 7;
		public static var DISPLAY_TABLE_HEADER_GROUP:uint = 8;
		public static var DISPLAY_TABLE_FOOTER_GROUP:uint = 9;
		public static var DISPLAY_TABLE:uint = 10;
		public static var DISPLAY_INLINE_TABLE:uint = 11;
		public static var DISPLAY_TABLE_CAPTION:uint = 12;
		public static var DISPLAY_TABLE_CELL:uint = 13;
		public static var DISPLAY_ROW:uint = 14;
		public static var DISPLAY_ROW_GROUP:uint = 15;
		public static var DISPLAY_COLUMN:uint = 16;
		public static var DISPLAY_COLUMN_GROUP:uint = 17;
		
		protected var _display:uint = DisplayValue.DISPLAY_INLINE;
		
		protected static var validStrings:Array = [
			"inline", "none", "block", "inline-block", "list-item", "marker", "compact", "run-in", "table-header-group", "table-footer-group",
			"table", "inline-table", "table-caption", "table-cell", "table-row", "table-row-group", "table-column", "table-column-group"
		];
		
		public function DisplayValue()
		{
			super();
		}
		
		public function get display():uint
		{
			return this._display;
		}
		
		public function set display(display:uint):void
		{
			this._display = display;
		}
		
		public static function parse(str:String):DisplayValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:DisplayValue = new DisplayValue();
			value.rawValue = str;
			
			value.display = Math.max(0, DisplayValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (DisplayValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is DisplayValue)
			{
				return (this.display == (other as DisplayValue).display);
			}
			
			return super.isEquivalent(other);
		}
	}
}
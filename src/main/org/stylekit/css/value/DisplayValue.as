/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is the StyleKit library.
 *
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 *
 * ***** END LICENSE BLOCK ***** */
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
			
			this.modified();
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
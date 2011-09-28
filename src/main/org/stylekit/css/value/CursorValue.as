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

	public class CursorValue extends Value
	{
		public static var CURSOR_AUTO:uint = 0;
		public static var CURSOR_CROSSHAIR:uint = 1;
		public static var CURSOR_DEFAULT:uint = 2;
		public static var CURSOR_POINTER:uint = 3;
		public static var CURSOR_MOVE:uint = 4;
		public static var CURSOR_E_RESIZE:uint = 5;
		public static var CURSOR_NE_RESIZE:uint = 6;
		public static var CURSOR_NW_RESIZE:uint = 7;
		public static var CURSOR_N_RESIZE:uint = 8;
		public static var CURSOR_SE_RESIZE:uint = 9;
		public static var CURSOR_SW_RESIZE:uint = 10;
		public static var CURSOR_S_RESIZE:uint = 11;
		public static var CURSOR_W_RESIZE:uint = 12;
		public static var CURSOR_TEXT:uint = 13;
		public static var CURSOR_WAIT:uint = 14;
		public static var CURSOR_HELP:uint = 15;
		public static var CURSOR_PROGRESS:uint = 16;
		
		protected var _cursor:uint = CursorValue.CURSOR_AUTO;
		protected var _cursorUrl:URLValue = null;
		
		public static var validStrings:Array = [
			"auto", "crosshair", "default", "pointer", "move", "e-resize", "ne-resize", "nw-resize", "n-resize", "se-resize", "sw-resize", "s-resize", "w-resize", "text", "wait", "help", "progress"
		];
		
		public function CursorValue()
		{
			super();
		}
		
		public function get cursor():uint
		{
			return this._cursor;
		}
		
		public function set cursor(cursor:uint):void
		{
			this._cursor = cursor;
		}
		
		public function get cursorUrl():URLValue
		{
			return this._cursorUrl;
		}
		
		public function set cursorUrl(cursorUrl:URLValue):void
		{
			this._cursorUrl = cursorUrl;
			
			this.modified();
		}
		
		public static function parse(str:String):CursorValue
		{
			var fvVal:CursorValue = new CursorValue();
			fvVal.rawValue = str;
			
			if (URLValue.identify(str))
			{
				fvVal.cursorUrl = URLValue.parse(str);
				fvVal.cursor = CursorValue.CURSOR_AUTO;
			}
			else
			{
				str = StringUtil.trim(str).toLowerCase();
				fvVal.cursor = Math.max(0, CursorValue.validStrings.indexOf(str));	
			}
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (CursorValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is CursorValue)
			{
				return (this.cursor == (other as CursorValue).cursor); // && (this.cursorUrl.isEquivalent((other as CursorValue).cursorUrl));
			}
			
			return super.isEquivalent(other);
		}
	}
}
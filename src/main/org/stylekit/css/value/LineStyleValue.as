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
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	public class LineStyleValue extends Value
	{
		
		public static var LINE_STYLE_NONE:uint = 1;
		public static var LINE_STYLE_HIDDEN:uint = 1; // deliberately the same as "none"
		public static var LINE_STYLE_DOTTED:uint = 2;
		public static var LINE_STYLE_DASHED:uint = 3;
		public static var LINE_STYLE_SOLID:uint = 4;
		public static var LINE_STYLE_DOUBLE:uint = 5;
		public static var LINE_STYLE_GROOVE:uint = 6;
		public static var LINE_STYLE_RIDGE:uint = 7;
		public static var LINE_STYLE_INSET:uint = 8;
		public static var LINE_STYLE_OUTSET:uint = 9;
		
		protected static var validStrings:Array = [
			"none", "hidden", "dotted", "dashed", "solid", "double", "groove", "ridge", "inset", "outset"
		];
		
		protected var _lineStyle:uint = LineStyleValue.LINE_STYLE_NONE;
		
		public function LineStyleValue()
		{
			super();
		}
		
		public static function parse(str:String):LineStyleValue
		{
			str = StringUtil.trim(str).toLowerCase();
			var lsVal:LineStyleValue = new LineStyleValue();
				lsVal.rawValue = str;
			lsVal.lineStyle = Math.max(1, LineStyleValue.validStrings.indexOf(str));
			return lsVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (LineStyleValue.validStrings.indexOf(str) > -1);
		}
		
		public function get lineStyle():uint
		{
			return this._lineStyle;
		}
		
		public function set lineStyle(l:uint):void
		{
			this._lineStyle = l;
			
			this.modified();
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is LineStyleValue)
			{
				return (this.lineStyle == (other as LineStyleValue).lineStyle);
			}
			
			return super.isEquivalent(other);
		}
	}
}
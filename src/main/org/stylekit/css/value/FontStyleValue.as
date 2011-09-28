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
	
	public class FontStyleValue extends Value
	{
		
		public static var FONT_STYLE_NORMAL:uint = 1;
		public static var FONT_STYLE_ITALIC:uint = 2;
		public static var FONT_STYLE_OBLIQUE:uint = 3;
		
		public static var validStrings:Array = [
			"normal", "italic", "oblique"
		];
		
		protected var _fontStyle:uint = 1;
		
		public function FontStyleValue()
		{
			super();
		}
		
		public static function parse(str:String):FontStyleValue
		{
			var fsVal:FontStyleValue = new FontStyleValue();
				fsVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fsVal.fontStyle = Math.max(1, FontStyleValue.validStrings.indexOf(str)+1);
			
			return fsVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (FontStyleValue.validStrings.indexOf(str) > -1);
		}
		
		public function get fontStyle():uint
		{
			return this._fontStyle;
		}
		
		public function set fontStyle(fs:uint):void
		{
			this._fontStyle = fs;
			
			this.modified();
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FontStyleValue)
			{
				return (this.fontStyle == (other as FontStyleValue).fontStyle);
			}
			
			return super.isEquivalent(other);
		}
	}
}
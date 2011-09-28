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
	
	public class FontVariantValue extends Value
	{
		public static var FONT_VARIANT_NORMAL:uint = 1;
		public static var FONT_VARIANT_SMALL_CAPS:uint = 2;
		
		public static var validStrings:Array = [
			"normal", "small-caps"
		];
		
		protected var _fontVariant:uint = 1;
		
		public function FontVariantValue()
		{
			super();
		}
		
		public static function parse(str:String):FontVariantValue
		{
			var fvVal:FontVariantValue = new FontVariantValue();
				fvVal.rawValue = str;
				
			str = StringUtil.trim(str).toLowerCase();
			fvVal.fontVariant = Math.max(1, FontVariantValue.validStrings.indexOf(str)+1);
				
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			return (FontVariantValue.validStrings.indexOf(str) > -1);
		}
		
		public function get fontVariant():uint
		{
			return this._fontVariant;
		}

		public function set fontVariant(fs:uint):void
		{
			this._fontVariant = fs;
			
			this.modified();
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FontVariantValue)
			{
				return (this.fontVariant == (other as FontVariantValue).fontVariant);
			}
			
			return super.isEquivalent(other);
		}
	}
}
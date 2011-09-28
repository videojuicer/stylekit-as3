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
	
	public class FontWeightValue extends Value
	{
		
		public static var FONT_WEIGHT_NORMAL:uint = 400;
		public static var FONT_WEIGHT_BOLD:uint = 700;
		public static var FONT_WEIGHT_BOLDER:uint = 900;
		public static var FONT_WEIGHT_LIGHTER:uint = 200;
		
		public static var validStrings:Array = [
			"normal", "bold", "bolder", "lighter"
		];
		
		protected var _fontWeight:uint = 400;
		
		public function FontWeightValue()
		{
			super();
		}
		
		public static function parse(str:String):FontWeightValue
		{
			var fwVal:FontWeightValue = new FontWeightValue();
				fwVal.rawValue = str;
				
			str = StringUtil.trim(str).toLowerCase();
			
			switch(str)
			{
				case "normal":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_NORMAL;
					break;
				case "bold":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_BOLD;
					break;
				case "bolder":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_BOLDER;
					break;
				case "lighter":
					fwVal.fontWeight = FontWeightValue.FONT_WEIGHT_LIGHTER;
					break;
				default:
					var pVal:uint = parseInt(str);
					if(!isNaN(pVal) && (pVal > 0) && (pVal % 100 == 0))
					{
						fwVal.fontWeight = pVal;
					}
					break;
			}
			
			return fwVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str).toLowerCase();
			
			// Check string values
			if(FontWeightValue.validStrings.indexOf(str) > -1)
			{
				return true;
			}
			
			// Check numeric values
			var pVal:uint = parseInt(str);
			if(!isNaN(pVal) && (pVal > 0) && (pVal % 100 == 0))
			{
				return true;
			}
			
			return false;
		}
		
		public function get fontWeight():uint
		{
			return this._fontWeight;
		}

		public function set fontWeight(fs:uint):void
		{
			this._fontWeight = fs;
			
			this.modified();
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FontWeightValue)
			{
				return (this.fontWeight == (other as FontWeightValue).fontWeight);
			}
			
			return super.isEquivalent(other);
		}
	}
}
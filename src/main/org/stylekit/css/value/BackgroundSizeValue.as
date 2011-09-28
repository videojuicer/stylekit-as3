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

	public class BackgroundSizeValue extends SizeValue
	{
		protected var _contain:Boolean = false;
		protected var _cover:Boolean = false;
		
		public function BackgroundSizeValue()
		{
			super();
		}
		
		public function get contain():Boolean
		{
			return this._contain;
		}
		
		public function set contain(value:Boolean):void
		{
			this._contain = value;
			
			this.modified();
		}
		
		public function get cover():Boolean
		{
			return this._cover;
		}
		
		public function set cover(value:Boolean):void
		{
			this._contain = value;
			
			this.modified();
		}
		
		public static function parse(str:String):SizeValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var sVal:BackgroundSizeValue = new BackgroundSizeValue();
			sVal.rawValue = str;
			
			// Substitute word sizings
			if(SizeValue.WORD_VALUE_MAP[str])
			{
				str = SizeValue.WORD_VALUE_MAP[str];
			}
			else if(str == "auto")
			{
				sVal.auto = true;
			}
			else if(str == "cover")
			{
				sVal.cover = true;
			}
			else if(str == "contain")
			{
				sVal.contain = true;
			}
			
			var unitPattern:RegExp = new RegExp("[%a-zA-Z]+");
			var unitIndex:int = str.search(unitPattern);
			
			sVal.value = parseFloat(str);
			
			if(unitIndex >= 0)
			{
				sVal.units = str.substring(unitIndex);
			}
			
			return sVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			var unitPattern:RegExp = new RegExp("[0-9.]+(px|em|%)+");
			var unitIndex:int = str.search(unitPattern);
			return (unitIndex == 0);
		}
	}
}
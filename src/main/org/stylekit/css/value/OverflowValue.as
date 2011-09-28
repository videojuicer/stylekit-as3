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

	public class OverflowValue extends Value
	{
		public static var OVERFLOW_VISIBLE:uint = 0;
		public static var OVERFLOW_HIDDEN:uint = 1;
		public static var OVERFLOW_SCROLL:uint = 2;
		public static var OVERFLOW_AUTO:uint = 3;
		
		protected var _overflow:uint = OverflowValue.OVERFLOW_VISIBLE;
		
		protected static var validStrings:Array = [
			"visible", "hidden", "scroll", "auto"
		];
		
		public function OverflowValue()
		{
			super();
		}
		
		public function get overflow():uint
		{
			return this._overflow;
		}
		
		public function set overflow(overflow:uint):void
		{
			this._overflow = overflow;
			
			this.modified();
		}
		
		public static function parse(str:String):OverflowValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:OverflowValue = new OverflowValue();
			value.rawValue = str;
			
			value.overflow = Math.max(0, OverflowValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (OverflowValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is OverflowValue)
			{
				return (this.overflow == (other as OverflowValue).overflow);
			}
			
			return super.isEquivalent(other);
		}
	}
}
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
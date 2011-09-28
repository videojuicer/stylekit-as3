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

	public class PositionValue extends Value
	{
		public static var POSITION_STATIC:uint = 0;
		public static var POSITION_RELATIVE:uint = 1;
		public static var POSITION_ABSOLUTE:uint = 2;
		public static var POSITION_FIXED:uint = 3;
		
		protected var _position:uint = PositionValue.POSITION_STATIC;
		
		protected static var validStrings:Array = [
			"static", "relative", "absolute", "fixed"
		];
		
		public function PositionValue()
		{
			super();
		}
		
		public function get position():uint
		{
			return this._position;
		}
		
		public function set position(position:uint):void
		{
			this._position = position;
			
			this.modified();
		}
		
		public static function parse(str:String):PositionValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:PositionValue = new PositionValue();
			value.rawValue = str;
			
			value.position = Math.max(0, PositionValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (PositionValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is PositionValue)
			{
				return (this.position == (other as PositionValue).position);
			}
			
			return super.isEquivalent(other);
		}
	}
}
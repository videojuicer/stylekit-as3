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

	public class ListStylePositionValue extends Value
	{
		public static var LISTSTYLE_INSIDE:uint = 0;
		public static var LISTSTYLE_OUTSIDE:uint = 1;
		public static var LISTSTYLE_INHERIT:uint = 2;
		
		protected var _position:uint = ListStylePositionValue.LISTSTYLE_OUTSIDE;
		
		protected static var validStrings:Array = [
			"inside", "outside", "inherit"
		];
		
		public function ListStylePositionValue()
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
		
		public static function parse(str:String):ListStylePositionValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:ListStylePositionValue = new ListStylePositionValue();
			value.rawValue = str;
			
			value.position = Math.max(0, ListStylePositionValue.validStrings.indexOf(str));
			
			return value; 
		}
		
		public static function identify(str:String):Boolean
		{
			return (ListStylePositionValue.validStrings.indexOf(str) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is ListStylePositionValue)
			{
				return (this.position == (other as ListStylePositionValue).position);
			}
			
			return super.isEquivalent(other);
		}
	}
}
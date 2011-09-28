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

	public class FloatValue extends Value
	{
		public static var FLOAT_LEFT:uint = 0;
		public static var FLOAT_RIGHT:uint = 1;
		public static var FLOAT_NONE:uint = 2;
		
		protected var _float:uint = FloatValue.FLOAT_NONE;
		
		protected static var validStrings:Array = [
			"left", "right", "none"
		];
		
		public function FloatValue()
		{
			super();
		}
		
		public function get float():uint
		{
			return this._float;
		}
		
		public function set float(float:uint):void
		{
			this._float = float;
			
			this.modified();
		}
		
		public static function parse(str:String):FloatValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:FloatValue = new FloatValue();
			value.rawValue = str;
			
			value.float = Math.max(0, FloatValue.validStrings.indexOf(str));
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (FloatValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is FloatValue)
			{
				return (this.float == (other as FloatValue).float);
			}
			
			return super.isEquivalent(other);
		}
	}
}
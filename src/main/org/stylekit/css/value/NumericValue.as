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

	public class NumericValue extends Value
	{
		protected var _value:Number = 1;
		
		public function NumericValue()
		{
			super();
		}
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(value:Number):void
		{
			this._value = value;
		}
		
		public static function parse(str:String):NumericValue
		{
			str = StringUtil.trim(str.toLowerCase());
			
			var v:NumericValue = new NumericValue();
			v.rawValue = str;
			
			var f:Number = Math.max(0, Math.min(1, parseFloat(str)));
			
			v.value = f;
			
			return v;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str);
			
			var pattern:RegExp = /[0-1].[0-1.]+/i;
			var index:int = str.search(pattern);
			
			return index == 0;
		}
	}
}
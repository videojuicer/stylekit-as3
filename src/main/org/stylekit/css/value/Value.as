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
package org.stylekit.css.value {
	import flash.events.EventDispatcher;
	
	import org.stylekit.events.ValueEvent;
	import org.utilkit.util.StringUtil;
	
	/**
	* The Value class represents any value attached to a CSS property. There are several specialised value types such as ColorValue and URLValue,
	* but the basic Value class may be used to store basic string values for any property where a specialised Value type is not required.
	*/
	public class Value extends EventDispatcher
	{
		protected var _rawValue:String;
		protected var _stringValue:String;
		protected var _important:Boolean = false;
		
		public function Value()
		{
			
		}
		
		public static function parse(str:String):Value
		{
			var val:Value = new Value();
				val.stringValue = StringUtil.trim(str);
			return val;
		}
		
		public function get important():Boolean
		{
			return this._important;
		}
		
		public function set important(i:Boolean):void
		{
			this._important = i;
			
			this.modified();
		}
		
		public function get stringValue():String
		{
			return this._stringValue;
		}
		
		public function set stringValue(s:String):void
		{
			this._stringValue = s;
		}
		
		public function get rawValue():String
		{
			return this._rawValue;
		}

		public function set rawValue(s:String):void
		{
			this._rawValue = s;
		}
		
		protected function modified():void
		{
			this.dispatchEvent(new ValueEvent(ValueEvent.VALUE_MODIFIED));
		}
		
		public function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is Value)
			{
				return (this._rawValue == other._rawValue || this._stringValue == other._stringValue);
			}
			
			return false;
		}
	}
}
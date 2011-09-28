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
	import org.stylekit.css.parse.ValueParser;

	public class ListStyleCompoundValue extends Value
	{
		protected var _positionValue:ListStylePositionValue;
		protected var _urlValue:URLValue;
		protected var _typeValue:ListStyleTypeValue;
		
		public function ListStyleCompoundValue()
		{
			super();
		}
		
		public function get positionValue():ListStylePositionValue
		{
			return this._positionValue;
		}
		
		public function set positionValue(value:ListStylePositionValue):void
		{
			this._positionValue = value;
			
			this.modified();
		}
		
		public function get urlValue():URLValue
		{
			return this._urlValue;
		}
		
		public function set urlValue(value:URLValue):void
		{
			this._urlValue = value;
			
			this.modified();
		}
		
		public function get typeValue():ListStyleTypeValue
		{
			return this._typeValue;
		}
		
		public function set typeValue(value:ListStyleTypeValue):void
		{
			this._typeValue = value;
			
			this.modified();
		}
		
		public static function parse(str:String):ListStyleCompoundValue
		{
			var value:ListStyleCompoundValue = new ListStyleCompoundValue();
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			for (var i:uint = 0; i < tokens.length; ++i)
			{
				var token:String = tokens[i];
				
				if (ListStylePositionValue.identify(token))
				{
					value.positionValue = ListStylePositionValue.parse(token);
				}
				else if (ListStyleTypeValue.identify(token))
				{
					value.typeValue = ListStyleTypeValue.parse(token);
				}
				else if (URLValue.identify(token))
				{
					value.urlValue = URLValue.parse(token);
				}
			}
			
			return value;
		}
	}
}
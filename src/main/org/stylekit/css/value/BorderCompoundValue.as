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
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ColorValue;
	
	import org.stylekit.css.parse.ValueParser;
	
	public class BorderCompoundValue extends Value
	{
		
		protected var _sizeValue:SizeValue;
		protected var _lineStyleValue:LineStyleValue;
		protected var _colorValue:ColorValue;
		
		public function BorderCompoundValue()
		{
			super();
		}
		
		/**
		* Parses a shorthand border, border-(top|left|right|bottom) property such as "3px solid red" or "5px red" and 
		* returns the resulting BorderCompoundValue object.
		*/
		public static function parse(str:String):BorderCompoundValue
		{
			var bVal:BorderCompoundValue = new BorderCompoundValue();
				bVal.rawValue = str;
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			for(var i:uint=0; i < tokens.length; i++)
			{
				var t:String = tokens[i];
				// Identify as weight
				if(SizeValue.identify(t))
				{
					bVal.sizeValue = SizeValue.parse(t);
				}
				// Identify as style
				else if(LineStyleValue.identify(t))
				{
					bVal.lineStyleValue = LineStyleValue.parse(t);
				}
				// Identify as color
				else if(ColorValue.identify(t))
				{
					bVal.colorValue = ColorValue.parse(t);
				}
			}
			return bVal;
		}
		
		public function get sizeValue():SizeValue
		{
			return this._sizeValue;
		}
		
		public function set sizeValue(s:SizeValue):void
		{
			this._sizeValue = s;
			
			this.modified();
		}
		
		public function get lineStyleValue():LineStyleValue
		{
			return this._lineStyleValue;
		}
		
		public function set lineStyleValue(l:LineStyleValue):void
		{
			this._lineStyleValue = l;
			
			this.modified();
		}
		
		public function get colorValue():ColorValue
		{
			return this._colorValue;
		}
		
		public function set colorValue(c:ColorValue):void
		{
			this._colorValue = c;
			
			this.modified();
		}
	}
}
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
	import org.utilkit.util.StringUtil;

	public class CornerCompoundValue extends Value
	{
		protected var _topRightValue:SizeValue;
		protected var _bottomRightValue:SizeValue;
		protected var _bottomLeftValue:SizeValue;
		protected var _topLeftValue:SizeValue;
		
		public function CornerCompoundValue()
		{
			super();
		}
		
		public function get topRightValue():SizeValue
		{
			return this._topRightValue;
		}
		
		public function set topRightValue(v:SizeValue):void
		{
			this._topRightValue = v;
			
			this.modified();
		}
		
		public function get bottomRightValue():SizeValue
		{
			return this._bottomRightValue;
		}
		
		public function set bottomRightValue(v:SizeValue):void
		{
			this._bottomRightValue = v;
			
			this.modified();
		}
		
		public function get bottomLeftValue():SizeValue
		{
			return this._bottomLeftValue;
		}
		
		public function set bottomLeftValue(v:SizeValue):void
		{
			this._bottomLeftValue = v;
			
			this.modified();
		}
		
		public function get topLeftValue():SizeValue
		{
			return this._topLeftValue;
		}
		
		public function set topLeftValue(v:SizeValue):void
		{
			this._topLeftValue = v;
			
			this.modified();
		}
		
		public static function parse(str:String):CornerCompoundValue
		{
			str = StringUtil.trim(str.toLowerCase());
			
			var sizeStrings:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			var val:CornerCompoundValue = new CornerCompoundValue();
			val.rawValue = str;
			
			var sizeValues:Vector.<SizeValue> = new Vector.<SizeValue>();
			
			for(var i:uint = 0; i < sizeStrings.length; i++)
			{
				sizeValues.push(SizeValue.parse(sizeStrings[i]));
			}
			
			switch (sizeValues.length)
			{
				case 1:
					val.topRightValue = val.bottomRightValue = val.bottomLeftValue = val.topLeftValue = sizeValues[0];
					break;
				case 2:
					val.topRightValue = val.bottomLeftValue = sizeValues[0];
					val.bottomRightValue = val.topLeftValue = sizeValues[1];
					break;
				case 3:
					val.topRightValue = sizeValues[0];
					val.bottomRightValue = sizeValues[2];
					val.topLeftValue = val.bottomLeftValue = sizeValues[1];
					break;
				case 4:
					val.topRightValue = sizeValues[0];
					val.bottomRightValue = sizeValues[1];
					val.bottomLeftValue = sizeValues[2];
					val.topLeftValue = sizeValues[3];
					break;
			}
			
			return val;
		}
	}
}
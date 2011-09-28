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

	public class BackgroundPositionValue extends Value
	{
		public static var POSITION_LEFT:uint = 1;
		public static var POSITION_CENTER:uint = 2;
		public static var POSITION_RIGHT:uint = 3;
		public static var POSITION_TOP:uint = 4;
		public static var POSITION_BOTTOM:uint = 5;
		
		protected var _alignmentX:uint;
		protected var _alignmentY:uint = BackgroundPositionValue.POSITION_CENTER;
		
		protected var _positionX:SizeValue;
		protected var _positionY:SizeValue;
		
		protected static var validStrings:Array = [
			"left", "center", "right", "top", "bottom"	
		];
		
		public function BackgroundPositionValue()
		{
			super();
		}
		
		public function get alignmentX():uint
		{
			return this._alignmentX;
		}
		
		public function set alignmentX(value:uint):void
		{
			this._alignmentX = value;
			
			this.modified();
		}
		
		public function get alignmentY():uint
		{
			return this._alignmentY;
		}
		
		public function set alignmentY(value:uint):void
		{
			this._alignmentY = value;
			
			this.modified();
		}
		
		public function get positionX():SizeValue
		{
			return this._positionX;
		}
		
		public function set positionX(value:SizeValue):void
		{
			this._positionX = value;
			
			this.modified();
		}
		
		public function get positionY():SizeValue
		{
			return this._positionY;
		}
		
		public function set positionY(value:SizeValue):void
		{
			this._positionY = value;
			
			this.modified();
		}
		
		public static function parse(str:String):BackgroundPositionValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:BackgroundPositionValue = new BackgroundPositionValue();
			value.rawValue = str;
			
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			for (var i:uint = 0; i < tokens.length; i++)
			{
				var val:int = BackgroundPositionValue.validStrings.indexOf(tokens[i]);
				var token:int = (val == -1 ? 0 : Math.max(1, val));
				
				if (i == 0)
				{
					if (token >= 1)
					{
						value.alignmentX = token;
						value.alignmentY = BackgroundPositionValue.POSITION_CENTER;
					}
					else
					{
						value.positionX = SizeValue.parse(tokens[i]);
						value.positionY = SizeValue.parse("50%");
					}
				}
				else
				{
					if (token >= 1)
					{
						value.alignmentY = token;
					}
					else
					{
						value.positionY = SizeValue.parse(tokens[i]);
					}
				}
			}
			
			return value;
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if (other is BackgroundPositionValue)
			{
				var val:BackgroundPositionValue = (other as BackgroundPositionValue);
				
				if (this.alignmentX == val.alignmentX)
				{
					if (this.alignmentY == val.alignmentY)
					{
						if (this.positionX == val.positionX)
						{
							if (this.positionY == val.positionY)
							{
								return true;
							}
						}
					}
				}
			}
			
			return super.isEquivalent(other);
		}
	}
}
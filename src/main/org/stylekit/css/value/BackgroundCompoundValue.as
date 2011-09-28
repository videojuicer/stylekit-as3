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
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.RepeatValue;
	
	import org.stylekit.css.parse.ValueParser;
	import org.utilkit.util.StringUtil;
	
	/**
	* A BackgroundCompoundValue represents a shorthand "background: color image repeat position" CSS property.
	*/
	public class BackgroundCompoundValue extends Value
	{
		
		protected var _colorValue:ColorValue;
		protected var _urlValue:URLValue;
		protected var _repeatValue:RepeatValue;
		protected var _alignmentValue:AlignmentValue;
		
		public function BackgroundCompoundValue(){
			super();
		}
		
		/**
		* Parses a shorthand background value and returns a compound value containing all of the found properties.
		* Background shorthand properties may contain a color, a url, a repeat value, and a position value.
		*/
		public static function parse(str:String):BackgroundCompoundValue
		{
			var bVal:BackgroundCompoundValue = new BackgroundCompoundValue();
			var aVal:AlignmentValue = new AlignmentValue();
			var setAVal:Boolean = false;
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				var t:String = tokens[i];
				
				// Try to identify the value as a color value
				if(ColorValue.identify(t))
				{
					bVal.colorValue = ColorValue.parse(t);
				}
				// Try to identify as a url value
				else if(URLValue.identify(t))
				{
					bVal.urlValue = URLValue.parse(t);
				}
				// Exclude the value as a repeat statement
				else if(t.indexOf("repeat") > -1)
				{
					bVal.repeatValue = RepeatValue.parse(t);
				}
				// Exclude the value as a position statement
				else if(t == "top")
				{
					aVal.verticalAlign = AlignmentValue.ALIGN_TOP;
					setAVal = true;
				}
				else if(t == "bottom")
				{
					aVal.verticalAlign = AlignmentValue.ALIGN_BOTTOM;
					setAVal = true;
				}
				else if(t == "left")
				{
					aVal.horizontalAlign = AlignmentValue.ALIGN_LEFT;
					setAVal = true;
				}
				else if(t == "right")
				{
					aVal.horizontalAlign = AlignmentValue.ALIGN_RIGHT;
					setAVal = true;
				}
			}
			
			if(setAVal)
			{
				bVal.alignmentValue = aVal;
			}
			
			return bVal;
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
		
		public function get urlValue():URLValue
		{
			return this._urlValue;
		}
		
		public function set urlValue(u:URLValue):void
		{
			this._urlValue = u;
			
			this.modified();
		}
		
		public function get repeatValue():RepeatValue
		{
			return this._repeatValue;
		}
		
		public function set repeatValue(r:RepeatValue):void
		{
			this._repeatValue = r;
			
			this.modified();
		}
		
		public function get alignmentValue():AlignmentValue
		{
			return this._alignmentValue;
		}
		
		public function set alignmentValue(a:AlignmentValue):void
		{
			this._alignmentValue = a;
			
			this.modified();
		}
	}
}
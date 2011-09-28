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

	public class TextDecorationValue extends Value
	{
		public static var TEXT_DECORATION_NONE:uint = 0;
		public static var TEXT_DECORATION_UNDERLINE:uint = 1;
		public static var TEXT_DECORATION_OVERLINE:uint = 2;
		public static var TEXT_DECORATION_LINE_THROUGH:uint = 3;
		public static var TEXT_DECORATION_BLINK:uint = 4;
		
		protected var _textDecoration:uint = TextDecorationValue.TEXT_DECORATION_NONE;
		
		public static var validStrings:Array = [
			"none", "underline", "overline", "line-through", "blink"
		];
		
		public function TextDecorationValue()
		{
			super();
		}
		
		public function get textDecoration():uint
		{
			return this._textDecoration;
		}
		
		public function set textDecoration(textDecoration:uint):void
		{
			this._textDecoration = textDecoration;
			
			this.modified();
		}
		
		public static function parse(str:String):TextDecorationValue
		{
			var fvVal:TextDecorationValue = new TextDecorationValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textDecoration = Math.max(0, TextDecorationValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextDecorationValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}

		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is TextDecorationValue)
			{
				return (this.textDecoration == (other as TextDecorationValue).textDecoration);
			}
			
			return super.isEquivalent(other);
		}
	}
}
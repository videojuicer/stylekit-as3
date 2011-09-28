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

	public class TextAlignValue extends Value
	{
		public static var TEXT_ALIGN_LEFT:uint = 0;
		public static var TEXT_ALIGN_RIGHT:uint = 1;
		public static var TEXT_ALIGN_CENTER:uint = 2;
		public static var TEXT_ALIGN_JUSTIFY:uint = 3;
		
		protected var _textAlign:uint = TextAlignValue.TEXT_ALIGN_LEFT;
		
		public static var validStrings:Array = [
			"left", "right", "center", "justify"
		];
		
		public function TextAlignValue()
		{
			super();
		}
		
		public function get textAlign():uint
		{
			return this._textAlign;
		}
		
		public function set textAlign(textAlign:uint):void
		{
			this._textAlign = textAlign;
			
			this.modified();
		}
		
		public function get leftAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_LEFT);
		}
		
		public function get rightAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_RIGHT);
		}
		
		public function get centerAlign():Boolean
		{
			return (this._textAlign == TextAlignValue.TEXT_ALIGN_CENTER);
		}
		
		public static function parse(str:String):TextAlignValue
		{
			var fvVal:TextAlignValue = new TextAlignValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textAlign = Math.max(0, TextAlignValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextAlignValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is TextAlignValue)
			{
				return (this.textAlign == (other as TextAlignValue).textAlign);
			}
			
			return super.isEquivalent(other);
		}
	}
}
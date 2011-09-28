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

	public class TextTransformValue extends Value
	{
		public static var TEXT_TRANSFORM_CAPITALIZE:uint = 0;
		public static var TEXT_TRANSFORM_UPPERCASE:uint = 1;
		public static var TEXT_TRANSFORM_LOWERCASE:uint = 2;
		public static var TEXT_TRANSFORM_NONE:uint = 3;
		
		protected var _textTransform:uint = TextTransformValue.TEXT_TRANSFORM_NONE;
		
		public static var validStrings:Array = [
			"capitalize", "uppercase", "lowercase", "none"
		];
		
		public function TextTransformValue()
		{
			super();
		}
		
		public function get textTransform():uint
		{
			return this._textTransform;
		}
		
		public function set textTransform(textTransform:uint):void
		{
			this._textTransform = textTransform;
			
			this.modified();
		}
		
		public static function parse(str:String):TextTransformValue
		{
			var fvVal:TextTransformValue = new TextTransformValue();
			fvVal.rawValue = str;
			
			str = StringUtil.trim(str).toLowerCase();
			fvVal.textTransform = Math.max(0, TextTransformValue.validStrings.indexOf(str));
			
			return fvVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (TextTransformValue.validStrings.indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is TextTransformValue)
			{
				return (this.textTransform == (other as TextTransformValue).textTransform);
			}
			
			return super.isEquivalent(other);
		}
	}
}
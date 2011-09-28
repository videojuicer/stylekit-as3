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
	import org.utilkit.util.StringUtil;
	
	public class AnimationDirectionValue extends Value
	{
		
		public static var DIRECTION_NORMAL:String = "normal";
		public static var DIRECTION_ALTERNATE:String = "alternate";
		
		protected var _direction:String = "normal";
		
		public function AnimationDirectionValue()
		{
			super();
		}
		
		public function get direction():String
		{
			return this._direction;
		}
		
		public function set direction(d:String):void
		{
			this._direction = d;
			this.modified();
		}
		
		public static function parse(str:String):AnimationDirectionValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var val:AnimationDirectionValue = new AnimationDirectionValue();
				// parser code here
				if(str == AnimationDirectionValue.DIRECTION_NORMAL || str == AnimationDirectionValue.DIRECTION_ALTERNATE)
				{
					val.direction = str;
				}
				
			return val;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			return (str == AnimationDirectionValue.DIRECTION_NORMAL || str == AnimationDirectionValue.DIRECTION_ALTERNATE);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is AnimationDirectionValue)
			{
				return (this.direction == (other as AnimationDirectionValue).direction);
			}
			return false;
		}
	}
}
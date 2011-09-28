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
package org.stylekit.css.style
{
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.PropertyContainer;
	
	public class AnimationKeyFrame extends PropertyContainer
	{
		
		/**
		* The time variable on the keyframe block. In the declaration '@keyframes foo { 0% { ... }}', the time selector on the keyframe is "0%".
		*/
		protected var _timeSelector:String;
		
		public function AnimationKeyFrame(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
		}
		
		public function get timeSelector():String
		{
			return this._timeSelector;
		}
		
		public function set timeSelector(ts:String):void
		{
			this._timeSelector = ts;
		}
	}
	
}
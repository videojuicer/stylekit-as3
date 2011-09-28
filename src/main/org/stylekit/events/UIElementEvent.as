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
package org.stylekit.events
{
	import flash.events.Event;
	
	import org.stylekit.ui.element.UIElement;
	
	public class UIElementEvent extends Event
	{
		public static var EFFECTIVE_DIMENSIONS_CHANGED:String = "uiElementEffectiveDimensionsChanged";
		public static var EFFECTIVE_CONTENT_DIMENSIONS_CHANGED:String = "uiElementEffectiveContentDimensionsChanged";
		public static var CONTENT_DIMENSIONS_CHANGED:String = "uiElementContentDimensionsChanged";		
		
		public static var EVALUATED_STYLES_MODIFIED:String = "uiElementEvaluatedStylesModified";
		
		public static var TRANSITION_STARTED:String = "uiElementTransitionStarted";
		public static var TRANSITION_FINISHED:String = "uiElementTransitionFinished";
		
		protected var _uiElement:UIElement;
		
		public function UIElementEvent(type:String, uiElement:UIElement, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._uiElement = uiElement;
		}
		
		public function get uiElement():UIElement
		{
			return this._uiElement;
		}
	}
}
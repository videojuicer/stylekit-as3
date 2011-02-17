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
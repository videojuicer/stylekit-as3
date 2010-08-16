package org.stylekit.events
{
	
	import flash.events.Event;
	import org.stylekit.css.property.PropertyContainer;
	
	public class PropertyContainerEvent extends Event
	{
		
		public static var PROPERTY_ADDED:String = "propertyContainerPropertyAdded";
		public static var PROPERTY_MODIFIED:String = "propertyContainerPropertyModified";
		public static var PROPERTY_REMOVED:String = "propertyContainerPropertyRemoved";
		
		protected var _propertyContainer:PropertyContainer;
		protected var _propertyName:String;
		protected var _propertyValue:String;
		
		public function PropertyContainerEvent(type:String, propertyContainer:PropertyContainer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._propertyContainer = propertyContainer;
		}
		
		public function get propertyContainer():PropertyContainer
		{
			return this._propertyContainer;
		}
		
	}
	
}
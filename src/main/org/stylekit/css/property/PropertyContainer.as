package org.stylekit.css.property
{
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.events.PropertyContainerEvent;
	
	/**
	 * Dispatched when any new properties are added to this container instance..
	 *
	 * @eventType org.stylekit.events.PropertyContainerEvent.PROPERTY_ADDED
	 */
	[Event(name="propertyContainerPropertyAdded", type="org.stylekit.events.PropertyContainerEvent")]
	
	/**
	 * Dispatched when any of the container's existing properties are modified.
	 *
	 * @eventType org.stylekit.events.PropertyContainerEvent.PROPERTY_MODIFIED
	 */
	[Event(name="propertyContainerPropertyModified", type="org.stylekit.events.PropertyContainerEvent")]
	
	/**
	 * Dispatched when any of the container's existing properties are nullified or removed.
	 *
	 * @eventType org.stylekit.events.PropertyContainerEvent.PROPERTY_REMOVED
	 */
	[Event(name="propertyContainerPropertyRemoved", type="org.stylekit.events.PropertyContainerEvent")]
	
	/**
	* <code>PropertyContainer</code> is an abstract class describing any CSS object that holds individual
	* properties. It manages storage and lookup of properties as well as dispatch of modification events
	* on those properties.
	* 
	* A <code>PropertyContainer</code> instance is created on an owning <code>StyleSheet</code> object.
	*/
	
	public class PropertyContainer extends EventDispatcher
	{
		
		protected var _styleSheet:StyleSheet;
		protected var _properties:Object;
		
		public function PropertyContainer(ownerStyleSheet:StyleSheet)
		{
			this._styleSheet = ownerStyleSheet;
		}
		
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}
		
		public function setProperty(propertyName:String, stringValue:String):void
		{
			
		}
		
		public function getProperty(propertyName:String):void
		{
			
		}
		
		public function rmProperty(propertyName:String):void
		{
			
		}
		
	}
}
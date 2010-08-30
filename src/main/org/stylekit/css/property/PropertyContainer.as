package org.stylekit.css.property
{
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.Property;
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
	* It is important to note that when PropertyContainer objects are created by the StyleSheetParser,
	* properties are added to the container in lexical order.
	* 
	* A <code>PropertyContainer</code> instance is created on an owning <code>StyleSheet</code> object.
	*/
	
	public class PropertyContainer extends EventDispatcher
	{
		
		protected var _styleSheet:StyleSheet;
		protected var _properties:Vector.<Property>;
		
		public function PropertyContainer(ownerStyleSheet:StyleSheet)
		{
			this._styleSheet = ownerStyleSheet;
			this._properties = new Vector.<Property>();
		}
		
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}
		
		public function get properties():Vector.<Property>
		{
			return this._properties;
		}
		
		public function addProperty(property:Property):void
		{
			this._properties.push(property);
		}
		
		public function evaluate(mergeParent:Object = null):Object
		{
			if (mergeParent == null)
			{
				mergeParent = new Object();
			}
			
			for (var i:int = 0; i < this._properties.length; i++)
			{
				mergeParent = this._properties[i].evaluateProperty(mergeParent);
			}
			
			return mergeParent;
		}
		
		public function removeProperty(property:Property):void
		{
			this._properties.splice(this._properties.indexOf(property), 1);
		}
				
	}
}
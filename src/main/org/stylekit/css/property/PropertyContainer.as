package org.stylekit.css.property
{
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.FontStyleValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.OverflowValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TextAlignValue;
	import org.stylekit.css.value.TextDecorationValue;
	import org.stylekit.css.value.TextTransformValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.VisibilityValue;
	import org.stylekit.events.PropertyContainerEvent;
	import org.stylekit.events.PropertyEvent;
	import org.stylekit.ui.element.UIElement;
	
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
			property.addEventListener(PropertyEvent.PROPERTY_MODIFIED, this.onPropertyModified);
			
			this._properties.push(property);
			
			this.dispatchEvent(new PropertyContainerEvent(PropertyContainerEvent.PROPERTY_ADDED, this));
		}
		
		public function evaluate(mergeParent:Object, uiElement:UIElement):Object
		{
			for (var i:int = 0; i < this._properties.length; i++)
			{
				mergeParent = this._properties[i].evaluateProperty(mergeParent, uiElement);
			}
			
			return mergeParent;
		}
		
		public function removeProperty(property:Property):void
		{
			property.removeEventListener(PropertyEvent.PROPERTY_MODIFIED, this.onPropertyModified);
			
			this._properties.splice(this._properties.indexOf(property), 1);
			
			this.dispatchEvent(new PropertyContainerEvent(PropertyContainerEvent.PROPERTY_REMOVED, this));
		}
		
		protected function onPropertyModified(e:PropertyEvent):void
		{
			this.dispatchEvent(new PropertyContainerEvent(PropertyContainerEvent.PROPERTY_MODIFIED, this));
		}
		
		public static function get defaultStyles():Object
		{
			var defaults:Object =
			{
				// background
				"background-color": ColorValue.parse("transparent"),
				"background-image": null,
				"background-position": PositionValue.parse("0% 0%"),
				"background-repeat": RepeatValue.parse("repeat"),
				
				// border-left
				"border-left-width": SizeValue.parse("medium"),
				"border-left-style": LineStyleValue.parse("none"),
				"border-left-color": ColorValue.parse("transparent"),
				
				// border-right
				"border-right-width": SizeValue.parse("medium"),
				"border-right-style": LineStyleValue.parse("none"),
				"border-right-color": ColorValue.parse("transparent"),
				
				// border-top
				"border-top-width": SizeValue.parse("medium"),
				"border-top-style": LineStyleValue.parse("none"),
				"border-top-color": ColorValue.parse("transparent"),
				
				// border-bottom
				"border-bottom-width": SizeValue.parse("medium"),
				"border-bottom-style": LineStyleValue.parse("none"),
				"border-bottom-color": ColorValue.parse("transparent"),
				
				// border-radius
				"border-top-right-radius": SizeValue.parse("0px"),
				"border-bottom-right-radius": SizeValue.parse("0px"),
				"border-bottom-left-radius": SizeValue.parse("0px"),
				"border-top-left-radius": SizeValue.parse("0px"),
				
				// positions
				"bottom": SizeValue.parse("auto"),
				"left": SizeValue.parse("auto"),
				"right": SizeValue.parse("auto"),
				"top": SizeValue.parse("auto"),
				
				"clear": AlignmentValue.parse("none"),				
				"float": AlignmentValue.parse("none"),
				"position": PositionValue.parse("static"),
				"text-align": AlignmentValue.parse("left"),
				"vertical-align": AlignmentValue.parse("left"),
				"overflow": OverflowValue.parse("visible"),
				
				// display
				"display": DisplayValue.parse("inline"),
				"color": ColorValue.parse("#000000"),
				"visibility": VisibilityValue.parse("visible"),
				
				// font
				"font-family": Value.parse("sans-serif"),
				"font-size": SizeValue.parse("medium"),
				"font-style": FontStyleValue.parse("medium"),
				"font-variant": FontVariantValue.parse("normal"),
				"font-weight": FontWeightValue.parse("normal"),
				
				// text
				"text-align": TextAlignValue.parse("left"),
				"text-decoration": TextDecorationValue.parse("none"),
				"text-indent": SizeValue.parse("0"),
				"text-transform": TextTransformValue.parse("none"),
				
				// size
				"height": SizeValue.parse("auto"),
				"width": SizeValue.parse("auto"),
				
				"max-height": null,
				"max-width": null,
				"min-height": null,
				"min-width": null,
				
				"letter-spacing": SizeValue.parse("normal"),
				"line-height": SizeValue.parse("normal"),
				
				// margin
				"margin-left": SizeValue.parse("0"),
				"margin-right": SizeValue.parse("0"),
				"margin-bottom": SizeValue.parse("0"),
				"margin-top": SizeValue.parse("0"),
				
				"outline-color": ColorValue.parse("invert"),
				"outline-style": LineStyleValue.parse("none"),
				"outline-width": SizeValue.parse("medium"),
				
				// padding
				"padding-left": SizeValue.parse("0"),
				"padding-right": SizeValue.parse("0"),
				"padding-bottom": SizeValue.parse("0"),
				"padding-top": SizeValue.parse("0"),
				
				"z-index": SizeValue.parse("auto")
			};
			
			return defaults;
		}
	}
}
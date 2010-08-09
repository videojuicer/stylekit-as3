package org.stylekit.css.style
{
	
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.events.StyleEvent;
	
	/**
	 * Dispatched when any of the Style's attributes are modified.
	 *
	 * @eventType org.smilkit.events.ViewportEvent.MUTATION
	 */
	[Event(name="styleMutation", type="org.stylekit.events.StyleEvent")]
	
	/**
	* A Style is a single declarative block within a given owning StyleSheet. It has a *selector* and a number of *properties*.
	* A single block of CSS such as <code>foo { property-one: foo; property-two: bar; }</code> is a single Style within Stylekit.
	*/	
	public class Style extends EventDispatcher
	{
		/* A reference to the Style's owning StyleSheet */
		protected var _styleSheet:StyleSheet;
		protected var _properties:Object = {};
		
		public function Style(ownerStyleSheet:StyleSheet)
		{
			this._styleSheet = ownerStyleSheet;
		}
		
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}
		
	}
	
}
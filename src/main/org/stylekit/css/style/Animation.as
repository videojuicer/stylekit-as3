package org.stylekit.css.style
{
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.events.AnimationEvent;
	
	/**
	 * Dispatched when any of the Animation's attributes are modified.
	 *
	 * @eventType org.smilkit.events.AnimationEvent.MUTATION
	 */
	[Event(name="animationMutation", type="org.stylekit.events.AnimationEvent")]
	
	/**
	* An animation encapsulates a single @keyframes block within an owning StyleSheet object.
	*/
	public class Animation extends EventDispatcher
	{
		protected var _styleSheet:StyleSheet;
		
		/**
		* Instiates a new Animation object within an owning <code>StyleSheet</code> instance.
		* @param ownerStyleSheet The <code>StyleSheet</code> instance to which this animation belongs.
		* @param name The name for this animation as a <code>String</code>. The <code>StyleSheetParser</code> passes name given in the @keyframes block when creating <code>Animation</code> objects.
		*/
		public function Animation(ownerStyleSheet:StyleSheet, name:String) 
		{
			this._styleSheet = ownerStyleSheet;
		}
	}
}
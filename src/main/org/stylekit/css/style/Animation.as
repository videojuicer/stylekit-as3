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
		*/
		public function Animation(ownerStyleSheet:StyleSheet) 
		{
			this._styleSheet = ownerStyleSheet;
		}
	}
}
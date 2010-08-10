package org.stylekit.css.style
{
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.events.FontFaceEvent;
	
	/**
	 * Dispatched when any of the FontFace's attributes are modified.
	 *
	 * @eventType org.smilkit.events.FontFaceEvent.MUTATION
	 */
	[Event(name="fontFaceMutation", type="org.stylekit.events.FontFaceEvent")]
	
	/**
	* An FontFace encapsulates a single @font-face block within an owning StyleSheet object.
	*/
	public class FontFace extends EventDispatcher
	{
		protected var _styleSheet:StyleSheet;
		
		/**
		* Instiates a new FontFace object within an owning <code>StyleSheet</code> instance.
		*/
		public function FontFace(ownerStyleSheet:StyleSheet) 
		{
			this._styleSheet = ownerStyleSheet;
		}
	}
}
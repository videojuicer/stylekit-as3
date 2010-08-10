package org.stylekit.css.style
{
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	
	/**
	* An Import encapsulates a single @import statement within an owning StyleSheet object.
	*/
	public class Import extends EventDispatcher
	{
		protected var _styleSheet:StyleSheet;
		protected var _styleInsertionIndex:uint;
		
		/**
		* Instiates a new Import object within an owning <code>StyleSheet</code> instance and an insertion index for the point 
		* at which any loaded styles should be injected.
		*/
		public function Import(ownerStyleSheet:StyleSheet, styleInsertionIndex:uint=0) 
		{
			this._styleSheet = ownerStyleSheet;
			this._styleInsertionIndex = styleInsertionIndex;
		}
	}
}
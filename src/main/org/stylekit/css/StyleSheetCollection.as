package org.stylekit.css {
	
	/**
	* A StyleSheetCollection object contains a list of individual StyleSheet objects and provides the public-facing API
	* for querying them. The StyleSheetCollection instance is also the main event dispatcher for reacting to changes in the 
	* loaded styling information.
	*/
	
	import flash.events.EventDispatcher;
	import org.stylekit.css.StyleSheet;
	
	public class StyleSheetCollection extends EventDispatcher
	{
		
		protected var _styleSheets:Vector.<StyleSheet>;
		
		public function StyleSheetCollection()
		{
			// Create the empty StyleSheet vector
			this._styleSheets = new Vector.<StyleSheet>();
		}
		
		public function get styleSheets():Vector.<StyleSheet>
		{
			return this._styleSheets;
		}
		
		/**
		* Returns a boolean indicating whether or not the collection contains the specified StyleSheet instance.
		*/
		public function hasStyleSheet(s:StyleSheet):Boolean
		{
			return (this.styleSheets.indexOf(s) > -1);
		}
		
		/**
		* Registers a <code>StyleSheet</code> instance with the collection.
		* @return A boolean, true if the <code>StyleSheet</code> was added and false if it was already present in the collection.
		*/
		public function addStyleSheet(s:StyleSheet):Boolean
		{
			if(this.hasStyleSheet(s)) {
				return false;
			}
			this._styleSheets.push(s);
			return true;
		}
		
		public function removeStyleSheet(s:StyleSheet):void
		{
			
		}
		
	}
	
}
package org.stylekit.css {
	
	/**
	* A StyleSheetCollection object contains a list of individual StyleSheet objects and provides the public-facing API
	* for querying them. The StyleSheetCollection instance is also the main event dispatcher for reacting to changes in the 
	* loaded styling information.
	*/
	
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.events.StyleSheetEvent;
	
	/**
	 * Dispatched when the StyleSheet collection is altered in anyway.
	 *
	 * @eventType org.stylekit.events.StyleSheetEvent.STYLESHEET_MODIFIED
	 */
	[Event(name="styleSheetModified", type="org.stylekit.events.StyleSheetEvent")]
	
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
			if(this.hasStyleSheet(s))
			{
				return false;
			}
			
			s.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);
			
			this._styleSheets.push(s);
			
			this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
			
			return true;
		}
		
		/** Removes a <code>StyleSheet</code> instance from the collection.
		* @return A boolean, true if the <code>StyleSheet</code> was removed and false if it was not present in the collection.
		*/
		public function removeStyleSheet(s:StyleSheet):Boolean
		{
			if(this.hasStyleSheet(s))
			{
				this._styleSheets.splice(this._styleSheets.indexOf(s), 1);
				
				s.removeEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);
				
				this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
				
				return true;
			}
			
			return false;
		}
		
		public function get length():uint
		{
			return this._styleSheets.length;
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent):void
		{
			this.dispatchEvent(e);
		}
	}
}
package org.stylekit.css {
	
	/**
	* A StyleSheet object represents an individual package of CSS styles, usually parsed from a String input.
	* Each StyleSheet object is expected to belong to a <code>StyleSheetCollection</code> instance before it may be
	* queried.
	*/ 
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.style.Style;
	import org.stylekit.events.PropertyContainerEvent;
	
	public class StyleSheet extends EventDispatcher
	{
		
		protected var _styles:Vector.<Style>;
		
		public function StyleSheet()
		{
			this._styles = new Vector.<Style>;
		}
		
		public function hasStyle(s:Style):Boolean
		{
			return (this._styles.indexOf(s) > -1);
		}
		
		public function addStyle(s:Style, atIndex:int=-1):Boolean
		{
			if(this.hasStyle(s))
			{
				return false;
			}
			this._styles.splice(atIndex, 0, s);
			s.addEventListener(PropertyContainerEvent.PROPERTY_ADDED, this.onStyleMutation);
			s.addEventListener(PropertyContainerEvent.PROPERTY_MODIFIED, this.onStyleMutation);
			s.addEventListener(PropertyContainerEvent.PROPERTY_REMOVED, this.onStyleMutation);
			return true;
		}
		
		/**
		* Removes a <code>Style</code> object from the Stylesheet.
		* @return A boolean, true if the <code>Style</code> object was removed and false if it was not present.
		*/
		public function removeStyle(s:Style):Boolean
		{
			if(this.hasStyle(s))
			{
				this._styles.splice(this._styles.indexOf(s), 1);
				s.removeEventListener(PropertyContainerEvent.PROPERTY_ADDED, this.onStyleMutation);
				s.removeEventListener(PropertyContainerEvent.PROPERTY_MODIFIED, this.onStyleMutation);
				s.removeEventListener(PropertyContainerEvent.PROPERTY_REMOVED, this.onStyleMutation);
				return true;
			}
			return false;
		}
		
		public function get styles():Vector.<Style>
		{
			return this._styles;
		}
		
		protected function onStyleMutation(e:PropertyContainerEvent):void
		{
			
		}
		
	}
	
}
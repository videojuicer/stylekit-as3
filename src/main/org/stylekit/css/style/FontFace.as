package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.property.PropertyContainer;
	import org.stylekit.css.style.selector.MediaSelector;
	
	/**
	* An FontFace encapsulates a single @font-face block within an owning StyleSheet object.
	*/
	public class FontFace extends PropertyContainer
	{
		
		/**
		* A reference to a <code>MediaSelector</code> object used to restrict this instance to a specific set of media types.
		*/ 
		protected var _mediaSelector:MediaSelector;
		
		
		/**
		* Instiates a new FontFace object within an owning <code>StyleSheet</code> instance.
		*/
		public function FontFace(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
		}
		
		public function set mediaSelector(ms:MediaSelector):void
		{
			this._mediaSelector = ms;
		}
		
		public function get mediaSelector():MediaSelector
		{
			return this._mediaSelector;
		}
	}
}
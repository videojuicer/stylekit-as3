package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.property.PropertyContainer;
	
	/**
	* An FontFace encapsulates a single @font-face block within an owning StyleSheet object.
	*/
	public class FontFace extends PropertyContainer
	{
		/**
		* Instiates a new FontFace object within an owning <code>StyleSheet</code> instance.
		*/
		public function FontFace(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
		}
	}
}
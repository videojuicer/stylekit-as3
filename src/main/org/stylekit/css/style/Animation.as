package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.property.PropertyContainer;
	
	/**
	* An animation encapsulates a single @keyframes block within an owning StyleSheet object.
	*/
	public class Animation extends PropertyContainer
	{
		
		/**
		* Instiates a new Animation object within an owning <code>StyleSheet</code> instance.
		* @param ownerStyleSheet The <code>StyleSheet</code> instance to which this animation belongs.
		* @param name The name for this animation as a <code>String</code>. The <code>StyleSheetParser</code> passes name given in the @keyframes block when creating <code>Animation</code> objects.
		*/
		public function Animation(ownerStyleSheet:StyleSheet, name:String) 
		{
			super(ownerStyleSheet);
		}
	}
}
package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.property.PropertyContainer;
		
	/**
	* A Style is a single declarative block within a given owning StyleSheet.
	* A single block of CSS such as <code>foo { property-one: foo; property-two: bar; }</code> is a single Style within Stylekit.
	*/	
	public class Style extends PropertyContainer
	{
		
		public function Style(ownerStyleSheet:StyleSheet)
		{
			super(ownerStyleSheet);
		}
				
	}
	
}
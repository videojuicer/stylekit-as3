package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.selector.MediaSelector;	
	import org.stylekit.css.selector.ElementSelectorChain;	
	
	/**
	* A Style is a single declarative block within a given owning StyleSheet.
	* A single block of CSS such as <code>foo { property-one: foo; property-two: bar; }</code> is a single Style within Stylekit.
	*/	
	public class Style extends PropertyContainer
	{
		
		/**
		* A reference to a <code>MediaSelector</code> object used to restrict this instance to a specific set of media types.
		*/ 
		protected var _mediaSelector:MediaSelector;
		protected var _elementSelectorChains:Vector.<ElementSelectorChain>;
		
		public function Style(ownerStyleSheet:StyleSheet)
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
		
		public function set elementSelectorChains(e:Vector.<ElementSelectorChain>):void
		{
			this._elementSelectorChains = e;
		}
		
		public function get elementSelectorChains():Vector.<ElementSelectorChain>
		{
			return this._elementSelectorChains;
		}
		
	}
	
}
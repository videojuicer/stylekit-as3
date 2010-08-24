package org.stylekit.ui
{
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.ui.element.UIElement;
	
	public class BaseUI extends UIElement
	{
		protected var _styleSheetCollection:StyleSheetCollection;
		
		public function BaseUI(styleSheetCollection:StyleSheetCollection = null)
		{
			super();
			
			this._styleSheetCollection = styleSheetCollection;
		}
		
		public override function get baseUI():BaseUI
		{
			return this;
		}
		
		public override function get styleEligible():Boolean
		{
			return true;
		}
		
		public override function get styleParent():UIElement
		{
			return this;
		}
		
		public function get styleSheetCollection():StyleSheetCollection
		{
			return this._styleSheetCollection;
		}
		
		public function createUIElement():UIElement
		{
			return new UIElement(this);
		}
	}
}
package org.stylekit.ui
{
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.ui.element.UIElement;
	
	public class BaseUI extends UIElement
	{
		protected var _styleSheetCollection:StyleSheetCollection;
		
		public function BaseUI()
		{
			super();
		}
		
		public override function get baseUI():BaseUI
		{
			return this;
		}
		
		public override function get styleEligible():Boolean
		{
			return true;
		}
		
		public function get styleSheetCollection():StyleSheetCollection
		{
			return this._styleSheetCollection;
		}
	}
}
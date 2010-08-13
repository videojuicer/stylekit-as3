package org.stylekit.ui
{
	import org.stylekit.ui.element.UIElement;
	
	public class BaseUI extends UIElement
	{
		public function BaseUI()
		{
			super();
		}
		
		public override function get baseUI():BaseUI
		{
			return this;
		}
	}
}
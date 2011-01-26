package org.stylekit.spec.tests.ui.element.paint
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.ui.element.UIElement;

	public class UIElementPainterTestCase
	{
		[Test(description="Tests that the border-radius rule applies the correct curve to the background of a UIElement")]
		public function borderRadiusCurvesCorrectly():void
		{
			var box:UIElement = new UIElement();
			box.evaluatedStyles = {
				'width': SizeValue.parse("100px"),
				'height': SizeValue.parse("100px"),
				'border-radius': SizeValue.parse("5px")
			};
			
			Assert.assertFalse(box.hitTestPoint(0, 0, true));
			Assert.assertFalse(box.hitTestPoint(0, 1, true));
			Assert.assertFalse(box.hitTestPoint(1, 0, true));
			
			Assert.assertTrue(box.hitTestPoint(1, 1, true));
		}
	}
}
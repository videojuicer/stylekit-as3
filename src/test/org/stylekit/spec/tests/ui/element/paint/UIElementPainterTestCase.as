package org.stylekit.spec.tests.ui.element.paint
{
	import flash.geom.Point;
	
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;

	public class UIElementPainterTestCase
	{
		protected var _baseUI:BaseUI;
		protected var _box:UIElement;
		
		[Before]
		public function setUp():void
		{
			this._baseUI = new BaseUI(null, SpecRunner.root);
			this._baseUI.evaluatedStyles = {
				'width': SizeValue.parse("100px"),
					'height': SizeValue.parse("100px")
			};
			
			SpecRunner.root.addChild(this._baseUI);
			
			this._box = new UIElement();
			this._box.evaluatedStyles = {
				'background-color': ColorValue.parse("black"),
				'width': SizeValue.parse("100px"),
				'height': SizeValue.parse("100px"),
				'border-top-right-radius': SizeValue.parse("5px"),
				'border-top-left-radius': SizeValue.parse("5px"),
				'border-bottom-right-radius': SizeValue.parse("5px"),
				'border-bottom-left-radius': SizeValue.parse("5px")
			};
			
			this._baseUI.addElement(this._box);
		}
		
		[Test(description="Tests that the border-radius rule applies the correct curve to the background of a UIElement")]
		public function borderRadiusCurvesCorrectly():void
		{			
			this._box.redraw();
			
			Assert.assertFalse(this.hitTestOnLocalPoint(0, 0));
			Assert.assertFalse(this.hitTestOnLocalPoint(0, 1));
			Assert.assertFalse(this.hitTestOnLocalPoint(1, 0));
			
			Assert.assertTrue(this.hitTestOnLocalPoint(1, 1));
			Assert.assertTrue(this.hitTestOnLocalPoint(25, 25));
		}
		
		protected function hitTestOnLocalPoint(x:Number, y:Number):Boolean
		{
			var p:Point = this._box.localToGlobal(new Point(x, y));
			
			return this._box.hitTestPoint(p.x, p.y, true);
		}
	}
}
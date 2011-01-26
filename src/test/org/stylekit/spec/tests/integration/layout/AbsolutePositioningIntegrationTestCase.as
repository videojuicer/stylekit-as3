package org.stylekit.spec.tests.integration.layout
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import flash.geom.Point;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	
	import org.stylekit.spec.Fixtures;
	
	public class AbsolutePositioningIntegrationTestCase
	{
		protected var _baseUI:BaseUI;
		protected var _styleSheetCollection:StyleSheetCollection;
		protected var _styleSheets:Vector.<StyleSheet>;
		protected var _parsed:StyleSheet;
		
		[Before]
		public function setUp():void
		{
			this._baseUI = new BaseUI();
		}
		
		[After]
		public function tearDown():void
		{
			this._baseUI = null;
		}
		
		[Test(description="Tests a regression issue where elements with the 'bottom' property are incorrectly positioned (http://www.bugtails.com/projects/253/tickets/1167.html)")]
		public function bottomAnchoredElementsPositionedCorrectly():void
		{
			var container:UIElement = new UIElement(this._baseUI);
			var box:UIElement = new UIElement(this._baseUI);
			var shim1:UIElement = new UIElement(this._baseUI);
			var shim2:UIElement = new UIElement(this._baseUI);
			var testSubject:UIElement = new UIElement(this._baseUI);
			
			// In the original manifestation of this problem, there were two other block elements
			// in the container before the test subject element was added.
			// This block of assertions tests this particular setup.
			
			this._baseUI.addElement(container);
			container.addElement(box);
			box.addElement(shim1);
			box.addElement(shim2);
			box.addElement(testSubject);

			this._baseUI.localStyleString = "width: 100px; height: 100px;";
			box.localStyleString = "float: right; width: 30px; height: 30px;";
			container.localStyleString = "position: absolute; bottom: 0px; display: block; width: 100%; height: 30px;";
			shim1.localStyleString = "float: left; position: relative; display: block; width: 100px; height: 100px;";
			shim2.localStyleString = "display: none;";
			testSubject.localStyleString = "display: block; width: 50px; height: 100px; position: absolute; bottom: 30px";
			
			Assert.assertEquals(100, testSubject.effectiveHeight);
			Assert.assertEquals(0, this._baseUI.localToGlobal(new Point(0,0)).y);
			Assert.assertEquals(-30, testSubject.localToGlobal(new Point(0,0)).y);
			
			// And now we remove the shim elements and assert that the position hasn't changed.
		}
	}
}
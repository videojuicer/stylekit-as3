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
	
	public class ElementSizeIntegrationTestCase
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
		
		[Test(description="Elements with height: auto correctly recalculate their dimensions when children modify their sizes")]
		public function heightAutoElementsCalculateContentSizes():void
		{
			var wrapper:UIElement = new UIElement(this._baseUI);
				wrapper.localStyleString = "width: 100px; height: auto;";
			
			Assert.assertEquals(0, wrapper.contentHeight);
			
			var children:Vector.<UIElement> = new Vector.<UIElement>();
			for(var i:uint=0; i<5; i++)
			{
				var h:uint = wrapper.contentHeight;
				var c:UIElement = new UIElement(this._baseUI);
					c.localStyleString = "display: block; width: 50px; height: 10px;";
				children.push(c);
				
				wrapper.addElement(c);
				Assert.assertEquals(h+10, wrapper.contentHeight);
			}
			
			// Now take a child and increase its size
			children[0].localStyleString = "display: block; width: 50px; height: 100px;";
			Assert.assertEquals(140, wrapper.contentHeight);
			
			// Now do something evil - set them all to float
			for(var j:uint=0; j<children.length; j++)
			{
				children[j].localStyleString = "display: block; width: 50px; height: 10px; float: left;";
			}
			// It should now be wrapped onto three lines
			Assert.assertEquals(30, wrapper.contentHeight);
		}
	}
}
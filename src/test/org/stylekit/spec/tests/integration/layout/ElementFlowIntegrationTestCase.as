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
	
	public class ElementFlowIntegrationTestCase
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
		
		[Test(description="Tests a regression in which flow control lines may be positioned in the wrong order")]
		public function controlLinesAppearInOrderRegardlessofZIndex():void
		{
			var numChildren:int = 10;
			var children:Vector.<UIElement> = new Vector.<UIElement>();
			var childWidth:Number = 50;
			var childHeight:Number = childWidth;
			var pad:Number = 10;
			
			var wrapper:UIElement = new UIElement(this._baseUI);
				wrapper.localStyleString = "width: "+(childWidth*2)+"px; height: auto; padding: "+pad+"px;";
			
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:UIElement = new UIElement(this._baseUI);
					// Interleave z-indexes just to annoy the test
					var styleFragment:String = "width: "+childWidth+"px; height: "+childHeight+"px; float: left;";
					if(i%2 == 0)
					{
						child.localStyleString = "z-index: "+(numChildren-i)+"; "+styleFragment; 
					}
					else
					{
						child.localStyleString = styleFragment;
					}
					
				children.push(child);
				wrapper.addElement(child);
				
				// Now ensure that children are still all positioned correctly
				for(var j:Number = 0; j < children.length; j++)
				{
					// Should be two elements per row
					var c:UIElement = children[j];
					var cOriginPoint:Point = c.localToGlobal(new Point(0,0));
					
					if(j%2 == 1)
					{
						// Should be at right
						Assert.assertEquals(childWidth+pad, cOriginPoint.x);
					}
					else
					{
						// Should be at left
						Assert.assertEquals(pad, cOriginPoint.x);
					}
					
					// Heights same for all element sets
					var yErr:String = "Y Position tests for element "+j+" failed when adding child "+i;
					Assert.assertEquals(yErr, pad+( Math.floor(j/2) * childHeight ), cOriginPoint.y);
				}
			}
			
		}
	}
}
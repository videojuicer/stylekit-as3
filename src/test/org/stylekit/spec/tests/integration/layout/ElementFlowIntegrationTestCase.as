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
	import org.stylekit.ui.element.layout.FlowControlLine;
	
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
		
		[Test(desciption="Ensures that negative z-indexes are properly respected when sorting elements into control lines")]
		public function negativeZIndexesRespected():void
		{
			var backgroundElem:UIElement = new UIElement(this._baseUI);
				backgroundElem.localStyleString = "display: block; position: absolute; z-index: -200";
			
			var numForegroundElements:int = 10;
			var elementQueue:Vector.<UIElement> = new Vector.<UIElement>();
			
			var i:int;
			var e:UIElement;
			var line:FlowControlLine;
			var lineElements:Vector.<UIElement>
			
			for(i=0; i < numForegroundElements; i++)
			{
				e = new UIElement(this._baseUI);
				e.localStyleString = "display: block; position: absolute; z-index: "+i;
				e.elementId = "element_"+i;
				elementQueue.push(e);
			}
			
			// Add the elements one at a time, each time asserting that the flow has been entered in the correct order.
			for(i=0; i < elementQueue.length; i++)
			{
				e = elementQueue[i];
				this._baseUI.addElement(e);
				
				// Check the position of all elements in the baseUI's control line order
				// working assumption: because each element is position: absolute, each element gets its own control line
				for(var j:int = 0; j < this._baseUI.controlLines.length; j++)
				{
					line = this._baseUI.controlLines[j];
					lineElements = line.elements;
					Assert.assertEquals("Broken assumption: each line expected to contain only 1 element", 
										1, lineElements.length);
					// Expect line and element indexes to match up
					Assert.assertEquals("Expected to find element "+j+" as the first element in line "+j, 
										elementQueue[j], line.elements[0]);
				}
			}
			// Now push the background element to the parent
			this._baseUI.addElement(backgroundElem);
			// Check it appears in the first line and all other elements appear in k-1
			for(var k:int = 0; k < this._baseUI.controlLines.length; k++)
			{
				line = this._baseUI.controlLines[k];
				lineElements = line.elements;
				Assert.assertEquals(1, line.elements.length);
				if(k == 0)
				{					
					Assert.assertEquals(0, line.elements.indexOf(backgroundElem));
				}
				else
				{
					Assert.assertEquals(0, line.elements.indexOf(elementQueue[k-1]));
				}
			}
			
		}
	}
}
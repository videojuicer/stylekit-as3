package org.stylekit.spec.tests.ui.element
{
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.spec.Fixtures;
	import org.stylekit.ui.element.UIElement;
	
	public class UIElementTestCase
	{
		[Before]
		public function setUp():void
		{
			
		}
		
		[Test(description="Tests that a UIElement can contain children that belong to the parent and the children can be removed")]
		public function elementCanContainChildren():void
		{
			var child:UIElement = new UIElement();
			var parent:UIElement = new UIElement();
			
			parent.addElement(child);
			
			Assert.assertEquals(1, parent.numChildren);
			Assert.assertEquals(parent, child.parentElement);
			Assert.assertEquals(parent.firstChild, child);
			
			parent.removeElement(child);
			
			Assert.assertEquals(0, parent.numChildren);
		}
		
		[Test(description="Tests that a UIElement contains the correct first and last children and that children can be inserted at any index")]
		public function elementHasFirstAndLastChildren():void
		{
			var child1:UIElement = new UIElement();
			var child2:UIElement = new UIElement();
			var child3:UIElement = new UIElement();
			
			var parent:UIElement = new UIElement();
			
			parent.addElement(child1);
			parent.addElement(child3);
			
			Assert.assertEquals(child1, parent.firstChild);
			Assert.assertEquals(child3, parent.lastChild);
			
			parent.addElementAt(child2, 1);
			
			Assert.assertEquals(child1, parent.firstChild);
			Assert.assertEquals(child3, parent.lastChild);
		}
		
		[Test(description="Tests that a UIElement can have pseduo classes attached and removed")]
		public function canHasPseudoClass():void
		{
			var element:UIElement = new UIElement();
			
			element.addElementPseudoClass("hover");
			
			Assert.assertTrue(element.hasElementPseudoClass("hover"));
				
			element.removeElementPseudoClass("hover");
			
			Assert.assertFalse(element.hasElementPseudoClass("hover"));
		}
		
		[Test(description="Tests that a UIElement can have class names attached and removed")]
		public function canHasClassNames():void
		{
			var element:UIElement = new UIElement();
			
			element.addElementClassName("test");
			
			Assert.assertTrue(element.hasElementClassName("test"));
			
			element.removeElementClassName("test");
			
			Assert.assertFalse(element.hasElementClassName("test"));
		}
		
		[Test(description="Tests that a child UIElement contains the correct parent index")]
		public function parentIndexCalculatedCorrectly():void
		{
			var parent:UIElement = new UIElement();
			
			var child1:UIElement = new UIElement();
			var child2:UIElement = new UIElement();
			var child3:UIElement = new UIElement();
			
			parent.addElement(child1);
			parent.addElement(child2);
			parent.addElement(child3);
			
			Assert.assertEquals(0, child1.parentIndex);
			Assert.assertEquals(1, child2.parentIndex);
			Assert.assertEquals(2, child3.parentIndex);
			
			parent.removeElement(child2);
			
			Assert.assertEquals(0, child1.parentIndex);
			Assert.assertEquals(1, child3.parentIndex);
		}
			
		[Test(async, description="Tests that a UIElement can react to the events dispatched from its children")]
		public function parentElementCanListen():void
		{
			var child:UIElement = new UIElement();
			var parent:UIElement = new UIElement();
			
			parent.addElement(child);
			
			var asyncCallback:Function = Async.asyncHandler(this, this.onEffectiveDimensionsChanged, 2000, { child: child, parent: parent }, this.onEffectiveDimensionsChangedTimeout);
			
			child.addEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, asyncCallback);
			
			child.dispatchEvent(new UIElementEvent(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, child));
		}
		
		protected function onEffectiveDimensionsChanged(e:UIElementEvent, passThru:Object):void
		{
			Assert.assertEquals(e.uiElement, passThru.child);
			Assert.assertEquals(e.uiElement.parentElement, passThru.parent);
		}
		
		protected function onEffectiveDimensionsChangedTimeout(passThru:Object):void
		{
			Assert.fail("Timeout reached whilst waiting for UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED to be dispatched.");
		}
	}
}
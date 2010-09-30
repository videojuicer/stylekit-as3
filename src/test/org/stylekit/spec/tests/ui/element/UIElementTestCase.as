
package org.stylekit.spec.tests.ui.element
{
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import mx.core.mx_internal;
	import mx.utils.object_proxy;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.selector.ElementSelector;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.selector.MediaSelector;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.spec.Fixtures;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	
	public class UIElementTestCase
	{
		protected var _baseUI:BaseUI;
		protected var _element:UIElement;
		
		[Before]
		public function setUp():void
		{
			this._baseUI = new BaseUI();
			this._element = new UIElement(this._baseUI);
			
			var child1:UIElement = new UIElement(this._baseUI);
			var child2:UIElement = new UIElement(this._baseUI);
			var child3:UIElement = new UIElement(this._baseUI);
			
			child1.elementName = "div";
			child2.elementName = "p";
			child3.elementName = "div";
			
			var child4:UIElement = new UIElement(this._baseUI);
			
			child2.addElement(child4);
			
			this._element.addElement(child1);
			this._element.addElement(child2);
			this._element.addElement(child3);
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
		
		[Test(description="Tests that a UIElement can be matched against a selector, and fail against a incorrect match")]
		public function selectorsMatchAnElement():void
		{
			var child:UIElement = new UIElement();
			child.elementName = "h1";
			child.addElementClassName("selected");
			
			var selector:ElementSelector = new ElementSelector();
			selector.elementName = "h1";
			selector.addElementClassName("selected");
			selector.addElementPseudoClass("hover");
			
			var invalidSelector:ElementSelector = new ElementSelector();
			invalidSelector.elementName = "div";
			invalidSelector.addElementClassName("unselected");
			invalidSelector.addElementPseudoClass("mouseover");
			
			Assert.assertFalse(child.matchesElementSelector(selector));
			Assert.assertFalse(child.matchesElementSelector(invalidSelector));
			
			child.addElementPseudoClass("hover");
			
			Assert.assertTrue(child.matchesElementSelector(selector));
			Assert.assertFalse(child.matchesElementSelector(invalidSelector));
		}
		
		[Test(description="Tests that a UIElement can be matched against a chain of selector elements")]
		public function chainSelectorsMatchAnElement():void
		{
			var child1:ElementSelector = new ElementSelector();
			child1.elementName = "p";
			
			var child2:ElementSelector = new ElementSelector();
			child2.elementName = "div";
			child2.addElementClassName("current");
			
			var child3:ElementSelector = new ElementSelector();
			child3.elementName = "body";
			child3.addElementPseudoClass("hover");
			
			var element1:UIElement = new UIElement();
			element1.elementName = "p";
			element1.styleEligible = true;
			
			var element2:UIElement = new UIElement();
			element2.elementName = "d-iv";
			element2.addElementClassName("current");
			element2.styleEligible = true;
			
			var element3:UIElement = new UIElement();
			element3.elementName = "body";
			element3.addElementPseudoClass("hover");
			element3.styleEligible = true;
			
			element1.parentElement = element2;
			element2.parentElement = element3;
			
			var chain:ElementSelectorChain = new ElementSelectorChain();
			
			chain.addElementSelector(child1);
			chain.addElementSelector(child2);
			chain.addElementSelector(child3);	
			
			Assert.assertFalse(element1.matchesElementSelectorChain(chain));
			
			element2.elementName = "div";
			
			Assert.assertTrue(element1.matchesElementSelectorChain(chain));
		}
		
		public function elementCanCollectStyles():void
		{
			var collection:StyleSheetCollection = new StyleSheetCollection();
			var styleSheet:StyleSheet = new StyleSheet();
			var style:Style = new Style(styleSheet);
			
			style.mediaSelector = new MediaSelector();
			style.mediaSelector.addMedia("div");
			
			styleSheet.addStyle(style);
			
			collection.addStyleSheet(styleSheet);
			
			var baseUI:BaseUI = new BaseUI(collection);
			var uiElement:UIElement = baseUI.createUIElement();
			uiElement.elementName = "div";
			
			uiElement.updateStyles();
		
			Assert.assertEquals(1, uiElement.styles.length);
			
			var newStyle:Style = uiElement.styles[0];
			
			Assert.assertEquals(style, newStyle);
		}
		
		public function getElementsBySelector():void
		{
			var selector:ElementSelector = new ElementSelector();
			selector.elementName = "div";
			
			var elements:Vector.<UIElement> = this._element.getElementsBySelector(selector);
			
			Assert.assertNotNull(elements);
			Assert.assertEquals(2, elements.length);
		}
		
		public function getElementsBySelectorString():void
		{			
			var elements:Vector.<UIElement> = this._element.getElementsBySelector("div");
			
			Assert.assertNotNull(elements);
			Assert.assertEquals(1, elements.length);
		}
		
		public function getElementsByChainSelector():void
		{
			var chainSelector:ElementSelectorChain = new ElementSelectorChain();
			
			var selector:ElementSelector = new ElementSelector();
			selector.elementName = "p";
			
			chainSelector.addElementSelector(selector);
			
			selector = new ElementSelector();
			selector.elementName = "div";
			
			chainSelector.addElementSelector(selector);
			
			var elements:Vector.<UIElement> = this._element.getElementsBySelector(chainSelector);
			
			Assert.assertNotNull(elements);
			Assert.assertEquals(1, elements.length);
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
		
		[Test(async, description="Tests that a UIElement dispatches an EVALUATED_STYLES_MODIFIED event when new keys are added")]
		public function dispatchesEvaluatedStylesModifiedOnNewKeys():void
		{
			var element:UIElement = new UIElement();
			var asyncCallback:Function = Async.asyncHandler(this, this.onEvaluatedStylesModified, 1000, { element: element }, this.onEvaluatedStylesModifiedTimeout);
			
			element.evaluatedStyles = {"fake-size-value": SizeValue.parse("10px")};
			element.addEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, asyncCallback);
			element.evaluatedStyles = {"fake-size-value": SizeValue.parse("10px"), "added-value": SizeValue.parse("5%")};
		}
		
		[Test(description="Ensures that a UIElement allows its size to be bounded by the min- and max- width/height CSS properties")]
		public function effectiveContentDimensionsMayBeBounded():void
		{
			var e:UIElement = new UIElement();
			e.evaluatedStyles = {"width": SizeValue.parse("100px"), "height": SizeValue.parse("200px")};
			Assert.assertEquals(100, e.effectiveContentWidth);
			Assert.assertEquals(200, e.effectiveContentHeight);
			
			// Now do maxima
			e.evaluatedStyles = {"width": SizeValue.parse("100px"), "height": SizeValue.parse("200px"), "max-width": SizeValue.parse("50px"), "max-height": SizeValue.parse("100px")};
			Assert.assertEquals(50, e.effectiveContentWidth);
			Assert.assertEquals(100, e.effectiveContentHeight);
			
			// Now do minimums
			e.evaluatedStyles = {"width": SizeValue.parse("100px"), "height": SizeValue.parse("200px"), "min-width": SizeValue.parse("200px"), "min-height": SizeValue.parse("400px")};
			Assert.assertEquals(200, e.effectiveContentWidth);
			Assert.assertEquals(400, e.effectiveContentHeight);
		}
		
		[Test(async, description="Tests that a UIElement dispatches an EVALUATED_STYLES_MODIFIED event when keys are removed")]
		public function dispatchesEvaluatedStylesModifiedOnRemovedKeys():void
		{
			var element:UIElement = new UIElement();
			var asyncCallback:Function = Async.asyncHandler(this, this.onEvaluatedStylesModified, 1000, { element: element }, this.onEvaluatedStylesModifiedTimeout);
			
			element.evaluatedStyles = {"fake-size-value": SizeValue.parse("10px")};
			element.addEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, asyncCallback);
			element.evaluatedStyles = {"fake-size-value": SizeValue.parse("50%")};
		}
		
		[Test(async, description="Tests that a UIElement dispatches an EVALUATED_STYLES_MODIFIED event when keys are no longer equivalent")]
		public function dispatchesEvaluatedStylesModifiedKeysNotEquivalent():void
		{
			var element:UIElement = new UIElement();
			var asyncCallback:Function = Async.asyncHandler(this, this.onEvaluatedStylesModified, 1000, { element: element }, this.onEvaluatedStylesModifiedTimeout);
			
			element.evaluatedStyles = {"fake-size-value": SizeValue.parse("10px")};
			element.addEventListener(UIElementEvent.EVALUATED_STYLES_MODIFIED, asyncCallback);
			element.evaluatedStyles = {};
		}
		
		[Test(description="Tests that a UIElement can calculate effective dimensions correctly")]
		public function calculatesEffectiveDimensionsCorrectly():void
		{
			var el:UIElement = new UIElement();
			el.evaluatedStyles = { 
				"width": SizeValue.parse("100px"), 
				"padding-left": SizeValue.parse("10px"), 
				"padding-right": SizeValue.parse("10px"), 
				"margin-left": SizeValue.parse("5px"),
				"margin-right": SizeValue.parse("5px")
			};
			
			Assert.assertEquals(100, el.effectiveContentWidth);
			Assert.assertEquals(130, el.effectiveWidth);
		}
		
		[Test(description="Ensures that local styles are evaluated with other styles")]
		public function localStylesAreEvaluated():void
		{
			var el:UIElement = new UIElement();
			el.localStyleString = "padding: 10px; value-not-present-in-defaults: foo";
			Assert.assertTrue(el.hasStyleProperty("padding-top"));
			Assert.assertTrue(el.hasStyleProperty("padding-left"));
			Assert.assertTrue(el.hasStyleProperty("padding-bottom"));
			Assert.assertTrue(el.hasStyleProperty("padding-right"));
			Assert.assertTrue(el.hasStyleProperty("value-not-present-in-defaults"));
		}
		
		[Test(async, description="Ensures that properties with a defined transition and non-zero duration are not altered immediately")]
		public function transitionsWithDurationsAreAnimated():void
		{
			var el:UIElement = new UIElement();
			
			el.localStyleString = "transition-property: padding-left; transition-duration: 2s; transition-delay: 1s; transition-timing-function: linear; padding-left: 10px;";
			
			Assert.assertTrue(el.shouldTransitionProperty("padding-left"));
			Assert.assertFalse(el.shouldTransitionProperty("padding-right"));

			var delayTimer:Timer = new Timer(800, 1);
			var intermediateTimer:Timer = new Timer(1400, 1);
			var completeTimer:Timer = new Timer(2300, 1);
            
			var asyncDelay:Function = Async.asyncHandler(
				this, this.onTransitionDelayTimerComplete, 1000, { "el": el }, this.onTransitionWithDurationTimeout
				);

			var asyncIntermediate:Function = Async.asyncHandler(
				this, this.onTransitionIntermediateTimerComplete, 1800, { "el": el }, this.onTransitionWithDurationTimeout
				);

			var asyncComplete:Function = Async.asyncHandler(
				this, this.onTransitionWithDurationTimerComplete, 2500, { "el": el }, this.onTransitionWithDurationTimeout
				);
			
			el.localStyleString = "transition-property: padding-left; transition-duration: 2s; transition-delay: 1s; transition-timing-function: linear; padding-left: 100px;";
			
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncDelay);
			delayTimer.start();
			intermediateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncIntermediate);
			intermediateTimer.start();
			completeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncComplete);
			completeTimer.start();
			
			Assert.assertEquals(10, (el.getStyleValue("padding-left") as SizeValue).evaluateSize(el));
		}
			protected function onTransitionDelayTimerComplete(e:TimerEvent, passThru:Object):void
			{
				var el:UIElement = (passThru.el as UIElement);
				var pl:Number = (el.getStyleValue("padding-left") as SizeValue).evaluateSize(el);
				Assert.assertEquals(10, pl);
			}
			protected function onTransitionIntermediateTimerComplete(e:TimerEvent, passThru:Object):void
			{
				var el:UIElement = (passThru.el as UIElement);
				var pl:Number = (el.getStyleValue("padding-left") as SizeValue).evaluateSize(el);
				Assert.assertTrue(pl > 10);
				Assert.assertTrue(pl < 100);
			}
			protected function onTransitionWithDurationTimerComplete(e:TimerEvent, passThru:Object):void
			{
				var el:UIElement = (passThru.el as UIElement);
				var pl:Number = (el.getStyleValue("padding-left") as SizeValue).evaluateSize(el);
				Assert.assertEquals(100, pl);
			}
			protected function onTransitionWithDurationTimeout(passThru:Object):void
			{
				Assert.fail("timed out");
			}
		
		[Test(description="Ensures that properties listed by transition-property but with a duration of zero are altered immedidately")]
		public function transitionsWithZeroDurationsAreSkipped():void
		{
			var el:UIElement = new UIElement();
			Assert.assertFalse(el.shouldTransitionProperty("padding-left"));
			
			el.evaluatedStyles = {"padding-left": SizeValue.parse("1235px")};
			
			Assert.assertEquals(1235, (el.getStyleValue("padding-left") as SizeValue).evaluateSize(el))
		}
		
		protected function onEvaluatedStylesModified(e:UIElementEvent, passThru:Object):void
		{
			Assert.assertEquals(e.uiElement, passThru.element);
		}
		
		protected function onEvaluatedStylesModifiedTimeout(passThru:Object):void
		{
			Assert.fail("Timed out waiting for UIElement instance to dispatch EVALUATED_STYLES_MODIFIED");
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
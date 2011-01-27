
package org.stylekit.spec.tests.ui.element
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import mx.core.mx_internal;
	import mx.utils.object_proxy;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.selector.ElementSelector;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.selector.MediaSelector;
	import org.stylekit.css.style.Style;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.CursorValue;
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
		
		[Test(description="Tests that a UIElement can calculate its content area correctly")]
		public function elementCanCalculateContentAreaPoint():void
		{
			var child:UIElement = new UIElement();
			child.localStyleString = "margin: 10px; padding: 10px; border: solid 10px pink;";
			
			var point:Point = child.calculateContentOriginPoint();
			
			Assert.assertEquals(30, point.x);
			Assert.assertEquals(30, point.y);
			
			child.localStyleString = "margin: 10px; padding: 10px; border: solid 10px pink; margin-top: 5px; padding-top: 5px; border-top-width: 5px;";
			
			point = child.calculateContentOriginPoint();
			
			Assert.assertEquals(30, point.x);
			Assert.assertEquals(15, point.y);
			
			child.localStyleString = "margin: 10px; padding: 10px; border: solid 10px pink; margin-left: 5px; padding-left: 5px; border-left-width: 5px;";
			
			point = child.calculateContentOriginPoint();
			
			Assert.assertEquals(15, point.x);
			Assert.assertEquals(30, point.y);			
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
		
		[Test(description="Ensures that descendants may be retrieved by chain selector")]
		public function getElementsBySelectorSet():void
		{
			var base:UIElement = new UIElement();
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
			var child:UIElement = new UIElement();

			root.addElementClassName("r");
			middle.addElementClassName("m");
			child.addElementClassName("c");

			base.addElement(root); root.addElement(middle); middle.addElement(child);

			child.addElementClassName("x");
			middle.addElementClassName("x");
			
			var parser:ElementSelectorParser = new ElementSelectorParser();
			var chain:ElementSelectorChain = parser.parseElementSelectorChain(".r .c");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(child, base.getElementsBySelectorSet(chain.elementSelectors)[0]);
			
			chain = parser.parseElementSelectorChain(".m .c");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(child, base.getElementsBySelectorSet(chain.elementSelectors)[0]);

			chain = parser.parseElementSelectorChain(".r");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(root, base.getElementsBySelectorSet(chain.elementSelectors)[0]);
			
			chain = parser.parseElementSelectorChain(".x");
			
			Assert.assertEquals(2, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertTrue(base.getElementsBySelectorSet(chain.elementSelectors).indexOf(child) > -1);
			Assert.assertTrue(base.getElementsBySelectorSet(chain.elementSelectors).indexOf(middle) > -1);
			
			chain = parser.parseElementSelectorChain(".r > .x");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(middle, base.getElementsBySelectorSet(chain.elementSelectors)[0]);			

			chain = parser.parseElementSelectorChain(".r > .c");
			
			Assert.assertEquals(0, base.getElementsBySelectorSet(chain.elementSelectors).length);
			
			chain = parser.parseElementSelectorChain(".m > .c");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(child, base.getElementsBySelectorSet(chain.elementSelectors)[0]);
			
			chain = parser.parseElementSelectorChain(".r > .m");
			
			Assert.assertEquals(1, base.getElementsBySelectorSet(chain.elementSelectors).length);
			Assert.assertEquals(middle, base.getElementsBySelectorSet(chain.elementSelectors)[0]);
		}
		
		[Test(description="Tests a complete style distribution cycle using a BaseUI and a set of child elements.")]
		public function styleAllocationEvaluatesStylesPostHoc():void
		{
			var ssCol:StyleSheetCollection = new StyleSheetCollection();
			var ssParse:StyleSheetParser = new StyleSheetParser();
			var ss:StyleSheet = ssParse.parse(".foo { width: 10px; } .foo .bar { height: 50px; } .foo > .bar { max-height: 100px; } .foo:hover > .bar { max-width: 200px; }");
			
			// Create some elements
			var baseUI:BaseUI = new BaseUI(ssCol);
			var foo:UIElement = new UIElement(baseUI);
			var barChild:UIElement = new UIElement(baseUI);
			var barDesc:UIElement = new UIElement(baseUI);
			
			baseUI.addElement(foo);
			foo.addElement(barChild);
			barChild.addElement(barDesc);
			
			ssCol.addStyleSheet(ss); // MUTATE!
			foo.addElementClassName("foo");
			barChild.addElementClassName("bar"); barDesc.addElementClassName("bar");
			
			// Now inspect the styles
			Assert.assertEquals(10, (foo.evaluatedStyles["width"] as SizeValue).value);
			Assert.assertEquals(50, (barChild.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertEquals(50, (barDesc.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertNull((barDesc.evaluatedStyles["max-height"] as SizeValue));
			Assert.assertEquals(100, (barChild.evaluatedStyles["max-height"] as SizeValue).value);
			Assert.assertNull((barDesc.evaluatedStyles["max-width"] as SizeValue));
			Assert.assertNull((barChild.evaluatedStyles["max-width"] as SizeValue));
			
			// Modify the state on an element
			foo.addElementPseudoClass("hover");
			Assert.assertEquals(10, (foo.evaluatedStyles["width"] as SizeValue).value);
			Assert.assertEquals(50, (barChild.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertEquals(50, (barDesc.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertNull((barDesc.evaluatedStyles["max-height"] as SizeValue));
			Assert.assertEquals(100, (barChild.evaluatedStyles["max-height"] as SizeValue).value);
			Assert.assertNull((barDesc.evaluatedStyles["max-width"] as SizeValue));
			Assert.assertEquals(200, (barChild.evaluatedStyles["max-width"] as SizeValue).value);
		}
		
		[Test(description="Tests that hover listeners are properly allocated during a style refresh")]
		public function hoverListenersAllocatedOnDomMutate():void
		{
			var ssCol:StyleSheetCollection = new StyleSheetCollection();
			var ssParse:StyleSheetParser = new StyleSheetParser();
			var ss:StyleSheet = ssParse.parse(".foo { width: 10px; } .foo .bar { height: 50px; } .foo > .bar { max-height: 100px; }");
			
			// Create some elements
			var baseUI:BaseUI = new BaseUI(ssCol);
			var foo1:UIElement = new UIElement(baseUI);
			var foo2:UIElement = new UIElement(baseUI);
			var barChild:UIElement = new UIElement(baseUI);
			var barDesc:UIElement = new UIElement(baseUI);
			
			baseUI.addElement(foo1);
			baseUI.addElement(foo2);
			foo1.addElement(barChild);
			barChild.addElement(barDesc);
			
			ssCol.addStyleSheet(ss); // MUTATE!
			foo1.addElementClassName("foo"); foo2.addElementClassName("foo");
			barChild.addElementClassName("bar"); barDesc.addElementClassName("bar");
			
			Assert.assertFalse(baseUI.listensForHover);
			Assert.assertFalse(foo1.listensForHover); 
			Assert.assertFalse(foo2.listensForHover);
			Assert.assertFalse(barChild.listensForHover);
			Assert.assertFalse(barDesc.listensForHover);
			
			ssCol.removeStyleSheet(ss);
			ss = ssParse.parse(".foo:hover { background-color red; } .foo > .bar:hover { height: 50px; }");
			ssCol.addStyleSheet(ss);
			
			Assert.assertFalse(baseUI.listensForHover);
			Assert.assertTrue(foo1.listensForHover); 
			Assert.assertTrue(foo2.listensForHover);
			Assert.assertTrue(barChild.listensForHover);
			Assert.assertFalse(barDesc.listensForHover);
			
			ssCol.removeStyleSheet(ss);
			ss = ssParse.parse(".foo { background-color red; } .bar:hover .foo { height: 50px; }");
			ssCol.addStyleSheet(ss);
			
			Assert.assertFalse(baseUI.listensForHover);
			Assert.assertFalse(foo1.listensForHover); 
			Assert.assertFalse(foo2.listensForHover);
			Assert.assertTrue(barChild.listensForHover);
			Assert.assertTrue(barDesc.listensForHover);
		}
		
		[Test(description="Tests a complete style distribution cycle using a BaseUI and a set of child elements.")]
		public function styleAllocationEvaluatesStylesPreHoc():void
		{
			var ssCol:StyleSheetCollection = new StyleSheetCollection();
			var ssParse:StyleSheetParser = new StyleSheetParser();
			var ss:StyleSheet = ssParse.parse(".foo { width: 10px; } .foo .bar { height: 50px; } .foo > .bar { max-height: 100px; }");
			ssCol.addStyleSheet(ss); // MUTATE!
			
			// Create some elements
			var baseUI:BaseUI = new BaseUI(ssCol);
			var foo:UIElement = new UIElement(baseUI);
			var barChild:UIElement = new UIElement(baseUI);
			var barDesc:UIElement = new UIElement(baseUI);
			
			foo.addElementClassName("foo");
			barChild.addElementClassName("bar"); barDesc.addElementClassName("bar");
			
			baseUI.addElement(foo);
			foo.addElement(barChild);
			barChild.addElement(barDesc);
			
			// Now inspect the styles
			Assert.assertEquals(10, (foo.evaluatedStyles["width"] as SizeValue).value);
			Assert.assertEquals(50, (barChild.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertEquals(50, (barDesc.evaluatedStyles["height"] as SizeValue).value);
			Assert.assertNull((barDesc.evaluatedStyles["max-height"] as SizeValue));
			Assert.assertEquals(100, (barChild.evaluatedStyles["max-height"] as SizeValue).value);
		}
		
		[Test(description="Ensures that relative percentage sizings are recomputed on a change of parent dimensions")]
		public function sizeChangesArePropagated():void
		{
			var ssCol:StyleSheetCollection = new StyleSheetCollection();
			var ssParse:StyleSheetParser = new StyleSheetParser();
			var ss:StyleSheet = ssParse.parse(".foo { width: 100px; } .bar { width: 50%; } .car { width: 50%; }");
			ssCol.addStyleSheet(ss); // MUTATE!
			
			// Create some elements
			var baseUI:BaseUI = new BaseUI(ssCol);
			var foo:UIElement = new UIElement(baseUI);
			var bar:UIElement = new UIElement(baseUI);
			var car:UIElement = new UIElement(baseUI);
			
			baseUI.addElementClassName("base"); foo.addElementClassName("foo"); bar.addElementClassName("bar"); car.addElementClassName("car");
			
			baseUI.addElement(foo); foo.addElement(bar); bar.addElement(car);
			
			Assert.assertEquals(100, foo.effectiveContentWidth);
			Assert.assertEquals(50, bar.effectiveContentWidth);
			Assert.assertEquals(25, car.effectiveContentWidth);
			
			ss = ssParse.parse(".foo { width: 200px; }");
			ssCol.addStyleSheet(ss);
			
			Assert.assertEquals(200, foo.effectiveContentWidth);
			Assert.assertEquals(100, bar.effectiveContentWidth);
			Assert.assertEquals(50, car.effectiveContentWidth);
		}
		
		[Test(description="Ensures that relative percentage sizings are recomputed on a change of parent dimensions: special case for the BaseUI")]
		public function sizeChangesArePropagatedFromBase():void
		{
			var ssCol:StyleSheetCollection = new StyleSheetCollection();
			var ssParse:StyleSheetParser = new StyleSheetParser();
			var ss:StyleSheet = ssParse.parse(".base { width: 100px; } .foo { width: 50%; } .bar { width: 50%; }");
			ssCol.addStyleSheet(ss); // MUTATE!
			
			// Create some elements
			var baseUI:BaseUI = new BaseUI(ssCol);
			var foo:UIElement = new UIElement(baseUI);
			var bar:UIElement = new UIElement(baseUI);
			
			baseUI.addElementClassName("base"); foo.addElementClassName("foo"); bar.addElementClassName("bar");
			
			baseUI.addElement(foo); foo.addElement(bar);
			
			Assert.assertEquals(100, baseUI.effectiveContentWidth);
			Assert.assertEquals(50, foo.effectiveContentWidth);
			Assert.assertEquals(25, bar.effectiveContentWidth);
			
			ss = ssParse.parse(".base { width: 200px; }");
			ssCol.addStyleSheet(ss);
			
			Assert.assertEquals(200, baseUI.effectiveContentWidth);
			Assert.assertEquals(100, foo.effectiveContentWidth);
			Assert.assertEquals(50, bar.effectiveContentWidth);
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
		
		[Test(description="Generates a key for the local styling state vector")]
		public function stateVectorsGenerated():void
		{
			var el:UIElement = new UIElement();
			el.elementName = "foo";
			el.elementId = "bar";
			el.addElementClassName("class1");
			el.addElementClassName("class2");
			el.addElementPseudoClass("pseudo1");
			el.addElementPseudoClass("pseudo2");
			
			Assert.assertEquals("bar/foo/class1,class2/pseudo1,pseudo2/0", el.generateStateVectorKey());
		}
		
		[Test(description="Ensures that special mouse cursors are inherited by all element children")]
		public function mouseCursorsInherited():void
		{
			var parent:UIElement = new UIElement();
			var child:UIElement = new UIElement();
			var grandchild:UIElement = new UIElement();
			
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, parent.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, parent.getMouseCursorTypeId());
			
			parent.localStyleString = "cursor: pointer;";
			
			Assert.assertEquals(CursorValue.CURSOR_POINTER, parent.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_POINTER, parent.getMouseCursorTypeId());
			
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, child.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, child.getMouseCursorTypeId());
			
			parent.addElement(child);
			
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, child.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_POINTER, child.getMouseCursorTypeId());
			
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, grandchild.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, grandchild.getMouseCursorTypeId());
			
			child.addElement(grandchild);
			
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, grandchild.getLocalMouseCursorTypeId());
			Assert.assertEquals(CursorValue.CURSOR_POINTER, grandchild.getMouseCursorTypeId());
		}
		
		[Test(description="Registers descendants being moved between trees")]
		public function descendantCacheUpdatedOnElementParentChange():void
		{
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
				middle.addElementClassName("m");
			var child:UIElement = new UIElement();
				child.addElementClassName("c");
			var other:UIElement = new UIElement();
			
			
			// Add middle+child to root and assert indexes
			root.addElement(middle);
			root.addElement(child);
			
			Assert.assertEquals(2, root.descendants.length);
			Assert.assertEquals(0, root.descendants.indexOf(middle));
			Assert.assertEquals(1, root.descendants.indexOf(child));
			
			Assert.assertEquals(0, middle.descendants.length);
			Assert.assertEquals(0, child.descendants.length);
			
			Assert.assertEquals(1, (root.descendantsByClass["m"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (root.descendantsByClass["m"] as Vector.<UIElement>).indexOf(middle));
			Assert.assertEquals(1, (root.descendantsByClass["c"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (root.descendantsByClass["c"] as Vector.<UIElement>).indexOf(child));

			// Move child to leaf and assert indexes
			middle.addElement(child);
			
			Assert.assertEquals(2, root.descendants.length);
			Assert.assertEquals(0, root.descendants.indexOf(middle));
			Assert.assertEquals(1, root.descendants.indexOf(child));
			
			Assert.assertEquals(1, middle.descendants.length);
			Assert.assertEquals(0, middle.descendants.indexOf(child));
			Assert.assertEquals(0, child.descendants.length);
			
			Assert.assertEquals(1, (root.descendantsByClass["m"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (root.descendantsByClass["m"] as Vector.<UIElement>).indexOf(middle));
			Assert.assertEquals(1, (root.descendantsByClass["c"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (root.descendantsByClass["c"] as Vector.<UIElement>).indexOf(child));

			Assert.assertNull(middle.descendantsByClass["m"]);
			Assert.assertEquals(1, (middle.descendantsByClass["c"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (middle.descendantsByClass["c"] as Vector.<UIElement>).indexOf(child));
			
		}
		
		[Test(description="Registers descendants switching classnames")]
		public function descendantCacheUpdateOnClassNameAddedOrRemoved():void
		{
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
			var child:UIElement = new UIElement();
			root.addElement(middle); middle.addElement(child);
			
			child.addElementClassName("foo");
			
			Assert.assertEquals(1, (root.descendantsByClass["foo"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsByClass["foo"] as Vector.<UIElement>).length);
			
			child.removeElementClassName("foo");
			
			Assert.assertEquals(0, (root.descendantsByClass["foo"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (middle.descendantsByClass["foo"] as Vector.<UIElement>).length);
		}
		
		[Test(description="Registers descendants switching pseudoclasses")]
		public function descendantCacheUpdateOnPseudoClassAddedOrRemoved():void
		{
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
			var child:UIElement = new UIElement();
			root.addElement(middle); middle.addElement(child);
			
			child.addElementPseudoClass("pseudo");
			
			Assert.assertEquals(1, (root.descendantsByPseudoClass["pseudo"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsByPseudoClass["pseudo"] as Vector.<UIElement>).length);
			
			child.removeElementPseudoClass("pseudo");
			
			Assert.assertEquals(0, (root.descendantsByPseudoClass["pseudo"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (middle.descendantsByPseudoClass["pseudo"] as Vector.<UIElement>).length);
		}
		
		[Test(description="Registers descendants modifying their element names")]
		public function descendantCacheUpdateOnElementNameModified():void
		{
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
			var child:UIElement = new UIElement();
			root.addElement(middle); middle.addElement(child);
			
			child.elementName = "div";
			
			Assert.assertEquals(1, (root.descendantsByName["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsByName["div"] as Vector.<UIElement>).length);
			
			child.elementName = "ul";
			
			Assert.assertEquals(0, (root.descendantsByName["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (middle.descendantsByName["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (root.descendantsByName["ul"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsByName["ul"] as Vector.<UIElement>).length);
			
			middle.elementName = "span";
			
			Assert.assertNull(child.descendantsByName["span"]);
			Assert.assertNull(middle.descendantsByName["span"]);
			Assert.assertEquals(1, (root.descendantsByName["span"] as Vector.<UIElement>).length);
		}
		
		[Test(description="Registers descendants modifying their element ID's")]
		public function descendantCacheUpdateOnElementIdModified():void
		{
			var root:UIElement = new UIElement();
			var middle:UIElement = new UIElement();
			var child:UIElement = new UIElement();
			root.addElement(middle); middle.addElement(child);
			
			child.elementId = "div";
			
			Assert.assertEquals(1, (root.descendantsById["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsById["div"] as Vector.<UIElement>).length);
			
			child.elementId = "ul";
			
			Assert.assertEquals(0, (root.descendantsById["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(0, (middle.descendantsById["div"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (root.descendantsById["ul"] as Vector.<UIElement>).length);
			Assert.assertEquals(1, (middle.descendantsById["ul"] as Vector.<UIElement>).length);
			
			middle.elementId = "span";
			
			Assert.assertNull(child.descendantsById["span"]);
			Assert.assertNull(middle.descendantsById["span"]);
			Assert.assertEquals(1, (root.descendantsById["span"] as Vector.<UIElement>).length);
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
		
		[Test(description="Correctly calculates the absolute origin point ommitting the padding")]
		public function calculatesInsideBorderOriginPoint():void
		{
			var el:UIElement = new UIElement();
			el.localStyleString = "margin-top: 50px; margin-left: 40px; padding: 70px; border: 10px solid red; border-left-width: 90px;";
			
			Assert.assertEquals(130, el.calculateInsideBorderOriginPoint().x);
			Assert.assertEquals(60, el.calculateInsideBorderOriginPoint().y);
		}
		
		[Test(description="Correctly calcualtes the absolute origin extent, ommitting the padding")]
		public function calculatesInsideBorderExtentPoint():void
		{
			var el:UIElement = new UIElement();
			el.localStyleString = "margin: 5px; margin-top: 50px; margin-left: 40px; padding: 70px; border: 10px solid red; border-left-width: 90px; width: 1000px; height: 2000px";
			
			Assert.assertEquals(1270, el.calculateInsideBorderExtentPoint().x);
			Assert.assertEquals(2200, el.calculateInsideBorderExtentPoint().y);
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
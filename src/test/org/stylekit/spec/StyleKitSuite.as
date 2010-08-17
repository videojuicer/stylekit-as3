package org.stylekit.spec
{
	
	import org.stylekit.spec.tests.css.StyleSheetCollectionTestCase;
	import org.stylekit.spec.tests.css.StyleSheetTestCase;
	import org.stylekit.spec.tests.ui.element.UIElementTestCase;

	import org.stylekit.spec.tests.css.parse.StyleSheetParserTestCase;
	import org.stylekit.spec.tests.css.parse.ElementSelectorParserTestCase;
	import org.stylekit.spec.tests.css.parse.ValueParserTestCase;
	
	import org.stylekit.spec.tests.css.style.AnimationTestCase;
	
	import org.stylekit.spec.tests.css.selector.ElementSelectorTestCase;
	import org.stylekit.spec.tests.css.selector.MediaSelectorTestCase;
	
	import org.stylekit.spec.tests.css.value.SizeValueTestCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StyleKitSuite
	{
		public var styleSheetCollectionTest:StyleSheetCollectionTestCase;
		public var styleSheetTest:StyleSheetTestCase;
		
		public var styleSheetParserTest:StyleSheetParserTestCase;
		public var elementSelectorParserTest:ElementSelectorParserTestCase;
		public var valueParserTest:ValueParserTestCase;
		
		public var elementSelectorTest:ElementSelectorTestCase;
		public var uiElementTest:UIElementTestCase;
		public var mediaSelectorTest:MediaSelectorTestCase;
		public var animationTest:AnimationTestCase;
		
		public var sizeValueTest:SizeValueTestCase;
	}
}
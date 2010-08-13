package org.stylekit.spec
{
	
	import org.stylekit.spec.tests.css.StyleSheetCollectionTestCase;
	import org.stylekit.spec.tests.css.StyleSheetTestCase;
	import org.stylekit.spec.tests.css.parse.ElementSelectorParserTestCase;
	import org.stylekit.spec.tests.css.parse.StyleSheetParserTestCase;
	import org.stylekit.spec.tests.css.style.selector.ElementSelectorTestCase;
	import org.stylekit.spec.tests.ui.element.UIElementTestCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StyleKitSuite
	{
		public var styleSheetCollectionTest:StyleSheetCollectionTestCase;
		public var styleSheetTest:StyleSheetTestCase;
		public var styleSheetParserTest:StyleSheetParserTestCase;
		public var elementSelectorParserTest:ElementSelectorParserTestCase;
		public var elementSelectorTest:ElementSelectorTestCase;
		public var uiElementTest:UIElementTestCase;
	}
}
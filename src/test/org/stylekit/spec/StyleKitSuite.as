package org.stylekit.spec
{
	
	import org.stylekit.spec.tests.css.StyleSheetCollectionTestCase;
	import org.stylekit.spec.tests.css.StyleSheetTestCase;
	import org.stylekit.spec.tests.css.parse.StyleSheetParserTestCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StyleKitSuite
	{
		public var styleSheetCollectionTest:StyleSheetCollectionTestCase;
		public var styleSheetTest:StyleSheetTestCase;
		public var styleSheetParserTest:StyleSheetParserTestCase;
	}
}
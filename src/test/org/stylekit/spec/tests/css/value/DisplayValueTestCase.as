package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.DisplayValue;

	public class DisplayValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid DisplayValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:DisplayValue;
			
			result = DisplayValue.parse("inline");
			Assert.assertEquals(DisplayValue.DISPLAY_INLINE, result.display);
			
			result = DisplayValue.parse("none");
			Assert.assertEquals(DisplayValue.DISPLAY_NONE, result.display);
			
			result = DisplayValue.parse("block");
			Assert.assertEquals(DisplayValue.DISPLAY_BLOCK, result.display);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a DisplayValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "inline", "none", "block", "inline-block", "list-item", "marker", "compact", "run-in", "table-header-group", "table-footer-group",
				"table", "inline-table", "table-caption", "table-cell", "table-row", "table-row-group", "table-column", "table-column-group" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(DisplayValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(DisplayValue.identify("FAAAAIL"));
		}
	}
}
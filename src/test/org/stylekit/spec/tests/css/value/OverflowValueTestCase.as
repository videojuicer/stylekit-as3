package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.OverflowValue;
	
	public class OverflowValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid OverflowValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:OverflowValue;
			
			result = OverflowValue.parse("visible");
			Assert.assertEquals(OverflowValue.OVERFLOW_VISIBLE, result.overflow);
			
			result = OverflowValue.parse("hidden");
			Assert.assertEquals(OverflowValue.OVERFLOW_HIDDEN, result.overflow);
			
			result = OverflowValue.parse("scroll");
			Assert.assertEquals(OverflowValue.OVERFLOW_SCROLL, result.overflow);
			
			result = OverflowValue.parse("auto");
			Assert.assertEquals(OverflowValue.OVERFLOW_AUTO, result.overflow);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a OverflowValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "visible", "hidden", "scroll", "auto" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(OverflowValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(OverflowValue.identify("FAAAAIL"));
		}
	}
}
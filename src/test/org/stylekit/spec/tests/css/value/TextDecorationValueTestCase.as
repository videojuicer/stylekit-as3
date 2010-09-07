package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.TextDecorationValue;

	public class TextDecorationValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid TextDecorationValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TextDecorationValue;
			
			result = TextDecorationValue.parse("none");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_NONE, result.textDecoration);
			
			result = TextDecorationValue.parse("underline");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_UNDERLINE, result.textDecoration);
			
			result = TextDecorationValue.parse("overline");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_OVERLINE, result.textDecoration);
			
			result = TextDecorationValue.parse("line-through");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_LINE_THROUGH, result.textDecoration);
			
			result = TextDecorationValue.parse("blink");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_BLINK, result.textDecoration);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TextDecorationValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "none", "underline", "overline", "line-through", "blink" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(TextDecorationValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(TextDecorationValue.identify("FAAAAIL"));
		}
	}
}
package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.TextAlignValue;

	public class TextAlignValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid TextAlignValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TextAlignValue;
			
			result = TextAlignValue.parse("left");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_LEFT, result.textAlign);
			
			result = TextAlignValue.parse("right");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_RIGHT, result.textAlign);
			
			result = TextAlignValue.parse("center");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_CENTER, result.textAlign);
			
			result = TextAlignValue.parse("justify");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_JUSTIFY, result.textAlign);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TextAlignValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "left", "right", "center", "justify" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(TextAlignValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(TextAlignValue.identify("FAAAAIL"));
		}
	}
}
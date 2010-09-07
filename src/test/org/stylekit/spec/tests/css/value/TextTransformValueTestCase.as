package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.TextTransformValue;

	public class TextTransformValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid TextTransformValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TextTransformValue;
			
			result = TextTransformValue.parse("capitalize");
			Assert.assertEquals(TextTransformValue.TEXT_TRANSFORM_CAPITALIZE, result.textTransform);
			
			result = TextTransformValue.parse("uppercase");
			Assert.assertEquals(TextTransformValue.TEXT_TRANSFORM_UPPERCASE, result.textTransform);
			
			result = TextTransformValue.parse("lowercase");
			Assert.assertEquals(TextTransformValue.TEXT_TRANSFORM_LOWERCASE, result.textTransform);
			
			result = TextTransformValue.parse("none");
			Assert.assertEquals(TextTransformValue.TEXT_TRANSFORM_NONE, result.textTransform);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TextTransformValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "capitalize", "uppercase", "lowercase", "none" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(TextTransformValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(TextTransformValue.identify("FAAAAIL"));
		}
	}
}
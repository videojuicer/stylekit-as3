package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.PositionValue;

	public class PositionValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid PositionValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:PositionValue;
			
			result = PositionValue.parse("static");
			Assert.assertEquals(PositionValue.POSITION_STATIC, result.position);
			
			result = PositionValue.parse("relative");
			Assert.assertEquals(PositionValue.POSITION_RELATIVE, result.position);
			
			result = PositionValue.parse("absolute");
			Assert.assertEquals(PositionValue.POSITION_ABSOLUTE, result.position);
			
			result = PositionValue.parse("fixed");
			Assert.assertEquals(PositionValue.POSITION_FIXED, result.position);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a PositionValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "static", "relative", "absolute", "fixed" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(PositionValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(PositionValue.identify("FAAAAIL"));
		}
	}
}
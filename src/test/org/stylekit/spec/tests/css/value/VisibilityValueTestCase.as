package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.VisibilityValue;

	public class VisibilityValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid VisibilityValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:VisibilityValue;
			
			result = VisibilityValue.parse("visible");
			Assert.assertEquals(VisibilityValue.VISIBILITY_VISIBLE, result.visibility);
			
			result = VisibilityValue.parse("hidden");
			Assert.assertEquals(VisibilityValue.VISIBILITY_HIDDEN, result.visibility);
			
			result = VisibilityValue.parse("collapse");
			Assert.assertEquals(VisibilityValue.VISIBILITY_COLLAPSE, result.visibility);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a VisibilityValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "visible", "hidden", "collapse" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(VisibilityValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(VisibilityValue.identify("FAAAAIL"));
		}
	}
}
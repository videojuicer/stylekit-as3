package org.stylekit.spec.tests.css.value
{
	import flexunit.framework.Assert;
	
	import org.stylekit.css.value.CursorValue;

	public class CursorValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid CursorValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:CursorValue;
			
			result = CursorValue.parse("auto");
			Assert.assertEquals(CursorValue.CURSOR_AUTO, result.cursor);
			
			result = CursorValue.parse("crosshair");
			Assert.assertEquals(CursorValue.CURSOR_CROSSHAIR, result.cursor);
			
			result = CursorValue.parse("default");
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, result.cursor);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a CursorValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "auto", "crosshair", "default", "pointer", "move", "e-resize", "ne-resize", "nw-resize", "n-resize", "se-resize", "sw-resize", "s-resize", "w-resize", "text", "wait", "help", "progress" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(CursorValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(CursorValue.identify("FAAAAIL"));
		}
	}
}
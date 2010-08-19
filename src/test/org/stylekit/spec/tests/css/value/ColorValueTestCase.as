package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.ColorValue;

	public class ColorValueTestCase {
		
		protected var _result:ColorValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid ColorValue object.")]
		public function stringParsesCorrectly():void
		{
			var testColors:Array = ["FF0000", "0xFF0000", "#FF0000", "red"];
			var cVal:ColorValue;
			for(var i:uint=0; i<testColors.length; i++)
			{
				cVal =ColorValue.parse(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0xFF0000, cVal.hexValue);
			}
			
			testColors = ["008000", "0x008000", "#008000", "green"];
			for(i=0; i<testColors.length; i++)
			{
				cVal =ColorValue.parse(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0x008000, cVal.hexValue);
			}
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a ColorValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var testValid:Array = ["0xFF0000", "#FF0000", "red"];
			for(var i:uint = 0; i < testValid.length; i++)
			{
				Assert.assertTrue("Should be a valid color: "+testValid[i], ColorValue.identify(testValid[i]));
			}
			
			var testInvalid:Array = ["lulz"];
			for(i = 0; i < testInvalid.length; i++)
			{
				Assert.assertFalse(ColorValue.identify(testInvalid[i]));
			}
		}
		
	}
}
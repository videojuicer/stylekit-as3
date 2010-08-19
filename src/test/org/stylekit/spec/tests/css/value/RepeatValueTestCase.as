package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.RepeatValue;

	public class RepeatValueTestCase {
		
		protected var _result:RepeatValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid RepeatValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:RepeatValue;
			
			result = RepeatValue.parse("repeat");
			Assert.assertTrue(result.horizontalRepeat);
			Assert.assertTrue(result.verticalRepeat);
			
			result = RepeatValue.parse("repeat-x");
			Assert.assertTrue(result.horizontalRepeat);
			Assert.assertFalse(result.verticalRepeat);
			
			result = RepeatValue.parse("repeat-y");
			Assert.assertFalse(result.horizontalRepeat);
			Assert.assertTrue(result.verticalRepeat);
			
			result = RepeatValue.parse("no-repeat");
			Assert.assertFalse(result.horizontalRepeat);
			Assert.assertFalse(result.verticalRepeat);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a RepeatValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = ["repeat", "repeat-x", "repeat-y", "no-repeat"];
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(RepeatValue.identify(tokens[i]));
			}
			Assert.assertTrue(RepeatValue.identify("FAAAAIL"));
		}
		
	}
}
package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.ui.element.UIElement;

	public class PropertyListValueTestCase {
		
		protected var _result:PropertyListValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid PropertyListValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:PropertyListValue;
			
			result = PropertyListValue.parse("border-left-width,border-right-width");
			Assert.assertEquals(2, result.properties.length);
			Assert.assertTrue(result.hasProperty("border-right-width"));
			
			result = PropertyListValue.parse("all");
			Assert.assertTrue(result.hasProperty("border-right-width"));
			
			result = PropertyListValue.parse("border-right-width, none");
			Assert.assertFalse(result.hasProperty("border-right-width"));
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a PropertyListValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(PropertyListValue.identify("all"));
			Assert.assertTrue(PropertyListValue.identify("none"));
			Assert.assertTrue(PropertyListValue.identify("border-left-width,padding-right"));
		}
		
	}
}
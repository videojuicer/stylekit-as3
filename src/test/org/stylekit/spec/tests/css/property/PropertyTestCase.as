package org.stylekit.spec.tests.css.property
{
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.Value;
	
	public class PropertyTestCase
	{
		[Test(description="Tests that a property can be evaluated into a flat hash successfully")]
		public function ableToEvaluate():void
		{
			// test some colours
			this.evaluatePropertyAndValue("background-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-left-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-right-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-top-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-bottom-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-left-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("outline-color", ColorValue.parse("#FFFFFF"));
			
			// some sizes
			this.evaluatePropertyAndValue("margin-top", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-bottom", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-left", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-right", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-top", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-bottom", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-left", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-right", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("outline-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("font-size", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-bottom-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-top-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-left-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-right-width", SizeValue.parse("10px"));
		}
		
		protected function evaluatePropertyAndValue(propertyName:String, value:Value):void
		{
			var property:Property = new Property(propertyName, value);
			var mergeParent:Object = property.evaluateProperty(new Object(), null);
			
			Assert.assertNotNull(mergeParent);
			Assert.assertTrue(mergeParent.hasOwnProperty(propertyName));
			Assert.assertNotNull(mergeParent[propertyName]);
			Assert.assertEquals(mergeParent[propertyName], value);
		}
		
		public function ableToEvaluateInherit():void
		{
			
		}
	}
}
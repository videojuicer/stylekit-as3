package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.TimeValue;

	public class ValueArrayTestCase {
		
		protected var _result:ValueArray;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid ValueArray object.")]
		public function stringParsesCorrectly():void
		{
			var result:ValueArray;
			
			result = ValueArray.parse("2s,5s, 10s ", TimeValue);
			Assert.assertEquals(3, result.values.length);
		}
		
		
	}
}
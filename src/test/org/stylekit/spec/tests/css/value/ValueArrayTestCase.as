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
			Assert.assertTrue(result.valueAt(0) is TimeValue);
			Assert.assertEquals(5000, (result.valueAt(1) as TimeValue).millisecondValue);
			Assert.assertEquals(10000, (result.valueAt(2) as TimeValue).millisecondValue);
			Assert.assertEquals(10000, (result.valueAt(100) as TimeValue).millisecondValue);
			
			var trueMatchResult:ValueArray = ValueArray.parse("2s,5s, 10s ", TimeValue);
				Assert.assertTrue(trueMatchResult.isEquivalent(result));
			var falseMatch1Result:ValueArray = ValueArray.parse("2s,5s, 10s, 5s ", TimeValue);
			var falseMatch2Result:ValueArray = ValueArray.parse("2s,5s, 100s ", TimeValue);
			var falseMatch3Result:ValueArray = ValueArray.parse("2s,5s ", TimeValue);
				Assert.assertFalse(falseMatch1Result.isEquivalent(result));
				Assert.assertFalse(falseMatch2Result.isEquivalent(result));
				Assert.assertFalse(falseMatch3Result.isEquivalent(result));
		}
		
		
	}
}
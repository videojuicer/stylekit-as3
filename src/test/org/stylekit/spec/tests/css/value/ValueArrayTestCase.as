/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is the StyleKit library.
 *
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 *
 * ***** END LICENSE BLOCK ***** */
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
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

	import org.stylekit.css.value.TimeValue;
	import org.stylekit.ui.element.UIElement;

	public class TimeValueTestCase {
		
		protected var _result:TimeValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid TimeValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TimeValue;
			
			result = TimeValue.parse("10ms");
			Assert.assertEquals(TimeValue.UNIT_MILLISECONDS, result.units);
			Assert.assertEquals(10, result.millisecondValue);
			
			result = TimeValue.parse("10s");
			Assert.assertEquals(TimeValue.UNIT_SECONDS, result.units);
			Assert.assertEquals(10*1000, result.millisecondValue);
			
			result = TimeValue.parse("5m");
			Assert.assertEquals(TimeValue.UNIT_MINUTES, result.units);
			Assert.assertEquals(5*60*1000, result.millisecondValue);
			
			result = TimeValue.parse("0.1h");
			Assert.assertEquals(TimeValue.UNIT_HOURS, result.units);
			Assert.assertEquals(0.1*60*60*1000, result.millisecondValue);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TimeValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertFalse(TimeValue.identify("0.1"));
			Assert.assertFalse(TimeValue.identify("10px"));
			
			Assert.assertTrue(TimeValue.identify("0.1s"));
			Assert.assertTrue(TimeValue.identify("0.1ms"));
			Assert.assertTrue(TimeValue.identify("10h"));
		}
		
	}
}
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

	import org.stylekit.css.value.AlignmentValue;

	public class AlignmentValueTestCase {
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid value object.")]
		public function stringParsesCorrectly():void
		{
			var result:AlignmentValue;
			
			result = AlignmentValue.parse("top");
			Assert.assertTrue(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);
			
			result = AlignmentValue.parse("left");
			Assert.assertFalse(result.topAlign);
			Assert.assertTrue(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);

			result = AlignmentValue.parse("right");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertTrue(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);

			result = AlignmentValue.parse("bottom");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertTrue(result.bottomAlign);

			result = AlignmentValue.parse("top left");
			Assert.assertTrue(result.topAlign);
			Assert.assertTrue(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);
		
			result = AlignmentValue.parse("right bottom");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertTrue(result.rightAlign);
			Assert.assertTrue(result.bottomAlign);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(AlignmentValue.identify("top"));
			Assert.assertTrue(AlignmentValue.identify("left"));
			Assert.assertTrue(AlignmentValue.identify("Right"));
			Assert.assertTrue(AlignmentValue.identify("BOTTOM"));
			Assert.assertTrue(AlignmentValue.identify("top left"));
			Assert.assertTrue(AlignmentValue.identify("right bottom"));
			
			Assert.assertFalse(AlignmentValue.identify("monkey pants"));
		}
		
	}
}
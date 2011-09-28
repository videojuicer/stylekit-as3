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

	import org.stylekit.css.value.FontWeightValue;

	public class FontWeightValueTestCase {
		
		protected var _result:FontWeightValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontWeightValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontWeightValue;
			
			result = FontWeightValue.parse("bold");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_BOLD);
			
			result = FontWeightValue.parse("700");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_BOLD);
			
			result = FontWeightValue.parse("nonsense");
			Assert.assertEquals(result.fontWeight, FontWeightValue.FONT_WEIGHT_NORMAL);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a FontWeightValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(FontWeightValue.identify("normal"));
			Assert.assertTrue(FontWeightValue.identify("800   "));
			Assert.assertFalse(FontWeightValue.identify("nonsense"));
			Assert.assertFalse(FontWeightValue.identify("650"));
		}
		
	}
}
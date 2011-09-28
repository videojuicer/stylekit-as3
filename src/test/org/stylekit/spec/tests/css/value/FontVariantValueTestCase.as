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

	import org.stylekit.css.value.FontVariantValue;

	public class FontVariantValueTestCase {
		
		protected var _result:FontVariantValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontVariantValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontVariantValue;
			
			result = FontVariantValue.parse("small-caps");
			Assert.assertEquals(result.fontVariant, FontVariantValue.FONT_VARIANT_SMALL_CAPS);
			
			result = FontVariantValue.parse("nonsense");
			Assert.assertEquals(result.fontVariant, FontVariantValue.FONT_VARIANT_NORMAL);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a FontVariantValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(FontVariantValue.identify("SMALL-CAPS"));
			Assert.assertTrue(FontVariantValue.identify("normal   "));
			Assert.assertFalse(FontVariantValue.identify("nonsense"));
		}
		
	}
}
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

	import org.stylekit.css.value.FontCompoundValue;
	import org.stylekit.css.value.FontVariantValue;
	import org.stylekit.css.value.FontWeightValue;

	public class FontCompoundValueTestCase {
		
		protected var _result:FontCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid FontCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:FontCompoundValue;
			
			result = FontCompoundValue.parse("3.4em");
			Assert.assertEquals(3.4, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			
			result = FontCompoundValue.parse("5px red arial small-caps 700");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("px", result.sizeValue.units);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("arial", result.fontFaceValue.stringValue);
			Assert.assertEquals(FontVariantValue.FONT_VARIANT_SMALL_CAPS, result.fontVariantValue.fontVariant);
			Assert.assertEquals(FontWeightValue.FONT_WEIGHT_BOLD, result.fontWeightValue.fontWeight);
		}
		
	}
}
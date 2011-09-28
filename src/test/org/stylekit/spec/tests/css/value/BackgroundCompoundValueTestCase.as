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

	import org.stylekit.css.value.BackgroundCompoundValue;

	public class BackgroundCompoundValueTestCase {
		
		protected var _result:BackgroundCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			var result:BackgroundCompoundValue;
			
			result = BackgroundCompoundValue.parse("red");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals(null, result.urlValue);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);

			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\")");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\") repeat-x");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = BackgroundCompoundValue.parse("#FF0000 url(\"foo.css\") repeat bottom right");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertTrue(result.repeatValue.verticalRepeat);
			Assert.assertTrue(result.alignmentValue.bottomAlign);
			Assert.assertTrue(result.alignmentValue.rightAlign);
			
			result = BackgroundCompoundValue.parse("url(\"foo.css\") no-repeat");
			Assert.assertEquals(null, result.colorValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertFalse(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid BackgroundCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			
		}
		
	}
}
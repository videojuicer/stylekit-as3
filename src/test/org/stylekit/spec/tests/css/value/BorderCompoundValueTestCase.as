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

	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.ColorValue;

	import org.stylekit.css.value.BorderCompoundValue;

	public class BorderCompoundValueTestCase {
		
		protected var _result:BorderCompoundValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid BorderCompoundValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:BorderCompoundValue;
			
			result = BorderCompoundValue.parse("5em dashed red");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			Assert.assertEquals(LineStyleValue.LINE_STYLE_DASHED, result.lineStyleValue.lineStyle);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			
			result = BorderCompoundValue.parse("red");
			Assert.assertEquals(null, result.sizeValue);
			Assert.assertEquals(null, result.lineStyleValue);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			
			result = BorderCompoundValue.parse("5em red");
			Assert.assertEquals(5, result.sizeValue.value);
			Assert.assertEquals("em", result.sizeValue.units);
			Assert.assertEquals(null, result.lineStyleValue);
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
		}
		
	}
}//
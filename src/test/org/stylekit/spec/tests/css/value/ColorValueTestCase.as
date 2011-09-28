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

	import org.stylekit.css.value.ColorValue;

	public class ColorValueTestCase {
		
		protected var _result:ColorValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid ColorValue object.")]
		public function stringParsesCorrectly():void
		{
			var testColors:Array = ["FF0000", "0xFF0000", "#FF0000", "red"];
			var cVal:ColorValue;
			for(var i:uint=0; i<testColors.length; i++)
			{
				cVal =ColorValue.parse(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0xFF0000, cVal.hexValue);
			}
			
			testColors = ["008000", "0x008000", "#008000", "green"];
			for(i=0; i<testColors.length; i++)
			{
				cVal =ColorValue.parse(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0x008000, cVal.hexValue);
			}
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a ColorValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var testValid:Array = ["0xFF0000", "#FF0000", "red"];
			for(var i:uint = 0; i < testValid.length; i++)
			{
				Assert.assertTrue("Should be a valid color: "+testValid[i], ColorValue.identify(testValid[i]));
			}
			
			var testInvalid:Array = ["lulz"];
			for(i = 0; i < testInvalid.length; i++)
			{
				Assert.assertFalse(ColorValue.identify(testInvalid[i]));
			}
		}
		
	}
}
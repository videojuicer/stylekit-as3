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
	
	import org.stylekit.css.value.OverflowValue;
	
	public class OverflowValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid OverflowValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:OverflowValue;
			
			result = OverflowValue.parse("visible");
			Assert.assertEquals(OverflowValue.OVERFLOW_VISIBLE, result.overflow);
			
			result = OverflowValue.parse("hidden");
			Assert.assertEquals(OverflowValue.OVERFLOW_HIDDEN, result.overflow);
			
			result = OverflowValue.parse("scroll");
			Assert.assertEquals(OverflowValue.OVERFLOW_SCROLL, result.overflow);
			
			result = OverflowValue.parse("auto");
			Assert.assertEquals(OverflowValue.OVERFLOW_AUTO, result.overflow);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a OverflowValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "visible", "hidden", "scroll", "auto" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(OverflowValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(OverflowValue.identify("FAAAAIL"));
		}
	}
}
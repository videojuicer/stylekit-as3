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
	
	import org.stylekit.css.value.PositionValue;

	public class PositionValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid PositionValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:PositionValue;
			
			result = PositionValue.parse("static");
			Assert.assertEquals(PositionValue.POSITION_STATIC, result.position);
			
			result = PositionValue.parse("relative");
			Assert.assertEquals(PositionValue.POSITION_RELATIVE, result.position);
			
			result = PositionValue.parse("absolute");
			Assert.assertEquals(PositionValue.POSITION_ABSOLUTE, result.position);
			
			result = PositionValue.parse("fixed");
			Assert.assertEquals(PositionValue.POSITION_FIXED, result.position);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a PositionValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "static", "relative", "absolute", "fixed" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(PositionValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(PositionValue.identify("FAAAAIL"));
		}
	}
}
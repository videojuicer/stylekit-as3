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
	
	import org.stylekit.css.value.DisplayValue;

	public class DisplayValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid DisplayValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:DisplayValue;
			
			result = DisplayValue.parse("inline");
			Assert.assertEquals(DisplayValue.DISPLAY_INLINE, result.display);
			
			result = DisplayValue.parse("none");
			Assert.assertEquals(DisplayValue.DISPLAY_NONE, result.display);
			
			result = DisplayValue.parse("block");
			Assert.assertEquals(DisplayValue.DISPLAY_BLOCK, result.display);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a DisplayValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "inline", "none", "block", "inline-block", "list-item", "marker", "compact", "run-in", "table-header-group", "table-footer-group",
				"table", "inline-table", "table-caption", "table-cell", "table-row", "table-row-group", "table-column", "table-column-group" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(DisplayValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(DisplayValue.identify("FAAAAIL"));
		}
	}
}
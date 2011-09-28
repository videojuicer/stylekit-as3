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
	
	import org.stylekit.css.value.TextAlignValue;

	public class TextAlignValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid TextAlignValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TextAlignValue;
			
			result = TextAlignValue.parse("left");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_LEFT, result.textAlign);
			
			result = TextAlignValue.parse("right");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_RIGHT, result.textAlign);
			
			result = TextAlignValue.parse("center");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_CENTER, result.textAlign);
			
			result = TextAlignValue.parse("justify");
			Assert.assertEquals(TextAlignValue.TEXT_ALIGN_JUSTIFY, result.textAlign);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TextAlignValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "left", "right", "center", "justify" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(TextAlignValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(TextAlignValue.identify("FAAAAIL"));
		}
	}
}
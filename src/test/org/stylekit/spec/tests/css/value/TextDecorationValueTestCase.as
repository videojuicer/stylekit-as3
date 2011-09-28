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
	
	import org.stylekit.css.value.TextDecorationValue;

	public class TextDecorationValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid TextDecorationValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:TextDecorationValue;
			
			result = TextDecorationValue.parse("none");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_NONE, result.textDecoration);
			
			result = TextDecorationValue.parse("underline");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_UNDERLINE, result.textDecoration);
			
			result = TextDecorationValue.parse("overline");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_OVERLINE, result.textDecoration);
			
			result = TextDecorationValue.parse("line-through");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_LINE_THROUGH, result.textDecoration);
			
			result = TextDecorationValue.parse("blink");
			Assert.assertEquals(TextDecorationValue.TEXT_DECORATION_BLINK, result.textDecoration);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a TextDecorationValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "none", "underline", "overline", "line-through", "blink" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(TextDecorationValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(TextDecorationValue.identify("FAAAAIL"));
		}
	}
}
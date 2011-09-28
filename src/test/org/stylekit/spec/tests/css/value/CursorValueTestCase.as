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
	
	import org.stylekit.css.value.CursorValue;

	public class CursorValueTestCase
	{
		[Test(description="Ensures that a string value may be parsed into a valid CursorValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:CursorValue;
			
			result = CursorValue.parse("auto");
			Assert.assertEquals(CursorValue.CURSOR_AUTO, result.cursor);
			
			result = CursorValue.parse("crosshair");
			Assert.assertEquals(CursorValue.CURSOR_CROSSHAIR, result.cursor);
			
			result = CursorValue.parse("default");
			Assert.assertEquals(CursorValue.CURSOR_DEFAULT, result.cursor);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a CursorValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var tokens:Array = [ "auto", "crosshair", "default", "pointer", "move", "e-resize", "ne-resize", "nw-resize", "n-resize", "se-resize", "sw-resize", "s-resize", "w-resize", "text", "wait", "help", "progress" ];
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				Assert.assertTrue(CursorValue.identify(tokens[i]));
			}
			
			Assert.assertFalse(CursorValue.identify("FAAAAIL"));
		}
	}
}
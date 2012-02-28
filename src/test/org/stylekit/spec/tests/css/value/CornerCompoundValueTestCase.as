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
	
	import org.stylekit.css.value.CornerCompoundValue;

	public class CornerCompoundValueTestCase
	{
		[Test(description="Tests that a corner compound can parse a single value correctly.")]
		public function parseSingleValue():void
		{
			var value:CornerCompoundValue = CornerCompoundValue.parse("10px");
			
			Assert.assertEquals(10, value.bottomLeftValue.value);
			Assert.assertEquals(10, value.bottomRightValue.value);
			Assert.assertEquals(10, value.topLeftValue.value);
			Assert.assertEquals(10, value.topRightValue.value);
		}
		
		[Test(description="Tests that a corner compound can parse two different values correctly.")]
		public function parseDoubleValues():void
		{
			var value:CornerCompoundValue = CornerCompoundValue.parse("10px 20px");
			
			Assert.assertEquals(10, value.bottomLeftValue.value);
			Assert.assertEquals(20, value.bottomRightValue.value);
			Assert.assertEquals(20, value.topLeftValue.value);
			Assert.assertEquals(10, value.topRightValue.value);
		}
		
		[Test(description="Tests that a corner compound can parse three different values correctly.")]
		public function parseTripleValues():void
		{
			var value:CornerCompoundValue = CornerCompoundValue.parse("10px 20px 30px");
			
			Assert.assertEquals(20, value.bottomLeftValue.value);
			Assert.assertEquals(30, value.bottomRightValue.value);
			Assert.assertEquals(20, value.topLeftValue.value);
			Assert.assertEquals(10, value.topRightValue.value);
		}
		
		[Test(description="Tests that a corner compound can parse four different values correctly.")]
		public function parseQuadrupleValues():void
		{
			var value:CornerCompoundValue = CornerCompoundValue.parse("10px 20px 30px 40px");
			
			Assert.assertEquals(30, value.bottomLeftValue.value);
			Assert.assertEquals(20, value.bottomRightValue.value);
			Assert.assertEquals(40, value.topLeftValue.value);
			Assert.assertEquals(10, value.topRightValue.value);
		}
	}
}
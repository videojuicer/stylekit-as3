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
	import org.stylekit.ui.element.UIElement;

	public class SizeValueTestCase {
		
		protected var _result:SizeValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid SizeValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:SizeValue;
			
			result = SizeValue.parse("3.4em");
			Assert.assertEquals(3.4, result.value);
			Assert.assertEquals("em", result.units);
			
			result = SizeValue.parse("3000%");
			Assert.assertEquals(3000, result.value);
			Assert.assertEquals("%", result.units);
			
			result = SizeValue.parse("3.1 em");
			Assert.assertEquals(3.1, result.value);
			Assert.assertEquals("em", result.units);
			
			result = SizeValue.parse("0");
			Assert.assertEquals(0, result.value);
			Assert.assertEquals("px", result.units);
		}
		
		[Test(description="Ensures a SizeValue with auto evaluates to NaN, as the auto margin is calculated else where")]
		public function ensureAutoEvaluatesToNaN():void
		{
			var result:SizeValue = SizeValue.parse("auto");
			
			Assert.assertEquals(NaN, result.value);
			Assert.assertTrue(result.auto);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a SizeValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(SizeValue.identify("30px"));
			Assert.assertTrue(SizeValue.identify("50%"));
			Assert.assertTrue(SizeValue.identify("3em"));
			Assert.assertFalse(SizeValue.identify("px"));
			Assert.assertFalse(SizeValue.identify("5"));
		}
		
		[Test(description="Ensures that a SizeValue may be evaluated to an actual pixel value.")]
		public function sizeValuesEvaluateWithUIElements():void
		{
			var parent:UIElement = new UIElement();
			parent.evaluatedStyles = {"width": SizeValue.parse("500px"), "font-size": SizeValue.parse("50px")};
			var child:UIElement = new UIElement();
			parent.addElement(child);
			
			var s1:SizeValue = SizeValue.parse("50px");

			Assert.assertEquals(50, s1.evaluateSize(parent));
			Assert.assertEquals(50, s1.evaluateSize(child));
			
			var s2:SizeValue = SizeValue.parse("50%");
			
			Assert.assertEquals(250, s2.evaluateSize(child));
			
			var s3:SizeValue = SizeValue.parse("0.5em");
			
			Assert.assertEquals(25, s3.evaluateSize(child));
			
		}
		
	}
}
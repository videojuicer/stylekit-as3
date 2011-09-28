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

	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.ui.element.UIElement;

	public class PropertyListValueTestCase {
		
		protected var _result:PropertyListValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid PropertyListValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:PropertyListValue;
			
			result = PropertyListValue.parse("border-left-width,border-right-width");
			Assert.assertEquals(2, result.properties.length);
			Assert.assertTrue(result.hasProperty("border-right-width"));
			
			result = PropertyListValue.parse("all");
			Assert.assertTrue(result.hasProperty("border-right-width"));
			
			result = PropertyListValue.parse("border-right-width, none");
			Assert.assertFalse(result.hasProperty("border-right-width"));
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a PropertyListValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(PropertyListValue.identify("all"));
			Assert.assertTrue(PropertyListValue.identify("none"));
			Assert.assertTrue(PropertyListValue.identify("border-left-width,padding-right"));
		}
		
	}
}
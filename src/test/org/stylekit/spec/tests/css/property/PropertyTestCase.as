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
package org.stylekit.spec.tests.css.property
{
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.property.Property;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.events.PropertyEvent;
	
	public class PropertyTestCase
	{
		[Test(description="Tests that a property can be evaluated into a flat hash successfully")]
		public function ableToEvaluate():void
		{
			// test some colours
			this.evaluatePropertyAndValue("background-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-left-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-right-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-top-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-bottom-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("border-left-color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("color", ColorValue.parse("#FFFFFF"));
			this.evaluatePropertyAndValue("outline-color", ColorValue.parse("#FFFFFF"));
			
			// some sizes
			this.evaluatePropertyAndValue("margin-top", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-bottom", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-left", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("margin-right", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-top", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-bottom", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-left", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("padding-right", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("outline-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("font-size", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-bottom-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-top-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-left-width", SizeValue.parse("10px"));
			this.evaluatePropertyAndValue("border-right-width", SizeValue.parse("10px"));
		}
		
		protected function evaluatePropertyAndValue(propertyName:String, value:Value):void
		{
			var property:Property = new Property(propertyName, value);
			var mergeParent:Object = property.evaluateProperty(new Object(), null);
			
			Assert.assertNotNull(mergeParent);
			Assert.assertTrue(mergeParent.hasOwnProperty(propertyName));
			Assert.assertNotNull(mergeParent[propertyName]);
			Assert.assertEquals(mergeParent[propertyName], value);
		}
		
		public function ableToEvaluateInherit():void
		{
			
		}
		
		[Test(async, description="Tests that a Property dispatches a MODIFIED event when the inner Value is modified")]
		public function propertyDispatchesWhenValueModified():void
		{
			var prop:Property = new Property("color", ColorValue.parse("#FFFFFF"));
			
			Assert.assertNotNull(prop.value);
			
			var async:Function = Async.asyncHandler(this, this.onPropertyModified, 2000, { prop: prop }, this.onPropertyModifiedTimeout);
			
			prop.addEventListener(PropertyEvent.PROPERTY_MODIFIED, async);
			
			(prop.value as ColorValue).hexValue = 0x000000;
		}
		
		protected function onPropertyModified(e:PropertyEvent, passThru:Object):void
		{
			Assert.assertNotNull(passThru.prop);
			Assert.assertEquals(0x000000, ((passThru.prop as Property).value as ColorValue).hexValue);
		}
		
		protected function onPropertyModifiedTimeout(passThru:Object):void
		{
			Assert.fail("Timeout occured whilst waiting for a modification event from the Property");
		}
	}
}
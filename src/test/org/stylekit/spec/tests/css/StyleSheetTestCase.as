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
package org.stylekit.spec.tests.css
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.PropertyContainerEvent;
	import org.stylekit.events.StyleSheetEvent;
	import org.stylekit.spec.Fixtures;
	
	public class StyleSheetTestCase
	{
		protected var _styleSheet:StyleSheet;
		protected var _styles:Vector.<Style>;
		
		[Before]
		public function setUp():void
		{
			this._styleSheet = new StyleSheet;
			this._styles = new Vector.<Style>();
			for(var i:uint=0; i<5; i++)
			{
				this._styles.push(new Style(this._styleSheet));
			}
		}
		
		[After]
		public function tearDown():void
		{
			this._styleSheet = null;
			this._styles = null;
		}
		
		[Test(description="Ensures that addStyle enforces uniqueness of known styles, and that the correct event listeners are created")]
		public function addStyleEnforcesUniquenessAndListensForEvents():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
			
				
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));
				


			}
		}
		
		[Test(description="Ensures that removeStyle removes the given style from the list and removes any event listeners on it")]
		public function removeStyleRemovesEventListners():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertFalse(this._styleSheet.removeStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));

				
				Assert.assertTrue(this._styleSheet.removeStyle(s));
				Assert.assertFalse(this._styleSheet.hasStyle(s));				

			}
		}
		
		[Test(async, description="Ensures that the StyleSheet dispatches a modified event when a Property mutates")]
		public function dispatchesEventsWhenPropertyMutates():void
		{
			var parser:StyleSheetParser = new StyleSheetParser();
			var parsed:StyleSheet = parser.parse(Fixtures.CSS_MIXED);
			
			var async:Function = Async.asyncHandler(this, this.onStyleSheetModified, 2000, { parsed: parsed }, this.onStyleSheetModifiedTimeout);
			
			parsed.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, async);
			
			// toggle the first property on the first stylesheet to use important
			parsed.styles[0].properties[0].value.important = true;
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent, passThru:Object):void
		{
			Assert.assertTrue((passThru.parsed as StyleSheet).styles[0].properties[0].value.important);
		}
		
		protected function onStyleSheetModifiedTimeout(passThru:Object):void
		{
			Assert.fail("Timeout occured whilst waiting for a modification event from the StyleSheetCollection");
		}
	}
}
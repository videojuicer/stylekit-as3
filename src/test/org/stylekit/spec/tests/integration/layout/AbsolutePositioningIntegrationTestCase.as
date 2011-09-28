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
package org.stylekit.spec.tests.integration.layout
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import flash.geom.Point;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	
	import org.stylekit.spec.Fixtures;
	
	public class AbsolutePositioningIntegrationTestCase
	{
		protected var _baseUI:BaseUI;
		protected var _styleSheetCollection:StyleSheetCollection;
		protected var _styleSheets:Vector.<StyleSheet>;
		protected var _parsed:StyleSheet;
		
		[Before]
		public function setUp():void
		{
			this._baseUI = new BaseUI();
		}
		
		[After]
		public function tearDown():void
		{
			this._baseUI = null;
		}
		
		[Test(description="Tests a regression issue where elements with the 'bottom' property are incorrectly positioned (http://www.bugtails.com/projects/253/tickets/1167.html)")]
		public function bottomAnchoredElementsPositionedCorrectly():void
		{
			var container:UIElement = new UIElement(this._baseUI);
			var box:UIElement = new UIElement(this._baseUI);
			var shim1:UIElement = new UIElement(this._baseUI);
			var shim2:UIElement = new UIElement(this._baseUI);
			var testSubject:UIElement = new UIElement(this._baseUI);
			
			// In the original manifestation of this problem, there were two other block elements
			// in the container before the test subject element was added.
			// This block of assertions tests this particular setup.
			
			this._baseUI.addElement(container);
			container.addElement(box);
			box.addElement(shim1);
			box.addElement(shim2);
			box.addElement(testSubject);

			this._baseUI.localStyleString = "width: 100px; height: 100px;";
			box.localStyleString = "float: right; width: 30px; height: 30px;";
			container.localStyleString = "position: absolute; bottom: 0px; display: block; width: 100%; height: 30px;";
			shim1.localStyleString = "float: left; position: relative; display: block; width: 100px; height: 100px;";
			shim2.localStyleString = "display: none;";
			testSubject.localStyleString = "display: block; width: 50px; height: 100px; position: absolute; bottom: 30px";
			
			Assert.assertEquals(100, testSubject.effectiveHeight);
			Assert.assertEquals(0, this._baseUI.localToGlobal(new Point(0,0)).y);
			Assert.assertEquals(-30, testSubject.localToGlobal(new Point(0,0)).y);
			
			// And now we remove the shim elements and assert that the position hasn't changed.
		}
	}
}
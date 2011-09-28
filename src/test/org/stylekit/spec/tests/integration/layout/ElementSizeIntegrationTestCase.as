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
	
	public class ElementSizeIntegrationTestCase
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
		
		[Test(description="Elements with height: auto correctly recalculate their dimensions when children modify their sizes")]
		public function heightAutoElementsCalculateContentSizes():void
		{
			var wrapper:UIElement = new UIElement(this._baseUI);
				wrapper.localStyleString = "width: 100px; height: auto;";
			
			Assert.assertEquals(0, wrapper.contentHeight);
			
			var children:Vector.<UIElement> = new Vector.<UIElement>();
			for(var i:uint=0; i<5; i++)
			{
				var h:uint = wrapper.contentHeight;
				var c:UIElement = new UIElement(this._baseUI);
					c.localStyleString = "display: block; width: 50px; height: 10px;";
				children.push(c);
				
				wrapper.addElement(c);
				Assert.assertEquals(h+10, wrapper.contentHeight);
			}
			
			// Now take a child and increase its size
			children[0].localStyleString = "display: block; width: 50px; height: 100px;";
			Assert.assertEquals(140, wrapper.contentHeight);
			
			// Now do something evil - set them all to float
			for(var j:uint=0; j<children.length; j++)
			{
				children[j].localStyleString = "display: block; width: 50px; height: 10px; float: left;";
			}
			// It should now be wrapped onto three lines
			Assert.assertEquals(30, wrapper.contentHeight);
		}
		
		[Test(description="Ensures that padding and margin correctly influence an element's effectiveContentWidth when width: auto")]
		public function paddingSubtractedFromEffectiveContentWidthOnWidthAuto():void
		{
			// refers to http://www.bugtails.com/projects/253/tickets/1186.html
			var wrapper:UIElement = new UIElement(this._baseUI);
			var autoElem:UIElement = new UIElement(this._baseUI);
				wrapper.addElement(autoElem);

			// Assert that the basics are all good
			wrapper.localStyleString = "width: 500px; height: 200px; padding: 50px;";
			Assert.assertEquals(500, wrapper.effectiveContentWidth);
			
			// Padding okay?
			autoElem.localStyleString = "width: auto; padding: 50px;";
			Assert.assertEquals(400, autoElem.effectiveContentWidth);

			// Margin okay?
			autoElem.localStyleString = "width: auto; margin: 25px;";
			Assert.assertEquals(450, autoElem.effectiveContentWidth);
			
			// Padding AND margin okay?
			autoElem.localStyleString = "width: auto; padding: 50px; margin: 25px;";
			Assert.assertEquals(350, autoElem.effectiveContentWidth);
		}
	}
}
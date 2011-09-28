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
package org.stylekit.spec.tests.css.selector
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.selector.MediaSelector;

	public class MediaSelectorTestCase {
		
		protected var _selector:MediaSelector;
		
		[Before]
		public function setUp():void
		{
			this._selector = new MediaSelector();
		}
		
		[After]
		public function tearDown():void
		{
			this._selector = null;
		}
		
		[Test(description="Ensures that a MediaSelector can match against a single media type")]
		public function matchesSingleMediaType():void
		{
			Assert.assertFalse(this._selector.hasMedia("foo"));
			Assert.assertTrue(this._selector.addMedia("foo"));
			Assert.assertTrue(this._selector.hasMedia("foo"));
		}
		
		[Test(description="Ensures that a MediaSelector can match against multiple media types")]
		public function matchesMultipleMediaTypes():void
		{
			var fooVec:Vector.<String> = new Vector.<String>();
				fooVec.push("foo");
			var barVec:Vector.<String> = new Vector.<String>();
				barVec.push("bar");
			var foobarVec:Vector.<String> = new Vector.<String>();
				foobarVec.push("foo"); foobarVec.push("bar");
			
			Assert.assertFalse(this._selector.hasMedia("foo"));
			Assert.assertFalse(this._selector.hasMedia("bar"));
			Assert.assertFalse(this._selector.matches(foobarVec));
			
			Assert.assertTrue(this._selector.addMedia("foo"));
			Assert.assertTrue(this._selector.matches(fooVec));
			Assert.assertFalse(this._selector.matches(barVec));
			Assert.assertTrue(this._selector.matches(foobarVec));
			
			Assert.assertTrue(this._selector.addMedia("bar"));
			Assert.assertTrue(this._selector.matches(fooVec));
			Assert.assertTrue(this._selector.matches(barVec));
			Assert.assertTrue(this._selector.matches(foobarVec));
		}
	}
}
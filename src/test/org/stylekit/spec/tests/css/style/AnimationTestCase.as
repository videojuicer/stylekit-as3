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
package org.stylekit.spec.tests.css.style
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.spec.Fixtures;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.Animation;
	import org.stylekit.css.style.AnimationKeyFrame;
	
	public class AnimationTestCase
	{
		protected var _styleSheet:StyleSheet;
		protected var _animation:Animation;
		protected var _keyFrames:Vector.<AnimationKeyFrame>;
		
		[Before]
		public function setUp():void
		{
			this._styleSheet = new StyleSheet();
			this._animation = new Animation(this._styleSheet);
			this._keyFrames = new Vector.<AnimationKeyFrame>();
			for(var i:uint = 0; i < 10; i++)
			{
				this._keyFrames.push(new AnimationKeyFrame(this._styleSheet));
			}
		}
		
		[After]
		public function tearDown():void
		{
			this._styleSheet = null;
			this._animation = null;
			this._keyFrames = null;
		}
		
		[Test(description="Ensure that multiple copies of the same keyframe cannot be added to an animation")]
		public function collectionEnforcesUniquenessOnChildren():void
		{
			for(var i:uint=0; i<this._keyFrames.length; i++)
			{
				var s:AnimationKeyFrame = this._keyFrames[i];
				
				Assert.assertFalse(this._animation.hasKeyFrame(s));
				Assert.assertTrue(this._animation.addKeyFrame(s));
				Assert.assertTrue(this._animation.hasKeyFrame(s));
				Assert.assertFalse(this._animation.addKeyFrame(s));
			}
		}
		
	}
}
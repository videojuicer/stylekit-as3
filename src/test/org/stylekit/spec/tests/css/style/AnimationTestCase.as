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
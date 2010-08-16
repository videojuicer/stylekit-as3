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
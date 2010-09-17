package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.AnimationIterationCountValue;
	import org.stylekit.ui.element.UIElement;

	public class AnimationIterationCountValueTestCase {
		
		protected var _result:AnimationIterationCountValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid AnimationIterationCountValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:AnimationIterationCountValue;
			
			result = AnimationIterationCountValue.parse("infinite");
			Assert.assertEquals(Infinity, result.iterationCount);
			
			result = AnimationIterationCountValue.parse("9");
			Assert.assertEquals(9, result.iterationCount);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a AnimationIterationCountValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(AnimationIterationCountValue.identify("infinite"));
			Assert.assertTrue(AnimationIterationCountValue.identify("9"));
			Assert.assertFalse(AnimationIterationCountValue.identify("9.0"));
			Assert.assertFalse(AnimationIterationCountValue.identify("foo"));
		}
		
	}
}
package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.AnimationDirectionValue;
	import org.stylekit.ui.element.UIElement;

	public class AnimationDirectionValueTestCase {
		
		protected var _result:AnimationDirectionValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid AnimationDirectionValue object.")]
		public function stringParsesCorrectly():void
		{
			var result:AnimationDirectionValue;
			
			result = AnimationDirectionValue.parse("normal");
			Assert.assertEquals(AnimationDirectionValue.DIRECTION_NORMAL, result.direction);
			
			result = AnimationDirectionValue.parse("nonsense");
			Assert.assertEquals(AnimationDirectionValue.DIRECTION_NORMAL, result.direction);
			
			result = AnimationDirectionValue.parse("alternate");
			Assert.assertEquals(AnimationDirectionValue.DIRECTION_ALTERNATE, result.direction);
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a AnimationDirectionValue.")]
		public function stringIdentifiesCorrectly():void
		{
			Assert.assertTrue(AnimationDirectionValue.identify("normal"));
			Assert.assertTrue(AnimationDirectionValue.identify("alternate"));
			Assert.assertFalse(AnimationDirectionValue.identify("nonsense"));
		}
		
	}
}
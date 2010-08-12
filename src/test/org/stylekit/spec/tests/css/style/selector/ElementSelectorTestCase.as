package org.stylekit.spec.tests.css.style.selector
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.style.selector.ElementSelector;

	public class ElementSelectorTestCase {
		
		protected var _selector:ElementSelector;
		
		[Before]
		public function setUp():void
		{
			this._selector = new ElementSelector();
		}
		
		[After]
		public function tearDown():void
		{
			this._selector = null;
		}
		
		[Test(description="Ensures that addElementClassName, hasElementClassName and removeElementClassName work correctly and that uniqueness is enforced")]
		public function testClassNameUniqueness():void
		{
			Assert.assertFalse(this._selector.hasElementClassName("one"));
			Assert.assertFalse(this._selector.removeElementClassName("one"));
			
			Assert.assertTrue(this._selector.addElementClassName("one"));
			Assert.assertTrue(this._selector.hasElementClassName("one"));
			Assert.assertFalse(this._selector.addElementClassName("one"));
			
			Assert.assertTrue(this._selector.removeElementClassName("one"));
			Assert.assertFalse(this._selector.hasElementClassName("one"));
		}
		
		[Test(description="Ensures that addPseudoClass, hasPseudoClass and removePseudoClass work correctly and that uniqueness is enforced")]
		public function testPseudoClassUniqueness():void
		{
			Assert.assertFalse(this._selector.hasElementPseudoClass("one"));
			Assert.assertFalse(this._selector.removeElementPseudoClass("one"));

			Assert.assertTrue(this._selector.addElementPseudoClass("one"));
			Assert.assertTrue(this._selector.hasElementPseudoClass("one"));
			Assert.assertFalse(this._selector.addElementPseudoClass("one"));

			Assert.assertTrue(this._selector.removeElementPseudoClass("one"));
			Assert.assertFalse(this._selector.hasElementPseudoClass("one"));
		}
		
		[Test(description="Ensures that adding the last-child and first-child pseudoclasses sets the appropriate flags")]
		public function firstLastChildPseudoClassesSetFlags():void
		{
			Assert.assertFalse(this._selector.hasElementPseudoClass("first-child"));
			Assert.assertFalse(this._selector.specifiesFirstChild);
			Assert.assertTrue(this._selector.addElementPseudoClass("first-child"));
			Assert.assertTrue(this._selector.specifiesFirstChild);
			
			Assert.assertFalse(this._selector.hasElementPseudoClass("last-child"));
			Assert.assertFalse(this._selector.specifiesLastChild);
			Assert.assertTrue(this._selector.addElementPseudoClass("last-child"));
			Assert.assertTrue(this._selector.specifiesLastChild);
			
		}
		
		[Test(description="Ensures that adding the last-letter and first-letter pseudoclasses sets the appropriate flags")]
		public function firstLastLetterPseudoClassesSetFlags():void
		{
			Assert.assertFalse(this._selector.hasElementPseudoClass("first-letter"));
			Assert.assertFalse(this._selector.firstLetterOnly);
			Assert.assertTrue(this._selector.addElementPseudoClass("first-letter"));
			Assert.assertTrue(this._selector.firstLetterOnly);
			
			Assert.assertFalse(this._selector.hasElementPseudoClass("last-letter"));
			Assert.assertFalse(this._selector.lastLetterOnly);
			Assert.assertTrue(this._selector.addElementPseudoClass("last-letter"));
			Assert.assertTrue(this._selector.lastLetterOnly);
			
		}
		
	}
	
}


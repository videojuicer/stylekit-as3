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

	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.selector.ElementSelector;

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
		
		[Test(description="Ensures that selectors may be sorted by specificity")]
		public function specificityIsComparable():void
		{
			var p:ElementSelectorParser = new ElementSelectorParser();
			
			var a:ElementSelector = p.parseElementSelector("p");
			var b:ElementSelector = p.parseElementSelector("p:first-letter");
			var c:ElementSelector = p.parseElementSelector("p.class");
			var d:ElementSelector = p.parseElementSelector("p#id");
			var e:ElementSelector = p.parseElementSelector("p#id.class");
			
			Assert.assertTrue(b.specificity > a.specificity);
			Assert.assertTrue(c.specificity > b.specificity);
			Assert.assertTrue(d.specificity > c.specificity);
			Assert.assertTrue(e.specificity > d.specificity);
		}
		
	}
	
}


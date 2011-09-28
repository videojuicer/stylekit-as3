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
package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.spec.Fixtures;
	
	import org.stylekit.css.parse.ElementSelectorParser;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.selector.ElementSelector;
	
	public class ElementSelectorParserTestCase
	{
		
		protected var _parser:ElementSelectorParser;
		protected var _parserResult:Vector.<ElementSelectorChain>;
		
		[Before]
		public function setUp():void
		{
			this._parser = new ElementSelectorParser();
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Ensures that a selector containing multiple comma-delim selectors is parsed correctly")]
		public function commasBreakSelectorIntoMultipleChains():void
		{
			this._parserResult = this._parser.parseSelector(" foo bar, p:last-child, div > h1 , foo");
			Assert.assertEquals(4, this._parserResult.length);
		}
		
		[Test(description="Ensures that a single selector is parsed correctly")]
		public function basicSingleSelectorParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("foo");
			Assert.assertEquals(1, this._parserResult.length);
			
			// assert contents of selector
			var chain:ElementSelectorChain = this._parserResult[0];
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("foo", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a chain of simple selectors is parsed correctly")]
		public function basicSelectorChainParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("foo bar");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("foo", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
			
			selector = chain.elementSelectors[1];
			Assert.assertEquals("bar", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that an advanced selector chain with ancestor conditions is parsed correctly.")]
		public function complexSelectorChainWithAncestorConditionsParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("div:last-child > p#p #onlyid .classonly > name.class");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(5, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("div", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(1, selector.elementPseudoClasses.length);
				Assert.assertEquals("last-child", selector.elementPseudoClasses[0]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertTrue(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
			
			selector = chain.elementSelectors[1];
			Assert.assertEquals("p", selector.elementName);
			Assert.assertEquals("p", selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(chain.elementSelectors[0], selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
			
			selector = chain.elementSelectors[2];
			Assert.assertEquals(null, selector.elementName);
			Assert.assertEquals("onlyid", selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);

			selector = chain.elementSelectors[3];
			Assert.assertEquals(null, selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("classonly", selector.elementClassNames[0]);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
			
			selector = chain.elementSelectors[4];
			Assert.assertEquals("name", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("class", selector.elementClassNames[0]);
			Assert.assertEquals(0, selector.elementPseudoClasses.length);
			Assert.assertEquals(chain.elementSelectors[3], selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a selector consisting of only a pseudoclass followed by a class is parsed correctly")]
		public function pseudoClassThenClassParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector(":pseudo-one.class-two");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals(null, selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("class-two", selector.elementClassNames[0]);
			Assert.assertEquals(1, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudo-one", selector.elementPseudoClasses[0]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a selector containing only a class followed by a pseudoclass is parsed correctly")]
		public function classThenPseudoParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector(".class-one:pseudo-two");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals(null, selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("class-one", selector.elementClassNames[0]);
			Assert.assertEquals(1, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudo-two", selector.elementPseudoClasses[0]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that elementNameMatchRequired is correctly set on the selector")]
		public function elementNameMatchRequiredSetCorrectly():void
		{
			var matchRequired:String = "p div div#id div.class div:pseudo";
			var matchNotRequired:String = "#id .class :pseudo * *.class *:pseudo *#id";
			
			this._parserResult = this._parser.parseSelector(matchRequired);
			var matchRequiredChain:ElementSelectorChain = this._parserResult[0];
			for(var i:uint = 0; i < matchRequiredChain.elementSelectors.length; i++)
			{
				Assert.assertTrue(matchRequiredChain.elementSelectors[i].elementNameMatchRequired)
			}
			
			this._parserResult = this._parser.parseSelector(matchNotRequired);
			var matchNotRequiredChain:ElementSelectorChain = this._parserResult[0];
			for(i = 0; i < matchNotRequiredChain.elementSelectors.length; i++)
			{
				var sel:ElementSelector = matchNotRequiredChain.elementSelectors[i];
				Assert.assertFalse("Failing on selector: "+matchNotRequired.split(" ")[i]+" elementName: '"+sel.elementName+"'" ,sel.elementNameMatchRequired)
			}
		}
		
		[Test(description="Ensures that a selector containing only an ID followed by a pseudoclass is parsed correctly")]
		public function idThenPseudoParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("#id-one:pseudo-two");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals(null, selector.elementName);
			Assert.assertEquals("id-one", selector.elementID);
			Assert.assertEquals(0, selector.elementClassNames.length);
			Assert.assertEquals(1, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudo-two", selector.elementPseudoClasses[0]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a selector containing an element and a class followed by a pseudoclass is parsed correctly")]
		public function elementWithClassAndPseudoParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("element-one.class-two:pseudo-three");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("element-one", selector.elementName);
			Assert.assertEquals(null, selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("class-two", selector.elementClassNames[0]);
			Assert.assertEquals(1, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudo-three", selector.elementPseudoClasses[0]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a selector containing multiple classes followed by multiple pseudoclasses is parsed correctly")]
		public function elementWithIdThenNClassesThenNPseudoParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("element#id.classone.classtwo:pseudoone:pseudotwo");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("element", selector.elementName);
			Assert.assertEquals("id", selector.elementID);
			Assert.assertEquals(2, selector.elementClassNames.length);
				Assert.assertEquals("classone", selector.elementClassNames[0]);
				Assert.assertEquals("classtwo", selector.elementClassNames[1]);
			Assert.assertEquals(2, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudoone", selector.elementPseudoClasses[0]);
				Assert.assertEquals("pseudotwo", selector.elementPseudoClasses[1]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
		[Test(description="Ensures that a selector containing an irregular configuration of classes and pseudoclasses parses recoverably")]
		public function elementWithMixedClassAndPseudoParsesCorrectly():void
		{
			this._parserResult = this._parser.parseSelector("element#id:pseudo.classone:pseudoone:pseudotwo");
			Assert.assertEquals(1, this._parserResult.length);
			
			var chain:ElementSelectorChain = this._parserResult[0];
			Assert.assertEquals(1, chain.elementSelectors.length)
			
			var selector:ElementSelector = chain.elementSelectors[0];
			Assert.assertEquals("element", selector.elementName);
			Assert.assertEquals("id", selector.elementID);
			Assert.assertEquals(1, selector.elementClassNames.length);
				Assert.assertEquals("classone", selector.elementClassNames[0]);
			Assert.assertEquals(3, selector.elementPseudoClasses.length);
				Assert.assertEquals("pseudo", selector.elementPseudoClasses[0]);
				Assert.assertEquals("pseudoone", selector.elementPseudoClasses[1]);
				Assert.assertEquals("pseudotwo", selector.elementPseudoClasses[2]);
			Assert.assertEquals(null, selector.parentSelector);
			Assert.assertFalse(selector.specifiesLastChild);
			Assert.assertFalse(selector.specifiesFirstChild);
		}
		
	}
}
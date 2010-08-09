package org.stylekit.spec.tests.css
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.StyleEvent;
	
	public class StyleSheetTestCase
	{
		protected var _styleSheet:StyleSheet;
		protected var _styles:Vector.<Style>;
		
		[Before]
		public function setUp():void
		{
			this._styleSheet = new StyleSheet;
			this._styles = new Vector.<Style>();
			for(var i:uint=0; i<5; i++)
			{
				this._styles.push(new Style(this._styleSheet));
			}
		}
		
		[After]
		public function tearDown():void
		{
			this._styleSheet = null;
			this._styles = null;
		}
		
		[Test(description="Ensures that addStyle enforces uniqueness of known styles, and that the correct event listeners are created")]
		public function addStyleEnforcesUniquenessAndListensForEvents():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
				Assert.assertFalse(s.hasEventListener(StyleEvent.MUTATION));
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));
				Assert.assertTrue(s.hasEventListener(StyleEvent.MUTATION));
			}
		}
		
		[Test(description="Ensures that removeStyle removes the given style from the list and removes any event listeners on it")]
		public function removeStyleRemovesEventListners():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertFalse(this._styleSheet.removeStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));
				Assert.assertTrue(s.hasEventListener(StyleEvent.MUTATION));
				Assert.assertTrue(this._styleSheet.removeStyle(s));
				Assert.assertFalse(this._styleSheet.hasStyle(s));				
				Assert.assertFalse(s.hasEventListener(StyleEvent.MUTATION));
			}
		}
		
		
		
	}
}
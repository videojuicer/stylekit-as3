package org.stylekit.spec.tests.css
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
	
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.StyleSheet;
	
	public class StyleSheetCollectionTestCase
	{
		protected var _styleSheetCollection:StyleSheetCollection;
		protected var _styleSheets:Vector.<StyleSheet>;
		
		[Before]
		public function setUp():void
		{
			this._styleSheetCollection = new StyleSheetCollection;
			this._styleSheets = new Vector.<StyleSheet>();
			for(var i:uint=0; i<5; i++)
			{
				this._styleSheets.push(new StyleSheet());
			}
		}
		
		[After]
		public function tearDown():void
		{
			this._styleSheetCollection = null;
			this._styleSheets = null;
		}
		
		[Test(description="Ensure that multiple copies of the same StyleSheet cannot be added to a collection")]
		public function collectionEnforcesUniquenessOnChildren():void
		{
			for(var i:uint=0; i<this._styleSheets.length; i++)
			{
				var s:StyleSheet = this._styleSheets[i];
				
				Assert.assertFalse(this._styleSheetCollection.hasStyleSheet(s));
				Assert.assertTrue(this._styleSheetCollection.addStyleSheet(s));
				Assert.assertTrue(this._styleSheetCollection.hasStyleSheet(s));
				Assert.assertFalse(this._styleSheetCollection.addStyleSheet(s));
			}
		}
		
		[Test(description="Ensure that removal of stylesheets from the collection works cleanly and returns the correct boolean value")]
		public function sheetsMayBeRemovedFromCollection():void
		{
			for(var i:uint=0; i<this._styleSheets.length; i++)
			{
				var s:StyleSheet = this._styleSheets[i];				
				Assert.assertTrue(this._styleSheetCollection.addStyleSheet(s));
			}
			for(var j:uint=0; j<this._styleSheets.length; j++)
			{
				var s1:StyleSheet = this._styleSheets[j];				
				Assert.assertTrue(this._styleSheetCollection.hasStyleSheet(s1));
				Assert.assertTrue(this._styleSheetCollection.removeStyleSheet(s1));
				Assert.assertFalse(this._styleSheetCollection.hasStyleSheet(s1));
			}
			for(var k:uint=0; k<this._styleSheets.length; k++)
			{
				var s2:StyleSheet = this._styleSheets[k];
				Assert.assertFalse(this._styleSheetCollection.removeStyleSheet(s2));
			}
		}
		
		// TODO: Bubbles a STYLE_MUTATION event from any constituent stylesheets
		// TODO: Emits a STYLE_MUTATION event on adding a stylesheet
		// TODO: Emits a STYLE_MUTATION event on removing a stylesheet
		
	}
}
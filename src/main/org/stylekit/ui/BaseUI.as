package org.stylekit.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.ui.element.UIElement;
	
	public class BaseUI extends UIElement
	{
		protected var _styleSheetCollection:StyleSheetCollection;
		protected var _root:DisplayObject;
		
		public function BaseUI(styleSheetCollection:StyleSheetCollection = null, root:DisplayObject = null)
		{
			this._styleSheetCollection = styleSheetCollection;
			this._root = root;
			
			super();
			
			if (this._root != null && this._root.stage != null)
			{
				this._root.stage.addEventListener(Event.RESIZE, this.onRootResized, false, 1);
			}
		}
		
		public override function get baseUI():BaseUI
		{
			return this;
		}
		
		public override function get styleEligible():Boolean
		{
			return true;
		}
		
		public override function get styleParent():UIElement
		{
			return this;
		}
		
		public function get stageRoot():DisplayObject
		{
			return this._root;
		}
		
		public function get styleSheetCollection():StyleSheetCollection
		{
			return this._styleSheetCollection;
		}
		
		public function createUIElement():UIElement
		{
			return new UIElement(this);
		}
		
		protected function onRootResized(e:Event):void
		{
			trace("BaseUI resizing from "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
			
			this.recalculateEffectiveContentDimensions();
			
			trace("BaseUI parent -> "+this.stageRoot.stage.width+"/"+this.stageRoot.stage.height);
			trace("BaseUI resized to "+this.effectiveContentWidth+"/"+this.effectiveContentHeight+" ...");
		}
	}
}
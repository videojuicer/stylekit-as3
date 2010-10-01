package org.stylekit.ui.element
{
	import flash.display.Sprite;
	
	import org.stylekit.ui.BaseUI;
	
	public class SpriteWrapperUIElement extends UIElement
	{
		protected var _sprite:Sprite;
		
		public function SpriteWrapperUIElement(baseUI:BaseUI=null)
		{
			super(baseUI);
		}
		
		public function get sprite():Sprite
		{
			return this._sprite;
		}
		
		public function set sprite(sprite:Sprite):void
		{
			this._sprite = sprite;
			
			this.layoutChildren();
		}
		
		public override function get contentWidth():int
		{
			return this._sprite.width;
		}
		
		public override function get contentHeight():int
		{
			return this._sprite.height;
		}
		
		public override function layoutChildren():void
		{
			for (var i:int = 0; i < super.numChildren; i++)
			{
				super.removeChildAt(i);
			}
			
			if (this.sprite != null)
			{
				super.addChild(this.sprite);
			}
		}
	}
}
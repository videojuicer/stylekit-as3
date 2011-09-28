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
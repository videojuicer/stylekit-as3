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
package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	import org.stylekit.css.value.SizeValue;
	
	import org.utilkit.logger.Logger;
	
	public class StyleKitConsole extends Sprite
	{
		protected var _parser:StyleSheetParser;
		protected var _baseUI:BaseUI;
		
		protected var _elements:Vector.<UIElement>;
		
		public function StyleKitConsole()
		{
			super();
			
			Logger.defaultRenderers();
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this._elements = new Vector.<UIElement>();
			this._parser = new StyleSheetParser();
			
			// setup the external JavaScript interface
			this.setupExternalInterface();
			
			// setup the sandbox user interface that can be manipulated
			this.setupSandboxInterface();
			
			this._baseUI.redraw();
		}
		
		protected function setupSandboxInterface():void
		{
			this._baseUI = new BaseUI(new StyleSheetCollection(), this);
			
			this.addChild(this._baseUI);
			
			this._baseUI.evaluatedStyles = { width: SizeValue.parse("100%"), height: SizeValue.parse("100%"), padding: SizeValue.parse("0px") };
			
			var hBox:UIElement = this.createUIElement(this._baseUI, "div", "hBox", [ 'toolbar' ]);
			
			//var button1:UIElement = this.createUIElement(hBox, "span", "button1", [ 'button' ]);
			//var button2:UIElement = this.createUIElement(hBox, "span", "button2", [ 'button' ]);
			//var button3:UIElement = this.createUIElement(hBox, "span", "button3", [ 'button' ]);
			
			var vBox:UIElement = this.createUIElement(this._baseUI, "div", "vBox", [ 'toolbar' ]);
			
			//var button4:UIElement = this.createUIElement(vBox, "span", "button4", [ 'button' ]);
			//var button5:UIElement = this.createUIElement(vBox, "span", "button5", [ 'button' ]);
			//var button6:UIElement = this.createUIElement(vBox, "span", "button6", [ 'button' ]);
			
			var empty:UIElement = this.createUIElement(this._baseUI, "div", "empty", [ 'toolbar' ]);
		}
		
		protected function createUIElement(parent:UIElement, elementName:String, elementId:String, classNames:Array):UIElement
		{
			var element:UIElement = this._baseUI.createUIElement();
			
			element.elementName = elementName;
			element.elementId = elementId;
			
			for (var i:int = 0; i < classNames.length; i++)
			{
				element.addElementClassName(classNames[i]);
			}
			
			if (parent != null)
			{
				trace("Adding child to parent", elementName, elementId, classNames);
				parent.addElement(element);
				trace("Added child to parent", elementName, elementId, classNames);
			}
			
			return element;
		}
		
		protected function updateCascadingStyles(css:String):void
		{
			var sheet:StyleSheet = this._parser.parse(css);
			
			if (this._baseUI != null)
			{
				if (this._baseUI.styleSheetCollection.length > 0)
				{
					this._baseUI.styleSheetCollection.removeStyleSheet(this._baseUI.styleSheetCollection.styleSheets[0]);
				}
				
				this._baseUI.styleSheetCollection.addStyleSheet(sheet);
			}
		}
		
		protected function setupExternalInterface():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("updateCascadingStyles", this.updateCascadingStyles);
			}
		}
	}
}
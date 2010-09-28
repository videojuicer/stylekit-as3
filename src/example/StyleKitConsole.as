package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	
	public class StyleKitConsole extends Sprite
	{
		protected var _parser:StyleSheetParser;
		protected var _baseUI:BaseUI;
		
		protected var _elements:Vector.<UIElement>;
		
		public function StyleKitConsole()
		{
			super();
			
			this._elements = new Vector.<UIElement>();
			this._parser = new StyleSheetParser();
			
			// setup the external JavaScript interface
			this.setupExternalInterface();
			
			// setup the sandbox user interface that can be manipulated
			this.setupSandboxInterface();
		}
		
		protected function setupSandboxInterface():void
		{
			this._baseUI = new BaseUI(new StyleSheetCollection(), this);
			
			this.addChild(this._baseUI);
			
			var hBox:UIElement = this.createUIElement(this._baseUI, "div", "hBox", [ 'toolbar' ]);
			
			var button1:UIElement = this.createUIElement(hBox, "span", "button1", [ 'button' ]);
			//this.createUIElement(hBox, "span", "button2", [ 'button' ]);
			//this.createUIElement(hBox, "span", "button3", [ 'button' ]);
			
			/*
			var vBox:UIElement = this.createUIElement(this._baseUI, "div", "vBox", [ 'toolbar' ]);
			
			this.createUIElement(vBox, "span", null, [ 'button' ]);
			this.createUIElement(vBox, "span", null, [ 'button' ]);
			this.createUIElement(vBox, "span", null, [ 'button' ]);
			
			var empty:UIElement = this.createUIElement(this._baseUI, "div", "empty", [ 'toolbar' ]);
			*/
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
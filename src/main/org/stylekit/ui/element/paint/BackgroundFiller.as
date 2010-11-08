package org.stylekit.ui.element.paint
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.stylekit.css.value.BackgroundPositionValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.ui.element.UIElement;
	import org.utilkit.crypto.Base64;
	import org.utilkit.crypto.MD5;
	import org.utilkit.parser.DataURIParser;
	import org.utilkit.parser.URLParser;

	public class BackgroundFiller extends EventDispatcher
	{
		protected var _signature:String;
		protected var _url:URLValue;
		
		protected var _loader:Loader;
		protected var _loaderComplete:Boolean = false;
		
		protected var _bitmapData:BitmapData;
		
		public function BackgroundFiller()
		{
			
		}
		
		public function get signature():String
		{
			/*if (this._signature == null && this._url != null)
			{
				this._signature = MD5.encrypt(this._url.url);
			}
			
			return this._signature;*/
			
			return this._url.url;
		}
		
		public function get loaderComplete():Boolean
		{
			return this._loaderComplete;
		}
		
		public function load(url:URLValue):void
		{
			this._url = url;
			
			this._loader = new Loader();
			
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoaderIOError);
			
			if (this._url.url.indexOf("data:") == 0)
			{
				var dataParserURI:DataURIParser = new DataURIParser(this._url.url);
				var bufferBytes:ByteArray = Base64.decodeToByteArray(dataParserURI.rawData);
				bufferBytes.position = 0;
				
				this._loader.loadBytes(bufferBytes);
			}
			else
			{
				var parserURI:URLParser = new URLParser(this._url.url);
				
				this._loader.load(new URLRequest(parserURI.url), new LoaderContext(true));
			}
		}
		
		public function createBitmapFillForElement(uiElement:UIElement):BitmapData
		{
			var elementEffectiveWidth:int = uiElement.effectiveWidth;
			var elementEffectiveHeight:int = uiElement.effectiveHeight;
			var elementContentX:Number = uiElement.calculateContentPoint().x;
			var elementContentY:Number = uiElement.calculateContentPoint().y;
			
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			var backgroundHorizontalRepeat:Boolean = (uiElement.getStyleValue("background-repeat") as RepeatValue).horizontalRepeat;
			var backgroundVerticalRepeat:Boolean = (uiElement.getStyleValue("background-repeat") as RepeatValue).verticalRepeat;
			
			var backgroundPosition:BackgroundPositionValue = (uiElement.getStyleValue("background-position") as BackgroundPositionValue);

			var backgroundXRepeat:int = Math.ceil((backgroundHorizontalRepeat ? (elementEffectiveWidth / this._bitmapData.width) : 1));
			var backgroundYRepeat:int = Math.ceil((backgroundVerticalRepeat ? (elementEffectiveHeight / this._bitmapData.height) : 1));
			
			var fillBitmapData:BitmapData = new BitmapData(Math.max(1, uiElement.effectiveWidth), Math.max(1, uiElement.effectiveHeight), true, backgroundColor);
			
			// so how does one position a background?
			var positionX:Number = 0;
			var positionY:Number = 0;
			
			if (backgroundPosition != null)
			{
				if (backgroundPosition.positionX != null)
				{
					positionX = backgroundPosition.positionX.evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH);
					
					if (backgroundPosition.positionX.units == "%" && backgroundPosition.positionX.value > 0)
					{
						positionX = positionX - (this._bitmapData.width / 2);
					}
				}
				
				if (backgroundPosition.positionY != null)
				{
					positionY = backgroundPosition.positionY.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT);
					
					if (backgroundPosition.positionY.units == "%" && backgroundPosition.positionY.value > 0)
					{
						positionY = positionY - (this._bitmapData.height / 2);
					}
				}
			}
			
			for (var y:int = 0; y < backgroundYRepeat; y++)
			{
				for (var x:int = 0; x < backgroundXRepeat; x++)
				{
					var sectionWidth:int = (backgroundXRepeat == 1 ? this._bitmapData.width : (backgroundXRepeat - 1 == x ? (elementEffectiveWidth - (this._bitmapData.width * (backgroundXRepeat - 1))) : this._bitmapData.width));
					var sectionHeight:int = (backgroundYRepeat == 1 ? this._bitmapData.height : (backgroundYRepeat - 1 == x ? (elementEffectiveHeight - (this._bitmapData.height * (backgroundYRepeat - 1))) : this._bitmapData.height));
					
					var sectionX:int = (positionX + elementContentX + (this._bitmapData.width * x));
					var sectionY:int = (positionY + elementContentY + (this._bitmapData.height * y));
					
					//if (backgroundPosition != null && backgroundPosition.position == PositionValue.
					
					for (var h:int = sectionHeight; h >= 0; h--)
					{
						for (var w:int = sectionWidth; w >= 0; w--)
						{
							fillBitmapData.setPixel32(w + sectionX, h + sectionY, this._bitmapData.getPixel32(w, h));
						}
					}
				}
			}
			
			return fillBitmapData;
		}
		
		protected function onLoaderComplete(e:Event):void
		{
			this._bitmapData = (this._loader.content as Bitmap).bitmapData;
			this._loaderComplete = true;
			
			this.dispatchEvent(e.clone());
		}
		
		protected function onLoaderIOError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e.clone());
		}
	}
}
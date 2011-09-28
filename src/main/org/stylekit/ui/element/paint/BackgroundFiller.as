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
package org.stylekit.ui.element.paint
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.value.BackgroundPositionValue;
	import org.stylekit.css.value.BackgroundSizeValue;
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
			
			try
			{
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
			catch (e:Event)
			{
				StyleKit.logger.error("Error when attempting to load background image from "+url, this);
			}
			catch (e:IOError)
			{
				StyleKit.logger.error("IOError when attempting to load background image from "+url, this);
			}
			catch (e:SecurityError)
			{
				StyleKit.logger.error("SecurityError when attempting to load background image from "+url, this);
			}

		}
		
		public function createBitmapFillForElement(uiElement:UIElement):BitmapData
		{
			var elementEffectiveWidth:int = uiElement.effectiveWidth;
			var elementEffectiveHeight:int = uiElement.effectiveHeight;
			var elementContentX:Number = uiElement.calculateContentOriginPoint().x;
			var elementContentY:Number = uiElement.calculateContentOriginPoint().y;
			
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			var backgroundHorizontalRepeat:Boolean = (uiElement.getStyleValue("background-repeat") as RepeatValue).horizontalRepeat;
			var backgroundVerticalRepeat:Boolean = (uiElement.getStyleValue("background-repeat") as RepeatValue).verticalRepeat;
			
			var backgroundPosition:BackgroundPositionValue = (uiElement.getStyleValue("background-position") as BackgroundPositionValue);
			var backgroundSize:BackgroundSizeValue = (uiElement.getStyleValue("background-size") as BackgroundSizeValue);
			
			// need to work out size to stretch too
			var formattedBitmap:BitmapData = this._bitmapData.clone();;
			
			if (backgroundSize.contain || backgroundSize.cover)
			{
				var rect:Rectangle = this.createMatrixFor(uiElement, this._bitmapData);
				
				formattedBitmap = new BitmapData(rect.width, rect.height, true);
				
				var matrix:Matrix = new Matrix();
				matrix.scale((rect.width / this._bitmapData.width), (rect.height / this._bitmapData.height));
				
				formattedBitmap.draw(this._bitmapData, matrix);
			}

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
						positionX = positionX - (formattedBitmap.width / 2);
					}
				}
				
				if (backgroundPosition.positionY != null)
				{
					positionY = backgroundPosition.positionY.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT);
					
					if (backgroundPosition.positionY.units == "%" && backgroundPosition.positionY.value > 0)
					{
						positionY = positionY - (formattedBitmap.height / 2);
					}
				}
			}
			
			for (var y:int = 0; y < backgroundYRepeat; y++)
			{
				for (var x:int = 0; x < backgroundXRepeat; x++)
				{
					var sectionWidth:int = (backgroundXRepeat == 1 ? formattedBitmap.width : (backgroundXRepeat - 1 == x ? (elementEffectiveWidth - (formattedBitmap.width * (backgroundXRepeat - 1))) : formattedBitmap.width));
					var sectionHeight:int = (backgroundYRepeat == 1 ? formattedBitmap.height : (backgroundYRepeat - 1 == x ? (elementEffectiveHeight - (formattedBitmap.height * (backgroundYRepeat - 1))) : formattedBitmap.height));
					
					var sectionX:int = (positionX + elementContentX + (formattedBitmap.width * x));
					var sectionY:int = (positionY + elementContentY + (formattedBitmap.height * y));
					
					//if (backgroundPosition != null && backgroundPosition.position == PositionValue.
					
					for (var h:int = sectionHeight; h >= 0; h--)
					{
						for (var w:int = sectionWidth; w >= 0; w--)
						{
							fillBitmapData.setPixel32(w + sectionX, h + sectionY, formattedBitmap.getPixel32(w, h));
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
			StyleKit.logger.error("IOError when attempting to load background image from "+this._url, this);
		}
		
		protected function createMatrixFor(uiElement:UIElement, bitmap:BitmapData):Rectangle
		{
			// this is where we do the logic for the fitting to a canvas and the like ...
			// think of it like a zombie stretching your brains to fit the region
			var ratio:Number = (bitmap.width / bitmap.height);
			var aspectRatio:Number = (uiElement.effectiveContentWidth / uiElement.effectiveContentHeight);
			var matrix:Rectangle = new Rectangle();
			
			if (aspectRatio < ratio)
			{
				matrix.width = uiElement.effectiveContentWidth;
				matrix.height = Math.floor((uiElement.effectiveContentWidth / bitmap.width) * bitmap.height);
				matrix.x = 0;
				matrix.y = ((uiElement.effectiveContentHeight - matrix.height) / 2);
			}
			else
			{
				matrix.height = uiElement.effectiveContentHeight;
				matrix.width = Math.floor((uiElement.effectiveContentHeight / bitmap.height) * bitmap.width);
				matrix.y = 0;
				matrix.x = ((uiElement.effectiveContentWidth - matrix.width) / 2);
			}
			
			return matrix;
		}
	}
}
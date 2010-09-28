package org.stylekit.ui.element.paint
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.CornerCompoundValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.NumericValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.ui.element.UIElement;
	import org.utilkit.crypto.Base64;
	import org.utilkit.logger.Logger;
	import org.utilkit.parser.DataURIParser;
	import org.utilkit.parser.URLParser;
	
	public class UIElementPainter
	{
		protected var _backgroundLoader:Loader;
		protected var _backgroundBytes:ByteArray;
		protected var _backgroundBitmapData:BitmapData;
		
		protected var _uiElement:UIElement;
		
		public function UIElementPainter(uiElement:UIElement)
		{
			this._uiElement = uiElement;
		}
		
		public function get uiElement():UIElement
		{
			return this._uiElement;
		}
		
		public function paint():void
		{
			var uiElement:UIElement = this._uiElement;
			var graphics:Graphics = uiElement.graphics;
			
			// one monster method, alot of variables here because we have to retreive everything
			// we skip some null checks because most properties should be set by default
			// 
			
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			var backgroundImage:URLValue = (uiElement.getStyleValue("background-image") as URLValue);

			var marginTop:Number = (uiElement.getStyleValue("margin-top") as SizeValue).evaluateSize();
			var marginRight:Number = (uiElement.getStyleValue("margin-right") as SizeValue).evaluateSize();
			var marginLeft:Number = (uiElement.getStyleValue("margin-left") as SizeValue).evaluateSize();
			var marginBottom:Number = (uiElement.getStyleValue("margin-bottom") as SizeValue).evaluateSize();
			
			var borderCompound:EdgeCompoundValue = (uiElement.getStyleValue("border") as EdgeCompoundValue);
			var radiusCompound:CornerCompoundValue = (uiElement.getStyleValue("border-radius") as CornerCompoundValue);
			
			var borderTop:BorderCompoundValue = (borderCompound.topValue as BorderCompoundValue);
			var borderLeft:BorderCompoundValue = (borderCompound.leftValue as BorderCompoundValue);
			var borderRight:BorderCompoundValue = (borderCompound.rightValue as BorderCompoundValue);
			var borderBottom:BorderCompoundValue = (borderCompound.bottomValue as BorderCompoundValue);
			
			var borderTopColor:uint = (borderTop.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderTop.colorValue.hexValue);
			var borderLeftColor:uint = (borderLeft.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderLeft.colorValue.hexValue);
			var borderRightColor:uint = (borderRight.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderRight.colorValue.hexValue);
			var borderBottomColor:uint = (borderBottom.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderBottom.colorValue.hexValue);
			
			var borderTopSize:int = (borderTop.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderTop.sizeValue.evaluateSize(uiElement));
			var borderLeftSize:int = (borderLeft.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderLeft.sizeValue.evaluateSize(uiElement));
			var borderRightSize:int = (borderRight.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderRight.sizeValue.evaluateSize(uiElement));
			var borderBottomSize:int = (borderBottom.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderBottom.sizeValue.evaluateSize(uiElement));

			var topRightRadius:SizeValue = (radiusCompound.topRightValue as SizeValue);
			var bottomRightRadius:SizeValue = (radiusCompound.bottomRightValue as SizeValue);
			var bottomLeftRadius:SizeValue = (radiusCompound.bottomLeftValue as SizeValue);
			var topLeftRadius:SizeValue = (radiusCompound.topLeftValue as SizeValue);
			
			var topRightR:Number = (borderTop.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE && borderRight.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE ? topRightRadius.evaluateSize(uiElement) : 0);
			var bottomRightR:Number = (borderBottom.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE && borderRight.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE ? bottomRightRadius.evaluateSize(uiElement) : 0);
			var bottomLeftR:Number = (borderBottom.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE && borderLeft.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE ? bottomLeftRadius.evaluateSize(uiElement) : 0);
			var topLeftR:Number = (borderTop.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE && borderLeft.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE ? topLeftRadius.evaluateSize(uiElement) : 0);
		
			var alpha:Number = uiElement.hasStyleProperty("opacity") ? (uiElement.getStyleValue("opacity") as NumericValue).value : 1.0;
			
			uiElement.alpha = alpha;
			
			graphics.clear();
			
			graphics.moveTo(marginLeft + topLeftR / 2, marginTop);
		
			graphics.beginFill(backgroundColor);
			
			if (backgroundImage != null)
			{
				if (this._backgroundLoader == null)
				{
					this._backgroundLoader = new Loader();
					
					this._backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onBackgroundLoaderComplete);
				
					if (backgroundImage.url.indexOf("data:") == 0)
					{
						var dataURI:DataURIParser = new DataURIParser(backgroundImage.url);
				
						this._backgroundLoader.loadBytes(Base64.decodeToByteArray(dataURI.data));
					}
					else
					{
						var uriParser:URLParser = new URLParser(backgroundImage.url);
						
						this._backgroundLoader.load(new URLRequest(uriParser.url));
					}
				}
				else
				{
					if (this._backgroundBitmapData != null)
					{
						graphics.beginBitmapFill(this._backgroundBitmapData, null, false, true);
					}
				}
			}

			graphics.lineStyle(0, 0);
			
			trace("Painting ...", uiElement);
			
			if (borderTop != null)
			{
				graphics.lineStyle(borderTopSize, borderTopColor, 1);

				graphics.lineTo(marginLeft + uiElement.effectiveWidth - (topRightR / 2) - marginRight, marginTop);
			}
			
			if (topRightR > 0)
			{
				graphics.curveTo(marginLeft + uiElement.effectiveWidth - marginRight, marginTop, marginLeft + uiElement.effectiveWidth - marginRight, marginTop + (topRightR / 2));
			}
			
			if (borderRight != null)
			{
				graphics.lineStyle(borderRightSize, borderRightColor, 1);
				
				graphics.lineTo(marginLeft + uiElement.effectiveWidth - marginRight, uiElement.effectiveHeight - (bottomRightR / 2) + marginTop - marginBottom);
			}
			
			if (bottomRightR > 0)
			{
				graphics.curveTo(marginLeft + uiElement.effectiveWidth - marginRight, marginTop + uiElement.effectiveHeight - marginBottom, marginLeft + uiElement.effectiveWidth - (bottomRightR / 2) - marginRight, marginTop + uiElement.effectiveHeight - marginBottom);
			}
			
			if (borderBottom != null)
			{
				graphics.lineStyle(borderBottomSize, borderBottomColor, 1);
				
				graphics.lineTo(marginLeft + (bottomRightR / 2), uiElement.effectiveHeight + marginTop - marginBottom);
			}
			
			if (bottomLeftR > 0)
			{
				graphics.curveTo(marginLeft, uiElement.effectiveHeight + marginTop - marginBottom, marginLeft, uiElement.effectiveHeight - (bottomLeftR / 2) + marginTop - marginBottom);
			}
			
			if (borderLeft != null)
			{ 
				graphics.lineStyle(borderLeftSize, borderLeftColor, 1);
			
				graphics.lineTo(marginLeft, (topLeftR / 2) + marginTop);
			}
			
			if (topLeftR > 0)
			{
				graphics.curveTo(marginLeft, marginTop, marginLeft + (topLeftR / 2), marginTop);
			}

			graphics.endFill();
		}
		
		protected function onBackgroundLoaderComplete(e:Event):void
		{
			trace("Background Image Loaded");
			
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			var backgroundRepeat:RepeatValue = (uiElement.getStyleValue("background-repeat") as RepeatValue);
			var backgroundPosition:PositionValue = (uiElement.getStyleValue("background-position") as PositionValue);
			
			var tempBitmapData:BitmapData = (this._backgroundLoader.content as Bitmap).bitmapData;
			var bitmapData:BitmapData = new BitmapData(this.uiElement.effectiveWidth, this.uiElement.effectiveHeight, true, backgroundColor);
			
			// need to draw the image repeated and positioned like the rules above in the bitmapData object
			var xRepeat:int = Math.ceil(backgroundRepeat.horizontalRepeat ? (bitmapData.width / tempBitmapData.width) : 1);
			var yRepeat:int = Math.ceil(backgroundRepeat.verticalRepeat ? (bitmapData.height / tempBitmapData.height) : 1);

			var bitmapBytes:ByteArray = tempBitmapData.getPixels(new Rectangle(0, 0, tempBitmapData.width, tempBitmapData.height));
			
			for (var y:int = 0; y < yRepeat; y++)
			{
				for (var x:int = 0; x < xRepeat; x++)
				{
					bitmapBytes.position = 0;
					
					var width:int = ((xRepeat - 1) == x ? bitmapData.width - (tempBitmapData.width * (xRepeat - 1)) : tempBitmapData.width);
					var height:int = ((yRepeat - 1) == y ? bitmapData.height - (tempBitmapData.height * (yRepeat - 1)) : tempBitmapData.height);
					
					var rect:Rectangle = new Rectangle((x * tempBitmapData.width), (y * tempBitmapData.height), width, height);
					
					//bitmapData.setPixels(rect, bitmapBytes);
					
					// starting position
					var startX:int = tempBitmapData.width * x;
					var startY:int = tempBitmapData.height * y;
					
					trace("Drawing from: "+startX+"/"+startY+" -> "+xRepeat+"/"+yRepeat);
					
					for (var h:int = 0; h < height; h++)
					{
						for (var w:int = 0; w < width; w++)
						{
							bitmapData.setPixel32(w + startX, h + startY, tempBitmapData.getPixel32(w, h));
						}
					}
				}
			}
			
			this._backgroundBitmapData = bitmapData;
			
			this.paint();
		}
	}
}
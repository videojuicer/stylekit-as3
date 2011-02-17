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
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	import mx.effects.easing.Back;
	
	import org.stylekit.StyleKit;
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
	import org.utilkit.crypto.MD5;
	import org.utilkit.parser.DataURIParser;
	import org.utilkit.parser.URLParser;
	
	public class UIElementPainter
	{
		protected static var __backgroundFillers:Vector.<BackgroundFiller> = new Vector.<BackgroundFiller>();
		
		protected var _currentBackgroundFiller:BackgroundFiller;
		
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

			var backgroundAlpha:Number = (uiElement.getStyleValue("background-color") as ColorValue).alphaValue;
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			var backgroundImage:URLValue = (uiElement.getStyleValue("background-image") as URLValue);

			var marginTop:Number = (uiElement.getStyleValue("margin-top") as SizeValue).evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT);
			var marginLeft:Number = (uiElement.getStyleValue("margin-left") as SizeValue).evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH);
			var marginRight:Number = (uiElement.getStyleValue("margin-right") as SizeValue).evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH);
			var marginBottom:Number = (uiElement.getStyleValue("margin-bottom") as SizeValue).evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT);
			
			if (isNaN(marginTop)) marginTop = 0;
			if (isNaN(marginLeft)) marginLeft = 0;
			if (isNaN(marginRight)) marginRight = 0;
			if (isNaN(marginBottom)) marginBottom = 0;
			
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
			
			var borderTopSize:int = (borderTop.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderTop.sizeValue.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT));
			var borderLeftSize:int = (borderLeft.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderLeft.sizeValue.evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH));
			var borderRightSize:int = (borderRight.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderRight.sizeValue.evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH));
			var borderBottomSize:int = (borderBottom.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderBottom.sizeValue.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT));

			var borderTopAlpha:Number = (borderTop.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderTop.colorValue.alphaValue);
			var borderLeftAlpha:Number = (borderLeft.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderLeft.colorValue.alphaValue);
			var borderRightAlpha:Number = (borderRight.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderRight.colorValue.alphaValue);
			var borderBottomAlpha:Number = (borderBottom.lineStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderBottom.colorValue.alphaValue);
			
			var topRightRadius:SizeValue = (radiusCompound.topRightValue as SizeValue);
			var bottomRightRadius:SizeValue = (radiusCompound.bottomRightValue as SizeValue);
			var bottomLeftRadius:SizeValue = (radiusCompound.bottomLeftValue as SizeValue);
			var topLeftRadius:SizeValue = (radiusCompound.topLeftValue as SizeValue);

			var topRightR:Number = Math.max(0, topRightRadius.evaluateSize(uiElement));
			var bottomRightR:Number = Math.max(0, bottomRightRadius.evaluateSize(uiElement));
			var bottomLeftR:Number = Math.max(0, bottomLeftRadius.evaluateSize(uiElement));
			var topLeftR:Number = Math.max(0, topLeftRadius.evaluateSize(uiElement));
		
			var alpha:Number = uiElement.hasStyleProperty("opacity") ? (uiElement.getStyleValue("opacity") as NumericValue).value : 1.0;
	
			uiElement.alpha = alpha;
			
			graphics.clear();
			
			graphics.moveTo(marginLeft + topLeftR, marginTop);
		
			if (uiElement.getStyleValue("background-color").rawValue == "transparent")
			{
				backgroundAlpha = 0;
			}

			graphics.beginFill(backgroundColor, backgroundAlpha);
			
			if (backgroundImage != null)
			{
				var backgroundSignature:String = backgroundImage.url; // MD5.encrypt(
				var filler:BackgroundFiller = UIElementPainter.findBackgroundFillerBySignature(backgroundSignature);
				
				if (filler == null)
				{
					if (this._currentBackgroundFiller != null)
					{
						this._currentBackgroundFiller.removeEventListener(Event.COMPLETE, this.onBackgroundFillerComplete);
					}
					
					filler = new BackgroundFiller();
					filler.addEventListener(Event.COMPLETE, this.onBackgroundFillerComplete);
					filler.load(backgroundImage);
					
					UIElementPainter.__backgroundFillers.push(filler);
					this._currentBackgroundFiller = filler;
				}
				
				if (filler.loaderComplete)
				{
					if (filler.hasEventListener(Event.COMPLETE))
					{
						filler.removeEventListener(Event.COMPLETE, this.onBackgroundFillerComplete);
					}
					
					var backgroundBitmapData:BitmapData = filler.createBitmapFillForElement(uiElement);
					
					graphics.beginBitmapFill(backgroundBitmapData, null, false, true);
				}
				else
				{
					filler.addEventListener(Event.COMPLETE, this.onBackgroundFillerComplete);
				}
			}

			graphics.lineStyle(0, 0);
			
			StyleKit.logger.debug("Painting ...", uiElement);
			
			if (borderTop != null)
			{
				graphics.lineStyle(borderTopSize, borderTopColor, borderTopAlpha);

				graphics.lineTo(uiElement.effectiveWidth - (topRightR) - marginRight, marginTop);
			}
			else
			{
				graphics.moveTo(uiElement.effectiveWidth - (topRightR) - marginRight, marginTop);
			}
			
			if (topRightR > 0)
			{
				graphics.curveTo(uiElement.effectiveWidth - marginRight, marginTop, uiElement.effectiveWidth - marginRight, marginTop + (topRightR));
			}
			
			if (borderRight != null)
			{
				graphics.lineStyle(borderRightSize, borderRightColor, borderRightAlpha);
				
				graphics.lineTo(uiElement.effectiveWidth - marginRight, uiElement.effectiveHeight - (bottomRightR) - marginBottom);
			}
			else
			{
				graphics.moveTo(uiElement.effectiveWidth - marginRight, uiElement.effectiveHeight - (bottomRightR) - marginBottom);
			}
			
			if (bottomRightR > 0)
			{
				graphics.curveTo(uiElement.effectiveWidth - marginRight, uiElement.effectiveHeight - marginBottom, uiElement.effectiveWidth - (bottomRightR) - marginRight, uiElement.effectiveHeight - marginBottom);
			}
			
			if (borderBottom != null)
			{
				graphics.lineStyle(borderBottomSize, borderBottomColor, borderBottomAlpha);
				
				graphics.lineTo(marginLeft + (bottomRightR), uiElement.effectiveHeight - marginBottom);
			}
			else
			{
				graphics.moveTo(marginLeft + (bottomRightR), uiElement.effectiveHeight - marginBottom);
			}
			
			if (bottomLeftR > 0)
			{
				graphics.curveTo(marginLeft, uiElement.effectiveHeight - marginBottom, marginLeft, uiElement.effectiveHeight - (bottomLeftR) - marginBottom);
			}
			
			if (borderLeft != null)
			{ 
				graphics.lineStyle(borderLeftSize, borderLeftColor, borderLeftAlpha);
			
				graphics.lineTo(marginLeft, (topLeftR) + marginTop);
			}
			else
			{
				graphics.moveTo(marginLeft, (topLeftR) + marginTop);
			}
			
			if (topLeftR > 0)
			{
				graphics.curveTo(marginLeft, marginTop, marginLeft + (topLeftR), marginTop);
			}

			graphics.endFill();
		}
		
		protected static function findBackgroundFillerBySignature(signature:String):BackgroundFiller
		{
			if (UIElementPainter.__backgroundFillers != null && UIElementPainter.__backgroundFillers.length > 0)
			{
				for (var i:int = 0; i < UIElementPainter.__backgroundFillers.length; i++)
				{
					var filler:BackgroundFiller = UIElementPainter.__backgroundFillers[i];
					
					if (filler.signature == signature)
					{
						return filler;
					}
				}
			}
			
			return null;
		}
		
		protected function onBackgroundFillerComplete(e:Event):void
		{
			this.paint();
		}
	}
}
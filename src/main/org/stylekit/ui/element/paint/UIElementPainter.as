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
	import org.stylekit.events.Benchmarks;
	import org.stylekit.ui.element.UIElement;
	import org.utilkit.crypto.Base64;
	import org.utilkit.crypto.MD5;
	import org.utilkit.logger.Benchmark;
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
			//Benchmark.begin(Benchmarks.ORIGIN_PAINTER, Benchmarks.ACTION_DRAW);
			
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
			
			var borderTopColorValue:ColorValue = (uiElement.getStyleValue("border-top-color") as ColorValue);
			var borderLeftColorValue:ColorValue = (uiElement.getStyleValue("border-left-color") as ColorValue);
			var borderRightColorValue:ColorValue = (uiElement.getStyleValue("border-right-color") as ColorValue);
			var borderBottomColorValue:ColorValue = (uiElement.getStyleValue("border-bottom-color") as ColorValue);
			
			var borderTopStyleValue:LineStyleValue = (uiElement.getStyleValue("border-top-style") as LineStyleValue);
			var borderLeftStyleValue:LineStyleValue = (uiElement.getStyleValue("border-left-style") as LineStyleValue);
			var borderRightStyleValue:LineStyleValue = (uiElement.getStyleValue("border-right-style") as LineStyleValue);
			var borderBottomStyleValue:LineStyleValue = (uiElement.getStyleValue("border-bottom-style") as LineStyleValue);
			
			var borderTopWidthValue:SizeValue = (uiElement.getStyleValue("border-top-width") as SizeValue);
			var borderLeftWidthValue:SizeValue = (uiElement.getStyleValue("border-left-width") as SizeValue);
			var borderRightWidthValue:SizeValue = (uiElement.getStyleValue("border-right-width") as SizeValue);
			var borderBottomWidthValue:SizeValue = (uiElement.getStyleValue("border-bottom-width") as SizeValue);
			
			var topRightRadius:SizeValue = (uiElement.getStyleValue("border-top-right-radius") as SizeValue);
			var bottomRightRadius:SizeValue = (uiElement.getStyleValue("border-bottom-right-radius") as SizeValue);
			var bottomLeftRadius:SizeValue = (uiElement.getStyleValue("border-bottom-left-radius") as SizeValue);
			var topLeftRadius:SizeValue = (uiElement.getStyleValue("border-top-left-radius") as SizeValue);
			
			var borderTopColor:uint = (borderTopColorValue == null || borderTopStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderTopColorValue.hexValue);
			var borderLeftColor:uint = (borderLeftColorValue == null || borderLeftStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderLeftColorValue.hexValue);
			var borderRightColor:uint = (borderRightColorValue == null || borderRightStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderRightColorValue.hexValue);
			var borderBottomColor:uint = (borderBottomColorValue == null || borderBottomStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? backgroundColor : borderBottomColorValue.hexValue);
			
			var borderTopSize:int = (borderTopWidthValue == null || borderTopStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderTopWidthValue.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT));
			var borderLeftSize:int = (borderLeftWidthValue == null || borderLeftStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderLeftWidthValue.evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH));
			var borderRightSize:int = (borderRightWidthValue == null || borderRightStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderRightWidthValue.evaluateSize(uiElement, SizeValue.DIMENSION_WIDTH));
			var borderBottomSize:int = (borderBottomWidthValue == null || borderBottomStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0 : borderBottomWidthValue.evaluateSize(uiElement, SizeValue.DIMENSION_HEIGHT));

			var borderTopAlpha:Number = (borderTopColorValue == null || borderTopStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderTopColorValue.alphaValue);
			var borderLeftAlpha:Number = (borderLeftColorValue == null || borderLeftStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderLeftColorValue.alphaValue);
			var borderRightAlpha:Number = (borderRightColorValue == null || borderRightStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderRightColorValue.alphaValue);
			var borderBottomAlpha:Number = (borderBottomColorValue == null || borderBottomStyleValue.lineStyle == LineStyleValue.LINE_STYLE_NONE ? 0.0 : borderBottomColorValue.alphaValue);
			
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
			
			//StyleKit.logger.debug("Painting ...", uiElement);
			
			if (borderTopStyleValue != null)
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
			
			if (borderRightStyleValue != null)
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
			
			if (borderBottomStyleValue != null)
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
			
			if (borderLeftStyleValue != null)
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
			
			//Benchmark.finish(Benchmarks.ORIGIN_PAINTER, Benchmarks.ACTION_DRAW);
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
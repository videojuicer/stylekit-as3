package org.stylekit.ui.element.paint
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.CornerCompoundValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.ui.element.UIElement;
	import org.utilkit.logger.Logger;
	
	public class UIElementPainter
	{
		public static function paint(uiElement:UIElement):void
		{
			var graphics:Graphics = uiElement.graphics;
			
			// one monster method, alot of variables here because we have to retreive everything
			// we skip some null checks because most properties should be set by default
			// 
			
			var backgroundColor:uint = (uiElement.getStyleValue("background-color") as ColorValue).hexValue;
			
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
			
			graphics.moveTo(marginLeft + topLeftR / 2, marginTop);
			
			graphics.beginFill(backgroundColor);
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
	}
}
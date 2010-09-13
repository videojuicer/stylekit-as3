package org.stylekit.ui.element.paint
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.stylekit.css.value.BorderCompoundValue;
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
			
			//graphics.beginFill(0xEEEEEE, 0.8);
			
			//var marginTop:Number = (uiElement.getStyleValue("margin-top") as SizeValue).evaluateSize();
			//var marginRight:Number = (uiElement.getStyleValue("margin-right") as SizeValue).evaluateSize();
			//var marginLeft:Number = (uiElement.getStyleValue("margin-left") as SizeValue).evaluateSize();
			//var marginBottom:Number = (uiElement.getStyleValue("margin-bottom") as SizeValue).evaluateSize();
			
			var borderCompound:EdgeCompoundValue = (uiElement.getStyleValue("border") as EdgeCompoundValue);
			var radiusCompound:CornerCompoundValue = (uiElement.getStyleValue("border-radius") as CornerCompoundValue);
			
			var borderTop:BorderCompoundValue = (borderCompound.topValue as BorderCompoundValue);
			var borderLeft:BorderCompoundValue = (borderCompound.leftValue as BorderCompoundValue);
			var borderRight:BorderCompoundValue = (borderCompound.rightValue as BorderCompoundValue);
			var borderBottom:BorderCompoundValue = (borderCompound.bottomValue as BorderCompoundValue);
			
			var topRightRadius:SizeValue = (radiusCompound.topRightValue as SizeValue);
			var bottomRightRadius:SizeValue = (radiusCompound.bottomRightValue as SizeValue);
			var bottomLeftRadius:SizeValue = (radiusCompound.bottomLeftValue as SizeValue);
			var topLeftRadius:SizeValue = (radiusCompound.topLeftValue as SizeValue);
			
			trace("Painting ...", uiElement);
			
			if (borderTop != null && borderTop.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				graphics.lineStyle(borderTop.sizeValue.evaluateSize(), borderTop.colorValue.hexValue, 1);

				graphics.moveTo(topLeftRadius.evaluateSize() / 2, 0);
				graphics.lineTo(uiElement.effectiveContentWidth - (topLeftRadius.evaluateSize() / 2), 0);
			}
			
			if (borderLeft != null && borderLeft.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{ 
				graphics.lineStyle(borderLeft.sizeValue.evaluateSize(), borderLeft.colorValue.hexValue, 1);
				
				graphics.moveTo(0, topLeftRadius.evaluateSize() / 2);
				graphics.lineTo(0, uiElement.effectiveContentHeight - (bottomLeftRadius.evaluateSize() / 2));
			}
			
			if (topRightRadius != null && topRightRadius.evaluateSize() > 0)
			{
				trace("Move: "+(uiElement.effectiveContentWidth - (topRightRadius.evaluateSize() / 2))+"/0", uiElement);
				trace("Curve: "+uiElement.effectiveContentWidth+"/0 "+uiElement.effectiveContentWidth+"/"+(topRightRadius.evaluateSize() / 2));
				
				graphics.moveTo((uiElement.effectiveContentWidth - (topRightRadius.evaluateSize() / 2)), 0);
				graphics.curveTo(uiElement.effectiveContentWidth, 0, uiElement.effectiveContentWidth, (topRightRadius.evaluateSize() / 2));
			}
			
			if (topLeftRadius != null && topLeftRadius.evaluateSize() > 0)
			{
				trace("Move: "+(uiElement.effectiveContentWidth - (topLeftRadius.evaluateSize() / 2))+"/0", uiElement);
				trace("Curve: "+uiElement.effectiveContentWidth+"/0 "+uiElement.effectiveContentWidth+"/"+(topLeftRadius.evaluateSize() / 2));
				
				graphics.moveTo((topLeftRadius.evaluateSize() / 2), 0);
				graphics.curveTo(0, 0, 0, (topLeftRadius.evaluateSize() / 2));
			}
			
			if (borderRight != null && borderRight.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				graphics.lineStyle(borderRight.sizeValue.evaluateSize(), borderRight.colorValue.hexValue, 1);
				
				graphics.moveTo(uiElement.effectiveContentWidth, topLeftRadius.evaluateSize() / 2);
				graphics.lineTo(uiElement.effectiveContentWidth, uiElement.effectiveContentHeight - (bottomRightRadius.evaluateSize() / 2));
			}
			
			if (borderBottom != null && borderBottom.lineStyleValue.lineStyle != LineStyleValue.LINE_STYLE_NONE)
			{
				graphics.lineStyle(borderBottom.sizeValue.evaluateSize(), borderBottom.colorValue.hexValue, 1);
				
				graphics.moveTo((bottomLeftRadius.evaluateSize() / 2), uiElement.effectiveContentHeight);
				graphics.lineTo(uiElement.effectiveContentWidth - (bottomRightRadius.evaluateSize() / 2), uiElement.effectiveContentHeight);
			}
			
			if (bottomRightRadius != null && bottomRightRadius.evaluateSize() > 0)
			{
				trace("Move: "+(uiElement.effectiveContentWidth - (bottomRightRadius.evaluateSize() / 2))+"/0", uiElement);
				trace("Curve: "+uiElement.effectiveContentWidth+"/0 "+uiElement.effectiveContentWidth+"/"+(bottomRightRadius.evaluateSize() / 2));
				
				graphics.moveTo(uiElement.effectiveContentWidth, uiElement.effectiveContentHeight - (bottomRightRadius.evaluateSize() / 2));
				graphics.curveTo(uiElement.effectiveContentWidth, uiElement.effectiveContentHeight, uiElement.effectiveContentWidth - (bottomRightRadius.evaluateSize() / 2), uiElement.effectiveContentHeight);
			}
			
			if (bottomLeftRadius != null && bottomLeftRadius.evaluateSize() > 0)
			{
				trace("Move: "+(uiElement.effectiveContentWidth - (bottomLeftRadius.evaluateSize() / 2))+"/0", uiElement);
				trace("Curve: "+uiElement.effectiveContentWidth+"/0 "+uiElement.effectiveContentWidth+"/"+(bottomLeftRadius.evaluateSize() / 2));
				
				graphics.moveTo(0, uiElement.effectiveContentHeight - (bottomLeftRadius.evaluateSize() / 2));
				graphics.curveTo(0, uiElement.effectiveContentHeight, (bottomLeftRadius.evaluateSize() / 2), uiElement.effectiveContentHeight);
			}
			
			graphics.lineStyle(0, 0);
			
			//graphics.endFill();
		}
	}
}
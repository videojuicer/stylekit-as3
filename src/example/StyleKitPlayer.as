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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.osmf.utils.URL;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.FloatValue;
	import org.stylekit.css.value.LineStyleValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.ui.BaseUI;
	import org.stylekit.ui.element.UIElement;
	
	/**
	 * StyleKit-as3 Demo Application
	 * 
	 * - Create AS3 Project in Flex Builder
	 * - Copy contents of File into the main Actionscript file
	 * - Link Project to StyleKit-as3
	 */
	public class StyleKitPlayer extends Sprite
	{
		protected var _parent:UIElement;
		protected var _element:UIElement;
		protected var _image:UIElement;
		protected var _image2:UIElement;
		
		protected var _baseUI:BaseUI;
		
		protected var _toolbar:UIElement;
		protected var _toolbar2:UIElement;
		protected var _toolbar3:UIElement;
		protected var _buttons:Vector.<UIElement>;
		protected var _button:UIElement;
		
		protected var _textField:TextField;
		
		protected function onStageResize(e:Event):void
		{
			
			trace("StyleKitPlayer - Application Size: "+this.width+"/"+this.height+" Stage Size: "+this.stage.stageWidth+"/"+this.stage.stageHeight);	
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x000000, 0.1);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
			
			trace("StyleKitPlayer - Application Size: "+this.width+"/"+this.height+" Stage Size: "+this.stage.stageWidth+"/"+this.stage.stageHeight);	
		}
		
		protected function onTextInput(e:TextEvent):void
		{
			var char:String = e.text.substr(e.text.length - 1, 1);
			
			trace("CHAR --> "+char);
		}
		
		protected function onMouseClick(e:Event):void
		{
			trace("CLICK CLICK");
			
			var parser:StyleSheetParser = new StyleSheetParser();
			var styleSheet:StyleSheet = parser.parse(this._textField.text);

			if (this._baseUI.styleSheetCollection.length > 0)
			{
				this._baseUI.styleSheetCollection.removeStyleSheet(this._baseUI.styleSheetCollection.styleSheets[0]);
			}
			
			this._baseUI.styleSheetCollection.addStyleSheet(styleSheet);
			
			this._baseUI.layoutChildren();
		}
		
		public function StyleKitPlayer()
		{
			this.setupImages();
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.graphics.clear();
			
			// draw a box to give our app some form of shape
			this.graphics.beginFill(0xFFFFFF, 0.1);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
			
			this.stage.addEventListener(Event.RESIZE, this.onStageResize, false, 100);
			
			this._baseUI = new BaseUI(new StyleSheetCollection(), this.stage);
			
			this.addChild(this._baseUI);
			
			this._baseUI.evaluatedStyles = {
				"width": SizeValue.parse("100%"),
				"height": SizeValue.parse("80%"),
				"background-color": ColorValue.parse("transparent"),
				"padding-top": SizeValue.parse("0px")
			};

			this._toolbar = this._baseUI.createUIElement();
			this._toolbar.elementId = "toolbar1";
			this._toolbar.name = "toolbar";
			
			this._baseUI.addElement(this._toolbar);
			
			this._toolbar.evaluatedStyles = {
				"display": DisplayValue.parse("inline"),
				"width": SizeValue.parse("200px"),
				"height": SizeValue.parse("40px"),
				
				"margin-bottom": SizeValue.parse("5px"),
				
				"background-color": ColorValue.parse("red")
			};
			
			this._toolbar2 = this._baseUI.createUIElement();
			this._toolbar2.elementId = "toolbar2";
			this._toolbar2.name = "toolbar";
			
			this._baseUI.addElement(this._toolbar2);
			
			this._toolbar2.evaluatedStyles = {
				"display": DisplayValue.parse("inline"),
				"width": SizeValue.parse("200px"),
				"height": SizeValue.parse("40px"),
				"float": FloatValue.parse("right"),
					
				"margin-bottom": SizeValue.parse("5px"),
				
				"background-color": ColorValue.parse("yellow")
			};
			
			this._toolbar3 = this._baseUI.createUIElement();
			this._toolbar3.elementId = "toolbar3";
			this._toolbar3.name = "toolbar";
			
			this._baseUI.addElement(this._toolbar3);
			
			this._toolbar3.evaluatedStyles = {
				"display": DisplayValue.parse("block"),
				"width": SizeValue.parse("100%"),
				"height": SizeValue.parse("40px"),
				"background-color": ColorValue.parse("green")
			};
			
			/*
			this._button = new UIElement(this._baseUI);
			
			this._button = this._baseUI.createUIElement();
			this._button.elementId = "go-button";
			this._button.name = "button";
			
			this._baseUI.addElement(this._button);
			
			this._button.evaluatedStyles = {
				"display": DisplayValue.parse("block"),
				"width": SizeValue.parse("40px"),
				"height": SizeValue.parse("40px"),
				"background-color": ColorValue.parse("pink"),
				"float": FloatValue.parse("right")
			};
			
			this._button.addEventListener(MouseEvent.CLICK, this.onMouseClick);
			*/
			
			trace("Redraw ...");
			
			this._baseUI.layoutChildren();
			
			/*this._textField = new TextField();
			this._textField.width = this.stage.stageWidth;
			this._textField.height = 100;
			this._textField.text = "--!> CSS GOES HERE <!--";
			this._textField.y = this.stage.stageHeight - 100;
			this._textField.x = 0;
			this._textField.type = TextFieldType.INPUT;
			this._textField.border = true;
			this._textField.borderColor = 0x333333;
			this._textField.backgroundColor = 0x888888;
			this._textField.textColor = 0xEEEEEE;
			this._textField.multiline = true;
			
			this._textField.addEventListener(TextEvent.TEXT_INPUT, this.onTextInput);
			
			this.addChild(this._textField);
			*/
			
			/*
			this._parent = new UIElement();
			this._parent.evaluatedStyles = {
				"width": SizeValue.parse("820px"),
					"height": SizeValue.parse("580px"),
					
					"margin-top": SizeValue.parse("10px"),
					"margin-right": SizeValue.parse("10px"),
					"margin-left": SizeValue.parse("10px"),
					"margin-bottom": SizeValue.parse("10px"),
					
					"padding-top": SizeValue.parse("5px"),
					"padding-right": SizeValue.parse("5px"),
					"padding-left": SizeValue.parse("5px"),
					"padding-bottom": SizeValue.parse("5px"),
					
					"background-color": ColorValue.parse("#990000"),
					"background-image": URLValue.parse("url(data:image/png,"+StyleKitPlayer.__backgroundImage+")"),
					"background-repeat": RepeatValue.parse("repeat"),
					
					"border-left-color": ColorValue.parse("#000000"),
					"border-left-width": SizeValue.parse("1px"),
					"border-left-style": LineStyleValue.parse("solid"),
					
					"border-right-color": ColorValue.parse("#000000"),
					"border-right-width": SizeValue.parse("1px"),
					"border-right-style": LineStyleValue.parse("solid"),
					
					"border-top-color": ColorValue.parse("#000000"),
					"border-top-width": SizeValue.parse("1px"),
					"border-top-style": LineStyleValue.parse("solid"),
					
					"border-bottom-color": ColorValue.parse("#000000"),
					"border-bottom-width": SizeValue.parse("1px"),
					"border-bottom-style": LineStyleValue.parse("solid"),
					
					"border-top-right-radius": SizeValue.parse("0"),
					"border-bottom-right-radius": SizeValue.parse("0"),
					"border-bottom-left-radius": SizeValue.parse("0"),
					"border-top-left-radius": SizeValue.parse("0")
			};
			
			this._image = new UIElement();
			
			this._parent.addElement(this._image);
			
			this._image.evaluatedStyles = {
				"width": SizeValue.parse("250px"),
					"height": SizeValue.parse("450px"),
					
					"position": PositionValue.parse("absolute"),
					"bottom": SizeValue.parse("0px"),
					"right": SizeValue.parse("0px"),
					
					"margin-top": SizeValue.parse("0px"),
					"margin-right": SizeValue.parse("0px"),
					"margin-left": SizeValue.parse("0px"),
					"margin-bottom": SizeValue.parse("0px"),
					
					"padding-top": SizeValue.parse("0px"),
					"padding-right": SizeValue.parse("0px"),
					"padding-left": SizeValue.parse("0px"),
					"padding-bottom": SizeValue.parse("0px"),
					
					"background-color": ColorValue.parse("#00FF00"),
					
					"border-left-color": ColorValue.parse("#000000"),
					"border-left-width": SizeValue.parse("2px"),
					"border-left-style": LineStyleValue.parse("solid"),
					
					"border-right-color": ColorValue.parse("#000000"),
					"border-right-width": SizeValue.parse("2px"),
					"border-right-style": LineStyleValue.parse("solid"),
					
					"border-top-color": ColorValue.parse("#000000"),
					"border-top-width": SizeValue.parse("2px"),
					"border-top-style": LineStyleValue.parse("solid"),
					
					"border-bottom-color": ColorValue.parse("#000000"),
					"border-bottom-width": SizeValue.parse("2px"),
					"border-bottom-style": LineStyleValue.parse("solid"),
					
					"border-top-right-radius": SizeValue.parse("25px"),
					"border-bottom-right-radius": SizeValue.parse("25px"),
					"border-bottom-left-radius": SizeValue.parse("25px"),
					"border-top-left-radius": SizeValue.parse("25px")
			};
			
			this._element = new UIElement();
			
			this._parent.addElement(this._element);
			
			this._element.evaluatedStyles = {
				"width": SizeValue.parse("200px"),
					"height": SizeValue.parse("300px"),
					
					"float": FloatValue.parse("right"),
					
					"margin-top": SizeValue.parse("0px"),
					"margin-right": SizeValue.parse("0px"),
					"margin-left": SizeValue.parse("0px"),
					"margin-bottom": SizeValue.parse("0px"),
					
					"padding-top": SizeValue.parse("5px"),
					"padding-right": SizeValue.parse("5px"),
					"padding-left": SizeValue.parse("5px"),
					"padding-bottom": SizeValue.parse("5px"),
					
					"background-color": ColorValue.parse("#EEEEEE"),
					
					"border-left-color": ColorValue.parse("#000000"),
					"border-left-width": SizeValue.parse("2px"),
					"border-left-style": LineStyleValue.parse("solid"),
					
					"border-right-color": ColorValue.parse("#000000"),
					"border-right-width": SizeValue.parse("2px"),
					"border-right-style": LineStyleValue.parse("solid"),
					
					"border-top-color": ColorValue.parse("#000000"),
					"border-top-width": SizeValue.parse("2px"),
					"border-top-style": LineStyleValue.parse("solid"),
					
					"border-bottom-color": ColorValue.parse("#000000"),
					"border-bottom-width": SizeValue.parse("2px"),
					"border-bottom-style": LineStyleValue.parse("solid"),
					
					"border-top-right-radius": SizeValue.parse("25px"),
					"border-bottom-right-radius": SizeValue.parse("25px"),
					"border-bottom-left-radius": SizeValue.parse("25px"),
					"border-top-left-radius": SizeValue.parse("25px")
			};
			
			this.addChild(this._parent);
			
			this._parent.redraw();
			this._element.redraw();
			*/
		}
		
		private static var __backgroundImage:String;
		private static var __redDot:String;
		
		private function setupImages():void
		{
			var dotData64:String = "";
			
			dotData64 += "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAABGdBTUEAALGP";
			dotData64 += "C/xhBQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9YGARc5KB0XV+IA";
			dotData64 += "AAAddEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIFRoZSBHSU1Q72QlbgAAAF1J";
			dotData64 += "REFUGNO9zL0NglAAxPEfdLTs4BZM4DIO4C7OwQg2JoQ9LE1exdlYvBBeZ7jq";
			dotData64 += "ch9//q1uH4TLzw4d6+ErXMMcXuHWxId3KOETnnXXV6MJpcq2MLaI97CER3N0";
			dotData64 += "vr4MkhoXe0rZigAAAABJRU5ErkJggg==";
			
			StyleKitPlayer.__redDot = dotData64;
			
			var imageData64:String = "";
			
			imageData64 += "iVBORw0KGgoAAAANSUhEUgAAAYAAAAGBCAAAAABK8DnGAAAACXBIWXMAAAxOAAAMTgF/d4wjAAAA";
			imageData64 += "BGdBTUEAALGOfPtRkwAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAdTAAAOpgAAA6mAAAF2+SX8VG";
			imageData64 += "AABWt0lEQVR42u1dZUAVWRt+Lt0lJYgCFgrYYmJgYmDt2t1rr93dunas3bV2d3c3NqWg0p333uf7";
			imageData64 += "MXMvF4VdWQE/2fv+YZgzM/fMeeac8/YLqOkHk6GHmn4UVTUBUIFq+mHkpQZADYAaAPUwqAFQA6Am";
			imageData64 += "NQBqANSkBkANgJrUAKgBUJMaADUAalIDoAZATWoA1ACoSQ2AGoDMKe3qB/X4/QgAHkQKf8P1G6vH";
			imageData64 += "L68BiLwvS7OfLP5TTfcTSdLvinoc8wqAVZgXaziLr+UkORJ3SfJTMZt49UDmBQCpcbLwuuhhOrxY";
			imageData64 += "kQSSPIblJGNqow/5ftKqJPVo5jIAG7Xsy3aRACh1WVh60ISMqoMWSbxqDawlP44NVg9p7gHg287V";
			imageData64 += "GACKrYkRTpS1SJA3x1Ap7xjpD0Bb8iH6idcmXohJv/Gmzzv1SOfIHpC8RgcAYDBFRpL1CkR2R8sU";
			imageData64 += "RhXHSZmtGxmi4SVeeRDr0m9ri4Pqkc4JAJIqQVNTogVHJ9wmyaaojIpx5HCMIlsbRDDSoLZ46QTs";
			imageData64 += "Vt4WaGTmpx7pnABA2qL+zVKFt2jb+92UkWQdwPkNeRX1SY7FS/pjgHhphQLR3HRRON6EEeqBzpkl";
			imageData64 += "SMZH+I2bB6QJ63xRuL0jk6rDdtUrLoQvn2GtcOEV9OJpWApLf1OcVg90TknCv8FXeXwPVn4kp6Fj";
			imageData64 += "QaBkCdziaewXmprgPrtB+PLDLArGkaRcph7u7wegQcVU5fFcdCT5GDX4cVwFU2A/V+IhSfI8RjLY";
			imageData64 += "2MKsjJzkCbQnSQ4apB7u7wcgNCr9uCYOkmyg+YQk0+biMIdZJJJkcsWC4dyCoWO0Q0iOxhLKNpym";
			imageData64 += "U2f1cH8/ACr0RrNIPLkdLYR/d+MMfym5vvoBcggOkK1x/wgOknFFcY3JFdFdY/XJnpHqEc85AJaj";
			imageData64 += "C5nogn3Cv2twkDWhBdvwM2hKvoYHr2MJuRoNudyhBKDhjhJqAHIQAE+cI/dDoZNeiUusgSL9sLgs";
			imageData64 += "bpHjsYYv0JXBRXCQO63NNQB0SVEPeA4CsGeZlHza/IH471rspxf2x1gAQ0g/A7c0sqbFcy+MIZk0";
			imageData64 += "SQIJLNtHqEc85wD4gm7WfcvD+8g5GJxMjsQ8kqthiDJhZHBFwORMR0geqUc81wBQisuvU8m32oUj";
			imageData64 += "Sco7wyuE5J6inVGb8gNLUlWuk6tHn7lmlH+hu4gkmfouUThxG9PUg52HAPBjcsb/40Y8Vg92XgKg";
			imageData64 += "JjUAagDUpAZADYCa1AD89ADI1RLTDwTg0/T6pSuNeft1gyyZlKVlhZlUPIjx/7IpOihURSX39vp/";
			imageData64 += "He1/AOCEJTSsdaE3Qxid6FSKAxTZssBEJRRfDdr90jdIkoHuehdIXmzV5tbzVMpXDGlUylgiKXtJ";
			imageData64 += "eeFQfKEdmlErhpRv7DV47TM1AGSIrf7s1ylv5lnaxJL80Fa3zPByq0hS3hbm6B5DvhjZtrS9i8es";
			imageData64 += "mAz3nUKNNJJ+ZYD25CwJIEH7KLrDtnr7sf31XZLTRA+6rngpPRpLJomGgkQn/RByEgCgYaAagMH4";
			imageData64 += "gyQZdInkM0eUt4MOtpAcg5qxXeH8jLMAq1JlHFD8oep9N4Gh5MsiGr9pV+FuFNhwpFk3NGNtg3ck";
			imageData64 += "WUU/ZRG2kSSbIeo81pJjrAXPoVfwJPej+E2/w6N1mv7nAXiM5un/pFXBSP7Z5Y2D6WseRdlPDOmt";
			imageData64 += "ax+6FTPSSC5H6TiVG29DE6Ov2GFPjE7t8IImD0lyGo50tkwko6ejL8dAZzNJeWmTtGv4nayHTiRJ";
			imageData64 += "X3RlTHGNGyT5/sZ/HoAROJf+zzl0I2UyHkK71FL690jyIDpuxxGS5EBsygDA3GrQMN7PF+i9EEuF";
			imageData64 += "/di8Y+8Cl1Z1LIBqYRwCc6wgUxzt+QTtyVoQHFreYhr/xGL1JiyQq424tEddWhoyGE8U63ZTLBcO";
			imageData64 += "x8ETV8VFp4vKjddwKKYUtpCbsbihrhjJ5FK/GyTQq7I8kWxn/aQ8TjDeogqfoQPZE7APIXkda1jZ";
			imageData64 += "OkoNgLDoFC0mJVMm/lLbCBjUzixWOP1QG84J4qEEuE+SfAFVp5NDOM2gfXKyC+471hbOpRTyagQs";
			imageData64 += "E+wwnkUZXMgmKlKrKe9jLDka09GO5CbsoVlXkny0+a9lY8eF/7dnQCv4k/FOMKzfAivaFVdw8gWV";
			imageData64 += "W8MeaGkIev7N+FPlxmkaQcLMsagiL1ZdOHcegz2BMgLjX6YyuR1TAtCDp7CO/A2ho3CEHIHrLNKF";
			imageData64 += "JDsCgN6r/zYAx7CEZFRADCfieJNS4tmVwG/CUbJbkVpaQSSZUkY/SOXGX8VrL2A4vTUFMa41zpVp";
			imageData64 += "sUgLw1NImVNTkh7Gq7CKy3GabFmYkQWLxrIJAtmpuJRk1NHzvTHvP74HxBctJLgxhNoZR7UzjyVJ";
			imageData64 += "6VQU1qwrtP+Bnc1MY0lySsaxKl9L+PsnNnITWqaR3IaW0iKNec8FHWVMtulJchdMcJy/w5csXZtc";
			imageData64 += "gaW0dJHxFOaQJIONWv7n5YCDaBxOMrE5ZnI9VpBJBz1QPaiu4O78F5rJS5eQkVyI+irmdkbqdxAO";
			imageData64 += "FmMek5vjV9/4UyYlP7JOoRQGV8BkJloMJZlcCrhLHxxllMFwMt6x1Fn0IzkYM0nGd8UDtSpiEgot";
			imageData64 += "ffOgEXzSGFMa5ZvZwWxeCg+i0Jm4173hGR5ta7v7yB4feGbYLR9CMMnzEiyOMHWEJrRR+BE5p66U";
			imageData64 += "9HfSfEPHbgITZR3BurjFSzhEcgKKYz9J6QB4Lu5ngd/VkjA5VQMAGsSQ9G1maeg5O4QkF0qgJ8EA";
			imageData64 += "GUcL+dc7RGe4aR+uiUfrCtQheadvzZ6vSUpTSXInbvLPAyT5qXB/cuugVD5t/5mkry7KCQGv++1g";
			imageData64 += "5HVILQeQpO/W9n3+EuOAE+MULv53xraf9Yzk+5PHly9Z9aVK8/UkZchq0tfBq9IPykCB8IQMLf1x";
			imageData64 += "VDxKfv1f8aH7vzLIJF5L5X+N1BYxNQBqANQAqAFQA5AJpT7ec/5hQEL2jLTJe68GRSRK09SG/O8H";
			imageData64 += "4AwAaFq7Nxv4WvV0ypdjm7Zqc/o/L3QAXXu3khWaz07m6z0qd6Yevz2v9a8ThTwf8hSF2T4+QQ1A";
			imageData64 += "FgAcQWUfT9eChsBmxr++fHjP0j9fMWmw3QBBLe1/QUSiL8w/K2+SHR/ZqFoRaOvBPua6IQyPkSRP";
			imageData64 += "LSTfGQA6ALwfyeY1LlekeKVu8+fOS2btdmoAsgDgADaT0sTQWzcue5oJEm+R8L6QwOsBSXbCVJLk";
			imageData64 += "EsDsc8Y7H2Fe2oNPbIjRRfWvkWRXPOB7PYer0a+3VoLhOicYOBTSB2AW9ElSRQ1AFgBsxRbxqBNa";
			imageData64 += "j56x+/rjGiZzUfzBFGiuJ9kYaB5BjoINXL4IvnuFP0k+QVNeQwUpyWE4Q3mxGiTJLSjjYhMoTQ5/";
			imageData64 += "cftRBO+joxqALABYqcg7wJb2qSQZYlHEwfQ55UfK4QZZV6cuSlzoh4ZH8GUE9kNsJzkGe8leOEVy";
			imageData64 += "AU6Srq4kySdaHja1lJcexww1AFkAsB6rxaOqpURVjTuWkeQ73RpkTd1PS/WBX9I2Y8MXd97BATLS";
			imageData64 += "ukQaeQwTSU7GadK1hJTkWVtstq6u2IK58z9lgc8eADthWNa79VlSXrwKyZDuaOhSRtCtDUQgS9km";
			imageData64 += "8FbT2VL2EXL3qdBdbCXXodyRq4/P67nGkUNxnVInzynjbngBk+KsYVGz/4TFn0muwxI1AFkAsB9a";
			imageData64 += "GsBgMtbWeNzKdjpocg1rhKZJeJdkVF68rrKYvVJ1Bhwka0Ei7Nx/kCPxiFKnxo0BFD3GYIOCbjqA";
			imageData64 += "0UOSRzBFDUAWAKzG5oDbj1PIAEMAqLaBh/FcXJOM4gLRWjhOtC/yRUAej+EeT6P9g23L1qzxxnZy";
			imageData64 += "Cl5TXqzFeQ/v7fHkVczhx2e+MSTpi6ZqALIAYCZuKVaUXrWBv8glEFw6D6ID72KkyPmXNvsyA8R2";
			imageData64 += "BLIdLpIkr2EkOQkPmWBZR2zeJPolkmRqsQJR5HCfeDUAX9EwvBEOTuIyZ2lIlnGKMAMuGBg/4z4s";
			imageData64 += "FK/rjuNf3DlVL8kf1UTBuWiRJC7AOSbaeojNi7GHJJkUHkf2xhGGmhYKVQPwFXWB6NJ2GJfJMwUw";
			imageData64 += "/SSqPAh9MU5S6Aa5WZmV7wpKfCGIrSklC7aZL/7zO27zAiaT9RopBQzz6m1q1yxnjcqpvIIOlPtH";
			imageData64 += "qJegr6m9YgZcwB6Sb9zx20RAAtQOJnlQYXgnlygng0IfESJnjILTvI8/yR2PyY/vxTOfhzkAuhb2";
			imageData64 += "PosuyMiV49V7QOZNnx+LYxi17A1JhjfvzEsDu488JiXJeyqeQJ8S/+4nbn/+6lRc4OtPCalUU/bs";
			imageData64 += "ATJVPajs7if16OUxAGpSA6AGQE1qAP6OwtfFqwH4kbQZJ9UA/Ejqp/V3lZ3kcaFxWdT5SMzifKoY";
			imageData64 += "FpR84D3JpKD3cRlN4vL7ygDduFvJGWShgNh8CMClA4oBm3iGiS9jvmyfNpIMW9jQ4w8Z075q5GVL";
			imageData64 += "UzO72iuSSUZ+uL537cyNihQAB2ydfpm47eLrGNXhlZMcYL5PVMcsJtfYASYVV6he8xRDFIdjcVOm";
			imageData64 += "lG0+twUsm8+5+DogNS8AuDf3Td4A0Evhd70Ig+I9Yblk7yMyZcI1kh/bXyfl5GZzlCqK0dxt0mLc";
			imageData64 += "tFV/7d52Uvlxx7qgVnljVH9OeS0tAIDWfHLeKnIqdDUAwLh8r9Z1vNr1n7Ry1cObFe9S6g6Tu4K0";
			imageData64 += "/xdZ3mTsQC9LzFbpUIieuwKPbjjm5ubdvGW1is2upNRGj8HFJQA0Xftvu/nowZ3UXAXgWF758u8R";
			imageData64 += "LZjBltZBPijuClg85DUMJXkHvUkmNkPpq3JpPXw+BAVtVN5epric8WNQMorFC51+GuB/piL2yUwr";
			imageData64 += "kpNxNfjUhkUDaloCGsJdzn9gB98b6aB2GskhuM4nmEIytW191R5VMFG45le3ngstTW0dE1v07I6l";
			imageData64 += "pNT/8rKajqJV5HSuAhBuWilvAIiwsg8nyb5Ytx/NpR8Wz8FALsYWko/xO8n5GJ1CcgUeX8Gs53fP";
			imageData64 += "nr107XSY4u4k29okOQijWbwmSfIiVsgMypNT8EK4JP7hs7saHXyvXNh0Yyv28B6Gd8F4ki3gz7U4";
			imageData64 += "TJJxGQoVtZKEiAobs4o9JY8+h0fGJCUeQStFu/SqqV7rTt16h+fuHlBPL4/K9KzAOJK74Z3sbh5M";
			imageData64 += "MsHGgx0RQPIxupCs6U6SHId3F78uXPMZg0nyvZnlh2LVSDKhmeRNikk18nekxxi+EI10e3CMJ7E5";
			imageData64 += "sRROkLUNojhCpXaCkvpCTGnxGP07GIizYZ5KAZcEmzJ5sAkvzjPbegts5TMjp5jLYrWUcoVSy5Ul";
			imageData64 += "SV+0I+Uly23deOLCAkNHnvzKTMF34gI2FJdKVSdjd1fAb4w2rEP2w/n7D+4IX+kD8arVuM5pOMPT";
			imageData64 += "qJTGckXS2BMfGbL7fMZnDlbMnc1YWq+kuB9Mhalz/WE7P5HkZ61WeQDAQ9TPIwDeFjI55onjHCtw";
			imageData64 += "/LLi5RILtCfJIDQhE5zEdX8N12Dq/F/nfdFLocLKduxx1S5fvSAkQ5IZodOabAsJIEJ6EytIkpPw";
			imageData64 += "io2NI8iOWM+iZchuBeSvjKCwBIo0BL5kSho5AMfK2/w2ZtncLqfp1616dVvA8QnJ63+fsjaHAEhz";
			imageData64 += "0w3JIwTOAphA/qITTpIRhjVTzJqTZLhOfTLMpIoZOmxc/4icDQAWGXp1ThTTRuO6HQB4PSEZod2D";
			imageData64 += "rGw0uOOgCcK3fFScOt1Nk6MMvUi+MXV6YlqHHGSeGjHlaEsxOYNIo/GA1x2HMK2kWWAxAIBEYFyT";
			imageData64 += "g47odSe5RjXhRu7JAasxLK+0DbaYQ9JLyJxwGCPoUIEk36MV6YdD21EyRFhnRhx8nVEs2w0hDYt5";
			imageData64 += "aV/JgJWlYLaM5EtMZoqDyhisxU2SZP3iPCGwnLNQAUPIRXhAchEuqz5zOc77W6E6/VAvTqfXgxNn";
			imageData64 += "biot5ElW7Ul2N/icFwB8tDLNo/xKqYVrkGQHXCT53kH/JevgDck9GESewRV2ReM0kp11vqoWsRwP";
			imageData64 += "SH6ug7WPsZkpe+0xh7yDGXyrrABIcqa4qle350BcJ8noEsBe8h58ZLxhVCaDE8hpDK4JuHEZFsZh";
			imageData64 += "LEkmfEjkliMk92MdKStWNm8k4SUCh5H79EGoCbQSPmRCQ6wgZ2EwmVQVF8ituMzwUphLsrH9V+Ui";
			imageData64 += "BmLjvRtL7NGDp3CG5AMDkyBeRQ/uxKn0q7poCetWI9yzcxGy4u1DwXCSI1G1u6bZzQzPDDIBZjTB";
			imageData64 += "hWoa/sH6sCjpaG+EkaykfylkAtxjyTDdtiQDX+Y6ADFOuJMnANzBOJKMKIbex+tiDMm4SliaNhBD";
			imageData64 += "Sa7HBvK8xPApWbfYVykFhwIAjOancruQ5GUOlvIxBrCdqUqg87UF4g/Nj+6/SrEs7SBJ+SIjtHvx";
			imageData64 += "xUPboh5PamhiBF9oFixuXrpC3dEP6VscmvB5T/IFxpDBtnoBua4L2oAOeQLAfsE/lWcNhd2Y5OuS";
			imageData64 += "0EOjeJIXcZbkYLTiWKBojfq1atXpka4TezOoZ6/flrwluRTvBN69BxPGP2HjZt+6Afl/VQwtfGUw";
			imageData64 += "ef6Xdu8ZbHuY0WL7qwEDBX41pNol8grqpOU6AGlV86Zk5wVTkat488fvCnHn/aAGs+JIMvV2AslP";
			imageData64 += "hY2i1tT3crK0sLCx9MpMKflhozAgW4SkjUk5Y0UIl2ZyUkoy5lBYHmhDD8AzT6ZA/D9X5Lt5iCRT";
			imageData64 += "E+Ljk5L/z50vclId7Y1jVNMPBOAa6qkH9EcCwKlimlE1/SAAIuz0n6mH9AcCwPnw+f991c+bRs30";
			imageData64 += "zfZdsuC0nwiAaLHWeS7T+7VfsY27GipiwsOUtuCXG6IYn8YY/7d+0eR1B2hBew3lt876xf3DD8jT";
			imageData64 += "TfRnJadIMjUs89j/J4EkxYzm0tgfDgDXoVkuDvyqJoIbez8844Oju6+QynpwS5VpM6s1UFw+EXee";
			imageData64 += "FXR3MwGg3/BiSfyR4FsR51kUMC7tPWLZaRXpN7HJogxCZSPl4UUMJ8mNWrdJSgMD5SQZe/GWwN3G";
			imageData64 += "FfAiHzYrM/76xShOcggmydC/FEAkqmiNPs6JyAsAEkpKnuQeAILtkXfRiSMB6F0mXxX/i4JMKyoQ";
			imageData64 += "2EBDYTIcizuPoVei1m9/LGuD+T54S/oZebAXWjd3t7DWV5Xc4y0rke8VQ/Rev5qy5Sn6kGKgbagP";
			imageData64 += "0O86yfZAqyiSDNJ0pa8NCkmARmyJxyS5EXdIRjxkaqU+gh7jFMmLOJAXAHA9uuYeAIklKpNkM9w7";
			imageData64 += "gAJ9deH4jhvELMrPFNmUOQoKRqAHnjwXvl+uriNfgACSE/F+LR5SnpASel6ldEGaczFGWlUSHb53";
			imageData64 += "obuy5YGg7piDy2RzVGylhVNMLGJSW3hPX9SiB/bKB3dpj0PV9T+TZH8Ek+wn+RAm8SLJt+hA8oHY";
			imageData64 += "k9wGIKUiduQeAhuxiTyAUSylcZYH5sND2hevxHESAzi5HbvEo14IvCpG+6dIORb+JCcjeHMm+1Sc";
			imageData64 += "VVEG6KOmsHhMw3Zlyy1MJ8nf8YQHUSWCo2F0Vm7lwVZYT/IZWtxGb5K8jt8KliVJVnRMIzkcvm/R";
			imageData64 += "lyS3YAvJlKIOyXkBAI+gbGKuAZBWx/B5lL11yl7BbDsHnSqJFu+TyiidO8rQnSYImAflijgYM64z";
			imageData64 += "wrEUV8B7U9AXDw6WNORrHSMxA3nX9Lt4BOtJsrlWKKvhHskTFsb7rRrwnaltGHkVg8cLHid3UEcw";
			imageData64 += "VsZbeQrfypXzQjDiELwlyZGZ8yc57xnXVJn6MBfouUG1dljEX8Tc1D5AG6Fhh3ITDtftIa7rtoXZ";
			imageData64 += "FpsCQoXPujcMNFwssYOTAGhPyfjcxxjDlxjVX3hKNa304JMl6HXyzp0dpi58Kq6u9woaw5uci7Hk";
			imageData64 += "Mqz6xThGuK4KDpHkC/QnyZtYtFQY8lZ6ESS5SDkzcxmAS7nKCO3VhA+lhQSvHnZSmsgn44R4hbRI";
			imageData64 += "U1JG8jr60x0ACgaTZJ2Ka4G6u8nfNK5s8x6X8bHnsZnvMDTOziqUZHmTdAapt2jlr8p1ii/LC+hF";
			imageData64 += "xrtqv+JAHGxok0hSXrZ0H6EezhVhdkYaNe8l6Lyb6EWSZAtcyhsA2DZXPZT74wI/SYR6G5/t7TBO";
			imageData64 += "sdwoc0NV8eBij2dkH5yI0am7/Pc+M5NJsmRVtsUSku20v3aS2own9MNgrsEykjXN0gUFT7OFU0b9";
			imageData64 += "vtCyCpcJflnci8KYTPIgOrIM/FuZxJLcg+WD8J4k94ilLMo5VzAMJ8kueE0ywc4qIo8AuIBWuQjA";
			imageData64 += "IL1PDEIv4RiLNEeIzGJ6ApYuNgGOqMkgvWLye6LFhmSqQ11+KokN5C/aX4/EXLziLcxlslN1krX1";
			imageData64 += "lObkeAsvkqR7Od5HC5IMcyw/SCgb0hBjNVw4CI/JD3YO0p4CANtEdsBL38E4XAD3KMk78GYeAcDm";
			imageData64 += "uJ57ADRwJ2NMGpPkVfyaYt2YJNMai5VUSHKypCPK4tQsbOcrXb0RR+8HJ5NkmTLk04Ka5zlUYJzS";
			imageData64 += "nqkwCwPwgbuxlRyCl2R1gyhFQ4ho6q5rHs+2WEBKm+NcSyFg/aoe0JPHUf+Vb1ns5niMfXRibn8H";
			imageData64 += "IcnMA3i2EnbfO5hEclgWufhzA4BTqrV/cpiSbGuSrF0gnAwpZvSC47GNjOkg+lSRJA8CRZ6XLGRU";
			imageData64 += "JpXcZAVAw9aj3TGeO0ryphmebUSZxTtO7W2mKjJOwHOOx33yAqYyxamQUhXxRFzjeiOIH0uhy57q";
			imageData64 += "WJdi7SAkulsJ7QdkewAmO8j7RgAAbYwl+dEVZ1bhJNMS5REmFfi6C6xe5BkAbJT5fpMT9ApDSC5B";
			imageData64 += "qxfXy2AXGVAEXj4m6KaiMfM3xlxuE/2RI4/+MaajVzljhRR0b+Sn6PY6AKCrGl2+BZdY1VVGprhr";
			imageData64 += "rz2MusqGR2J5p3k4QQb6AI4P+VrwyyB5/zJJ6b5Oo/1I8sXgPvNPvHxmaXos6pQLZvAqCtV1tLZc";
			imageData64 += "PxRFddAskHkHwHFFJpWcJz+77STlnQHoLCJJv+amFl57Mlgpm9sEkIczMH0pGVSagVf/XHIog49z";
			imageData64 += "6LwINplPkpdsAL2z6QKCCN1jnQ0kZX7vEknpyb9Vuq8CNFDgAMn+0HWr4LP3cxW9hifzSBknKhNr";
			imageData64 += "fZXDKefUEVKSlB4YNFMRE5LwpeAX+v5fPVkmoBi1edhTlbNBYlrNT98uXt5s4z0jiCRT7wnl6ZIj";
			imageData64 += "5MxTAHhI0GCpKc/V0Qryhq96bHMVgJS/9/bYhlXqsc1VAMb2Jrlyd1bNoXq/qMc2VwGYp/meSYVm";
			imageData64 += "ZdneQ/L+/+1VQ8f45SMAHmIWr5hm/UY7vkommsMku7tl49Jtx87ffx37jZnabytMIom/Lgm7H/Ti";
			imageData64 += "2qGT/qQ88vV7GR9evPXiU6I00yfJU2T/hwCwTglucZJm2Rys3Sl3AUgpLYSjaEBUB6WMV/XLS/L7";
			imageData64 += "atQSi9rGiEJVaQdBxalxJXGQAdA+rgygY2jjXHLMYxkT/K/e5Yvfh+0TVEbPWliXUdqY4mNJbluu";
			imageData64 += "ZDif/jgAXu3ikf5/097COJfzwN1fvuPShb3eVh2qCBFFL1DwM0n/heXXhh6d21S3cb/Jm7fvUY0R";
			imageData64 += "WCwYba6i6giUa9p7zaEtv6x0QeE+TbHt3oyKsHKrYgvNnm1tAY2A2QD0mh+XMrAIapZGV8GmsLeg";
			imageData64 += "wUayB84quO3qPwSAb5qRm1TUY7lILfGSk7eTZGwt7Gb0WF1orm2ljNF2V42SiXcxeUKGO+v6LRSD";
			imageData64 += "YHwLoFcEUyffIJdjPzkTAEp2Hz43oZLW9YPdzdGVp4DLnIByASSPwNbZ5jP99QRd10Ud60s/AoCL";
			imageData64 += "hb0aieanB0djs1baDMgLAGZhd5CornmCfrKqqHw6nIf67FmBcW9vPXyU0QHoqk6pN+yJdRwihgX3";
			imageData64 += "Sre+L8I5Mrmo+40nUpJJdhVlZNIsnGJNXCSXoUYSo4ob+53AEnIODpB8aaWfA/L+vwAgZnz9UmOE";
			imageData64 += "w4kw7Z9VCJpn4bxwDP8TR9aKbgAfNX0moogYMH5f6aaiSpesLDrDS86muJUsJ+kBZb3caXhGRhv0";
			imageData64 += "FieLye8k+Qd2ci4ektyJGRyHvQyWdCQTy9i8o19RjTM/XBJOOdHDfH8WbcORF1zfHLzpJqjdGazR";
			imageData64 += "Zj905wkf/fHMubC3hWHynGwKiVm5as0S62HQ2YhX5z6S7GuRQD5HmR513au+ZYzheH48VB9tUzhe";
			imageData64 += "WK4GWlw0bE6m2NcleUPL6ZCrYK3/UQDc2E9GJJBMzWpH2JKbxnklDdAOda0sHK7FYt71RomXJLkc";
			imageData64 += "FzK7PLkYNpGsol2tvL15J14pBmhK4Ckl3V1JngegW7yPP/11i1c1gdFoKTkQISS5BK5wrN+mm37h";
			imageData64 += "cJJnCiCHPMH/JQC70Z6s8LfqhvtZeCLlEA8k2nUbFnqjKei+E10tgkkeM3L2J9kH/pnd9hhdScab";
			imageData64 += "NyeTk0imvF4/Y0cfXGGMUTuS27HQL0JK8irs4XI5hiQ72SSTpA9gX7mgkQ5whSQ3oIr0BwJwDN3I";
			imageData64 += "KKO1Xy1Jd94qjyP0czFoT+7SV1irLRtEaglJwaeLn+RNDCDpZRKT2X1rsIPkRwzMKFTO4wvMIzlL";
			imageData64 += "sWwuweGSohtJLReSPAwYPGJybEpbBJDkuQxZg/IagDfG/dPIML0vvB3DVrrCcJlSFLLKTdv8FDS6";
			imageData64 += "kUL6YiDrSHxJnlAEIh7DGDKtSOa5K9rjOklfhS9FXLs9JB9jBk9jJ8kRpqLbdVe8eWiOiaRQ+ubz";
			imageData64 += "DBOIDNMyIQ5rj+B0FfI07EcAEPtKRvKDbkYu4G0hFO3oKdZWIlMKVc3Nxf8PHRSq0rg+VvEvFNkV";
			imageData64 += "etLc5OFW71DyoaXZGzJEo1umW4CjVRTJV1iQ9PzS7mX3Ywvq75clD8CfPI5DJFsXEy/0sIjj0xJo";
			imageData64 += "HkeWrnS4vT7KuovS110MFdjfxyRjSsI29EcsQcIaY5VRDFmFLWRKycqKGWCbuxFjwdNKW2qi1Aty";
			imageData64 += "pS40UOgxF8O297AC2idJPlLNPZBOQULNplh7aAMA9j22ho0JeqTxIjaT9NDp1rRmJc82Ha2qk4zt";
			imageData64 += "h54HqhYAUHrbe9uSwgRLdbGOIDkMj0kGGRjN/3FsqPxpRivdUlwn6dpQAYBNy1zmgGSJH32jSfLt";
			imageData64 += "9FZzQ0hutAZsr5Nk4vJXmd2RNPaesEz19fL+bd7pfff5cWbNBqdIBrlcIMOsAWjoGWr1OiXUrhhu";
			imageData64 += "fKBokUbz38l4CaPFZ6y2eE/yQvlAkrJHH3+sHJCBHmA2GaH/m0JeM26Y57rdqPNnY/7lrUlykk/3";
			imageData64 += "X34WGBGtzJ2Y+jItRdAmyW4qBM5UIZNETgUu5aRJspFjnIqb+EfBOVtNeQfAHYPqMytahimVQbPU";
			imageData64 += "w5u3APCQHkz/SBfE5qiHN48BYOjj9CV4szpqO+8BUKXRGVN7qSmvAQi8oR7dHwqAmvIEgJTj28LU";
			imageData64 += "o/gDARgBWO39/3utyBv+/w0AgvVa3CzYJpOG5B9bG6+PGM+V7wHwxRrWbU2Sp0IZf195PqHOD83d";
			imageData64 += "9BiN/iNLUKyLZgvtkSQ54hBTzzN1+5iDJBObuA39kW/V7u/TBeenPeDtENcGz0jy/AqmXuH+zaH9";
			imageData64 += "XzC6fq/UH7kE3ft/TluUW2xozCiZPDrmYCKvdlzrNkH+Q1+qLR78twB4v+cCb7hUHLYtdusmfq5r";
			imageData64 += "cuXHvtONn2gC5AAAkTzyu32ZvpoeG6/sHFhx7Ajbw+8jSTI0XWMul+bxBLj3XwKgZ+XqnQc3rDw4";
			imageData64 += "iv6zChRDg65/FTfqMml1a8OjFxUQ5O2CdF2Mo/+vABA2TNP2aTFTt5KtCmi2NoemnoF1aSsNQN9b";
			imageData64 += "kXRHlrcToK7em/8OANH3Asnjv0woP32jozYM657a2NvHyVWvdE2gsNKpPm8nwFrM/c+oIlJOb9g1";
			imageData64 += "ss+OOS7N5jSc3Ni0UcS7xLm2n5NDn565PxEV0n7ICz01KBf7nwEg4MmuFXFlN8k4FIZDIyu7LPnM";
			imageData64 += "K3hIkvzspPdD1NGxlYx/rgDZ71uC/HZXbnY7Vj646bBih3iy5Zh4BjQRc1KcUiZUyFPqjrX8DwFw";
			imageData64 += "Zy79L0519uG5W182yStov8j71xn+04XofxcAu0z9ondfLgavMQe/blyKznn+NuvRKvm/BMBl+Pjo";
			imageData64 += "WWt5/5lZDbFIO4O8DhU+Ac+fraD2dy5BBywB96wCdfpgBz/kJSv0poBDMP9bANAH5bKsoLcEk1dP";
			imageData64 += "k+Xdq0g9tc/zPwaA3A0v/mZBsN6Yl68yVKwBmRklpuVPAOIKWmWdCf4Uyuflm8xFuyzbjjqXHPUo";
			imageData64 += "hSkp+Q2AVxBLzd16xruTN0Wrtm11R6G4PHuP+LGw9M+ytToA2JVwKDw5nwFwU5He7nDRSiZfFHqd";
			imageData64 += "38MA9R/l0Wu8qAi7W1m2hvR2w+Q+lcqVQc18BsA6TCTJpPsrSgKAJENsbmIRrS0f8+Ytoh3QPuhv";
			imageData64 += "tirWsYgleQpD8hkA3bGXDFtaBDDy0FRWFlRuEIZ55bOVNGPP37aH6dUnyYEo9yp/AVATD1MWWEGv";
			imageData64 += "7qqwMzooNzlDcoJAbZuYXOjxu53bD54KyN49dwVP7SaAW0i+AqAchjjBcPInUjrd9LcvEjteg1vO";
			imageData64 += "SwH+PQwAQKdNtiqlrMNNktEFKq5Ho3/HkCaf//j/OQNgMjOYZEhFz69yF63I+STeQZNMoNli1sTO";
			imageData64 += "RaDb9eW339cH70k+RV8Ow7J/99Ohb1Pl/3cAHDaCszDuwxd+3er9N4LRv6N9FtCse4Ykk5fbQXvG";
			imageData64 += "N99Y2zKB5G78wUi7gp//Lacr+z8DIHYktCCkCZBlstv6GQhFhXKMUroDTZUZemLmG6Op/zcqKZzd";
			imageData64 += "hXlwnuyRRTWjn28PeFQSBc/0w8ovX1ZxMC0H8nll4Grbwu4v1RNHjFH0/jfdGqHTjaTM1fAjU4sb";
			imageData64 += "fsgfADwwR9vPfGGk90WtAMU8jXIUK0nkFKtfG4W/SFCVOA8O36Txfo65JD/rViID0C1/cEEBRYVE";
			imageData64 += "YWth+zzTC6agVo56o/SC3dc8/AyxvMI/0ElcIvkMXcnLYl2rnx2AqCrwFBQ9o1Aus3QV1zVwMSf7";
			imageData64 += "eQPIJA4kpIDpt/D163Cb5G2MJMfieH4AILQOSorOH6mtUf7r3GSJVTEmR/s5CKMyO90Z177h5uF4";
			imageData64 += "SvIINpDeeJMfADgAmPY4Giwnyeh6KHj6i3ZZZ1TJUePsbZTM1Ng4Feu+hQu1TiA5AQeZYFdCmh8A";
			imageData64 += "kN/saQdolRl7J41M6gGMyaB0iGyLojmbsa8Fxmd6fg2m/fPNYQbeJNkaL/kcHZgfACCZ8GR1LROg";
			imageData64 += "5ISHcu4pDNvp6TvB5aIo/TZHe3kXbpkzj5fwDRmSL2IBSWkxu0TuyZt0snklCcde6GYElN3FmN4a";
			imageData64 += "MK016NynqIjQndU14BOes70cjX2ZN9xRqbfzN1vAWZLRJpXIUf93oRvf6x0debQh4DA54NUAMwB6";
			imageData64 += "pgZ6gElOc3ryClmN26VvqZhVFW9JPkUrsj3e5TMASN7vbgBJ67Nvbqyt7V6kcKHam3PcCvBJr0KW";
			imageData64 += "HP4/xwLEWJRII7ka48kmKmU68w0AZOhWT01Ydurt6ktZUi7oDF+icRYtm77BxvVccNHrgtNkaYfk";
			imageData64 += "/AgAybczykgAq9a5omi5h8pZtMxTFtLOmhYKG0h5iT+TbDyZTwEg5UGTAZjvyYVO3kFWGTD7CjV8";
			imageData64 += "/5aa4THJRHvrOH7S7px/ASDfSSpNBAbn/CR/htKZi0/SUhqv/+nmZIfScpKv4EG+xMz8DECqkyMP";
			imageData64 += "mqJhjsdof9QrnJjF5uD2j75Wj4U65RfQj3yuTCubLwFgNf1QPisBl2c53cs6yFzlugu//uO9KwVt";
			imageData64 += "xTJMJR9n9NvIdwA0xjPylSvMc1oQ2IIemZ5vh382S7YVWP8+OEeewJR8DUArXCcZ2RpoHZijvfQ3";
			imageData64 += "MvHP5PRlFPhHlUdyYQcx/fw9cun/mzI6hwFoBMFEv8wcxjkbK7oXNaK/Puv9Daq4QEkVkmRt+JGT";
			imageData64 += "8DRfA+ChEPSj5+uhbo7GxyxAva88fU/B5p8dtO4LwYLJjsafyWk5ayX6fwMgraSWctBf1YXd9hxU";
			imageData64 += "vcv7oPoXiAaU+JbcvEcEzjPa1EVGzsDpfD0DyqqouuL6Ay4Lcy5kS94fNutUPXP2OqDwN0yycThB";
			imageData64 += "khHGjot3fWgsRjHnVwDqZoiX2eEGFJ2XkFMPl87SRvmtChkjarQEnt8SB9tcWPYDDSGBBIaB+RqA";
			imageData64 += "Vsjgp5N80Rsok3P5c+83Aax/33/u+o3FjU1RYMO3eKrFWJmFCQzTgB6ooG8bk68B6PxV7ajHLaD9";
			imageData64 += "e2KO9fZSD1OxRqFJ328zrh+Gk79UmsbpONAc/l2xM18DMFIsPKS6cCw0RfUc5P3erWgE5w69V3/r";
			imageData64 += "UnLNGAaFSjpXLoBbbiZxIW7ofSUfA7ACi74++bwGDMZ8Z6Ubvj+2ecGA1g3cXCrUqwSP7Eyp4IXe";
			imageData64 += "7k5l7FEvws44kDGdoLsq/wJwSqiR86UsOk0Xdqe+a+WpbQixerC+ngT4LXu3x55aN2/usVUSFHQZ";
			imageData64 += "JD1nrvk83wLwGJnbO160BNp/RxaZRgDgXAAFH38ITewEaGQr/ninlQagoSFA2IVjcIfylOSYiOiI";
			imageData64 += "CP9HD56FyfIPAEGaZTJvkK23Bv59iOgFoKLPicj2GEGyE4YZGWfFzkt9P8TFRyfGJ/i/i0oMDUlM";
			imageData64 += "Tg5LmwMV0mnnql/Z09XW2khLT1MTAPSc2i5odD1/ABBj4ZDV8vx5tqb3vxfCKmMGpYyrjoOUuZgl";
			imageData64 += "LESFLGwOw6BlZVugcEEbHehb6ehYFSyobeyoCoAG7L1KV6jdatK8sSNGzF+yctnqud0b6mB+/gAg";
			imageData64 += "0cEoa4eg4O/wR2gCjyiSF1GTyYV1Ajk0i2xQ7y00SxtbGenpFa7UvEn96u41vbzat/Ioba6vpWtU";
			imageData64 += "ofvAaQsv+MUI+pE35/ade3L/0YvguDRyWOaOpz8fADJXPMuVXjYEnI+RbImT8oKafpS3wMLMrtuD";
			imageData64 += "iYxPiI9W1dvJUyPfPLxz/U44Uz88vXPpyPq5s0f3Kp4+JbTNCptjev4AgNVyI/7nfQxbatcABsby";
			imageData64 += "ELrHG1iHk0FOyCxLzhwM/Rge8PDg6okti5eoWrN2zVpVXe1tbW2LlLI3NHMwSF+JrHrPXj5tzLSh";
			imageData64 += "gwf/Ur2sq+UPtFTmLAD1kfP5UVKL9WJvvFpjCrd9fna2t/Xd5STPwSqTyXZJD9o6whDr6WuY60s0";
			imageData64 += "9d3LlnWtXr6wY+PyjtW6/j5y1PrNmy7ceanqOybniixcf38+ALy+yVs8mztwSRcOwy2+aS2BmQEm";
			imageData64 += "WBRKIMnp8Ez6+uLrLW2KelVpre948eMnv4RQ/+BPMplcTqbEU5aWpcvY9m9x8f0pAKiHkznfxdY6";
			imageData64 += "TYG1JA/X1gV0YSls9B0wILOr41LItGI22crTcvoHJvHI6SUo52fAu3Iw8hb9eQKXmwBouCGKZEyF";
			imageData64 += "LItay930s+Wf+jCHAzp/HAA1c17bGFsZGOunrE/fDgBQeIw/eccErU68z0yOlbpoZcse+grl8g0A";
			imageData64 += "x3K6g/dhpF37k3Yz8d8pAPo3BKqkkUd0Ad0yvecd94vLuLzHWReIzM5vBOvaxecPABphf053UFpG";
			imageData64 += "09zwpWth0eFxKYCDfFYTZ0lem9zaWgOApm2Fep3a1/Wq061Z3fUkgzVqZ+s3PujYxuUPADriYI73";
			imageData64 += "cDbMsK6nwtq8FcAi8piiTFLC083DqzlppnP4thHkU/ySrZ8INbKMyh8A9MwqlOg76BKcJE0X46zw";
			imageData64 += "33kA3Um5l8pck6c8vXz+8MFz585derdveXgU72UzM1ZcQZ33+QOAzoILQo5SmgdgO02hrfHVkqAq";
			imageData64 += "yRduG76+NHnt1KENLQ1qeSF7RpdkJ+0P+QKApGJYn/NdPAJAgqKCOf2NjoHEKYHpOSlU6RwAHVtH";
			imageData64 += "I2Q3FrIM3uYLAF7ooEnOd1G+uD48fhWXnAeoXw9Xs7jSF/Uef0xISV2S3TwhjXEjXwCwCzDyy4VO";
			imageData64 += "ftKt5ydpLO4BA6bgzyyu2yQafVZhR/Z+YOjX3gQ/JQBLgZznQwX5wq+T4Ni8HbOfoFoWWp3jGMfA";
			imageData64 += "4HguxPbsPX8yluYLAMahYe444K/GrqfQ/kNO9sAhVlewRF9JzfaaFtC0KGWJzdl7/pjc2Lt+AABt";
			imageData64 += "LHbmTtWGe+jNrZZwOboCpi+5B07KjLzyyMDEpIAPMUIuxLHOVTo0q+Jokt2kQDMxJ18AULZskG6Z";
			imageData64 += "3Mgt+FHHiwwZrA/o7CU5FYWXLtx6+vnKlt41rPRLFNfStChWdfztBDJNKqwo2eSCFmFcfgAgxqQy";
			imageData64 += "G8M/F3opc7GOI/m8f52DJPm5NABAS+HpULy6a2EjwEERFNInu7UMJ+SPGRCMlhz3DYG7/4I6ZAxt";
			imageData64 += "Cd05ooWrqUQEQLdIlV+H/9HHQOn50ii7WZl+we38AIAf+nAnRuRGNxd9rWZNC729aXL7th061C1h";
			imageData64 += "qKHQBNUZOC+ArGCYPVfI1GLGkfkBgNsYz3dokBvdPPN38aVp4S9Ozmvv7dOkFABMYbJ91ew9PcrC";
			imageData64 += "PiE/ALAHk5hYRDM3krK9Qq2stof4BKVWIsBMqxFmM9Y8m28UqFlKmh8AWIPt5G84lQvdTC2dcVlP";
			imageData64 += "fXt6SfemntU8a5QpaOdS3fuPi6Ek2Q3u2Mp4m6Kp2QNAowzzAwA7sJpch0G50c8lKqJS9JEhxZSr";
			imageData64 += "vsTAWA8AjLteJS8AuExW0sheens/uMnzAwCHsJ588C1JxP7NGlRFcXipMKBVqs+SJadvXt1+4tWn";
			imageData64 += "8I9vzizoURbYQ5kHdF+RDbOZtfoVKuWLGXAYu8jkoia5kpSqNsRgs082KDfC9+svtjPcojkFph/J";
			imageData64 += "Oshe7ZqnqJovANiGMyQHYE1udHS7UK6GPJgVo/sr1vA2iqeQ5XEnW89+nU+8IlbjPMnTqJcbHf1o";
			imageData64 += "4JYkwrww8yvGYwdvwiiAaSWRvVIxITol0vIDAFNwk2Sys3l4bvTUB0dJkleh+VtmnG6oK3y5FpjK";
			imageData64 += "RAfd7FkYAzWLpeQHACbgljBS23Kjp6fRVDg4YAE9zwU3X0ap7APJdyfZowk5ADALSjB0zl7Wrg86";
			imageData64 += "9vnCL6iHwKtv+oZUkv+C0jwx8m14opwMX14egJZ1xS7DF67etv/A3O51HAE0DSYbGjTHyDhdj+w9";
			imageData64 += "OsayQFR+AMDbIIIkP5nkzoS+awzo2lTx6T1+6rSaDsX1VCOPYD/sbDKZWMTxhZX2URP37LH1yUU1";
			imageData64 += "A/IBAPGFjASX2Na5ZOIO2tirShFdccSNlKKYw9jVh+8JsWmX0JPTURCO2VPtpBTV+5wPALgLcebP";
			imageData64 += "yEXtekpE4IO7109uHFi7dhUrEYHDytZJ2MCwQsiub0ZcQd3gfADAnxgtHFyDV570fQ8anBoK0/nK";
			imageData64 += "5UNWFi/JUchujvp4O72QfABAI6wWPyhn/Tz5oGZhCa/DLlZ54iEakkzrnN2o0ygL8+ifH4CLcFKw";
			imageData64 += "EqNz3ks9E0otqxPAKFuV1K1LhDiOydn1jYk2t4z5+QFon66C2JsnNu5N6EayJdKLi7XAeZLsnV38";
			imageData64 += "I00K/vxywHqUVxpGgjQ98qDr9XGH5Axl8Azj7TX9SLJVNlVB/KBTOPFnByDcDippu9sg95Mv+KE+";
			imageData64 += "SZ5CbcWZF3BKIMnG2XUMeJIbdV/zGIC1+F3lv725Y5XJQCuFGsHvDXUVm8AWceX7FdlM4f4gy/oE";
			imageData64 += "Pw0AsooZ/EbCbKzDc7njoY46gsqzm5Ln6SOu/W2z65v7Eq4/u0340hdZtKdm1zsz2zQAI4WDHQqx";
			imageData64 += "S1ZKDDT6VUU0+zYRW/unV8Z1/SI47HWmubNykPaiaJhitolT4Z5iN+iOrdl72Cu4/uR7wDtt5y+0";
			imageData64 += "L9XtctXTZiGKPCDJJBk5Vqya+ExRnWFQdpegJyj/k+8BE78q5TIjV2WxV7oaowY0adPJw7JWzzlb";
			imageData64 += "NC0/kaTsligTj8hugMxzVPy5AfhoXjjhK8bil9zr9OdR5pDAuph1MZ+SgK7GF+lKJ2S3kKgvqv3c";
			imageData64 += "AIxNF4aUVCkXbRxzAVhOXbdw7pHLf47Y8HtpmGXIeLUhu1zlW/zcjlkBhtZfh9lOz701KMxe1RRj";
			imageData64 += "VN4J0FT1R/8LLh+eHl27YNLsqQPGrTv+KuqfLO6f9K1jf2IApG2QSczu7dyrHR7rCMCoXutBg5r1";
			imageData64 += "7d+lgrU2MsalPrGGhkQ1U6KzZ7fZw0dM3vgw5NSs+fM2bD74+GOwqtEuSMfyZ9aGDoFHJhxPtL1Z";
			imageData64 += "aC71+aaxrhEKKJMXPzSFhiAVK6fIol+GLDl27dyBs/fu7Zveo0UZLWXORJE0NZ07du82c/Wik+9i";
			imageData64 += "kkPHo85PvARtR6lMEzm30cktAGroHvt0ML0i2AwMeF34b7V/0s+vb1w9f2Bl3+Z99p448ueKRc2r";
			imageData64 += "1bRRYGFur4uCl39iAALmZV6gdJheLu3CcjfnZPrr91H87yMJeWHmkl1JKu7ezZvbF69sX8fRvNqE";
			imageData64 += "H2aSz+lcEaoUmGuxz7tQp6421ir+nQ9Tze+oYJ8c+0NzF+ceALlI42A79LByF5Wvb9B7VSJ/Uvop";
			imageData64 += "AUj79NOOd/4AID+RGgA1AGoA1ACoAVADoCY1AGoA1KQGQA2AmtQAqAFQkxoANQBqUgOgBkBNagDU";
			imageData64 += "AKhJDYAaADWpAVADoCY1AGoA1KQGQA2AmtQAqAFQkxoANQBq+tEAyIPT1KOXtwCkZUjGGWUzmCRl";
			imageData64 += "GcNLos/v2Xfpzd+mDU16ffN2nHrgsw/AHvc63Ralh0OGaFVlWtBkV9euKrmZDtsBAMq8y3r4NzkB";
			imageData64 += "cNyUfubD3gWzbv7Db3/ePGfehWyh5j/6cc4PVuSVxZuSfxQAfwDaQMHFUs4ScpFUMItspQUjI2gr";
			imageData64 += "U+TFFUGDRRvnl8OeJ09I8vOxBMpJMuHy2fWzxk26HHWhOOzbj6sITBNvieisB0BIsPVw5KQYUi7O";
			imageData64 += "qeTfmjf37jJt540IJlYFAIclySRTr8aRpO8/RFYPgu2LDCdkmSTTlT9fO33fN4do72tgDOAuKQv3";
			imageData64 += "j/lq7mdKD39rNuCvyBwB4BwK7o/sU6EohiYXcEohyWU48xsWxn8eD3fFbuArlNpJ8o1wqiuA5t5m";
			imageData64 += "4JTV65KWiiGhFh3QIYxMvlFBUWmmBaz6rdmz5ROFBAStyCMeYWTU79dTSiqKlMddQq2zZ6bYoEE0";
			imageData64 += "eRYjSN7GJNm4AJIMfPr81eOn/iEZq8bEOAKeqSQ/bZ4293QwKWu+KjnuiyF7XEcCoA0Z5pt6e9Vz";
			imageData64 += "lbu3hZDk1q6hTEoNfvIqOErKuPbQLDXs/Csp7zTUQHVykPfj59cPr1j/MXDn9r/Ovv8K3+cB9LME";
			imageData64 += "AMPZOQBASjlcImVM8tS+Y+wpoIthe3GVZF1lvYrziuRVwZKWJLldDI4+sQL1FyxZv2njiFnYS5J8";
			imageData64 += "pS/UhH+jUThIvHkLJOOq1CdX4BIZiIbshhOvH9/aNX8JP2r6kIzsg3JhXIhRJD8VqHQNS0jSU4y8";
			imageData64 += "tl9E6fONHcXE7ZswqTQOkikeAKDz6+ep0Da0KN9nj0ri+20GKL7qxtrdfFkYboZAlyhFy1EUCyJD";
			imageData64 += "7DCKtYoaAJp6RXd7o5ywqE2V6LXdeJlXFHHGLlUAQKP0ZsVnmNpyIUm6enAjBn1+c6yO0NHvA2Av";
			imageData64 += "uovzEC01hILtibZVt+EQycbKii1PFbVULws17c5gwb2923bd5xtMEhrCDIcKB/X1o0jyOBYpFm0r";
			imageData64 += "/dOcupNchctkvEU9ttcSUzIxsWBZkuQE9OIgoaxtF615WE9SXg51W3YcPqRlkV6ny0FiJQLQtEDy";
			imageData64 += "XNQnpeVw4M2fZVHCB5plSmirJpU4DIyKIUl5bbjomI53Q6mXYtMaoCU5Emghc4Blk05dW7uZA3at";
			imageData64 += "B5+VcgWKCPWkx6BE6yk7zp/e1R0LzqzrYocK4u23hOzxrfFsOcaSjC5YKPG7AWivSAkXZQ+xplqE";
			imageData64 += "QeuNWPdsdw20Us6TkgajTlx+Qi4QUqfeUJRejtASsxpLXWwHL9p/9dxAeIpzptQJYVtrg32knORU";
			imageData64 += "vCBjjDqwiVaIsIPwk0VNsbfa0f0Mo0iyD2oKySl/tRYKa6QOBZreFzsSqtOZEU5a78jReEpGO+JR";
			imageData64 += "7aJpDDq9fJgiR3FSCfwmHJ2AJ8fihrQziogB2wNhjVOnURYdWclBWMI3NGxXq5AmaodWVeTGWaLI";
			imageData64 += "DLkWJ0imjoG9kDFgs/CJHMIf89GbJKv/Xc6AbwSgsr7ia2wEzCNJnsSq8ZAAZgPSs85eKw9A9wE7";
			imageData64 += "a4YIAIhL0gdFlce00uLE9RDTG2xzhGWPe+RjtBWf0U/zYXyqH/qzJgqVaBJPklJHsYzbfNzt6pBG";
			imageData64 += "kt1hVDSJJH+xEQBcBZVEZauwR8ZZWEsOxgdyGBqwcumMbyStCMeJ16NI+uAmU/3SKGsLYW7Ts8Rx";
			imageData64 += "FLYsdUe7DWu5quzj7wZgeA9U3pdEkrMVlc2uYiWFE71EQO6SZITegBlYSPKiaeGE7wVAVryoYoWr";
			imageData64 += "Cpyk8A36NbFuBo1VGS58cqAPxtFJWDKaQavgiFSSt+DeazVJhuu38Lv314w1p5TZSRIPN9OCd9Rw";
			imageData64 += "ofoGyfaAgYU1trOYfVnrpjKSDNfpo/jYrja2TSLJJhAzQtVxTY7+nERuBXyUC3xdmBmYO6MF2QPP";
			imageData64 += "nnqjfijLWs1aekhlo2XIdAfAaGDMRy0fBUNsWFpGklEmzTkMhrfD0Z41nO+e35+eC6NmgVeTC8Fy";
			imageData64 += "GckumLn6SgLJZ1hBkgw3dZULq/QFkozS67kEw/ePqQhFTu3vmQHeuuIsem8qpot/jEbSQq5JnYDu";
			imageData64 += "GRmQVOdq79GPJDkJbkVqRJM8BaB2KsknmeXVDhojKeWszO9Uw75zy3q2uJeoM5apQjbJQEVGtD54";
			imageData64 += "27hQCsloB4hP8oSNAYqGkCcqooBYyfwhCrXt6ymBeRC7wFALjT9S6g4AAzPKJNcWN0atdcrcxzGW";
			imageData64 += "FcRFfAoTtx2lP3qyOgCVPs/BcaYcq4d6iS8NAaAzyRfiACfbC7PltJA75xXGLgEA1LuWA1zQSkWV";
			imageData64 += "9j/QVtjUW+O81KQyZQfLo2PGpJuly90W2fy1uMA0YQ/fEC4jyd1iJZ4vqD9QSoQxrVA3kivxJhDK";
			imageData64 += "ZBMnxEn31tCTnfWjSZ5DcTExnAcKVmg2PJJk6iRdLCZJjsJ+Uv6uHXazobEDikaSCVbNHxw9/nVy";
			imageData64 += "yqlwMFB84LMhzOb1YvahJ/iNlbVHbT6VftslYS3do9k/RNtl0+WdC9PIB2K6pGfoJF7zF0kewKGl";
			imageData64 += "GDxzw0t5TsgBUYXNn5HkB0vHZwbVZOQNdGGKXXWSCe2V9RreRJG8hU63sIkyOTkQokj8J/quW7Z0";
			imageData64 += "6Q3+oVxphIX4s4wkDxmYGdnHkmTEuhjz/iRnI/gBlF+OuKq+rISTnI5nJH/BeAEAedG66S94zgon";
			imageData64 += "SUbYWIQLn2JPulW6VRA+sYw17PfFK6XKSbI5bHXFTh5ALUGH0hVvBbzRjY7eGSermIZqDf7CVPHc";
			imageData64 += "SRGv9uLfW9hBUl4HYdMRlGOS8Ek97aFh/MsR6zge7XcvtzcNJCcsJMnE8rp+Im85leSvuPAclZq5";
			imageData64 += "uzW71Qothkxbef5a2nJh59X7MA8vVZ+6GfW3XjnUGs6vxgj8aPd68TojSS5F4A2cCXn84F4QyaV4";
			imageData64 += "k3ZpVEVNrVXkCawh96DbfUwnKUtyFtO2pqWR7IeNJHeJlSRirV1Tnb34uhgapURKBmd8oU+uW0iO";
			imageData64 += "Ro/JAro8quMkTAVpsUJJ4mh70cmDpDwpxW9roiAhDCNJLkA31JbKkqI+xXOugNdqBTf4CONJLkYn";
			imageData64 += "9tOJyjlVxKvWsC4F8xVyhlYAIFEpl3dIkTypo3Ms96Mm3xsB0EKV1gZCxZeHN2utnzv/z/WbucM+";
			imageData64 += "Q3a5p2UBQHNwKD84oZtv0mwckxsPIXkOG+dBBwDQL5E70a04IPE6RzK1VBneMrQOijI3GzayU8kx";
			imageData64 += "FeoxPvT57fj5brsujkCVBJI+iqqHVY0DrXuTL4uhX5xpzcv3A/39H13dK7AkYQWM5h3sjBryHWgv";
			imageData64 += "I7kKxcRvI0CRPysQLVjaaPTE9hVtLQrAdeba1Z00i2/fkkbetDSTQMvRuaAefmdH6ySSO2Enfu6f";
			imageData64 += "DMskcSWcQzjIMCbnACD313Qa4k+Skae3H/RVaUi0LycsAxdRv7+e8SPy/OlnL4IP3g3/HHjx2LLB";
			imageData64 += "G0jFLiH9Ijeb9N6UYeMekuRbD0i00UrKzXdJxgy7v9jZ2bNpn1F1tc5TesysaM+tQcKP7IRHAa0z";
			imageData64 += "5GIAMF5mpeVsqQXYVQKAOkEkWbesyLI1wSPbHiR9bXCvPCDRlEgAPXGcD1kB6B3D6NJwHzLJA7X9";
			imageData64 += "qRj3buImPeEsp2gB0K3ccfUwawmg3SlmCir81kzDPWCnj2spp7Jt139KnT2M5DKJpbIq+lgULovi";
			imageData64 += "L8iJuqE5CYBSTfYVLVewxGMB93+b/Stpb68G41W/mORkkpSHJpGMUJElR8HsEEn67th2/PM7D8ei";
			imageData64 += "rg07+rhsPr142lZhxocpEoefWppcqCZJPt2VenHp2I7NmrQbMl9Z4SloxYr7JPm2jQZgt0L5crLT";
			imageData64 += "/iq9eHdy78NQkky8vON4MBnQqQA0fnlPUiZPk5O8XarL4SN1YHs//avaXNxhRAjJuBfSHAUga21x";
			imageData64 += "e3H2SX0f5X4mH/nbCFXJIylNSjIrVuPk2W944rvr17Oh6w57lbHizzwNAFUzaL/Tvl1prTZJfj/5";
			imageData64 += "Dh904l+XrlMD8POYJL9n1VAP9A8FIMW7m3qkvwOAmHd+j3YumzlhwhaFYJcmsAwRW0/93X0fgilP";
			imageData64 += "TQj24020UI/0vwdAVgmKTMwVBbYqrsZokjxZGFjJ6JeX9u87fe99Rj4iKZGsqFOufElLDbScItT3";
			imageData64 += "YtzrdFeWhGCSTI2LzDHvlu8oAxO1adlJZfLWsFvnnySTlKf37MK646/evo+Ny4wPv7f66ofYVDkp";
			imageData64 += "SybJuMScnwGLfdoNXFHO+uH1eUsbnCbJSOPKJG9rmqy1c24ulpWVmFacoKL29qmWyi21Smhpl2le";
			imageData64 += "f8z01qQ8eH1r83SVfWI7i87t65crZKrRn4zbMXzQQcV2EZtKyvtMIV+dj5CmJSemykjy3ojGdT2q";
			imageData64 += "1u7RqLp75YY9Ru1OIknZunlLl6xYMWfq/ENPly0sN0lVirjQcUCbNo0a1W08XJBRQgXRMXReq+NP";
			imageData64 += "Z7Zp5F2tUcM+E24pVXKAZtszMlJ+uLkpAMfR/lzvWKF6s+6dO/l0DWgAABomZkWv8MPWgZ5ly7We";
			imageData64 += "rzS11wM0TEvWrFHR1ekVOc3QemJSruwBlfGcfCqqOUsXl5HtsYujUbRezwaoOKJn8yqFy6nkkO6B";
			imageData64 += "myST7CqRZGLa+wXVdWHRYKSy1nuMCyCxcG3Z0nkMOQnQxFKSDJlVWatiFOmu/4l1YejsbGfj4Phr";
			imageData64 += "BOdoQL+kayEAsLWWAGYPSTK+mMIwq20E6KGUShndDYBEVxM69hoFH5HkSINgkkstgNZtoGUg0bB0";
			imageData64 += "stSbKF5817TAmjbaKH+Ob/RgO2DFMCfYxOyCrqamhkRH4vDQG2MnzRvYsqrX2ycFYV61Wavy6Zrt";
			imageData64 += "VzPb1nQzBDQsK73eU0yzTBE0jckNABrgKukrqsarFkljsHYN8iSmkK80G5OkVHWCrsZukuG6dYUX";
			imageData64 += "tIVGo9MZvoxZ2BgVLyPTyFgHk6t+BS3DyafOsO87PJjshqf0QSkXt8pVvepUCtsFk3nvyUCvqRux";
			imageData64 += "hgGPL7wVtQZ7r7RFp3P3L5dAvVXXTtprn1BRXj14l1gbxzkMW0iyE24zvgf050WkhRwMCDYvGssk";
			imageData64 += "5YyVF6tM+o23NLrPFthBMmX/6Mjb+D002P9N+IdU9lKI+hyPoVKSAQYNmfFt1oYmchPQnfKVaJMb";
			imageData64 += "AMzHMfKOWJ2qhn0yD2IZ6Y82JD1Mv0q/fwB/kXwnqsibo9OX9WJHpRce24OJZEvc4H1HjBFQmofz";
			imageData64 += "9NYOE/nX+MI4LV57TWE2VNAKbCL/Qs1kkr5WFh8yNPbCcbbDM5JciknsAWNRUfJZJ0PCeqljY5L8";
			imageData64 += "BQfZVeEww8PpCdqHQOFkdAzTSMbUwokMP3QMO8lH+ib700hOylDNIKcA2INN5HGxTmlti3j+jiBS";
			imageData64 += "7uKURlY0/8q7aR9ukXwkDFeqC0r335dxaeyOD+mr6BNyFI6yH1xEGX4VdrKyleILTSxisH2TIOvf";
			imageData64 += "/MKqxaXYTHlV0XawQOEFoBy4UyzplEaSCaWNQ7doah9VqIwzmAei9DqRUb+gHdkOV8Xt/ChmpX8t";
			imageData64 += "C7cId/qhHVMOlvqyUNZ1rCIbi3ajgEwqunw/ANcxg1wEjy6j1hw+XsIiIbk4um8/faMqnlJWvMRX";
			imageData64 += "7MFChJC8JOY4PzujZ3E4/KkqrzfCqKuX/EjyibakXOW2ZbCYfhXQSnAb2YhtLO28slUH4ctbCcD4";
			imageData64 += "kKALnZnxh6bgFE8r6iheVfjFiNQRT2N061G0oSznTSeMSSbJ7ciQ2/2thtvCEYXRK45sC8cSJeus";
			imageData64 += "I3kMlQbMFJbziQAEm+BH7cbnnGH7ZbHKK9jL0xAr2bzJFQDuYzg5BCLP48YbEMu7r2OUQbOvLh+J";
			imageData64 += "DyS3Yp/yzJkaqKqyS1cBINj3BqFooQJmRphJxowwQJ9gkn/iiqwQAHEJk189etTaPoLkBJzJ+EMD";
			imageData64 += "8ICTcUn4Z4tyqRKoklmaL4YKx9uwmgxrg8afSA4UrTAKbY42AI8jJFkHRiZF9D1JrgdgLihG+2DB";
			imageData64 += "7v5HSDJUz3sOCvh9+bpLcYttIWpRZ2ankt83A3AbM8kOBn6Bd87vOWDizVF4/Xb3+NlLJc34BP2+";
			imageData64 += "ury1XgTJBbiiuizplVAybymFqj1YuSuVZIRVwQhpvPQiBpNkYB8Nw03kNLxLtkHX57fSK1SuxVyS";
			imageData64 += "NYwjMv5QS7M4dlHY2TwNMmw1UabV6Cuaxz46GQUJM6Z6LOlRKIO+8gEsteHzjmRK4RIRManxiST/";
			imageData64 += "wIJA8XF1C6cpF4IO8rICiKrUH+/ldu7CsZ+hhzwXALiIraSXTRJJRmh3prNQ+Unubph0Mr2YgpKa";
			imageData64 += "OaSRnA7RES3RT06yA5TVr+PMWotHu4UaqG8U1ezuVsUuNnLge2V9Vnm0nGSoUTUy4KvyZKWLyThK";
			imageData64 += "NItvSy8kve8WySuYz3A9oaZVS6yj+DVfYpRB+4z6TPx5pZlEZwEZpddEcXKoaBom6VZKcfQXpvKl";
			imageData64 += "O8q/zKjrKuPCGH3hTlnLL8qa5RAAa3GG9HCSkmSkTv+7on8c+yBwA258zbU6SUnOMBT9uebhz7e+";
			imageData64 += "OzQ9lZ9GcpGiV+6+C416v7O0sBqkFNcLZJKM5F78SpumvIGd4rVP9Hs8SwrdamAezj1Y+IVyXq8u";
			imageData64 += "Ge6B4X5pvGpYQcmNDepNsieukxWtI0mOVPjBfXQ1COIDpUVdoJdYTt6pgrYpYTr17t94+DEq5FgL";
			imageData64 += "bQclm+rZSXE0F0fJiHYomKFg8lP8SllJ5xRhw56dK4LYWLwiawleUVF63Scqvu05CPwTz7+6/Nx1";
			imageData64 += "knytcGx46AAA1rfTL6gGANo6MHCpJ6wG+xbzidXU92/m6hV8649evAavbt5ezZv2nPCkF2CqA5ej";
			imageData64 += "5Eh8YXDzhw/JmO4SFHSB/bN0OUx/x8W+cIgi/0L3qA+/omkSV++IjtpbFKvIjV/sJH5YSDJlIMac";
			imageData64 += "AwBoaUtQvVhRhcOT79jl98KFb2cQ/EjKZ6KCNMMGuZYcgYlpTPsdnXNHG7qxJ8m9oovStHPLW4iM";
			imageData64 += "z6NJPIiH/3h72LYJsw+rWkhfzJ4x+Ldf2vS+Kk9fjd+XBCRwf85r6Ex2BKBtYqxhdJ1XB/h025VI";
			imageData64 += "cnq9LySOIFOB73k+51fv8a/Tz78vA8D1lsAP6OqiSzKTSsLMCFYbSQ7HF9toK2ENa9nWt1vnjr0G";
			imageData64 += "dOw9/iiHt0tn6QCjirVrlTnP3gUEXc/vUPkxxi37REZWgGMrJwxJyx0AvtDpy1U+gMR7OVUGJ3bF";
			imageData64 += "0B67k8irWEamXjj5PDQu5tPfC/bBWSi/IpaOOyA6VP31S/P9JPl8cBW3QX4kubt5YqYvl6Iqq8iV";
			imageData64 += "bxx/fHZDJz0JnB7yhlioNWj814EdoeMdLKpns5Tx/6lFTHYn9v+tS8mRAf7/qGVLSs626Ultkvwv";
			imageData64 += "WMTUpAZADYCafhQAskxMha9W/745W9yaXJoYdPexijLv2fv/I5bhi1dJjkjKTQCiPgri6UeVcx+e";
			imageData64 += "RwrjevTyvYDX91TNw+er2NV9RlJGkkHj3pKx26tBoq9ahT4r1iHtzb1rj55dOZrmX7ekjQbQWSky";
			imageData64 += "vEJHkrK3T5IzuT9g/kHpF8/dNz34Wznh3VNmb7n4NusLYi58Fg4+Hz13796lvav6uFSOSm9+t6Su";
			imageData64 += "rZZlzaMkGX1729yOlTxbPPxeAFI3K3VcwckDdO6RDNPryNenjxy48jQkhHM1odfwJDkaACRQVcqf";
			imageData64 += "0ZbUc2wQyRcVrpLcg6mcVhCFF0UEaHZVXjOxWQIT244WBP+gRTdq//pL577DBk1bXlE0ON67Cy2n";
			imageData64 += "ZiNbYDqTXqaQ5J8YTX5qIkFvkmdLXVTpbMp0U6DWHZJvqgk234itx31guYUkQyf99vhLwGShYen/";
			imageData64 += "JNQXfnJp0Ktr2xZPn3fXr93IlatmjepYbYRM+K5bo9AbpY5aAgA6bdKnQFIpoF6PpgUxi9xrKgG0";
			imageData64 += "bO30vjtMNaVQR4XI5/DrAqwgeRdjAvSFvur21y49qb0d1nMwBkyZPWby6nSJN6Y0dvK6ltG5Q5hF";
			imageData64 += "8hQWvobp4hTyA/oqL/LGa56C6JM8DPvcFJZeXa9ebZv/Ono738OL5FEM5xb0SCU5HCfJX1DBDefI";
			imageData64 += "cRn07z3guPaYo90ncr/wJXwoDvxxxwFDyXgPwNwvsc5ekqHXpaTs0eIWRVE6XSz7Dc3v3z82vXsJ";
			imageData64 += "aAMAmj8R3lLbbOg6k1UkJ8FSDEgJ+WvReB3HpQeDg8/fTI/SelLYLIpMaqj/ictRYYvv56SURNl3";
			imageData64 += "L0HTJKIm/wKG3sUykhex/Sbq7T20YFzv2Y7ab8mPOq04WuNLd+wVmETyoUH1udhL8g3GJ2m1FLTb";
			imageData64 += "C5QXdYU/F0AX50iyNt7ynqH1uZtnt5gWUaylnzQbkVyGvZwGzCTZGb48g/LyXRhOTlbEYJLkcVQI";
			imageData64 += "JWP8ZeQsQV/VH21GbGdIRazlIlQ7YXQyXtub/FzCIpqpHQHzKr3TjQgbUEFY5u4ZGo06/vzt8w8c";
			imageData64 += "gz4HHwV+TuFWaKzmPpTblI53ok1V8nM9oGt6PoLahtEkpyCQ17+03v17AO4rDEgLsOcJFpA8gsN3";
			imageData64 += "FEtNHwQL5vkpEv8vvHM8rGJIsrlhU7wgGarRk5a1SXK8iqWgrySE2zHazJNkrLk7yapGUaS0uL0C";
			imageData64 += "gEiTktfj71oUiuA46Jq/IRvoh7MdLvEZmpI9VWvaN4fST7x1gXiSwXoV40ky0MQ92d3gBV+EywqX";
			imageData64 += "Z1R1LCMnoUoGV4GEkgqLTrxFA/HcFsGoT4aYAxVNTPxe4lfl2ly4GlOqoEpjaA9Q7InNDN+m0t/K";
			imageData64 += "TcqnaHLtyOXknAAgyXaAcNAPIbfQ5cGnyOm4cgYHGB9NcjoOHxylVzKOf6CAs/0ylftCdAUjRRtJ";
			imageData64 += "MW0/kjHGDVMtLaeuWTVZp3r6Vd0MY3gUq0fjHOmPhiTr60aQLI/mE5pPkpEMs4CGhTb+JDtYLsQQ";
			imageData64 += "ylysZc/gmso468LJrI307CwJNhWVx67lSHIVxOj5zlgk2guq2EfVwzLyGUpmjOC9h6pMSZGRDMEA";
			imageData64 += "JqaQ5A6sESINWcGmk4bdSfqiQ/q41OAi9EiVn6kFuyciANBzKG+DK6S/gdLq991cUC3RItHMVH4d";
			imageData64 += "gIYmcH8JbN2MHCPJyZBAUuEWuQ0O9paqxtbHGCu8sWVN7fck36NLmAEAwO5O+lXeNkk8hqXxJhVT";
			imageData64 += "eRMjSfaHHxlrDwDecpKvdSUSuN8n2ahwnFvB5Bj9apwBOHWfZKn7QeZQIF1FGqKh9AmJNuhBkh0V";
			imageData64 += "1sfZMDIWuJtOeq0wj+RFmLeZdVSFnXuqZVDExqbiPtJPp4KHldkMkp1hYV47kSRdndP8Q8kH6dtX";
			imageData64 += "ok0duht9IsmtEC1MdVBERwMYFscPei6/DZ/xNEcAGC35wJQUspKF/BoatukwrBGezEfpsq13S8ne";
			imageData64 += "0ECtOJJ78VyegQW+IdhPPuk36YK3JDdi9SsMmqmLKar7kqsruQ0bOAdruRPrSHbCO/K9RtWXz0LS";
			imageData64 += "BK5z6lJY3CBZqTRn4fw7tGIZgyraAHA5TruSimbWupHi8Lrw4y0U9sq+QGWKumRgEMnkXrYagI5P";
			imageData64 += "ukyxuUZVH28LzKCvFgrUrLaFZDdY1lghJ8kyxWQk+SzdAptaqJ2/+F9yIQ/hXDm3lE9P9zdFpaRI";
			imageData64 += "zRE5JgecwVE2rJXC0o68hKMkt+LSFIjMqbf1ZU/UiyY3fKlmDxC2obnYNhbPyEQ344gT2MBjxnoq";
			imageData64 += "rHFakbrkXFykrKpp+DycIFm7QDz52aDim7CYZLmcvIX93K9l+ZbxlrXojx6HMf0GWjDg8umJmBkA";
			imageData64 += "VZ+AJoaiu8tOHRwULEnCZEsrrQVRwz8JnuUEU3FS0IUVLVAvY6/jGiP4AUaKYt8aRU6IZPtyAler";
			imageData64 += "56UUuWwG3RTjlXdDVFSXEoZzDJZGY3COARCESe80cfwjGvE0dpI8g8kDNESJpLJVsqw3WpB7cY9k";
			imageData64 += "vP85RQhfuH4rku/NinM6LpLDsIpbsI3cpswMQTLerAvZF4HkBQwbgLtkgnVZiq4K+gXdSm3nLlwh";
			imageData64 += "N6B66hsMIFsa1ce+bcLi+hqd7mfwRNuELsIoVoAw8ufQgyR5Au10xU93Gt5E10r38Gqi+YWNvR1C";
			imageData64 += "zoq7cVr0AiEZzMfPIZKGijFTGPoSLPo+FOLWIx1LCrysvKiweweiRyjGk5SFvJOTM33OfRcAifau";
			imageData64 += "TYHynXCAZ7CM5AfTUT1wzPfKozsnwuoViGdaYyzgRVj/4l3JHHBSLMql3EhZR+znc41m7+eiKxlz";
			imageData64 += "PIakt4q/ykdMJcvZJJBsC32HePIdGpL8oOfoU66Uk53OIm7GY5JDcGcbtpMXJTD4PFFgzBLsCr+2";
			imageData64 += "0apStW5fkX2RNkbvcKnvCBtA4zEToyLD6mG8lIwpY3jTujZJhq8bhneMaYAO4jdeziSjmS3V2Y3r";
			imageData64 += "cZEpqYztVn8dzlEef9TC4w56Cu2rYDXjtfjt9JJZlowl2VXhGZPiWNSfZNp4DIjVbPXyzDIPbXTj";
			imageData64 += "DaDJ96kifIAZ84GqKbyJ9SQZklBLFJemn9tA8q2RF9+ZaQH6ruOOPFTImr2xaU1xtCY5BkANpY7i";
			imageData64 += "pIp3w3MspKxkdZL0KwAvkq/QhmSiw1BSmpocI+OjOlEkE05wPq6SbIQOfL1EkDmqW0vXWmppaaK0";
			imageData64 += "OJxhDWFor4ECY9qgrLu9kYF2Q1eU7NffGZvZCZMCHi8tYtgKT8iUfui5o7EveRl1FSqRB+9Ixk7G";
			imageData64 += "dE6BefFCRUqZ4PAu1PYpawitU5eVPhd/6GOjIGcaDOVoNLhyq44yIUeiM7Tc2w2sCNuPlwURrkK5";
			imageData64 += "UolhPr39vw+A7YUHp9HH4AUZf0nkbJ9PGzhm+dpVu8TPJyCI0jdBvm+iVSWBZyUA3U6fScpvbjyY";
			imageData64 += "Lq3IZ6SrguKXBZMvhU9qFvaTjO96hCSD0l2AFHt29B0pSb9h6bqal9fIhE8fAu8oWdG0Pc2dPTdH";
			imageData64 += "czOgY1PcudyGuFFmgPUx0s8FAKwvHBLWkDGSBpr6dStp6p1XrJh2mu4eJfXgFc7jxeqWcXdzaXSS";
			imageData64 += "ewAdhzoD7vFIuqvi6+tporTQirLeAAy2KTt0e2crEwBNP/BeBZcyLXYFy6WJOaGMk5KM88u2pvDz";
			imageData64 += "sfOh2bg87W2OxGtI5SRT7zwISUhLlZKM9n0VQ5KRq9q02RpFf/PjJCn3jbzeEEYdnyjvu+nt7O45";
			imageData64 += "+mIaKUsk5TK5nEy6fuejlCQf6ez56ofKNSF5Y9HijJ93zJsrp+JIytPkObUJ5zMKV+pupB8zrP9y";
			imageData64 += "WdZDJg9O/erco6Dv7YraIKO2iKkBUAOgBkANgJrUAKgBUJMaADUAalIDoAZATWoA1ACoSQ2AGgA1";
			imageData64 += "qQFQA6AmNQBqANSUywAYe9XzUtOPofrmUNMPpv8B9csenCWBzJoAAAAASUVORK5CYII=";
			
			StyleKitPlayer.__backgroundImage = imageData64;
		}
	}
}
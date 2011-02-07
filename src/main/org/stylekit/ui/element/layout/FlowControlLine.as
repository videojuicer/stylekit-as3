package org.stylekit.ui.element.layout
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.stylekit.StyleKit;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.FloatValue;
	import org.stylekit.css.value.IntegerValue;
	import org.stylekit.css.value.NumericValue;
	import org.stylekit.css.value.PositionValue;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.TextAlignValue;
	import org.stylekit.css.value.Value;
	import org.stylekit.ui.element.UIElement;
	
	/**
	* A FlowControlLine is used for the purposes of line wrapping and content flow control when laying out child elements
	* within another element. A single FlowControlLine is constrained to a specific width, and controls the layout of 
	* elements added to it. If the width is changed, UIElements are "ejected" and returned to the object that initiated the 
	* width change.
	*
	* A FlowControlLine may reject an appended element if there is not enough room on the line to accomodate it.
	*/
	public class FlowControlLine extends Sprite
	{
		public static var FLOW_DIRECTION_LEFT:String = "left";
		public static var FLOW_DIRECTION_RIGHT:String = "right";
		public static var FLOW_DIRECTION_CENTER:String = "center";
		
		protected var _elements:Vector.<UIElement>;
		protected var _maxWidth:Number;
		protected var _flowDirection:String;
		
		/**
		* Since each line may only contain a single non-floating block element, this flag will be set to TRUE when admitting
		* any elements that match the description, and false when removing them.
		*/
		protected var _occupiedByBlockElement:Boolean = false;
		/** 
		* Lines may also be marked 'occupied' by absolutely-positioned elements
		*/
		protected var _occupiedByAbsoluteElement:Boolean = false;
		
		protected var _leftFloatElementCount:uint = 0;
		protected var _rightFloatElementCount:uint = 0;
		protected var _elementTotalEffectiveWidth:uint = 0;
		protected var _elementHighestZIndex:Number = Number.NEGATIVE_INFINITY;
		
		/**
		* Instantiates a new line with the given flow direction (available options are left or right)
		* and the given constraining width.
		*
		* Note that flow direction does not alter the placement of blocks, only of text within those blocks.
		*/
		public function FlowControlLine(maxWidth:Number, flowDirection:String = "left")
		{
			super();
			
			this._flowDirection = flowDirection;
			this._maxWidth = maxWidth;
			
			this._occupiedByBlockElement = false;
			this._elements = new Vector.<UIElement>();
		}
		
		public function get elements():Vector.<UIElement>
		{
			return this._elements;
		}
		
		public function get occupiedBySingleElement():Boolean
		{
			return (this.occupiedByAbsoluteElement || this.occupiedByBlockElement);
		}
		
		public function get occupiedByBlockElement():Boolean
		{
			return this._occupiedByBlockElement;
		}
		
		public function get occupiedByAbsoluteElement():Boolean
		{
			return this._occupiedByAbsoluteElement;
		}
		
		public function get lineHeight():Number
		{
			var h:int = 0;
			
			for(var i:uint=0; i < this._elements.length; i++)
			{
				var e:UIElement = this._elements[i];
				
				// TODO: should include the relative height but only the amount that exists inside the current box
				if(e.effectiveHeight > h && (e.getStyleValue("position") as PositionValue).position != PositionValue.POSITION_ABSOLUTE && (e.getStyleValue("display") as DisplayValue).display != DisplayValue.DISPLAY_NONE)
				{
					h = e.effectiveHeight;
				}
			}
			
			return h;
		}
		
		// clears the line, removing all elements and resetting all counters
		public function clear():void
		{
			for(var i:uint = 0; i < super.numChildren; i++)
			{
				// remove sprites
				super.removeChildAt(i);
			}
			
			this._elements = new Vector.<UIElement>();
			this._occupiedByBlockElement = false;
			this._elementTotalEffectiveWidth = 0;
			this._leftFloatElementCount = 0;
			this._rightFloatElementCount = 0;
		}
		
		public function setMaxWidth(w:Number):Vector.<UIElement>
		{
			if(w < this._maxWidth)
			{
				// shrinking the line - attempt to refund elements
				this._maxWidth = w;
				var oldElements:Vector.<UIElement> = this._elements;

				this.clear();

				// loop over oldElements list, append each
				var addedToIndex:int = -1; // elements added up to but not including this index
				while((addedToIndex < oldElements.length-1) && (this.appendElement(oldElements[addedToIndex+1])))
				{
					addedToIndex++;
				}

				// when full, return remainder of the element list
				this.layoutElements();
				return ((addedToIndex < 0)? oldElements : oldElements.slice(addedToIndex+1));
			}
			else
			{
				// growing the line - refund an empty vector
				this._maxWidth = w;
				this.layoutElements();
				return new Vector.<UIElement>();
			}
		}
		
		/**
		* Attempts to append an element to the line, returning true if the element was accepted.
		*/
		public function appendElement(e:UIElement):Boolean
		{
			var added:Boolean = false;
			
			//StyleKit.logger.debug("appendElement >> ", e, e.effectiveContentWidth, e.effectiveContentHeight, e.effectiveWidth, e.effectiveHeight);
			//StyleKit.logger.debug("appendElement >> ", this, this._maxWidth, this.elements.length, this._elementTotalEffectiveWidth, this._leftFloatElementCount, this._rightFloatElementCount);
			
			if (this.treatElementAsAbsolute(e))
			{
				if(!this.occupiedBySingleElement)
				{
					added = true;
					this._occupiedByAbsoluteElement = true;
				}
			}
			else if(this.treatElementAsNonFloatedBlock(e))
			{
				if(!this.occupiedBySingleElement && (this._elements.length == (this._leftFloatElementCount + this._rightFloatElementCount)))
				{
					// BLOCK ELEMS
					added = true;					
					this._occupiedByBlockElement = true;
				}
			}
			else if(!this.occupiedBySingleElement)
			{
				if(this.treatElementAsLeftFloat(e) && this.widthAvailableForElement(e))
				{
					// LEFT FLOATS
					added = true;
					
					this._leftFloatElementCount++;
				}
				else if(this.treatElementAsRightFloat(e) && this.widthAvailableForElement(e))
				{
					// RIGHT FLOATS
					added = true;
					
					this._rightFloatElementCount++;
				}
				else
				{
					// INLINE ELEMS
					if(this.widthAvailableForElement(e))
					{
						added = true;
					}
				}
			}
			
			if (this.elements.length == 0)
			{
				added = true;
			}

			if (added)
			{
				this._elements.push(e);
				
				if ((e.getStyleValue("display") as DisplayValue).display != DisplayValue.DISPLAY_NONE && !e.flexible)
				{
					this._elementTotalEffectiveWidth += e.effectiveWidth;
				}
				
				//this.layoutElements();
				this.recalculateZIndex();				
				this.refreshFlexibles();
			}

			return added;
		}
		
		protected function refreshFlexibles():void
		{
			for (var i:int = 0; i < this._elements.length; i++)
			{
				var element:UIElement = this._elements[i];
				
				if (element.flexible)
				{
					element.recalculateEffectiveContentDimensions();
				}
			}
		}
		
		/**
		* Pushes an element onto the beginning of the line, forcibly admitting it to the line and returning a vector
		* of UIElements that were pushed off the line.
		*/
		public function prependElements(prependVector:Vector.<UIElement>):Vector.<UIElement>
		{
			var oldElements:Vector.<UIElement> = this._elements;
			
			this.clear();
			
			// prepend elements to the oldElements list
			oldElements = prependVector.concat(oldElements);
			
			// loop over oldElements list, append each
			var addedToIndex:int = -1; // elements added up to but not including this index
			while((addedToIndex < oldElements.length-1) && (this.appendElement(oldElements[addedToIndex+1])))
			{
				addedToIndex++;
			}

			// when full, return remainder of the element list
			//this.layoutElements();
			return ((addedToIndex < 0)? oldElements : oldElements.slice(addedToIndex+1));
		}
		
		/*
		* Attempts to shift elements from the beginning of the element list into the given line. Any that are successfully appended
		* to the given line will be removed from this line.
		*/
		public function shiftElementsToLine(destinationLine:FlowControlLine):void
		{
			for(var i:uint=0; i < this._elements.length; i++)
			{
				var e:UIElement = this._elements[i];
				if(destinationLine.appendElement(e))
				{
					// Remove the element from this line if the addition was successful
					this.removeElement(e);
				}
				else
				{
					// End the loop when the given line stops accepting elements
					break;
				}
			}
		}
		
		/**
		* Removes an element from all internal lists on this line and removes it from the display.
		*/
		public function removeElement(e:UIElement):void
		{
			var lists:Array = [this._elements];
			for(var i:uint=0; i < lists.length; i++)
			{
				var f:int = lists[i].indexOf(e);
				if(f > -1)
				{
					(lists[i] as Vector.<UIElement>).splice(f, 1);
					
					this._elementTotalEffectiveWidth -= e.effectiveWidth;
					
					if(this.treatElementAsNonFloatedBlock(e))
					{
						this._occupiedByBlockElement = false;
					}
					else if(this.treatElementAsLeftFloat(e))
					{
						this._leftFloatElementCount--;
					}
					else if(this.treatElementAsRightFloat(e))
					{
						this._rightFloatElementCount--;
					}
				}
			}
		}
		
		public function get highestZIndex():Number
		{
			return (this._elementHighestZIndex != Number.NEGATIVE_INFINITY)? this._elementHighestZIndex : 0;
		}
		
		protected function recalculateZIndex():void
		{
			this._elementHighestZIndex = Number.NEGATIVE_INFINITY;
			for (var i:int = 0; i < this._elements.length; i++)
			{
				var zIndex:int = (this._elements[i].getStyleValue("z-index") as IntegerValue).value;
				
				if (zIndex > this._elementHighestZIndex)
				{
					this._elementHighestZIndex = zIndex;
				}
			}
		}
		
		/*
		* Actually performs the layout of all elements on this line.
		*/
		public function layoutElements():void
		{
			// clear the canvas before we draw again, just incase we havent been recreated
			// from scratch
			for (var r:int = 0; r < this._elements.length; r++)
			{
				if (super.contains(this._elements[r]))
				{
					super.removeChild(this._elements[r]);
				}
			}
			
			var leftFloatXCollector:int = 0;
			var rightFloatXCollector:int = 0;
			
			var leftEdgeCollector:int = 0;
			var rightEdgeCollector:int = 0;
			
			var textAlign:uint = TextAlignValue.TEXT_ALIGN_CENTER;
			
			// sort elements by there z-index
			//this._elements.sort(this.sortElementsByZIndex);
			
			var highestZIndex:Number = 0;
			var highest0Index:Number = 0;
			
			var sortedChildren:Vector.<UIElement> = new Vector.<UIElement>();
			
			for (var i:uint = 0; i < this._elements.length; i++)
			{
				var e:UIElement = this._elements[i];
				
				// if the element is a block, give it 0,0
				// if the element is left floated, rack it up against the existing left floats
				// if the element is right floated, rack it up against the existing right floats
				// if the element is inline, wait for all floats to be processed and then treat this element as a float in the flowDirection of this line.
				
				var displayValue:DisplayValue = (e.getStyleValue("display") as DisplayValue);
				var floatValue:FloatValue = (e.getStyleValue("float") as FloatValue);
				var positionValue:PositionValue = (e.getStyleValue("position") as PositionValue);
				
				if (displayValue.display == DisplayValue.DISPLAY_NONE)
				{
					//StyleKit.logger.debug("FlowControlLine - skipping UIElement due to display being set to none", e);
					
					continue;
				}
				
				//StyleKit.logger.debug("FlowControlLine - adding UIElement to line contents", e);
				
				var zIndex:int = (e.getStyleValue("z-index") as IntegerValue).value;
				var insertIndex:int = 0;
				
				// the current z-index is higher than we have ever seen, so we can stick it at the end
				if (zIndex >= highestZIndex)
				{
					insertIndex = super.numChildren;
					
					highestZIndex = zIndex;
				}
				// the current z-index is lower than our highest, so we need to work out where it sits
				else
				{
					var highest:int = super.numChildren;
					
					for (var m:int = 0; m < super.numChildren; m++)
					{
						var display:DisplayObject = super.getChildAt(m);
						
						if (display is UIElement)
						{
							var element:UIElement = (display as UIElement);
							var elementIndex:int = (element.getStyleValue("z-index") as IntegerValue).value;
							
							if (zIndex <= elementIndex)
							{
								highest = m;
								
								break;
							}
						}
					}
					
					insertIndex = highest;
				}

				super.addChildAt(e, insertIndex);

				var marginLeft:SizeValue = (e.getStyleValue("margin-left") as SizeValue);
				var marginRight:SizeValue = (e.getStyleValue("margin-right") as SizeValue);
				var marginTop:SizeValue = (e.getStyleValue("margin-top") as SizeValue);
				var marginBottom:SizeValue = (e.getStyleValue("margin-bottom") as SizeValue);
				
				var marginLeftBump:Number = (marginLeft.auto ? ((this._maxWidth / 2) - (e.effectiveWidth / 2)) : 0);
				var marginRightBump:Number = (marginRight.auto ? ((this._maxWidth / 2) - (e.effectiveWidth / 2)) : 0);
				var marginTopBump:Number = (marginTop.auto ? ((e.parentElement.effectiveContentHeight / 2) - (e.effectiveHeight / 2)) : 0);
				var marginBottomBump:Number = (marginBottom.auto ? ((e.parentElement.effectiveContentHeight / 2) - (e.effectiveHeight / 2)) : 0);
				
				e.x = marginLeftBump;
				e.y = marginTopBump;

				if (positionValue.position == PositionValue.POSITION_ABSOLUTE)
				{
					var relativeParent:UIElement = null;
					var parent:UIElement = e.parentElement;
					
					do
					{
						var parentPosition:PositionValue = parent.getStyleValue("position") as PositionValue;
						
						if (parentPosition.position != PositionValue.POSITION_STATIC || parent == e.baseUI)
						{
							relativeParent = parent;
						}
						else
						{
							parent = parent.parentElement;
						}
					}
					while (relativeParent == null);
					
					var parentOriginPoint:Point = relativeParent.calculateInsideBorderOriginPoint();
					var parentExtentPoint:Point = relativeParent.calculateInsideBorderExtentPoint();
					
					// The parent's absolute positioning anchors, made local to this sprite
					var originPoint:Point = this.globalToLocal(relativeParent.localToGlobal(parentOriginPoint)); // top/left
					var extentPoint:Point = this.globalToLocal(relativeParent.localToGlobal(parentExtentPoint)); // bottom/right

					if (e.hasStyleProperty("left") && !isNaN(e.evalStyleSize("left", SizeValue.DIMENSION_WIDTH)))
					{
						e.x = originPoint.x + (e.evalStyleSize("left", SizeValue.DIMENSION_WIDTH));
					}
					
					if (e.hasStyleProperty("right") && !isNaN(e.evalStyleSize("right", SizeValue.DIMENSION_WIDTH)))
					{
						e.x = extentPoint.x - (e.effectiveWidth + e.evalStyleSize("right", SizeValue.DIMENSION_WIDTH));
					}
					
					if (e.hasStyleProperty("top") && !isNaN(e.evalStyleSize("top", SizeValue.DIMENSION_HEIGHT)))
					{
						e.y = originPoint.y + e.evalStyleSize("top", SizeValue.DIMENSION_HEIGHT);
					}

					if (e.hasStyleProperty("bottom") && !isNaN(e.evalStyleSize("bottom", SizeValue.DIMENSION_HEIGHT)))
					{
						e.y = extentPoint.y - (e.effectiveHeight + e.evalStyleSize("bottom", SizeValue.DIMENSION_HEIGHT));
					}
					
				}
				else if (floatValue.float == FloatValue.FLOAT_LEFT)
				{
					e.x = leftFloatXCollector;
					
					leftFloatXCollector += e.effectiveWidth + marginLeftBump;
				}
				else if (floatValue.float == FloatValue.FLOAT_RIGHT)
				{
					e.x = (this._maxWidth - e.effectiveWidth - rightFloatXCollector) - marginRightBump;
					
					rightFloatXCollector += e.effectiveWidth;
				}
				else
				{
					if (displayValue.display == DisplayValue.DISPLAY_BLOCK)
					{
						e.x = leftFloatXCollector + marginLeftBump;
						
						leftEdgeCollector += e.effectiveWidth;
					}
					else if (displayValue.display == DisplayValue.DISPLAY_INLINE)
					{
						if (this._flowDirection == FlowControlLine.FLOW_DIRECTION_CENTER)
						{
							e.x = (this._maxWidth / 2) - (e.effectiveWidth / 2);
						}
						else
						if (this._flowDirection == FlowControlLine.FLOW_DIRECTION_RIGHT)
						{
							e.x = (this._maxWidth - rightEdgeCollector) - marginRightBump;
							
							rightEdgeCollector += e.effectiveWidth;
						}
						else
						{
							e.x = leftEdgeCollector + leftFloatXCollector + marginLeftBump;
							
							leftEdgeCollector += e.effectiveWidth;
						}
					}
				}
				
				if (positionValue.position == PositionValue.POSITION_RELATIVE)
				{
					// we've positioned the element as normal, now we adjust relative to our current position
					if (e.hasStyleProperty("left") && !isNaN(e.evalStyleSize("left", SizeValue.DIMENSION_WIDTH)))
					{
						e.x = e.x + e.evalStyleSize("left", SizeValue.DIMENSION_WIDTH);
					}
					
					if (e.hasStyleProperty("right") && !isNaN(e.evalStyleSize("right", SizeValue.DIMENSION_WIDTH)))
					{
						e.x = e.x - e.evalStyleSize("right", SizeValue.DIMENSION_WIDTH);
						//e.x = (e.parentElement.effectiveWidth - e.effectiveWidth)  - e.evalStyleSize("right", SizeValue.DIMENSION_WIDTH);
					}
					
					if (e.hasStyleProperty("top") && !isNaN(e.evalStyleSize("top", SizeValue.DIMENSION_HEIGHT)))
					{
						e.y = e.y + e.evalStyleSize("top", SizeValue.DIMENSION_HEIGHT);
					}
					
					if (e.hasStyleProperty("bottom") && !isNaN(e.evalStyleSize("bottom", SizeValue.DIMENSION_HEIGHT)))
					{
						e.y = e.y - e.evalStyleSize("bottom", SizeValue.DIMENSION_HEIGHT);
						//e.y = ((e.parentElement.effectiveHeight - e.effectiveHeight) - (e.evalStyleSize("bottom", SizeValue.DIMENSION_HEIGHT) * 2));
					}
				}

				e.recalculateEffectiveContentDimensions();
				//e.layoutChildren();

				StyleKit.logger.debug("Adding UIElement to FlowControlLine contents ... "+e.x+"/"+e.y, e);
			}
		}
			
		public function treatElementAsAbsolute(e:UIElement):Boolean
		{
			return (e.hasStyleProperty("position") && (e.getStyleValue("position") as PositionValue).position == PositionValue.POSITION_ABSOLUTE);
		}

		public function treatElementAsNonFloatedBlock(e:UIElement):Boolean
		{
			if(e.hasStyleProperty("display") && (e.getStyleValue("display") as DisplayValue).display >= DisplayValue.DISPLAY_BLOCK && (e.getStyleValue("position") as PositionValue).position != PositionValue.POSITION_ABSOLUTE)
			{
				if((!e.hasStyleProperty("float")) || ((e.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_NONE))
				{
					return true;
				}
			}
			return false;
		}
		
		public function widthAvailableForElement(e:UIElement):Boolean
		{
			return ((this._maxWidth - this._elementTotalEffectiveWidth) >= e.effectiveWidth);
		}		
		
		public function treatElementAsLeftFloat(e:UIElement):Boolean
		{
			return (e.hasStyleProperty("float") && (e.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_LEFT);
		}
		
		public function treatElementAsRightFloat(e:UIElement):Boolean
		{
			return (e.hasStyleProperty("float") && (e.getStyleValue("float") as FloatValue).float == FloatValue.FLOAT_RIGHT);
		}
		
		public function elementIsClearedLeft(e:UIElement):Boolean
		{
			return (e.hasStyleProperty("clear") && ((e.getStyleValue("clear") as Value).stringValue == "left" || (e.getStyleValue("clear") as Value).stringValue == "both"));
		}
		
		public function elementIsClearedRight(e:UIElement):Boolean
		{
			return (e.hasStyleProperty("clear") && ((e.getStyleValue("clear") as Value).stringValue == "right" || (e.getStyleValue("clear") as Value).stringValue == "both"));
		}
	}
}
package org.stylekit.ui.element.layout
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.stylekit.css.value.DisplayValue;
	import org.stylekit.css.value.FloatValue;
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
		
		protected var _elements:Vector.<UIElement>;
		protected var _maxWidth:Number;
		protected var _flowDirection:String;
		
		/**
		* Since each line may only contain a single non-floating block element, this flag will be set to TRUE when admitting
		* any elements that match the description, and false when removing them.
		*/
		protected var _occupiedByBlockElement:Boolean = false;
		
		protected var _leftFloatElementCount:uint = 0;
		protected var _rightFloatElementCount:uint = 0;
		protected var _elementTotalEffectiveWidth:uint = 0;
		
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
			
			this._elements = new Vector.<UIElement>();
			
			//this.setMaxWidth(maxWidth);
		}
		
		public function get elements():Vector.<UIElement>
		{
			return this._elements;
		}
		
		public function get lineHeight():Number
		{
			var h:int = 0;
			for(var i:uint=0; i < this._elements.length; i++)
			{
				var e:UIElement = this._elements[i];
				if(e.effectiveHeight > h) h = e.effectiveHeight;
			}
			return h;
		}
		
		// clears the line, removing all elements and resetting all counters
		public function clear():void
		{
			for(var i:uint=0; i < this._elements.length; i++)
			{
				// remove sprites
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
		
		public function acceptableElement(e:UIElement):Boolean
		{
			var added:Boolean = false;
			
			if(this.treatElementAsNonFloatedBlock(e))
			{
				if(this._occupiedByBlockElement == false)
				{
					// BLOCK ELEMS
					added = true;
					this._occupiedByBlockElement = true;
				}
			}
			else if(this._occupiedByBlockElement == false)
			{
				if(this.treatElementAsLeftFloat(e))
				{
					// LEFT FLOATS
					if(this.widthAvailableForElement(e))
					{
						added = true;
						this._leftFloatElementCount++;
					}
				}
				else if(this.treatElementAsRightFloat(e))
				{
					// RIGHT FLOATS
					if(this.widthAvailableForElement(e))
					{
						added = true;
						this._rightFloatElementCount++;
					}
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
			
			return added;
		}
		
		/**
		* Attempts to append an element to the line, returning true if the element was accepted.
		*/
		public function appendElement(e:UIElement):Boolean
		{
			var added:Boolean = this.acceptableElement(e);
			
			if(added) 
			{
				this._elements.push(e);
				this._elementTotalEffectiveWidth += e.effectiveWidth;
				//this.layoutElements();
			}
			return added;
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
		
		/*
		* Actually performs the layout of all elements on this line.
		*/
		public function layoutElements():void
		{
			var leftFloatXCollector:int = 0;
			var rightFloatXCollector:int = 0;
			
			for(var i:uint = 0; i < this._elements.length; i++)
			{
				var e:UIElement = this._elements[i];
				
				// if the element is a block, give it 0,0
				// if the element is left floated, rack it up against the existing left floats
				// if the element is right floated, rack it up against the existing right floats
				// if the element is inline, wait for all floats to be processed and then treat this element as a float in the flowDirection of this line.
				
				trace("Adding UIElement to FlowControlLine contents ...", e);
				
				super.addChild(e);
			}
		}
		
		public function treatElementAsNonFloatedBlock(e:UIElement):Boolean
		{
			if(e.hasStyleProperty("display") && (e.getStyleValue("display") as DisplayValue).display >= DisplayValue.DISPLAY_BLOCK)
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
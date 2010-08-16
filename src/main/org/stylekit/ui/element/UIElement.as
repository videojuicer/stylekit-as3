package org.stylekit.ui.element
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.ui.BaseUI;
	
	/**
	 * Dispatched when the effective dimensions are changed on the UI element.
	 *
	 * @eventType org.stylekit.events.UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED
	 */
	[Event(name="uiElementEffectiveDimensionsChanged", type="org.stylekit.events.UIElementEvent")]
	
	public class UIElement extends Sprite
	{
		protected var _children:Vector.<UIElement>;
		
		protected var _styleEligible:Boolean = false;
		
		protected var _effectiveWidth:int;
		protected var _effectiveHeight:int;
		protected var _contentWidth:int;
		protected var _contentHeight:int;

		protected var _parentElement:UIElement;
		protected var _baseUI:BaseUI;
		protected var _localStyle:Style;
		
		public function UIElement()
		{
			super();
			
			this._children = new Vector.<UIElement>();
		}
		
		public function get parentElement():UIElement
		{
			return this._parentElement;
		}
		
		public function get baseUI():BaseUI
		{
			return this._baseUI;
		}
		
		public function get localStyle():Style
		{
			return this._localStyle;
		}
		
		public function get styleEligible():Boolean
		{
			return this._styleEligible;
		}
		
		public function get effectiveWidth():int
		{
			return this._effectiveWidth;
		}
		
		public function get effectiveHeight():int
		{
			return this._effectiveHeight;
		}
		
		public function get contentWidth():int
		{
			return this._contentWidth;
		}
		
		public function get contentHeight():int
		{
			return this._contentHeight;
		}
		
		public function get children():Vector.<UIElement>
		{
			return this._children;
		}
		
		public override function get numChildren():int
		{
			return this._children.length;
		}
		
		public function get firstChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[0];
			}
			
			return null;
		}
		
		public function get lastChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[this._children.length - 1];
			}
			
			return null;
		}
		
		public function layoutChildren():void
		{
			
		}
		
		public function redraw():void
		{
			
		}
		
		public function addElement(child:UIElement):UIElement
		{
			return this.addElementAt(child, this._children.length);
		}
		
		public function addElementAt(child:UIElement, index:int):UIElement
		{
			if (child.baseUI != null && child.baseUI != this)
			{
				throw new IllegalOperationError("Child belongs to a different BaseUI, cannot add to this UIElement");
			}
			
			child._parentElement = this;
			child._baseUI = this.baseUI;
			
			child.addEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			if (index < this._children.length)
			{
				this._children.splice(index, 0, child);
			}
			else
			{
				this._children.push(child);
			}
			
			return child;
		}
		
		public function removeElement(child:UIElement):UIElement
		{
			var index:int = this._children.indexOf(child);
			
			return this.removeElementAt(index);
		}
		
		public function removeElementAt(index:int):UIElement
		{
			if (index == -1)
			{
				throw new IllegalOperationError("Child does not exist within the UIElement");
			}
			
			var child:UIElement = this._children[index];
			
			child.removeEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			child._parentElement = null;
			child._baseUI = null;
			
			this._children.splice(index, 1);
			
			return child;
		}
		
		protected function onChildDimensionsChanged(e:UIElementEvent):void
		{
			this.layoutChildren();
		}
		
		/* Overrides to block the Flash methods when they called outside of this class */
		
		/**
		 * @see UIElement.addElement
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method addChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.addElementAt
		 */
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new IllegalOperationError("Method addChildAt not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElement
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method removeChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElementAt
		 */
		public override function removeChildAt(index:int):DisplayObject
		{
			throw new IllegalOperationError("Method removeChildAt not accessible on a UIElement");
		}
	}
}
package org.stylekit.css.style.selector
{
	
	public class ElementSelector
	{
		
		/**
		* The element name required to match this selector. In the selector string "div.clear", the elementName is "div".
		*/ 
		protected var _elementName:String;
		
		/**
		* The element ID required to match this selector. In the selector strings "p#intro" or "#intro", the elementID is "intro".
		*/
		protected var _elementID:String;
		
		/**
		* The element classes required to match this selector. With an example selector string "div.clear", the className "clear" is required to
		* match the selector. In the selector ".one.two", both the element must have both "one" and "two" as classNames in order to match
		* the selector.
		*/
		protected var _elementClassNames:Vector.<String>;
		
		/**
		* The element pseudoclasses required to match this selector. With an example selector string "div:hover", a div element must have the "hover"
		* pseudoclass in order to match the selector.
		*/
		protected var _elementPseudoClasses:Vector.<String>;
		
		/**
		* A selector which the element's direct style parent must match in order to match the selector. With an example selector chain string "a:hover > em",
		* an "em" element's direct style parent must be an "a" element with the pseudoclass "hover" in order for the "em" element to match the selector.
		*/
		protected var _parentSelector:ElementSelector;
		
		/**
		* A flag that, when set to <code>true</code>, requires the element to be the last child element within its style parent in order for it to match the selector.
		*/
		protected var _specifiesLastChild:Boolean = false;
		
		/**
		* A flag that, when set to <code>true</code>, requires the element to be the first child element within its style parent in order for it to match the selector.
		*/
		protected var _specifiesFirstChild:Boolean = false;
		
		/**
		* A flag that, when set to <code>true</code>, limits the style application to the first letter of any text in the style container.
		*/
		protected var _firstLetterOnly:Boolean = false;
		
		/**
		* A flag that, when set to <code>true</code>, limits the style application to the last letter of any text in the style container.
		*/
		protected var _lastLetterOnly:Boolean = false;
		
		/**
		* A flag that, when set to <code>false</code>, allows the selector to match elements of any name. This may be achieved through using the "*" wildcard in a selector,
		* or by specifying a selector that omits the element name such as ":hover" or ".okbutton"
		*/
		protected var _elementNameMatchRequired:Boolean = true;
		
		public function ElementSelector()
		{
			this._elementClassNames = new Vector.<String>();
			this._elementPseudoClasses = new Vector.<String>();
		}
		
		public function get elementName():String
		{
			return this._elementName;
		}
		
		public function set elementName(s:String):void
		{
			this._elementName = s;
		}
		
		public function get elementID():String
		{
			return this._elementID;
		}
		
		public function set elementID(s:String):void
		{
			this._elementID = s;
		}
		
		public function get elementClassNames():Vector.<String>
		{
			return this._elementClassNames;
		}
		
		public function get elementPseudoClasses():Vector.<String>
		{
			return this._elementPseudoClasses;
		}
		
		public function set elementPseudoClasses(v:Vector.<String>):void
		{
			this._elementPseudoClasses = v;
		}
		
		public function get parentSelector():ElementSelector
		{
			return this._parentSelector;
		}
		
		public function set parentSelector(e:ElementSelector):void
		{
			this._parentSelector = e;
		}
		
		public function get specifiesLastChild():Boolean
		{
			return this._specifiesLastChild;
		}
		
		public function set specifiesLastChild(b:Boolean):void
		{
			this._specifiesLastChild = b;
		}
		
		public function get specifiesFirstChild():Boolean
		{
			return this._specifiesFirstChild;
		}
		
		public function set specifiesFirstChild(b:Boolean):void
		{
			this._specifiesFirstChild = b;
		}
		
		public function get firstLetterOnly():Boolean
		{
			return this._firstLetterOnly;
		}
		
		public function set firstLetterOnly(b:Boolean):void
		{
			this._firstLetterOnly = b;
		}
		
		public function get lastLetterOnly():Boolean
		{
			return this._lastLetterOnly;
		}
		
		public function set lastLetterOnly(b:Boolean):void
		{
			this._lastLetterOnly = b;
		}
		
		public function get elementNameMatchRequired():Boolean
		{
			return this._elementNameMatchRequired;
		}
		
		public function set elementNameMatchRequired(b:Boolean):void
		{
			this._elementNameMatchRequired = b;
		}
		
		public function hasElementClassName(className:String):Boolean
		{
			return (this._elementClassNames.indexOf(className) > -1);
		}
		
		public function addElementClassName(className:String):Boolean
		{
			if(this.hasElementClassName(className))
			{
				return false;
			}
			
			this._elementClassNames.push(className);			
			return true;
		}
		
		public function removeElementClassName(className:String):Boolean
		{
			if(this.hasElementClassName(className))
			{
				this._elementClassNames.splice(this._elementClassNames.indexOf(className), 1);
				return true;
			}
			return false;
		}
		
		public function hasElementPseudoClass(className:String):Boolean
		{
			return (this._elementPseudoClasses.indexOf(className) > -1);
		}

		public function addElementPseudoClass(className:String):Boolean
		{
			if(this.hasElementPseudoClass(className))
			{
				return false;
			}

			this._elementPseudoClasses.push(className);
			
			if(className == "last-child")
			{
				this._specifiesLastChild = true;
			} 
			else if(className == "first-child")
			{
				this._specifiesFirstChild = true;
			}
			else if(className == "last-letter")
			{
				this._lastLetterOnly = true;
			}
			else if(className == "first-letter")
			{
				this._firstLetterOnly = true;
			}
			
			return true;
		}

		public function removeElementPseudoClass(className:String):Boolean
		{
			if(this.hasElementPseudoClass(className))
			{
				this._elementPseudoClasses.splice(this._elementPseudoClasses.indexOf(className), 1);
				
				if(className == "last-child")
				{
					this._specifiesLastChild = false;
				} 
				else if(className == "first-child")
				{
					this._specifiesFirstChild = false;
				}
				else if(className == "last-letter")
				{
					this._lastLetterOnly = false;
				}
				else if(className == "first-letter")
				{
					this._firstLetterOnly = false;
				}
				
				return true;
			}
			return false;
		}
	}
	
}
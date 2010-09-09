package org.stylekit.css {
	
	/**
	* A StyleSheet object represents an individual package of CSS styles, usually parsed from a String input.
	* Each StyleSheet object is expected to belong to a <code>StyleSheetCollection</code> instance before it may be
	* queried.
	*/ 
	import flash.events.EventDispatcher;
	
	import org.stylekit.css.style.Animation;
	import org.stylekit.css.style.FontFace;
	import org.stylekit.css.style.Import;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.PropertyContainerEvent;
	import org.stylekit.events.StyleSheetEvent;
	
	public class StyleSheet extends EventDispatcher
	{
		
		protected var _styles:Vector.<Style>;
		protected var _fontFaces:Vector.<FontFace>;
		protected var _animations:Vector.<Animation>;
		protected var _imports:Vector.<Import>;
		
		public function StyleSheet()
		{
			this._styles = new Vector.<Style>();
			this._fontFaces = new Vector.<FontFace>();
			this._animations = new Vector.<Animation>();
			this._imports = new Vector.<Import>();
		}
		
		public function get styles():Vector.<Style>
		{
			return this._styles;
		}
		
		public function get fontFaces():Vector.<FontFace>
		{
			return this._fontFaces;
		}
		
		public function get animations():Vector.<Animation>
		{
			return this._animations;
		}
		
		public function get imports():Vector.<Import>
		{
			return this._imports;
		}
		
		public function hasStyle(s:Style):Boolean
		{
			return (this._styles.indexOf(s) > -1);
		}
		
		public function addStyle(s:Style, atIndex:int=-1):Boolean
		{
			if(this.hasStyle(s))
			{
				return false;
			}
			
			this._styles.splice(atIndex, 0, s);
			
			this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
			
			return true;
		}
		
		/**
		* Removes a <code>Style</code> object from the Stylesheet.
		* @return A boolean, true if the <code>Style</code> object was removed and false if it was not present.
		*/
		public function removeStyle(s:Style):Boolean
		{
			if(this.hasStyle(s))
			{
				this._styles.splice(this._styles.indexOf(s), 1);
				
				this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
				
				return true;
			}
			
			return false;
		}
		
		public function hasFontFace(s:FontFace):Boolean
		{
			return (this._fontFaces.indexOf(s) > -1);
		}

		public function addFontFace(s:FontFace, atIndex:int=-1):Boolean
		{
			if(this.hasFontFace(s))
			{
				return false;
			}
			this._fontFaces.splice(atIndex, 0, s);
			
			this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
			
			return true;
		}

		/**
		* Removes a <code>FontFace</code> object from the StyleSheet.
		* @return A boolean, true if the <code>FontFace</code> object was removed and false if it was not present.
		*/
		public function removeFontFace(s:FontFace):Boolean
		{
			if(this.hasFontFace(s))
			{
				this._fontFaces.splice(this._fontFaces.indexOf(s), 1);
				
				this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
				
				return true;
			}
			
			return false;
		}
		
		public function hasAnimation(s:Animation):Boolean
		{
			return (this._animations.indexOf(s) > -1);
		}

		public function addAnimation(s:Animation, atIndex:int=-1):Boolean
		{
			if(this.hasAnimation(s))
			{
				return false;
			}
			
			this._animations.splice(atIndex, 0, s);
			
			this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
			
			return true;
		}

		/**
		* Removes a <code>Animation</code> object from the StyleSheet.
		* @return A boolean, true if the <code>Animation</code> object was removed and false if it was not present.
		*/
		public function removeAnimation(s:Animation):Boolean
		{
			if(this.hasAnimation(s))
			{
				this._animations.splice(this._animations.indexOf(s), 1);
				
				this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
				
				return true;
			}
			
			return false;
		}
		
		public function hasImport(s:Import):Boolean
		{
			return (this._imports.indexOf(s) > -1);
		}

		public function addImport(s:Import):Boolean
		{
			if(this.hasImport(s))
			{
				return false;
			}
			
			this._imports.push(s);
			
			this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
			
			return true;
		}

		/**
		* Removes a <code>Import</code> object from the StyleSheet.
		* @return A boolean, true if the <code>Import</code> object was removed and false if it was not present.
		*/
		public function removeImport(s:Import):Boolean
		{
			if(this.hasImport(s))
			{
				this._imports.splice(this._imports.indexOf(s), 1);
				
				this.dispatchEvent(new StyleSheetEvent(StyleSheetEvent.STYLESHEET_MODIFIED));
				
				return true;
			}
			
			return false;
		}
		

	}
	
}
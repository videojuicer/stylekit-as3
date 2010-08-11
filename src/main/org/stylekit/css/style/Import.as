package org.stylekit.css.style
{
	import flash.events.EventDispatcher;	
	import org.stylekit.css.StyleSheet;
		
	/**
	* An Import encapsulates a single @import statement within an owning StyleSheet object.
	*/
	public class Import extends EventDispatcher
	{
		protected var _styleSheet:StyleSheet;
		protected var _styleInsertionIndex:uint;
		protected var _animationInsertionIndex:uint;
		protected var _fontFaceInsertionIndex:uint;
		
		/**
		* Instiates a new Import object within an owning <code>StyleSheet</code> instance.
		* @param sourceURL A <code>String</code> indicating the URL from which the styles should be loaded.
		* @param styleInsertionIndex A <code>uint</code> indicating the index at which loaded styles should be injected into the parent StyleSheet.
		* @param animationInsertionIndex A <code>uint</code> indicating the index at which loaded @keyframe blocks should be injected into the parent StyleSheet.
		* @param fontFaceInsertionIndex A <code>uint</code> indicating the index at which loaded @font-face blocks should be injected into the parent StyleSheet.
		*/
		public function Import(ownerStyleSheet:StyleSheet, sourceURL:String, styleInsertionIndex:uint=0, animationInsertionIndex:uint=0, fontFaceInsertionIndex:uint=0) 
		{
			this._styleSheet = ownerStyleSheet;
			this._styleInsertionIndex = styleInsertionIndex;
			this._animationInsertionIndex = animationInsertionIndex;
			this._fontFaceInsertionIndex = fontFaceInsertionIndex;
		}
	}
}
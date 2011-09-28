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
package org.stylekit.css.style
{
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.selector.MediaSelector;
	
	/**
	* An FontFace encapsulates a single @font-face block within an owning StyleSheet object.
	*/
	public class FontFace extends PropertyContainer
	{
		
		/**
		* A reference to a <code>MediaSelector</code> object used to restrict this instance to a specific set of media types.
		*/ 
		protected var _mediaSelector:MediaSelector;
		
		
		/**
		* Instiates a new FontFace object within an owning <code>StyleSheet</code> instance.
		*/
		public function FontFace(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
		}
		
		public function set mediaSelector(ms:MediaSelector):void
		{
			this._mediaSelector = ms;
		}
		
		public function get mediaSelector():MediaSelector
		{
			return this._mediaSelector;
		}
		
		protected function registerFontFamily():void
		{
			// we need to download the font file or decode it from Base64?
			// get the definition of the font class
			// register the font class to the specified font family name
			
			// remote fonts (via swf's): http://www.flashmorgan.com/index.php/2007/06/18/runtime-font-embedding-in-as3-there-is-no-need-to-embed-the-entire-fontset-anymore/
		}
	}
}
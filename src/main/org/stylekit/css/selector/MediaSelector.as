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
package org.stylekit.css.selector
{
	/**
	* A <code>MediaSelector</code> object may be applied to a StyleSheet or 
	*/
	public class MediaSelector
	{
		
		protected var _media:Vector.<String>;
		
		public function MediaSelector()
		{
			this._media = new Vector.<String>();
		}
		
		public function get media():Vector.<String>
		{
			return this._media;
		}
		
		public function matches(mediaVec:Vector.<String>):Boolean
		{
			for(var i:uint=0; i < mediaVec.length; i++)
			{
				if(this.hasMedia(mediaVec[i]))
				{
					return true;
				}
			}
			return false;
		}
		
		public function addMedia(m:String):Boolean
		{
			if(this.hasMedia(m))
			{
				return false;
			}
			this._media.push(m);
			return true;
		}
		
		public function hasMedia(m:String):Boolean
		{
			return (this._media.indexOf(m) > -1);
		}
		
		public function removeMedia(m:String):Boolean
		{
			if(this.hasMedia(m))
			{
				this._media.splice(this._media.indexOf(m), 1);
				return true;
			}
			return false;
		}
	}
}
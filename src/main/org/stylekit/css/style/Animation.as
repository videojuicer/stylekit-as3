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
	import org.stylekit.css.style.AnimationKeyFrame;
	import org.stylekit.css.selector.MediaSelector;
	
	/**
	* An animation encapsulates a single @keyframes block within an owning StyleSheet object.
	*/
	public class Animation extends PropertyContainer
	{
		
		/**
		* The registered name for this animation. In the declaration '@keyframes foo {}', the name is "foo".
		*/
		protected var _animationName:String;
		
		/**
		* A list of all keyframes defined by the Animation
		*/
		protected var _keyFrames:Vector.<AnimationKeyFrame>;
		
		/**
		* A reference to a <code>MediaSelector</code> object used to restrict this instance to a specific set of media types.
		*/ 
		protected var _mediaSelector:MediaSelector;
		
		
		/**
		* Instiates a new Animation object within an owning <code>StyleSheet</code> instance.
		* @param ownerStyleSheet The <code>StyleSheet</code> instance to which this animation belongs.
		* @param name The name for this animation as a <code>String</code>. The <code>StyleSheetParser</code> passes name given in the @keyframes block when creating <code>Animation</code> objects.
		*/
		public function Animation(ownerStyleSheet:StyleSheet) 
		{
			super(ownerStyleSheet);
			this._keyFrames = new Vector.<AnimationKeyFrame>();
		}
		
		public function get animationName():String
		{
			return this._animationName;
		}
		
		public function set animationName(n:String):void
		{
			this._animationName = n;
		}
		
		public function get keyFrames():Vector.<AnimationKeyFrame>
		{
			return this._keyFrames;
		}
		
		public function set mediaSelector(ms:MediaSelector):void
		{
			this._mediaSelector = ms;
		}
		
		public function get mediaSelector():MediaSelector
		{
			return this._mediaSelector;
		}
		
		public function addKeyFrame(kf:AnimationKeyFrame):Boolean
		{
			if(this.hasKeyFrame(kf))
			{
				return false;
			}
			this._keyFrames.push(kf);
			return true;
		}
		
		public function hasKeyFrame(kf:AnimationKeyFrame):Boolean
		{
			return (this._keyFrames.indexOf(kf) > -1);
		}
		
		public function removeKeyFrame(kf:AnimationKeyFrame):Boolean
		{
			if(this.hasKeyFrame(kf))
			{
				this._keyFrames.splice(this.keyFrames.indexOf(kf), 1);
				return true;
			}
			return false;
		}
	}
}
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
	
	import org.stylekit.css.selector.ElementSelector;
	
	/**
	* An <code>ElementSelectorChain</code> is, as the name suggests, an ordered chain of <code>ElementSelector</code> instances.
	* While an individual CSS selector "p:last-child" is expressed within SMILKit as an <code>ElementSelector</code>, a chain of
	* selectors such as "div p" or "div > h1:first-child" is expressed as an <code>ElementSelectorChain</code>.
	*
	* @see org.stylekit.css.style.selector.ElementSelector
	*/
	
	public class ElementSelectorChain
	{
		
		protected var _elementSelectors:Vector.<ElementSelector>;
		protected var _stringValue:String;
		protected var _selectorId:int;
		
		public static var ID_INC:int = 0;
		
		public function ElementSelectorChain()
		{
			this._elementSelectors = new Vector.<ElementSelector>();
			
			ElementSelectorChain.ID_INC++;
			this._selectorId = ElementSelectorChain.ID_INC;
		}
		
		public function get selectorId():int
		{
			return this._selectorId;
		}
		
		public function addElementSelector(e:ElementSelector, atIndex:int=-1):void
		{
			this._elementSelectors.splice(((atIndex > -1)? atIndex : this.elementSelectors.length ), 0, e);
		}
		
		public function get elementSelectors():Vector.<ElementSelector>
		{
			return this._elementSelectors;
		}
		
		public function get specificity():uint
		{
			var score:uint = 0;
			for(var i:uint=0; i < this._elementSelectors.length; i++)
			{
				score += this._elementSelectors[i];
			}
			return score;
		}
		
		public function get stringValue():String
		{
			return this._stringValue;
		}
		
		public function set stringValue(s:String):void
		{
			this._stringValue = s;
		}
		
	}
	
}
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
package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	
	public class EdgeCompoundValue extends Value
	{
		protected var _leftValue:Value;
		protected var _rightValue:Value;
		protected var _topValue:Value;
		protected var _bottomValue:Value;
		
		public function EdgeCompoundValue()
		{
			super();
		}
		
		public function get leftValue():Value
		{
			return this._leftValue;
		}
		
		public function set leftValue(v:Value):void
		{
			this._leftValue = v;
			
			this.modified();
		}
		
		public function get rightValue():Value
		{
			return this._rightValue;
		}

		public function set rightValue(v:Value):void
		{
			this._rightValue = v;
			
			this.modified();
		}
		
		public function get topValue():Value
		{
			return this._topValue;
		}

		public function set topValue(v:Value):void
		{
			this._topValue = v;
			
			this.modified();
		}
		
		public function get bottomValue():Value
		{
			return this._bottomValue;
		}

		public function set bottomValue(v:Value):void
		{
			this._bottomValue = v;
			
			this.modified();
		}
	}
}
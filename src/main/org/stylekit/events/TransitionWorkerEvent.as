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
package org.stylekit.events
{
	import flash.events.Event;
	import org.stylekit.css.value.Value;
	import org.stylekit.ui.element.worker.TransitionWorker;
	
	public class TransitionWorkerEvent extends Event
	{
		public static var INTERMEDIATE_VALUE_GENERATED:String = "transitionWorkerIntermediateValueGenerated";
		public static var FINAL_VALUE_GENERATED:String = "transitionWorkerFinalValueGenerated";
		
		protected var _value:Value;
		protected var _worker:TransitionWorker;
		
		public function TransitionWorkerEvent(type:String, value:Value, worker:TransitionWorker, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._value = value;
			this._worker = worker;
		}
		
		public function get value():Value
		{
			return this._value;
		}
		
		public function get worker():TransitionWorker
		{
			return this._worker;
		}
	}
}
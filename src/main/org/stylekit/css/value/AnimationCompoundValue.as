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
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.TimeValue;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.AnimationIterationCountValue;
	import org.stylekit.css.value.AnimationDirectionValue;
	
	import org.utilkit.util.StringUtil;
	
	public class AnimationCompoundValue extends Value
	{
		
		protected var _animationNameValue:ValueArray;
		protected var _animationDurationValue:ValueArray;
		protected var _animationTimingFunctionValue:ValueArray;
		protected var _animationDelayValue:ValueArray;
		protected var _animationIterationCountValue:ValueArray;
		protected var _animationDirectionValue:ValueArray;
		
		public function AnimationCompoundValue()
		{
			super();
			this._animationNameValue = new ValueArray(Value);
			this._animationDurationValue = new ValueArray(TimeValue);
			this._animationTimingFunctionValue = new ValueArray(TimingFunctionValue);
			this._animationDelayValue = new ValueArray(TimeValue);
			this._animationIterationCountValue = new ValueArray(AnimationIterationCountValue);
			this._animationDirectionValue = new ValueArray(AnimationDirectionValue);
		}
		
		public function get animationNameValue():ValueArray
		{
			return this._animationNameValue;
		}
		
		public function set animationNameValue(v:ValueArray):void
		{
			this._animationNameValue = v;
		}
		
		public function get animationDurationValue():ValueArray
		{
			return this._animationDurationValue;
		}
		
		public function set animationDurationValue(v:ValueArray):void
		{
			this._animationDurationValue = v;
		}
		
		public function get animationTimingFunctionValue():ValueArray
		{
			return this._animationTimingFunctionValue;
		}
		
		public function set animationTimingFunctionValue(v:ValueArray):void
		{
			this._animationTimingFunctionValue = v;
		}
		
		public function get animationDelayValue():ValueArray
		{
			return this._animationDelayValue;
		}
		
		public function set animationDelayValue(v:ValueArray):void
		{
			this._animationDelayValue = v;
		}
		
		public function get animationIterationCountValue():ValueArray
		{
			return this._animationIterationCountValue;
		}
		
		public function set animationIterationCountValue(v:ValueArray):void
		{
			this._animationIterationCountValue = v;
		}
		
		public function get animationDirectionValue():ValueArray
		{
			return this._animationDirectionValue;
		}
		
		public function set animationDirectionValue(v:ValueArray):void
		{
			this._animationDirectionValue = v;
		}
		
		public static function parse(str:String):AnimationCompoundValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var val:AnimationCompoundValue = new AnimationCompoundValue();
			
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			// every time we encounter an unrecognised value, consider it to be an animation name and fill-in on the remaining values
			var durationAdded:Boolean = false;
			var delayAdded:Boolean = false;
			var directionAdded:Boolean = false;
			var iterationCountAdded:Boolean = false;
			var timingFunctionAdded:Boolean = false;
			
			for(var i:uint=0; i<tokens.length; i++)
			{
				var t:String = tokens[i];
				
				if(TimeValue.identify(t))
				{
					if(durationAdded)
					{
						// animation-delay
						val.animationDelayValue.andParse(t);
						delayAdded = true;
					}
					else
					{
						// animation-duration
						val.animationDurationValue.andParse(t);
						durationAdded = true;
					}
				}
				else if(TimingFunctionValue.identify(t))
				{
					val.animationTimingFunctionValue.andParse(t);
					timingFunctionAdded = true;
				}
				else if(AnimationDirectionValue.identify(t))
				{
					// animation-direction
					val.animationDirectionValue.andParse(t);
					directionAdded = true;
				}
				else if(AnimationIterationCountValue.identify(t))
				{
					// animation-iteration-count
					val.animationIterationCountValue.andParse(t);
					iterationCountAdded = true;
				}
				else
				{
					// animation-name value
					val.animationNameValue.andParse(t);
					
					// reset flags
					timingFunctionAdded = false;
					durationAdded = false;
					delayAdded = false;
					directionAdded = false;
					iterationCountAdded = false;
				}
			}
			
			return val;
		}
		
	}
}
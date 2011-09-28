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
	import org.utilkit.util.StringUtil;
	
	import org.stylekit.css.property.PropertyContainer;
	import org.stylekit.css.value.ValueArray;
	import org.stylekit.css.value.TimingFunctionValue;
	import org.stylekit.css.value.PropertyListValue;
	import org.stylekit.css.value.TimeValue;
	
	public class TransitionCompoundValue extends Value
	{
		
		protected var _transitionPropertyValue:PropertyListValue;
		protected var _transitionDurationValue:ValueArray;
		protected var _transitionDelayValue:ValueArray;
		protected var _transitionTimingFunctionValue:ValueArray;
		
		public function TransitionCompoundValue()
		{
			super();
		}
		
		public function get transitionPropertyValue():PropertyListValue
		{
			return this._transitionPropertyValue;
		}
		
		public function set transitionPropertyValue(t:PropertyListValue):void
		{
			this._transitionPropertyValue = t;
		}
		
		public function get transitionDurationValue():ValueArray
		{
			return this._transitionDurationValue;
		}
		
		public function set transitionDurationValue(t:ValueArray):void
		{
			this._transitionDurationValue = t;
		}
		
		public function get transitionDelayValue():ValueArray
		{
			return this._transitionDelayValue;
		}
		
		public function set transitionDelayValue(t:ValueArray):void
		{
			this._transitionDelayValue = t;
		}
		
		public function get transitionTimingFunctionValue():ValueArray
		{
			return this._transitionTimingFunctionValue;
		}
		
		public function set transitionTimingFunctionValue(t:ValueArray):void
		{
			this._transitionTimingFunctionValue = t;
		}
		
		public static function parse(str:String):TransitionCompoundValue
		{
			str = StringUtil.trim(str.toLowerCase());
			
			var val:TransitionCompoundValue = new TransitionCompoundValue();
				val.transitionPropertyValue = new PropertyListValue();
				val.transitionDurationValue = new ValueArray(TimeValue);
				val.transitionDelayValue = new ValueArray(TimeValue);
				val.transitionTimingFunctionValue = new ValueArray(TimingFunctionValue);
			
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			
			// each found propertylist value restarts the conditions for parsing time values.
			var durationParsed:Boolean = false;
			for(var i:uint=0; i<tokens.length; i++)
			{
				var t:String = tokens[i];
				if(PropertyListValue.identify(t))
				{
					val.transitionPropertyValue.addProperty(t);
					durationParsed = false;
				}
				else if(TimeValue.identify(t))
				{
					if(durationParsed)
					{
						val.transitionDelayValue.andParse(t);
					}
					else
					{
						val.transitionDurationValue.andParse(t);
						durationParsed = true;
					}
				}
				else if(TimingFunctionValue.identify(t))
				{
					val.transitionTimingFunctionValue.andParse(t);
				}
			}
			
			var d:Object;
			if(val.transitionDelayValue.values.length == 0)
			{
				if(d == null) d = PropertyContainer.defaultStyles;
				val.transitionDelayValue.values.push((d["transition-delay"] as ValueArray).valueAt(0));
			}
			
			if(val.transitionDurationValue.values.length == 0)
			{
				if(d == null) d = PropertyContainer.defaultStyles;
				val.transitionDelayValue.values.push((d["transition-duration"] as ValueArray).valueAt(0));
			}
			
			if(val.transitionTimingFunctionValue.values.length == 0)
			{
				if(d == null) d = PropertyContainer.defaultStyles;
				val.transitionDelayValue.values.push((d["transition-timing-function"] as ValueArray).valueAt(0));
			}
				
			return val;
		}
		
	}
}
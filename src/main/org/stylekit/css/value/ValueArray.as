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
	
	/**
	* ValueArray describes a comma-seperated list of homogenous value types, for instance as specified by the "animation-iteration-count"
	* property, which may list several AnimationIterationCountValues as a comma-sep list.
	*/
	public class ValueArray extends Value
	{
		
		protected var _values:Vector.<Value>;
		protected var _valueClass:Class;
		
		public function ValueArray(valueClass:Class = null)
		{
			super();
			this._valueClass = valueClass;
			this._values = new Vector.<Value>();
		}
		
		public function get values():Vector.<Value>
		{
			return this._values;
		}
		
		public function set values(v:Vector.<Value>):void
		{
			this._values = v;
		}
		
		public static function parse(str:String, valueClass:Class = null):ValueArray
		{
			if(valueClass == null)
			{
				valueClass = Value;
			} 
			str = StringUtil.trim(str.toLowerCase());
			var val:ValueArray = new ValueArray();
				val._valueClass = valueClass;
				
				var tokens:Vector.<String> = ValueParser.parseCommaDelimitedString(str);
				for(var i:uint; i < tokens.length; i++)
				{
					val.values.push(valueClass.parse(tokens[i]));
				}
				
			return val;
		}
		
		public function andParse(str:String):void
		{
			str = StringUtil.trim(str.toLowerCase());
			if(this._valueClass == Value || this._valueClass.identify(str))
			{
				this._values.push(this._valueClass.parse(str));
			}
		}
		
		public function valueAt(index:uint):Value
		{
			if(this.values.length == 0)
			{
				return null;
			}
			else if(index > this.values.length-1)
			{
				return this.values[this.values.length-1];
			}
			else
			{
				return this.values[index];
			}
		}
		
		public static function identify(str:String):Boolean
		{
			return true; // all values are eligible
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is ValueArray)
			{
				var otherVal:ValueArray = (other as ValueArray); // AS3 precompiler won't work otherwise.aaaargh.
				for(var i:uint = 0; i < this.values.length; i++)
				{
					if(!this.valueAt(i).isEquivalent(otherVal.valueAt(i))) return false;
				}
				for(i=0; i < otherVal.values.length; i++)
				{
					if(!otherVal.valueAt(i).isEquivalent(this.valueAt(i))) return false;
				}
				return true;
			}
			return super.isEquivalent(other);
		}
	}
}
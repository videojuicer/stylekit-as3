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
package org.stylekit.css.parse
{
	
	import org.utilkit.util.StringUtil;
	import org.stylekit.css.selector.MediaSelector;
	
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.RepeatValue;
	
	import org.stylekit.css.value.BorderCompoundValue;
	import org.stylekit.css.value.BackgroundCompoundValue;
	import org.stylekit.css.value.EdgeCompoundValue;
	
	/**
	* The <code>ValueParser</code> class provides utility methods for parsing CSS property values of various types.
	*/
	public class ValueParser
	{
		
		public static var wrapMap:Object = {
			"(": ")",
			'"': '"',
			"'": "'",
			"{": "}"
		};
		
		public function ValueParser()
		{
			
		}
		
		/**
		* Parses a four-way sizing value such as may be used for padding, margin etc. and returns an EdgeCompoundValue.
		*/
		public function parseEdgeSizeCompoundValue(str:String):EdgeCompoundValue
		{
			var sizeStrings:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			var cVal:EdgeCompoundValue = new EdgeCompoundValue();
			
			var sizeValues:Vector.<SizeValue> = new Vector.<SizeValue>();
			for(var i:uint = 0; i < sizeStrings.length; i++)
			{
				sizeValues.push(SizeValue.parse(sizeStrings[i]));
			}
			
			switch(sizeValues.length)
			{
				case 1:
					// all
					cVal.leftValue = cVal.rightValue = cVal.topValue = cVal.bottomValue = sizeValues[0];
					break;
				case 2:
					// top+bottom, left+right
					cVal.topValue = cVal.bottomValue = sizeValues[0];
					cVal.leftValue = cVal.rightValue = sizeValues[1];
					break;
				case 3: 
					// top, left+right, bottom
					cVal.topValue = sizeValues[0];
					cVal.leftValue = cVal.rightValue = sizeValues[1];
					cVal.bottomValue = sizeValues[2];
					break;
				case 4:
					// top, right, bottom, left
					cVal.topValue = sizeValues[0];
					cVal.rightValue = sizeValues[1];
					cVal.bottomValue = sizeValues[2];
					cVal.leftValue = sizeValues[3];
					break;
			}
			
			return cVal;
		}

		
		/**
		* Accepts an argument string from a CSS @import statement and parses it into an array containing a
		* URLValue object and a MediaSelector.
		*/ 
		public function parseImportArguments(importArgs:String):Array
		{
			var result:Array = [];
			var urlParserResult:Array = URLValue.parseWithExtent(importArgs);
			var mediaSelectorParserResult:MediaSelector = this.parseMediaSelector(importArgs.slice(urlParserResult[1]));
			
			return [urlParserResult[0], mediaSelectorParserResult];
		}
		
		/**
		* Accepts a comma-delimited set of media types and produces a matching MediaSelector object.
		*/
		public function parseMediaSelector(str:String):MediaSelector
		{
			var mSel:MediaSelector = new MediaSelector();
			var mediaTypes:Vector.<String> = ValueParser.parseCommaDelimitedString(str);

			if(mediaTypes.length == 0)
			{
				return null;
			}
			
			for(var m:uint = 0; m < mediaTypes.length; m++)
			{
				mSel.addMedia(mediaTypes[m]);
			}
			return mSel;
		}
		
		/**
		* Parses a space-delimited CSS property string and returns the resulting vector of individual string objects.
		* ignores spaces that occur within brackets or quotes.
		*/
		public static function parseSpaceDelimitedString(str:String):Vector.<String>
		{
			return ValueParser.parseDelimitedString(" ", str);
		}
		
		/**
		* Parses a comma-delimited string into a vector of strings, trimming the whitespace from each.
		* e.g. "foo,bar, car, baz,, faz,,  bat, " > vector containing foo,bar,car,baz,faz,bat
		*/
		public static function  parseCommaDelimitedString(str:String):Vector.<String>
		{
			return ValueParser.parseDelimitedString(",", str);
		}
		
		public static function parseDelimitedString(delimiter:String, str:String):Vector.<String>
		{
			str = StringUtil.trim(str);
			var result:Vector.<String> = new Vector.<String>();
			var tokenOpened:Boolean = false;
			var token:String = "";
			var lastPoppedWrap:String = "";
			
			
			
			// Contains a stack of expected closing strings
			var wrapStack:Vector.<String> = new Vector.<String>();
			
			for(var i:uint=0; i <= str.length; i++) // loop deliberately overruns
			{
				var char:String;
				if(i < str.length) char = str.charAt(i);
				else char = "END";
				
				// Process the character to determine if we're deepening (or popping) either the quote depth or the bracket depth.
				if(wrapStack.length > 0 && char == wrapStack[wrapStack.length-1])
				{
					lastPoppedWrap = wrapStack.pop();
				}
				else if(ValueParser.wrapMap[char] != null)
				{
					// Encountered a wrap character
					wrapStack.push(ValueParser.wrapMap[char]);
				}
				
				// Decide whether to open or close a token
				if(char == delimiter || char == "END")
				{
					if(tokenOpened && (wrapStack.length == 0 || char == "END"))
					{
						// Close the token
						var t:String = token;
						// Strip the last character if we're quote-wrapped and it matches the quotestack
						if(t.length > 0)
						{
							result.push(ValueParser.stripWrapping(t));
						}
						token = "";
						tokenOpened = false;
					}
					else if(tokenOpened && char != "END")
					{
						// If the token is opened, push the char
						token += char;
					}
				}
				else
				{
					tokenOpened = true;
					token += char;
				}
				
				
			}
			
			return result;
		}
		
		// Strips any wrapping quotes or brackets from a single string.
		// e.g. "(foo)" => "foo"
		public static function stripWrapping(str:String):String
		{
			str = StringUtil.trim(str);
			var oWraps:Vector.<String> = new Vector.<String>();
			var chopIndex:uint = 0;
			
			for(var i:uint = 0; i < str.length; i++)
			{
				var char:String = str.charAt(i);
				
				if(ValueParser.wrapMap[char] != null)
				{
					oWraps.push(ValueParser.wrapMap[char]);
				}
				else
				{
					break;
				}
			}
			
			for(i=0; i < oWraps.length; i++)
			{
				var strChar:String = str.charAt(str.length-(1+i));
				if(strChar == oWraps[i])
				{
					chopIndex++;
				}
			}
			
			return str.substring(chopIndex, str.length-(chopIndex));
		}
		
	}
	
}
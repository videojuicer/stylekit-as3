package org.stylekit.css.value
{
	
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	/**
	* A URLValue instance represents any CSS value of the style 'url("foo.css")'.
	*/	
	public class URLValue extends Value
	{
		
		protected var _url:String;
		protected var _baseURL:String;
		
		public function URLValue()
		{
			super();
		}
		
		public static function parseWithExtent(str:String):Array
		{
			var openBracketFound:Boolean = false;
			var openStringFound:Boolean = false;
			var closeBracketFound:Boolean = false;
			var closeStringFound:Boolean = false;
			var openStringChar:String;
			
			var token:String = "";
			var count:uint = 0;
			
			for(var i:uint=0; i < str.length; i++)
			{
				var char:String = str.charAt(i);
				
				
				
				if(char == "(") 
				{
					openBracketFound = true;
				}
				else if(!openStringFound && (char == "'" || char == "\""))
				{
					openStringFound = true;
					openStringChar = char;
				}
				else if(char == ")") 
				{
					closeBracketFound = true;
				}
				else if(openStringFound && char == openStringChar)
				{
					closeStringFound = true;
				}
				else
				{
					if(openBracketFound || openStringFound)
					{
						token += char;
					}
				}
				
				if((!openBracketFound && openStringFound && closeStringFound) || (!openStringFound && openBracketFound && closeBracketFound) || (openStringFound && closeStringFound && openBracketFound && closeBracketFound))
				{
					// If there was no open bracket but there was a quote and we've found the open and close quotes
					// if there was no quote but we've found both brackets
					// if there was a bracket and a quote and we've found both ends
					count = i+1;
					break;
				}
			}
			
			var uVal:URLValue = new URLValue();
			uVal.url = token;
			uVal.rawValue = str;
			return [uVal, count];
		}
		
		public static function parse(str:String):URLValue
		{
			return (URLValue.parseWithExtent(str)[0] as URLValue);
		}
		
		public static function identify(str:String):Boolean
		{
			var pattern:RegExp = new RegExp("url\(.*\)");
			var pIndex:int = str.search(pattern);
			return (pIndex > -1);
		}
		
		public function get url():String
		{
			return this._url;
		}
		
		public function set url(u:String):void
		{
			this._url = u;
			
			this.modified();
		}
		
		public function get baseURL():String
		{
			return this._baseURL;
		}
		
		public function set baseURL(b:String):void
		{
			this._baseURL = b;
			
			this.modified();
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is URLValue)
			{
				return (this.url == (other as URLValue).url);
			}
			
			return super.isEquivalent(other);
		}
	}
	
}
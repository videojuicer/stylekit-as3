package org.stylekit.css.parse
{
	
	import org.utilkit.util.StringUtil;
	
	/**
	* The <code>ValueParser</code> class provides utility methods for parsing CSS property values of various types.
	*/
	public class ValueParser
	{
		
		public function ValueParser()
		{
			
		}
		
		/**
		* Accepts an argument string from a CSS @import statement and parses it into an array containing a
		* URLValue object and a vector of media types.
		*/ 
		public function parseImportArguments(cssImport:String):void
		{
			
		}
		
		/**
		* Accepts a string such as 'url("foo.css")'
		*/
		public function parseURL(cssURL:String, baseURL:String = ""):void
		{
			
		}
		
		/**
		* Parses a comma-delimited string into a vector of strings, trimming the whitespace from each.
		* e.g. "foo,bar, car, baz,, faz,,  bat, " > vector containing foo,bar,car,baz,faz,bat
		*/
		public function parseCommaDelimitedString(str:String):Vector.<String>
		{
			var spl:Array = str.split(",");
			var vec:Vector.<String> = new Vector.<String>();
			for(var i:uint=0; i<spl.length; i++)
			{
				var strp:String = StringUtil.trim(spl[i]);
				if(strp.length > 0)
				{
					vec.push(strp);
				}
			}
			return vec;
		}
		
	}
	
}
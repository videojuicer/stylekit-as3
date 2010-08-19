package org.stylekit.css.value
{
	
	import org.stylekit.css.value.Value;
	
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
		
		public function get url():String
		{
			return this._url;
		}
		
		public function set url(u:String):void
		{
			this._url = u;
		}
		
		public function get baseURL():String
		{
			return this._baseURL;
		}
		
		public function set baseURL(b:String):void
		{
			this._baseURL = b;
		}
		
	}
	
}
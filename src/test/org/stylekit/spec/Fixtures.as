package org.stylekit.spec {
	
	public class Fixtures
	{
		
		public static var CSS_MIXED:String = ""+
		"/* Comment */"+
		"/*"+
		"Multiline"+
		"comment"+
		"*/"+
	    "@import url(\"external.css\");"+
	    "selector {"+
	     	"property-foo: bar;"+
	    	"property-bar: baz;"+
			"property-important: srsbsns !important;"+
	    "}"+
		"another selector {"+
			"property-one: value-one;"+
			"property-two: value-two"+ // Deliberately omit semicolon to test parser failover
		"}"+
	    "@font-face {"+
	      'font-family: "Your typeface";'+
	      'src: url("type/filename.eot");'+
	      'src: local("foo"),'+
	        'url("type/filename.woff") format("woff"),'+
	        'url("type/filename.otf") format("opentype"),'+
	        'url("type/filename.svg#filename") format("svg");'+
	    "}"+
	    "@import url(\"later.css\");"+
	   	"@keyframes keyframes {"+
	      "0% {"+
	        "foo: bar;"+
	      "}"+
	      "100% {"+
	        "foo: bar;"+
	      "}"+
	    "}";
	}
	
}
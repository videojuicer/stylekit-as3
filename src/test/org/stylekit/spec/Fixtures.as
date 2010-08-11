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
	        "foo: bar1;"+
	      "}"+
	      "100% {"+
	        "foo: bar2;"+
	      "}"+
	    "}"+
		"third selector {"+
	     	"property-foo: bar;"+
	    	"property-bar: baz;"+
			"property-important: srsbsns !important;"+
	    "}"+
		"@media print, screen {"+
			"media selector for print and screen {"+
		     	"property-foo: bar;"+
		    "}"+
			"another media selector {"+
		     	"property-foo: bar;"+
		    "}"+
		"}"+
		"non-media selector {"+
	     	"property-foo: bar;"+
	    "}";
	}
	
}
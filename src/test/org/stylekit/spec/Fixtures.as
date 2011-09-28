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
	    "@import url(\"later.css\") mediaA, mediaB;"+
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
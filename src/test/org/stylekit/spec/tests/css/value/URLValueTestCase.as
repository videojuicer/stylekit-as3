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
package org.stylekit.spec.tests.css.value
{

	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.value.URLValue;

	public class URLValueTestCase {
		
		protected var _result:URLValue;
		
		[Before]
		public function setUp():void
		{
			
		}
		
		[After]
		public function tearDown():void
		{
			
		}
		
		[Test(description="Ensures that a string value may be parsed into a valid URLValue object.")]
		public function stringParsesCorrectly():void
		{
			var tokens:Vector.<String> = new Vector.<String>();
				tokens.push("url(\"foo.css\") some other stuff");
				tokens.push("url('foo.css') blah blah");
				tokens.push("\"foo.css\"     ");
				tokens.push("url(foo.css)     ");
				
			var tokenLengths:Vector.<uint> = new Vector.<uint>();
				tokenLengths.push(14);
				tokenLengths.push(14);
				tokenLengths.push(9);
				tokenLengths.push(12);
			
			for(var i:uint=0; i < tokens.length; i++)
			{
				var result:Array = URLValue.parseWithExtent(tokens[i]);
				Assert.assertEquals("foo.css",  (result[0] as URLValue).url);
				Assert.assertEquals(tokenLengths[i], result[1]);
			}
		}
		
		[Test(description="Ensures that a string value may be identified as valid for parsing as a URLValue.")]
		public function stringIdentifiesCorrectly():void
		{
			var valid:Array = ["url('foo.css')", "url(\"foo.css\")"];
			for(var i:uint = 0; i < valid.length; i++)
			{
				Assert.assertTrue("Failing on: "+valid[i], URLValue.identify(valid[i]));
			}
			
			var invalid:Array = ["poooop"];
			for(i=0; i < invalid.length; i++)
			{
				Assert.assertFalse("Failing on: "+invalid[i], URLValue.identify(invalid[i]));
			}
		}
		
	}
}
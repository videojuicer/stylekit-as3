package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.selector.MediaSelector;
		
	import org.stylekit.css.parse.ValueParser;

		
	public class ValueParserTestCase
	{
		protected var _parser:ValueParser;
	
		[Before]
		public function setUp():void
		{
			this._parser = new ValueParser();
		}
	
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
	
		[Test(description="Ensures that the arguments for an @import selector can be properly parsed")]
		public function importArgsParseCorrectly():void
		{
			var result:Array;
			
			result = this._parser.parseImportArguments("url('foo.css') media1, media2");
			Assert.assertEquals("foo.css", result[0]);
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media1"));
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media2"));
			
			result = this._parser.parseImportArguments("url('foo.css')");
			Assert.assertEquals("foo.css", result[0]);
			Assert.assertEquals(null, result[1]);
			
			result = this._parser.parseImportArguments("\"foo.css\" media1, media2");
			Assert.assertEquals("foo.css", result[0]);
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media1"));
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media2"));
		}
	
		[Test(description="Ensures that the parsing of a comma-delimited string works correctly")]
		public function commaDelimStringParsesCorrectly():void
		{
			var result:Vector.<String> = this._parser.parseCommaDelimitedString("foo,bar, baz,,,,     car, ");
			Assert.assertEquals(4, result.length);
			
			var expected:Array = ["foo", "bar", "baz", "car"];
			for(var i:uint = 0; i<expected.length; i++)
			{
				Assert.assertEquals(expected[i], result[i]);
			}
		}
		
		[Test(description="Ensures that a space-delimited CSS string can be parsed, ignoring bracketed or quoted values.")]
		public function spaceDelimStringParsesCorrectly():void
		{
			var result:Vector.<String> = this._parser.parseSpaceDelimitedString("one two url(three three three) url(\"four four four\") 'five five five'");
			Assert.assertEquals(5, result.length);
			
			var expected:Array = ["one", "two", "url(three three three)", "url(\"four four four\")", "'five five five'"];
			for(var i:uint = 0; i<expected.length; i++)
			{
				Assert.assertEquals(expected[i], result[i]);
			}
		}
		
		[Test(description="Ensures that the parsing of a CSS url-type string works correctly")]
		public function urlTokenParsesCorrectly():void
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
				var result:Array = this._parser.parseURLToken(tokens[i]);
				Assert.assertEquals("foo.css", result[0]);
				Assert.assertEquals(tokenLengths[i], result[1]);
			}
		}
		
	}
}
package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.selector.MediaSelector;
		
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.EdgeCompoundValue;
		
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
		
		[Test(description="Ensures that compound edge size values such as padding or margin shorthand parse correctly")]
		public function edgeSizeCompoundValuesParseCorrectly():void
		{
			var result:EdgeCompoundValue;
			
			result = this._parser.parseEdgeSizeCompoundValue("25px");
			Assert.assertEquals(25, (result.topValue as SizeValue).value);
			Assert.assertEquals("px", (result.topValue as SizeValue).units);
			Assert.assertEquals(25, (result.rightValue as SizeValue).value);
			Assert.assertEquals("px", (result.rightValue as SizeValue).units);
			Assert.assertEquals(25, (result.bottomValue as SizeValue).value);
			Assert.assertEquals("px", (result.bottomValue as SizeValue).units);
			Assert.assertEquals(25, (result.leftValue as SizeValue).value);
			Assert.assertEquals("px", (result.leftValue as SizeValue).units);
			
			result = this._parser.parseEdgeSizeCompoundValue("25px 5em");
			Assert.assertEquals(25, (result.topValue as SizeValue).value);
			Assert.assertEquals("px", (result.topValue as SizeValue).units);
			Assert.assertEquals(5, (result.rightValue as SizeValue).value);
			Assert.assertEquals("em", (result.rightValue as SizeValue).units);
			Assert.assertEquals(25, (result.bottomValue as SizeValue).value);
			Assert.assertEquals("px", (result.bottomValue as SizeValue).units);
			Assert.assertEquals(5, (result.leftValue as SizeValue).value);
			Assert.assertEquals("em", (result.leftValue as SizeValue).units);
			
			result = this._parser.parseEdgeSizeCompoundValue("25px 75% 50px");
			Assert.assertEquals(25, (result.topValue as SizeValue).value);
			Assert.assertEquals("px", (result.topValue as SizeValue).units);
			Assert.assertEquals(75, (result.rightValue as SizeValue).value);
			Assert.assertEquals("%", (result.rightValue as SizeValue).units);
			Assert.assertEquals(50, (result.bottomValue as SizeValue).value);
			Assert.assertEquals("px", (result.bottomValue as SizeValue).units);
			Assert.assertEquals(75, (result.leftValue as SizeValue).value);
			Assert.assertEquals("%", (result.leftValue as SizeValue).units);
			
			result = this._parser.parseEdgeSizeCompoundValue("1px 2px 3px 4px");
			Assert.assertEquals(1, (result.topValue as SizeValue).value);
			Assert.assertEquals("px", (result.topValue as SizeValue).units);
			Assert.assertEquals(2, (result.rightValue as SizeValue).value);
			Assert.assertEquals("px", (result.rightValue as SizeValue).units);
			Assert.assertEquals(3, (result.bottomValue as SizeValue).value);
			Assert.assertEquals("px", (result.bottomValue as SizeValue).units);
			Assert.assertEquals(4, (result.leftValue as SizeValue).value);
			Assert.assertEquals("px", (result.leftValue as SizeValue).units);
		}
		
		[Test(description="Ensures that basic size values may be parsed correctly")]
		public function sizeValuesParseCorrectly():void
		{
			var result:SizeValue;
			
			result = this._parser.parseSizeValue("3.4em");
			Assert.assertEquals(3.4, result.value);
			Assert.assertEquals("em", result.units);
			
			result = this._parser.parseSizeValue("3000%");
			Assert.assertEquals(3000, result.value);
			Assert.assertEquals("%", result.units);
			
			result = this._parser.parseSizeValue("3.1 em");
			Assert.assertEquals(3.1, result.value);
			Assert.assertEquals("em", result.units);
			
			result = this._parser.parseSizeValue("0");
			Assert.assertEquals(0, result.value);
			Assert.assertEquals("px", result.units);
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
			
			result = this._parser.parseSpaceDelimitedString("    ");
			Assert.assertEquals(0, result.length);
			
			result = this._parser.parseSpaceDelimitedString("");
			Assert.assertEquals(0, result.length);
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
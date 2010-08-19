package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;

	import org.stylekit.css.selector.MediaSelector;
		
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.SizeValue;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.RepeatValue;
	import org.stylekit.css.value.BackgroundCompoundValue;
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
		
		[Test(description="Ensures that a shorthand background value may be parsed correctly")]
		public function backgroundCompoundValuesParseCorrectly():void
		{
			var result:BackgroundCompoundValue;
			
			result = this._parser.parseBackgroundCompoundValue("red");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals(null, result.urlValue);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);

			result = this._parser.parseBackgroundCompoundValue("#FF0000 url(\"foo.css\")");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertEquals(null, result.repeatValue);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = this._parser.parseBackgroundCompoundValue("#FF0000 url(\"foo.css\") repeat-x");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
			
			result = this._parser.parseBackgroundCompoundValue("#FF0000 url(\"foo.css\") repeat bottom right");
			Assert.assertEquals(0xFF0000, result.colorValue.hexValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertTrue(result.repeatValue.horizontalRepeat);
			Assert.assertTrue(result.repeatValue.verticalRepeat);
			Assert.assertTrue(result.alignmentValue.bottomAlign);
			Assert.assertTrue(result.alignmentValue.rightAlign);
			
			result = this._parser.parseBackgroundCompoundValue("url(\"foo.css\") no-repeat");
			Assert.assertEquals(null, result.colorValue);
			Assert.assertEquals("foo.css", result.urlValue.url);
			Assert.assertFalse(result.repeatValue.horizontalRepeat);
			Assert.assertFalse(result.repeatValue.verticalRepeat);
			Assert.assertEquals(null, result.alignmentValue);
		}
		
		[Test(description="Ensures that repeat values such as repeat-x or repeat-none parse correctly")]
		public function repeatValuesParseCorrectly():void
		{
			var result:RepeatValue;
			
			result = this._parser.parseRepeatValue("repeat");
			Assert.assertTrue(result.horizontalRepeat);
			Assert.assertTrue(result.verticalRepeat);
			
			result = this._parser.parseRepeatValue("repeat-x");
			Assert.assertTrue(result.horizontalRepeat);
			Assert.assertFalse(result.verticalRepeat);
			
			result = this._parser.parseRepeatValue("repeat-y");
			Assert.assertFalse(result.horizontalRepeat);
			Assert.assertTrue(result.verticalRepeat);
			
			result = this._parser.parseRepeatValue("no-repeat");
			Assert.assertFalse(result.horizontalRepeat);
			Assert.assertFalse(result.verticalRepeat);
		}
		
		[Test(description="Ensures that an anchoring or alignment value may be parsed correctly")]
		public function alignmentValuesParseCorrectly():void
		{
			var result:AlignmentValue;
			
			result = this._parser.parseAlignmentValue("top");
			Assert.assertTrue(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);
			
			result = this._parser.parseAlignmentValue("left");
			Assert.assertFalse(result.topAlign);
			Assert.assertTrue(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);

			result = this._parser.parseAlignmentValue("right");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertTrue(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);

			result = this._parser.parseAlignmentValue("bottom");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertTrue(result.bottomAlign);

			result = this._parser.parseAlignmentValue("top left");
			Assert.assertTrue(result.topAlign);
			Assert.assertTrue(result.leftAlign);
			Assert.assertFalse(result.rightAlign);
			Assert.assertFalse(result.bottomAlign);
		
			result = this._parser.parseAlignmentValue("right bottom");
			Assert.assertFalse(result.topAlign);
			Assert.assertFalse(result.leftAlign);
			Assert.assertTrue(result.rightAlign);
			Assert.assertTrue(result.bottomAlign);
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
		
		[Test(description="Ensures that color values may be identified")]
		public function colorValuesIdentifyCorrectly():void
		{
			var testValid:Array = ["0xFF0000", "#FF0000", "red"];
			for(var i:uint = 0; i < testValid.length; i++)
			{
				Assert.assertTrue("Should be a valid color: "+testValid[i], this._parser.valueIsColorValue(testValid[i]));
			}
			
			var testInvalid:Array = ["lulz"];
			for(i = 0; i < testInvalid.length; i++)
			{
				Assert.assertFalse(this._parser.valueIsColorValue(testInvalid[i]));
			}
		}
		
		[Test(description="Ensures that basic color values using both hex and CSS color words parse correctly.")]
		public function colorValuesParseCorrectly():void
		{
			var testColors:Array = ["FF0000", "0xFF0000", "#FF0000", "red"];
			var cVal:ColorValue;
			for(var i:uint=0; i<testColors.length; i++)
			{
				cVal = this._parser.parseColorValue(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0xFF0000, cVal.hexValue);
			}
			
			testColors = ["008000", "0x008000", "#008000", "green"];
			for(i=0; i<testColors.length; i++)
			{
				cVal = this._parser.parseColorValue(testColors[i]);
				Assert.assertEquals("Failing on test color string: "+testColors[i], 0x008000, cVal.hexValue);
			}
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
			Assert.assertEquals("foo.css", (result[0] as URLValue).url);
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media1"));
			Assert.assertTrue((result[1] as MediaSelector).hasMedia("media2"));
			
			result = this._parser.parseImportArguments("url('foo.css')");
			Assert.assertEquals("foo.css",  (result[0] as URLValue).url);
			Assert.assertEquals(null, result[1]);
			
			result = this._parser.parseImportArguments("\"foo.css\" media1, media2");
			Assert.assertEquals("foo.css", (result[0] as URLValue).url);
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
				var result:Array = this._parser.parseURLTokenWithExtent(tokens[i]);
				Assert.assertEquals("foo.css",  (result[0] as URLValue).url);
				Assert.assertEquals(tokenLengths[i], result[1]);
			}
		}
		
	}
}
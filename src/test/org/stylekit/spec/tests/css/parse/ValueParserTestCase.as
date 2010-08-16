package org.stylekit.spec.tests.css.parse
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	import org.flexunit.async.Async;
		
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
		
	}
}
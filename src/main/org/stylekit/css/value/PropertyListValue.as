package org.stylekit.css.value
{
	
	import org.utilkit.util.StringUtil;
	import org.stylekit.css.value.Value;
	import org.stylekit.css.parse.ValueParser;
	
	public class PropertyListValue extends Value
	{
		
		public static var METAPROPERTY_ALL:String = "all";
		public static var METAPROPERTY_NONE:String = "none";
		
		public var _properties:Vector.<String>;
		public var _all:Boolean = false;
		
		public function PropertyListValue()
		{
			super();
			this._properties = new Vector.<String>();
		}
		
		public function get properties():Vector.<String>
		{
			return this._properties;
		}
		
		public function set properties(p:Vector.<String>):void
		{
			this._properties = p;
		}
		
		public static function parse(str:String):PropertyListValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var plVal:PropertyListValue = new PropertyListValue();
				plVal.rawValue = str;
				
			var tokens:Vector.<String> = ValueParser.parseCommaDelimitedString(str);
			for(var i:uint=0; i < tokens.length; i++)
			{
				if(tokens[i] == PropertyListValue.METAPROPERTY_ALL)
				{
					plVal._all = true;
					plVal.properties = new Vector.<String>();
					break;
				}
				else if(tokens[i] == PropertyListValue.METAPROPERTY_NONE)
				{
					plVal.properties = new Vector.<String>();
					break;
				}
				else
				{
					plVal.addProperty(tokens[i]);
				}
			}
			
			return plVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
				
			var tokens:Vector.<String> = ValueParser.parseCommaDelimitedString(str);
			var unitPattern:RegExp = /(([a-z-]+,?))+/;
			var unitIndex:int = str.search(unitPattern);
			return (unitIndex == 0);
		}
		
		public function addProperty(p:String):void
		{
			if(!this.hasProperty(p))
			{
				this._properties.push(p);
				this.modified();
			}
		}
		
		public function removeProperty(p:String):void
		{
			if(this.hasProperty(p))
			{
				var i:int = this._properties.indexOf(p);
				if(i > -1)
				{
					this._properties.splice(i, 1);
					this.modified();
				}
			}
		}
		
		public function hasProperty(p:String):Boolean
		{
			if(this._all)
			{
				return true;
			}
			else
			{
				return (this.properties.indexOf(p) > -1);
			}
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if (other is PropertyListValue)
			{
				return false;
			}
			
			return super.isEquivalent(other);
		}
	}
}
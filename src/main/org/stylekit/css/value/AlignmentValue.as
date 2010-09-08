package org.stylekit.css.value
{
	
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	/**
	* An AlignmentValue represents any type of anchoring or alignment in a CSS statement. text-align, background-position and other such properties are good examples.
	* An AlignmentValue may have a horizontalAlign value and a verticalAlign value.
	*/
	public class AlignmentValue extends Value
	{
		
		public static var ALIGN_TOP:uint = 1;
		public static var ALIGN_RIGHT:uint = 2;
		public static var ALIGN_BOTTOM:uint = 3;
		public static var ALIGN_LEFT:uint = 4;
		
		protected var _horizontalAlign:uint;
		protected var _verticalAlign:uint;
		
		public function AlignmentValue()
		{
			super();
		}
		
		public static function parse(str:String):AlignmentValue
		{
			var aVal:AlignmentValue = new AlignmentValue();
				aVal.rawValue = str;
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			
			for(var i:uint = 0; i < tokens.length; i++)
			{
				var t:String = tokens[i].toLowerCase();
				
				switch(t)
				{
					case "left":
						aVal.horizontalAlign = AlignmentValue.ALIGN_LEFT;
						break;
					case "right":
						aVal.horizontalAlign = AlignmentValue.ALIGN_RIGHT;
						break;
					case "top":
						aVal.verticalAlign = AlignmentValue.ALIGN_TOP;
						break;
					case "bottom":
						aVal.verticalAlign = AlignmentValue.ALIGN_BOTTOM;
						break;
				}
			}
			
			return aVal;
		}
		
		/**
		* Identifies a string as a valid candidate AlignmentValue string. Returns true if the string appears valid.
		*/
		public static function identify(str:String):Boolean
		{
			var tokens:Vector.<String> = ValueParser.parseSpaceDelimitedString(str);
			var valid:Array = ["left", "right", "top", "bottom"];
			for(var i:uint = 0; i < tokens.length; i++)
			{
				if(valid.indexOf(tokens[i].toLowerCase()) == -1)
				{
					return false;
				}
			}
			return true;
		}
		
		public function get horizontalAlign():uint
		{
			return this._horizontalAlign;
		}
		
		public function set horizontalAlign(a:uint):void
		{
			this._horizontalAlign = a;
		}
		
		public function get verticalAlign():uint
		{
			return this._verticalAlign;
		}

		public function set verticalAlign(a:uint):void
		{
			this._verticalAlign = a;
		}
		
		public function get leftAlign():Boolean
		{
			return (this.horizontalAlign == AlignmentValue.ALIGN_LEFT);
		}
		
		public function get rightAlign():Boolean
		{
			return (this.horizontalAlign == AlignmentValue.ALIGN_RIGHT);
		}
		
		public function get topAlign():Boolean
		{
			return (this.verticalAlign == AlignmentValue.ALIGN_TOP);
		}
		
		public function get bottomAlign():Boolean
		{
			return (this.verticalAlign == AlignmentValue.ALIGN_BOTTOM);
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is AlignmentValue)
			{
				var align:AlignmentValue = (other as AlignmentValue);
				var validates:Boolean = true;
				
				if (this.bottomAlign != align.bottomAlign) validates = false;
				if (this.leftAlign != align.leftAlign) validates = false;
				if (this.rightAlign != align.rightAlign) validates = false;
				if (this.topAlign != align.topAlign) validates = false;
				
				if (this.horizontalAlign != align.horizontalAlign) validates = false;
				if (this.verticalAlign != align.verticalAlign) validates = false;
				
				if (validates)
				{
					return true;
				}
			}
			
			return super.isEquivalent(other);
		}
	}
	
}
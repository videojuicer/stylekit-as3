package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;

	public class RepeatValue extends Value
	{
		
		protected var _horizontalRepeat:Boolean = false;
		protected var _verticalRepeat:Boolean = false;
		
		public function RepeatValue()
		{
			super();
		}
		
		public static function parse(str:String):RepeatValue
		{
			var rVal:RepeatValue = new RepeatValue();
				rVal.rawValue = str;
			str = StringUtil.trim(str).toLowerCase();
			
			switch(str)
			{
				case "repeat":
					rVal.horizontalRepeat = true;
					rVal.verticalRepeat = true;
					break;
				case "repeat-x":
					rVal.horizontalRepeat = true;
					rVal.verticalRepeat = false;
					break;
				case "repeat-y":
					rVal.horizontalRepeat = false;
					rVal.verticalRepeat = true;
					break;
				default:
					rVal.horizontalRepeat = false;
					rVal.verticalRepeat = false;
					break;
			}
			return rVal;
		}
		
		public static function identify(str:String):Boolean
		{
			return (["repeat", "repeat-x", "repeat-y", "no-repeat"].indexOf(StringUtil.trim(str).toLowerCase()) > -1);
		}
		
		public function get horizontalRepeat():Boolean
		{
			return this._horizontalRepeat;
		}
		
		public function set horizontalRepeat(r:Boolean):void
		{
			this._horizontalRepeat = r;
		}
		
		public function get verticalRepeat():Boolean
		{
			return this._verticalRepeat;
		}

		public function set verticalRepeat(r:Boolean):void
		{
			this._verticalRepeat = r;
		}

		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is RepeatValue)
			{
				return (this.horizontalRepeat == (other as RepeatValue).horizontalRepeat) && (this.verticalRepeat == (other as RepeatValue).verticalRepeat);
			}
			
			return super.isEquivalent(other);
		}
	}
}
package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	
	public class RepeatValue extends Value
	{
		
		protected var _horizontalRepeat:Boolean = false;
		protected var _verticalRepeat:Boolean = false;
		
		public function RepeatValue()
		{
			super();
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
	}
}
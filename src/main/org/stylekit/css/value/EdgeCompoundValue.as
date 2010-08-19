package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	
	public class EdgeCompoundValue extends Value
	{
		protected var _leftValue:Value;
		protected var _rightValue:Value;
		protected var _topValue:Value;
		protected var _bottomValue:Value;
		
		public function EdgeCompoundValue()
		{
			super();
		}
		
		public function get leftValue():Value
		{
			return this._leftValue;
		}
		
		public function set leftValue(v:Value):void
		{
			this._leftValue = v;
		}
		
		public function get rightValue():Value
		{
			return this._rightValue;
		}

		public function set rightValue(v:Value):void
		{
			this._rightValue = v;
		}
		
		public function get topValue():Value
		{
			return this._topValue;
		}

		public function set topValue(v:Value):void
		{
			this._topValue = v;
		}
		
		public function get bottomValue():Value
		{
			return this._bottomValue;
		}

		public function set bottomValue(v:Value):void
		{
			this._bottomValue = v;
		}
	}
}
package org.stylekit.css.value
{
	import org.stylekit.css.value.Value;
	import org.stylekit.css.value.ColorValue;
	import org.stylekit.css.value.URLValue;
	import org.stylekit.css.value.AlignmentValue;
	import org.stylekit.css.value.RepeatValue;
	
	/**
	* A BackgroundCompoundValue represents a shorthand "background: color image repeat position"
	*/
	public class BackgroundCompoundValue extends Value
	{
		
		protected var _colorValue:ColorValue;
		protected var _urlValue:URLValue;
		protected var _repeatValue:RepeatValue;
		protected var _alignmentValue:AlignmentValue;
		
		public function BackgroundCompoundValue(){
			super();
		}
		
		public function get colorValue():ColorValue
		{
			return this._colorValue;
		}
		
		public function set colorValue(c:ColorValue):void
		{
			this._colorValue = c;
		}
		
		public function get urlValue():URLValue
		{
			return this._urlValue;
		}
		
		public function set urlValue(u:URLValue):void
		{
			this._urlValue = u;
		}
		
		public function get repeatValue():RepeatValue
		{
			return this._repeatValue;
		}
		
		public function set repeatValue(r:RepeatValue):void
		{
			this._repeatValue = r;
		}
		
		public function get alignmentValue():AlignmentValue
		{
			return this._alignmentValue;
		}
		
		public function set alignmentValue(a:AlignmentValue):void
		{
			this._alignmentValue = a;
		}
	}
}
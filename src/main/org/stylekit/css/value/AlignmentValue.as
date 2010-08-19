package org.stylekit.css.value
{
	
	import org.stylekit.css.value.Value;
	
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
		
	}
	
}
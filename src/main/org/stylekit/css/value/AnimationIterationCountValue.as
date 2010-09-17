package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;
	import org.stylekit.css.value.Value;
	
	/**
	* Describes an animation-iteration-count value describing the number of times to repeat animations on any elements to which this
	* property is applied. Since multiple animations may be applied to an element using a style such as:
	* <code>foo { animation: anim1, anim2; }</code>
	* The other Animation properties are therefore allowed to specify multiple values mapped to each applied animation. For example:
	* <code>foo { animation: anim1, anim2; animation-iteration-count: 0, infinite }</code>
	*
	* This is handled through the <code>ValueArray</code> value type, which allows for multiple comma-sep values to be included in a list. 
	* The CSS parser will include all animation properties as ValueArrays.
	*
	* The individual value type classes will work for only individual values, so the CSS parser will interpret the "animation-iteration-count"
	* property as 
	*/
	public class AnimationIterationCountValue extends Value
	{
		
		public static var REPEAT_INFINITE:String = "infinite";
		
		protected var _iterationCount:Number = 0;
		
		public function AnimationIterationCountValue()
		{
			super();
		}
		
		public function get iterationCount():Number
		{
			return this._iterationCount;
		}
		
		public function set iterationCount(i:Number):void
		{
			this._iterationCount = i;
			this.modified();
		}
		
		public static function parse(str:String):AnimationIterationCountValue
		{
			str = StringUtil.trim(str.toLowerCase());
			var aicVal:AnimationIterationCountValue = new AnimationIterationCountValue();
				aicVal.rawValue = str;
				
				if(str == AnimationIterationCountValue.REPEAT_INFINITE)
				{
					aicVal.iterationCount = Infinity;
				}
				else
				{
					aicVal.iterationCount = parseInt(str);
				}
				
			return aicVal;
		}
		
		public static function identify(str:String):Boolean
		{
			str = StringUtil.trim(str.toLowerCase());
			return (str == AnimationIterationCountValue.REPEAT_INFINITE || str.search(/^[0-9]+$/) == 0)
		}
		
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is AnimationIterationCountValue)
			{
				return (this.iterationCount == (other as AnimationIterationCountValue).iterationCount);
			}
			return super.isEquivalent(other);
		}
	}
}
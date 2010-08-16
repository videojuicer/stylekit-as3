package org.stylekit.css.style.selector
{
	/**
	* A <code>MediaSelector</code> object may be applied to a StyleSheet or 
	*/
	public class MediaSelector
	{
		
		protected var _media:Vector.<String>;
		
		public function MediaSelector()
		{
			this._media = new Vector.<String>();
		}
		
		public function matches(mediaVec:Vector.<String>):Boolean
		{
			for(var i:uint=0; i < mediaVec.length; i++)
			{
				if(this.hasMedia(mediaVec[i]))
				{
					return true;
				}
			}
			return false;
		}
		
		public function addMedia(m:String):Boolean
		{
			if(this.hasMedia(m))
			{
				return false;
			}
			this._media.push(m);
			return true;
		}
		
		public function hasMedia(m:String):Boolean
		{
			return (this._media.indexOf(m) > -1);
		}
		
		public function removeMedia(m:String):Boolean
		{
			if(this.hasMedia(m))
			{
				this._media.splice(this._media.indexOf(m), 1);
				return true;
			}
			return false;
		}
	}
}
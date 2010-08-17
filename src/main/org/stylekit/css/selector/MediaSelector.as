package org.stylekit.css.selector
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
		
		public function get media():Vector.<String>
		{
			return this._media;
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
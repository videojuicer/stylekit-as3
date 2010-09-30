package org.stylekit
{
	import org.utilkit.logger.ApplicationLog;

	public class StyleKit
	{
		private static var __version:String = "0.1.0";
		private static var __applicationLog:ApplicationLog = new ApplicationLog("stylekit-as3");
		
		/**
		 * Retrieve's the current StyleKit version.
		 */
		public static function get version():String
		{
			return StyleKit.__version;
		}
		
		public static function get logger():ApplicationLog
		{
			return StyleKit.__applicationLog;
		}
	}
}
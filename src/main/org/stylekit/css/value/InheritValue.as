/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is the StyleKit library.
 *
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 *
 * ***** END LICENSE BLOCK ***** */
package org.stylekit.css.value
{
	import org.stylekit.css.property.Property;
	import org.stylekit.css.style.Style;
	import org.stylekit.ui.element.UIElement;

	public class InheritValue extends Value
	{
		protected var _propertyName:String;
		
		public function InheritValue(propertyName:String, rawValue:String = "inherit")
		{
			super();
			
			this._propertyName = propertyName;
			this._rawValue = rawValue;
		}
		
		public function resolveValue(uiElement:UIElement):Value
		{
			var value:Value = null;
			var styleParent:UIElement = uiElement.styleParent;
			
			do
			{
				var pVal:Value = styleParent.getStyleValue(this._propertyName);
				
				if (pVal != null)
				{
					if (pVal is InheritValue)
					{
						// keep going
					}
					else
					{
						value = pVal;
					}
				}

				styleParent = styleParent.styleParent;
			}
			while (value == null && styleParent != null);
			
			return value;
		}
		
		public static function identify(str:String):Boolean
		{
			return (str == "inherit");
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (other is InheritValue)
			{
				return (this.stringValue == other.stringValue);
			}
			
			return super.isEquivalent(other);
		}
	}
}
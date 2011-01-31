package org.stylekit.spec
{
	
	import org.stylekit.spec.tests.css.StyleSheetCollectionTestCase;
	import org.stylekit.spec.tests.css.StyleSheetTestCase;
	import org.stylekit.spec.tests.css.parse.ElementSelectorParserTestCase;
	import org.stylekit.spec.tests.css.parse.StyleSheetParserTestCase;
	import org.stylekit.spec.tests.css.parse.ValueParserTestCase;
	import org.stylekit.spec.tests.css.selector.ElementSelectorTestCase;
	import org.stylekit.spec.tests.css.selector.MediaSelectorTestCase;
	import org.stylekit.spec.tests.css.style.AnimationTestCase;
	import org.stylekit.spec.tests.css.value.AlignmentValueTestCase;
	import org.stylekit.spec.tests.css.value.AnimationCompoundValueTestCase;
	import org.stylekit.spec.tests.css.value.AnimationDirectionValueTestCase;
	import org.stylekit.spec.tests.css.value.AnimationIterationCountValueTestCase;
	import org.stylekit.spec.tests.css.value.BackgroundCompoundValueTestCase;
	import org.stylekit.spec.tests.css.value.BorderCompoundValueTestCase;
	import org.stylekit.spec.tests.css.value.ColorValueTestCase;
	import org.stylekit.spec.tests.css.value.CursorValueTestCase;
	import org.stylekit.spec.tests.css.value.DisplayValueTestCase;
	import org.stylekit.spec.tests.css.value.FontCompoundValueTestCase;
	import org.stylekit.spec.tests.css.value.FontStyleValueTestCase;
	import org.stylekit.spec.tests.css.value.FontVariantValueTestCase;
	import org.stylekit.spec.tests.css.value.FontWeightValueTestCase;
	import org.stylekit.spec.tests.css.value.LineStyleValueTestCase;
	import org.stylekit.spec.tests.css.value.OverflowValueTestCase;
	import org.stylekit.spec.tests.css.value.PositionValueTestCase;
	import org.stylekit.spec.tests.css.value.PropertyListValueTestCase;
	import org.stylekit.spec.tests.css.value.SizeValueTestCase;
	import org.stylekit.spec.tests.css.value.TextAlignValueTestCase;
	import org.stylekit.spec.tests.css.value.TextDecorationValueTestCase;
	import org.stylekit.spec.tests.css.value.TextTransformValueTestCase;
	import org.stylekit.spec.tests.css.value.TimeValueTestCase;
	import org.stylekit.spec.tests.css.value.TimingFunctionValueTestCase;
	import org.stylekit.spec.tests.css.value.TransitionCompoundValueTestCase;
	import org.stylekit.spec.tests.css.value.URLValueTestCase;
	import org.stylekit.spec.tests.css.value.ValueArrayTestCase;
	import org.stylekit.spec.tests.css.value.VisibilityValueTestCase;
	import org.stylekit.spec.tests.ui.element.UIElementTestCase;
	import org.stylekit.spec.tests.ui.element.layout.FlowControlLineTestCase;
	import org.stylekit.spec.tests.ui.element.paint.UIElementPainterTestCase;
	import org.stylekit.spec.tests.ui.element.worker.TransitionWorkerTestCase;
	
	import org.stylekit.spec.tests.integration.layout.AbsolutePositioningIntegrationTestCase;
	import org.stylekit.spec.tests.integration.layout.ElementSizeIntegrationTestCase;
	import org.stylekit.spec.tests.integration.layout.ElementFlowIntegrationTestCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StyleKitSuite
	{
		public var styleSheetCollectionTest:StyleSheetCollectionTestCase;
		public var styleSheetTest:StyleSheetTestCase;
		
		public var styleSheetParserTest:StyleSheetParserTestCase;
		public var elementSelectorParserTest:ElementSelectorParserTestCase;
		public var valueParserTest:ValueParserTestCase;
		
		public var elementSelectorTest:ElementSelectorTestCase;
		public var uiElementTest:UIElementTestCase;
		public var mediaSelectorTest:MediaSelectorTestCase;
		public var animationTest:AnimationTestCase;
		public var flowControlLineTest:FlowControlLineTestCase;
		
		public var sizeValueTest:SizeValueTestCase;
		public var timeValueTest:TimeValueTestCase;
		public var alignmentValueTest:AlignmentValueTestCase;
		public var urlValueTest:URLValueTestCase;
		public var colorValueTest:ColorValueTestCase;
		public var lineStyleValueTest:LineStyleValueTestCase;
		public var fontStyleValueTest:FontStyleValueTestCase;
		public var fontVariantValueTest:FontVariantValueTestCase;
		public var fontWeightValueTest:FontWeightValueTestCase;
		public var propertyListValueTest:PropertyListValueTestCase;
		public var timingFunctionValueTest:TimingFunctionValueTestCase;
		
		public var valueArrayTest:ValueArrayTestCase;
		
		public var animationIterationCountValueTest:AnimationIterationCountValueTestCase;
		public var animationDirectionValueTest:AnimationDirectionValueTestCase;
		
		public var backgroundCompoundValueTest:BackgroundCompoundValueTestCase;
		public var borderCompoundValueTest:BorderCompoundValueTestCase;
		public var fontCompoundValueTest:FontCompoundValueTestCase;
		public var animationCompoundValueTest:AnimationCompoundValueTestCase;
		public var transitionCompoundValueTest:TransitionCompoundValueTestCase;
		
		public var visibilityValueTest:VisibilityValueTestCase;
		public var textTransformValueTest:TextTransformValueTestCase;
		public var textDecorationValueTest:TextDecorationValueTestCase;
		public var textAlignValueTest:TextAlignValueTestCase;
		public var positionValueTest:PositionValueTestCase;
		public var overflowValueTest:OverflowValueTestCase;
		
		public var displayValueTest:DisplayValueTestCase;
		public var cursorValueTest:CursorValueTestCase;
		
		public var transitionWorkerTest:TransitionWorkerTestCase;
		public var uiElementPainterTest:UIElementPainterTestCase;
		
		// LAYOUT INTEGRATION TESTS
		public var absolutePositioningIntegrationTest:AbsolutePositioningIntegrationTestCase;
		public var elementSizeIntegrationTest:ElementSizeIntegrationTestCase;
		public var elementFlowIntegrationTest:ElementFlowIntegrationTestCase;

	}
}
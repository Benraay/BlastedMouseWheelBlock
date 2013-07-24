package com.kumokairo.mousewheel 
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	/**
	 * BlastedMouseWheelBlock - stops simultaneous browser/Flash mousewheel scrolling including chrome pepper flash plugin
	 * @author KumoKairo
	 * @version 0.9
	 * @usage Call BlastedMouseWheelBlock(stage,"yourFlashObjectId") - the second parameter is and ID or NAME of 
	 * your SWFOBJECT attributes. 
	 * @see https://github.com/KumoKairo/BlastedMouseWheelBlock for possible updates and bug reports
	 * feel free to modify this software
	 */ 
	public class BlastedMouseWheelBlock 
	{
		/**
		 * Errors
		 */
		private static const NEW_OBJECT_ERROR:String = "You don't have to create an instance of this class. Call BlastedMouseWheelBlock.initialize(..) instead";
		private static const NO_EXTERNAL_INTERFACE_ERROR:String = "No External Interface available. Please, disable BlastedMouseWheelBlock";
		
		/**
		 * Javascript functions and function names
		 * You have to pass correct flash object ID or NAME
		 * externalJavascriptFunction is a concatenation of three strings: part1 + your flash ID or NAME + part2
		 */
		private static const EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION:String = "allowBrowserScroll";
		private static const EXTERNAL_JAVASCRIPT_FUNCTION_P1:String = "if (window.addEventListener) { window.addEventListener('mousewheel', wheelHandler, true); window.addEventListener('DOMMouseScroll', wheelHandler, true); window.addEventListener('scroll', wheelHandler, true); } window.onmousewheel = wheelHandler; document.onmousewheel = wheelHandler; var browserScrollAllow = true; function wheelHandler(event) { if (!event) {   event = window.event  } if(!browserScrollAllow) { if(window.chrome) { document.getElementById('";
		private static const EXTERNAL_JAVASCRIPT_FUNCTION_P2:String = "').scrollHappened(event.wheelDeltaY); } if(event.preventDefault) { event.preventDefault(); } else { event.returnValue = false; } } } function allowBrowserScroll(allow) { browserScrollAllow = allow; }";
		private static var externalJavascriptFunction:String;
		
		private static var nativeStage:Stage;
		//private static var curren
		public function BlastedMouseWheelBlock() 
		{
			throw new IllegalOperationError(NEW_OBJECT_ERROR);
		}

		/**
		 * Init function, use this to setup your BlastedMouseWheelBlock
		 * @param	stage - link to your current stage
		 * @param	flashObjectID - id or name of your flash object on the HTML page (can be found in attributes of SWFobject)
		 */
		public static function initialize(stage:Stage, flashObjectID:String = 'flashObject'):void
		{
			if (ExternalInterface.available)
			{
				externalJavascriptFunction = EXTERNAL_JAVASCRIPT_FUNCTION_P1 + flashObjectID + EXTERNAL_JAVASCRIPT_FUNCTION_P2;
				BlastedMouseWheelBlock.nativeStage = stage;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverStage);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeavesStage);
			
				ExternalInterface.addCallback("scrollHappened", scrollHappened);
				ExternalInterface.call("eval", externalJavascriptFunction);
			}
			else
			{
				throw new UninitializedError(NO_EXTERNAL_INTERFACE_ERROR);
			}
		}
		
		static private function scrollHappened(wheelDelta:Number):void 
		{
			nativeStage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, nativeStage.mouseX, nativeStage.mouseY, null, false, false, false, false, wheelDelta/40));
		}
		
		static private function mouseOverStage(e:MouseEvent):void 
		{
			if (nativeStage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseOverStage);
			}
			nativeStage.addEventListener(Event.MOUSE_LEAVE, mouseLeavesStage);

			ExternalInterface.call(EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION, false);
		}
		
		static private function mouseLeavesStage(e:Event):void 
		{
			if (nativeStage.hasEventListener(Event.MOUSE_LEAVE))
			{
				nativeStage.removeEventListener(Event.MOUSE_LEAVE, mouseLeavesStage);
			}
			nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverStage);
			
			ExternalInterface.call(EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION, true);
		}
	}

}
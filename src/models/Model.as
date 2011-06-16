package models 
{		
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.utils.ByteArray;
	
	import models.valueObject.Frame;
	
	import mx.collections.ArrayCollection;
	import mx.graphics.codec.JPEGEncoder;
	
	import spark.components.List;
	
	// Class to save movies: http://www.zeropointnine.com/blog/assets_code/SimpleFlvWriter.as.txt
	
	[Bindable]
	public class Model extends EventDispatcher
	{		
		public var camera:Camera;
		public var _camWidth:Number;
		public var _camHeight:Number;
				
		private var _frames:ArrayCollection;
		
		private var _defaultFrameDuration:Number = 800;
		private var frameId:int = 0;	
		
		public var nextIndex:int = 0;
		private var _currentIndex:int = 0;	
		
		private var _timerTime:int;

		public function Model():void {			
			camWidth = 640;
			
			timerTime = 60;
			
			_frames = new ArrayCollection();
		}
		
		// -----------------------------------------------------
		public function initWebcam():Boolean {
			
			camera = Camera.getCamera();
			if (camera) {
				camera.setMode(camWidth, camHeight, 24, false);
				camera.setQuality(0, 90);
				return true;
			} else {
				return false;
			}
		}
		
		// -----------------------------------------------------
		public function recordFrame(bitmapData:BitmapData):void {
			
			var frame:Frame = new Frame();
			
			frame.bitmapData = bitmapData;
			frame.duration = defaultFrameDuration;
			frame.id = frameId;
			
			frames.addItemAt(frame, nextIndex);
			
			// -------------------------------------------
			// SAVE TO FILE
			var time:Date = new Date();
			var seconds:uint = time.getSeconds();
			var minutes:uint = time.getMinutes();
			var hours:uint = time.getHours();
			var timeString = hours.toString() + "." + minutes.toString() + "." + seconds.toString(); 
				
			var jpgenc:JPEGEncoder = new JPEGEncoder(80);
			var imgByteArray:ByteArray = jpgenc.encode(bitmapData);			
			
			var fl:File = File.desktopDirectory.resolvePath("party/" + timeString + ".jpg");
			
			var fs:FileStream = new FileStream();
			try {
				//open file in write mode
				fs.open(fl, FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(imgByteArray);
				//close the file
				fs.close();
			} catch(e:Error) {
				trace(e.message);
			}
			// -------------------------------------------
			frameId++;
		}
		
		// -----------------------------------------------------
		public function nextFrame():void {
			if(currentIndex == frames.length - 1)
				currentIndex = 0;
			else
				currentIndex += 1;	
		}
		
		public function previousFrame():void {
			if(currentIndex > 0)
				currentIndex -= 1;
			else 
				currentIndex = frames.length - 1;
		}
		
		// -----------------------------------------------------
		public function removeFrame(frameList:List):void {
			
			for each(var s:Frame in frameList.selectedItems){
				var tmpIndex:int = frameList.selectedIndex;
				frames.removeItemAt(frames.getItemIndex(s));
				frameList.selectedIndex = tmpIndex;
			}

			nextIndex = frameList.selectedIndex;			
		}

		// -----------------------------------------------------
		// GETTER & SETTER
		public function get frames():ArrayCollection {
			return _frames;
		}
		
		public function get camWidth():Number {
			return _camWidth;
		}
		
		public function get camHeight():Number {
			return _camHeight;
		}
		
		public function set camHeight(value:Number):void {
			if(value == camHeight)
				return;
			
			_camHeight = value;
		}
		
		public function set camWidth(value:Number):void	{
			if(value == camWidth)
				return;
			
			_camWidth = value;
			
			camHeight = camWidth / 1.3;
		}
		
		public function get currentIndex():int {
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void {
			if(value == currentIndex) 
				return;
			_currentIndex = value;
		}
		
		public function get timerTime():int {
			return _timerTime;
		}
		
		public function set timerTime(value:int):void {
			_timerTime = value;
		}
		
		public function get defaultFrameDuration():Number {
			return _defaultFrameDuration;
		}
		
		public function set defaultFrameDuration(value:Number):void	{
			_defaultFrameDuration = value;
		}
	}
}
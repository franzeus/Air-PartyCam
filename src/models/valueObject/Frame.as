package models.valueObject
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class Frame extends EventDispatcher
	{
		public var id:int;
		public var bitmapData:BitmapData;
		public var duration:Number;
		
		public function Frame(target:IEventDispatcher=null)	{
			super(target);
		}
	}
}
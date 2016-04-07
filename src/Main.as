package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class Main extends Sprite
	{
		private var _loadedBitmaps:Vector.<Bitmap>;
		
		public function Main()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			// Input
			var inputManager:InputManager = new InputManager();
			var resourceFolder:File = File.applicationDirectory.resolvePath("Resources");
			inputManager.setup(resourceFolder, this);
			
			// Packing
			
			// Output
			
			
			
			
			
			resourceFolder = null;
		}
		
		public function setBitmaps(bitmaps:Vector.<Bitmap>):void
		{
			_loadedBitmaps = bitmaps;
		}
		
		private function onExit(event:Event):void
		{
			if (_loadedBitmaps)
			{
				for (var i:int = 0; i < _loadedBitmaps.length; i++)
				{
					_loadedBitmaps[i] = null;
				}
				_loadedBitmaps = null;
			}	

			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
		}
	}
}
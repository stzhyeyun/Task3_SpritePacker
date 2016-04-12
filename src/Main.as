package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class Main extends Sprite
	{
		private var _resourceFolder:File;
		private var _packer:Packer;
		private var _outputManager:OutputManager;
		private var _sprites:Vector.<Bitmap>;
		private var _packData:Vector.<PackData>;
		
		public function Main()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			// Input
			_resourceFolder = File.applicationDirectory.resolvePath("Resources");
			
			var inputManager:InputManager = new InputManager();
			inputManager.setup(_resourceFolder, this);
			
//			var _resourceFolder:File = new File(); 
//			_resourceFolder.addEventListener(Event.SELECT, onDirectorySelected); 
//			_resourceFolder.browseForDirectory("Select a directory"); 
//			function onDirectorySelected(event:Event):void
//			{
//				startLoading();
//			}
		}
		
		public function setBitmaps(sprites:Vector.<Bitmap>):void
		{
			_sprites = sprites;
			
			startPacking();
		}
		
		private function startLoading():void
		{
			var inputManager:InputManager = new InputManager();
			inputManager.setup(_resourceFolder, this);
		}
		
		private function startPacking():void
		{
			// Packing
			if (!_packer)
			{
				_packer = new Packer(2048); 
			}
			_packData = _packer.pack(_sprites, true);
		}
		
		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			_resourceFolder = null;
			
			if (_sprites)
			{
				for (var i:int = 0; i < _sprites.length; i++)
				{
					_sprites[i] = null;
				}
				_sprites = null;
			}				
		}
	}
}
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
		private var _sprites:Vector.<Bitmap>;
		
		public function Main()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			// Input
			_resourceFolder = File.applicationDirectory.resolvePath("Resources");
			
			var inputManager:InputManager = new InputManager();
			inputManager.setup(_resourceFolder, this);
		}
		
		public function setBitmaps(sprites:Vector.<Bitmap>):void
		{
			_sprites = sprites;
			
			startPacking();
		}
		
		private function startPacking():void
		{
			// Packing & Output
			var packer:Packer = new Packer();
			var outputManager:OutputManager = new OutputManager();
			
			outputManager.export("HOS", packer.pack(_sprites)); // 선택한 폴더명으로 디폴트 지정할 것
		}
		
		private function onExit(event:Event):void
		{
			_resourceFolder = null;
			
			if (_sprites)
			{
				for (var i:int = 0; i < _sprites.length; i++)
				{
					_sprites[i] = null;
				}
				_sprites = null;
			}	

			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
		}
	}
}
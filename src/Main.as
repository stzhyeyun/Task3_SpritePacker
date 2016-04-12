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
		private var _inputManager:InputManager;
		private var _packer:Packer;
		private var _outputManager:OutputManager;
		private var _sprites:Vector.<Bitmap>;
		private var _packData:Vector.<PackData>;
		
		public function Main()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			// Input
			if (!_resourceFolder)
			{
				_resourceFolder = new File();
			}
			_resourceFolder.addEventListener(Event.CANCEL, onCanceled);
			_resourceFolder.addEventListener(Event.SELECT, onDirectorySelected);
			_resourceFolder.browseForDirectory("Select Resource Folder");
		}
		
		public function setBitmaps(sprites:Vector.<Bitmap>):void
		{
			_sprites = sprites;
			
			startPacking();
		}
		
		private function startLoading():void
		{
			if (!_inputManager)
			{
				_inputManager = new InputManager();
			}
			_inputManager.setup(_resourceFolder, this);
		}
		
		public function startExporting():void
		{
			if (!_outputManager)
			{
				_outputManager = new OutputManager(this);
			}
			
			if (_packData && _packData.length > 0)
			{
				_outputManager.export("temp", _packData[0]);
				_packData.shift();
			}
			else
			{
				trace("[Main] End of Process");
				
				clean();
			}
		}
		
		private function startPacking():void
		{
			// Packing
			if (!_packer)
			{
				_packer = new Packer(2048); 
			}
			_packData = _packer.pack(_sprites, true);

			startExporting();
		}
		
		private function clean():void
		{
			_resourceFolder = null;
			_outputManager = null;
			
			_packer.clean();
			_packer = null;
			
			if (_sprites && _sprites.length > 0)
			{
				for (var i:int = 0; i < _sprites.length; i++)
				{
					_sprites[i] = null;
				}
			}
			_sprites = null;
			
			if (_packData && _packData.length > 0)
			{
				for (var i:int = 0; i < _packData.length; i++)
				{
					_packData[i].dispose();
					_packData[i] = null;
				}
			}
			_packData = null;
		}
		
		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			clean();
		}
		
		private function onCanceled(event:Event):void
		{
			// to do
			
		}
		
		private function onDirectorySelected(event:Event):void
		{
			_resourceFolder = File(event.target); // 선택된 디렉토리
			startLoading();
		}
	}
}
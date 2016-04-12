package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Main extends Sprite
	{
		private var _resourceFolder:File;
		private var _exportFolder:File;
		private var _inputManager:InputManager;
		private var _packer:Packer;
		private var _outputManager:OutputManager;
		private var _sprites:Vector.<Bitmap>;
		private var _packData:Vector.<PackData>;
		private var _button:Sprite;
		
		public function Main()
		{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			setButton(250, 30);
		}
		
		public function setBitmaps(sprites:Vector.<Bitmap>):void
		{
			_sprites = sprites;
			
			startPacking();
		}
		
		private function setButton(width:Number, height:Number):void
		{
			_button = new Sprite();
			_button.buttonMode = true;
			_button.useHandCursor = false;
			_button.graphics.lineStyle(1, 0x000000);
			_button.graphics.beginFill(0xf2f2f2, 1);
			_button.graphics.drawRect(0, 0, width, height);
			_button.graphics.endFill();
			_button.x = (stage.nativeWindow.width / 2) - (_button.width / 2);
			_button.y = (stage.nativeWindow.height / 2) - (_button.height);
			_button.addEventListener(MouseEvent.CLICK, onClick);
			
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.bold = true;
			format.font = "Consolas";
			format.align = TextFormatAlign.CENTER;
			
			var textField:TextField = new TextField();
			textField.mouseEnabled = false;			 
			textField.width = width;
			textField.height = height;
			textField.defaultTextFormat = format;
			textField.text = "Create Sprite Sheet";
			_button.addChild(textField);
			
			addChild(_button);
		}
		
		private function startLoading():void
		{
			if (!_inputManager)
			{
				_inputManager = new InputManager();
			}
			_inputManager.setup(_resourceFolder, this);
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
		
		public function startExporting():void
		{
			if (!_outputManager)
			{
				_outputManager = new OutputManager(this);
			}
			
			if (_packData && _packData.length > 0)
			{
				_outputManager.export("temp", _packData[0]); // _exportFolder에 저장하도록 변경
				_packData.shift();
			}
			else
			{
				trace("[Main] End of Process");
				
				_button.mouseEnabled = true;
				clean();
			}
		}
		
		private function clean():void
		{
			_resourceFolder.removeEventListener(Event.SELECT, onResourceFolderSelected);
			_resourceFolder = null;			
			_exportFolder.removeEventListener(Event.SELECT, onResourceFolderSelected);
			_exportFolder = null;
			
			_outputManager = null;
			
			if (_packer)
			{
				_packer.clean();
			}
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
		
		private function onClick(event:Event):void
		{
			// Input
			if (!_resourceFolder)
			{
				_resourceFolder = new File();
			}
			_resourceFolder.addEventListener(Event.SELECT, onResourceFolderSelected);
			_resourceFolder.browseForDirectory("Select Resource Folder");
		}
		
		private function onResourceFolderSelected(event:Event):void
		{
			_resourceFolder = event.target as File; // 선택된 디렉토리
			
			if (!_exportFolder)
			{
				_exportFolder = new File();
			}
			_exportFolder.addEventListener(Event.SELECT, onExportFolderSelected);
			_exportFolder.browseForDirectory("Select Export Folder");
		}
		
		private function onExportFolderSelected(event:Event):void
		{
			_exportFolder = event.target as File; // 선택된 디렉토리
			
			_button.mouseEnabled = false;			
			
			startLoading();
		}
		
		private function onExit(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			_button.removeChildren();
			removeChildren();
			
			clean();
		}
	}
}
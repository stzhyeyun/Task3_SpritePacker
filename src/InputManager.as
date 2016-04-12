package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	
	public class InputManager
	{
		private var _orderer:Main;
		private var _loader:Loader;
		private var _loadList:Vector.<String>;
		private var _loadedBitmaps:Vector.<Bitmap>;
		private var _isLoading:Boolean;
		
		public function InputManager()
		{
			_isLoading = false;
		}
		
		public function setup(resourceFolder:File, orderer:Main):void
		{
			if (resourceFolder.isDirectory && resourceFolder.exists)
			{
				_orderer = orderer;
				
				if (!_loadList)
				{
					_loadList = new Vector.<String>();
				}
				
				var fileList:Array = resourceFolder.getDirectoryListing();

				for (var i:int = 0; i < fileList.length; i++)
				{	
					// 확장자로 필터링
					if(fileList[i].name.match(/\.(jpe?g|png)$/i))
					{
						var filepath:String = File(fileList[i]).nativePath;
						_loadList.push(filepath);
						
						trace("[InputManager] Enqueued ", filepath);
					}					
				}
				
				_isLoading = true;
				load();
			}
		}
		
		private function load():void
		{	
			if (_loadList)
			{
				if (!_loader)
				{
					_loader = new Loader();
				}
				
				if (_loadList.length > 0)
				{
					_loader.load(new URLRequest(_loadList[0]));
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				}
			}
		}
		
		private function onComplete(event:Event):void
		{
			var bitmapData:BitmapData = Bitmap(event.currentTarget.loader.content).bitmapData;
			
			var filepath:String = _loadList.shift();
			var filename:String = filepath.substring(filepath.lastIndexOf("\\") + 1, filepath.length);
			filename = filename.substring(0, filename.indexOf("."));
			
			var loadedBitmap:Bitmap = new Bitmap(bitmapData);
			loadedBitmap.name = filename;
			
			trace("[InputManager] Loaded ", loadedBitmap.name);
			
			if (!_loadedBitmaps)
			{
				_loadedBitmaps = new Vector.<Bitmap>();
			}
			_loadedBitmaps.push(loadedBitmap);
			
			if (_loadList.length > 0)
			{
				load();
			}
			else
			{
				_isLoading = false;
				shipBitmaps();
				clean();
			}
		}
		
		private function shipBitmaps():void
		{
			_orderer.setBitmaps(_loadedBitmaps);	
		}
		
		private function clean():void
		{
			_orderer = null;
			
			_loader.unload();
			_loader = null;
			
			if (_loadList && _loadList.length > 0)
			{
				for (var i:int = 0; i < _loadList.length; i++)
				{					
					_loadList[i] = null;
				}
			}
			_loadList = null;
			
			if (_loadedBitmaps && _loadedBitmaps.length > 0)
			{
				for (var i:int = 0; i < _loadedBitmaps.length; i++)
				{					
					_loadedBitmaps[i] = null;
				}
			}
			_loadedBitmaps = null;
		}
	}
}
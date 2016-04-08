package
{
	import flash.display.Bitmap;

	public class PackData
	{
		private var _spriteSheet:Bitmap;
		private var _spriteData:Vector.<SpriteData>;
		
		public function PackData()
		{

		}
		
		public function get spriteSheet():Bitmap
		{
			return _spriteSheet;
		}
		
		public function set spriteSheet(spriteSheet:Bitmap):void
		{
			_spriteSheet = spriteSheet;
		}
		
		public function get spriteData():Vector.<SpriteData>
		{
			if (!_spriteData)
			{
				_spriteData = new Vector.<SpriteData>();	
			}
			
			return _spriteData;	
		}		
	}
}
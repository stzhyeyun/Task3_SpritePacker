package
{
	import flash.display.BitmapData;

	public class PackData
	{
		private var _spriteSheet:BitmapData;
		private var _spriteData:Vector.<SpriteData>;
		
		public function PackData()
		{

		}
		
		public function get spriteSheet():BitmapData
		{
			return _spriteSheet;
		}
		
		public function set spriteSheet(spriteSheet:BitmapData):void
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
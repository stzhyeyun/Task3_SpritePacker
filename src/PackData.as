package
{
	import flash.display.BitmapData;

	public class PackData
	{
		private var _id:int;
		private var _numInput:int;
		private var _spriteSheet:BitmapData;
		private var _spriteData:Vector.<SpriteData>;
		
		public function PackData()
		{

		}
		
		public function dispose():void
		{
			_spriteSheet.dispose();
			
			if (_spriteData && _spriteData.length > 0)
			{
				for (var i:int = 0; i < _spriteData.length; i++)
				{
					_spriteData[i] = null;
				}
			}
			_spriteData = null;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(id:int):void
		{
			_id = id;
		}
		
		public function get numInput():int
		{
			return _numInput;
		}
		
		public function set numInput(num:int):void
		{
			_numInput = num;
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
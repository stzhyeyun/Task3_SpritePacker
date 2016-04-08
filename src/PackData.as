package
{
	import flash.display.Bitmap;

	public class PackData
	{
		private var _spriteSheet:Bitmap;
		private var _spriteData:Vector.<SpriteData>;
		
		public function PackData(spriteSheet:Bitmap, spriteData:Vector.<SpriteData>)
		{
			_spriteSheet = spriteSheet;
			_spriteData = spriteData;
		}
	}
}
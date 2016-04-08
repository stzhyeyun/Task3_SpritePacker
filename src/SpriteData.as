package
{
	public class SpriteData
	{
		private var _name:String;
		private var _width:Number;
		private var _height:Number;
		private var _x:Number;
		private var _y:Number;
		private var _isRotated:Boolean;		
		
		public function SpriteData()
		{
			_name = null;
			_width = 0;
			_height = 0;			
			_x = 0;
			_y = 0;
			_isRotated = false;			
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(name:String):void
		{
			_name = name;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(width:Number):void
		{
			_width = width;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(height:Number):void
		{
			_height = height;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(x:Number):void
		{
			_x = x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(y:Number):void
		{
			_y = y;
		}
		
		public function get isRotated():Boolean
		{
			return _isRotated;
		}
		
		public function set isRotated(isRotated:Boolean):void
		{
			_isRotated = isRotated;
		}
	}
}
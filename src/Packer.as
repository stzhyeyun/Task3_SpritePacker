package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{
		private var _size:Number;	
		private var _space:Vector.<Rectangle>;
		
		public function Packer()
		{
			_size = 2048;
		}
		
		public function pack(sprites:Vector.<Bitmap>):PackData // Maximal Rectangles Algorithm
		{
			// 면적으로 정렬
			sprites.sort(compareAreaForDescendingSort);

			// 패킹 준비
			var packData:PackData = new PackData();
			var canvas:BitmapData = new BitmapData(_size, _size, true, 0x00FFFFFF);
			if (!_space)
			{
				_space = new Vector.<Rectangle>();
			}
			_space.push(new Rectangle(0, 0, _size, _size));
				
			// 패킹
			var isPacked:Boolean = false;
			var unpackedSprites:Vector.<Bitmap>;
			
			while (sprites.length > 0)
			{			
				// _space 선택
				for (var i:int = 0; i < _space.length; i++)
				{
					if (isIn(_space[i], sprites[0]))
					{
						// 이미지 병합
						canvas.copyPixels(
							sprites[0].bitmapData,
							new Rectangle(0, 0, sprites[0].width, sprites[0].height),
							new Point(_space[i].x, _space[i].y));
						
						// SpriteData 작성
						var data:SpriteData = new SpriteData();
						data.name = sprites[0].name;
						data.width = sprites[0].width;
						data.height = sprites[0].height;
						data.x = _space[i].x;
						data.y = _space[i].y;

						packData.spriteData.push(data);
						isPacked = true;

						// 남은 _space 재설정						
						devideSpace(data);
												
						break;
					}
					else if (isInIfRotated(_space[i], sprites[0]))
					{
						// 스프라이트 회전 및 이동
						var mat:Matrix = new Matrix();
						mat.rotate(90 / 180 * Math.PI);
						mat.translate(_space[i].x + sprites[0].height, _space[i].y);
						
						// 이미지 병합
						canvas.draw(sprites[0].bitmapData, mat);
						
						// SpriteData 작성
						var data:SpriteData = new SpriteData();
						data.name = sprites[0].name;
						data.width = sprites[0].height;
						data.height = sprites[0].width;
						data.x = _space[i].x;
						data.y = _space[i].y;
						data.isRotated = true;
						
						packData.spriteData.push(data);
						isPacked = true;
						
						// 남은 _space 재설정	
						devideSpace(data);
						
						break;
					}
				} // for (var i:int = 0; i < _space.length; i++)
				
				// 패킹되지 못한 스프라이트 저장
				if (!isPacked)
				{
					if (!unpackedSprites)
					{
						unpackedSprites = new Vector.<Bitmap>();
					}
					unpackedSprites.push(sprites[0]);
				}
				sprites.shift();
								
				isPacked = false;
									
			} // while
			
			// 패킹되지 못한 스프라이트의 처리
			// to do
			
			// 스프라이트 시트 저장
			packData.spriteSheet = canvas;
			
			return packData;
		}

		private function devideSpace(mergedSprite:SpriteData):void
		{
			var devidedSpace:Vector.<Rectangle> = new Vector.<Rectangle>();
			
			// 병합한 스프라이트와 겹치는 Space를 검사
			for (var i:int = 0; i < _space.length; i++)
			{
				var doubled:Rectangle = _space[i].intersection(
					new Rectangle(mergedSprite.x, mergedSprite.y, 
						mergedSprite.width, mergedSprite.height));
				
				if (doubled.width != 0 && doubled.height != 0) // 겹치는 부분이 있음
				{
					var temp:Vector.<Rectangle> = new Vector.<Rectangle>();
					
					temp.push(new Rectangle(
						_space[i].x, _space[i].y, _space[i].width, doubled.y - _space[i].y));
					
					temp.push(new Rectangle(
						_space[i].x, doubled.y + doubled.height,
						_space[i].width, _space[i].y + _space[i].height - (doubled.y + doubled.height)));
					
					temp.push(new Rectangle(_space[i].x, _space[i].y, doubled.x - _space[i].x, _space[i].height));
						
					temp.push(new Rectangle(
						doubled.x + doubled.width, _space[i].y,
						_space[i].x + _space[i].width - (doubled.x + doubled.width), _space[i].height));	
						
					for (var j:int = 0; j < temp.length; j++)
					{
						if (temp[j].width > 0 && temp[j].height > 0)
						{
							devidedSpace.push(temp[j]);	
						}							
					}					
					
//					var top:Rectangle = new Rectangle(
//						_space[i].x, _space[i].y, _space[i].width, doubled.y - _space[i].y);
//					
//					var bottom:Rectangle = new Rectangle(
//						_space[i].x, doubled.y + doubled.height,
//						_space[i].width, _space[i].y + _space[i].height - (doubled.y + doubled.height));
//					
//					var left:Rectangle = new Rectangle(
//						_space[i].x, _space[i].y, doubled.x - _space[i].x, _space[i].height);
//					
//					var right:Rectangle = new Rectangle(
//						doubled.x + doubled.width, _space[i].y,
//						_space[i].x + _space[i].width - (doubled.x + doubled.width), _space[i].height);	
				}
				else
				{
					devidedSpace.push(_space[i]);
				}
			}
			
			// 유효하지 않은 공간 제거
			var removeIdList:Vector.<int>;
			for (var i:int = 0; i < devidedSpace.length - 1; i++)
			{
				var intersection:Rectangle = devidedSpace[i].intersection(devidedSpace[i + 1]);
				
				if (intersection.topLeft == devidedSpace[i + 1].topLeft
					&& intersection.bottomRight == devidedSpace[i + 1].bottomRight)
				{
					if (!removeIdList)
					{
						removeIdList = new Vector.<int>();
					}
					removeIdList.push(i + 1);
				}
			}
			
			if (removeIdList)
			{
				for (var i:int = 0; i < removeIdList.length; i++)
				{
					devidedSpace.removeAt(removeIdList[i]);
				}
			}
			
			// 결과 저장
			_space = devidedSpace;
		}
		
		private function isIn(space:Rectangle, sprite:Bitmap):Boolean
		{
			if (sprite.width <= space.width && sprite.height <= space.height)
			{
				return true;	
			}
			else
			{
				return false;	
			}			
		}
		
		private function isInIfRotated(space:Rectangle, sprite:Bitmap):Boolean
		{
			if (sprite.width <= space.height && sprite.height <= space.width)
			{
				return true;	
			}
			else
			{
				return false;	
			}			
		}
		
		private function trim():void // additional
		{
			
		}
		
		private function compareAreaForDescendingSort(x:Bitmap, y:Bitmap):int 
		{ 
			var areaX:Number = x.width * x.height;
			var areaY:Number = y.width * y.height;
			
			if (areaX < areaY) 
			{ 
				return 1; 
			} 
			else if (areaX > areaY)
			{ 
				return -1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}		
	}
}
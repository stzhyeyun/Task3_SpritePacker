package
{
	import com.adobe.images.PNGEncoder;	
	import flash.filesystem.File;
	
	public class OutputManager
	{
		public function OutputManager()
		{
			
		}
		
		public function export(outputName:String, data:PackData):void
		{
			// XML 작성
			
			
			
			// XMl 저장
			
			
			
			// 스프라이트 시트 저장
			var file:File = new File();
			file.save(PNGEncoder.encode(data.spriteSheet), outputName + ".png");		
		}
	}
}
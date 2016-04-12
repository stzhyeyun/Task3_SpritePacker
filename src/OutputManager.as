package
{
	import com.adobe.images.PNGEncoder;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class OutputManager
	{
		private var _orderer:Main;
		private var _exporter:File;
		private var _outName:String;
		private var _outdata:PackData;
		
		public function OutputManager(orderer:Main)
		{
			_orderer = orderer;
		}
		
		public function export(outputName:String, data:PackData):void
		{
			_exporter = new File();
			_outName = outputName;
			_outdata = data;
			
			// 디버깅 코드
			trace("[OutputManager] Input item : " + data.numInput.toString() +
				" / Packed item : " + data.spriteData.length.toString());
			
			// 스프라이트 시트 저장
			exportPNG();
		}
		
		private function exportPNG():void
		{
			trace("[OutputManager] Start exporting PNG");
			
			_exporter.save(PNGEncoder.encode(_outdata.spriteSheet), _outName + ".png");
			_exporter.addEventListener(Event.COMPLETE, onCompleteExportingPNG);
		}
		
		private function exportXML():void
		{
			trace("[OutputManager] Start exporting XML");
			
			// XML 작성
			var name:String = _outName + ".png"; // 사용자 지정 이름으로 변경할 것
			var width:String = _outdata.spriteSheet.width.toString();
			var height:String = _outdata.spriteSheet.height.toString();
			
			var xml:XML = 
				<SpriteSheet name = {name} width = {width} height = {height}> 
				</SpriteSheet>

			for (var i:int = 0; i < _outdata.spriteData.length; i++)
			{
				var name:String = _outdata.spriteData[i].name;
				var x:String = _outdata.spriteData[i].x.toString();
				var y:String = _outdata.spriteData[i].y.toString();
				var width:String = _outdata.spriteData[i].width.toString();
				var height:String = _outdata.spriteData[i].height.toString();
				var rotated:String = _outdata.spriteData[i].isRotated.toString();
				
				xml.appendChild(
					<Sprite name = {name} x = {x} y = {y} width = {width} height = {height} rotated = {rotated}>
					</Sprite>);
			}
			
			// XMl 저장
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(xml);
			
			_exporter.removeEventListener(Event.COMPLETE, onCompleteExportingPNG);
			_exporter.addEventListener(Event.COMPLETE, onCompleteExportingXML);
			_exporter.save(bytes, _outName + ".xml");
		}
		
		private function onCompleteExportingPNG(event:Event):void
		{
			trace("[OutputManager] Completed exporting PNG");
			
			exportXML();
		}
		
		private function onCompleteExportingXML(event:Event):void
		{
			trace("[OutputManager] Completed exporting XML");
			
			_exporter.removeEventListener(Event.COMPLETE, onCompleteExportingXML);		

			_orderer.startExporting();
			_exporter = null;
			_outName = null;
			_outdata.dispose();
		}
	}
}
package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class PKYEK extends MovieClip
	{
		
		public var player:Object;
		public var loader:Loader = new Loader();
		public var videoId:String = "e9AUSUSr2qc";
		
		public function PKYEK()
		{
			super();     
			registerEvents();
			initApp();
		} 
		
		private function registerEvents():void
		{  
			trace("we are in register Events");
			introBtn.addEventListener(MouseEvent.CLICK,handleIntroBtnClicked);
			abhayBtn.addEventListener(MouseEvent.CLICK,handleAbhayBtnClicked);
		} 
		
		private function handleIntroBtnClicked(event:MouseEvent):void 
		{
			trace("Intro button clicked");
		}
		private function handleAbhayBtnClicked(event:MouseEvent):void
		{
			trace("Abhay button clicked");   
		}
		
		
		//---------------------------- initApp ----------------------------
		
		private function initApp():void
		{
			trace("We are in init App");
			loadIntroPlayer();
			registerEventsForIntroVideo();
		}  
		
		//------------------------ video player for intro tab---------------------
		
		private function loadIntroPlayer():void
		{
			unmuteBtn.visible = false;
			trace("Load Intro Player");
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void {
				addChild(loader);
				loader.content.addEventListener("onReady", onPlayerReady);
				loader.content.addEventListener("onError", onPlayerError);
				loader.content.addEventListener("onStateChange", onPlayerStateChange);
				loader.content.addEventListener("onPlaybackQualityChange", 
					onVideoPlaybackQualityChange);
			}
			
			function onPlayerReady(event:Event):void {
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player = loader.content;
				// Set appropriate player dimensions for your application
				player.setSize(270, 165);
				player.x = 8;
				player.y = 200;
				player.loadVideoById(videoId);
			}
			
			function onPlayerError(event:Event):void {
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
			function onPlayerStateChange(event:Event):void {
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
			function onVideoPlaybackQualityChange(event:Event):void {
				// Event.data contains the event parameter, which is the new video quality
				trace("video quality:", Object(event).data);
			}

		}
		
		//--------------------------------- registerEventsForIntroVideo(); -------------------------
		private function registerEventsForIntroVideo():void
		{
			
			trace("Events registers for intro video player controls");
			playBtn.addEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
			pauseBtn.addEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
			muteBtn.addEventListener(MouseEvent.CLICK,handleMuteBtnClicked);
			unmuteBtn.addEventListener(MouseEvent.CLICK,handleUnmuteBtnClicked);
		}
		
		private function handlePlayBtnClicked(event:MouseEvent):void
		{
			player.playVideo();
			playBtn.removeEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
			pauseBtn.addEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
		}
		private function handlePauseBtnClicked(event:MouseEvent):void
		{
			player.pauseVideo();
			pauseBtn.removeEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
			playBtn.addEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
		}
		private function handleMuteBtnClicked(event:MouseEvent):void
		{
			player.mute();
			muteBtn.removeEventListener(MouseEvent.CLICK,handleMuteBtnClicked);
			muteBtn.visible = false;
			unmuteBtn.visible = true;
			unmuteBtn.addEventListener(MouseEvent.CLICK,handleUnmuteBtnClicked);
		}
		private function handleUnmuteBtnClicked(event:MouseEvent):void
		{
			player.unMute();
			unmuteBtn.removeEventListener(MouseEvent.CLICK,handleUnmuteBtnClicked);
			unmuteBtn.visible = false;
			muteBtn.visible = true;
			muteBtn.addEventListener(MouseEvent.CLICK,handleMuteBtnClicked);
		}
}
}
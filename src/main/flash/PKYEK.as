package
{
	import com.adobe.xml.syndication.generic.Image;
	import com.adobe.xml.syndication.rss.Source;
	import com.codedrunks.components.flash.Image;
	import com.codedrunks.components.flash.Share;
	import com.codedrunks.components.flash.Twitter;
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	
	import flash.debugger.enterDebugger;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	
	public class PKYEK extends MovieClip
	{
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		private var flashvars:Object;
		public var player:Object;
		public var loader:Loader = new Loader();
		public var videoId:String = "e9AUSUSr2qc";
		
		private var applicationID:String = "141829609202805";
		private var secretKey:String = "47777f0d9c678eea4fd1a3f4071dc475";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://apptikka.com/starone/fb/PKYEK/canvas/callback.html";
		private var socnetAPI:SocnetAPI;
		private var profilePicLoader:Loader;
		private var player2:Object;
		private var player3:Object;
		private var timer:Timer = new Timer(1000);
		private var loaderTwo:Loader;
		private var loaderThree:Loader;  
		private var playerNumber:Number = 1;
		
		private var share:Share;
		private var embedCode:String;
		private var wildfireUIConfig:String;
		private var memberId:String;
		private var twitter:Twitter;   
		[Bindable]
		private var shareImage:com.codedrunks.components.flash.Image = new com.codedrunks.components.flash.Image();
		private var image:com.codedrunks.components.flash.Image = new com.codedrunks.components.flash.Image();
		[Bindable]
		private var fbUserName:String = "";
		private var showShare:Boolean = false;
		
		private var shareTimer:Timer = new Timer(2000);
		[Bindable]
		private var allTypes:Array = new Array(getTypes());
		
		private var fileRef:FileReferenceList = new FileReferenceList();
		
		//private var facebookWall:FacebookWall = new FacebookWall();
		
		
		public function PKYEK()
		{
			super();     
			registerEvents();
			initApp();
		} 
		
		private function getTypes():FileFilter
		{
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		public function setFlashvars(parameters:Object):void
		{
			flashvars = parameters;
			init();
			
			trace("set flash vars");
		}
		
		private function init():void
		{
			trace("init()");
			loadConfig();
			
			//addToFacebookBtn.addEventListener(MouseEvent.CLICK, handleAddToFacebookBtnClick);
			//shareBtn.addEventListener(MouseEvent.CLICK, handleShareBtnClick);
			//twitterBtn.addEventListener(MouseEvent.CLICK, handleTwitterBtnClick);
		}
		
		private function loadConfig():void
		{
			trace("reachedload config");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleConfigLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleConfigLoadIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleConfigLoadSecurityError);
			urlLoader.load(new URLRequest(flashvars.configUrl));
		}
		/**
		 @ handles the load IO error event	
		 
		 @ method dispose (private)
		 @ params event:IOErrorEvent.
		 @ usage <code></code>
		 @ return void
		 */			
		private function handleConfigLoadIOError(event:IOErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to IO Error.");
		}
		
		/**
		 @ handles the load security error	event
		 
		 @ method dispose (private)
		 @ params event:SecurityErrorEvent.
		 @ usage <code></code>
		 @ return void
		 */			
		private function handleConfigLoadSecurityError(event:SecurityErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to security reasons.");
		}
		
		/**
		 @ handles the load complete event	
		 
		 @ method dispose (private)
		 @ params event:Event.
		 @ usage <code></code>
		 @ return void
		 */		
		
		
		private function handleConfigLoadComplete(event:Event):void
		{
			
			trace("reached handleload Complete");
			
			var xml:XML = XML(event.target.data);
			
			embedCode = xml.embedCode;
			wildfireUIConfig = xml.wildfireConfig;
			
			var tokens:XMLList = xml..token;
			for each (var token:XML in tokens) {
				var tokenValue:String = flashvars[token.@name];
				
				if (tokenValue == null) {
					tokenValue = token.@value;
				}
				/* *
				if (!httpRe.test(tokenValue as String) && urlTokens[token.@name] == true) {
				tokenValue = baseUrl + tokenValue;	
				}
				/* */
				
				flashvars[token.@name] = tokenValue;
			}
			
			initSocnet();
		}
		
		private function initSocnet():void
		{
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(flashvars, applicationID, secretKey, scope, redirectURI);
		}
		
		private function handleSocnetInitializeFail(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
		}
		
		private function handleSocnetInitialize(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			
			fetchAuthorProfile();
		}
		
		private function fetchAuthorProfile():void
		{
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			socnetAPI.getProfileInfo();			
		}
		
		
		private function handleProfileInfoFetch(event:SocnetUserInfoEvent):void
		{
			showShare = true;
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			
			fbUserName = event.userName;
			profileMc.profileName.text = event.userName;
			image.source = event.userPic;
			image.width = profileMc.profilePicLoader.width;
			image.height = profileMc.profilePicLoader.height;
			profileMc.profilePicLoader.addChild(image);
			shareImage = image;
			//initApp();
		}
		
		private function handleProfileInfoFail(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			showShare = false;
		}
	
		
		//---------------------------- initApp ----------------------------
		
		private function initApp():void
		{
			trace("We are in init App");
			loadIntroPlayer();
			registerEventsForIntroVideo();
			registerEvents();
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
				playerNumber = 1;
				registerEvents();
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
		
		
		private function registerEvents():void
		{  
			trace("we are in register Events");
			introBtn.addEventListener(MouseEvent.CLICK,handleIntroBtnClicked);
			abhayBtn.addEventListener(MouseEvent.CLICK,handleAbhayBtnClicked);
		} 
		
		private function handleIntroBtnClicked(event:MouseEvent):void 
		{
			trace("Intro button clicked");
			derstroyplayer();
			gotoAndStop("intro");
			loadIntroPlayer();
		}
		private function handleAbhayBtnClicked(event:MouseEvent):void
		{
			trace("Abhay button clicked");
			derstroyplayer();
			gotoAndStop("page1");
			registerEventsForpage1();  
		}
		
		
		//------------------------------ registerEventsForpage2() -    ------------------
		
		private function registerEventsForpage1():void
		{
			askYourQuestionBtn.addEventListener(MouseEvent.CLICK,handleAskYourQuestionBtnClicked);
		}
		
		private function handleAskYourQuestionBtnClicked(event:MouseEvent):void
		{
			trace("");
			gotoAndStop("page2");
			registerEventsForpage2();  
		}
		
		//---------------------------------- registerEventsForpage3 ---------------------
		
		private function registerEventsForpage2():void
		{
			enterBtn.addEventListener(MouseEvent.CLICK,handleEnterBtnClicked);
		}
		
		
		private function handleEnterBtnClicked(event:MouseEvent):void
		{
			gotoAndStop("page3"); 
			registerEventForPage3();  
		}
		  
		//------------------------------ registerEventForPage3 --------------------
		
		private function registerEventForPage3():void
		{
			browsBtn.addEventListener(MouseEvent.CLICK,handleBrowseBtnClicked);
		}
		private function handleBrowseBtnClicked(event:MouseEvent):void
		{   
			fileRef.browse(allTypes);
			fileRef.addEventListener(Event.COMPLETE, completeHandler);
			 
			//gotoAndStop("page4");
			//registerEventsForPage4();
		}
		private function completeHandler()
		{
			gotoAndStop("page4");
			imgLoader.source = "http://i1222.photobucket.com/albums/dd489/amar_hole/DIWALI/diwali1.jpg"; 

		}
		
		//-------------------------------- registerEventsForPage4 --------------------
		
		private function registerEventsForPage4():void
		{
			
		}
		
		
		//-------------------------------- destoy player function ---------------
		
		
		private function derstroyplayer():void
		{
			if(playerNumber == 1)
			{
				player.destroy();
				player.visible = false;
			}
			else 
			{
				
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
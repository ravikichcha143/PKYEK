package com.codedrunks.socnet.events
{
	import flash.events.Event;
	
	public class SocnetUserInfoEvent extends Event
	{
		public static const USER_INFO_FETCHED:String = "userInfoFetched";
		public static const USER_INFO_FAILED:String = "userInfoFailed";
		
		public static const FETCH_FRIENDS_SUCCESS:String = "fetchFriendsSuccess";
		public static const FETCH_FRIENDS_FAIL:String = "fetchFriendsFail";
		
		public var userId:String;
		public var userName:String;
		public var userPic:String;
		
		public var friendsData:Array;
		
		public function SocnetUserInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
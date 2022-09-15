//
//  Constant.h
//  Yokara 

//

//  Created by Rain Nguyen on 6/27/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//



#ifndef Constant_h
#define Constant_h

#define KXD @"(Chưa xác định)"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define DATAURL [NSURL URLWithString: @"http://www.ikara.co/test/getallsongs"]
//#define NSLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

#define ONESIGNAL_APPID @"1e8d0fce-6b2a-4b86-9909-6be72b4f9a83"
#define  nap_45k  @"com.yokara.icoin.45k"
#define  nap_109k  @"com.yokara.icoin.109k"
#define  nap_499k  @"com.yokara.icoin.499k"
#define  ONE_MONTH  @"com.yokara.vip.1month"
#define  THREE_MONTH  @"com.yokara.vip.3month"
#define  ONE_WEEK  @"com.yokara.vip.1week"
#define  ONE_MONTH  @"com.yokara.vip.1month"
#define  THREE_MONTH  @"com.yokara.vip.3month"
#define  ONE_YEAR @"com.yokara.vip.1year"
#define S_Table @"Song"
#define S_SNAME @"songName"
#define S_SingerNAME @"singerName"
#define S_IDS @"ids"
#define S_Lyric @"idLyric"
#define S_SUrl @"songUrl"
#define S_ViewCounter @"viewCounter"
#define S_Selected @"selectedLyric"
#define S_Status @"status"
#define S_likeCounter @"likeCounter"
#define S_dislikeCounter @"dislikeCounter"
#define S_videoId @"videoId"
#define S_thumbnailUrl @"thumbnailUrl"
#define S_duration @"duration"
#define S_nameKoDau @"nameKoDau"
#define S_NOLIKE @"NoLike"
#define S_NOCMT @"NoCmt"
#define S_owner @"owner"
#define S_SUrlMp4 @"songUrlMp4"
#define S_DurationString @"durationString"
#define S_TimeUpload @"timeUpload"

#define R_Table @"Record"
#define R_SNAME @"songName"
#define R_SingerNAME @"singerName"
#define R_IDS @"idSong"
#define R_IDR @"idRec"
#define R_SIZE @"size"
#define R_CONVERT @"upload"
#define R_DATE @"date"
#define R_SONGURL @"songUrl"
#define R_LOCALURL @"localUrl"
#define R_LYRIC @"lyric"
#define R_ONLINERECORDURL @"onlineRecordingUrl"
#define R_NEWEFFECTS @"newEffects"
#define R_YOURNAME @"yourName"
#define R_YOURMESSAGE @"yourMessage"
#define R_PRIVATEID @"privateId"
#define R_DEPLAY @"deplay"
#define R_VIEWCOUNTER @"viewCounter"
#define R_NOLIKE @"NoLike"
#define R_NOCMT @"NoCmt"
#define R_SELECTEDLYRIC @"selectedLyric"
#define R_MUSICVOLUME @"musicVolume"
#define R_VOCALVULUME @"vocalVolume"
#define R_ECHO @"echo"
#define R_TREBLE @"treble"
#define R_BASS @"bass"
#define R_duration @"duration"
#define R_toneShift @"toneShift"
#define R_originalRecording @"originalRecording"
#define R_thumnailUrl @"thumnailUrl"
#define R_recordDevice @"recordDevice"
#define R_onlineVocalUrl @"onlineVocalUrl"
#define R_onlineVoiceUrl @"onlineVoiceUrl"
#define R_recordingType @"recordingType"
#define R_onlineMp3Recording @"onlineMp3Recording"
#define R_mixedRecordingVideoUrl @"mixedRecordingVideoUrl"

#define ACCESS_KEY @"writeonlyuser"//@"AKIAIMCEHQ7Z2J6WZDUA"//0023003e6144cac0000000004
#define SECRET_KEY @"awJBPnZwvVpGYmp5MDQsw3Ry7z5EsyAE"//  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"//K002AE3odq+2F6w/D5Q8WUuNs8T84ps
#define S3_ENDPOINT @"https://s3.us-west-002.backblazeb2.com"
#define B2_ACCOUNT_ID @"0023003e6144cac0000000004"
#define B2_APPLICATION_KEY @"K002AE3odq+2F6w/D5Q8WUuNs8T84ps"
#define AppFloodAppKey @"67pz6mdRzfLGnPoc"
#define AppFloodSerectKey @"46DG4X0N3c50L534b581d"
#define UIDeviceOrientationIsLandscape(orientation) \
((orientation) == UIDeviceOrientationLandscapeLeft || \
(orientation) == UIDeviceOrientationLandscapeRight)

#define L_Table @"Lyric"
#define L_key @"key"
#define L_PrivatedId @"privatedId"
#define L_ownerId @"ownerId"
#define L_url @"url"
#define L_content @"content"
#define L_openningNo @"openningNo"
#define L_totalRating @"totalRating"
#define L_ratingCount @"ratingCount"
#define L_date @"date"
#define L_yourRating @"yourRating"
#define L_type @"type"
#define L_SongID @"songId"

#define XML 1
#define PLAINTEXT 0
#define serialVersionUID 8604856535350871032L
#define TYPE_DAILY  0
#define TYPE_WEEKLY  1
#define TYPE_MONTHLY  2
#define TYPE_NEWSONG  3
#define TYPE_HOT_VIDEO  4
#define TYPE_TREND_VIDEO  5
#define TYPE_HOT_AUDIO  6
#define TYPE_TREND_AUDIO  7

#define ColorTextLabel 0x455580
#define ColorHeader 0x51669A
#define ColorSearchBar 0xD5DAE6
#define ColorMenuTopRecord 0xE8EBF3
#define ColorTabBar 0xE6E9EF
#define ColorSlider 0xEE534F
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kSampleAdUnitID @"ca-app-pub-8429996645546440/4691936167"//
#define kInterstitialAdID @"ca-app-pub-8429996645546440/3378854492"//
#define kFacebookADUnitID @"331190657041066_556207764539353" //
#define kFacebookADNativeID @"331190657041066_845882305571896" //
#define kFacebookADInterstitial @"331190657041066_556207847872678" //
#define kFacebookADNativeiKara @"331190657041066_764185347074926" //
#define kFacebookADInterstitialiKara @"331190657041066_676338322526296" //
//#define kSampleAdUnitID1 @"a1527b142ab7df5"
//#define kSampleAdUnitID2 @"a1527b149a91667"
///#define kSampleAdUnitID3 @"a1527b150e2e49a"
//#define kSampleAdUnitID4 @"a1527b154e9f3ca"
//#define kSampleAdUnitID5 @"a1527b159a9142f"
#define kSampleAdUnitID1 kSampleAdUnitID
#define kSampleAdUnitID2 kSampleAdUnitID
#define kSampleAdUnitID3 kSampleAdUnitID
#define kSampleAdUnitID4 kSampleAdUnitID
#define kSampleAdUnitID5 kSampleAdUnitID
#define STATUS_WAITING  1
#define STATUS_MIXED  2
#define STATUS_ERROR  3
#define STATUS_DELETE 5
#define linkWeb @""
#define linkWebReplace @"http://www.yokara.com/"
#define linkWebiKara @"http://www.yokara.com/"
#define AppStoreIdYokara @"894927596"
//#define linkWeb @"http://www.ikake.net/"
//#define urlAppicon @"http://www.ikake.net/ikake_icon_128.png"
//#define urlAppicon @"http://www.ikara.co/appicon.png"
#define urlAppicon @"http://www.yokara.com/a.png"

#define Language @"en.yokara"

#define L_ConnectUsingAppleId (linkWeb @"v28.ConnectUsingAppleId")
#define L_ConnectUsingGoogle (linkWeb @"v27.ConnectUsingGoogle")
#define L_ConnectUsingFirebaseAuthen (linkWeb @"v27.ConnectUsingFirebaseAuthen")
#define L_ConnectUsingZalo (linkWeb @"v27.ConnectUsingZalo")

#define L_GetHotApps (linkWeb @"v15.GetHotApps")
#define L_GetBpmAndKeySong (linkWeb @"v22.GetBpmAndKeySong")
#define L_LinkWithFacebookAccount (linkWeb @"v4.LinkWithFacebookAccount2")
#define L_deleteRecording (linkWeb @"v13.DeleteRecording")
#define L_getBackground (linkWeb @"v4.GetBackgroundUrls")
#define L_getMyRecordings (linkWeb @"v32.GetMyRecordings")
#define L_getRecordings (linkWeb @"v35.GetUserRecordings")
#define L_GetUserProfile (linkWeb @"v35.GetUserProfile")

#define L_getSearchDataSong (linkWeb @"v22.SearchSongs")
#define L_SearchRecordings (linkWeb @"v22.SearchRecordings")
#define L_getDataSong (linkWeb @"v22.GetSong")
#define L_getTopSong (linkWeb @"v32.TopSongs")
#define L_SearchSongsFromChannels (linkWeb @"v21.SearchSongsFromChannels")
#define L_SearchAsk4DuetRecordings (linkWeb @"v29.SearchAsk4DuetRecordings")
#define L_GetYtDirectLinks (linkWeb @"v29.GetYtDirectLinks4Test")//v29.GetYtDirectLinks")//
#define L_getRecording (linkWeb @"v25.GetRecording")
#define L_updateRecording (linkWeb @"v25.UpdateRecording")
#define L_getTopRecord (linkWeb @"v32.TopRecordings")
#define L_TrendRecordings (linkWeb @"v27.TrendRecordings")
#define L_SetPrivacyLevelRecording (linkWeb @"v18.SetPrivacyLevelRecording")
#define L_TopUsers (linkWeb @"v32.TopUsers")
#define L_GetTopFamilys (linkWeb @"v32.GetTopFamilys")
#define L_uploadRecordToServer (linkWeb @"v25.UploadRecording")
#define L_getLyricData (linkWeb @"v4.GetLyric")
#define L_like (linkWeb @"like.jsp?id=")
#define L_comment (linkWeb @"comment.jsp?id=")
#define L_IncreaseViewCounter (linkWeb @"v13.IncreaseViewCounter")
#define L_IncreaseSimpleViewCounter (linkWeb @"v29.IncreaseSimpleViewCounter")
#define L_GetUserInfo (linkWeb @"v18.GetUserInfo")
#define L_GetLastestVersion (linkWeb @"v34.GetLastestVersion")
#define L_StoreID (linkWeb @"v24.StoreGcmId")
#define L_GetYoutubeMp3Link (linkWeb @"v33.GetYoutubeMp3Link")
#define L_GetYoutubeVideoLinks (linkWeb @"v9.GetYoutubeVideoLinks")
#define L_GetOtherApps (linkWeb @"v12.GetOtherApps")
#define L_ConnectUsingAccountKit (linkWeb @"v27.ConnectUsingAccountKit")
#define L_UpdateAccountKitInfo (linkWeb @"v20.UpdateAccountKitInfo")
#define L_UpdateAccountInfo (linkWeb @"v28.UpdateAccountInfo")
#define L_ConnectUsingFacebookAndTelco (linkWeb @"okara.v1.ConnectUsingFacebookAndTelco")
#define L_ConnectUsingGoogleAndTelco (linkWeb @"okara.v1.ConnectUsingGoogleAndTelco")
#define L_ConnectUsingAccountKitAndTelco (linkWeb @"okara.v1.ConnectUsingAccountKitAndTelco")
#define L_ConnectUsingTelco (linkWeb @"okara.v1.ConnectUsingTelco")

#define L_ConnectUsingFacebook (linkWeb @"v27.ConnectUsingFacebook")
#define L_ConfirmConnectUsingRelatedUser (linkWeb @"v27.ConfirmConnectUsingRelatedUser")
#define L_DisconnectFacebookAccount (linkWeb @"v22.DisconnectUsingFacebook")
#define L_UpdateFacebookFriendRelationships (linkWeb @"v13.UpdateFacebookFriendRelationships")
#define L_GetFacebookFriendsRequest (linkWeb @"v13.GetFacebookFriends")
#define L_CheckIfUsed (linkWeb @"v13.CheckIfUsed")
#define L_GetNotifications (linkWeb @"v13.GetNotifications")
#define L_GetRecordingEventDetails (linkWeb @"v24.GetRecordingEventDetails")
#define L_GetChatRooms (linkWeb @"v13.GetChatRooms")
#define L_GetScoreDetails (linkWeb @"v13.GetScoreDetails")
#define L_GetScoreDetailsForContest (linkWeb @"v13.GetScoreDetailsForContest")
#define L_BlockNick (linkWeb @"v25.BlockNick")
#define L_UnblockNick (linkWeb @"v25.UnblockNick")
#define L_SetReferralCode (linkWeb @"v27.SetReferralCode")
#define L_UpdateContacts (linkWeb @"v27.UpdateContacts")

#define L_AddFriend (linkWeb @"v16.AddFriend")
#define L_RemoveFriend (linkWeb @"v16.RemoveFriend")
#define L_GetRequestFriends (linkWeb @"v13.GetRequestFriends")
#define L_UpdateFacebookNoForRecording (linkWeb @"v13.UpdateFacebookNoForRecording")
#define L_JoinToContest (linkWeb @"v20.JoinToContest")
#define L_UnjoinFromContest (linkWeb @"v13.UnjoinFromContest")
#define L_UpdateRecordingMessage (linkWeb @"v20.UpdateRecordingMessage")
#define L_SendLike (linkWeb @"v24.SendLike")
#define L_SendComment (linkWeb @"v24.SendComment")

#define L_AddRecordingToContestRequest (linkWeb @"v24.AddRecordingToContest")
#define L_RemoveRecordingFromContestRequest (linkWeb @"v24.RemoveRecordingFromContest")
#define L_GetContests (linkWeb @"v20.GetContests")
#define L_GetContest (linkWeb @"v20.GetContest")
#define L_SetAvatarFrame (linkWeb @"v22.SetAvatarFrame")

#define L_GetNoRealLikeAndComment @"https://graph.facebook.com/?ids="//http://api.facebook.com/restserver.php?format=json&method=links.getStats&urls="
#define L_PromoteRecording (linkWeb @"v13.PromoteRecording")
#define L_GetRecordingsByContest (linkWeb @"v24.GetRecordingsForContest")
#define L_MyRecordingsForContest (linkWeb @"v24.MyRecordingsForContest")
#define L_SearchUsers (linkWeb @"v13.SearchUsers")
#define L_GetPitchShiftedSongLink (linkWeb @"v13.GetPitchShiftedSongLink")
#define L_AppleInappNotification (linkWeb @"v13.AppleInappNotification")
#define L_GetAccountInfo (linkWeb @"global.v2.GetAccountInfo")
#define L_BuyVip (linkWeb @"global.v2.BuyVip")
#define L_BuyIAPProduct (linkWeb @"v22.BuyIAPProduct")
#define L_SubcribeIAPVipAccount (linkWeb @"v22.SubcribeIAPVipAccount")
#define L_GetAllAvatarFrames (linkWeb @"v22.GetAllAvatarFrames")
#define L_GetIcoinHistory (linkWeb @"global.v2.GetIcoinHistory")

#define L_ForgetPassword (linkWeb @"v14.ForgetPassword")
#define L_CreateAccount (linkWeb @"v14.CreateAccount")
#define L_CheckAuthen (linkWeb @"v14.CheckAuthen")
#define L_ResetBadge (linkWeb @"v14.ResetBadge")

#define L_FamilyPromoted (linkWeb @"v32.Promoted")
#define L_FamilyDegraded (linkWeb @"v32.Degraded")
#define L_FamilyExpel (linkWeb @"v32.ExpelFromFamily")
#define L_AcceptInviteJoinFamily (linkWeb @"v32.AcceptInviteJoinFamily")
#define Fir_InviteMemberForUser @"v6-InviteMemberForUser"

#define L_AddIcoinDevice (linkWeb @"add-icoin?deviceId=")
#define L_AddIcoinFB (linkWeb @"add-icoin?")
#define L_CardPayment (linkWeb @"web.v4.CardPayment")
#define L_CardPaymentStatus (linkWeb @"web.v4.CardPaymentStatus")
#define L_BankPayment (linkWeb @"web.BankPayment")
#define L_VisaPayment (linkWeb @"web.VisaPayment")

#define L_SMSOTP (linkWeb @"web.ChargeOtp")
#define L_SMSChargeOtpConfirm (linkWeb @"web.ChargeOtpConfirm")
#define L_GetSmsSyntax (linkWeb @"web.GetSmsSyntax")

#define L_UpdateLocation (linkWeb @"v16.UpdateLocation")
#define L_GetNearbyUsers (linkWeb @"v16.GetNearbyUsers")
#define L_GetFollowingUsers (linkWeb @"v16.GetFollowingUsers")
#define L_GetFollowedUsers (linkWeb @"v16.GetFollowedUsers")
#define L_PushNotification (linkWeb @"v19.PushNotification")
#define L_GetMyAsk4DuetRecordings (linkWeb @"v25.GetMyAsk4DuetRecordings")
#define L_GetAsk4DuetRecordings (linkWeb @"v25.GetAsk4DuetRecordings")
#define L_GetAsk4DuetRecordingsOfSong (linkWeb @"v25.GetAsk4DuetRecordingsOfSong")
#define L_GetRecordingsOfSong (linkWeb @"v24.GetRecordingsOfSong")
#define L_TopAsk4DuetRecordings (linkWeb @"v32.TopAsk4DuetRecordings")
#define L_GetHotDuetRecordingsOfRecording (linkWeb @"v24.GetHotDuetRecordingsOfRecording")
#define L_GetNewDuetRecordingsOfRecording (linkWeb @"v24.GetNewDuetRecordingsOfRecording")
#define L_GetNewFeed (linkWeb @"v25.GetNewFeeds")
#define L_FixThumbnailSong (linkWeb @"v17.FixThumbnailSong")
#define L_GetFirebaseToken (linkWeb @"v19.GetFirebaseToken")
#define L_CheckPairingCode (linkWeb @"v14.CheckPairingCode")
#define L_GetSuggestedUsers (linkWeb @"v27.GetRickestUsers")
#define L_GetAllGifts (linkWeb @"v29.GetAllGifts")
#define L_GetRulesTopLiveRooms (linkWeb @"v34.GetRulesTopLiveRooms")
#define L_GetAllFollowingUsers (linkWeb @"v29.GetAllFollowingUsers")

#define L_GetMyProfile (linkWeb @"v34.GetMyProfile")

#define L_GetAllUserGifts (linkWeb @"v22.GetAllUserGifts")
#define L_ReportIssue (linkWeb @"v28.ReportIssue")
#define L_SendGiftInRecording (linkWeb @"v22.SendGiftInRecording")
#define L_SellGift (linkWeb @"v29.SellGift")

#define L_SearchLiveRooms (linkWeb @"v37.SearchLiveRooms")
#define L_CreateLiveRoom (linkWeb @"v29.CreateLiveRoom")
#define L_DeleteLiveRoom (linkWeb @"v28.DeleteLiveRoom")
#define L_RestoreLiveRoom (linkWeb @"v29.RestoreLiveRoom")
#define L_CreateVideo (linkWeb @"v23.CreateVideo")

#define L_RenewLiveRoom (linkWeb @"v28.RenewLiveRoom")
#define L_GetFriendsStatus (linkWeb @"v28.GetFriendsStatus")
#define L_TopUsersInLiveRoom (linkWeb @"v29.TopUsersInLiveRoom")
#define L_GetTopLiveRooms (linkWeb @"v37.GetTopLiveRooms")
#define L_GetHotLiveRooms (linkWeb @"v37.GetHotLiveRooms")
#define L_GetHotPKLiveRooms (linkWeb @"v37.GetHotPKRooms")

#define L_UpdateLiveRoomProperty (linkWeb @"v28.UpdateLiveRoomProperty")
#define L_GetMyAndRecentLiveRooms (linkWeb @"v37.GetMyAndRecentLiveRooms")
#define L_SendGiftInLiveRoom (linkWeb @"v29.SendGiftInLiveRoom")
#define L_SendGiftInPKRoom (linkWeb @"v29.SendGiftInPKRoom")

#define L_GetAllLuckyGifts (linkWeb @"v35.GetAllLuckyGifts")
#define L_GetGiftsForLiveRoom (linkWeb @"v35.GetGiftsForLiveRoom")
#define L_GetGiftsForRecording (linkWeb @"v35.GetGiftsForRecording")
#define L_SendLuckyGift (linkWeb @"v35.SendLuckyGift")
#define L_GetAllLuckyGiftsGave (linkWeb @"v35.GetAllLuckyGiftsGave")
#define L_TakeLuckyGift (linkWeb @"v35.TakeLuckyGift")
#define L_GetLuckyGiftsHistory (linkWeb @"v35.GetLuckyGiftsHistory")

#define GIFT_TYPE_STATIC @"STATIC"
#define GIFT_TYPE_ANIMATED @"ANIMATED"
#define GIFT_TAG_NORMAL @"NORMAL"
#define GIFT_TAG_EVENT @"EVENT"
#define GIFT_TAG_NEW @"NEW"

#define Fir_AddComment @"v2_AddComment"
#define Fir_AddSong @"v4-AddSong"
#define Fir_AddUserOnline @"v6-AddUserOnline"
#define Fir_RemoveUserOnline @"v1_RemoveUserOnline"
#define Fir_UpdateUserOnline @"v1_UpdateUserOnline"
#define Fir_BlockComment @"v1_BlockComment"
#define Fir_BlockUser @"v1_BlockUser"
#define Fir_CancelAdminForUser @"v1_CancelAdminForUser"
#define Fir_CancelVipForUser @"v1_CancelVipForUser"
#define Fir_CreateLiveRoom @"v1_CreateLiveRoomt"
#define Fir_DeleteLiveRoom @"v1_DeleteLiveRoom"

#define Fir_GetInfoUser @"v1_GetInfoUser"
#define Fir_RemoveSong @"v1_RemoveSong"
#define Fir_RemoveStatus @"v1_RemoveStatus"
#define Fir_SetAdminForUser @"v1_SetAdminForUser"
#define Fir_SetTopSongInQueue @"v1_SetTopSongInQueue"
#define Fir_SetVipForUser @"v1_SetVipForUser"
#define Fir_UnblockComment @"v1_UnblockComment"
#define Fir_UnblockUser @"v1_UnblockUser"
#define Fir_UpdateSong @"v1_UpdateSong"
#define Fir_AddGift @"v1_public_AddGift"
#define Fir_DoneSong @"v1_DoneSong"
#define Fir_StopSong @"v3-StopSong"
#define Fir_ClearAllSongOfUserInQueue @"v1_ClearAllSongOfUserInQueue"
#define Fir_RemoveMC @"v1_RemoveMC"
#define Fir_AddMC @"v1_AddMC"
#define Fir_StopMC @"v3-StopMC"
#define Fir_StartMC @"v3-StartMC"
#define Fir_UpdateOnlineStatus @"v3-UpdateOnlineStatus"
#define Fir_UpdateLiveRoomProperty @"v6-UpdateLiveRoomProperty"

#define Fir_SENDMESSAGE @"v5-SendMessage"
#define Fir_PUSHNOTIFICATION @"v5-SetPushNotification"
#define Fir_REMOVECONVERSATION @"v5-RemoveConversation"
#define Fir_CHANGESTATUSMESSAGE @"v5-ChangeStatusMessage"
#define Fir_CHANGEISREADCONVERSATION @"v5-ChangeIsReadConversation"
#define Fir_RemoveImageFromAlbumUser @"v5-RemoveImageFromAlbumUser"
#define Fir_AddImageToAlbumUser @"v5-AddImageToAlbumUser"
#define Fir_RemoveCommentRecording @"v5-RemoveCommentRecording"
#define Fir_AddImageToAlbumUser @"v5-AddImageToAlbumUser"
#define Fir_RemoveCommentRecording @"v5-RemoveCommentRecording"

#define Fir_SetLogCat @"v5-SetLogCat"
#define Fir_SetLastRunLogCat @"v5-SetLastRunLogCat"
#define Fir_SetOnlineStatus @"v5-SetOnlineStatus"
#define Fir_SetProcessRecording @"v5-SetProcessRecording"
#define Fir_SetOwnerUserId @"v5-SetOwnerUserId"
#define Fir_SetNameAndProfileImageUser @"v5-SetNameAndProfileImageUser"

#pragma mark PK
#define L_CreateLiveRoomContest (linkWeb @"v29.CreateLiveRoomContest")
#define L_GetAllLiveRoomContests (linkWeb @"v29.GetAllLiveRoomContests")
#define L_GetAllContestsOfLiveRoom (linkWeb @"v29.GetAllContestsOfLiveRoom")
#define L_JoinLiveRoomContest (linkWeb @"v29.JoinLiveRoomContest")
#define L_UnjoinLiveRoomContest (linkWeb @"v29.UnjoinLiveRoomContest")
#define L_DeleteLiveRoomContest (linkWeb @"v29.DeleteLiveRoomContest")
#define L_EndLiveRoomContest (linkWeb @"v29.EndLiveRoomContest")


#define  STARTPK  @"STARTPK"
#define  REDSTART @"REDSTART"
#define  BLUESTART @"BLUESTART"
#define  ENDPK @"ENDPK"

#define Fir_DoneSongPK @"v3-DoneSongPK"
#define Fir_AddSongPK @"v3-AddSongPK"
#define Fir_StopSongPK @"v3-StopSongPK"
#define Fir_UpdateSongPK @"v3-UpdateSongPK"
#define Fir_RemoveSongPK @"v3-RemoveSongPK"
#define Fir_RemoveSongTempPK @"v3-RemoveSongPK"
#define Fir_StartPK @"v3-StartPK"

#define Fir_CreateContest @"v4-CreateContest"
#define Fir_DeleteContest @"v4-DeleteContest"
#define Fir_UnregisterCandidates @"v4-UnregisterCandidates"
#define Fir_RegisterCandidates @"v4-RegisterCandidates"
#define Fir_SetTopSongInPKQueue @"v3-SetTopSongInPKQueue"
#define Fir_NextRound @"v4-NextRound"

#define BACKGROUND1 @"BACKGROUND1"
#define BACKGROUND2 @"BACKGROUND2"
#define BACKGROUND3 @"BACKGROUND3"
#define BACKGROUND4 @"BACKGROUND4"
#define HeaderColor 0xFF4C48
#define BackGroundColor1 0xF16041
#define BackGroundColor2 0xF02C6A
#define L_GetProducts  @"http://ikarastore.com/index.php?route=module/apimodule/product_featured&limit=20"
#define L_GetAcademies  @"http://academy.ikara.co/wp-json/myapi/posts/random/5?device_id="
#define LAVersion NO
#endif
#import <UIKit/UIKit.h>
#import "User.h"

#import "Recording.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "GetAccountInfoResponse.h"
#import "GetMyRecordingsResponse.h"
extern BOOL mixOfflineProssesing;
extern NSInteger menuSelected;
extern NSInteger vitriuploadRec;
extern double intervalRender;
extern BOOL streamPlay;
extern NSMutableArray *listSongMyAskDuet;
extern NSMutableArray * dataRecord;
extern NSMutableArray *dataRecordAskDuet;
extern NSMutableArray * dataRecordUpload;
extern NSMutableArray * dataKara;
extern NSMutableArray *dataFavorite;
extern int demShowAlertRate;
extern NSInteger numDisplayLineLyric;
extern BOOL enableSendLogFirebase;
extern BOOL isKaraokeTab;
extern NSInteger selectedMenuIndex;
extern BOOL _doneUploadingToIkara;
extern CGFloat percent;
extern CGFloat percentUploadImage;
extern BOOL HasConnectTVYokara;
extern NSInteger tabSelected;
extern BOOL getLinkFromYoutube;
extern NSString *regularExpression;
extern NSString * YoutubeGetVideo;
extern NSString * userAgent;
extern NSString * locationNow;
extern NSString * videoQuality;
extern double delayRec;
extern double timeRecord;
extern double timeAudioRecord;
extern  Song *songPlay;
extern  Recording *songRec;
extern   Recording *songRecOld;
extern Recording * recordingPlaying;
extern BOOL VipMember;
extern bool unload;
extern BOOL playRecord;
extern BOOL isrecord;
extern BOOL incommingCall;
extern BOOL playRecUpload;
extern BOOL playTopRec;
extern AVAudioPlayer *audioPlayRecorder;
extern BOOL finishTopSong;
//extern MPMoviePlayerController *playerYoutube;
extern BOOL isVoice;
extern BOOL playthroughOn;
extern BOOL hasHeadset;
extern BOOL connectBluetooth;
extern NSMutableArray *dataTopRecordDay;
extern UIColor *namColor;
extern BOOL isRecorded;
extern BOOL isIphone5s;
extern BOOL uploadToServer;
extern UIColor *nuColor;
extern UIColor *songCaColor;

extern NSInteger numDisplayLineLyric;
extern int timeChangeBackground;
extern BOOL autoChangeBackground;
extern int reverbVolume;
extern  long serverTimeOffset;

extern BOOL isShowingADVN;
extern int demQuangCao;
extern BOOL hasLogin;
extern GetAccountInfoResponse *AccountVIPInfo;
extern BOOL userOtherServer;
extern BOOL isPlayYoutubeVideo;
extern BOOL hasLoadYoutubePlayer;
extern BOOL youtubePlayerIsPlay;
extern BOOL  isExitPlayRecord;
extern BOOL pauseFromControl;
extern BOOL useBackCamera;
extern BOOL isFinalLoadRecord;
extern GetMyRecordingsResponse *recordSVList;
extern BOOL playVideoRecorded;
extern BOOL pushToInit;
extern NSString * streamServer;
extern NSInteger timeShowInterAds;
extern BOOL isExportingVideo;
extern BOOL isExportingVideoWithEffect;
extern BOOL isPlayRecordView;
extern BOOL didEnterBackground;
extern UIBackgroundTaskIdentifier bgTask2;
extern Recording *iSongPlay;
extern User * currentFbUser;

extern BOOL isExpand;
extern BOOL xulyTrucTiep;
extern BOOL isVoice;
extern BOOL videoRecord;
extern BOOL isRecorded;
extern double delayRec;
extern Recording *songRec;
extern NSString* mixOfflineMessage;
extern BOOL autoChangePlayList;
extern BOOL isPlayingAu;


extern BOOL gotoXulyView;
static BOOL showLoginAlert;
extern BOOL isTabKaraoke;
extern BOOL showAlertEnablePush;
extern NSInteger currentEffectID;




extern BOOL loadlaiLyric;
extern NSString *tieude;

//
//  LoadData.h
//  YokaraKaraoke
//
//  Created by Admin on 23/05/2022.
//  Copyright © 2022 Nguyen Anh Tuan Vu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Foundation/Foundation.h>
//#import "SGdownloader.h"
#import "NSMutableArray+QueueAdditions.h"
//#import "InitViewController.h"
#import "Gift.h"
#import <SDWebImage/SDWebImage.h>
#import "LocalizationSystem.h"
#import "Base64.h"
#import "iosDigitalSignature.h"
#import "Song.h"
#import "Recording.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TheAmazingAudioEngine.h"
#import "GetAccountInfoResponse.h"
#import "GetMyRecordingsResponse.h"
#import "GetYtDirectLinksRequest.h"
#import "YoutubeMp4Respone.h"
#import "YoutubeMp4.h"
#import "GetLastestVersionResponse.h"
#import "YTPatternRequest.h"
#import "Constant.h"
#import "GetLastestVersionRequest.h"
#import "GetLastestVersionResponse.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AFNetworking/AFNetworking.h>
#import <GZIP/GZIP.h>
#import "iToast.h"
#import "GetYoutubeMp3LinkRespone.h"
#import "GetYoutubeMp3LinkRequest.h"
#import "DBHelperYokaraSDK.h"
#import "ColorAndTime.h"
#import "NewEffect.h"
#import "Response.h"
#import "CreateStreamRequest.h"
#import "DestroyStreamRequest.h"
#import "DoNothingStreamRequest.h"
#import "PauseStreamRequest.h"
#import "PlayStreamRequest.h"
#import "Response.h"
#import "SeekStreamRequest.h"
#import "UpdateStreamRequest.h"
#import "UpdateTimeCodeRequest.h"
#import "AFNetworking.h"
#import "GetPitchShiftedSongLinkResponse.h"
#import "GetPitchShiftedSongLinkRequest.h"
#import "Reachability.h"
#import "UploadRecordingRequest.h"
#import "UploadRecordingResponse.h"
#import "GetLyricResponse.h"
#import "EffectsR.h"
#import "GetLyricRequest.h"
#import "Gift.h"
#import "DeleteRecordingResponse.h"
#import "DeleteRecordingRequest.h"
#import "GetYoutubeVideoLinksRequest.h"
#import "GetYoutubeVideoLinksResponse.h"
#import "GetSongRequest.h"
#import "GetSongResponse.h"
#import "SetProcessRecordingRequest.h"
#import "FirebaseFuntionResponse.h"
#import "UpdateFacebookNoForRecordingResponse.h"
#import "UpdateRecordingRequest.h"
#import "YokaraSDK.h"
#import "LiveRoom.h"
#import "GetTopLiveRoomsRequest.h"
#import "GetTopLiveRoomsResponse.h"
#import "LiveRoom.h"
#import "CreateLiveRoomRequest.h"
#import "UpdateLiveRoomPropertyFirRequest.h"
#import "UpdateLiveRoomPropertyResponse.h"
#import "GetMyAndRecentLiveRoomsRequest.h"
#import "GetMyAndRecentLiveRoomsResponse.h"
#import "RoomComment.h"
#import "RoomStatus.h"
#import "SearchLiveRoomsRequest.h"
#import "SearchLiveRoomsResponse.h"
#import "RoomShowTime.h"
#import "Room.h"
#import "RoomQueueSong.h"
#import "SendDataRequest.h"
#import "DeleteLiveRoomResponse.h"
#import "DeleteLiveRoomRequest.h"
#import "SetTopSongInQueueResponse.h"
#import "FirebaseFuntionResponse.h"
#import "AddCommentRequest.h"
#import "AddSongRequest.h"
#import "BlockCommentRequest.h"
#import "AddUserOnlineResponse.h"
#import "AddUserOnLineRequest.h"
#import "CancelAdminForUserRequest.h"
#import "BlockUserRequest.h"
#import "DeleteLiveRoomFirRequest.h"
#import "CreateLiveRoomFirRequest.h"
#import "CancelVipForUserRequest.h"
#import "GetInfoUserRequest.h"
#import "GetInfoUserOnlineResponse.h"
#import "RemoveSongRequest.h"
#import "RemoveStatusRequest.h"
#import "SetAdminForUserRequest.h"
#import "SetTopSongInQueueRequest.h"
#import "SetVipForUserRequest.h"
#import "UnblockCommentRequest.h"
#import "UnblockUserRequest.h"
#import "UpdateLiveRoomPropertyRequest.h"
#import "RoomUserOnline.h"
#import "RemoveUserOnLineRequest.h"
#import "UserScore.h"
#import "ClearAllSongOfUserInQueueRequest.h"
#import "DoneSongRequest.h"
#import "AddGiftRequest.h"
#import "SendGiftInLiveRoomRequest.h"
#import "SendGiftInLiveRoomResponse.h"
#import "DoNothingLiveStreamRequest.h"
#import "CreateLiveRoomRespone.h"
#import "RenewLiveRoomRequest.h"
#import "RenewLiveRoomResponse.h"
#import "GetFriendsStatusRequest.h"
#import "GetFriendsStatusResponse.h"
#import "AddMCRequest.h"
#import "McRequest.h"
#import "SearchAsk4DuetRecordingsResponse.h"
#import "SearchAsk4DuetRecordingsRequest.h"
#import "MoreInforDataRequest.h"
#import "UpdateBitrateRequest.h"
#import "GetAllFollowingUsersRequest.h"
#import "GetAllFollowingUsersResponse.h"
#import "GetAllGiftsResponse.h"
#import "GetAllGiftsRequest.h"
#import "TopUsersInLiveRoomRequest.h"
#import "TopUsersInLiveRoomResponse.h"
#import "LiveRoomContest.h"
#import "SendGiftInLiveRoomResponse.h"
#import "SendGiftInLiveRoomRequest.h"
#import "GetLuckyGiftsHistoryResponse.h"
#import "GetAllLuckyGiftsGaveResponse.h"
#import "GetAllLuckyGiftsResponse.h"
#import "TakeLuckyGiftResponse.h"
#import "SendLuckyGiftResponse.h"
#import "SendLuckyGiftRequest.h"
#import "GetAllGiftsResponse.h"
#import <AVFoundation/AVFoundation.h>
#import "GetAllLiveRoomContestsResponse.h"
#import "GetAllLiveRoomContestsRequest.h"
#import "CreateLiveRoomContestRequest.h"
#import "GetAllContestsOfLiveRoomResponse.h"
#import "GetAllContestsOfLiveRoomRequest.h"
#import "JoinLiveRoomContestResponse.h"
#import "JoinLiveRoomContestRequest.h"
#import "UnjoinLiveRoomContestResponse.h"
#import "UnjoinLiveRoomContestRequest.h"
#import "DeleteLiveRoomContestResponse.h"
#import "DeleteLiveRoomContestRequest.h"
#import "EndLiveRoomContestResponse.h"
#import "EndLiveRoomContestRequest.h"
#import "LogStreamRequest.h"
#import "PromotedRequest.h"
#import "PromotedResponse.h"

#import "AddFriendResponse.h"
#import "RemoveFriendResponse.h"
#import "GetRequestFriendsResponse.h"
#import "AddFriendRequest.h"
#import "RemoveFriendRequest.h"
#import "GetRequestFriendsRequest.h"
#import "StartPKRequest.h"
#import "RenewLiveRoomRequest.h"
#import "RenewLiveRoomResponse.h"
#import "GetMyProfileResponse.h"
#import "GetMyProfileRequest.h"
#import "LuckyGiftGave.h"
#import "TopUsersInLiveRoomRequest.h"
#import "TopUsersInLiveRoomResponse.h"
#import "Family.h"
#import "GetUserProfileRequest.h"
#import "GetUserProfileResponse.h"
#import "ClientInfo.h"
#import "TwoUser.h"
#import <Firebase/Firebase.h>
#import "LuckyGiftHistory.h"
#import "GetFriendsStatusRequest.h"
#import "GetFriendsStatusResponse.h"
#import "GetAllGiftsResponse.h"
#import "GetAllGiftsRequest.h"
#import "NSString+JSMessagesView.h"
#import "GetAllLuckyGiftsGaveRequest.h"
#import "GetAllLuckyGiftsGaveResponse.h"
#import "TakeLuckyGiftRequest.h"
#import "GetLuckyGiftsHistoryRequest.h"
#import "GetAllLuckyGiftsRequest.h"
#import "GetAllUserGiftsRequest.h"
#import "ExpelFromFamilyResponse.h"
#import "ExpelFromFamilyRequest.h"
#import "DegradedRequest.h"
#import "DegradedResponse.h"
#import "PromotedResponse.h"
#import "PromotedRequest.h"
#import "GetRecordingsRequest.h"
#import "GetRecordingsResponse.h"
#import "JSON.h"
#import "AllSongDB.h"
#import "AllRecordingDB.h"
@protocol Recording;
@protocol Song;
@interface LoadData2 : NSObject{
    BOOL  loadLastTestVersionFirt;
    BOOL isTestingPing;
    double timeDownload;
}
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(strong, nonatomic) FIRFunctions *functions;
@property(assign, nonatomic) BOOL isDownloadSong;
- (NSString *) checkLinkMp4:(NSString *)videoId ;
- (BOOL )downloadRecord:(Recording *) recordD;
- (BOOL )downloadSong:(Song *) songD;
- (ExpelFromFamilyResponse *) familyExpelFromFamily:(NSString *) fbId;
- (DegradedResponse *) familyDegraded:(NSString *) fbId;
- (PromotedResponse *) familyPromoted:(NSString *) fbId;
- (PromotedResponse *) AcceptInviteJoinFamily:(NSString *) fbId;
- (GetAllGiftsResponse* ) GetAllGifts;
- (GetAllLuckyGiftsGaveResponse* ) GetAllLuckyGiftsGave:(NSString *)liveRoomID ;
- (GetFriendsStatusResponse *) GetFriendsStatus:(NSMutableArray *) friends;
- (TopUsersInLiveRoomResponse *) TopUsersInLiveRoom:(NSString *) cursor liveRoom:(long )roomId andType:(int) type;
- (GetAllGiftsResponse* ) GetGiftsForLiveRoom ;
- (NSString *) thoigianHourFir:(long )serverTimestamp;
- (GetAllLuckyGiftsResponse* ) GetAllLuckyGifts;
- (SendLuckyGiftResponse* ) SendLuckyGift:(SendLuckyGiftRequest *)getSongRequest;
- (TakeLuckyGiftResponse* ) TakeLuckyGift:(long ) luckyGiftGaveId ;
- (GetLuckyGiftsHistoryResponse* ) GetLuckyGiftsHistory:(long ) luckyGiftGaveId ;
- (GetAllLuckyGiftsGaveResponse* ) GetAllLuckyGiftsGave:(NSString *)liveRoomID ;
- (NSString *) formatNumber:(long) number ;

- (NSString *) prettyTimeContest:(NSString *)timeCmt;
- (NSString *) prettyTimeVIPDate:(NSString *)timeCmt;
- (NSString *)parseDuration:(NSString *)duration ;
- (NSString *) thoigian:(NSString *)timeCmt;
- (NSString *) thoigianFir:(long )serverTimestamp;
- (NSString *) thoigian3:(NSDate *)datetime;
- (NSString *) thoigian4:(NSDate *)datetime;
- (NSString *) thoigianNoGMT:(NSString *)timeCmt;
- (NSString *) thoigian2:(NSString *)timeCmt;
#pragma mark PK Live API
- (GetMyProfileResponse* ) GetMyProfile ;
- (GetUserProfileResponse* ) GetUserProfile:(NSString *) userKey andOwnFacebookId:(NSString *) ownerFacebookId ;
- (RenewLiveRoomResponse *  ) RenewLiveRoom:(long) roomId;
- (SendGiftInLiveRoomResponse* ) SendGiftInPKRoom:(SendGiftInLiveRoomRequest *)getSongRequest;
- (GetAllFollowingUsersResponse* ) GetAllFollowingUsers;
+(BOOL) fileExistsInProject:(NSString *)fileName;
#pragma mark Firebase Function
- (SendGiftInLiveRoomResponse* ) SendGiftInLiveRoom:(SendGiftInLiveRoomRequest *)getSongRequest;

- (FirebaseFuntionResponse *) AddGiftFir:(AddGiftRequest *)firRequest ;
- (FirebaseFuntionResponse *) DoneSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId;
- (FirebaseFuntionResponse *) ClearAllSongOfUserInQueueFir:(NSString *)roomId  andUserId:(NSString *)userId;
- (FirebaseFuntionResponse *) RemoveUserOnLineFir:(NSString *)roomId;
- (FirebaseFuntionResponse *) AddCommentFir:(RoomComment *)comment;
- (AddUserOnlineResponse *) AddUserOnLineFir:(LiveRoom *)room;
- (AddUserOnlineResponse *) UpdateUserOnLineFir:(NSString *)roomId withMinute:(long)minuteOnline;
- (FirebaseFuntionResponse *) BlockCommentFir:(NSString *)roomId andUserBlock:(User *)userB;
- (FirebaseFuntionResponse *) UnblockCommentFir:(NSString *)roomId andUserBlock:(User *)userB;
- (FirebaseFuntionResponse *) BlockUserFir:(NSString *)roomId andUserBlock:(User *)userB;
- (FirebaseFuntionResponse *) UnblockUserFir:(NSString *)roomId andUserBlock:(User *)userB;
- (FirebaseFuntionResponse *) CancelAdminForUserFir:(NSString *)roomId andUser:(User *)userB;
- (FirebaseFuntionResponse *) SetAdminForUserFir:(NSString *)roomId andUser:(User *)userB;
- (FirebaseFuntionResponse *) CancelVipForUserFir:(NSString *)roomId andUser:(User *)userB;
- (FirebaseFuntionResponse *) SetVipForUserFir:(NSString *)roomId andUser:(User *)userB;
- (FirebaseFuntionResponse *) CreateLiveRoomFir:(LiveRoom *)room;
- (FirebaseFuntionResponse *) DeleteLiveRoomFir:(NSString *)roomId;
- (FirebaseFuntionResponse *) UpdateLiveRoomPropertyFir:(LiveRoom *)room;
- (GetInfoUserOnlineResponse *) GetInfoUserFir:(NSString *)roomId andUserId:(NSString *)userId;
- (FirebaseFuntionResponse *) AddSongFir:(NSString *)roomId withSong:(Song *)song ;
- (FirebaseFuntionResponse *) RemoveSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId;
- (FirebaseFuntionResponse *) UpdateSongFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId ;
- (SetTopSongInQueueResponse *) SetTopSongInQueueFir:(NSString *)roomId withSong:(Song *)song andUserActionId:(NSString *)userId ;
- (FirebaseFuntionResponse *) RemoveStatusFir:(NSString *)roomId;
- (NSInteger ) minuteRangeNowFromFirebase:(long )time;
- (NSString *) getSendDataStream:(NSString *)streamName andDevice:(NSString *)deviceId andAction:(NSString *)action ;
- (NSString *) getSendDoNothingLiveStream:(NSString *)streamName andDevice:(NSString *)deviceId ;
- (NSString *) getMCStreamRequest:(NSString *)streamID andFacebookID:(NSString *)facebookID ;

- (UpdateFacebookNoForRecordingResponse *) updateRecording:(Recording *) record;
- (GetSongResponse *) getDataSong:(NSNumber *) idS ;
- (YoutubeMp4Respone* ) GetYoutubeMp4Link:(NSString *) videoId;
- (BOOL) checkVideoDeleted:(NSString *) videoId;
- (NSString *) convertTimeToString:(double ) timeplay;
- (GetLastestVersionResponse *) getLastestVersion;
- (GetYoutubeMp3LinkRespone* ) GetYoutubeMp3Link:(Song *) song;
+(void)openSettings;
+(BOOL)isHaveRegistrationForNotification;
- (GetPitchShiftedSongLinkResponse *) GetPitchShiftedSongLink:(NSNumber *)songId withPitchShift:(NSNumber *) pitchShift;
- (NSString *) getAllRecordDB;
- (NSString *) getAllSongDB;
- (NSString *) getParaCreateStream:(NSString *)streamName andParameter:(Recording *)record;
- (NSString *) getParaPauseStream:(NSString *)streamName andRecord:(Recording *)record;
- (NSString *) getParaDestroyStream:(NSString *)streamName andEffect:(Recording *)record;
- (NSString *) getParaDoNoThingStream:(NSString *)streamName;
- (NSString *) getParaUpdateStream:(NSString *)streamName andPosition:(double)position andRecord:(Recording *)record;
- (NSString *) getParaUpdateStream2:(NSString *)streamName andPosition:(long)position andRecord:(Recording *)record;
- (BOOL) checkNetwork;
- (void ) addFavorite:(NSNumber *) idsong;
- (void) addRecord:(Recording *) songss;
- (void ) removeFavorite:(NSNumber *) idsong;
- (void) addDownloadSong:(NSNumber *) idsong;
- (GetLyricResponse *) getLyricData:(NSString *) idS ;
- (void) removeRecord:(NSString *) date;
- (UploadRecordingResponse *) uploadRecordToServer:(Recording *) record andSong: (Song *) songss andName: (NSString *) name andMessage: (NSString *) message andUrl:(NSString *) urlUpload;// andLyric: (NSString *) selectLyric ;
- (NSString *) getDeviceName;
-(NSString *)normalizeVietnameseString:(NSString *)str;
- (DeleteRecordingResponse*) deleteRecording:(NSString *) recordId;
- (NSString *) idForDevice;
- (NSString *) getUrlWithYoutubeVideoId:(NSString * )youtubeID ;
- (GetYoutubeVideoLinksResponse *) getYoutubeVideoLinks:(NSString *) videoId andContent:(NSString *) content;
- (NSString *) pretty: (long) d;
- (PromotedResponse *) AcceptInviteJoinFamily:(NSString *) fbId;
- (RemoveFriendResponse *) RemoveFriend:(NSString *)toFacebookId;
- (AddFriendResponse *) AddFriend:(NSString *)toFacebookId;
- (GetRequestFriendsResponse *) GetRequestFriends:(NSString *)currsor ;
- (GetAllFollowingUsersResponse* ) GetAllFollowingUsers;
@end
extern TopUsersInLiveRoomResponse * topUsersInLiveRoomResponse;
extern NSMutableArray *allFollowingUsers;
extern BOOL uploadProssesing;
extern  Recording *recordingCurrentUpload;
extern NSString * nameUp;
extern NSString * messUp;
extern UIBackgroundTaskIdentifier bgTask;
extern UIBackgroundTaskIdentifier bgMixTask;
extern GetAllGiftsResponse * allGiftRespone;
extern GetAllLuckyGiftsResponse * allLuckyGiftRespone;
extern NSMutableArray * listQueueSing;
extern NSMutableArray * listQueueSingPK;
extern NSMutableArray * listQueueSingPKTemp;


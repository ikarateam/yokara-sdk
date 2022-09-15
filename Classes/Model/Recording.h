//
//  Recording.h
//  Yokara
//
//  Created by Rain Nguyen on 8/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//

//#define serialVersionUID  281773198795949875L
#define STATUS_NEW  0
#define STATUS_WAITING  1
#define STATUS_MIXED  2
#define STATUS_ERROR  3
#define STATUS_CHANGED 4
#define STATUS_DELETED  5
#import "NewEffects.h"
#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class Song;
@class EffectsR;
@class User;
@class Lyric;
@class NewEffects;
@class SuggestInfor;
@interface Recording : JSONModel{
    @public
    int isPlaying;
    BOOL hasLike;
    NSString* hasUpload;
    BOOL isUploading;
    BOOL isConvert;
    int ptUpload;
    BOOL hasApplyContest;
    BOOL isOwner;
    NSString *statusUpload;
    BOOL myRecord;
    BOOL inDataBase;
    BOOL isExportVideo;
}
@property (strong, nonatomic) NSNumber * lyricDelay;
@property (strong, nonatomic) NSString*  recordingType;
@property (strong, nonatomic) SuggestInfor *suggestInfor;
//user thu am
@property (strong, nonatomic) User * owner;
//id trong database
@property (strong, nonatomic) NSNumber * _id;
/*id trên server của iKara, lúc chưa upload lên server thì cái này bằng null,
 * sau khi upload lên thì gán giá trị mà server trả về
 */
@property (strong, nonatomic) NSNumber* localDBId;
@property (strong, nonatomic) NSString* recordingId;

/*id của bài hát được thu âm
 */

@property (strong, nonatomic) NSNumber *  songId;
@property (strong, nonatomic) NSNumber *  statusOfProcessing;
/* đối tượng Song của bài hát được thu âm */

@property (strong, nonatomic) Song *  song;

/* thời gian thu âm */

@property (strong, nonatomic) NSString*  recordingTime;

/* vị trí của file tiếng hát ở dưới máy */

@property (strong, nonatomic) NSString*  vocalUrl;

/* độ trễ của nhạc nền so với lời bài hát,
 * với trường hợp của iOS thì như em nói nó sẽ bằng 200 hoặc -200
 * một trong 2 giá trị đó, anh không nhớ cái nào :D
 */

@property (strong,nonatomic) NSNumber * delay;

/*
 * status này được dùng dưới local để mô tả rằng cái bài thu âm của em,
 * đã được upload lên server chưa
 */
@property (strong,nonatomic) NSNumber *  status;

// đây là link của giọng hát mà em upload lên server của em, sau khi có link trả về em gắn vào đây

@property (strong, nonatomic) NSString* onlineVocalUrl;
@property (strong, nonatomic) NSString<Ignore>* onlineVoiceUrl;
//đây là link của video record
@property (strong, nonatomic) NSString<Optional>* mixedRecordingVideoUrl;
@property (strong, nonatomic) NSString<Optional>* onlineMp3Recording;
@property (strong, nonatomic) NSString<Optional>* thumbnailImageUrl;
@property (strong, nonatomic) NSString<Optional>* mixedRecordingYoutubeId;//videoId khi up video lên youtube
/* đây là link của bài thu âm sau khi gửi lên server của ikara*/

@property (strong, nonatomic) NSString*  onlineRecordingUrl;

/* đây là id của cái máy mà gửi bài thu âm lên,
 * để có cái này thì search xem trong iOS có hàm nào lấy được một chuỗi string duy nhất
 * cho một thiết bị nào đó không
 */
@property (strong,nonatomic) NSNumber<Ignore> * duration;
@property (strong,nonatomic) NSNumber * noLike;
@property (strong,nonatomic) NSNumber * noComment;
@property (strong,nonatomic) NSNumber * viewCounter;
@property (strong, nonatomic) NSString*  ownerId;

// mấy tham số này em để giá trị là 0 vì chưa dùng tới

@property (strong,nonatomic) NSNumber  *totalRating;
// mấy tham số này em để giá trị là 0 vì chưa dùng tới

@property (strong,nonatomic) NSNumber * ratingCount;
// mấy tham số này em để giá trị là 0 vì chưa dùng tới

@property (strong,nonatomic) NSNumber  *yourRating;
// mấy tham số này em để giá trị là 0 vì chưa dùng tới
@property (strong,nonatomic) NSNumber * bitRate;
// mấy tham số này em để giá trị là 0 vì chưa dùng tới
@property (strong,nonatomic) NSNumber * noChannels;
// mấy tham số này em để giá trị là 0 vì chưa dùng tới
@property (strong,nonatomic) NSNumber * avgRating;

/* đây là id của cái Lyric người dùng đã chọn để ghi âm bài này */
@property (strong, nonatomic) NSString* selectedLyric;
/* cái này em để giá trị là 1 */
@property (strong,nonatomic) NSNumber * playWithMusic;

/* khi upload lên server người dùng có thể nhập tên, thì tên đó được gán vào đây */
@property (strong, nonatomic) NSString*  yourName;

/* khi upload lên server người dùng có thể nhập một tin nhắn, thì tin nhắn đó được gán vào đây */
@property (strong, nonatomic) NSString*  message;


/* tạm thời để null */
@property (strong, nonatomic) NewEffects *   effectsNew;
@property (strong, nonatomic) EffectsR*  effects;
@property (strong,nonatomic) NSNumber<Optional>* isReviewing;
@property (strong, nonatomic) NSString* rankType;
@property (strong, nonatomic) NSString* platform;
@property (strong, nonatomic)  NSNumber * scorePlus;
@property (strong, nonatomic)  NSNumber * score;
@property (strong, nonatomic)  NSNumber<Optional> * giftScore;
@property (strong,nonatomic)  NSNumber *  rank;
@property (strong,nonatomic) NSNumber<Optional> *isPlaying;

@property (strong, nonatomic) NSString * privacyLevel ;// PUBLIC PRIVATE
@property (strong, nonatomic) NSString * fbVideoId;
@property (strong, nonatomic) NSString * fbVideoUrl;
@property (strong, nonatomic) NSString * fbOwnerId;
@property (strong, nonatomic) NSString * fbPermalinkUrl;
@property (strong, nonatomic) NSString<Optional> * language;
@property (strong, nonatomic) NSString<Optional> * contestStatus;
@property (strong, nonatomic) NSString<Optional> * performanceType; //SOLO ASK4DUET DUET
@property (strong, nonatomic) NSString<Optional> * deviceName;
@property (strong, nonatomic) NSString<Optional> * recordDevice; //HEADSET NOHEADSET

@property (strong, nonatomic) User<Optional> *   owner2; //Dùng Cho DUET
@property (strong, nonatomic) NSString *  originalRecording;  //Dùng Cho DUET
@property (strong, nonatomic) NSNumber<Optional> *   featCounter; //Dùng cho ASK4DUET
@property (strong, nonatomic) Lyric<Optional> *  lyric; //lyric để hát song ca
@property (strong, nonatomic) NSString<Optional> *  sex; //Với một lyric hát song ca thì có 1 lời nam (m) một lời nữ (f),
//Bài thu ASK4DUET thì sex mô tả giới tính được chọn của owner
//Bài thu DUET thì sex mô tả giới tính được chọn của owner2
@property (strong, nonatomic) NSString<Optional> * subVideoUrl;//nếu khác nil thì phát video
@property (strong,nonatomic) NSString<Optional> * playWithSubVideo; //Dùng Cho DUET  TRUE FALSE

@property (strong, nonatomic) NSNumber<Optional> *   lastPosition;
@property (strong, nonatomic) NSString<Optional> * trendStatus;
@end

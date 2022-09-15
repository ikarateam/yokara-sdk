//
//  Song.h
//  Yokara
//
//  Created by Rain Nguyen on 6/27/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Lyric.h"
@protocol Lyric;
@class User;
@interface Song : JSONModel {
    // NSString* localSongUrl;
    @public
    BOOL isDowloading;
  //   NSString* status;
}
@property(strong, nonatomic) NSNumber*  _id;
@property (strong, nonatomic) NSString* songName;
@property (strong, nonatomic) NSString* singerName;
@property (strong, nonatomic) NSString* songUrl;
@property (strong, nonatomic) NSString* mp4link;
@property (strong, nonatomic) NSString<Optional>* videoId;
@property (strong, nonatomic) User<Optional>* owner;
@property (strong, nonatomic) User<Optional>* owner2;
@property (strong, nonatomic) NSString<Optional>* thumbnailUrl;
@property (strong, nonatomic) NSString* approvedLyric;
@property (strong, nonatomic) Lyric<Optional>* selectedLyric;
@property(assign, nonatomic) long   status;
/*public final static int NORMAL = 0;
public final static int ADDTOPLAYLIST = 2;
public final static int QUEUE = 3;
public final static int PREPARE = 4;
public final static int READY = 5;
public final static int STOP = 6;*/
//@property (strong, nonatomic) NSString* localSongUrl;
//@property (strong, nonatomic) Lyric* selectedLyric;
@property (strong, nonatomic) NSMutableArray<Lyric>* lyrics;
@property (strong, nonatomic) NSNumber* viewCounter;
@property (strong, nonatomic) NSNumber* bpm;
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSNumber<Optional>*   duration;
@property (strong, nonatomic) NSNumber<Optional>* likeCounter ;
@property (strong, nonatomic) NSNumber<Optional>* dislikeCounter ;

@property(assign, nonatomic) long counter;
@property(assign, nonatomic) long dateTime;
@property(assign, nonatomic) long dateTimeUpdatePosition;
@property(strong, nonatomic) NSString* firebaseId;
@property(assign, nonatomic) BOOL  isFavorite;
@property(assign, nonatomic) long numberOfLyrics;
@property(assign, nonatomic) long pitchShift;
@property(assign, nonatomic) long progress;



@end

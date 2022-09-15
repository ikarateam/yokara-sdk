//
//  AllSongDB.h
//  YokaraSDK
//
//  Created by Admin on 12/09/2022.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol Song;
@interface AllSongDB : JSONModel
@property (strong, nonatomic) NSMutableArray<Song> * songs;
@end

NS_ASSUME_NONNULL_END

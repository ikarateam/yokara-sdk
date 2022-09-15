//
//  AllRecordingDB.h
//  YokaraSDK
//
//  Created by Admin on 12/09/2022.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol Recording;
@interface AllRecordingDB : JSONModel
@property (strong, nonatomic) NSMutableArray<Recording> * recordings;
@end

NS_ASSUME_NONNULL_END

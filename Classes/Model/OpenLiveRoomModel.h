//
//  OpenLiveRoomModel.h
//  YokaraSDK
//
//  Created by Admin on 18/08/2022.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@class User;
@class LiveRoom;
@interface OpenLiveRoomModel : JSONModel
@property(strong, nonatomic) NSString* user;
@property(strong, nonatomic) NSString* mainUser;
@property(strong, nonatomic) NSString* liveRoom;
@property(strong, nonatomic) NSString* backgroundId;
@end

NS_ASSUME_NONNULL_END

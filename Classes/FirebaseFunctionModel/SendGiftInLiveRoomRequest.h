//
//  SendGiftInRecordingRequest.h
//  Likara
//
//  Created by Rain Nguyen on 6/5/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface SendGiftInLiveRoomRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString*  userId;
@property(strong, nonatomic) NSString*  platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString*  language; //vi, en.yokara
@property(strong, nonatomic) NSString*  packageName;

@property(strong, nonatomic) NSString*  toFacebookId;
@property(strong, nonatomic) NSString*  giftId;
@property(assign, nonatomic) long noItem;
@property(assign, nonatomic) long liveRoomId;

@property(assign, nonatomic) long  noItemSent;
@property(assign, nonatomic) BOOL  isFinishCombo;
@property(strong, nonatomic) NSString*  comboId;
@end


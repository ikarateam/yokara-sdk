//
//  AddGiftRequest.h
//  Likara
//
//  Created by Rain Nguyen on 6/3/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface AddGiftRequest : JSONModel<NSCoding>
@property (assign, nonatomic) long liveRoomId;
@property(strong, nonatomic) NSString* fromFacebookId;
@property(strong, nonatomic) NSString* toFacebookId;
@property(strong, nonatomic) NSString* giftName ;
@property(strong, nonatomic) NSString* giftId;
@property(strong, nonatomic) NSString* giftUrl;
@property (assign, nonatomic) long noItem;
@property (assign, nonatomic) long currentPrice;
@property (assign, nonatomic) long roomTotalScore;
@property(strong, nonatomic) NSString* message;
@end

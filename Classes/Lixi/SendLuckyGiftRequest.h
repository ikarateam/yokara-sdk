//
//  SendLuckyGiftRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface SendLuckyGiftRequest : JSONModel
@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString *language; //vi, en.yokara
@property(strong, nonatomic) NSString *packageName;

@property(strong, nonatomic) NSString *targetId;
@property(strong, nonatomic) NSString *luckyGiftId;
@end

NS_ASSUME_NONNULL_END

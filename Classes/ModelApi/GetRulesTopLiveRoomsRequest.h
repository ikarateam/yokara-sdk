//
//  GetRulesTopLiveRoomsRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/11/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetRulesTopLiveRoomsRequest : JSONModel
@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString *language; //vi, en.yokara
@property(strong, nonatomic) NSString *packageName;
@end

NS_ASSUME_NONNULL_END

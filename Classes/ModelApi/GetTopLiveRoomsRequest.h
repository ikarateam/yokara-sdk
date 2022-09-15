//
//  GetTopLiveRoomsRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetTopLiveRoomsRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString * language; //vi, en.yokara
@property(strong, nonatomic) NSString * packageName;

@property(strong, nonatomic) NSString * cursor;
@property(assign, nonatomic)  int type; //0 daily 1 weekly 2 monthly
@end

NS_ASSUME_NONNULL_END

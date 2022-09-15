//
//  ClientInfo.h
//  Karaoke
//
//  Created by Rain Nguyen on 9/14/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class User;
@interface ClientInfo : JSONModel

@property(strong, nonatomic) NSString *packageName;
@property(strong, nonatomic) NSString * deviceId;
@property(strong, nonatomic) NSString * platform;
@property(strong, nonatomic) NSString *language;
@property(strong, nonatomic)  User* user; 
@end

NS_ASSUME_NONNULL_END

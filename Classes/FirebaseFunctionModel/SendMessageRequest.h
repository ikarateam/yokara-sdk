//
//  SendMessageRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/11/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
#import "JSONModel.h"
@interface SendMessageRequest : JSONModel<NSCoding>

@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) User* fromUser;
@property(strong, nonatomic) User * toUser;

@end


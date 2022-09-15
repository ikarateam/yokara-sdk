//
//  RemoveConversationRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/11/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface RemoveConversationRequest : JSONModel<NSCoding>

@property(strong, nonatomic) NSString*  privateChatId;
@property(strong, nonatomic) NSString*  toFacebookId; 
@end

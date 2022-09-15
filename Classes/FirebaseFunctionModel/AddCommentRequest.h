//
//  AddCommentRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface AddCommentRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* message;
/*@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userUid;
@property(strong, nonatomic) NSString* userType;*/
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* commentId;
@property(strong, nonatomic) NSString* targetId;
@end


//
//  AddFriendRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 7/9/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface AddFriendRequest : JSONModel
@property(strong, nonatomic) NSString*  userId;
@property(strong, nonatomic) NSString*  platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString*  language; //vi, en.Yokara
@property(strong, nonatomic) NSString*  packageName;
@property(strong, nonatomic) NSString*  fromFacebookId;
@property(strong, nonatomic) NSString*  password;
@property(strong, nonatomic) NSString*  toFacebookId;

@end

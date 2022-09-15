//
//  GetRequestFriendsResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 7/9/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol User;
@interface GetRequestFriendsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<User>* friends;
@property(strong, nonatomic) NSString*  cursor;

@end

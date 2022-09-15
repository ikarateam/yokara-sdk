//
//  AddFriendResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 7/9/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface AddFriendResponse : JSONModel
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK

@end

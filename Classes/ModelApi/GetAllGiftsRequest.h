//
//  GetAllGiftsRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 7/19/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface GetAllGiftsRequest : JSONModel
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *platform; //ANDROID, IOS, WINDOWSPHONE
@property (strong, nonatomic) NSString *language; //vi, en.Yokara
@property (strong, nonatomic) NSString *packageName;


@end

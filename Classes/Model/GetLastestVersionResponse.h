//
//  GetLastestVersionResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 7/1/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "YTPatternRequest.h"
@protocol Banner;
@protocol YTPatternRequest;
@protocol User;
#import "ContestRules.h"
#import "BannedObject.h"
@interface GetLastestVersionResponse : JSONModel
/*
@property (strong, nonatomic)  NSNumber* lastestVersionCode;
@property (strong, nonatomic) NSString*  lastestVersionName;
@property (strong, nonatomic) NSString*  nonMarketLink;
@property (strong, nonatomic) NSString*  marketLink;
@property (strong, nonatomic) NSString*  forceUpdate;
//@property (strong, nonatomic) NSString* neFeatures;
@property (strong, nonatomic) NSString*  showUpdate;*/
@property (strong, nonatomic) NSDictionary* properties;
@property (strong, nonatomic)  NSMutableArray<Banner> *banners;
@property (strong, nonatomic)  NSMutableArray<User> *blockedUsers;
@property (strong, nonatomic)  NSMutableArray<User> *relatedUsers;
@property (strong, nonatomic) NSMutableArray <YTPatternRequest>* YTPatternRequests;
@property (strong, nonatomic) NSMutableArray * copyrightedSong;
@property (strong, nonatomic) ContestRules* topRecordingsRules;
@property (strong, nonatomic) BannedObject* bannedObject;
@end

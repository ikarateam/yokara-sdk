//
//  GetLastestVersionRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 7/1/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetLastestVersionRequest : JSONModel
@property (strong, nonatomic) NSString*  userId;
@property (strong, nonatomic) NSString*  platform; //ANDROID, IOS, WINDOWSPHONE
@property (strong, nonatomic) NSString*  language;
@property (strong, nonatomic) NSString*  packageName;
@property (strong, nonatomic) NSString*  version;

@property (strong, nonatomic) NSString* device; //android.Build.device
@property (strong, nonatomic) NSString* model;
@property (strong, nonatomic) NSString* product;
@property (strong, nonatomic) NSString* versionSdk;
@property (strong, nonatomic) NSString* brand;
@property (strong, nonatomic) NSString* buildId; //Build.ID
@property (strong, nonatomic) NSString*versionRelease;//Build.VERSION.RELEASE
@property (strong, nonatomic) NSString* versionIncremental; //Build.VERSION.INCREMENTAL

@property (strong, nonatomic) NSMutableArray* viewedBanner; //list id of viewed banners
@property (strong, nonatomic) NSString* localIp;
@property (strong, nonatomic) NSString* firebaseAppInstanceId;
@end

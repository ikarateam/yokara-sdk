//
//  GetYtDirectLinksRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 10/5/19.
//  Copyright © 2019 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetYtDirectLinksRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString * language; //vi, en.Yokara
@property(strong, nonatomic) NSString * packageName;
@property(strong, nonatomic) NSString * videoId;
@property(strong, nonatomic) NSMutableArray * contents;
@end

NS_ASSUME_NONNULL_END

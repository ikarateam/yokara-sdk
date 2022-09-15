//
//  GetYtDirectLinksResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 12/17/19.
//  Copyright © 2019 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol Video;
@interface GetYtDirectLinksResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<Video>* videos;
@end

NS_ASSUME_NONNULL_END

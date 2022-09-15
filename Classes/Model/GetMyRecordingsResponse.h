//
//  GetMyRecordingsResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/29/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol Recording;
@interface GetMyRecordingsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray <Recording>* recordings;
@property(strong, nonatomic) NSString* cursor;

@end

NS_ASSUME_NONNULL_END

//
//  SearchAsk4DuetRecordingsResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/2/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol Recording;
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchAsk4DuetRecordingsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray <Recording>* recordings;
@property(strong, nonatomic) NSString *cursor;
@end

NS_ASSUME_NONNULL_END

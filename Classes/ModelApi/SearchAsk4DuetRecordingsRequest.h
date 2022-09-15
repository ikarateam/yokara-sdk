//
//  SearchAsk4DuetRecordingsRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/2/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchAsk4DuetRecordingsRequest : JSONModel
@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString *language;
@property(strong, nonatomic) NSString *packageName;
@property(strong, nonatomic) NSString *version;
@property(strong, nonatomic) NSString *query;
@property(strong, nonatomic) NSString *cursor;
@end

NS_ASSUME_NONNULL_END

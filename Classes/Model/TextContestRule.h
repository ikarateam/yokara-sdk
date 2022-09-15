//
//  TextContestRule.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/3/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TextContestRule : JSONModel
@property(strong, nonatomic) NSString *  title;
@property(strong, nonatomic) NSString *  details;
@end

NS_ASSUME_NONNULL_END

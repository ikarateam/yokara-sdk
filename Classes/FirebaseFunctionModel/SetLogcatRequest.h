//
//  SetLogcatRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/20/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LogcatLine;
#import "JSONModel.h"
@interface SetLogcatRequest : JSONModel
@property(strong, nonatomic) LogcatLine* logcatLine;
@property(strong, nonatomic) NSString*  lastUID;
@end


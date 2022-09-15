//
//  SetLastRunLogcatRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/20/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface SetLastRunLogcatRequest : JSONModel
@property(strong, nonatomic) NSString*  lastUID;
@end


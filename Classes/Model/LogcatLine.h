//
//  LogcatLine.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/20/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "JSONModel.h"
@interface LogcatLine : JSONModel
@property(strong, nonatomic) NSString*  pid ;
@property(assign, nonatomic) long tid ;
@property(assign, nonatomic) long time ;
@property(strong, nonatomic) NSString*  level ;
@property(strong, nonatomic) NSString*  tag ;
@property(strong, nonatomic) NSString*  msg ;
@end



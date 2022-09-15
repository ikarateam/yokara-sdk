//
//  UserScore.h
//  Likara
//
//  Created by Rain Nguyen on 5/22/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface UserScore : JSONModel<NSCoding>
@property (assign, nonatomic) long lastOnline;
@property (assign, nonatomic)  long totalScore;
@end


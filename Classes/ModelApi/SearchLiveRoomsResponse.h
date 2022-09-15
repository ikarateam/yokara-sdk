//
//  SearchLiveRoomsResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol LiveRoom;
@interface SearchLiveRoomsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<LiveRoom> * rooms;
@property(strong, nonatomic) NSString * cursor;
@end



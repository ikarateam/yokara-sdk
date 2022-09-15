//
//  RemoveSongRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class Song;
@interface RemoveSongRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic)  Song* song;
@end


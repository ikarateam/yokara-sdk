//
//  DoneSongRequest.h
//  Likara
//
//  Created by Rain Nguyen on 6/3/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Song;
#import "JSONModel.h"
@interface DoneSongRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString*  roomId;
@property(strong, nonatomic)  Song* song;
@end


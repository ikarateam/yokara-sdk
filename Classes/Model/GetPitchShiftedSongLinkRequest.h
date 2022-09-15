//
//  GetPitchShiftedSongLinkRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 10/28/19.
//  Copyright © 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetPitchShiftedSongLinkRequest : JSONModel
@property(strong, nonatomic) NSString* facebookId;
@property(strong, nonatomic) NSString* password;
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSNumber* songId;
@property(strong, nonatomic) NSString* language;
@property(strong, nonatomic) NSNumber* pitchShift; //0 -> +-12

@end

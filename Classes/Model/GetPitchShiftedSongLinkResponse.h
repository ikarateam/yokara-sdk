//
//  GetPitchShiftedSongLinkResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 10/28/19.
//  Copyright © 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetPitchShiftedSongLinkResponse : JSONModel
@property(strong, nonatomic) NSString* message;
@property(strong, nonatomic) NSString* status; //READY, PENDING
@property(strong, nonatomic) NSString* link; //nếu status = READY thì sẽ trả về link

@end

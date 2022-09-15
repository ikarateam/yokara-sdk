//
//  SetOwnerUserIdRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/2/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@interface SetOwnerUserIdRequest : JSONModel
@property(strong, nonatomic)  NSNumber * recordingId; //id số a nhé ko phải string

@end



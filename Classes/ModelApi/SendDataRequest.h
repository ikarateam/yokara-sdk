//
//  SendDataRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/12/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@interface SendDataRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* streamId;
@property(strong, nonatomic) NSString* facebookId;
@property(assign, nonatomic) long timestamp;
@end

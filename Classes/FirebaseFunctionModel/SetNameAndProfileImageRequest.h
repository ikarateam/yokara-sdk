//
//  SetNameAndProfileImageRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/2/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@interface SetNameAndProfileImageRequest : JSONModel
@property(strong, nonatomic) NSString*  name;
@property(strong, nonatomic) NSString* profileImageLink;
@end



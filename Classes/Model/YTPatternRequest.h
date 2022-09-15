//
//  YTPatternRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 10/24/19.
//  Copyright © 2019 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@interface YTPatternRequest : JSONModel
@property(strong, nonatomic) NSString* url;
@property(strong, nonatomic) NSString* method; //POST GET
@property(strong, nonatomic) NSMutableDictionary* headers;
@property(strong, nonatomic) NSMutableDictionary* params;
@end


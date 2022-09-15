//
//  NSString+URLEncoding.h
//  Yokara
//
//  Created by Rain Nguyen on 10/2/19.
//  Copyright © 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding;
-(NSString *)urlEncodeUsingUtf8Encoding;

@end

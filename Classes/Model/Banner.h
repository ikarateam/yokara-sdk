//
//  Banner.h
//  Yokara
//
//  Created by APPLE on 6/22/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface Banner : JSONModel
@property(strong, nonatomic) NSString* bannerId;
@property(strong, nonatomic) NSString* type; //TIP //PROMOTE // EVENT

@property(strong, nonatomic) NSString* url; //url có thể dạng http:// hoặc ikara:// nếu là ikara:// thì sẽ mở deeplink tương ứng
@property(strong, nonatomic) NSString* thumbnail;
@property(strong, nonatomic) NSString* backgroundColor;
@end

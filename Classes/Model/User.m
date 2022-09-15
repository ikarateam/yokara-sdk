//
//  User.m
//  Yokara
//
//  Created by Rain Nguyen on 10/8/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "User.h"
#import "coverImage.h"
//#import "LoadData.h"
#import "cover.h"
@implementation User
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
       
       
        _facebookId = [dict objectForKey:@"id"];
        _name = [dict objectForKey:@"name"];
        //_nameKoDau=[[LoadData alloc] normalizeVietnameseString:_name];
        _username = [dict objectForKey:@"username"];
        _email = [dict objectForKey:@"email"];
         _gender = [dict objectForKey:@"gender"];
        /*if (gender.length>0){
            if ([gender isEqualToString:@"male"]) _gender=[NSNumber numberWithInt:1];
            else if ([gender isEqualToString:@"female"]) _gender=[NSNumber numberWithInt:2];
            else _gender=[NSNumber numberWithInt:0];
        }else _gender=[NSNumber numberWithInt:0];*/
        _facebookLink = [dict objectForKey:@"link"];
        _location = [[dict objectForKey:@"location"] objectForKey:@"name"];
        _profileImageLink=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",_facebookId];
      //  NSString *coverImageString=[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@?fields=cover",_facebookId]] encoding:NSUTF8StringEncoding error:nil];
      //  coverImage * coverImageData=[[coverImage alloc] initWithString:coverImageString error:nil];
        
       // _coverImageLink=coverImageData.cover.source;
    }
    return self;
}

@end

//
//  Paint.m
//  Yokara
//
//  Created by Rain Nguyen on 7/8/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "Paint.h"

@implementation Paint

-(id) initWithFont:(NSString *) fon andSize:(int) size{
    self=[super init];
    if(self){
        self.font=fon;
        self.fontsize=size;
    }
    return self;
}
-(id) getPaint{
    Paint* pain = self;
    return pain;
}
-(void) setTypeface:(NSString *) tf{
    self.font= tf;
}
-(void) setTextSize:(int) fontSize{
    self.fontsize = fontSize;
}
-(CGFloat) measureText:(NSString*) text{
    UIFont *myFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@",self.font] size:self.fontsize];
    
    CGSize stringSize = [text sizeWithFont:myFont];
    
    CGFloat width = stringSize.width;
    return width;
}

@end

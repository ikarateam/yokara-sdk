//
//  Paint.h
//  Yokara
//
//  Created by Rain Nguyen on 7/8/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Paint : NSObject{
    
    
}
@property (atomic) int fontsize;
@property (strong,nonatomic) NSString * font;
-(id) getPaint;
-(id) initWithFont:(NSString *) fon andSize:(int) size;
-(void) setTypeface:(NSString *) tf;
-(void) setTextSize:(int) fontSize;
-(CGFloat) measureText:(NSString*) text;

@end

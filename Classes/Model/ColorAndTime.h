//
//  ColorAndTime.h
//  Yokara
//
//  Created by APPLE on 10/16/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ColorAndTime:NSObject
@property(nonatomic,assign) double time;
@property(nonatomic,assign) NSInteger gender;//0:me,1:other,2:duet
@property (nonatomic,strong) UIColor *color;

@end

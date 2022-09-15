//
//  RulerVolumeView.m
//  Yokara
//
//  Created by Rain Nguyen on 11/28/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "RulerVolumeView.h"
#import <Constant.h>
@implementation RulerVolumeView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect frame = self.bounds;
    // Set the background color
    [[UIColor lightGrayColor] set];
    UIRectFill(frame);
    float wid=(frame.size.width/19.0);
    for (int i=0;i<15;i++) {
        if (i<7) {
           [UIColorFromRGB(0x62C47B) set];
            float start=i*wid;
            UIRectFill(CGRectMake(start, 0,wid, frame.size.height));
        }else if (i<10) {
            [UIColorFromRGB(0xFDA945) set];
            float start=i*wid;
            UIRectFill(CGRectMake(start, 0,wid, frame.size.height));
        }else if (i<15) {
            [UIColorFromRGB(ColorSlider) set];
            float start=i*wid;
            UIRectFill(CGRectMake(start, 0,wid, frame.size.height));
        }
        
        
    }
}


@end

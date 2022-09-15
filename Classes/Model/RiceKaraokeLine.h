//
//  RiceKaraokeLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
@class SimpleKaraokeDisplay;
@class Line;
#import <UIKit/UIKit.h>
@interface RiceKaraokeLine : NSObject{

}
@property (strong, nonatomic) SimpleKaraokeDisplay *_display;
@property (atomic) CGFloat _start;
@property (atomic)   CGFloat end;
@property (strong, nonatomic)Line *_timing;
@property (atomic) CGFloat _elapsed;
-(RiceKaraokeLine *) expire:(CGFloat) elapsed;
-(BOOL) update:(CGFloat) elapsed;

@end

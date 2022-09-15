//
//  EmptyListView.m
//  Yokara
//
//  Created by Rain Nguyen on 10/2/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "EmptyListView.h"
#import "YokaraSDK.h"
@implementation EmptyListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init{
    NSArray *subviewArray = [[YokaraSDK resourceBundle] loadNibNamed:@"EmptyListView" owner:self options:nil];
    return [subviewArray objectAtIndex:0];
}

@end

//
//  ToggleButton.m
//  ToggleView
//
//  Created by SOMTD on 12/10/19.
//  Copyright (c) 2012年 somtd.com. All rights reserved.
//


#import "ToggleButton.h"

//change button image option
NSString *const TOGGLE_BUTTON_IMAGE_L    = @"icn_vswitch_tat.png";
NSString *const TOGGLE_BUTTON_IMAGE_R    = @"icn_vswitch_mo.png";


@implementation ToggleButton
@synthesize buttonType;

- (id)initWithImage:(UIImage *)image buttonType:(ToggleButtonType)aButtonType
{
    self = [super initWithImage:image];
    if (self) {
        self.buttonType = aButtonType;
        if (self.buttonType == ToggleButtonTypeChangeImage)
        {
            //default select "L"
            self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_L inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            return self;
        }
    }
    return self;
}

- (void)selectedLeftToggleButton
{
    if (self.buttonType == ToggleButtonTypeChangeImage)
    {
        self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_L inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    }
}

- (void)selectedRightToggleButton
{
    if (self.buttonType == ToggleButtonTypeChangeImage)
    {
        self.image = [UIImage imageNamed:TOGGLE_BUTTON_IMAGE_R inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];

    }
}

@end

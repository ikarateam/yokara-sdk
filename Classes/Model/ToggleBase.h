//
//  ToggleBase.h
//  ToggleView
//
//  Created by SOMTD on 12/10/19.
//  Copyright (c) 2012年 somtd.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YokaraSDK.h"
typedef enum{
    ToggleBaseTypeDefault,
    ToggleBaseTypeChangeImage,
}ToggleBaseType;

@interface ToggleBase : UIImageView

@property (nonatomic) ToggleBaseType baseType;
- (id)initWithImage:(UIImage *)image baseType:(ToggleBaseType)aBaseType;
- (void)selectedLeftToggleBase;
- (void)selectedRightToggleBase;


@end

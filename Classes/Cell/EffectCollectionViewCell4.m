//
//  EffectCollectionViewCell.m
//  iMimic
//
//  Created by APPLE on 3/22/19.
//  Copyright © 2019 vnapps. All rights reserved.
//


#import "EffectCollectionViewCell4.h"
#import <Constant.h>
@implementation EffectCollectionViewCell4

- (void)awakeFromNib {
    // Initialization code
    self.imageView.layer.cornerRadius=55/2;
    self.imageView.layer.masksToBounds=YES;
    self.isChoose.layer.cornerRadius=55/2;
   self.isChoose.layer.borderColor=[UIColorFromRGB(0xF14953)   CGColor]; self.isChoose.layer.masksToBounds=YES;
    [super awakeFromNib];
}


@end

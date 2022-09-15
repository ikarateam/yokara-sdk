//
//  EffectCollectionViewCell.m
//  iMimic
//
//  Created by APPLE on 3/22/19.
//  Copyright © 2019 vnapps. All rights reserved.
//


#import "EffectCollectionViewCell2.h"

@implementation EffectCollectionViewCell2

- (void)awakeFromNib {
    // Initialization code
    self.imageView.layer.cornerRadius=55/2;
    self.imageView.layer.masksToBounds=YES;
    self.isChosse.layer.cornerRadius=55/2;
    self.isChosse.layer.masksToBounds=YES;
}


@end

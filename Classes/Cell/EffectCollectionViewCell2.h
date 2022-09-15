//
//  EffectCollectionViewCell.h
//  iMimic
//
//  Created by APPLE on 3/22/19.
//  Copyright © 2019 vnapps. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EffectCollectionViewCell2 : UICollectionViewCell
@property  (weak, nonatomic)  IBOutlet UILongPressGestureRecognizer *longPressGestureActionButton;
@property  (weak, nonatomic)  IBOutlet UITapGestureRecognizer *tapGestureActionButton;
@property  (weak, nonatomic)  IBOutlet UIButton *actionButton;
@property  (weak, nonatomic)  IBOutlet UIImageView *imageView;
@property  (weak, nonatomic)  IBOutlet UILabel *titleLabel;
@property  (weak, nonatomic)  IBOutlet UIImageView *isChosse;
@property  (weak, nonatomic)  IBOutlet UIImageView *icnVIP;


@end

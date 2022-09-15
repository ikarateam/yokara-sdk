//
//  GiftCollectionViewCell.h
//  Yokara
//
//  Created by Rain Nguyen on 7/30/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftCollectionViewCell2 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iCoinImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImageWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftNameHeight;
@property  (weak, nonatomic)  IBOutlet UIImageView *giftImage;
@property  (weak, nonatomic)  IBOutlet UILabel *giftName;
@property  (weak, nonatomic)  IBOutlet UILabel *giftNoItems;
@property  (weak, nonatomic)  IBOutlet UIButton *actionButton;
@property  (weak, nonatomic)  IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *giftTag;

@property (weak, nonatomic) IBOutlet UILabel *giftType;


@end

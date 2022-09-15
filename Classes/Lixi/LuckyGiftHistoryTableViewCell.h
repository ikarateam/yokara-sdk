//
//  LuckyGiftHistoryTableViewCell.h
//  Karaoke
//
//  Created by Admin on 25/11/2021.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuckyGiftHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *takeLGButton;
@property (weak, nonatomic) IBOutlet UILabel *noGift;
@property (weak, nonatomic) IBOutlet UIImageView *giftTaken;
@property (weak, nonatomic) IBOutlet UILabel *timeTakeLG;
@property (weak, nonatomic) IBOutlet UIImageView *userFrame;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;

@end

NS_ASSUME_NONNULL_END

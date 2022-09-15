//
//  LuckyGiftHistoryTableViewCell.m
//  Karaoke
//
//  Created by Admin on 25/11/2021.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LuckyGiftHistoryTableViewCell.h"

@implementation LuckyGiftHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.takeLGButton.layer.cornerRadius = 12;
    self.takeLGButton.layer.masksToBounds = YES;
    self.userProfile.layer.cornerRadius = 24;
    self.userProfile.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

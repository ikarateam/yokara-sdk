//
//  LuckyGiftInfoTableViewCell.m
//  Karaoke
//
//  Created by Rain Nguyen on 11/22/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LuckyGiftInfoTableViewCell.h"

@implementation LuckyGiftInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumbnail.layer.cornerRadius = 22;
    self.thumbnail.layer.masksToBounds = YES;
    self.scoreView.layer.cornerRadius = 7;
    self.scoreView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

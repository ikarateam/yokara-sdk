//
//  UserOnlineRoomTableViewCell.m
//  Likara
//
//  Created by Rain Nguyen on 3/26/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "UserOnlineRoomTableViewCell.h"

@implementation UserOnlineRoomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumbnailImage.layer.cornerRadius = 16;
    self.thumbnailImage.layer.masksToBounds = YES;
    self.noUserOnline.layer.cornerRadius = 4;
    self.noUserOnline.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

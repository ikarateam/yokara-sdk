//
//  ChatGroupListTableViewCell.m
//  Yokara
//
//  Created by Rain Nguyen on 6/16/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import "UserCell2.h"

@implementation UserCell2

- (void)awakeFromNib {
    // Initialization code
    self.thumbnail.layer.cornerRadius=self.thumbnail.frame.size.height/2;
    self.thumbnail.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

//
//  UserOnlineCollectionViewCell.m
//  Likara
//
//  Created by Rain Nguyen on 3/24/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "UserOnlineCollectionViewCell.h"

@implementation UserOnlineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumnailImage.layer.cornerRadius = 15;
    self.thumnailImage.layer.masksToBounds = YES;
    self.point.layer.cornerRadius = 4;
    self.point.layer.masksToBounds = YES;
	
}

@end

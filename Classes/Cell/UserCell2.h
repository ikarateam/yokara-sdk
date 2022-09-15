//
//  ChatGroupListTableViewCell.h
//  Yokara
//
//  Created by Rain Nguyen on 6/16/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UserCell2 : UITableViewCell
@property  (weak, nonatomic)  IBOutlet UIImageView *frameImage;
@property  (weak, nonatomic)  IBOutlet UIImageView *scoreIcon;
@property  (weak, nonatomic)  IBOutlet UILabel *score;
@property  (weak, nonatomic)  IBOutlet UIImageView *rankBG;
@property  (weak, nonatomic)  IBOutlet UILabel *rankLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *nameGroup;
@property  (weak, nonatomic)  IBOutlet UILabel *descriptionGroup;
@property  (weak, nonatomic)  IBOutlet UIImageView *thumbnail;
@property  (weak, nonatomic)  IBOutlet UIImageView *genderImage;
@property  (weak, nonatomic)  IBOutlet UIButton *actionButton;


@end

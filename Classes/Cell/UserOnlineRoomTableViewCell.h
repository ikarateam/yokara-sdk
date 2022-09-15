//
//  UserOnlineRoomTableViewCell.h
//  Likara
//
//  Created by Rain Nguyen on 3/26/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserOnlineRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userFrame;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *userType;
@property (weak, nonatomic) IBOutlet UILabel *noUserOnline;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterConstraints;

@end

NS_ASSUME_NONNULL_END

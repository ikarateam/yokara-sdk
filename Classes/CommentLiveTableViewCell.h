//
//  CommentTableViewCell.h
//  iSing
//
//  Created by APPLE on 12/19/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BMXSwipableCell.h"
@interface CommentLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *luckyGiftImage;
@property (weak, nonatomic) IBOutlet UIView *luckyGiftView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImage;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbnailButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *statusMessageView;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerIcon;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *ownerRoom;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *topTimeLabelMargin;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *userNameTopMargin;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *contentLabelHeight;
@property  (weak, nonatomic)  IBOutlet UIImageView *giftBackground;
@property  (weak, nonatomic)  IBOutlet UIImageView *giftImage;
@property  (weak, nonatomic)  IBOutlet UILabel *noGift;
@property (strong, nonatomic) UIButton *deleteButton;
@property  (weak, nonatomic)  IBOutlet UIButton *actionButton;
@property  (weak, nonatomic)  IBOutlet UIButton *thumnailButton;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *thumnailImageHeight;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *thumnailImageWidth;
@property  (weak, nonatomic)  IBOutlet NSLayoutConstraint *thumnailImageContrain;
@property  (weak, nonatomic)  IBOutlet UIButton *noLikeButton;
@property  (weak, nonatomic)  IBOutlet UILabel *nameLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *contentLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *timeLabel;
@property  (weak, nonatomic)  IBOutlet UIImageView *thumnailImage;
@property  (weak, nonatomic)  IBOutlet UIButton *likeButton;
@property  (weak, nonatomic)  IBOutlet UIButton *relyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeftContrainst;

@end

//
//  UserOnlineCollectionViewCell.h
//  Likara
//
//  Created by Rain Nguyen on 3/24/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserOnlineCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ic_sofa;
@property (weak, nonatomic) IBOutlet UIImageView *thumnailImage;
@property (weak, nonatomic) IBOutlet UIImageView *frameImage;
@property (weak, nonatomic) IBOutlet UILabel *point;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

NS_ASSUME_NONNULL_END

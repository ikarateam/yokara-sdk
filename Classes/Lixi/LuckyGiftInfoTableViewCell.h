//
//  LuckyGiftInfoTableViewCell.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/22/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuckyGiftInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *noGift;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

NS_ASSUME_NONNULL_END

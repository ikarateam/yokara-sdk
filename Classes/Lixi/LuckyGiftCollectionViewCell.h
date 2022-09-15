//
//  LuckyGiftCollectionViewCell.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/22/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol Gift;
@interface LuckyGiftCollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (strong, nonatomic) NSMutableArray<Gift> *gifts;
@property (weak, nonatomic) IBOutlet UIImageView *lgBackground;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet UITableView *giftTableView;

@end

NS_ASSUME_NONNULL_END

//
//  LuckyGiftCollectionViewCell.m
//  Karaoke
//
//  Created by Rain Nguyen on 11/22/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LuckyGiftCollectionViewCell.h"
#import "LuckyGiftInfoTableViewCell.h"
#import "LoadData2.h"
#import "YokaraSDK.h"
@implementation LuckyGiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lgBackground.layer.cornerRadius = 10;
    self.lgBackground.layer.masksToBounds = YES;
    self.giftTableView.dataSource = self;
    self.giftTableView.delegate = self;
    [self.giftTableView registerNib:[UINib nibWithNibName:@"LuckyGiftInfoTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"Cell"];
    self.giftTableView.allowsSelection = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.
    return [self.gifts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    LuckyGiftInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Gift * gift = [self.gifts objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[LuckyGiftInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.giftName.text = gift.name;
    cell.noGift.text = [NSString stringWithFormat:@"Số lượng x%@",gift.noItem];
    cell.score.text = [NSString stringWithFormat:@"+ %d",gift.score];
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:gift.url]];
    if (indexPath.row==self.gifts.count-1){
        cell.line.hidden = YES;
    }else {
        cell.line.hidden = NO;
    }
    return cell;
}
@end

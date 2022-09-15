//
//  PrepareViewController.h
//  YokaraKaraoke
//
//  Created by Admin on 03/06/2022.
//  Copyright © 2022 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#pragma mark - Delegate functions
@protocol PrepareViewDelegate <NSObject>

@optional
- (void) recordFinish:(NSString *)record;
- (void) recordCancel;
- (void) recordFailWithError;
@end
@interface PrepareView : NSObject
@property (nonatomic, weak) id <PrepareViewDelegate> delegate;
@property (strong ,nonatomic) NSString *recordString;
@property (strong ,nonatomic) NSString *performanceType;
@property (assign ,nonatomic) NSInteger toneOfSong;
- (void) recordSolo:(NSString *) songString;
@end

NS_ASSUME_NONNULL_END

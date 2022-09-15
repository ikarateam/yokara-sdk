//
//  AlertViewController.h
//  Yokara
//
//  Created by Rain Nguyen on 7/11/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol alertViewDelegate <NSObject>
@optional
-(void) okPress:(BOOL) isPress;

- (void) checkBoxChange:(BOOL) isCheck;

@end
@interface AlertViewController : UIViewController
@property(nonatomic,weak) id<alertViewDelegate> delegate;
@property  (weak, nonatomic)  IBOutlet UILabel *contentMessage;
@property  (weak, nonatomic)  IBOutlet UILabel *contentAdding;
@property  (weak, nonatomic)  IBOutlet UILabel *checkboxLabel;
@property (strong,nonatomic) NSString *contentMess;
@property (strong,nonatomic) NSString *contentAdd;

@end

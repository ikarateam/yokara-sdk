//
//  UploadRecordingViewController.h
//  Yokara
//
//  Created by APPLE on 3/20/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LoadData2.h"
#import "UploadToServerYokara.h"
@interface UploadRecordingViewController : UIViewController<UITextViewDelegate>{
    BOOL privacyRecordingisPrivate;
    NSTimer *buttonTimer;
    NSTimer *demperc;
}
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pt;

@property (strong ,nonatomic) Recording * recording;
@property  (weak, nonatomic)  IBOutlet UITextView *userNameTextView;
@property  (weak, nonatomic)  IBOutlet UIImageView *privacyImage;
@property  (weak, nonatomic)  IBOutlet UITextView *messageTextView;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyButton;
@property  (weak, nonatomic)  IBOutlet UILabel *userNameLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *messageLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *characterCount;

@property  (weak, nonatomic)  IBOutlet UIView *privacyView;

@end

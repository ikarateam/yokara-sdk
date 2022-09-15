//
//  MenuUserOnlineInfoViewController.h
//  Likara
//
//  Created by Rain Nguyen on 3/25/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadData2.h"
NS_ASSUME_NONNULL_BEGIN

@interface MenuUserOnlineInfoViewController : UIViewController{
    //GetRecordingsResponse *getRecordOfUser;
    FIRDatabaseHandle _refHandle;
}
@property (weak, nonatomic) IBOutlet UIImageView *userGender;
@property (weak, nonatomic) IBOutlet UIImageView *userFrame;
@property(strong, nonatomic) FIRFunctions *functions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuForAdminHeightConstrainst;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuForOwnerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *menuForAdminView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuMessageHeightConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewBottomContrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *menuMessageView;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
@property (weak, nonatomic) IBOutlet UIView *menuReportView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel4;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel3;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel2;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel1;
@property (strong, nonatomic) User * currUser;
@property (strong, nonatomic) User * user;
@property (assign, nonatomic) BOOL  isFamilyRoom;
@property (strong, nonatomic) NSString * ownerUserType;
@property  (weak, nonatomic)  IBOutlet UIView *menuEditRecordingView;

@property  (weak, nonatomic)  IBOutlet UIView *menuRecordingView;
@property  (weak, nonatomic)  IBOutlet UIView *menuRecordingSubView;
@property  (weak, nonatomic)  IBOutlet UIImageView *menuRecordingThumbnail;
@property  (weak, nonatomic)  IBOutlet UILabel *menuRecordingSongName;
@property  (weak, nonatomic)  IBOutlet UILabel *menuRecordingOwer;
@end

NS_ASSUME_NONNULL_END

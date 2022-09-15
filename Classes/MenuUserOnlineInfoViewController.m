//
//  MenuUserOnlineInfoViewController.m
//  Likara
//
//  Created by Rain Nguyen on 3/25/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "MenuUserOnlineInfoViewController.h"

#import "LiveViewController.h"
#import "ExpelFromFamilyResponse.h"
@interface MenuUserOnlineInfoViewController ()

@end

@implementation MenuUserOnlineInfoViewController
- (IBAction)setVip:(id)sender {
	 self.loading.hidden = NO;
	 [UIView animateWithDuration: 0.5f animations:^{
		  self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-100;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){



	 }];
    if ([self.currUser.roomUserType isEqualToString:@"VIP"] || ( self.isFamilyRoom && [self.currUser.roomUserType isEqualToString:@"ADMIN"])) {
       dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
       dispatch_async(queue, ^{
           if (self.isFamilyRoom){
               ExpelFromFamilyResponse *getResponse =  [[LoadData2 alloc] familyExpelFromFamily:self.currUser.facebookId];
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   
                   [[[[iToast makeText:getResponse.message]
                      setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                   
                   [self.view removeFromSuperview];
                   ////[self dismissViewControllerAnimated:YES completion:nil];
               });
           }else {
           CancelVipForUserRequest *firRequest = [CancelVipForUserRequest new];
            firRequest.userActionId = currentFbUser.facebookId;
            firRequest.roomId = liveRoomID;
            firRequest.profileImageLink = self.currUser.profileImageLink;
            firRequest.name = self.currUser.name;
            firRequest.facebookId = self.currUser.facebookId;
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            self.functions = [FIRFunctions functions];
       
            __block FirebaseFuntionResponse *getResponse=nil;
            [[_functions HTTPSCallableWithName:Fir_CancelVipForUser] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
             
                NSString *stringReply = (NSString *)result.data;

                getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                // Some debug code, etc.
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([getResponse.status isEqualToString:@"OK"]) {
                        self.currUser.roomUserType = @"USER";
                        if ([self.currUser.roomUserType isEqualToString:@"USER"]) {
                            if (self.isFamilyRoom){
                                self.menuLabel2.text = AMLocalizedString(@"Mời làm thành viên", nil);
                            }else
                            self.menuLabel2.text = AMLocalizedString(@"Chọn làm khách VIP", nil);
                        }
                    }else{
                            [[[[iToast makeText:getResponse.message]
                            setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                    }
                    [self.view removeFromSuperview];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                });

            }];
           }
         
       });
   }else {
    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
    dispatch_async(queue, ^{
   
        if (self.isFamilyRoom){
            SetVipForUserRequest *firRequest = [SetVipForUserRequest new];
            firRequest.userActionId = currentFbUser.facebookId;
            firRequest.roomId = liveRoomID;
            firRequest.profileImageLink = self.currUser.profileImageLink;
            firRequest.name = self.currUser.name;
            firRequest.facebookId = self.currUser.facebookId;
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            self.functions = [FIRFunctions functions];
            __block FirebaseFuntionResponse *getResponse=nil;
            [[_functions HTTPSCallableWithName:Fir_InviteMemberForUser] callWithObject:@{@"parameters":requestString}
                                                                      completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                
                NSString *stringReply = (NSString *)result.data;
                
                getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                        [[[[iToast makeText:getResponse.message]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        
                    [self.view removeFromSuperview];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }];
        }else {
        SetVipForUserRequest *firRequest = [SetVipForUserRequest new];
         firRequest.userActionId = currentFbUser.facebookId;
         firRequest.roomId = liveRoomID;
         firRequest.profileImageLink = self.currUser.profileImageLink;
         firRequest.name = self.currUser.name;
         firRequest.facebookId = self.currUser.facebookId;
         NSString * requestString = [[firRequest toJSONString] base64EncodedString];
         self.functions = [FIRFunctions functions];
         __block FirebaseFuntionResponse *getResponse=nil;
         [[_functions HTTPSCallableWithName:Fir_SetVipForUser] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
          
             NSString *stringReply = (NSString *)result.data;

             getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
             dispatch_async(dispatch_get_main_queue(), ^{

                 if ([getResponse.status isEqualToString:@"OK"]) {
                     self.currUser.roomUserType = @"VIP";
                     if ([self.currUser.roomUserType isEqualToString:@"VIP"]) {
                         if (self.isFamilyRoom){
                             self.menuLabel2.text = AMLocalizedString(@"Hủy Thành viên", nil);
                         }else
                         self.menuLabel2.text = AMLocalizedString(@"Hủy khách VIP", nil);
                     }
                 }else{
                         [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                 }
                 [self.view removeFromSuperview];
                 // [self dismissViewControllerAnimated:YES completion:nil];
             });

         }];
        }
        
    });
   }
}
- (IBAction)setAdmin:(id)sender {
	 self.loading.hidden = NO;
	 [UIView animateWithDuration: 0.5f animations:^{
		  self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-100;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){



	 }];
    if ([self.currUser.roomUserType isEqualToString:@"ADMIN"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            if (self.isFamilyRoom){
                DegradedResponse *getResponse =  [[LoadData2 alloc] familyDegraded:self.currUser.facebookId];
                if (getResponse.status.length==2){
                    self.currUser.roomUserType = @"USER";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [[[[iToast makeText:getResponse.message]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    
                    [self.view removeFromSuperview];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                });
            }else {
            CancelAdminForUserRequest *firRequest = [CancelAdminForUserRequest new];
            firRequest.userActionId = currentFbUser.facebookId;
            firRequest.roomId = liveRoomID;
            firRequest.profileImageLink = self.currUser.profileImageLink;
            firRequest.name = self.currUser.name;
            firRequest.facebookId = self.currUser.facebookId;
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            self.functions = [FIRFunctions functions];
            __block FirebaseFuntionResponse *getResponse=nil;
            NSString * link = Fir_CancelAdminForUser;
            
            [[self.functions HTTPSCallableWithName:Fir_CancelAdminForUser] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
             
                NSString *stringReply = (NSString *)result.data;

                getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([getResponse.status isEqualToString:@"OK"]) {
                        self.currUser.roomUserType = @"USER";
                        if ([self.currUser.roomUserType isEqualToString:@"ADMIN"]) {
                            if (self.isFamilyRoom){
                                self.menuLabel1.text = AMLocalizedString(@"Chọn làm Tộc phó", nil);
                            }else
                            self.menuLabel1.text = AMLocalizedString(@"Chọn làm quản trị viên", nil);
                        }
                    }else{
                            [[[[iToast makeText:getResponse.message]
                            setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                    }
                    [self.view removeFromSuperview];
                   /// [self dismissViewControllerAnimated:YES completion:nil];
                });

            }];
            }
            
        });
    }else {
     dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
     dispatch_async(queue, ^{
         if (self.isFamilyRoom){
             PromotedResponse *getResponse =  [[LoadData2 alloc] familyPromoted:self.currUser.facebookId];
             if (getResponse.status.length==2){
                 self.currUser.roomUserType = @"ADMIN";
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
                 [[[[iToast makeText:getResponse.message]
                    setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                 
                 [self.view removeFromSuperview];
                 //[self dismissViewControllerAnimated:YES completion:nil];
             });
         }else {
         SetAdminForUserRequest *firRequest = [SetAdminForUserRequest new];
         firRequest.userActionId = currentFbUser.facebookId;
         firRequest.roomId = liveRoomID;
         firRequest.profileImageLink = self.currUser.profileImageLink;
         firRequest.name = self.currUser.name;
         firRequest.facebookId = self.currUser.facebookId;
         NSString * requestString = [[firRequest toJSONString] base64EncodedString];
         self.functions = [FIRFunctions functions];
         __block FirebaseFuntionResponse *getResponse=nil;
         [[self.functions HTTPSCallableWithName:Fir_SetAdminForUser] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
          
             NSString *stringReply = (NSString *)result.data;

             getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
             dispatch_async(dispatch_get_main_queue(), ^{

                 if ([getResponse.status isEqualToString:@"OK"]) {
                     self.currUser.roomUserType = @"ADMIN";
                     if ([self.currUser.roomUserType isEqualToString:@"ADMIN"]) {
                         if (self.isFamilyRoom){
                             self.menuLabel1.text = AMLocalizedString(@"Hủy Tộc phó", nil);
                         }else
                         self.menuLabel1.text = AMLocalizedString(@"Hủy quản trị viên", nil);
                     }
                 }else{
                         [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                 }
                 [self.view removeFromSuperview];
                 // [self dismissViewControllerAnimated:YES completion:nil];
             });

         }];
         }
        
     });
    }
}
- (IBAction)block:(id)sender {
	 self.loading.hidden = NO;
	 [UIView animateWithDuration: 0.5f animations:^{
		  self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-100;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){



	 }];
    if ([self.currUser.roomUserType isEqualToString:@"BLOCK"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
          
            UnblockUserRequest *firRequest = [UnblockUserRequest new];
            firRequest.userActionId = currentFbUser.facebookId;
            firRequest.roomId = liveRoomID;
            firRequest.profileImageLink = self.currUser.profileImageLink;
            firRequest.name = self.currUser.name;
            firRequest.facebookId = self.currUser.facebookId;
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            self.functions = [FIRFunctions functions];
          
            __block FirebaseFuntionResponse *getResponse=nil;
            [[self.functions HTTPSCallableWithName:Fir_UnblockUser] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
              
                NSString *stringReply = (NSString *)result.data;

                getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{


                            [[[[iToast makeText:getResponse.message]
                            setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                    [self.view removeFromSuperview];
                   // [self dismissViewControllerAnimated:YES completion:nil];
                });

            }];

            
        });
    }else {
     dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
     dispatch_async(queue, ^{
         BlockUserRequest *firRequest = [BlockUserRequest new];
         firRequest.userActionId = currentFbUser.facebookId;
         firRequest.roomId = liveRoomID;
         firRequest.profileImageLink = self.currUser.profileImageLink;
         firRequest.name = self.currUser.name;
         firRequest.facebookId = self.currUser.facebookId;
         NSString * requestString = [[firRequest toJSONString] base64EncodedString];
         self.functions = [FIRFunctions functions];
         __block FirebaseFuntionResponse *getResponse=nil;
         [[self.functions HTTPSCallableWithName:Fir_BlockUser] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
         
             NSString *stringReply = (NSString *)result.data;

             getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
             dispatch_async(dispatch_get_main_queue(), ^{


                         [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                 [self.view removeFromSuperview];
                  //[self dismissViewControllerAnimated:YES completion:nil];
             });

         }];
        
     });
    }
}
- (IBAction)blockComment:(id)sender {
	 self.loading.hidden = NO;
	 [UIView animateWithDuration: 0.5f animations:^{
		  self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-100;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){



	 }];
    if ([self.currUser.roomUserType isEqualToString:@"ADMIN"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            UnblockCommentRequest *firRequest = [UnblockCommentRequest new];
            firRequest.userActionId = currentFbUser.facebookId;
            firRequest.roomId = liveRoomID;
            firRequest.profileImageLink = self.currUser.profileImageLink;
            firRequest.name = self.currUser.name;
            firRequest.facebookId = self.currUser.facebookId;
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            self.functions = [FIRFunctions functions];
            __block FirebaseFuntionResponse *getResponse=nil;
            [[self.functions HTTPSCallableWithName:Fir_UnblockComment] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
            
                NSString *stringReply = (NSString *)result.data;

                getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{


                            [[[[iToast makeText:getResponse.message]
                            setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                    [self.view removeFromSuperview];
                   // [self dismissViewControllerAnimated:YES completion:nil];
                });

            }];
           
        });
    }else {
     dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
     dispatch_async(queue, ^{
        
         BlockCommentRequest *firRequest = [BlockCommentRequest new];
         firRequest.userActionId = currentFbUser.facebookId;
         firRequest.roomId = liveRoomID;
         firRequest.profileImageLink = self.currUser.profileImageLink;
         firRequest.name = self.currUser.name;
         firRequest.facebookId = self.currUser.facebookId;
         NSString * requestString = [[firRequest toJSONString] base64EncodedString];
         self.functions = [FIRFunctions functions];
         __block FirebaseFuntionResponse *getResponse=nil;
         [[self.functions HTTPSCallableWithName:Fir_BlockComment] callWithObject:@{@"parameters":requestString}
                                                               completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
           
             NSString *stringReply = (NSString *)result.data;

             getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
             dispatch_async(dispatch_get_main_queue(), ^{


                         [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

                 [self.view removeFromSuperview];
                  //[self dismissViewControllerAnimated:YES completion:nil];
             });

         }];

        
     });
    }
}
- (IBAction)privateChat:(id)sender {
    /*PrivateMessageViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"TinNhanRiengView"];// [PrivateMessageViewController messagesViewController];
    if (![currentFbUser.facebookId isKindOfClass:[NSString class]]) {
        User *sendUser=[User new];
        sendUser.facebookId=[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
        sendUser.profileImageLink=[[NSUserDefaults standardUserDefaults] objectForKey:@"profileImageLink"];
        sendUser.name=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        vc.sendUser=sendUser;
    }else
    vc.sendUser=currentFbUser;
	 vc.receiveUser=self.currUser;*/
   // [self dismissViewControllerAnimated:NO completion:^{
    [self.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"replyCommentLive" object:self.currUser];
    //}];
}
- (IBAction)followPress:(id)sender {
    if (![self.currUser.friendStatus isEqualToString:@"FRIEND"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            AddFriendResponse*res=   [[LoadData2 alloc] AddFriend:self.currUser.facebookId];
            self.currUser.friendStatus=res.status;
            if (res.status.length==2){
                User *userF = self.currUser;
                [allFollowingUsers addObject:userF];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.currUser.friendStatus isEqualToString:@"FRIEND"]) {

                    self.followLabel.text=AMLocalizedString(@"Bỏ theo dõi", nil);
                }else{

                    self.followLabel.text=AMLocalizedString(@"Theo dõi", nil);

                }
            });
        });
    }else{

        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            RemoveFriendResponse*res=   [[LoadData2 alloc] RemoveFriend: self.currUser.facebookId];
            self.currUser.friendStatus=res.status;

            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.currUser.friendStatus isEqualToString:@"FRIEND"]) {

                    self.followLabel.text=AMLocalizedString(@"Bỏ theo dõi", nil);
                }else{

                    self.followLabel.text=AMLocalizedString(@"Theo dõi", nil);

                }
            });
        });
    }
}
- (IBAction)hideMenu:(id)sender {

    [UIView animateWithDuration: 0.5f animations:^{
        self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-100;

		   [self.view layoutIfNeeded];
    } completion:^(BOOL finish){

        [self.view removeFromSuperview];
       // [self dismissViewControllerAnimated:NO completion:nil];
    }];

}
- (void) loadUser{
    @autoreleasepool {
        if ([self.currUser.facebookId isEqualToString:currentFbUser.facebookId]) {
             dispatch_async(dispatch_get_main_queue(), ^{
				  self.loading.hidden = YES;
            [UIView animateWithDuration: 0.3f animations:^{
				 self.menuMessageHeightConstrainst.constant = 100;
				 self.menuHeightConstraint.constant = 0;
				 self.menuForOwnerHeightConstraint.constant = 0;
				 self.menuMessageView.hidden = YES;
                    self.subViewBottomContrainst.constant = 0;
				  self.menuForAdminView.hidden = YES;
				  [self.view layoutIfNeeded];
                } completion:^(BOOL finish){
                    self.subViewBottomContrainst.constant = 0;

                }];
            });
        }else {
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

               dispatch_async(queue, ^{

               


        dispatch_async(dispatch_get_main_queue(), ^{
			 self.loading.hidden = YES;

			 if ([currentFbUser.roomUserType isEqualToString:@"OWNER"]) {
                self.menuMessageHeightConstrainst.constant = 40;
                self.menuHeightConstraint.constant = 220;
                self.menuForOwnerHeightConstraint.constant = 40;
				 self.menuEditRecordingView.hidden = NO;
				 self.menuForAdminView.hidden = NO;
				  self.menuForAdminHeightConstrainst.constant = 80;
                if ([self.currUser.roomUserType isEqualToString:@"ADMIN"]) {
                    if (self.isFamilyRoom){
                        self.menuLabel2.text = AMLocalizedString(@"Hủy Thành viên", nil);
                        self.menuLabel1.text = AMLocalizedString(@"Hủy Tộc phó", nil);
                    }else
                    self.menuLabel1.text = AMLocalizedString(@"Hủy làm Quản trị viên", nil);
                }else
                
                if ([self.currUser.roomUserType isEqualToString:@"VIP"]) {
                    if (self.isFamilyRoom){
                        self.menuLabel2.text = AMLocalizedString(@"Hủy Thành viên", nil);
                    }else
                    self.menuLabel2.text = AMLocalizedString(@"Hủy làm Khách VIP", nil);
                }

                if ([self.currUser.roomUserType isEqualToString:@"BLOCKCOMMENT"]) {
                    self.menuLabel4.text = AMLocalizedString(@"Hủy cấm phát ngôn", nil);
                }
            }else  if ([self.currUser.roomUserType isEqualToString:@"OWNER"]) {
							 self.menuMessageHeightConstrainst.constant = 40;
							 self.menuHeightConstraint.constant = 100;
							   self.menuEditRecordingView.hidden = YES;
				 self.menuForAdminView.hidden = YES;
						}else
            if ([currentFbUser.roomUserType isEqualToString:@"ADMIN"]) {
                self.menuMessageHeightConstrainst.constant = 40;
                self.menuHeightConstraint.constant = 180;
                self.menuForOwnerHeightConstraint.constant = 40;
				  self.menuEditRecordingView.hidden = NO;
				 self.menuForAdminHeightConstrainst.constant = 40;
				 self.menuForAdminView.hidden = NO;
				 if ([self.currUser.roomUserType isEqualToString:@"VIP"]) {
                     if (self.isFamilyRoom){
                         self.menuLabel2.text = AMLocalizedString(@"Hủy Thành viên", nil);
                     }else
					  self.menuLabel2.text = AMLocalizedString(@"Hủy làm Khách VIP", nil);
				 }
                if ([self.currUser.roomUserType isEqualToString:@"BLOCKCOMMENT"]) {
					 self.
                    self.menuLabel3.text = AMLocalizedString(@"Hủy cấm phát ngôn", nil);
                }
            }else
           {
			   self.menuForAdminView.hidden = YES;
                self.menuMessageHeightConstrainst.constant = 40;
                self.menuHeightConstraint.constant = 100;
				  self.menuEditRecordingView.hidden = YES;

            }



            [UIView animateWithDuration: 0.3f animations:^{
                self.subViewBottomContrainst.constant = -0;
				   [self.view layoutIfNeeded];

            } completion:^(BOOL finish){
                self.subViewBottomContrainst.constant = -0;

            }];
        });
					if (![self.currUser.friendStatus isKindOfClass:[NSString class]]) {
                        GetUserProfileResponse * userProfile = [[LoadData2 alloc] GetUserProfile:currentFbUser.facebookId andOwnFacebookId:self.currUser.facebookId];

					//getRecordOfUser = [[LoadData2 alloc] getRecordings:userInfoRec andProper:getRecordOfUser.cursor andOwnFacebookId:self.currUser.facebookId];
                   if ([userProfile.user isKindOfClass:[User class]])
						self.currUser.friendStatus=userProfile.user.friendStatus;
					}
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if ([self.currUser.friendStatus isEqualToString:@"FRIEND"]) {

                                      self.followLabel.text=AMLocalizedString(@"Bỏ theo dõi", nil);
                                  }else{

                                      self.followLabel.text=AMLocalizedString(@"Theo dõi", nil);

                                  }
                   });
               });
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isFamilyRoom){
        self.menuLabel1.text = AMLocalizedString(@"Chọn làm Tộc phó", nil);
    }else
    self.menuLabel1.text = AMLocalizedString(@"Cài đặt làm Quản trị viên", nil);
    if (self.isFamilyRoom){
        self.menuLabel2.text = AMLocalizedString(@"Mời làm Thành viên", nil);
    }else
    self.menuLabel2.text = AMLocalizedString(@"Cài đặt làm Khách VIP", nil);
    self.menuLabel3.text = AMLocalizedString(@"Chặn tài khoản", nil);
    self.menuLabel4.text = AMLocalizedString(@"Cấm phát ngôn", nil);


       self.menuRecordingThumbnail.layer.cornerRadius=self.menuRecordingThumbnail.frame.size.height/2;
       self.menuRecordingThumbnail.layer.masksToBounds=YES;
       self.menuRecordingView.hidden=NO;
       [self setModalPresentationStyle:UIModalPresentationCustom];
       // Do any additional setup after loading the view.
       self.menuRecordingSongName.text=self.currUser.name;

        self.menuRecordingOwer.text=[NSString stringWithFormat:@"ID %d",[self.currUser.uid intValue] ];
     [self.menuRecordingThumbnail sd_setImageWithURL:[NSURL URLWithString:self.currUser.profileImageLink] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageDelayPlaceholder];

    if ([self.currUser.frameUrl isKindOfClass:[NSString class]]){
        [self.userFrame sd_setImageWithURL:[NSURL URLWithString:self.currUser.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
        self.userFrame.hidden = NO;
    }else {
        self.userFrame.hidden = YES;
    }
    self.userGender.hidden = NO;
    if (![self.currUser.gender isKindOfClass:[NSString class]]) {
        self.userGender.hidden = YES;
    }else
    if ([self.currUser.gender isEqualToString:@"male"] || [self.currUser.gender isEqualToString:@"m"]) {
        self.userGender.image = [UIImage imageNamed:@"Nam_48.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    }else if ([self.currUser.gender isEqualToString:@"female"] || [self.currUser.gender isEqualToString:@"f"]){
        self.userGender.image = [UIImage imageNamed:@"Nu_48.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    }else {
        self.userGender.hidden = YES;
    }
    self.subViewBottomContrainst.constant = -self.menuRecordingSubView.frame.size.height-30;
	 [self loadUser];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{

}
- (IBAction)showUserInfo:(id)sender {
    if ([self.currUser.facebookId isEqualToString:currentFbUser.facebookId]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPerson" object:self.currUser];
   
    }
}
#pragma mark Firebase load
- (void)configureDatabase {

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

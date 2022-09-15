//
//  YokaraSDK.h
//  YokaraSDK
//
//  Created by Admin on 20/06/2022.
//


//
//  PrepareViewController.m
//  YokaraKaraoke
//
//  Created by Admin on 03/06/2022.
//  Copyright © 2022 Nguyen Anh Tuan Vu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark - Delegate functions
@protocol YokaraSDKDelegate <NSObject>
@property (strong, nonatomic) UIViewController *liveViewC;
@optional
- (void) recordFinish:(NSString *)recordingJson;
- (void) recordCancel;
- (void) recordFailWithError:(NSString *)errorString;
- (void)mixingOfflineWithStatus:(NSString *)statusString withProcess:(float)percent ofLocalRecordID:(NSNumber *)localID;
- (void) downloadWithStatus:(NSString *) statusString;
- (void) recordStartProgress:(NSString *)recordingJson;
- (void) recordFinishNotPublic:(NSString *)recordingJson;
- (void) kara_exit:(NSString *)liveRoomJson;
- (void)kara_waiting_song:(NSString *)liveRoomJson withView:(UINavigationController *)topView;
- (void)kara_room_info:(NSString *)liveRoomJson withView:(UINavigationController *)topView;
- (void)showWallet:(NSString *)person  withView:(UINavigationController *)topView;
- (void)showRank:(NSString *)person  withView:(UINavigationController *)topView;
- (void)showPerson:(NSString *)person  withView:(UINavigationController *)topView;
- (void) updatePlayerPositionLive:(NSString *)posString;
@end
@interface YokaraSDK : NSObject{
    
    FIRDatabaseHandle _refHandleF8;
    FIRDatabaseHandle _refHandleF;
    int countLog;
    BOOL isSetUpNoti;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic, weak) id <YokaraSDKDelegate> delegate;
@property (strong ,nonatomic) NSString *recordString;
@property (strong ,nonatomic) NSString *performanceType;
@property (assign ,nonatomic) NSInteger toneOfSong;
- (NSString *) getAllRecordingDB;
- (NSString *) getAllSongDB;
- (UIViewController *)getLiveView;
- (void) updateUser:(NSString *) userString;
- (void) recordSolo:(NSString *) songString;
- (void) recordSoloVIP:(NSString *) songString;
- (void) recordAsk4Duet:(NSString *) songString;
- (void) recordAsk4DuetVIP:(NSString *) songString;
- (void) recordDuet:(NSString *) recordString;
- (void) recordDuetVIP:(NSString *) recordString;
- (void) showEditRecordView:(NSString *) recordString;
- (void) showEditRecordViewVIP:(NSString *) recordString;
- (void) downloadSong:(NSString *) songString;
- (void) downloadRecord:(NSString *) recordString;
+ (NSBundle *) resourceBundle;
- (void) openLiveRoomVIP:(NSString *)liveJson;
- (void) openLiveRoom:(NSString *)liveJson;
- (void) xepluot:(NSNotification *) object;
- (void) sendLocalDBId:(NSNumber *) localId;
@end
extern NSNumber * localRecordId;
NS_ASSUME_NONNULL_END

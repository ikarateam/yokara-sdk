//
//  LiveViewController.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadData2.h"
#import "MyPlayerLayerView.h"
#import "GCDAsyncSocket.h"
#import "CircularQueue.h"
#import "audioEngine.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "RulerVolumeView.h"
#import "MyPlayerLayerView.h"
#import "CircleProgressBar.h"
#import "AACEncoder.h"
#import "AACDecoder.h"
#import "LuckyGiftCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "LuckyGift.h"
#import "DemoTableController.h"
#import <Lottie/Lottie.h>
#import "EmptyListView.h"
@interface LiveViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FPDemoTableControllerDelegate> {
	 BOOL changeNotifi;
    NSMutableArray *listComment;
    NSInteger endListComment;
    FIRDatabaseHandle _refHandle;
    FIRDatabaseHandle _refHandleQueueSongPK;
	 FIRDatabaseHandle _refHandleQueueSong;
	 FIRDatabaseHandle _refHandleQueueSong2;
	  FIRDatabaseHandle _refHandleQueueSong3;
    FIRDatabaseHandle _refHandleStatus;
        FIRDatabaseHandle _refHandleComment;
    FIRDatabaseHandle _refHandleUserOnline;
	  FIRDatabaseHandle _refHandleRemoveUserOnline;
	 FIRDatabaseHandle _refHandleShowTime;
     FIRDatabaseHandle _refHandleMicMC;
    
    FIRDatabaseHandle _refHandleQueueSongB;
    FIRDatabaseHandle _refHandleQueueSongB2;
    FIRDatabaseHandle _refHandleQueueSongB3;
    
    FIRDatabaseHandle _refHandleQueueSongR;
    FIRDatabaseHandle _refHandleQueueSongR2;
    FIRDatabaseHandle _refHandleQueueSongR3;
    
    FIRDatabaseHandle _refHandleQueueSongRS;
    FIRDatabaseHandle _refHandleQueueSongBS;
    FIRDatabaseHandle _refHandlePKStatus;
    RoomComment *comment;
    long demBuffer;
    NSTimer *doNothingStreamTimer;
    BOOL keyboardIsShown;

	 AVPlayer *playerYoutubeVideoTmp;
    long minuteOnline;
    NSMutableArray * listUserOnline;
    BOOL firstLoad;
	 AVPlayerItem *playerItem;
	 BOOL isSeeking;
	 float restoreAfterScrubbingRate;
	 BOOL seekToZeroBeforePlay1;
	 id timeObserver;
		BOOL isTapSlider;
	 NSString *streamName;
	 BOOL streamSVIsConnect;
	 BOOL streamIsPlay;
		NSString * streamSV;
		BOOL playStream;
		BOOL destroyStream;
		union
		{
			short s;
			unsigned char bytes[2];
		}u;
		union
		{
			long long l;
			unsigned char longs[8];
		}kieuL,hashL,sampleAudioL;
		NSTimer *checkReceive;


		NSTimer *checkRingTimer;
		BOOL svPause;
	 long dataHash[15504];
	 NSUInteger hashEffect;
	 long demConnect;
	 
	 NSMutableArray * listRoomQueueSong;
	 int numberGiftToBuy;
	 Gift * selectedGift;
	  DemoTableController *sendGiftNoItemView;
	 NSMutableArray * noItemGiftList;
	 FPPopoverKeyboardResponsiveController *popover;
	 CGFloat _keyboardHeight;

    NSString *backgroundId;
	 BOOL playXong;
    BOOL sendingAudioLiveMC;
	 NSTimer *timerPlayer;
	 BOOL isStartingLive;
	 BOOL isReceiveLive;
	 float maxV;
	 float vocalVolumeLive;
	 float musicVolumeLive;
	 float echoVolumeLive;
    GetFriendsStatusResponse * responeFriendStatus;
	 //change image
	  NSMutableArray * listImage;
	 NSInteger demBglayer;
	 NSTimer * changeBGtimer;

	 NSInteger noUpdateComment;
	 BOOL alertGiaHanShow;
	 BOOL alertEndLiveShow;
	 BOOL alertStopLiveShow;
	 BOOL alertAddMicMCShow;
	 BOOL alertRemoveMicMCShow;
    BOOL alertOutRoom;
    BOOL alertInviteMemberFamily;
    NSString * acceptInviteFromFBId;
	 BOOL onMicMC;
		  audioEngine *audioEngine3;
	 
    User * userMC;
	 NSString *serverLive;
	 long portLive;
    BOOL isSendingMicMC;
    NSMutableArray * tagUserList;
    NSInteger showTagUserView;
    User * userReply;
   
    NSMutableData *dataEncoded;
    NSMutableData *resultDecode;
    BOOL endSong;
    NSMutableArray * queueGifts;
   
    BOOL isFinishLoadTopUserDay;
    BOOL isFinishLoadTopUserWeek;
    BOOL isFinishLoadTopUserMonth;
    NSMutableArray * listTopUserDay;
    NSMutableArray * listTopUserWeek;
    NSMutableArray * listTopUserMonth;
    TopUsersInLiveRoomResponse * topUserResponeD;
    TopUsersInLiveRoomResponse * topUserResponeW;
    TopUsersInLiveRoomResponse * topUserResponeM;
    NSThread *threadDecodeAudio;
    NSThread *threadEncodeAudio;
    unsigned char byte_arrSend[3] ;
    unsigned char byte_arrS[8] ;
    unsigned char encodedDataD[400];
    BOOL isSeekPlayer;
    
    Song * userPKRed;
    Song * userPKBlued;
    User * userPKRedScore;
    User * userPKBluedScore;
    User * userPKSelected;
    NSMutableArray * redTeam;
    NSMutableArray * blueTeam;
    NSString *pkStatus;
    BOOL isFirstNotEndPK;
    NSString * urlVideoMp4;
    
    LuckyGift *selectedLuckyGift;
    GetLuckyGiftsHistoryResponse *luckyGiftHistory ;
    GetAllLuckyGiftsGaveResponse *allLuckyGiftsGave ;
    long  luckyGiftGaveID;
    bool showTakeLG;
    TakeLuckyGiftResponse *takeLGRespone ;
    NSString * luckyGiftGaveUserID;
}
#pragma mark PK

@property (weak, nonatomic) IBOutlet UILabel *gaveLGInfoStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *takeLGLoading;
@property (weak, nonatomic) IBOutlet UIButton *takeLGInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *takeLGUserFollowButton;
@property (weak, nonatomic) IBOutlet UILabel *takeLGHadSend;
@property (weak, nonatomic) IBOutlet UIButton *haveLGButton;
@property (weak, nonatomic) IBOutlet UIButton *sendLGSendButton;
@property (weak, nonatomic) IBOutlet UIPageControl *sendLGPageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *sendLGCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *gaveLGInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *gaveLGInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *takeLGFirstFollow;
@property (weak, nonatomic) IBOutlet UIButton *takeLGFirstButton;
@property (weak, nonatomic) IBOutlet UIImageView *takeLGFirstUser;
@property (weak, nonatomic) IBOutlet UILabel *takeLGFirstEmptyNotice;
@property (weak, nonatomic) IBOutlet UILabel *takeLGFirstTitle;
@property (weak, nonatomic) IBOutlet UIView *takeLuckyFirstView;
@property (weak, nonatomic) IBOutlet UILabel *takeLGNoGift;
@property (weak, nonatomic) IBOutlet UIImageView *takeLGGiftImage;
@property (weak, nonatomic) IBOutlet UILabel *takeLGStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeLGEmptyLabel;
@property (weak, nonatomic) IBOutlet UITableView *takeLGTableView;
@property (weak, nonatomic) IBOutlet UILabel *takeLGTitle;
@property (weak, nonatomic) IBOutlet UIView *takeLuckyGiftView;
@property (weak, nonatomic) IBOutlet UIView *sendLuckyGiftView;
@property (weak, nonatomic) IBOutlet UIView *gaveLuckyGiftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoNameLabelLeftContrainst;
@property (weak, nonatomic) IBOutlet UIImageView *pkStartUserIconR;
@property (weak, nonatomic) IBOutlet UIImageView *pkStartUserIconL;
@property (weak, nonatomic) IBOutlet UILabel *pkStartUserNameL;
@property (weak, nonatomic) IBOutlet UILabel *pkStartUserNameR;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameR1;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameR2;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameR3;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameL3;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameL2;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFrameL1;
@property (weak, nonatomic) IBOutlet UILabel *pkResultUserNameR;
@property (weak, nonatomic) IBOutlet UILabel *pkResultUserNameL;
@property (weak, nonatomic) IBOutlet UILabel *pkResultScoreR;
@property (weak, nonatomic) IBOutlet UILabel *pkResultScoreL;
@property (weak, nonatomic) IBOutlet UIImageView *beatInfoImageBG;
@property (weak, nonatomic) IBOutlet UIView *userSingDuetView;
@property (weak, nonatomic) IBOutlet UIView *pkStartViewBGLeft;
@property (weak, nonatomic) IBOutlet UIView *pkStartViewBGRight;
@property (weak, nonatomic) IBOutlet UIView *beatInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *ic_userPKSingingRight;
@property (weak, nonatomic) IBOutlet UIImageView *ic_userPKSingingLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerViewBottomConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatInfoImageCenterYContrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatInfoImageWidthConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewTopConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftViewInfoTopConstrainst;
@property (weak, nonatomic) IBOutlet UIView *pkSelectUserView;
@property (weak, nonatomic) IBOutlet UIView *pkSelectUserSubView;
@property (weak, nonatomic) IBOutlet UILabel *pkSelectUserTitle;
@property (weak, nonatomic) IBOutlet UILabel *pkSelectUserLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *pkSelectUserRightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pkSelectUserLeftImage;
@property (weak, nonatomic) IBOutlet UIImageView *pkSelectUserRightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkSelectUserViewBottomConstrainst;
@property (weak, nonatomic) IBOutlet UIView *pkGiftSubView;
@property (weak, nonatomic) IBOutlet UIView *pkGiftUserView;
@property (weak, nonatomic) IBOutlet UIImageView *pkGiftUserImage;
@property (weak, nonatomic) IBOutlet UILabel *pkGiftUserNameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkBattleViewBottomConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkBattleFireImageConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkBattleRulerRedWidthContrainst;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleFireImage;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleRulerRedImage;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleRulerBlueImage;
@property (weak, nonatomic) IBOutlet UIView *pkStartView;
@property (weak, nonatomic) IBOutlet UIImageView *pkStartUserL;
@property (weak, nonatomic) IBOutlet UIImageView *pkStartUserR;
@property (weak, nonatomic) IBOutlet UIImageView *pkStartButtonImage;

@property (weak, nonatomic) IBOutlet UIView *pkResultView;
@property (weak, nonatomic) IBOutlet UIView *pkResultSubView;
@property (weak, nonatomic) IBOutlet UIImageView *pkResultIconL;
@property (weak, nonatomic) IBOutlet UIImageView *pkResultIconR;
@property (weak, nonatomic) IBOutlet UIImageView *pkResultUserL;
@property (weak, nonatomic) IBOutlet UIImageView *pkResultUserR;
@property (weak, nonatomic) IBOutlet UIButton *pkResultFollowButtonR;
@property (weak, nonatomic) IBOutlet UIButton *pkResultFollowButtonL;
@property (weak, nonatomic) IBOutlet UILabel *pkResultScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *pkBattleView;
@property (weak, nonatomic) IBOutlet UIView *pkBattleUserView;
@property (weak, nonatomic) IBOutlet UIView *pkBattleScoreView;
@property (weak, nonatomic) IBOutlet UILabel *pkBattleScoreL;
@property (weak, nonatomic) IBOutlet UILabel *pkBattleScoreR;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserL;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserR;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserLTop1;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserLTop2;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserLTop3;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserRTop1;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserRTop3;
@property (weak, nonatomic) IBOutlet UIImageView *pkBattleUserRTop2;

@property (weak, nonatomic) IBOutlet UIImageView *userSingFrame;
@property (nonatomic, strong)EmptyListView *emptyView;
@property (weak, nonatomic) IBOutlet UIScrollView *topUserScrollView;
@property (weak, nonatomic) IBOutlet UIView *topUserView;
@property (weak, nonatomic) IBOutlet UIView *topUserSubView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topUserSegment;
@property (weak, nonatomic) IBOutlet UITableView *topUserDayTableView;
@property (weak, nonatomic) IBOutlet UITableView *topUserWeekTableView;
@property (weak, nonatomic) IBOutlet UITableView *topUserMonthTabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topUserViewBottomContrainst;
@property (weak, nonatomic) IBOutlet UILabel *userSingDuetName;



- (void) deallocLive ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMenuSubViewContrainst;
@property (weak, nonatomic) IBOutlet UIView *menuSubView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *giftBuyComboButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftBuyComboViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *giftBuyNoComboLabel;
@property (strong, nonatomic) IBOutlet CircleProgressBar *giftBuyComboTimeProcess;
@property (weak, nonatomic) IBOutlet UIView *giftBuyComboView;
@property (weak, nonatomic) IBOutlet UIView *giftExpView;
@property (weak, nonatomic) IBOutlet UIView *giftBuyView;
@property (weak, nonatomic) IBOutlet UIImageView *giftAnimationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *giftViewInfoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagUserTableViewHeightConstrainst;
@property (weak, nonatomic) IBOutlet UITableView *tagUserTableView;
@property (weak, nonatomic) IBOutlet UIView *micMCRecordingView;
@property (weak, nonatomic) IBOutlet UIImageView *micMCRecordingImage;
@property (weak, nonatomic) IBOutlet UIButton *btnMicMCRecord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btShareLeftConstrainst;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *liveAlertHeightConstrainst;
@property (weak, nonatomic) IBOutlet UIView *MicMCView;
@property (weak, nonatomic) IBOutlet UIImageView *micMCImage;
@property (weak, nonatomic) IBOutlet UILabel *micMCLabel;
@property (weak, nonatomic) IBOutlet UIButton *micMCButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconGiftLive;



@property(strong, nonatomic) FIRFunctions *functions;
@property (weak, nonatomic) IBOutlet UIView *roomInfoView;
@property (strong, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *roomShowTimeHeadsetLabel;
@property (strong, nonatomic) LOTAnimationView * liveAnimation;
@property (strong, nonatomic) LOTAnimationView * micMCAnimation;
@property (strong, nonatomic) LOTAnimationView * pkBattleUserLeftSingAnimation;
@property (strong, nonatomic) LOTAnimationView * pkBattleUserRightSingAnimation;
@property (strong, nonatomic) NSMutableArray * listFriendStatusTmp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmtTableViewTopConstrainst;
@property (weak, nonatomic) IBOutlet UILabel *passNoticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *passLabel4;
@property (weak, nonatomic) IBOutlet UITextField *passLabel3;
@property (weak, nonatomic) IBOutlet UITextField *passLabel2;
@property (weak, nonatomic) IBOutlet UITextField *passLabel1;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *passwordSubView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *startStreamLoading;
@property (weak, nonatomic) IBOutlet UIImageView *liveAlertIcon;
@property (weak, nonatomic) IBOutlet UILabel *liveAlertContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveAlertTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *liveAlertNoButton;
@property (weak, nonatomic) IBOutlet UIButton *liveAlertYesButton;
@property (weak, nonatomic) IBOutlet UIView *liveAlertSubView;
@property (weak, nonatomic) IBOutlet UIView *liveAlertView;
@property (weak, nonatomic) IBOutlet UIImageView *BeatInfoImageView;
@property  (weak, nonatomic)  IBOutlet UIView *volumeVocal100Mark;
@property  (weak, nonatomic)  IBOutlet UIView *volumeMusic100Mark;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolume100Mark;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolumMaxView;
@property  (weak, nonatomic)  IBOutlet RulerVolumeView *rulerVolumeV;
@property  (weak, nonatomic)  IBOutlet UIImageView *rulerVolumeImage;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolumeView;
@property (weak, nonatomic) IBOutlet UILabel *volumeMusicLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeVocalLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeEchoLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeVocal;
@property (weak, nonatomic) IBOutlet UISlider *volumeMusic;
@property (weak, nonatomic) IBOutlet UISlider *volumeEcho;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveVolumeMenuSubBottomConstrainst;
@property (weak, nonatomic) IBOutlet UIView *liveVolumeMenuSubView;
@property (weak, nonatomic) IBOutlet UIView *liveVolumeMenuView;
@property (weak, nonatomic) IBOutlet UIView *menuToolBarView;
- (void) stopLive ;
@property (weak, nonatomic) IBOutlet MyPlayerLayerView *playerLayerView;
@property (weak, nonatomic) IBOutlet UILabel *roomShowTimeTimerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roomShowTimeIcon;
@property (weak, nonatomic) IBOutlet UIButton *roomShowTimeCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *roomShowTimeStartButton;
@property (weak, nonatomic) IBOutlet UIView *roomShowTimeView;
@property (weak, nonatomic) IBOutlet UIView *roomShowTimeSubView;
- (void) startLive ;
- (void) decodeAudioAAC:(NSData *)frame withPts:(SInt64)pts;
@property (weak, nonatomic) IBOutlet UIView *startLiveView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIView *prepareRoomLoadingView;
@property (weak, nonatomic) IBOutlet UILabel *prepareRoomLoadingViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftViewLevelExpLabel;

@property (weak, nonatomic) IBOutlet UIButton *giftViewLevelButton;
@property (weak, nonatomic) IBOutlet UIProgressView *giftViewLvProcess;
@property (weak, nonatomic) IBOutlet UILabel *giftViewLevelLabel;
@property  (weak, nonatomic)  IBOutlet UICollectionView *giftStoreViewCollectionView;
@property  (weak, nonatomic)  IBOutlet UILabel *giftStoreViewTotalIcoin;
@property  (weak, nonatomic)  IBOutlet UIPageControl *giftStoreViewPageControl;
@property  (weak, nonatomic)  IBOutlet UIButton *giftStoreViewBuyButton;
@property  (weak, nonatomic)  IBOutlet UILabel *giftStoreViewNoItemBuy;
@property (weak, nonatomic) IBOutlet UIView *giftStoreViewLoading;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UITableView *queueSongTableView;
@property (weak, nonatomic) IBOutlet UIView *queueSongView;
@property (strong, nonatomic)  GCDAsyncSocket *socket;
@property  (weak, nonatomic)  IBOutlet UILabel *durationLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *timeplay;
@property  (weak, nonatomic)  IBOutlet UIProgressView *progressBuffer;
@property  (weak, nonatomic)  IBOutlet UIButton *playButt;
@property  (weak, nonatomic)  IBOutlet UIButton *pauseBtt;
@property  (weak, nonatomic)  IBOutlet UISlider *movieTimeControl;
@property  (weak, nonatomic)  IBOutlet UIActivityIndicatorView *isLoading;

@property (weak, nonatomic) IBOutlet UIView *UserSingingInfoView;
@property (weak, nonatomic) IBOutlet UIView *giftViewInfo;
@property (weak, nonatomic) IBOutlet UILabel *noGiftLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *noUserOnline;
@property (weak, nonatomic) IBOutlet UIView *noUserOnlineView;
@property (weak, nonatomic) IBOutlet UILabel *notifiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noBodyImage;
@property (weak, nonatomic) IBOutlet UIView *noBodySing;
////////
@property (weak, nonatomic) IBOutlet UILabel *statusNogiftLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewGiftIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewUserType2;
@property (weak, nonatomic) IBOutlet UILabel *statusViewUserNameLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewLeftConstrainst2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewBottomConstrainst2;
@property (weak, nonatomic) IBOutlet UIImageView *statusUserProfileImage2;
@property (weak, nonatomic) IBOutlet UIView *statusView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewUserNameTopConstraint2;
@property (weak, nonatomic) IBOutlet UIView *giftSubView;

@property (weak, nonatomic) IBOutlet UILabel *statusNogiftLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewGiftIcon3;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewUserType3;
@property (weak, nonatomic) IBOutlet UILabel *statusViewUserNameLabel3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewLeftConstrainst3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewBottomConstrainst3;
@property (weak, nonatomic) IBOutlet UIImageView *statusUserProfileImage3;
@property (weak, nonatomic) IBOutlet UIView *statusView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewUserNameTopConstraint3;
///
@property (weak, nonatomic) IBOutlet UILabel *statusNogiftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewGiftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewUserType;
@property (weak, nonatomic) IBOutlet UILabel *statusViewUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *notifiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewLeftConstrainst;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UIView *statusSubView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewUserNameTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *statusSubView1;
@property (weak, nonatomic) IBOutlet UIView *statusSubView2;
@property (weak, nonatomic) IBOutlet UIImageView *statusUserProfileImage;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *UserInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderUserImage;
@property (weak, nonatomic) IBOutlet UILabel *noUserOnlineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineSubViewLeftConstraint;
@property (weak, nonatomic) IBOutlet UITableView *userOnlineTableView;
@property (weak, nonatomic) IBOutlet UIView *userOnlineSubView;
@property (weak, nonatomic) IBOutlet UICollectionView *userOnlineCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmtToolbarViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmtViewBottomConstrainst;
@property (weak, nonatomic) IBOutlet UIView *cmtToolBarView;
@property (weak, nonatomic) IBOutlet UIView *cmtView;
@property (weak, nonatomic) IBOutlet UIView *cmtNotifyView;
@property (weak, nonatomic) IBOutlet UILabel *cmtNotifyLabel;
@property (weak, nonatomic) IBOutlet UIButton *cmtViewSendButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cmtViewProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *commentTextFieldToolbar;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) LiveRoom * liveroom;
@property (weak, nonatomic) IBOutlet UIView *playerToolbar;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *statusAndCommentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextFieldLeftConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewBottomConstrainst;
@property (weak, nonatomic) IBOutlet UIImageView *iconClock;
@property (weak, nonatomic) IBOutlet UIButton *buttonGift;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (strong, nonatomic) IBOutlet UILabel *lbInviteSing;
@property (weak, nonatomic) IBOutlet UIButton *buttonSing;
@property (strong, nonatomic) IBOutlet UIButton *btSmall;
@property (strong, nonatomic) IBOutlet UIButton *btInforRoom;
@property (strong, nonatomic) IBOutlet UILabel *lbCollor;

@end
static void *MyLiveStreamingMovieViewControllerPlayerItemStatusObserverContext4 = &MyLiveStreamingMovieViewControllerPlayerItemStatusObserverContext4;
static void *PlayLiveStreamViewControllerPlayerItemStatusObserverContext = &PlayLiveStreamViewControllerPlayerItemStatusObserverContext;
static void *PlayLiveStreamViewControllerPlayerItemRateObserverContext = &PlayLiveStreamViewControllerPlayerItemRateObserverContext;
extern Song *userSinging;
extern Song *userShowTime;
extern  int demTimeHideRoomShowTime;
extern NSString *liveRoomID;
extern CircularQueue *ringBufferData;
extern AVAudioPlayerNode *playerNode;
extern AVAudioEngine *engine;
extern AACEncoder * encoder;
extern AACDecoder * decoder;
extern AACDecoder * decoder2;
  //them
extern RoomStatus *currentStatusAnimate;
extern RoomStatus *currentStatus1;
extern RoomStatus *currentStatus2;
extern RoomStatus *currentStatus3;
extern UIViewPropertyAnimator * animator1;
extern UIViewPropertyAnimator * animator2;
extern UIViewPropertyAnimator * animator3;

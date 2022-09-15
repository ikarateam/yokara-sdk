//
//  PrepareRecordViewController.h
//  Yokara
//
//  Created by APPLE on 1/25/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LoadData2.h"
//#import "StreamingMovieViewController.h"
#import "LocalizationSystem.h"
#import "SGdownloader.h"
#import <Constant.h>
#import "ToggleView.h"
#import <SCRecorder/SCRecorder.h>
#import "AVCamPreviewView.h"
#import "User.h"
@interface PrepareRecordViewController : UIViewController<SGdownloaderDelegate,ToggleViewDelegate,SCRecorderDelegate,SCSwipeableFilterViewDelegate> {
    BOOL isEnableBeauty;
    SCRecorder *recorder;
     UIAlertView * alertOpenSetting;
    BOOL canChangeCamera;
    NSTimer *waitTimer;
    double waitTime;
    NSInteger widthStartbutton;
    CGRect frame2;
    int demTimeTone;
    BOOL demTimeToneLan2;
    NSTimer * demToneTimer;
    BOOL VideoRecord;
    BOOL initCamera;
    SCSwipeableFilterView *filterView;
    SCFilter *currentFilter;
    NSMutableArray * filterNames;
    NSString * filterName;
}
@property (weak, nonatomic) IBOutlet UIImageView *thumnailImageFrame;
@property  (weak, nonatomic)  IBOutlet UIView *backView;
@property (assign, nonatomic) AVCaptureDevicePosition deviceCamera;
@property  (weak, nonatomic)  IBOutlet UIButton *beautyButton;
@property  (weak, nonatomic)  IBOutlet UIView *tipChangeEffectVideoView;
@property  (weak, nonatomic)  IBOutlet UILabel *filterLabel;
@property  (weak, nonatomic)  IBOutlet UIButton *cameraButton;
@property  (weak, nonatomic)  IBOutlet UIView *OnOffCameraView;
@property(nonatomic, strong)ToggleView *toggleViewButtonChange;
@property  (weak, nonatomic)  IBOutlet UIView *headphoneWarningView;
@property  (weak, nonatomic)  IBOutlet UIButton *headphoneWarningOkButton;
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property  (weak, nonatomic)  IBOutlet UIButton *StartButton2;
@property  (weak, nonatomic)  IBOutlet UIButton *closeButton;
@property  (weak, nonatomic)  IBOutlet UIView *audioView;
@property  (weak, nonatomic)  IBOutlet UILabel *statusLabel2;
@property  (weak, nonatomic)  IBOutlet UIImageView *thumnailImage;
@property  (weak, nonatomic)  IBOutlet UILabel *statusLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *TatLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *MoLabel;
@property  (weak, nonatomic)  IBOutlet UIButton *startButton;
@property  (weak, nonatomic)  IBOutlet UIProgressView *processDownloadSong;
@property  (weak, nonatomic)  IBOutlet UIActivityIndicatorView *waitTimeLoading;
@property (nonatomic, strong) SGdownloader* download;
@property  (weak, nonatomic)  IBOutlet UIView *waitStatusView;
@property (strong ,nonatomic) Lyric * lyricForDuet;
@property (strong ,nonatomic) NSString * performanceType;
@property  (weak, nonatomic)  IBOutlet UILabel *waitTimeLabel;
@property (strong ,nonatomic) Song *song;
@property  (weak, nonatomic)  IBOutlet UILabel *StatusWaitLabel;
@property (strong ,nonatomic) Recording *recording;
@property (assign, nonatomic) NSInteger toneOfSong;
@property  (weak, nonatomic)  IBOutlet UILabel *songName;
@property  (weak, nonatomic)  IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UILabel *backViewlabel;
@property  (weak, nonatomic)  IBOutlet AVCamPreviewView *previewLayer;
@property  (weak, nonatomic)  IBOutlet UIView *toolBarView;
@property  (weak, nonatomic)  IBOutlet UIView *infoView;
@property (strong ,nonatomic) CAGradientLayer *gradient;
@property (strong ,nonatomic) CAGradientLayer *gradient2;
@property  (weak, nonatomic)  IBOutlet UISwitch *selectRecordButton;
@property (weak, nonatomic) IBOutlet UILabel *headphoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipChangeEffectLabel;
@property (weak, nonatomic) IBOutlet UIView *headphoneSubView;

@property (weak, nonatomic) IBOutlet UILabel *headphoneDesLabel;
@property (strong,nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDeviceInput *videoDeviceInput;
@property (strong,nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (strong,nonatomic) id runtimeErrorHandlingObserver;

@end
extern BOOL resetRecord;

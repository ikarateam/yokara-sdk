/*
    

*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MyPlayerLayerView.h"
#import "KaraokeDisplay.h"
#import "CSLinearLayoutView.h"
#import "AVCamPreviewView.h"
#import "FPPopoverController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "DuetLyricView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SCRecorder/SCRecorder.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EffectCollectionViewCell.h"
#import "LoadData2.h"
#import <Constant.h>
#import "AlertViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <ImageIO/ImageIO.h>
#import "Effect.h"
#import "DemoTableController.h"
#import "Paint.h"
//#import "UploadRecordingViewController.h"
#import "YTPlayerView.h"
#import "CRRulerControl.h"
#import "audioEngine.h"
#import "RulerVolumeView.h"
#import "CircularQueue.h"
#import "GCDAsyncSocket.h"
#import "GetBpmAndKeySongResponse.h"
#import "ExtendedAudioFileConvertOperation.h"
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@class Recording;
//@class RecorderController;
@class GetSongResponse;
@protocol Line;
@class AVPlayer;
@class AVPlayerItem;
@class AEAudioController;

@class CircularProgressView;
@interface StreamingMovieViewController : UIViewController <AVCaptureFileOutputRecordingDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SCAssetExportSessionDelegate,alertViewDelegate,FPDemoTableControllerDelegate,YTPlayerViewDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,SCRecorderDelegate> {
    SCAssetExportSession* assetExportSession;
    AVAssetExportSession * assetExportSessionNoEffect;
    float maxV;
    UIImage *meSingThumbImage;
    UIImage *otherSingThumbImage;
    UIImage *duetSingThumbImage;
    UIColor *genderColor;
    long offsetPositionStream;
    long timeCodeStream;
    NSString *streamName;
    bool alerReRecordIsShow;
   // AVCaptureVideoDataOutput    *captureAudioDataOutput;
    UIInterfaceOrientation orientationLast, orientationAfterProcess;
    CMMotionManager *motionManager;
    CGFloat _keyboardHeight;
    FPPopoverKeyboardResponsiveController *popover;
    NSURL *movieURL;
	BOOL isDownload;
    BOOL hasObser;
    BOOL hasObser2;
    BOOL hasObser3;
	BOOL isObser;
    BOOL startRecord;
    BOOL configVideoRecord;
   // IBOutlet RecorderController *recoder;
	StreamingMovieViewController* myself;
	BOOL isSeeking;
    BOOL streamIsPlay;
	float restoreAfterScrubbingRate;
    NSTimer *changeBackground;
    NSTimer *checkPlaying;
    id timeObserver;
	id timeObserver2;
    UIAlertView * alertOpenSetting;
    UIAlertView *alert;
    UIAlertView *alertChangePlayList;
    UIAlertView * alertReRecord;
	NSArray *adList;
       NSString *urlSong;
     AVPlayerItem *playerItem;
    AVPlayerItem *playerItem2;
    AVPlayerItem *playerItem3;
    AVPlayerItem *playerItem4;
    NSInteger xulyViewMenuSelected;
    CSLinearLayoutView *karaokeDisplayElement;
    NSArray * videoQualityList;
    BOOL canChangeCamera;
    BOOL audioEnd;
    BOOL isTapSlider;
    NSTimer * demMarkTimer;
    NSInteger *mark;
    NSInteger * demMark;
    BOOL cancelAutoPlaylist;
     UIAlertView *alertNangCapVIP;
    BOOL layerRecordIsFullscreen;
   // AVAudioRecorder* recorder;
    NSMutableArray *listEffect;
    SCSwipeableFilterView *filterView;
    Effect * currentEffect;
    
     UIAlertView *alertHuyUpload;
      UIAlertView *alertHuyEditRecord;
    UIAlertView *alertDeleteRecord;
    CGRect frameNotFull;
    BOOL cancelUpload;
     BOOL privacyRecordingisPrivate;
    audioEngine *audioEngine2;
    BOOL recordWithBluetooth;
    AVAudioRecorder *recordBluetooth;
    NSInteger startRecordDem;
    BOOL duetYouIsFullscreen;
    CGRect DuetPreviewViewFrame;
     YTPlayerView *youtubePlayer;
    NSTimer * checkStartRecordTimer;
   
    BOOL muteYoutube;
    NSTimer *timerWhenMuteYoutube;
    AVPlayer * duetVideoPlayer;
    UIAlertView *alertLinkFacebook;
    AVPlayer *audioPlayer;
    BOOL recordStated;
    NSTimer *buttonTimer;
    NSTimer *startRecordTimer;
    AVPlayer *playerMain;
    AVPlayer *playerYoutubeVideoTmp;
    int demTimeTone;
    BOOL demTimeToneLan2;
    NSTimer * demToneTimer;
    NSTimer * recordImageTimer;
    DemoTableController *controllerRecord;
    DemoTableController *autotuneKeyMenu;
    DemoTableController *autotuneAmGiaiMenu;
    DemoTableController *voiceChangerMenu;
    NSInteger duetSingLyric;
    NewEffect *liveEffect;
    NewEffect *voicechangerEffect;
    NewEffect *karaokeEffect;
    NewEffect *studioEffect;
    NewEffect *autotuneEffect;
    NewEffect *denoiseEffect;
    NewEffect *superbassEffect;
    NewEffect *boleroEffect;
    NewEffect *remixEffect;
    
    GetBpmAndKeySongResponse * bpmAndKey;
    NSMutableArray * catalogKey;
     NSMutableArray * catalogVoiceChanger;
    NSMutableArray * catalogVoiceChangerKey;
    NSMutableArray * catalogAmGiai;
    NSString *chuam;
    NSString * amgiai;
    NSString * autotuneKey;
    NSTimer *doNothingStreamTimer;
    NSString * streamSV;
     NSTimer *demperc;
    NSInteger streamStatus;//1:PLay 0: Pause
    long streamDuration;
    
    dispatch_queue_t bufferAudioQueue;
    dispatch_queue_t bufferVideoQueue;
    CMTime timeAudioSeek;
    long delayVideoRecord;
    
    //stream socket
    UIAlertController *alertDisconnectStream;
    union
    {
        short s;
        unsigned char bytes[2];
    }u;
    union
    {
        long long l;
        unsigned char longs[8];
    }kieuL,hashL;
    NSTimer *checkReceive;
    CircularQueue *ringBufferData;
    NSTimer *checkRingTimer;
    BOOL svPause;
    long long dataHash[15504];
    long long hashEffect;
    long demBuffer;
    long demConnect;
    NSInteger denoiseEffectLevel;
    NSInteger autotuneEffectLevel;
    NSInteger changeVoiceEffectLevel;
    BOOL streamSVIsConnect;
    BOOL seekToZeroBeforePlay;
}
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property (weak, nonatomic) IBOutlet UILabel *saveRecordMenuSubViewLabel1;
@property (weak, nonatomic) IBOutlet UILabel *saveRecordMenuSubViewLabel2;
@property (weak, nonatomic) IBOutlet UILabel *saveRecordMenuSubViewLabel3;
@property (weak, nonatomic) IBOutlet UILabel *saveRecordMenuSubViewLabel4;
@property (weak, nonatomic) IBOutlet UILabel *onOffPlaythroughLabel;
@property (weak, nonatomic) IBOutlet UILabel *xulyViewLechNhipTitle;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *xulyViewAutotuneMenuSegment;
@property  (weak, nonatomic)  IBOutlet UILabel *xulyViewAutotuneAmGiaiLabel;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewAutotuneDoRungSubView;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewAutotuneTuyChinhSubView;
@property (weak, nonatomic) IBOutlet UILabel *karaokeEffectEchoDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *karaokeEffectBassDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *karaokeEffectTrebleDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishRecordSubViewDiemLabel;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyViewLechNhipLoiNhanhButton;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyViewLechNhipLoiChamButton;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *superbassEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *superbassEffectTrebleSubView;
@property  (weak, nonatomic)  IBOutlet UIView *superbassEffectBassSubView;
@property  (weak, nonatomic)  IBOutlet UIView *superbassEffectEchoSubView;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *boleroEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *boleroEffectTrebleSubView;
@property  (weak, nonatomic)  IBOutlet UIView *boleroEffectBassSubView;
@property  (weak, nonatomic)  IBOutlet UIView *boleroEffectEchoSubView;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *remixEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *RemixEffectRemixSubView;
@property  (weak, nonatomic)  IBOutlet UIView *remixEffectTrebleSubview;
@property  (weak, nonatomic)  IBOutlet UIView *remixEffectBassSubView;
@property  (weak, nonatomic)  IBOutlet UIView *remixEffectEchoSubView;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *liveEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectEchoSubView;
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectBassSubView;
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectTrebleSubView;
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectWarmSubView;
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectThickSubView;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *studioEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *studioEffectVoiceSubView;
@property  (weak, nonatomic)  IBOutlet UIView *studioEffectGenderSubView;
@property  (weak, nonatomic)  IBOutlet UIView *studioEffectEchoSubView;
@property  (weak, nonatomic)  IBOutlet UISegmentedControl *karaokeEffectMenuSegment;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectWarmSubView;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectThickSubView;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectTrebleSubView;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectBassSubview;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectEchoSubview;
@property  (weak, nonatomic)  IBOutlet UIScrollView *xulyViewDenoiseSubview;
@property  (weak, nonatomic)  IBOutlet UICollectionView *xulyViewChangeVoiceEffectCollectionView;
@property  (weak, nonatomic)  IBOutlet UIScrollView *xulyViewChangeVoiceSubview;
@property  (weak, nonatomic)  IBOutlet UICollectionView *xulyViewAutotuneEffectCollectionView;
@property  (weak, nonatomic)  IBOutlet UIScrollView *xulyViewAutotuneSubView;
@property  (weak, nonatomic)  IBOutlet UICollectionView *xulyViewDenoiseEffectCollectionView;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewLechNhipSubView;
@property  (weak, nonatomic)  IBOutlet UICollectionView *xulyMenuToolbarCollectionView;
@property  (weak, nonatomic)  IBOutlet UIButton *XulyButton;
@property  (weak, nonatomic)  IBOutlet UIView *volumeVocal100Mark;
@property  (weak, nonatomic)  IBOutlet UIView *volumeMusic100Mark;
@property (strong, nonatomic)  GCDAsyncSocket *socket;
@property (assign, nonatomic) AVCaptureDevicePosition deviceCamera;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolume100Mark;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolumMaxView;
@property  (weak, nonatomic)  IBOutlet RulerVolumeView *rulerVolumeV;
@property  (weak, nonatomic)  IBOutlet UIImageView *rulerVolumeImage;
@property  (weak, nonatomic)  IBOutlet UIView *rulerVolumeView;
@property (strong, nonatomic) SCFilter *currentFilter;
@property (strong, nonatomic) NSString *currentFilterCIName;
@property (assign, nonatomic) BOOL enableBeauty;
@property (strong, nonatomic) SCRecordSession *recordSession;
@property (strong,nonatomic) AVAssetWriter *assetWriter;
@property (strong,nonatomic) AVAssetWriterInput * assetWriterInputAudio;
@property (strong,nonatomic) AVAssetWriterInput *assetWriterInputCamera;
@property  (weak, nonatomic)  IBOutlet UIButton *recordToolbarReRecordButton;


@property  (weak, nonatomic)  IBOutlet UIImageView *karaokeEffectWarmVIPIcoin;
@property  (weak, nonatomic)  IBOutlet UIImageView *karaokeEffectThickVIPIcoin;
@property  (weak, nonatomic)  IBOutlet UILabel *microVolumeLabel;
@property  (weak, nonatomic)  IBOutlet UIView *xulyviewEffectLineView;
@property  (weak, nonatomic)  IBOutlet UILabel *loadingLabelVip;
@property  (weak, nonatomic)  IBOutlet UIView *loadingViewVIP2;
@property  (weak, nonatomic)  IBOutlet UIView *loadingViewVIP;
@property (assign, nonatomic) FIRDatabaseHandle refHandle;
@property (assign, nonatomic) FIRDatabaseHandle refHandle2;
@property (strong, nonatomic) FIRDatabaseReference *ref;
//karaoke
//live
@property  (weak, nonatomic)  IBOutlet UIView *liveEffectView;
@property  (weak, nonatomic)  IBOutlet UISwitch *liveEffectSwitch;
@property  (weak, nonatomic)  IBOutlet UISlider *liveEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *liveEffectEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *liveEffectWarmSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *liveEffectWarmLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *liveEffectThickSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *liveEffectTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *liveEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *liveEffectThickLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *liveEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *liveEffectBassSlider;
//superBass
@property  (weak, nonatomic)  IBOutlet UIView *superBassEffectView;
@property  (weak, nonatomic)  IBOutlet UISlider *superBassEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *superBassEffectEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *superBassEffectBassSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *superBassEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *superBassEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *superBassEffectTrebleLabel;

//Bolero
@property  (weak, nonatomic)  IBOutlet UIView *boleroEffectView;
@property  (weak, nonatomic)  IBOutlet UISlider *boleroEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *boleroEffectEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *boleroEffectBassSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *boleroEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *boleroEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *boleroEffectTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *boleroEffectDelaySlider;
@property  (weak, nonatomic)  IBOutlet UILabel *boleroEffectDelayLabel;

//remix
@property  (weak, nonatomic)  IBOutlet UIView *remixEffectView;
@property  (weak, nonatomic)  IBOutlet UISlider *remixEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *remixEffectEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *remixEffectBassSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *remixEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *remixEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *remixEffectTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UIButton *remixEffectClassicButton;
@property  (weak, nonatomic)  IBOutlet UIButton *remixEffectSoftButton;

@property  (weak, nonatomic)  IBOutlet UIButton *remixEffectSlowBassButton;
//studio
@property  (weak, nonatomic)  IBOutlet UIButton *studioNamButton;
@property  (weak, nonatomic)  IBOutlet UIButton *studioNuButton;
@property  (weak, nonatomic)  IBOutlet UIButton *stutioCGTram;
@property  (weak, nonatomic)  IBOutlet UIButton *stutioCGTrung;
@property  (weak, nonatomic)  IBOutlet UIButton *studioCGThanh;
@property  (weak, nonatomic)  IBOutlet UIButton *studioTLCham;
@property  (weak, nonatomic)  IBOutlet UIButton *studioTLVua;
@property  (weak, nonatomic)  IBOutlet UIButton *studioTLNhanh;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectEchoLabel;

//denoise
@property  (weak, nonatomic)  IBOutlet UIButton *denoiseIt;

@property  (weak, nonatomic)  IBOutlet UIButton *denoiseVua;
@property  (weak, nonatomic)  IBOutlet UIButton *denoiseNhieu;
// voice changer
@property  (weak, nonatomic)  IBOutlet UIScrollView *voiceChangerEffectView;
@property  (weak, nonatomic)  IBOutlet UISwitch *voiceChangerEffectSwitch;
@property  (weak, nonatomic)  IBOutlet UILabel *voiceChangerEffectVoice;
@property  (weak, nonatomic)  IBOutlet UIButton *voiceChangerBaby;
@property  (weak, nonatomic)  IBOutlet UIButton *voiceChangerFemaleToMale;
@property  (weak, nonatomic)  IBOutlet UIButton *voiceChangerMaleToFemale;

@property  (weak, nonatomic)  IBOutlet UIButton *voiceChangerOlder;

//autotune
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneAmthu;

@property  (weak, nonatomic)  IBOutlet UIButton *autotuneAmTruong;
@property  (weak, nonatomic)  IBOutlet UILabel *autotuneChuAm;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneIt;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneRatNhieu;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneVua;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneNhieu;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneEffectVibIt;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneEffectVibVua;
@property  (weak, nonatomic)  IBOutlet UIButton *autotuneEffectVibNhieu;


////////
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectView;
@property  (weak, nonatomic)  IBOutlet UIImageView *karaokeEffectPlayButton;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectTimeSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectTime;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectDuration;
@property  (weak, nonatomic)  IBOutlet UISwitch *karaokeEffectSwitch;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectEchoSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectBassSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectPlayerView;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectWarmLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectWarmSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *karaokeEffectThickLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *karaokeEffectThickSlider;
@property  (weak, nonatomic)  IBOutlet UIView *karaokeEffectVIPView;

@property  (weak, nonatomic)  IBOutlet UISwitch *studioEffectSwitch;
@property  (weak, nonatomic)  IBOutlet UIScrollView *studioEffectView;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectDeesserSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectDeesserLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectBassSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectBassLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectTrebleSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectMidSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectMidLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectReverbSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectReverbLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectDelaySlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectDelayLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *studioEffectHarmonySlider;
@property  (weak, nonatomic)  IBOutlet UILabel *studioEffectHarmonyLabel;
@property  (weak, nonatomic)  IBOutlet UIView *studioEffectPlayerView;

@property  (weak, nonatomic)  IBOutlet UIScrollView *autotuneEffectView;
@property  (weak, nonatomic)  IBOutlet UIView *autotuneEffectPlayer;
@property  (weak, nonatomic)  IBOutlet UISwitch *autotuneEffectSwitch;



@property  (weak, nonatomic)  IBOutlet UIScrollView *denoiseEffectView;
@property  (weak, nonatomic)  IBOutlet UISlider *denoiseEffectSlider;
@property  (weak, nonatomic)  IBOutlet UILabel *denoiseEffectLabel;
@property  (weak, nonatomic)  IBOutlet UISwitch *denoiseEffectSwitch;
@property  (weak, nonatomic)  IBOutlet UILabel *microEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *microEchoSlider;
@property  (weak, nonatomic)  IBOutlet UIImageView *recordAlertImage;
@property  (weak, nonatomic)  IBOutlet UIView *onOffPlaythroughView;
@property  (weak, nonatomic)  IBOutlet UISwitch *onOffPlaythroughSwitch;


@property (strong, nonatomic) CRRulerControl *rulerDelay;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewRulerDelay;
@property  (weak, nonatomic)  IBOutlet UISlider *recordToolbarVoiceVolumeSlider;
@property  (weak, nonatomic)  IBOutlet UIButton *recordToolbarVoiceButton;
@property  (weak, nonatomic)  IBOutlet UIButton *recordToolbarMusicButton;
@property  (weak, nonatomic)  IBOutlet UIActivityIndicatorView *loadingViewVipLoad;
@property  (weak, nonatomic)  IBOutlet UISlider *recordToolbarMusicVolumeSlider;
@property  (weak, nonatomic)  IBOutlet UIView *recordToolbar;
@property  (weak, nonatomic)  IBOutlet UIImageView *userImage2;
@property  (weak, nonatomic)  IBOutlet UIImageView *userImage1;
@property  (weak, nonatomic)  IBOutlet UIView *duetUserView;
@property (assign, nonatomic) double delayLyricDuet;
@property  (weak, nonatomic)  IBOutlet MyPlayerLayerView *duetVideoLayer;

@property  (weak, nonatomic)  IBOutlet UIImageView *effectViewIcon;
@property  (weak, nonatomic)  IBOutlet UIButton *effectViewButton;
@property  (weak, nonatomic)  IBOutlet UIView *editViewButton;
@property  (weak, nonatomic)  IBOutlet UIScrollView *editScrollView;
@property  (weak, nonatomic)  IBOutlet UIView *effectView;
@property  (weak, nonatomic)  IBOutlet UIButton *editMoreButton;
@property  (weak, nonatomic)  IBOutlet UIImageView *editMoreIcon;
@property  (weak, nonatomic)  IBOutlet UIView *bgViewWhenEditVideo;
@property  (weak, nonatomic)  IBOutlet UIView *headerView;
@property  (weak, nonatomic)  IBOutlet UILabel *titleName;

@property  (weak, nonatomic)  IBOutlet UILabel *startRecordTime;
@property  (weak, nonatomic)  IBOutlet UIButton *uploadViewHuyButton;
@property  (weak, nonatomic)  IBOutlet UIButton *uploadViewXulyButton;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyButton;
@property  (weak, nonatomic)  IBOutlet UIButton *loiNhanhButton;
@property  (weak, nonatomic)  IBOutlet UIButton *loiChamButton;
@property  (weak, nonatomic)  IBOutlet UILabel *privacyLabelButton;
@property  (weak, nonatomic)  IBOutlet UIImageView *privacyTickerImage;
@property  (weak, nonatomic)  IBOutlet UILabel *warningVideoRecord;
@property  (weak, nonatomic)  IBOutlet UIButton *hieuungButton;
@property  (weak, nonatomic)  IBOutlet SCSwipeableFilterView *filterSwitcherView;
@property  (weak, nonatomic)  IBOutlet UIButton *fullScreenVideoPrivewButton;
@property  (weak, nonatomic)  IBOutlet UISlider *volumeBass;
@property  (weak, nonatomic)  IBOutlet UILabel *volumeBassLabel;

@property  (weak, nonatomic)  IBOutlet UICollectionView *colectionView;
//record video
// Session management.
@property  (weak, nonatomic)  IBOutlet UIButton *finishViewChangePlaylistYesButton;
@property  (weak, nonatomic)  IBOutlet UIButton *finishViewChangePlaylistNoButton;
@property  (weak, nonatomic)  IBOutlet UIImageView *markImage1;
@property  (weak, nonatomic)  IBOutlet UIButton *markButton;
@property  (weak, nonatomic)  IBOutlet UIImageView *markImage2;
@property (strong,nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property  (weak, nonatomic)  IBOutlet UINavigationItem *titleBarName;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDeviceInput *videoDeviceInput;
@property (strong,nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (strong,nonatomic) id runtimeErrorHandlingObserver;
////
@property  (weak, nonatomic)  IBOutlet UIButton *fullScreenButton;
@property  (weak, nonatomic)  IBOutlet UILabel *markLabel;
@property  (weak, nonatomic)  IBOutlet UIView *finishRecordView;
@property  (weak, nonatomic)  IBOutlet UIView *finishRecordSubview;
@property  (weak, nonatomic)  IBOutlet UILabel *timeDuration;

@property  (weak, nonatomic)  IBOutlet AVCamPreviewView *previewView;
@property  (weak, nonatomic)  IBOutlet UIBarButtonItem *MenuRightButton;

@property  (weak, nonatomic)  IBOutlet SCVideoPlayerView *playerLayerViewRec;
@property  (weak, nonatomic)  IBOutlet UIProgressView *progressBuffer;
@property (weak) IBOutlet MyPlayerLayerView *playerLayerView;
//@property  (weak, nonatomic)  IBOutlet UIView *playerView;
@property  (weak, nonatomic)  IBOutlet UILabel *timeplay;
@property  (weak, nonatomic)  IBOutlet UIView *uploadView;
@property  (weak, nonatomic)  IBOutlet UIView *toolBar;
@property  (weak, nonatomic)  IBOutlet UILabel *pt;
@property  (weak, nonatomic)  IBOutlet UILabel *Thongbao;
@property  (weak, nonatomic)  IBOutlet UITextField *NameUpload;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyButt;
@property  (weak, nonatomic)  IBOutlet UITextField *messageUpload;
@property  (weak, nonatomic)  IBOutlet UIView *saveRecordView;
@property  (weak, nonatomic)  IBOutlet UIView *saveRecordMenuSubview;
@property  (weak, nonatomic)  IBOutlet UILabel *saveRecordMenuSongName;
@property  (weak, nonatomic)  IBOutlet UIImageView *saveRecordMenuThumbnailImage;
@property  (weak, nonatomic)  IBOutlet UILabel *songNameUpload;
@property  (weak, nonatomic)  IBOutlet UISlider *volumeMusic;
@property  (weak, nonatomic)  IBOutlet UILabel *volumeMusicLabel;
@property  (weak, nonatomic)  IBOutlet UIView *effectViewBG;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewBG;
@property  (weak, nonatomic)  IBOutlet UISlider *volumeVocal;
@property  (weak, nonatomic)  IBOutlet UILabel *volumeVocalLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *volumEcho;
@property  (weak, nonatomic)  IBOutlet UILabel *volumEchoLabel;
@property  (weak, nonatomic)  IBOutlet UISlider *volumeTreble;
@property  (weak, nonatomic)  IBOutlet UILabel *volumeTrebleLabel;
@property  (weak, nonatomic)  IBOutlet UIView *xulyView;
@property  (weak, nonatomic)  IBOutlet UISlider *xulyViewMusicVolumeSlider;
@property  (weak, nonatomic)  IBOutlet UISlider *xulyViewVoiceVolumeSlider;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyViewEffectTapButton;
@property  (weak, nonatomic)  IBOutlet UIButton *xulyViewVolumeTapButton;
@property  (weak, nonatomic)  IBOutlet UIScrollView *xulyViewEffectView;
@property  (weak, nonatomic)  IBOutlet UIView *xulyViewVolumeView;
@property  (weak, nonatomic)  IBOutlet UICollectionView *xulyViewEffectCollectionView;
@property  (weak, nonatomic)  IBOutlet UIScrollView *xulyViewRuler;

@property  (weak, nonatomic)  IBOutlet UIView *volumeMusicView;
@property  (weak, nonatomic)  IBOutlet UIImageView *editBackgroundImage;

@property  (weak, nonatomic)  IBOutlet UILabel *xulyViewVolumeLechNhipLabel;


@property  (weak, nonatomic)  IBOutlet UILabel *deplayLabel;

//@property (strong, nonatomic) CSLinearLayoutView *karaokeDisplayElement;
@property  (weak, nonatomic)  IBOutlet UITextView *showplainText;
@property  (weak, nonatomic)  IBOutlet UIBarButtonItem *selectLyricButton;
@property  (weak, nonatomic)  IBOutlet UILabel *showSongName;
@property  (weak, nonatomic)  IBOutlet UILabel *showSingerName;

@property  (weak, nonatomic)  IBOutlet UITableView *menuLyric;
//@property (strong) IBOutlet UIToolbar *toolBar;
@property (weak) IBOutlet UIToolbar *MenuRec;
@property  (weak, nonatomic)  IBOutlet UIButton *playButt;
@property  (weak, nonatomic)  IBOutlet UIButton *editButt;
@property  (weak, nonatomic)  IBOutlet UILabel *warningHeadset;
@property  (weak, nonatomic)  IBOutlet UIBarButtonItem *scubberItem;
@property  (weak, nonatomic)  IBOutlet UIImageView *backgroundImage;
@property (strong , nonatomic) KaraokeDisplay *karaokeDisplay;
@property  (weak, nonatomic)  IBOutlet UIButton *pauseBtt;
@property (weak) IBOutlet UITextField *movieURLTextField;
@property (weak) IBOutlet UISlider *movieTimeControl;
@property  (weak, nonatomic)  IBOutlet UIActivityIndicatorView *isLoading;
//@property (weak, nonatomic) SelectLyricViewController *selectMenuLyric;
@property (weak) IBOutlet UILabel *isPlayingAdText;
@property (weak, nonatomic) UIButton *menuBtn;
@property  (weak, nonatomic)  IBOutlet UIImageView *recordImage;
@property  (weak, nonatomic)  IBOutlet UILabel *finishViewLabel;
@property  (weak, nonatomic)  IBOutlet UIButton *finishViewHuyButton;
@property  (weak, nonatomic)  IBOutlet UIButton *finishViewYesButton;
@property  (weak, nonatomic)  IBOutlet UIButton *finishViewNoButton;

@property (strong,nonatomic) DuetLyricView *lyricView;
@property  (weak, nonatomic)  IBOutlet UIView *duetLyricView;
@property  (weak, nonatomic)  IBOutlet UIView *microVolumeView;
- (void) sendCREATSTREAM;
- (void)loadMovi:(NSString *)urlL;
//- (IBAction)loadMovieButtonPressed:(id)sender;
- (IBAction)beginScrubbing:(id)sender;
- (IBAction)scrub:(id)sender;
- (IBAction)endScrubbing:(id)sender;
- (IBAction)showListLyric :(id)sender ;
- (IBAction)playAV:(id)sender;
- (IBAction)pause:(id)sender;
- (NSMutableArray<Line> *) getLyric: (NSString *) url;
- (BOOL)isPlaying;
-(void)showPlayButton;
-(void)showStopButton;
- (void) showAlert;
- (void)syncPlayPauseButtons;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end

static BOOL isPlayingRecordFromEdit;
static double timeRestore;
static BOOL isFavoriteTable;

static BOOL isTableSearch;

static BOOL hasCheckHeadset;
static NSString *contentPlaintext;
static BOOL showPlain;
static NSMutableDictionary *videoYoutubeDictionary;
static void *MyStreamingMovieViewControllerTimedMetadataObserverContext = &MyStreamingMovieViewControllerTimedMetadataObserverContext;
static void *MyStreamingMovieViewControllerRateObservationContext = &MyStreamingMovieViewControllerRateObservationContext;
static void *MyStreamingMovieViewControllerRateObservationContext2 = &MyStreamingMovieViewControllerRateObservationContext2;
static void *MyStreamingMovieViewControllerRateObservationContext3 = &MyStreamingMovieViewControllerRateObservationContext3;
static void *MyStreamingMovieViewControllerCurrentItemObservationContext = &MyStreamingMovieViewControllerCurrentItemObservationContext;
static void *MyStreamingMovieViewControllerCurrentItemObservationContext2 = &MyStreamingMovieViewControllerCurrentItemObservationContext2;
static void *MyStreamingMovieViewControllerPlayerItemStatusObserverContext = &MyStreamingMovieViewControllerPlayerItemStatusObserverContext;
static void *MyStreamingMovieViewControllerPlayerItemStatusObserverContext2 = &MyStreamingMovieViewControllerPlayerItemStatusObserverContext2;
static void *MyStreamingMovieViewControllerPlayerItemStatusObserverContext3 = &MyStreamingMovieViewControllerPlayerItemStatusObserverContext3;
static void *MyStreamingMovieViewControllerPlayerItemStatusObserverContext4 = &MyStreamingMovieViewControllerPlayerItemStatusObserverContext4;
static NSMutableArray *ListLyric;
static int STTBackground=0;
static  GetSongResponse* songs;
//static  AVAudioPlayer *audioPlayer;
//static KaraokeDisplay *karaokeDisplay;

extern AVURLAsset *assetLoadmovie1;
static NSMutableArray<Line> *lyric;

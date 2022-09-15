/*
 File: MyStreamingMovieViewController.m
 Abstract:
 A UIViewController controller subclass that loads the SecondView nib file that contains its view.
 Contains an action method that is called when the Play Movie button is pressed to play the movie.
 Provides a text edit control for the user to enter a movie URL.
 Manages a collection of transport control UI that allows the user to play/pause and seek.
 
 Version: 1.4
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, inclu/Users/nguyenanhtuanvu/Documents/iKara/iKara/HelpViewController.mding but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARYokara IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 èeeffe
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */
#import "UploadToServerYokara.h"
#import "StreamFirebase.h"
#import "User.h"
#import <CoreText/CoreText.h>
#import "StreamingMovieViewController.h"
#include <sys/xattr.h>
#import "RiceKaraokeUpcomingLine.h"
#import "RiceKaraokeShow.h"
#import "RiceKaraokeKaraokeLine.h"
#import "RiceKaraokeInstrumentalLine.h"

#import "GetSongResponse.h"
#import "Recording.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "LoadData2.h"
#import "Line.h"
#import "Recording.h"
#import "Lyric.h"
#import "Lyrics.h"
#import "UtilsK.h"
#import "Recording.h"
#import "EffectsR.h"
//#import "Voice.h"
//#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <Constant.h>
#import "TheAmazingAudioEngine.h"
#import "AEPlaythroughChannel.h"
#import "AEExpanderFilter.h"
#import "GetLyricResponse.h"
#import "AELimiterFilter.h"
#import "AERecorder.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "DYRateView.h"
//#import <BugSense-iOS/BugSenseController.h>

#import "audioEngine.h"
#import "LocalizationSystem.h"
#import "Video.h"
#import "GetYoutubeVideoLinksResponse.h"

#import <AVFoundation/AVFoundation.h>
#import "LocalizationSystem.h"
#import <AudioToolbox/AudioServices.h>
#import <sys/utsname.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AERecorder.h"
#import "AEPlaythroughChannel.h"
#import "AEExpanderFilter.h"
#import "AELimiterFilter.h"
#import "EffectCollectionViewCell2.h"
#import "MYAudioTapProcessor.h"
#import <SCRecorder/SCRecorder.h>
#import <JWGCircleCounter/JWGCircleCounter.h>
#import "GCDAsyncSocket.h"
#import "iosDigitalSignature.h"
#import "ExtendedAudioFileConvertOperation2.h"
#import "EffectCollectionViewCell4.h"
#import "UploadRecordingViewController.h"
//#import <ATCircularProgressView/ATCircularProgressView.h>
#define checkResult(result,operation) (_checkResult((result),(operation),strrchr(__FILE__, '/')+1,__LINE__))
/*static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
 if ( result != noErr ) {
 int fourCC = CFSwapInt32HostToBig(result);
 NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&fourCC);
 return NO;
 }
 return YES;
 }*/
NSString *tieude;
bool unload;
 BOOL playRecord;
 BOOL isrecord;
 BOOL incommingCall;
 BOOL playRecUpload;
 BOOL playTopRec;
NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

typedef struct   {
    UInt32 mChannels;
    UInt32 mDataSize;
    const void* mData;
    AudioStreamPacketDescription mPacket;
}PassthroughUserData;


OSStatus inInputDataProc(AudioConverterRef aAudioConverter,
                         UInt32* aNumDataPackets /* in/out */,
                         AudioBufferList* aData /* in/out */,
                         AudioStreamPacketDescription** aPacketDesc,
                         void* aUserData)
{
    
    PassthroughUserData* userData = (PassthroughUserData*)aUserData;
    
    if (!userData->mDataSize) {
        *aNumDataPackets = 0;
        return 222;
    }
    
    if (aPacketDesc) {
        userData->mPacket.mStartOffset = 0;
        userData->mPacket.mVariableFramesInPacket = 0;
        userData->mPacket.mDataByteSize = userData->mDataSize;
        *aPacketDesc = &userData->mPacket;
        
    }
    
    aData->mBuffers[0].mNumberChannels = userData->mChannels;
    aData->mBuffers[0].mDataByteSize = userData->mDataSize;
    aData->mBuffers[0].mData = (void*)(userData->mData);
    
    //*aNumDataPackets=userData->mDataSize;
    // No more data to provide following this run.
    userData->mDataSize = 0;
    
    return noErr;
}


@interface StreamingMovieViewController () <JWGCircleCounterDelegate,MYAudioTabProcessorDelegate,GCDAsyncSocketDelegate>{
    
    
    AudioFileID destinationFile ;
    AudioConverterRef _audioConverter;
    AudioFileID outputFileID;
    SCRecorder *recorder;
    
}



@property ( strong, nonatomic) MYAudioTapProcessor *audioTapProcessor;
@property (nonatomic, strong) NSTimer *levelsTimer;

@property  (weak, nonatomic)  IBOutlet JWGCircleCounter *startRecordView;
@property (readonly, nonatomic, strong) NSURL *destinationURL;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButtonRec;
@property (nonatomic, strong) UIButton *oneshotButton;
@property (nonatomic, strong) UIButton *oneshotAudioUnitButton;

@end
NSMutableArray *arrayIncreaseView;
AVURLAsset *assetLoadmovie1;
BOOL isRecorded;
BOOL playTopRec;
NSMutableArray * dataBackground;
BOOL hasHeadset;
BOOL connectBluetooth;
BOOL uploadProssesing;
BOOL loadlaiLyric;
CGFloat percent;
Recording *iSongPlay;
SCRecordSession *recordSessionTmp;
Recording *songRecOld;
BOOL playVideoRecorded;
NSString *kTracksKey        = @"tracks";
NSString *kStatusKey        = @"status";
NSString *kRateKey            = @"rate";
NSString *kPlayableKey        = @"playable";
NSString *kCurrentItemKey    = @"currentItem";
NSString *kTimedMetadataKey    = @"currentItem.timedMetadata";

#pragma mark -
@interface StreamingMovieViewController (Player)
- (CMTime)playerItemDuration;
- (CMTime)playerItemDuration2;
- (BOOL)isPlaying;
- (BOOL)isPlayingAudio;
- (void)handleTimedMetadata:(AVMetadataItem*)timedMetadata;
- (void)updateAdList:(NSArray *)newAdList;
- (void)assetFailedToPrepareForPlayback:(NSError *)error;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
- (void)prepareToPlayAsset2:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
- (void)prepareToPlayAsset3:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
- (void)prepareToPlayAsset4:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
- (void) playerItemDidReachEnd:(NSNotification*) aNotification;
- (void) playerItemDidReachEnd2:(NSNotification*) aNotification;
- (void) playerItemDidReachEnd3:(NSNotification*) aNotification;
- (void) startRecordVideo;

@end

@implementation StreamingMovieViewController
@synthesize audioTapProcessor = _audioTapProcessor,socket;

- (MYAudioTapProcessor *)audioTapProcessor
{
    if (!_audioTapProcessor)
    {
        AVAssetTrack *firstAudioAssetTrack;
        for (AVAssetTrack *assetTrack in audioPlayer.currentItem.asset.tracks)
        {
            if ([assetTrack.mediaType isEqualToString:AVMediaTypeAudio])
            {
                firstAudioAssetTrack = assetTrack;
                break;
            }
        }
        if (firstAudioAssetTrack)
        {
             NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString*    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
            if ([songPlay.songUrl isKindOfClass:[NSString class]])
            if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
            }
            if (songPlay.videoId.length>2){
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
                
            }
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
            }
            if (VipMember && playRecord) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"Output.caf"]];
            }
             BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (haveS ) {

                _audioTapProcessor = [[MYAudioTapProcessor alloc] initWithAudioAssetTrack:firstAudioAssetTrack andPlayer:audioPlayer andAudioPath:filePath];
                _audioTapProcessor.delegate=self;
                if (VipMember) {
                    [_audioTapProcessor updateVolumeVideo:0 ];
                    [_audioTapProcessor updateVolumeAudio:100 ];
                    maxV=0;
                    [_audioTapProcessor setDelay:0 ];
                }else{
                [_audioTapProcessor updateVolumeVideo:(int)(powf((float)[songRec.effectsNew.vocalVolume intValue]/100,1.6666)*100) ];
                [_audioTapProcessor updateVolumeAudio:(int)(powf((float)[songRec.effectsNew.beatVolume intValue]/100,1.6666)*100) ];
                    maxV=0;
                    [_audioTapProcessor setDelay:[songRec.delay intValue] ];
                     [_audioTapProcessor setEffect:[[karaokeEffect.parameters objectForKey:@"ECHO"] intValue] andBass:[[karaokeEffect.parameters objectForKey:@"BASS"] intValue] andTreble:[[karaokeEffect.parameters objectForKey:@"TREBLE"] intValue]];
                }


            }

        }
    }
    return _audioTapProcessor;
}

//AVPlayer *player;
NSInteger currentEffectID;
BOOL isExporting;
BOOL isExportingVideo;
BOOL isExportingVideoWithEffect;
BOOL isPlayingAu;
BOOL playthroughOn;
SCRecordSession *recordSessionAddEffect;
NSString * nameUp;
NSString * messUp;
@synthesize movieURLTextField;
@synthesize movieTimeControl;
@synthesize backgroundImage;
@synthesize menuLyric;
@synthesize isPlayingAdText;
@synthesize toolBar, playButt, pauseBtt,MenuRec , selectLyricButton,isLoading;
@synthesize menuBtn,NameUpload,uploadView,messageUpload;
@synthesize showSongName,pt;
@synthesize karaokeDisplay,playerLayerView,playerLayerViewRec;

#pragma mark -
#pragma mark Movie controller methods
#pragma mark -

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */
NSInteger vitriUpRec;
#pragma mark Play, Stop Buttons
/* Show the stop button in the movie player controller. */
- (BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)showStopButton
{
    //NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[toolBar items]];
    // [toolbarItems replaceObjectAtIndex:0 withObject:stopButton];
    // toolBar.items = toolbarItems;
    // NSLog(@"Show pause");
    self.isLoading.hidden=YES;
    self.playButt.hidden=YES;
    self.pauseBtt.hidden=NO;
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
    ///NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[toolBar items]];
    // [toolbarItems replaceObjectAtIndex:0 withObject:playButton];
    //toolBar.items = toolbarItems;
    // NSLog(@"show play");
    // if (isPlayingAu && !seekToZeroBeforePlay) self.isLoading.hidden=NO;
    //else self.isLoading.hidden=YES;
    if (playRecord){
    self.playButt.hidden=NO;
    self.pauseBtt.hidden=YES;
    }
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
    if ([playerMain rate]!=0.f)
    {
        NSLog(@"is play");
        [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
    }
    else
    {
    NSLog(@"is pause");
        [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
        //if (playerMain) [playerMain pause];
        // if (audioPlayRecorder) [audioPlayRecorder pause];
    }
}
- (void)syncPlayPauseButtonsAudio
{
    if (VipMember){

    }else
        if ([self isPlayingAudio])
        {
            
            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
            
        }
        else
        {
            if ([self isPlaying]) [playerMain pause];
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
            //if (playerMain) [playerMain pause];
            // if (audioPlayRecorder) [audioPlayRecorder pause];
        }
}
-(void)enablePlayerButtons
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
    self.playButt.enabled = YES;
    NSLog(@"enabled");
    self.pauseBtt.enabled = YES;
    self.editButt.enabled=YES;
                   });
}

-(void)disablePlayerButtons
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
    NSLog(@"disabled");
    self.editButt.enabled=NO;
    self.playButt.enabled = NO;
    self.pauseBtt.enabled = NO;
                   });
}

#pragma mark Scrubber control

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        movieTimeControl.minimumValue = 0.0;
        [self.progressBuffer setProgress:0.0];
        return;
    }
                       
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [movieTimeControl minimumValue];
        float maxValue = [movieTimeControl maximumValue];
        double time = CMTimeGetSeconds([playerMain currentTime]);
        //delayRec=0.28;
        [movieTimeControl setValue:(maxValue - minValue) * time / duration + minValue];
        // NSLog(@"%f",[self  availableDuration]);
        
        /// [self checkHeadset];
        /*
         float phantramtang=time/duration*;
         if (fabs(phantramtang-0.7)<0.001 && tangLuotNghe==YES){
         if (playRecUpload || playTopRec) {
         //[NSThread detachNewThreadSelector:@selector(<#selector#>) toTarget:<#(id)#> withObject:<#(id)#>
         NSLog(@"Tăng luot nghe");
         tangLuotNghe=NO;
         [[LoadData2 alloc] IncreaseViewCounter:iSongPlay.recordingId fromSource:@"NORMAL"];
         
         }
         }*/
        if (isrecord && (recorder.isRecording || audioEngine2.recorder.recording) && [songRec.performanceType isEqualToString:@"DUET"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.recordAlertImage.hidden=!self.recordAlertImage.isHidden;
            });
        }
       // if (playRecord && (self.karaokeEffectView.isHidden==NO || !self.studioEffectView.isHidden || !self.delayVIPView.isHidden)) {
            self.karaokeEffectTime.text=[NSString stringWithFormat:@"%@ | %@",[self convertTimeToString:[playerMain currentTime]],[self convertTimeToString:playerDuration]];
            
            [self.karaokeEffectTimeSlider setValue:(maxValue - minValue) * time / duration + minValue];
       // }
        self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:[playerMain currentTime]]];
        self.timeDuration.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:playerDuration]];
        if ([Language hasSuffix:@"karaokestar"]) {
            [karaokeDisplay render:time];
        }
       
        //  self.timeplay.text=[NSString stringWithFormat:@"%@/%@",[self convertTimeToString:[playerMain currentTime]],[self convertTimeToString:playerDuration]];
        if (([songRec.performanceType isEqualToString:@"DUET"] || [songRec.performanceType isEqualToString:@"ASK4DUET"])&& isrecord) {
            UIColor *color=[UIColor whiteColor];
            NSInteger gen;
            for (int i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
                ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
                if (ct.time<=time+1) {
                    color=ct.color;
                    gen=ct.gender;
                    break;
                }
            }
            if (gen==0) {
                // [self user1Sing];
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
                }else{
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }
            }else if (gen==1){
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }else
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
            }else{
                [self bothSing];
            }
            //// [self.movieTimeControl setThumbTintColor:color];
            if ([color isEqual:genderColor]) {
                [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
            }else if ([color isEqual:[UIColor whiteColor]]) {
                [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
            }else{
                [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
            }
            

        }
    if (isrecord && [playerMain rate]!=0&& time>15&& time<20 && !videoRecord){

        if ([songRec.performanceType isEqualToString:@"DUET"]  && CMTimeGetSeconds([duetVideoPlayer currentTime])>0 ) {

            delayRec=audioEngine2.recorder.currentTime-CMTimeGetSeconds([duetVideoPlayer currentTime]);

            NSLog(@"delay duet check 2 %f",delayRec);
                //timeRecord=0;

        }else{
            delayRec=audioEngine2.recorder.currentTime-CMTimeGetSeconds([playerMain currentTime]);
           // delayRec=CACurrentMediaTime()-timeRecord-CMTimeGetSeconds([playerMain currentTime]);
            NSLog(@"delay check 2 %f",delayRec);
            timeRecord=0;
        }
    }
    if ( CMTimeGetSeconds([playerMain currentTime])>0 && [playerMain rate]!=0) {
        if (isrecord &&  !isRecorded){
            [self record];
            NSLog(@"change rate player DUET and record");
                //[self performSelectorOnMainThread:@selector(record) withObject:nil waitUntilDone:NO];
        }
    }

    }
                   });
}
- (void)syncScrubber2
{
    CMTime playerDuration = [self playerItemDuration2];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        movieTimeControl.minimumValue = 0.0;
        [self.progressBuffer setProgress:0.0];
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [movieTimeControl minimumValue];
        float maxValue = [movieTimeControl maximumValue];
        double time = CMTimeGetSeconds([audioPlayer currentTime]);
        //delayRec=0.28;
        [movieTimeControl setValue:(maxValue - minValue) * time / duration + minValue];
        // NSLog(@"%f",[self  availableDuration]);
        
        /// [self checkHeadset];
        /*
         float phantramtang=time/duration*;
         if (fabs(phantramtang-0.7)<0.001 && tangLuotNghe==YES){
         if (playRecUpload || playTopRec) {
         //[NSThread detachNewThreadSelector:@selector(<#selector#>) toTarget:<#(id)#> withObject:<#(id)#>
         NSLog(@"Tăng luot nghe");
         tangLuotNghe=NO;
         [[LoadData2 alloc] IncreaseViewCounter:iSongPlay.recordingId fromSource:@"NORMAL"];
         
         }
         }*/
        // if (playRecord && (self.karaokeEffectView.isHidden==NO || !self.studioEffectView.isHidden || !self.delayVIPView.isHidden)) {
        if (time>=duration-1  && VipMember && playRecord  ) {
            [audioPlayer seekToTime:kCMTimeZero];
            [audioPlayer play];
        }
        /*long pos=time*44100/1024;
        if (pos<15500) {
            if ( dataHash[pos]!=hashEffect){
                demBuffer++;
                if (demBuffer>3) {
                    demBuffer=0;
                    [self sendUPDATESTREAM2:(pos-1)*1024];
                    streamIsPlay=NO;
                    [self showPlayButton];
                    if (audioPlayer.rate) {
                         [audioPlayer pause];
                    }
                    if (playerYoutubeVideoTmp) {
                        if (playerYoutubeVideoTmp.rate) {
                            [playerYoutubeVideoTmp pause];
                        }
                    }
                }
                
            }
            
            
        }*/
        
        self.karaokeEffectTime.text=[NSString stringWithFormat:@"%@ | %@",[self convertTimeToString:[audioPlayer currentTime]],[self convertTimeToString:playerDuration]];
        
        [self.karaokeEffectTimeSlider setValue:(maxValue - minValue) * time / duration + minValue];
        // }
        self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:[audioPlayer currentTime]]];
        self.timeDuration.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:playerDuration]];
        //  self.timeplay.text=[NSString stringWithFormat:@"%@/%@",[self convertTimeToString:[playerMain currentTime]],[self convertTimeToString:playerDuration]];
        if (([songRec.performanceType isEqualToString:@"DUET"] || [songRec.performanceType isEqualToString:@"ASK4DUET"])) {
            UIColor *color=[UIColor whiteColor];
            NSInteger gen;
            for (int i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
                ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
                if (ct.time<=time+1) {
                    color=ct.color;
                    gen=ct.gender;
                    break;
                }
            }
            if (gen==0) {
                // [self user1Sing];
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
                }else{
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }
            }else if (gen==1){
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }else
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
            }else{
                [self bothSing];
            }
            //// [self.movieTimeControl setThumbTintColor:color];
            if ([color isEqual:genderColor]) {
                [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
            }else if ([color isEqual:[UIColor whiteColor]]) {
                [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
            }else{
                [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
            }
            
            
            
        }
        
    }
}
- (void)user1Sing{
    if (duetSingLyric!=1) {
        duetSingLyric=1;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.userImage1.transform = CGAffineTransformMakeScale(1.35,1.35);
            self.userImage2.transform=CGAffineTransformMakeScale(0.7,0.7);
            self.userImage1.frame=CGRectMake(20, 30, self.userImage1.frame.size.width, self.userImage1.frame.size.height);
            self.userImage2.frame=CGRectMake(80, 10, self.userImage2.frame.size.width, self.userImage2.frame.size.height);
            
            
            
            /*
             self.userImage1.layer.cornerRadius=self.userImage1.frame.size.width/2;
             self.userImage2.layer.cornerRadius=self.userImage2.frame.size.width/2;
             self.userImage1.layer.masksToBounds=YES;
             self.userImage2.layer.masksToBounds=YES;*/
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void) user2Sing{
    if (duetSingLyric!=2) {
        duetSingLyric=2;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.userImage2.transform = CGAffineTransformMakeScale(1.35,1.35);
            self.userImage1.transform=CGAffineTransformMakeScale(0.7,0.7);
            self.userImage2.frame=CGRectMake(20, 30, self.userImage2.frame.size.width, self.userImage2.frame.size.height);
            self.userImage1.frame=CGRectMake(80, 10, self.userImage1.frame.size.width, self.userImage1.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void) bothSing{
    duetSingLyric=0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.userImage2.transform = CGAffineTransformMakeScale(1,1);
        self.userImage1.transform=CGAffineTransformMakeScale(1,1);
        self.userImage1.frame=CGRectMake(20, 20, 60, 60);
        self.userImage2.frame=CGRectMake(70, 20, 60, 60);
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void) hideLoading{
    NSLog(@"an load");
    [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
    self.isLoading.hidden=YES;
}
- (void) showLoading{
    NSLog(@"hien load");
    if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
        self.isLoading.hidden=NO;
    }
    
}
- (void)initializeMotionManager{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            if (!error) {
                                                [self outputAccelerationData:accelerometerData.acceleration];
                                            }
                                            else{
                                                NSLog(@"%@", error);
                                            }
                                        }];
}
- (void)outputAccelerationData:(CMAcceleration)acceleration{
    UIInterfaceOrientation orientationNew;
    
    if (acceleration.x >= 0.75) {
        orientationNew = UIInterfaceOrientationLandscapeLeft;
        //   NSLog(@"Landscape Left");
    }
    else if (acceleration.x <= -0.75) {
        orientationNew = UIInterfaceOrientationLandscapeRight;
        // NSLog(@"Landscape Right");
    }
    else if (acceleration.y <= -0.75) {
        orientationNew = UIInterfaceOrientationPortrait;
        //NSLog(@"Portrait");
    }
    else if (acceleration.y >= 0.75) {
        orientationNew = UIInterfaceOrientationPortraitUpsideDown;
    }
    else {
        // Consider same as last time
        return;
    }
    
    if (orientationNew == orientationLast)
        return;
    
    orientationLast = orientationNew;
}
- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter {

    if ([Language hasSuffix:@"kara"] && ![songRec.performanceType isEqualToString:@"DUET"]) {
        //   dispatch_async(dispatch_get_main_queue(), ^{
       [self playYoutube];
		  [youtubePlayer playVideo];
        
        // });
        
    }
    startRecordDem=0;
    [self checkPlaying1];
    dispatch_async(dispatch_get_main_queue(), ^{
    self.startRecordView.hidden=YES;
        self.isLoading.hidden = NO;
    });
}
- (void) checkStartRecord{
    if (startRecordDem<=0 && recordStated==NO) {
        recordStated=YES;
        //startRecordDem=3;
        // dispatch_async(dispatch_get_main_queue(), ^{
        [self showStopButton];
        
        if ([Language hasSuffix:@"kara"]) {
            //   dispatch_async(dispatch_get_main_queue(), ^{
            if (![songRec.performanceType isEqualToString:@"DUET"])
                [youtubePlayer playVideo];
            
            // });
            
        }
        self.startRecordView.hidden=YES;
        //});
        //isRecorded=YES;
        //[startRecordTimer invalidate];
        // startRecordTimer=nil;
        
        // [checkStartRecordTimer invalidate];
        //  checkStartRecordTimer=nil;
        // [playerMain play];
    }else{
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        self.startRecordView.hidden=NO;
        //[self.startRecordView setProgressWithValue:(1-startRecordDem/3) animated:YES duration:1 completion:^{
             startRecordDem--;
            [self checkStartRecord];
      //  }];
       
       /* [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.startRecordTime.text=[NSString stringWithFormat:@"%d",startRecordDem];
            self.startRecordTime.font=[UIFont systemFontOfSize:60];
            self.startRecordTime.transform = CGAffineTransformMakeScale(1.5,1.5);
            
        } completion:^(BOOL finished) {
            self.startRecordTime.transform = CGAffineTransformMakeScale(1,1);
            self.startRecordTime.font=[UIFont systemFontOfSize:40];
            startRecordDem--;
            [self checkStartRecord];
        }];*/
        
        // });
        
    }
}
- (void) checkPlaying1{
    @autoreleasepool {
        //UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])
        if (playRecord) {
            [playerMain setMuted:YES];
        }
     
         dispatch_async(dispatch_get_main_queue(), ^{
            /* if (duetVideoPlayer && isPlayingAu ) {
                 if ( fabs( CMTimeGetSeconds([playerMain currentTime])-CMTimeGetSeconds([duetVideoPlayer currentTime]))>1 && (CMTimeGetSeconds([playerMain currentTime]))<CMTimeGetSeconds([duetVideoPlayer.currentItem duration]) )  {
                     NSLog(@"Dong bo player duet");
                     duetVideoPlayer.muted=YES;
                     if (duetVideoPlayer.rate) {
                         [duetVideoPlayer pause];
                     }
                     
                     [duetVideoPlayer play];
                 }
             }*/
        
             if (playerMain && [songRec.performanceType isEqualToString:@"DUET"]&& isrecord ) {
                 if (duetVideoPlayer.rate && fabs( CMTimeGetSeconds([duetVideoPlayer currentTime])-CMTimeGetSeconds([playerMain currentTime]))>0.2 && (CMTimeGetSeconds([duetVideoPlayer currentTime]))<CMTimeGetSeconds([playerMain.currentItem duration])  && isPlayingAu && CMTimeGetSeconds([duetVideoPlayer currentTime])>0 && playerMain.rate && [self availableDuration]>0) {
                     CMTime time = duetVideoPlayer.currentTime;
                     if (playerMain.rate) {
                         [playerMain pause];
                     }
                     [playerMain seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                         [playerMain play];
                         if (!duetVideoPlayer.rate) {
                             [duetVideoPlayer play];
                         }
                     }];
                     
                 }
             }else
        if (playerYoutubeVideoTmp && fabs( CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([playerYoutubeVideoTmp currentTime]))>0.5 && (CMTimeGetSeconds([audioPlayer currentTime]))<CMTimeGetSeconds([playerYoutubeVideoTmp.currentItem duration])  && isPlayingAu) {
            if (playerYoutubeVideoTmp.rate) {
                [playerYoutubeVideoTmp pause];
            }
            
            [playerYoutubeVideoTmp seekToTime:audioPlayer.currentTime];
            [playerYoutubeVideoTmp play];
        }
             
         });
        //  if (isrecord && !videoRecord && startRecord && !isRecorded && !recordStated) {
        
        
        
        // }else
        //    orientationLast==UIInterfaceOrientationLandscapeLeft     &&
        if ( videoRecord && isrecord && !isRecorded && !recordStated) {
            //     NSLog(@"Landscape record video");
            
            
        }else{
            if (videoRecord && isrecord && !isRecorded) {
                /*
                 dispatch_async(dispatch_get_main_queue(), ^{
                 [self showPlayButton];
                 // self.warningVideoRecord.hidden=NO;
                 });*/
            }
        }
        
        
        /*
         if(playRecord){
         if (playVideoRecorded){
         NSLog(@"beat %f   voice   %f  delay %f",CMTimeGetSeconds( playerMain.currentTime),CMTimeGetSeconds( audioPlayer.currentTime),CMTimeGetSeconds( playerMain.currentTime)+[songRec.delay doubleValue]/1000.0f-CMTimeGetSeconds( audioPlayer.currentTime));
         }else
         NSLog(@"beat %f   voice   %f  delay %f",CMTimeGetSeconds( playerMain.currentTime),audioPlayRecorder.currentTime,CMTimeGetSeconds( playerMain.currentTime)+[songRec.delay doubleValue]/1000.0f-audioPlayRecorder.currentTime);
         }*/
        
        if (isKaraokeTab ){
            if (VipMember ) {
                if (playRecord) {
                    if (!playerMain.isMuted) {
                        playerMain.muted=YES;
                        
                    }
                    
                    if (!playerYoutubeVideoTmp.isMuted) {
                        playerYoutubeVideoTmp.muted=YES;
                    }
                    if (audioPlayRecorder.volume) {
                        [audioPlayRecorder setVolume:0];
                    }
                    
                    if (!duetVideoPlayer.isMuted) {
                        duetVideoPlayer.muted=YES;
                    }
                }
                
            }
            
            if  (playRecord && [Language hasSuffix:@"kara"])
            {
                
                if (isPlayingAu && ![self isPlayingAudio]  && [Language hasSuffix:@"kara"]  )
                {
                    if (VipMember && streamIsPlay) {
                        NSLog(@"asset audio%f",[self  availableDurationAudio]);
                        //NSTimeInterval timeLoaded=[self  availableDuration];
                        NSTimeInterval timeLoadedAudio=[self  availableDurationAudio];
                        if  (timeLoadedAudio>=(CMTimeGetSeconds( audioPlayer.currentTime)+5))  {
                            NSLog(@"Play top and Rec Up");
                            //  for (int i=1;i++;i<100)
                            
                            NSLog(@"player %f lech  %f audio %f",CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f-CMTimeGetSeconds([audioPlayer currentTime]),CMTimeGetSeconds([audioPlayer currentTime]));
                            
                            /*if (CMTimeGetSeconds([playerMain currentTime])==0 || CMTimeGetSeconds([audioPlayer currentTime])==0){
                                if ([songRec.delay doubleValue]>0){
                                    [audioPlayer seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                                   
                                    
                                }else{
                                    [audioPlayer seekToTime:kCMTimeZero];
                                    
                                    [playerMain seekToTime:CMTimeMakeWithSeconds(fabs([songRec.delay doubleValue]/1000), NSEC_PER_SEC)];
                                }
                            }*/
                            //if ( CMTimeGetSeconds( audioPlayer.currentTime)< CMTimeGetSeconds([self playerItemDuration2])){
                            if (playerYoutubeVideoTmp) {
                                [playerYoutubeVideoTmp play];
                            }
                            [audioPlayer play];
                            // }
                            if (playerMain) {
                                [playerMain play];
                            }
                            
                            if ( duetVideoPlayer) {
                                [duetVideoPlayer play];
                            }
                            
                            if (isKaraokeTab){
                                isLoading.hidden=YES;
                            }
                            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                        }
                    }else if (!VipMember){
                        NSLog(@"asset audio%f",[self  availableDuration]);
                        NSTimeInterval timeLoaded=[self  availableDuration];
                        NSTimeInterval timeLoadedAudio=[self  availableDurationAudio];
                        if ((timeLoaded>=(CMTimeGetSeconds( playerMain.currentTime)+5) || timeLoaded>= CMTimeGetSeconds([self playerItemDuration] ))|| (timeLoadedAudio>=(CMTimeGetSeconds( audioPlayer.currentTime)+5)|| timeLoadedAudio>= CMTimeGetSeconds([self playerItemDuration2]))  ) {
                            NSLog(@"Play top and Rec Up");
                            //  for (int i=1;i++;i<100)
                            
                            //NSLog(@"player %f lech  %f audio %f",CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f-CMTimeGetSeconds([audioPlayer currentTime]),CMTimeGetSeconds([audioPlayer currentTime]));
                            
                            /*if (CMTimeGetSeconds([playerMain currentTime])==0 || CMTimeGetSeconds([audioPlayer currentTime])==0){
                                if ([songRec.delay doubleValue]>0){
                                    [audioPlayer seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                                    
                                    
                                }else{
                                    [audioPlayer seekToTime:kCMTimeZero];
                                    
                                    [playerMain seekToTime:CMTimeMakeWithSeconds(fabs([songRec.delay doubleValue]/1000), NSEC_PER_SEC)];
                                }
                            }*/
                            //if ( CMTimeGetSeconds( audioPlayer.currentTime)< CMTimeGetSeconds([self playerItemDuration2])){
                            if (VipMember  && playRecord ) {
                              
                                
                            }else{
                                [audioPlayer play];
                                // }
                                if (playerMain) {
                                    [playerMain play];
                                }
                                
                                if ( duetVideoPlayer) {
                                    [duetVideoPlayer play];
                                }
                                if (playerYoutubeVideoTmp) {
                                    [playerYoutubeVideoTmp play];
                                }
                            }
                            
                            if (isKaraokeTab){
                                isLoading.hidden=YES;
                            }
                            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                        }
                    }else if (isKaraokeTab){
                        if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
                            self.isLoading.hidden=NO;
                        }
                    }
                }else if  (isPlayingAu){
                    if (isKaraokeTab){
                        self.playButt.hidden=YES;
                        self.pauseBtt.hidden=NO;
                      
                        isLoading.hidden=YES;
                    }
                }
            }else if  (playRecord  ){
                if (isPlayingAu && (![self isPlayingAudio] || ![self isPlaying] ) )
                {
                    NSLog(@"asset audio%f",[self  availableDuration]);
                    NSTimeInterval timeLoaded=[self  availableDuration];
                    NSTimeInterval timeLoadedAudio=[self  availableDurationAudio];
                    if ((timeLoaded>=(CMTimeGetSeconds( playerMain.currentTime)+5) || timeLoaded>= CMTimeGetSeconds([self playerItemDuration])) && (timeLoadedAudio>=(CMTimeGetSeconds( audioPlayer.currentTime)+5)|| timeLoadedAudio>= CMTimeGetSeconds([self playerItemDuration2])) && (playRecUpload || playTopRec ||playVideoRecorded)) {
                        
                        NSLog(@"Play top and Rec Up playVideoRecorded");
                        
                       
                        if (VipMember && playRecord ) {
                           
                        }else{
                            [playerMain play];
                            [audioPlayer play];
                            if ( duetVideoPlayer) {
                                [duetVideoPlayer play];
                            }
                            if (playerYoutubeVideoTmp) {
                                [playerYoutubeVideoTmp play];
                            }
                            //if ( CMTimeGetSeconds( audioPlayer.currentTime)< CMTimeGetSeconds([self playerItemDuration2])){
                            
                            //}
                            if (isKaraokeTab){
                                isLoading.hidden=YES;
                            }
                            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                        }
                    }else if (isKaraokeTab){
                        if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
                            self.isLoading.hidden=NO;
                        }
                    }
                }else if  (isPlayingAu){
                    if (isKaraokeTab){
                        self.playButt.hidden=YES;
                        self.pauseBtt.hidden=NO;
                      
                        isLoading.hidden=YES;
                    }
                }
            }
            else if  (playRecord && !playVideoRecorded ){
                if (isPlayingAu && [playerMain rate]==0.f )
                {
                    NSLog(@"asset %f",[self  availableDuration]);
                    NSTimeInterval timeLoaded=[self  availableDuration];
                    if (timeLoaded>=(CMTimeGetSeconds( playerMain.currentTime)+5) && audioPlayRecorder && playRecord && !playVideoRecorded) {
                        NSLog(@"Play recor");
                      
                        if (VipMember && playRecord ) {
                          
                        }else{
                            //if ([songRec->hasUpload isEqualToString:@"YES"]){
                            audioPlayRecorder.currentTime=CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f;
                            if (CMTimeGetSeconds( playerMain.currentTime)+[songRec.delay doubleValue]/1000<audioPlayRecorder.duration){
                                [audioPlayRecorder play];
                                [playerMain play];
                                
                            }else{
                                [playerMain play];
                            }
                            if ( duetVideoPlayer) {
                                [duetVideoPlayer play];
                            }
                            if (playerYoutubeVideoTmp ) {
                                [playerYoutubeVideoTmp play];
                            }
                            /*  }
                             
                             else {
                             if (CMTimeGetSeconds( playerMain.currentTime)+[songRec.delay doubleValue]<audioPlayRecorder.duration){
                             [audioPlayRecorder play];
                             }
                             }*/
                            if (isKaraokeTab){
                                isLoading.hidden=YES;
                            }
                            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                        }
                    }
                    else if (timeLoaded>=(CMTimeGetSeconds( playerMain.currentTime)+5) ) {
                        NSLog(@"Play");
                        
                        [playerMain play];
                        if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2) {
                            [audioEngine2 playthroughSwitchChanged:YES];
                            [audioEngine2 reverbSwitchChanged:YES];
                            [audioEngine2 expanderSwitchChanged:YES];
                        }
                        if (isKaraokeTab){
                            isLoading.hidden=YES;
                        }
                        if (playerYoutubeVideoTmp) {
                            [playerYoutubeVideoTmp play];
                        }
                        [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                    }else if (isKaraokeTab){
                        if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
                            self.isLoading.hidden=NO;
                        }
                    }
                }else if  (isPlayingAu){
                    if (isKaraokeTab){
                        self.playButt.hidden=YES;
                        self.pauseBtt.hidden=NO;
                       
                        isLoading.hidden=YES;
                    }
                }
            }else {
                if (isPlayingAu && !playRecord && ![self isPlaying] && playerMain){
                    NSTimeInterval timeLoaded=[self  availableDuration];
                    NSLog(@"Play mot minh player %f",timeLoaded);
                    if (timeLoaded>=(CMTimeGetSeconds( playerMain.currentTime)+5)) {
                        
                        if (isrecord && [songRec.performanceType isEqualToString:@"DUET"]) {
                            NSTimeInterval timeLoadedDuet=[self  availableDurationDuet];
                            NSLog(@"Play mot minh player duet %f",timeLoadedDuet);
                            if (timeLoadedDuet>=(CMTimeGetSeconds( duetVideoPlayer.currentTime)+5)) {
                                NSLog(@"Play mot minh player duet");
                                /*
                                 if (CMTimeGetSeconds( playerMain.currentTime)>5
                                 && isRecorded &&  isrecord){
                                 isrecord=NO;
                                 
                                 [[[[iToast makeText:AMLocalizedString(@"Tốc độ mạng chậm nên ảnh hưởng đến chất lượng thu âm.", @"")]
                                 setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                 [self record];
                                 }
                                 else*/
                                
                                    if (((videoRecord && isrecord ) || !videoRecord) && startRecordDem==0) {
                                        if (duetVideoPlayer) {
                                            
                                            [duetVideoPlayer play];
                                        }
                                        if (playerMain) {
                                            [playerMain play];
                                        }
                                        
                                        
                                        
                                        
                                        
                                        if (playerYoutubeVideoTmp) {
                                            [playerYoutubeVideoTmp play];
                                        }
                                    }
                                    
                                    if (isKaraokeTab){
                                        isLoading.hidden=YES;
                                    }
                                    
                                    [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                                
                            }
                        
                                
                        }else{
                        NSLog(@"Play mot minh player");
                     
                        if (VipMember&& playRecord  ) {
                          
                        }else{
                            if (((videoRecord && isrecord ) || !videoRecord) && startRecordDem==0) {
                                [playerMain play];
                                
                                if ( duetVideoPlayer) {
                                    [duetVideoPlayer play];
                                }
                                if (playerYoutubeVideoTmp) {
                                    [playerYoutubeVideoTmp play];
                                }
                            }
                            
                            if (isKaraokeTab){
                                isLoading.hidden=YES;
                            }
                            
                            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
                        }
                        }
                    }else if (isKaraokeTab){
                        if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
                            self.isLoading.hidden=NO;
                        }
                    }
                }
            }
            
            //  }
           
            if (seekToZeroBeforePlay  && (playTopRec || playRecUpload || (songRec.mixedRecordingVideoUrl && ![songRec.mixedRecordingVideoUrl isKindOfClass:[NSNull class]]) ) ) {
                if (movieTimeControl.value!=0){
                    [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
                    [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
                    // self.timeplay.text=[NSString stringWithFormat:@"%@/%@",[self convertTimeToString:kCMTimeZero],[self convertTimeToString:[self playerItemDuration]]];
                    self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:kCMTimeZero]];
                    self.timeDuration.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:[self playerItemDuration]]];
                    self.karaokeEffectTime.text=[NSString stringWithFormat:@"%@ | %@",[self convertTimeToString:[playerMain currentTime]],[self convertTimeToString:[self playerItemDuration]]];
                    
                    [self.karaokeEffectTimeSlider setValue:0];
                    isLoading.hidden=YES;
                }
            }
            
            if (isKaraokeTab){
                if ([Language hasSuffix:@"kara"] && (playRecUpload || playTopRec) ){
                    if ([self availableDuration]<[self availableDurationAudio]){
                        [self.progressBuffer setProgress:[self  availableDuration]/CMTimeGetSeconds([self playerItemDuration])];
                    }
                    else{
                        [self.progressBuffer setProgress:[self  availableDurationAudio]/CMTimeGetSeconds([self playerItemDuration])];
                    }
                }else{
                    [self.progressBuffer setProgress:[self  availableDuration]/CMTimeGetSeconds([self playerItemDuration])];
                }
            }
            double time = CMTimeGetSeconds([playerMain currentTime]);
            /*if (isrecord && [self isPlaying] && time>2&& timeRecord>0){
                NSLog(@"delay check 2 %f",CACurrentMediaTime()-timeRecord-CMTimeGetSeconds([playerMain currentTime]));
                
                
                        delayRec=CACurrentMediaTime()-timeRecord-CMTimeGetSeconds([playerMain currentTime]);
                NSLog(@"delay check 2 %f",delayRec);
                timeRecord=0;
            }*/
            
            if (!hasHeadset && CMTimeGetSeconds([playerMain currentTime])>15 && self.warningHeadset.hidden==NO){
                self.warningHeadset.hidden=YES;
            }
            float timeLech=55555550.03;
            if ([songRec.performanceType isEqualToString:@"DUET"]|| playVideoRecorded) {
                timeLech=5555550.05;
            }
            if (VipMember && playRecord  ) {
                timeLech=55555550.5;
            }
            if (playRecord && !playVideoRecorded && !audioEnd && !isTapSlider) {
                if (![Language hasSuffix:@"kara"]){
                    // if ([songRec->hasUpload isEqualToString:@"YES"]) {
                    if ((fabs(audioPlayRecorder.currentTime-CMTimeGetSeconds([playerMain currentTime])-[songRec.delay doubleValue]/1000) > timeLech ) &&(fabs(audioPlayRecorder.currentTime-audioPlayRecorder.duration)) > 5 && (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000)>0 && CMTimeGetSeconds([playerMain currentTime])>0 && audioPlayRecorder.currentTime>0   && [playerMain rate]!=0.f && CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000<audioPlayRecorder.duration) {
                        [audioPlayRecorder pause];
                        [playerMain pause];
                        if (isKaraokeTab){
                            [self performSelectorOnMainThread:@selector(showLoading) withObject:nil waitUntilDone:NO];
                        }
                        audioPlayRecorder.currentTime=CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000;
                        [audioPlayRecorder play];
                        [playerMain play];
                    }
                    
                }else{
                    
                    //  if ([songRec->hasUpload isEqualToString:@"YES"]) {
                    if ((fabs(audioPlayRecorder.currentTime-CMTimeGetSeconds([playerMain currentTime])-[songRec.delay doubleValue]/1000) > timeLech ) &&(fabs(audioPlayRecorder.currentTime-audioPlayRecorder.duration)) > 4 && (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000)>0 && CMTimeGetSeconds([playerMain currentTime])>0&& audioPlayRecorder.currentTime>0 && [self isPlaying] && CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000<audioPlayRecorder.duration && !(playRecord )) {
                       
                       //// [playerMain pause];
                        if (isKaraokeTab && !VipMember){
                          //  [self performSelectorOnMainThread:@selector(showLoading) withObject:nil waitUntilDone:NO];
                        }
                        NSLog(@"dong bo player audio                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       %f lech  %f audio %f",CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f-audioPlayRecorder.currentTime,audioPlayRecorder.currentTime);
                      //  audioPlayRecorder.currentTime=CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f;
                         //[self removePlayerTimeObserver];
                        restoreAfterScrubbingRate = [playerMain rate];
                        [audioPlayRecorder pause];
                        [playerMain pause];
                        
                        // [playerMain pause];
                         [audioPlayer pause];
                        
                        /* Remove previous timer. */
                       
                        double time =CMTimeGetSeconds([playerMain currentTime]);
                        audioPlayRecorder.currentTime=time+[songRec.delay doubleValue]/1000.0f-0.01;
                        //[playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                        if (timeObserver==nil) {
                            timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                            ^(CMTime time)
                                            {
                                                [self syncScrubber];
                                            }];
                        }
                       
                        //[self playAfterScruber];
                         [self performSelector:@selector(playAfterScruber) withObject:nil afterDelay:0.2];
                    }
                    
                }
            }else if ((([Language hasSuffix:@"kara"]&& (playRecUpload|| playTopRec ) && !playVideoRecorded ) || (playVideoRecorded && playRecord))  && audioPlayer && playerMain && !isTapSlider){
                if (playVideoRecorded && playRecord ) {
                    //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                   
                    if (isPlayingAu && (fabs(CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([playerMain currentTime])-[songRec.delay doubleValue]/1000.0) > timeLech ) &&(fabs(CMTimeGetSeconds([[audioPlayer currentItem] duration])-CMTimeGetSeconds([audioPlayer currentTime]))) > 5 && (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0)>0 && (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0)<CMTimeGetSeconds([[audioPlayer currentItem] duration]) && CMTimeGetSeconds([playerMain currentTime])>0&& CMTimeGetSeconds([audioPlayer currentTime])>0  && [self isPlaying] && !(playRecord )) {
                        
                        //float ratet=[playerMain rate];
                        // [playerMain pause];
                        //time = CMTimeGetSeconds([playerMain currentTime]);
                        //[audioPlayer pause];
                        
                        
                        
                        //   for (int i=1;i++;i<100)
                        
                        
                        /*
                         if (!isTapSlider){
                         [audioPlayer seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                         }
                         [playerMain setRate:1.0f];
                         [audioPlayer setRate:1.0f];*/
                      //  dispatch_async(dispatch_get_main_queue(), ^{
                            if (!isrecord) {
                                 NSLog(@"dong bo player                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       %f lech  %f audio %f",CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f-CMTimeGetSeconds([audioPlayer currentTime]),CMTimeGetSeconds([audioPlayer currentTime]));
                                [self performSelectorOnMainThread:@selector(dongboPlayerAndAudio:) withObject:[NSNumber numberWithDouble: CMTimeGetSeconds([playerMain currentTime])] waitUntilDone:NO];
                               
                            }
                       // });
                        
                    }
                  
                }else if (playVideoRecorded && playRecord && ![Language hasSuffix:@"kara"]) {
                    //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                    if ((fabs(CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([playerMain currentTime])-[songRec.delay doubleValue]/1000.0) > timeLech ) &&(fabs(CMTimeGetSeconds([[audioPlayer currentItem] duration])-CMTimeGetSeconds([audioPlayer currentTime]))) > fabs([songRec.delay doubleValue]/1000.0) && (CMTimeGetSeconds([audioPlayer currentTime])>fabs([songRec.delay doubleValue]/1000.0)) && (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0)<CMTimeGetSeconds([[audioPlayer currentItem] duration]) && CMTimeGetSeconds([playerMain currentTime])>0&& CMTimeGetSeconds([audioPlayer currentTime])>0  && [playerMain rate]!=0.f) {
                        //[self pause:nil];
                        // [self playAV:nil];
                        
                        /*
                         //float ratet=[playerMain rate];
                         [playerMain pause];
                         //time = CMTimeGetSeconds([playerMain currentTime]);
                         [audioPlayer pause];
                         [playerMain setRate:0.f];
                         [audioPlayer setRate:0.f];
                         if (isKaraokeTab){
                         [self performSelectorOnMainThread:@selector(showLoading) withObject:nil waitUntilDone:NO];
                         }
                         
                         
                         //   for (int i=1;i++;i<100)
                         
                         
                         
                         //
                         
                         if (!isTapSlider)
                         [audioPlayer seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                         //
                         */
                            if (!isrecord) {
                                restoreAfterScrubbingRate = [playerMain rate];
                                [playerMain setRate:0.f];
                                
                                [audioPlayer setRate:0.f];
                                //if ([audioPlayer rate]!=0) [audioPlayer pause];
                                
                                /* Remove previous timer. */
                                [self removePlayerTimeObserver];
                                
                                CMTime playerDuration = [self playerItemDuration];
                                if (CMTIME_IS_INVALID(playerDuration)) {
                                    return;
                                }
                                
                                double duration = CMTimeGetSeconds(playerDuration);
                                if (isfinite(duration))
                                {
                                    
                                    
                                    double time =CMTimeGetSeconds([playerMain currentTime]);
                                    
                                    [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                                    
                                    if (playRecord) {
                                        if (playVideoRecorded && audioPlayer){
                                            
                                            //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                                            [audioPlayer seekToTime:CMTimeMakeWithSeconds(time+[songRec.delay doubleValue]/1000.0f+0.1, NSEC_PER_SEC)];
                                            if (VipMember && playRecord  ) {
                                                dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                                                
                                                dispatch_async(queue, ^{
                                                    //   [[LoadData2 alloc] seekStream:streamName andPossition:CMTimeGetSeconds([audioPlayer currentTime])*1000 andSV:streamSV];
                                                });
                                            }
                                            /*}else{
                                             [audioPlayer seekToTime:CMTimeMakeWithSeconds(time+[songRec.delay doubleValue], NSEC_PER_SEC)];
                                             }*/
                                        }
                                        
                                    }
                                }
                                
                                if (!timeObserver)
                                {
                                    CMTime playerDuration = [self playerItemDuration];
                                    if (CMTIME_IS_INVALID(playerDuration))
                                    {
                                        return;
                                    }
                                    
                                    double duration = CMTimeGetSeconds(playerDuration);
                                    if (isfinite(duration))
                                    {
                                        CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
                                        /// double tolerance = 0.2f;// * duration / width;
                                        // if (tolerance > 0.1) tolerance=0.1;
                                        // if (tolerance < 0.05) tolerance= 0.05;
                                        timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                                        ^(CMTime time)
                                                        {
                                                            [self syncScrubber];
                                                        }];
                                        if ([Language hasSuffix:@"kara"] && (((playRecUpload || playTopRec) &&!playVideoRecorded) || (playRecord && playVideoRecorded)) && audioPlayer){
                                            
                                        }
                                    }
                                }
                                /*if (restoreAfterScrubbingRate)
                                 {
                                 [playerMain setRate:restoreAfterScrubbingRate];
                                 
                                 if  (playRecord && playVideoRecorded) {
                                 [audioPlayer setRate:restoreAfterScrubbingRate];
                                 
                                 }
                                 restoreAfterScrubbingRate = 0.f;
                                 }*/
                                if (!VipMember ) {
                                    [self performSelector:@selector(playAfterScruber) withObject:nil afterDelay:0.2];
                                    
                                }
                                //   [self checkPlaying];
                                //. [playerMain play];
                                //. if ([Language hasSuffix:@"kara"] && (playRecUpload || playTopRec) && audioPlayer && [self isPlaying] ) [audioPlayer play];
                            }
                      
                        //[playerMain setRate:1.0f];
                        //[audioPlayer setRate:1.0f];
                        //[audioPlayer play];
                        //[playerMain play];
                    }
                }else if ((playRecUpload|| playTopRec ) && !playVideoRecorded){
                    if ((fabs(CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([playerMain currentTime])) > timeLech ) &&(fabs(CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([[audioPlayer currentItem] duration]))) > 5 && CMTimeGetSeconds([audioPlayer currentTime]) >  2  && [playerMain rate]!=0.f) {
                        [audioPlayer pause];
                        [playerMain pause];
                        if (isKaraokeTab ){
                            [self performSelectorOnMainThread:@selector(showLoading) withObject:nil waitUntilDone:NO];
                        }
                        NSLog(@"audio: %f",CMTimeGetSeconds([audioPlayer currentTime]));
                        NSLog(@"playerVideo: %f",CMTimeGetSeconds([playerMain currentTime]));
                        [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                        [audioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                        NSLog(@"audio 1: %f",CMTimeGetSeconds([audioPlayer currentTime]));
                        NSLog(@"playerVideo 1: %f",CMTimeGetSeconds([playerMain currentTime]));
                    }
                }
            }
        }
        
    }
}
- (void) dongboPlayerAndAudio:(NSNumber *) timeN{
    double time=[timeN doubleValue];
    isTapSlider=YES;
    restoreAfterScrubbingRate = [playerMain rate];
    [playerMain pause];
    if (audioPlayRecorder) {
        //[audioPlayRecorder setRate:0.f];
        if ([audioPlayRecorder isPlaying]) [audioPlayRecorder pause];
    }
    if (audioPlayer  && ((!playVideoRecorded && [Language hasSuffix:@"kara"] &&(playTopRec || playRecUpload)) || (playRecord && playVideoRecorded))){
        [audioPlayer pause];
        //if ([audioPlayer rate]!=0) [audioPlayer pause];
    }
    /* Remove previous timer. */
    [self removePlayerTimeObserver];
    
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    
    if (isfinite(duration))
    {
        
        
       
        
        
        [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
        if (audioPlayer && (playRecUpload || playTopRec ) && !playVideoRecorded && ![Language hasSuffix:@"kara"]) {
            [audioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
            
            
        }
     
        if (playRecord) {
            if (playVideoRecorded && audioPlayer){
                
                //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                [audioPlayer seekToTime:CMTimeMakeWithSeconds(time+[songRec.delay doubleValue]/1000.0f, NSEC_PER_SEC)];
                
            }
            else{
                //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                if (time+[songRec.delay doubleValue]/1000.0f<audioPlayRecorder.duration){
                    audioPlayRecorder.currentTime=time+[songRec.delay doubleValue]/1000.0f;
                    
                }
               
            }
        }
    }
    
    if (!timeObserver)
    {
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
            /// double tolerance = 0.2f;// * duration / width;
            // if (tolerance > 0.1) tolerance=0.1;
            // if (tolerance < 0.05) tolerance= 0.05;
            if (!playRecord) {
                timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                ^(CMTime time)
                                {
                                    [self syncScrubber];
                                }];
            }
            
            if ([Language hasSuffix:@"kara"] && playRecord && audioPlayer){
                timeObserver2 = [audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                 ^(CMTime time)
                                 {
                                     //[self checkPlaying];
                                     [self syncScrubber2];
                                 }];
            }
        }
    }
    if (restoreAfterScrubbingRate)
    {
        [playerMain setRate:restoreAfterScrubbingRate];
        
        if (audioPlayer  && (((playRecUpload || playTopRec) &&!playVideoRecorded && [Language hasSuffix:@"kara"]) || (playRecord && playVideoRecorded))) {
            
            if (restoreAfterScrubbingRate!=0) {
                [audioPlayer play];
            }
        }else
            if (audioPlayRecorder && playRecord &&  (CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f<audioPlayRecorder.duration)){
                if (restoreAfterScrubbingRate!=0) {
                    [audioPlayRecorder play];
                }
                
            }
        if (duetVideoPlayer && fabs( CMTimeGetSeconds([playerMain currentTime])-CMTimeGetSeconds([duetVideoPlayer currentTime]))>0.4 && (CMTimeGetSeconds([playerMain currentTime]))<CMTimeGetSeconds([duetVideoPlayer.currentItem duration])) {
            [duetVideoPlayer pause];
            [duetVideoPlayer seekToTime:playerMain.currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                [duetVideoPlayer play];
            }];
           
           
            
        }
        restoreAfterScrubbingRate = 0.f;
    }
    isTapSlider=NO;
}
- (void) dongboPlayerAndAudio{
    restoreAfterScrubbingRate = [playerMain rate];
    
    // [playerMain setRate:0.0f];
    //[audioPlayer setRate:0.0f];
    
    [playerMain pause];
    [audioPlayer pause];
    [self removePlayerTimeObserver];
    /* Remove previous timer. */
    double time1 =CMTimeGetSeconds([playerMain currentTime]);
    
    
    // [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    [audioPlayer seekToTime:CMTimeMakeWithSeconds(time1+[songRec.delay doubleValue]/1000.0f, NSEC_PER_SEC)];
    if (!timeObserver)
    {
        timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                        ^(CMTime time)
                        {
                            [self syncScrubber];
                        }];
    }
    if (restoreAfterScrubbingRate)
    {
        [playerMain setRate:restoreAfterScrubbingRate];
        
        [audioPlayer setRate:restoreAfterScrubbingRate];
        
        
        restoreAfterScrubbingRate = 0.f;
    }
    if (!VipMember ) {
       // [self performSelector:@selector(playAfterScruber) withObject:nil afterDelay:0.3];
        
    }
}
- (void) playAfterScruber{
    @autoreleasepool {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        if (restoreAfterScrubbingRate)
        {
            [playerMain setRate:restoreAfterScrubbingRate];
            
            if  (playRecord && playVideoRecorded) {
                [audioPlayer play];
                
            }
            if  (playRecord && !playVideoRecorded && audioPlayRecorder) {
                [audioPlayRecorder play];
                
            }
            restoreAfterScrubbingRate = 0.f;
             NSLog(@"dong bo player                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       %f lech  %f audio %f",CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0f-CMTimeGetSeconds([audioPlayer currentTime]),CMTimeGetSeconds([audioPlayer currentTime]));
        }
        });
    }
}
- (IBAction)privacyChange:(id)sender {
    if (privacyRecordingisPrivate) {
        privacyRecordingisPrivate=NO;
        [[NSUserDefaults standardUserDefaults] setBool:privacyRecordingisPrivate forKey:@"privacyRecordingisPrivate"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.privacyTickerImage.image=[UIImage imageNamed:@"da_check.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        });
    }else {
        privacyRecordingisPrivate=YES;
        [[NSUserDefaults standardUserDefaults] setBool:privacyRecordingisPrivate forKey:@"privacyRecordingisPrivate"];
        dispatch_async(dispatch_get_main_queue(),^{
            self.privacyTickerImage.image=[UIImage imageNamed:@"khong_checked.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        });
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) dongbo{
    NSLog(@"%fplayer 3 %f audio  %f and %f",time,CMTimeGetSeconds([playerMain currentTime]),CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000.0,CMTimeGetSeconds([audioPlayer currentTime]));
    [audioPlayer  seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
  
}
/* Requests invocation of a given block during media playback to update the
 movie scrubber control. */
-(void)initScrubberTimer
{
    
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
        //interval = 0.2f ;//* duration / width;
    }
    if ([Language hasSuffix:@"karaokestar"]) {
        [self updateLyric];
    }
    [self syncScrubber];
    //if (interval > 0.1) interval=0.1;
    ///if (interval < 0.05) interval=0.05;
    /* Update the scrubber during normal playback. */
    if (!timeObserver && !playRecord) {
        timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC)
                                                                queue:NULL
                                                           usingBlock:
                        ^(CMTime time)
                        {
                            [self syncScrubber];
                        }];
    }
    if ( checkPlaying==nil && !playRecord)
        checkPlaying=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPlaying1) userInfo:nil repeats:YES];
    
    
    
}
-(void)initScrubberTimer2
{
    
    
    CMTime playerDuration = [self playerItemDuration2];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
        //interval = 0.2f ;//* duration / width;
    }
    //if (interval > 0.1) interval=0.1;
    ///if (interval < 0.05) interval=0.05;
    /* Update the scrubber during normal playback. */
    if (!timeObserver2  && playRecord) {
        timeObserver2 = [audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC)
                                                                queue:NULL
                                                           usingBlock:
                        ^(CMTime time)
                        {
                            [self syncScrubber2];
                        }];
    }
    
    
    
    if ( checkPlaying==nil && playRecord)
        checkPlaying=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPlaying1) userInfo:nil repeats:YES];
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
    if (timeObserver)
    {
        [playerMain removeTimeObserver:timeObserver];
        timeObserver = nil;
    }
    if (timeObserver2)
    {
        [audioPlayer removeTimeObserver:timeObserver2];
        timeObserver2 = nil;
    }
}
-(void)removePlayerTimeObserver2
{
    if (timeObserver2)
    {
        [audioPlayer removeTimeObserver:timeObserver2];
        timeObserver2 = nil;
    }
}
/* The user is dragging the movie controller thumb to scrub through the movie. */
- (IBAction)beginScrubbing:(id)sender
{
    if (!isrecord) {
        restoreAfterScrubbingRate = [audioPlayer rate];
        if (playerMain) {
            [playerMain pause];
        }
     
        
        if (audioPlayer && playRecord){
            // if ([audioPlayer rate]!=0) [audioPlayer pause];
            [audioPlayer pause];
            
        }
        /* Remove previous timer. */
       // [self removePlayerTimeObserver];
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (IBAction)endScrubbing:(UISlider*)sender
{
    if (!isrecord) {
        /*if (!timeObserver)
        {
            CMTime playerDuration = [self playerItemDuration2];
            if (CMTIME_IS_INVALID(playerDuration))
            {
                return;
            }
            
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration))
            {
                CGFloat width = CGRectGetWidth([sender bounds]);
                
                ///double tolerance = 0.2f;// * duration / width;
                
                if (!playRecord && playerMain) {
                    timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                    ^(CMTime time)
                                    {
                                        [self syncScrubber];
                                    }];
                }
                
                if ([Language hasSuffix:@"kara"]&& playRecord  && audioPlayer){
                    timeObserver2 = [audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                     ^(CMTime time)
                                     {
                                         //[self checkPlaying];
                                         [self syncScrubber2];
                                     }];
                }
            }
        }*/
        
        if (restoreAfterScrubbingRate)
        {
            if (playerMain) {
                [playerMain setRate:restoreAfterScrubbingRate];
            }
            
          
            if (audioPlayer && playRecord){
                [audioPlayer setRate:restoreAfterScrubbingRate];
            }
            restoreAfterScrubbingRate = 0.f;
        }
        if (VipMember && playRecord  ) {
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            
            dispatch_async(queue, ^{
               [self sendUPDATESTREAM:CMTimeGetSeconds([audioPlayer currentTime])];
            });
        }
        //. [playerMain play];
        [self checkPlaying1];
    }
}

/* Set the player current time to match the scrubber position. */
- (IBAction)scrub:(id)sender
{
    if (!isrecord) {
        if ([sender isKindOfClass:[UISlider class]])
        {
            UISlider* slider = sender;
            
            CMTime playerDuration = [self playerItemDuration2];
            if (CMTIME_IS_INVALID(playerDuration)) {
                return;
            }
            
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration))
            {
                float minValue = [slider minimumValue];
                float maxValue = [slider maximumValue];
                float value = [slider value];
                
                double time = duration * (value - minValue) / (maxValue - minValue);
                if (playerMain) {
                    [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                }
                
                if (audioPlayer && playRecord ) [audioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
               
            }
        }
    }
}

- (BOOL)isScrubbing
{
    return restoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
    self.movieTimeControl.enabled = YES;
    if ([songRec.performanceType isEqualToString:@"SOLO" ]) {
        //self.progressBuffer.hidden=NO;
    }
                   });
}

-(void)disableScrubber
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
    self.progressBuffer.hidden=YES;
    self.movieTimeControl.enabled = NO;
                   });
}

/* Prevent the slider from seeking during Ad playback. */
- (void)sliderSyncToPlayerSeekableTimeRanges
{
    NSArray *seekableTimeRanges = [[playerMain currentItem] seekableTimeRanges];
    if ([seekableTimeRanges count] > 0)
    {
        NSValue *range = [seekableTimeRanges objectAtIndex:0];
        CMTimeRange timeRange = [range CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        /* Set the minimum and maximum values of the time slider to match the seekable time range. */
        movieTimeControl.minimumValue = startSeconds;
        movieTimeControl.maximumValue = startSeconds + durationSeconds;
    }
}
#define TAG_WELCOME 10
#define TAG_CAPABILITIES 11
#define TAG_MSG 12
#pragma mark - Stream Socket

- (void) setupAssynSocket{
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
	
    if (![socket connectToHost:streamSV onPort:9090 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
    }
    //[socket acceptOnPort:9090 error:nil];
}
- (void) reconnectAssynSocket{
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![socket connectToHost:@"data.ikara.co" onPort:9090 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
    }
    streamSV=@"data.ikara.co";
    //[socket acceptOnPort:9090 error:nil];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    streamSVIsConnect=NO;
    if (isKaraokeTab) {
        
    
     dispatch_async(dispatch_get_main_queue(), ^{
         alertDisconnectStream=[UIAlertController alertControllerWithTitle:@"Kết nối bị ngắt"
                                                                       message:@"Kết nối với server bị ngắt. Vui lòng mở lại bài thu!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
         {
             /** What we write here???????? **/
             if (audioPlayRecorder) {
                 [audioPlayRecorder pause];
             }
             if (audioPlayer) {
                 if ([audioPlayer rate]!=0) {
                     [audioPlayer pause];
                 }
             }
             if (playerMain) {
                 if ([self isPlaying]) {
                     [playerMain pause];
                 }
             }
             if (duetVideoPlayer) {
                 if ([duetVideoPlayer rate]!=0) {
                     [duetVideoPlayer pause];
                 }
             }
             if (isVoice  && audioEngine2) {
                 [audioEngine2 playthroughSwitchChanged:NO];
                 [audioEngine2 reverbSwitchChanged:NO];
                 [audioEngine2 expanderSwitchChanged:NO];
             }
             if (audioEngine2.audioController.running) {
                 [audioEngine2 stopP];
                 
             }
             streamPlay=NO;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
             });
         }];
        NSLog(@"stream disconnect");
         [alertDisconnectStream addAction:yesButton];
         
         
         [self presentViewController:alertDisconnectStream animated:YES completion:nil];
     });
    }
}
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    [socket readDataWithTimeout:-1 tag:0];
    NSLog(@"Cool, I'm connected! That was easy.");
    streamSVIsConnect=YES;
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 1){
        NSLog(@"Destroy request sent");
    }
    else if (tag == 2){
        NSLog(@"Create request sent");
    }
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)dataT withTag:(long)tag
{
    
    
    NSMutableData *result;
    NSMutableData *data=[NSMutableData dataWithData:dataT];
    
    NSString *received;
    
    short size=0;
    NSInteger leng=[data length];
    
    
    do {
        char* bytes=(char *)[data bytes];
        u.bytes[0]=bytes[1];
        u.bytes[1]=bytes[0];
        size=u.s;
        leng=[data length];
        //  NSLog(@"socket read data %ld and size %d",leng,size);
        if (size<=0 || leng<size+1) {
            break;
        }
        short status=(short)bytes[2];
        
            if (status==0||status==1 ) {//bo 3 byte dau
                NSRange range =NSMakeRange(3, size-1);
                
                
                
                
                //result=[[NSMutableData alloc] initWithBytes:bytes length:size+2];
                result=[data subdataWithRange:range];
                [data replaceBytesInRange:NSMakeRange(0, size+2) withBytes:nil length:0];
                received=[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                if (received.length<=0) {
                    NSLog(@"data audio");
                }
                NSLog(@"received %@",received);
                Response *getSongResponse = [[Response alloc] initWithString:received error:nil];
                if ([getSongResponse.message isKindOfClass:[NSString class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.loadingLabelVip.text=getSongResponse.message;
                    });
                }
                if ([getSongResponse.status isKindOfClass:[NSString class]]) {
                    if ([getSongResponse.status isEqualToString:@"READY"] && isKaraokeTab) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            streamIsPlay=YES;
                            isPlayingAu=YES;
                            if (audioPlayer.rate==0) {
                                [audioPlayer play];
                            }
                            if (playerYoutubeVideoTmp.rate==0) {
                                [playerYoutubeVideoTmp play];
                            }
                            
                            [isLoading setHidden:YES];
                            /* Show the movie slider control since the movie is now ready to play. */
                            if (movieTimeControl.isEnabled==NO) {
                             
                                    playerMain.muted=YES;
                         
                                if (movieTimeControl.isHidden) {
                                    movieTimeControl.hidden = NO;
                                }
                                
                            }
                            [self enableScrubber];
                            [self enablePlayerButtons];
                            self.loadingViewVIP.hidden=YES;
                            self.loadingViewVIP2.hidden=YES;
                            self.isLoading.center=self.playerLayerView.center;
                         
                            if (demperc) {
                                [demperc invalidate];
                                demperc=nil;
                            }
                        });
                    }else if([getSongResponse.status isEqualToString:@"ERROR"] && isKaraokeTab){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            streamIsPlay=NO;
                            isPlayingAu=YES;
                            if (audioPlayer.rate==0) {
                                [audioPlayer play];
                            }
                            if (playerYoutubeVideoTmp.rate==0) {
                                [playerYoutubeVideoTmp play];
                            }
                            audioPlayer.muted=NO;
                            [_audioTapProcessor updateVolumeVideo:(int)(powf((float)[songRec.effectsNew.vocalVolume intValue]/100,1.6666)*100) ];
                            [_audioTapProcessor updateVolumeAudio:(int)(powf((float)[songRec.effectsNew.beatVolume intValue]/100,1.6666)*100) ];
                            maxV=0;
                            [_audioTapProcessor setDelay:[songRec.delay intValue] ];
                            [_audioTapProcessor setEffect:[[karaokeEffect.parameters objectForKey:@"ECHO"] intValue] andBass:[[karaokeEffect.parameters objectForKey:@"BASS"] intValue] andTreble:[[karaokeEffect.parameters objectForKey:@"TREBLE"] intValue]];
                            [isLoading setHidden:YES];
                            /* Show the movie slider control since the movie is now ready to play. */
                            if (movieTimeControl.isEnabled==NO) {
                                
                                playerMain.muted=YES;
                                
                                if (movieTimeControl.isHidden) {
                                    movieTimeControl.hidden = NO;
                                }
                                
                            }
                            [self enableScrubber];
                            [self enablePlayerButtons];
                            self.loadingViewVIP.hidden=YES;
                            self.loadingViewVIP2.hidden=YES;
                            self.isLoading.center=self.playerLayerView.center;
                            
                            if (demperc) {
                                [demperc invalidate];
                                demperc=nil;
                            }
                        });
                    }
                }
            }else  if (status==2 || status==3){//bỏ 26 byte đầu 2 byte lenght,  1 byte phân type,8 byte possition,8 byte HASH và 7 byte header AAC
                kieuL.longs[0]=bytes[10];
                kieuL.longs[1]=bytes[9];
                kieuL.longs[2]=bytes[8];
                kieuL.longs[3]=bytes[7];
                kieuL.longs[4]=bytes[6];
                kieuL.longs[5]=bytes[5];
                kieuL.longs[6]=bytes[4];
                kieuL.longs[7]=bytes[3];
                
                NSRange range =NSMakeRange(0, size+2);//NSMakeRange(26, size-24);
                
                
                
                
                //result=[[NSMutableData alloc] initWithBytes:bytes length:size+2];
                result=[NSMutableData dataWithData: [data subdataWithRange:range]];
                [data replaceBytesInRange:NSMakeRange(0, size+2) withBytes:nil length:0];
                // [self decodeAudioFrame:result withPts:kieuL.l];
                
                [ringBufferData enqObject:result];
                if (ringBufferData.count>480 || [self timeBuffer]>10*44100/1024) {
                    [self sendPauseSTREAM];
                }
            }else  if (status==3){//bỏ 17 byte đầu là 1 byte phân type,8 byte possition,8byte hash
                kieuL.longs[0]=bytes[10];
                kieuL.longs[1]=bytes[9];
                kieuL.longs[2]=bytes[8];
                kieuL.longs[3]=bytes[7];
                kieuL.longs[4]=bytes[6];
                kieuL.longs[5]=bytes[5];
                kieuL.longs[6]=bytes[4];
                kieuL.longs[7]=bytes[3];
                NSLog(@"audio data %d posstion %lld",(short)bytes[2],kieuL.l);
                NSRange range =NSMakeRange(19, size-17);
                
                
                
                
                //result=[[NSMutableData alloc] initWithBytes:bytes length:size+2];
                result=[data subdataWithRange:range];
                [data replaceBytesInRange:NSMakeRange(0, size+2) withBytes:nil length:0];
                [self decodeAudioFrame:result withPts:kieuL.l];
            }else{
                break;
            }
        bytes=(char *)[data bytes];
        u.bytes[0]=bytes[1];
        u.bytes[1]=bytes[0];
        size=u.s;
        leng=[data length];
    } while(leng>size+1 && size>0)    ;
    
     //NSLog(@"Start read data %ld and size %d",leng,size);
    [socket readDataWithTimeout:-1 tag:0];
}

- (void) processDataAudio{
    @autoreleasepool{
        while (YES) {
            if (!isKaraokeTab) {
                return;
            }
            
            if (ringBufferData.count>0) {
                //pop data ra va xu ly data
                NSMutableData *data=(NSMutableData *)[ringBufferData deqObject];
                if ([data isKindOfClass:[NSMutableData class]]) {
                    if (data.length>26) {
                        
                        
                        NSRange range =NSMakeRange(26, data.length-26);
                        char* bytes=(char *)[data bytes];
                        NSMutableData *result=[NSMutableData dataWithData:[data subdataWithRange:range]];
                        kieuL.longs[0]=bytes[10];
                        kieuL.longs[1]=bytes[9];
                        kieuL.longs[2]=bytes[8];
                        kieuL.longs[3]=bytes[7];
                        kieuL.longs[4]=bytes[6];
                        kieuL.longs[5]=bytes[5];
                        kieuL.longs[6]=bytes[4];
                        kieuL.longs[7]=bytes[3];
                        hashL.longs[0]=bytes[18];
                        hashL.longs[1]=bytes[17];
                        hashL.longs[2]=bytes[16];
                        hashL.longs[3]=bytes[15];
                        hashL.longs[4]=bytes[14];
                        hashL.longs[5]=bytes[13];
                        hashL.longs[6]=bytes[12];
                        hashL.longs[7]=bytes[11];
                        //   NSLog(@"audio data %d posstion %lld %d %d",(short)bytes[2],kieuL.l,( short)bytes[19],( short)bytes[20]);
                        int curr=(int)(kieuL.l/1024);
                        if (curr<15500 && curr>=0) {
                            dataHash[curr]=hashL.l;
                            [self decodeAudioFrame:result withPts:kieuL.l];
                        }
                        
                        
                    }
                }
                
            }else{
                [NSThread sleepForTimeInterval:0.05f];
            }
        }
    }
}
- (long) timeBuffer{
    long timeBuffe=0;
    long curr=0;
    curr=CMTimeGetSeconds(audioPlayer.currentTime)*44100/1024;
    while (curr<15504) {
        if (dataHash[curr]!=hashEffect ||dataHash[curr]==0 ) {
            break;
        }
        timeBuffe++;
        curr++;
    }
    //timeBuffe=curr*1024/44100.0;
    
    return timeBuffe;
}
- (void) checkRing{
    @autoreleasepool{
        if (ringBufferData.count<10 && svPause && streamSVIsConnect)
        {
            if ([self timeBuffer]<5*44100/1024) {
                
                    [self sendUPDATESTREAM:-1];
                
            }
        }
        if (isPlayingAu && audioPlayer.rate==0 ) {
            long timeL=[self timeBuffer];
            
            if (timeL>2*44100/1024) {
                
                if (audioPlayer.rate==0) {
                    [audioPlayer play];
                    streamIsPlay=YES;
                    if (playerYoutubeVideoTmp) {
                        if (playerYoutubeVideoTmp.rate==0) {
                            [playerYoutubeVideoTmp play];
                        }
                    }
                }
                
            }else{
                demBuffer++;
                if (demBuffer>5&& [self timeBuffer]<44100/1024 && streamSVIsConnect) {
                    if (CMTimeGetSeconds(audioPlayer.currentTime)>0.5){
                        demBuffer=0;
                        NSLog(@"time buffer %ld",[self timeBuffer]);
                        [self sendUPDATESTREAM:CMTimeGetSeconds(audioPlayer.currentTime)];
                        
                    }
                    
                }
                
            }
        }
        if (!streamSVIsConnect) {
            demConnect++;
            if (demConnect>3) {
                demConnect=0;
                [self reconnectAssynSocket];
                [self performSelector:@selector(sendCREATSTREAM) withObject:nil afterDelay:1];
            }
        }
        if (!isKaraokeTab) {
            return;
        }
        [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.4];
    }
}

- (void) sendDestroy{
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original =[[LoadData2 alloc] getParaDestroyStream:streamName andEffect:songRec];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:1];
}

- (void) sendUPDATESTREAM:(double) position {
    if (position>=0) {
        demBuffer=0;
    }
    
    NSLog(@"sendUPDATESTREAM pos %f",position);
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original =[[LoadData2 alloc] getParaUpdateStream:streamName andPosition:position andRecord:songRec];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:2];
    if (position>=0) {
         [ringBufferData removeAllObjects];
    }
   
    svPause=NO;
}
- (void) sendUPDATESTREAM2:(long) position {
    
        demBuffer=0;
    
    
    NSLog(@"sendUPDATESTREAM pos %ld",position);
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original =[[LoadData2 alloc] getParaUpdateStream2:streamName andPosition:position andRecord:songRec];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:2];
    if (position>=0) {
        [ringBufferData removeAllObjects];
    }
    
    svPause=NO;
}
- (void) sendDoNothingStream{
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original = [[LoadData2 alloc] getParaDoNoThingStream:streamName];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) sendCREATSTREAM{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath;
    if ([songRec.recordingType isEqualToString:@"VIDEO"]) {
         filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
    }else{
         filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
    }
   
    NSURL *audioFileURL= [NSURL fileURLWithPath:filePath];
    if (songRec->isExportVideo && (isExportingVideo|| isExportingVideoWithEffect)) {
         [NSThread detachNewThreadSelector:@selector(loadMovie2:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songRec.vocalUrl]];
    }else
    [NSThread detachNewThreadSelector:@selector(loadMovie2:) toTarget:self withObject:[NSString stringWithFormat:@"%@",audioFileURL]];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original = [[LoadData2 alloc] getParaCreateStream:streamName andParameter:songRec];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) sendPauseSTREAM{
    if (svPause) {
        return;
    }
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longLongValue];
    NSString *original = [[LoadData2 alloc] getParaPauseStream:streamName andRecord:songRec];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length];
    // char* head=(char *)&len;
    unsigned char byte_arr[2] ;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:2];
    [socket writeData:data withTimeout:-1 tag:2];
    NSLog(@"Pause data stream");
    svPause=YES;
}
- (void)setupAudioConverter{
    /*AudioStreamBasicDescription outFormat;
     memset(&outFormat, 0, sizeof(outFormat));
     outFormat.mSampleRate       = 44100;
     outFormat.mFormatID         = kAudioFormatLinearPCM;
     outFormat.mFormatFlags      = kLinearPCMFormatFlagIsSignedInteger;
     
     outFormat.mFramesPerPacket  = 1;
     outFormat.mChannelsPerFrame = 2;
     outFormat.mBytesPerFrame    = outFormat.mChannelsPerFrame * sizeof(int);
     outFormat.mBytesPerPacket   =  outFormat.mFramesPerPacket * outFormat.mBytesPerFrame;
     outFormat.mBitsPerChannel   = 32;
     outFormat.mReserved         = 1;*/
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;   // GIVE YOUR SAMPLING RATE
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mBitsPerChannel = sizeof(float) * 8;
    audioFormat.mChannelsPerFrame = 2; // Mono
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * sizeof(float);  // == sizeof(Float32)
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame;
    
    AudioStreamBasicDescription inFormat;
    memset(&inFormat, 0, sizeof(inFormat));
    inFormat.mSampleRate        = 44100;
    inFormat.mFormatID          = kAudioFormatMPEG4AAC;
    inFormat.mFormatFlags       = kMPEG4Object_AAC_LC;
    inFormat.mBytesPerPacket    = 0;
    inFormat.mFramesPerPacket   = 1024;
    inFormat.mBytesPerFrame     = 0;
    inFormat.mChannelsPerFrame  = 2;
    inFormat.mBitsPerChannel    = 0;
    inFormat.mReserved          = 0;
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destinationFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Output.caf"]];
    _destinationURL = [NSURL fileURLWithPath:destinationFilePath];
    UInt32 size ;
    /*if (![self checkError:ExtAudioFileCreateWithURL((__bridge CFURLRef _Nonnull)(self.destinationURL), kAudioFileCAFType, &audioFormat, NULL, kAudioFileFlags_EraseFile, &destinationFile) withErrorString:@"ExtAudioFileCreateWithURL failed!"]) {
     return;
     }*/
    if (![self checkError:AudioFileOpenURL((__bridge CFURLRef _Nonnull)(self.destinationURL),kAudioFileReadWritePermission,0, &destinationFile) withErrorString:[NSString stringWithFormat:@"ExtAudioFileOpenURL failed for destinationFile with URL: %@", self.destinationURL]]) {
        return ;
    }
    AudioStreamBasicDescription clientFormat =audioFormat;
    size = sizeof(clientFormat);
    OSStatus result = 0;
    result = AudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
    if(result != noErr)
        NSLog(@"error on ExtAudioFileSetProperty for output File with result code %i \n", result);
   /* ExtAudioFileRef sourceFile = 0;
    NSString *path = [[NSBundle mainBundle]                                                                          pathForResource:@"vocal-server" ofType:@"m4a"];
    if (![self checkError:ExtAudioFileOpenURL((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &sourceFile) withErrorString:[NSString stringWithFormat:@"ExtAudioFileOpenURL failed for sourceFile with URL: %@", [NSURL fileURLWithPath:path]]]) {
        return ;
    }
    AudioStreamBasicDescription sourceFormat = {};
    size = sizeof(sourceFormat);
    if (![self checkError:ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileDataFormat, &size, &sourceFormat) withErrorString:@"ExtAudioFileGetProperty couldn't get the source data format"]) {
        return ;
    }*/
    OSStatus status =  AudioConverterNew(&inFormat, &audioFormat, &_audioConverter);
    if (status != 0) {
        printf("setup converter error, status: %i\n", (int)status);
    }
}
- (BOOL)checkError:(OSStatus)error withErrorString:(NSString *)string {
    if (error == noErr) {
        return YES;
    }
    
    
    return NO;
}
- (void )decodeAudioFrame:(NSData *)frame withPts:(SInt64)pts{
    if(!_audioConverter){
        [self setupAudioConverter];
    }
    AudioStreamPacketDescription packetDescription;
    memset(&packetDescription, 0, sizeof(AudioStreamPacketDescription));
    packetDescription.mStartOffset=0;
    packetDescription.mDataByteSize=(UInt32)frame.length;
    packetDescription.mVariableFramesInPacket=0;
    PassthroughUserData userData = { 2, (UInt32)frame.length, [frame bytes],packetDescription};
    
    
    const uint32_t MAX_AUDIO_FRAMES = 128;
    const uint32_t maxDecodedSamples = MAX_AUDIO_FRAMES * 1;
    float *buffer = (float *)malloc(maxDecodedSamples * sizeof(float));
    AudioBufferList decBuffer;
    decBuffer.mNumberBuffers = 1;
    decBuffer.mBuffers[0].mNumberChannels = 2;
    decBuffer.mBuffers[0].mDataByteSize = maxDecodedSamples * sizeof(float);
    decBuffer.mBuffers[0].mData = buffer;
    UInt32 numFrames = MAX_AUDIO_FRAMES;
    
    AudioStreamPacketDescription outPacketDescription;
    memset(&outPacketDescription, 0, sizeof(AudioStreamPacketDescription));
    SInt64 tell=pts*8;
    OSStatus result;//= ExtAudioFileSeek(destinationFile, pts);
    // AudioFileTell(destinationFile, &tell);
    // NSLog(@"position des %lld",tell);
    
    do{
        
        
        OSStatus rv = AudioConverterFillComplexBuffer(_audioConverter,
                                                      inInputDataProc,
                                                      &userData,
                                                      &numFrames /* in/out */,
                                                      &decBuffer,
                                                      &outPacketDescription);
        
        NSError *error = nil;
        //  NSLog(@"error code %d %d",rv,numFrames);
        if (rv  ==222 ){
            break;
        }else if( rv==0) {
            // NSLog(@"%u bytes decoded", (unsigned int)decBuffer.mBuffers[0].mDataByteSize);
            UInt32 numByte=decBuffer.mBuffers[0].mDataByteSize;
            result = AudioFileWriteBytes(destinationFile,false,tell,
                                         &numByte,
                                         decBuffer.mBuffers[0].mData);
            tell+=numByte;
            if(result!= noErr){
                NSLog(@"ExtAudioFileWrite failed with code %i \n", result);
            }
            //[decodedData appendData:[NSData dataWithBytes:decBuffer.mBuffers[0].mData length:decBuffer.mBuffers[0].mDataByteSize]];
            
        } else {
            error = [NSError errorWithDomain:NSOSStatusErrorDomain code:rv userInfo:nil];
            break;
        }
        
        
        
        
        
    }while (true);
    //NSLog(@"position des %lld",tell);
    free(buffer);
    
    // return decodedData;
    //audioRenderer->Render(&pData, decodedData.length, pts);
}
- (void)createSilentPCMFileWithDuration:(NSNumber *) duration {
    double timeC=CACurrentMediaTime();
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destinationFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Output.caf"]];
    NSURL *fileURL =[NSURL fileURLWithPath:destinationFilePath];
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath];
    if (haveS) {
        //return;
    }
    AudioFileID mRecordFile;
    
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;   // GIVE YOUR SAMPLING RATE
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mBitsPerChannel = sizeof(float) * 8;
    audioFormat.mChannelsPerFrame = 2; // Mono
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * sizeof(float);  // == sizeof(Float32)
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame;
    
    OSStatus status = AudioFileCreateWithURL((__bridge CFURLRef)fileURL, kAudioFileCAFType, &audioFormat, kAudioFileFlags_EraseFile, &mRecordFile);
    
    double intervalInSamples = 0.5;
    intervalInSamples *= audioFormat.mSampleRate * audioFormat.mChannelsPerFrame;
    
    int beatsToRecord = [duration intValue]; //seconds of silence
    UInt32 inNumberFrames = (intervalInSamples * beatsToRecord);
    
    float frameBuffer[44100];
    
    for (int i = 0; i < 44100; i++) { frameBuffer[i] = 0; }
    
    
    for (int i = 0; i < beatsToRecord; i++) {
        UInt32 bytesToWrite = 44100 * sizeof(float);
        status = AudioFileWriteBytes(mRecordFile, false, 44100*i, &bytesToWrite, &frameBuffer);
        if (status!=noErr) {
            NSLog(@"create error");
        }
    }
    status = AudioFileClose(mRecordFile);
    
    NSAssert(status == noErr, @"");
    NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:fileURL.path error:nil];
    unsigned long long filesize=[fileinfo fileSize];
    
    NSLog(@"%f Size des file : %0.2f MB",CACurrentMediaTime()-timeC,filesize/1024.0/1024.0);
    // Cleanup
}
- (void) processMixOffline:(Recording *)tmp{
    @autoreleasepool {
        if ([[LoadData2 alloc] checkNetwork] && !uploadProssesing) {
            mixOfflineProssesing=YES;
            NSLog(@"Start mix ofline");
            vitriuploadRec=(int)[dataRecord indexOfObject:tmp];
            tmp->isConvert=YES;
            bgMixTask= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"MixTask" expirationHandler:^{
                // Clean up any unfinished task business by marking where you
                // stopped or ending the task outright.
                [[UIApplication sharedApplication] endBackgroundTask:bgMixTask];
                bgMixTask = UIBackgroundTaskInvalid;
            }];
            
            // Start the long-running task and return immediately.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                //dispatch_async(queue, ^{
                ExtendedAudioFileConvertOperation *operation;
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath;
                do {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                while (isExportingVideo || isExportingVideoWithEffect);
                if ([tmp.vocalUrl isKindOfClass:[NSString class]]){
                    if ([tmp.vocalUrl hasSuffix:@"mov"]|| [tmp.vocalUrl hasSuffix:@"mp4"]){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]];
                        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                        if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",tmp.recordingTime]];
                        
                    }
                    else {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",tmp.recordingTime]];
                        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                        if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",tmp.recordingTime]];
                    }
                }else{
                    if ([tmp.recordingType isEqualToString:@"AUDIO"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",tmp.recordingTime]];
                        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                        if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",tmp.recordingTime]];
                    }else{
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]];
                        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                        if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",tmp.recordingTime]];
                    }
                }
                NSString *mp3Path;
                
                mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",tmp.song._id]];
                if ([tmp.song.songUrl isKindOfClass:[NSString class]])
                    if ([tmp.song.songUrl hasSuffix:@"m4a"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",tmp.song._id]];
                    }
                if (tmp.song.videoId.length>2){
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",tmp.song.videoId]];
                    
                }
                if ([tmp.performanceType isEqualToString:@"DUET"]) {
                    mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",tmp.originalRecording]];
                }
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:mp3Path];
                if (!haveS) {
                    mixOfflineProssesing=NO;
                    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                    bgTask = UIBackgroundTaskInvalid;
                    uploadProssesing = NO;
                    [self uploadFileToServerIkara:tmp];
                    return;
                }
                if (filePath.length==0) {
                    tmp->isConvert=NO;
                    mixOfflineProssesing=NO;
                    [[UIApplication sharedApplication] endBackgroundTask:bgMixTask];
                    bgMixTask = UIBackgroundTaskInvalid;
                    uploadProssesing = NO;
                    [self uploadFileToServerIkara:tmp];
                    return;
                }
                operation = [[ExtendedAudioFileConvertOperation alloc] initWithRecording:(Recording *)tmp sourceURL:[NSURL fileURLWithPath:filePath] sourceUrl2:[NSURL fileURLWithPath:mp3Path]  sampleRate:44100 outputFormat:kAudioFormatLinearPCM];
                
                // [operation setEffect:100 andBass:50 andTreble:0 andDelay:[tmp.delay intValue] ];
                NSMutableDictionary *effectDict=[tmp.effectsNew.effects objectForKey:@"KARAOKE"];
                
                NewEffect* karaokeEffect=[[NewEffect alloc] initWithDict:effectDict];
                
                NSString *info=@"";
                [operation setEffect:0 andBass:0 andTreble:0 andDelay:[tmp.delay intValue]];
                if ([karaokeEffect.name isKindOfClass:[NSString class]]) {
                    if ([karaokeEffect.name isEqualToString:@"KARAOKE"]) {
                        [operation setEffect:[[karaokeEffect.parameters objectForKey:@"ECHO"] intValue] andBass:[[karaokeEffect.parameters objectForKey:@"BASS"] intValue] andTreble:[[karaokeEffect.parameters objectForKey:@"TREBLE"] intValue] andDelay:[tmp.delay intValue] ];
                    }
                }
                
                [operation updateBeateVolume:[tmp.effectsNew.beatVolume intValue] ];
                [operation updateVocalVolume:[tmp.effectsNew.vocalVolume intValue]];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [operation start];
                });
                do {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                while (mixOfflineProssesing);
                tmp->isConvert=NO;
                [[UIApplication sharedApplication] endBackgroundTask:bgMixTask];
                bgMixTask = UIBackgroundTaskInvalid;
                uploadProssesing = NO;
                [self uploadFileToServerIkara:tmp];
            });
        }
    }
}
-(void) processMixOffline{
    @autoreleasepool {
        mixOfflineProssesing=YES;
        // Start the long-running task and return immediately.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
            //dispatch_async(queue, ^{
            ExtendedAudioFileConvertOperation2 *operation;
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath;
            if ([songRec.vocalUrl isKindOfClass:[NSString class]]){
                if ([songRec.vocalUrl hasSuffix:@"mov"]|| [songRec.vocalUrl hasSuffix:@"mp4"]){
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                    
                }
                else {
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
                    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    if (!haveS) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                }
            }
            NSString *mp3Path;
            
            mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.song._id]];
            if ([songRec.song.songUrl isKindOfClass:[NSString class]])
            if ([songRec.song.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songRec.song._id]];
            }
            if (songRec.song.videoId.length>2){
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.song.videoId]];
                
            }
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
            }
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:mp3Path];
            
            
            operation = [[ExtendedAudioFileConvertOperation2 alloc] initWithSourceURL:[NSURL fileURLWithPath:filePath] sourceUrl2:[NSURL fileURLWithPath:mp3Path]  sampleRate:44100 outputFormat:kAudioFormatLinearPCM];
            
            [operation setEffect:0 andBass:0 andTreble:0 andDelay:0 ];
            
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [operation start];
            });
            do {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            while (mixOfflineProssesing);
            
        });
        
    }
}
#pragma mark Button Action Methods

- (IBAction)playAV:(id)sender
{
    
    if (VipMember && playRecord   ) {
       
        self.isLoading.hidden=NO;
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
        
        dispatch_async(queue, ^{
            
            // Response *respone=  [[LoadData2 alloc] playStream:streamName andRecord:songRec andSV:streamSV];
           
            
           
                    isPlayingAu=YES;
                    streamIsPlay=YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.isLoading.hidden=YES;
                       
                        if (duetVideoPlayer) {
                            [duetVideoPlayer play];
                        }
                        if (playerYoutubeVideoTmp) {
                            [playerYoutubeVideoTmp play];
                        }
                        if (!isVoice && hasHeadset && !playTopRec && !playRecUpload && !playRecord && !playthroughOn&& audioEngine2) {
                            [audioEngine2 playthroughSwitchChanged:YES];
                            [audioEngine2 reverbSwitchChanged:YES];
                            [audioEngine2 expanderSwitchChanged:YES];
                        }
                        if (!isrecord) self.recordImage.hidden=YES;
                        if (YES == seekToZeroBeforePlay)
                        {
                            seekToZeroBeforePlay = NO;
                            if (![Language hasSuffix:@"kara"])
                                [karaokeDisplay reset];
                            else if (youtubePlayer){
                                [youtubePlayer seekToSeconds:0 allowSeekAhead:YES];
                            }
                            if (playerMain) {
                                 [playerMain seekToTime:kCMTimeZero];
                            }
                           
                            if (audioPlayer && (((playRecUpload || playTopRec) &&!playVideoRecorded && [Language hasSuffix:@"kara"]) || (playRecord && playVideoRecorded)) )
                            {
                                if (playVideoRecorded){
                                    // if ([songRec->hasUpload isEqualToString:@"YES"])
                                    [audioPlayer seekToTime:CMTimeMakeWithSeconds([songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                                    
                                    //else [audioPlayer seekToTime:CMTimeMakeWithSeconds([songRec.delay doubleValue], NSEC_PER_SEC)];
                                }else
                                    [audioPlayer seekToTime:kCMTimeZero];
                                
                            }
                            
                            
                        }
                        
                        //.[playerMain play];
                        else
                            if (playRecord) {
                                if (isVoice && audioEngine2) {
                                    [audioEngine2 playthroughSwitchChanged:NO];
                                    [audioEngine2 reverbSwitchChanged:NO];
                                    [audioEngine2 expanderSwitchChanged:NO];
                                }
                                
                                
                                
                                
                            }

                            [self showStopButton];
                        //[recoder playerRec];
                        
                        
                        if ([Language hasSuffix:@"kara"] && !playTopRec && !playRecUpload){
                            /*if (!muteYoutube) {
                             [youtubePlayer playVideo];
                             }else if (timerWhenMuteYoutube==nil){
                             timerWhenMuteYoutube= [NSTimer
                             scheduledTimerWithTimeInterval:1
                             target:self
                             selector:@selector(scrubAudio)
                             userInfo:nil
                             repeats:YES];
                             }*/
                            
                            if (playRecord) {
                                if (VipMember && playerMain  ) {
                                    [playerMain play];
                                }
                               
                                    [audioPlayer play];
                                
                                
                            }
                        }else{
                            
                            [self checkPlaying1];
                        }
                    });
            
            
            
            
            
            
        });
    }else{
        isPlayingAu=YES;
        /* If we are at the end of the movie, we must seek to the beginning first
         before starting playback. */
        if (playTopRec) {
            //playTopRec=NO;
            if (!iSongPlay->isPlaying) iSongPlay->isPlaying=1;
        }
        if (duetVideoPlayer) {
            [duetVideoPlayer play];
        }
        if (!isVoice && hasHeadset && !playTopRec && !playRecUpload && !playRecord && !playthroughOn && audioEngine2) {
            [audioEngine2 playthroughSwitchChanged:YES];
            [audioEngine2 reverbSwitchChanged:YES];
            [audioEngine2 expanderSwitchChanged:YES];
        }
        if (!isrecord) self.recordImage.hidden=YES;
        if (YES == seekToZeroBeforePlay)
        {
            seekToZeroBeforePlay = NO;
            if (![Language hasSuffix:@"kara"])
                [karaokeDisplay reset];
            else if (youtubePlayer){
                [youtubePlayer seekToSeconds:0 allowSeekAhead:YES];
            }
            [playerMain seekToTime:kCMTimeZero];
            if (audioPlayer && (((playRecUpload || playTopRec) &&!playVideoRecorded && [Language hasSuffix:@"kara"]) || (playRecord && playVideoRecorded)) )
            {
                if (playVideoRecorded){
                    // if ([songRec->hasUpload isEqualToString:@"YES"])
                    [audioPlayer seekToTime:CMTimeMakeWithSeconds([songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                    
                    //else [audioPlayer seekToTime:CMTimeMakeWithSeconds([songRec.delay doubleValue], NSEC_PER_SEC)];
                }else
                    [audioPlayer seekToTime:kCMTimeZero];
                
            }
            
         
        }
       
            [self showStopButton];
        //[recoder playerRec];
        
        
        if ([Language hasSuffix:@"kara"] && !playTopRec && !playRecUpload){
            /*if (!muteYoutube) {
             [youtubePlayer playVideo];
             }else if (timerWhenMuteYoutube==nil){
             timerWhenMuteYoutube= [NSTimer
             scheduledTimerWithTimeInterval:1
             target:self
             selector:@selector(scrubAudio)
             userInfo:nil
             repeats:YES];
             }*/
            
            if (playRecord) {
                if (VipMember && playerMain  ) {
                    [playerMain play];
                }
                if (audioPlayer) {
                     [audioPlayer play];
                }
                
                if (duetVideoPlayer) {
                    [duetVideoPlayer play];
                }
                if (playerYoutubeVideoTmp) {
                    [playerYoutubeVideoTmp play];
                }
                
            }
        }else{
            
            [self checkPlaying1];
        }
    }
}

- (IBAction)pause:(id)sender
{
    
    if (isrecord){
        [self
         record];
        
    }else{
        if (VipMember && playRecord  ) {
            self.isLoading.hidden=NO;
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            
            dispatch_async(queue, ^{
                
            
                        streamIsPlay=NO;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                                [youtubePlayer pauseVideo];
                            }
                          
                            if ([duetVideoPlayer rate]) {
                                [duetVideoPlayer pause];
                            }
                            
                            isPlayingAu=NO;
                            if (isVoice && audioEngine2) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                                [audioEngine2 expanderSwitchChanged:NO];
                            }
                            
                            if ([playerYoutubeVideoTmp rate]) {
                                [playerYoutubeVideoTmp pause];
                            }
                            if ( audioPlayer.rate) [audioPlayer pause];
                           
                            if ([playerMain rate]!=0.f) [playerMain pause];
                            
                            
                            // recoder =[RecorderController new];
                            // [recoder stopRecord];
                            //isrecord=NO;
                            
                            [self showPlayButton];
                            self.isLoading.hidden=YES;
                        });
                
            });
        }else{
            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                [youtubePlayer pauseVideo];
            }
           
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            if ([playerYoutubeVideoTmp rate]) {
                [playerYoutubeVideoTmp pause];
            }
            isPlayingAu=NO;
            if (isVoice && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
                [audioEngine2 expanderSwitchChanged:NO];
            }
            
            
            if ( audioPlayer.rate) [audioPlayer pause];
            
            if ([playerMain rate]!=0.f) [playerMain pause];
            
            
            // recoder =[RecorderController new];
            // [recoder stopRecord];
            //isrecord=NO;
            
            [self showPlayButton];
        }
    }
    
    
    // [self checkPlaying];//them
}

- (void)loadMovi:(NSString *)urlL
{
    @autoreleasepool {
        
        
        /* Has the user entered a movie URL? */
        NSLog(@"loadMovi %@",urlL);
        dispatch_async( dispatch_get_main_queue(),
        ^{
        self.isLoading.hidden=NO;
        });
        if (urlL.length > 0)
        {
             NSURL *newMovieURL = [NSURL URLWithString:urlL];
            if (!newMovieURL) {
                NSRange range=[urlL rangeOfString:@"title="];
                range.length=urlL.length-range.location;
                NSString *link=[urlL substringWithRange:range];
                NSString *urlTmp=[urlL substringToIndex:range.location];
                link=[link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                newMovieURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlTmp,link]];
            }
         
           
            if ([newMovieURL scheme])    /* Sanity check on the URL. */
            {
                /*
                 Create an asset for inspection of a resource referenced by a given URL.
                 Load the values for the asset keys "tracks", "playable".
                 */
                assetLoadmovie1 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];
                
                NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
                
                /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
                [assetLoadmovie1 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                 ^{
                     dispatch_async( dispatch_get_main_queue(),
                                    ^{
                                        /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                        arrayIncreaseView=[NSMutableArray new];
                                        
                                        if (isTabKaraoke) isKaraokeTab=YES;
                                        if (isKaraokeTab){
                                            [self prepareToPlayAsset:assetLoadmovie1 withKeys:requestedKeys];
                                            
                                        
                                        
                                        
                                        
                                        
                                        if (isrecord) {
                                            NSLog(@"isrecord");
                                            //[playerMain play];
                                            if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2) {
                                                [audioEngine2 playthroughSwitchChanged:YES];
                                                [audioEngine2 reverbSwitchChanged:YES];
                                                [audioEngine2 expanderSwitchChanged:YES];
                                            }
                                        }else
                                            if (playRecord){
                                                //[audioPlayRecorder play];
                                                //[playerMain play];
                                                
                                                
                                                if (isVoice && audioEngine2) {[audioEngine2 playthroughSwitchChanged:NO];
                                                    [audioEngine2 reverbSwitchChanged:NO];
                                                    [audioEngine2 expanderSwitchChanged:NO];
                                                }
                                            }else if ((playTopRec||playRecUpload) &&!playVideoRecorded && [Language hasSuffix:@"kara"]) {
                                                // if (audioPlayer)
                                                
                                                
                                                if (timeRestore!=0){
                                                    [playerMain seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
                                                    [audioPlayer seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
                                                    timeRestore=0;
                                                }
                                                // [playerMain play];
                                                // [audioPlayer play];
                                                if (isVoice && audioEngine2) {
                                                    [audioEngine2 playthroughSwitchChanged:NO];
                                                    [audioEngine2 reverbSwitchChanged:NO];
                                                    [audioEngine2 expanderSwitchChanged:NO];
                                                }
                                            }else{
                                                
                                                // while(playerMain.status!=AVPlayerStatusReadyToPlay){
                                                
                                                
                                                
                                                if (timeRestore!=0){
                                                    [playerMain seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
                                                    timeRestore=0;
                                                }
                                                // hasHeadset=YES;
                                                if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2) {
                                                    [audioEngine2 playthroughSwitchChanged:YES];
                                                    [audioEngine2 reverbSwitchChanged:YES];
                                                    [audioEngine2 expanderSwitchChanged:YES];
                                                }
                                                
                                            }
                                        isPlayingAu=YES;
                                        
                                        if (lyric && ![Language hasSuffix:@"kara"]) {
                                            [karaokeDisplay setSimpleTiming:lyric];
                                            [karaokeDisplay reset];
                                            [karaokeDisplay _updateOrientation ];
                                            [karaokeDisplay render:CMTimeGetSeconds([playerMain currentTime])];
                                        }
                                        if (VipMember && playRecord   ) {
                                            playerMain.muted=YES;
                                            [playerMain play];
                                        }
                                        }
                                    });
                 }];
                
            }
        }
        
    }
}
- (void)loadMovie2:(NSString *)urlL
{
    @autoreleasepool {
        
        NSLog(@"loadMovie2 %@",urlL);
        if (self.recordSession) {
          
            if (isKaraokeTab){
                [self prepareToPlayAsset2:self.recordSession.assetRepresentingSegments withKeys:nil];
            }

                isPlayingAu=YES;
                [audioPlayer play];

        }else
        /* Has the user entered a movie URL? */
        if (urlL.length > 0)
        {
            NSURL *newMovieURL = [NSURL URLWithString:urlL];
            if ([newMovieURL scheme])    /* Sanity check on the URL. */
            {
                /*
                 Create an asset for inspection of a resource referenced by a given URL.
                 Load the values for the asset keys "tracks", "playable".
                 */
                AVURLAsset* asset2 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];
                
                NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
                
                /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
                [asset2 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                 ^{
                     dispatch_async( dispatch_get_main_queue(),
                                    ^{
                                        /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                        if (isKaraokeTab){
                                            [self prepareToPlayAsset2:asset2 withKeys:requestedKeys];
                                        
                                       
                                        if (!VipMember ) {
                                            isPlayingAu=YES;
                                            [audioPlayer play];
                                        }
                                        }
                                        //if  ([self isPlaying] ) [audioPlayer play];
                                        
                                        
                                    });
                 }];
            }
        }
    }
}
- (void)loadDuetVideo:(NSString *)urlL
{
    @autoreleasepool {
        
        NSLog(@"loadDuetVideo %@",urlL);
        /* Has the user entered a movie URL? */
        if (urlL.length > 0)
        {
            NSURL *newMovieURL = [NSURL URLWithString:urlL];
            if ([newMovieURL scheme])    /* Sanity check on the URL. */
            {
                /*
                 Create an asset for inspection of a resource referenced by a given URL.
                 Load the values for the asset keys "tracks", "playable".
                 */
                AVURLAsset* asset2 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];
                
                NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
                
                /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
                [asset2 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                 ^{
                     dispatch_async( dispatch_get_main_queue(),
                                    ^{
                                        /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                        if (isKaraokeTab) {
                                             [self prepareToPlayAsset3:asset2 withKeys:requestedKeys];
                                        }
                                       
                                        
                                        //if  ([self isPlaying] ) [audioPlayer play];
                                        
                                        
                                    });
                 }];
            }
        }
    }
}
- (void)loadYoutubeVideoTmp:(NSString *)urlL
{
    @autoreleasepool {
        if ([Language hasSuffix:@"karaokestar"]) {
            return;
        }
        NSLog(@"loadYoutubeVideoTmp %@",urlL);
        /* Has the user entered a movie URL? */
        if (urlL.length > 0)
        {
            NSURL *newMovieURL = [NSURL URLWithString:urlL];
            if ([newMovieURL scheme])    /* Sanity check on the URL. */
            {
                /*
                 Create an asset for inspection of a resource referenced by a given URL.
                 Load the values for the asset keys "tracks", "playable".
                 */
                AVURLAsset* asset2 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];
                
                NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
                
                /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
                [asset2 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                 ^{
                     dispatch_async( dispatch_get_main_queue(),
                                    ^{
                                        /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                        if (isKaraokeTab) {
                                             [self prepareToPlayAsset4:asset2 withKeys:requestedKeys];
                                        }
                                       
                                        
                                        //if  ([self isPlaying] ) [audioPlayer play];
                                        
                                        
                                    });
                 }];
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    /* When the user presses return, take focus away from the text
     field so that the keyboard is dismissed.
     if (theTextField == self.movieURLTextField)
     {
     [self.movieURLTextField resignFirstResponder];
     }
     */
    [theTextField resignFirstResponder];
    return YES;
}

//////
////audio engine



-(void)destroy {
    @autoreleasepool {
        
        if (unload) {
            
            if (audioEngine2 ) {
                
                isRecorded=NO;
                [audioEngine2 record];
                
                if (isIphone5s) {
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    
                    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.aif",songRecOld.recordingTime]];
                    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                    
                    if (success){ NSLog(@"[deleteFile5s] success");}
                    else{
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aif",songRecOld.recordingTime]];
                        success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                    }
                }
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                NSLog(@"Xoa file cu");
                
                if (success){ NSLog(@"[deleteFile] success");}
                else{
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.m4a",songRecOld.recordingTime]];
                    success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                    // NSLog(@"Xoa file cu");
                    
                    if (success) NSLog(@"[deleteVideo] success");
                    
                }
                //songRecOld=nil;
                
            }
            
            
            //if (audioController) [audioController removeObserver:self forKeyPath:@"numberOfInputChannels"];
            /*khi chuyen xuong thì sửa lại chỗ này
             if ([self isPlaying] && !playRecUpload) {
             [playerMain pause];
             
             }
             */
        }
    }
    //[super dealloc];
}


- (void) creatAudioEngine{
    @autoreleasepool {
      
        if (audioEngine2 ==nil ){
            AEAudioController * audioController1 = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
            audioController1.preferredBufferDuration = 0.005;
                // audioController1.useMeasurementMode = YES;
                //audioController1.inputGain=1;
            audioController1.enableBluetoothInput=YES;
            [audioController1 start:nil];
                //[audioController1 performSelectorInBackground:@selector(start:) withObject:nil];
                //[NSThread detachNewThreadSelector:@selector(start) toTarget:audioController1 withObject:nil];
            audioEngine2=[[audioEngine alloc] initWithAudioController:audioController1];
            
            //[audioEngine2 expanderSwitchChanged:YES];
            //});
        }
       
    }
}
-(void) changeB:(UIImage *) image{
    @autoreleasepool {
        [backgroundImage setImage:image];
    }
}
- (void) changeBackgroun {
    @autoreleasepool {
        
        if (autoChangeBackground && dataBackground){
            
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"BackgroundNew%d.jpg",STTBackground]];
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!haveS) {
                if ([[LoadData2 alloc]checkNetwork]){
                    
                    NSString *urlB=[dataBackground objectAtIndex:STTBackground];
                    if ([urlB hasPrefix:@"http"]){
                        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                        dispatch_async(queue, ^{
                            //code to executed in the background
                            NSURL *urlBackground = [NSURL URLWithString:urlB];
                            NSData *dataBack=[NSData dataWithContentsOfURL:urlBackground];
                            UIImage *image = [UIImage imageWithData: dataBack];
                            [dataBack writeToFile:filePath atomically:YES];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [backgroundImage setImage:image];
                                
                            });
                        });
                        // [self performSelectorOnMainThread:@selector(changeB:) withObject:image waitUntilDone:NO];
                    }
                }
                STTBackground=(STTBackground+1)%dataBackground.count;
            }else{
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                
                [backgroundImage setImage:image];
                
                STTBackground=(STTBackground+1)%dataBackground.count;
                
            }
            
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    
	if (youtubePlayer) {
		[youtubePlayer pauseVideo];
		[youtubePlayer removeFromSuperview];
		youtubePlayer.delegate=nil;
		youtubePlayer=nil;
	}
    
}

- (void) demTGTone{
    if (demTimeTone==10 || demTimeTone==20 || demTimeTone==1 || demTimeTone==30){
        [demToneTimer invalidate];
        demToneTimer=nil;
        GetPitchShiftedSongLinkResponse * respone=[[LoadData2 alloc] GetPitchShiftedSongLink:songPlay._id withPitchShift:[NSNumber numberWithInteger: songPlay.pitchShift *2]];
        if (respone.status.length>0){
            if ([respone.status isEqualToString:@"READY"]){
                // [demToneTimer invalidate];
                
                demTimeTone=30;
                
                [demToneTimer invalidate];
                demToneTimer=nil;
                
                songPlay.songUrl=respone.link;
                
                [self finishGetTone];
                
            }else {
                if (demTimeTone<=0 ){
                    demTimeToneLan2=YES;
                    [demToneTimer invalidate];
                    demToneTimer=nil;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[[[iToast makeText:AMLocalizedString(@"Bài hát không thể tăng giảm tone, bạn sẽ hát với tone gốc", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                    [self finishGetTone];
                }else {
                    [demToneTimer invalidate];
                    demToneTimer=nil;
                    demToneTimer=[NSTimer scheduledTimerWithTimeInterval:1
                                                                  target:self
                                                                selector:@selector(demTGTone)
                                                                userInfo:nil
                                                                 repeats:NO];
                }
            }
        }else {
            if (demTimeTone<=0 ){
                demTimeToneLan2=NO;
                [demToneTimer invalidate];
                demToneTimer=nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[[[iToast makeText:AMLocalizedString(@"Bài hát không thể tăng giảm tone, bạn sẽ hát với tone gốc", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
                [self finishGetTone];
            }else {
                [demToneTimer invalidate];
                demToneTimer=nil;
                demToneTimer=[NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(demTGTone)
                                                            userInfo:nil
                                                             repeats:NO];
            }
            
        }
        
        demTimeToneLan2=YES;
        
        
    }
    
    demTimeTone--;
    if (demTimeTone<0 ){
        demTimeToneLan2=NO;
        [demToneTimer invalidate];
        demToneTimer=nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[[iToast makeText:AMLocalizedString(@"Bài hát không thể tăng giảm tone, bạn sẽ hát với tone gốc", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
        [self finishGetTone];
    }else {
        [demToneTimer invalidate];
        demToneTimer=nil;
        //  demToneTimer=[NSTimer scheduledTimerWithTimeInterval:1    target:self   selector:@selector(demTGTone)   userInfo:nil   repeats:NO];
    }
}
- (void) finishGetTone{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",songPlay._id,songPlay.pitchShift]];
    
    
    //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswitch_mo.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (haveS){
        NSURL *urlLocal= [NSURL fileURLWithPath:filePath];
        urlSong=[NSString stringWithFormat:@"%@",urlLocal];
        [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSong];
    }else{
        
        // self.startButton.backgroundColor=UIColorFromRGB(0x959595);
        [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:songPlay.songUrl];
        
        // [self.download startWithDelegate:self];
    }
}
- (void) viewWillDisappear:(BOOL)animated{
    
    recorder.delegate = nil;
    if (videoRecord && isrecord) {
        [recorder stopRunning];
      
        //recorder=nil;
    }
     [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb3.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (timerWhenMuteYoutube) {
        [timerWhenMuteYoutube invalidate];
        timerWhenMuteYoutube=nil;
    }
    if (youtubePlayerIsPlay) {
        [youtubePlayer stopVideo];
        youtubePlayer=nil;
    }
    if (playerYoutubeVideoTmp.rate) {
        [playerYoutubeVideoTmp pause];
        if (playerItem4 )
        {
            @try {
                [playerItem4 removeObserver:self forKeyPath:@"status"];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem4];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception.debugDescription);
            } @finally {
                
            }
           
        }
    }
    if (demToneTimer) {
        [demToneTimer invalidate];
        demToneTimer=nil;
    }
    
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
    [backgroundImage.layer removeAllAnimations];
    [super viewWillDisappear:YES];
    
    if (isVoice && audioEngine2) {
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 reverbSwitchChanged:NO];
        [audioEngine2 expanderSwitchChanged:NO];
    }
    if (audioPlayer.rate) {
        [audioPlayer pause];
       
    }
    if (playerItem2) {
         playerItem2.audioMix=nil;
    }
    if (duetVideoPlayer.rate) {
        [duetVideoPlayer pause];
    }
   
    NSLog(@"dis did appear");
   
    [[self previewView] setSession:nil];
    [self.previewView removeFromSuperview];
    self.previewView=nil;
    if ([self isPlaying]) {
        [playerMain pause];
    }
    if (buttonTimer) {
        [buttonTimer invalidate];
        buttonTimer=nil;
    }
   
   
    // [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    isKaraokeTab=NO;
    //[[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    [changeBackground invalidate];
    changeBackground=nil;
    [checkPlaying invalidate];
    checkPlaying=nil;
    [self removePlayerTimeObserver];
    //  if (audioPlayer) [audioPlayer removeObserver:self forKeyPath:kRateKey];
    if ([Language hasSuffix:@"kara"] || (!playRecord && playVideoRecorded)){
        
        [playerLayerView removeFromSuperview];
        [playerLayerView.playerLayer setPlayer:nil];
        playerLayerView=nil;
    }
   
    if (playVideoRecorded && playRecord){
        
        [playerLayerViewRec removeFromSuperview];
        [playerLayerViewRec.playerLayer setPlayer:nil];
        playerLayerViewRec=nil;
    }
    if (duetVideoPlayer ){
        
        [self.duetVideoLayer removeFromSuperview];
        [self.duetVideoLayer.playerLayer setPlayer:nil];
        self.duetVideoLayer=nil;
        if (playerItem3 )
        {
              @try {
            [duetVideoPlayer removeObserver:self forKeyPath:kRateKey context:MyStreamingMovieViewControllerRateObservationContext3];
                [playerItem3 removeObserver:self forKeyPath:@"status"];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem3];
              }@catch (NSException *exception) {
                  
              }
        }
    }
    if (hasObser) {
        @try {
            [playerMain removeObserver:self forKeyPath:kRateKey context:MyStreamingMovieViewControllerRateObservationContext];
            [playerMain removeObserver:self forKeyPath:kTimedMetadataKey context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
            //if (![Language hasSuffix:@"kara"])
            [playerMain removeObserver:self forKeyPath:kCurrentItemKey context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        }@catch (NSException *exception) {
            
        }
        @try {
            if (playerItem)
            {
                
                
                [playerItem removeObserver:self forKeyPath:@"status"];
            }
        } @catch (NSException *exception) {
            
        }
        
        hasObser=NO;
        
        
        
    }
    
    if (playerItem){
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:playerItem];
    }
    
    if (demperc) {
        [demperc invalidate];
        demperc=nil;
    }
    self.startRecordView.delegate = nil;
    controllerRecord.delegate = nil;
    autotuneKeyMenu.delegate = nil;
    autotuneAmGiaiMenu.delegate = nil;
    movieURLTextField=nil;
    movieTimeControl=nil;
    backgroundImage=nil;
    menuLyric=nil;
    
    isPlayingAdText=nil;
    self.showplainText=nil;
    toolBar=nil;
    MenuRec=nil;
    //isLoading =nil;
    selectLyricButton=nil;
    //karaokeDisplayElement=nil;
    menuBtn=nil;
    NameUpload=nil;
    uploadView=nil;
    messageUpload=nil;
    showSongName=nil;pt=nil;
    //karaokeDisplay=nil;
    _xulyView=nil;
    _recordImage=nil;
    _warningHeadset=nil;
    _deplayLabel=nil;
    _volumeTrebleLabel=nil;
    _volumeVocalLabel=nil;
    _volumeMusicLabel=nil;
    _volumeTreble=nil;
    _volumEcho=nil;
    _volumeVocal=nil;
    _volumeMusic=nil;
    
    _editButt=nil;
    _showSingerName=nil;
    _volumEchoLabel=nil;
    _songNameUpload=nil;
    _Thongbao=nil;
    _timeplay=nil;
    self.xulyButt=nil;
    
    if (playerItem2 )
    {
        if (hasObser2) {
            hasObser2=NO;
            [playerItem2 removeObserver:self forKeyPath:@"status"];
             [audioPlayer removeObserver:self forKeyPath:kRateKey context:MyStreamingMovieViewControllerRateObservationContext2];
            [audioPlayer removeObserver:self forKeyPath:kTimedMetadataKey context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
            //if (![Language hasSuffix:@"kara"])
            [audioPlayer removeObserver:self forKeyPath:kCurrentItemKey context:MyStreamingMovieViewControllerCurrentItemObservationContext2];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem2];
    }
    
    isTabKaraoke=NO;
    if (youtubePlayer && [Language hasSuffix:@"kara"] && !playTopRec && !playRecUpload){
        
        if ([self isPlaying]) [playerMain pause];
        if (playRecord) {
            
            
            if ([self isPlayingAudio]) [audioPlayer pause];
            
        }
        if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
            [youtubePlayer pauseVideo];
        }
        [youtubePlayer removeFromSuperview];
        youtubePlayer.delegate=nil;
        youtubePlayer=nil;
    }
    if (doNothingStreamTimer) {
        [doNothingStreamTimer invalidate];
        doNothingStreamTimer=nil;
    }
    if (VipMember && playRecord  ) {
        [self sendDestroy];
        [socket disconnect];
        socket.delegate=nil;
        
        NSString *url1=[NSString stringWithFormat: @"ikara/streams/%@",streamName];
        [[self.ref child:url1 ] removeAllObservers];
        [self.ref removeObserverWithHandle:self.refHandle];
        //[self.ref removeObserverWithHandle:self.refHandle2];
    }
    [super viewWillDisappear:NO];
}
BOOL isTabKaraoke;
- (void) viewWillAppear:(BOOL)animated{
   
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // if (playRecord){
    //  NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    // [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //}else if (videoRecord){
    // NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    // [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //  }
    self.navigationController.navigationBarHidden=YES;
   
     [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb4.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"homePress" object:nil];
    if (audioEngine2.audioController.running) {
        [audioEngine2 stopP];
    }
    if (audioEngine2) {
        
        audioEngine2.audioController=nil;
        
    }
   // audioEngine2=nil;
    NSLog(@"dealloc streammingplayer");
}
- (void)viewDidAppear:(BOOL)animated
{
    

    if (playRecord) {
        
        
        //set up voicechanger
        catalogVoiceChanger=[NSMutableArray new];
        [catalogVoiceChanger addObjectsFromArray:@[@"Trẻ em",@"Người già",@"Nam => Nữ",@"Nữ => Nam"]];
        voiceChangerMenu = [[DemoTableController alloc] init];
        
        voiceChangerMenu.array=catalogVoiceChanger;
        voiceChangerMenu.hideIcon=@1;
        self.voiceChangerEffectVoice.text=@"Trẻ em";
        
        voiceChangerMenu.title=@"";
        voiceChangerMenu.delegate = self;
        //controllerRecord.view.center=self.view.center;
        voiceChangerMenu.view.layer.cornerRadius=5;
        voiceChangerMenu.view.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        voiceChangerMenu.view.layer.masksToBounds=YES;
        voiceChangerMenu.view.backgroundColor=[UIColor whiteColor];
        [voiceChangerMenu.view setFrame:CGRectMake(-40, 0, 200, (autotuneKeyMenu.array.count)*50+20)];
        //  [self.saveRecordView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        voicechangerEffect=[NewEffect new];
        voicechangerEffect.enable=@0;
        voicechangerEffect.type=@"VOCAL";
        voicechangerEffect.name=@"VOICECHANGER";
        voicechangerEffect.version=@1;
        voicechangerEffect.preset=@"DEFAULT";
        voicechangerEffect.parameters=[NSMutableDictionary new];
        [voicechangerEffect.parameters setObject:@"BABY" forKey:@"TYPE"];
        
        //SET UP LIVE EFFECT
        liveEffect=[NewEffect new];
        liveEffect.enable=@0;
        liveEffect.name=@"LIVE";
        liveEffect.version=@1;
        liveEffect.preset=@"DEFAULT";
        liveEffect.type=@"VOCAL";
        
        
        liveEffect.parameters=[NSMutableDictionary new];
        self.liveEffectThickLabel.text=@"100";
        self.liveEffectWarmLabel.text=@"50";
        self.liveEffectThickSlider.value=100;
        self.liveEffectWarmSlider.value=50;
        self.liveEffectEchoLabel.text=@"70";
        self.liveEffectEchoSlider.value=70;
        self.liveEffectBassSlider.value=50;
        self.liveEffectBassLabel.text=@"50";
        self.liveEffectTrebleLabel.text=@"50";
        self.liveEffectTrebleSlider.value=50;
        [liveEffect.parameters setObject:[NSNumber numberWithInteger:70] forKey:@"ECHO"];
        [liveEffect.parameters setObject:[NSNumber numberWithInteger:100] forKey:@"THICK"];
        [liveEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"WARM"];
        [liveEffect.parameters setObject:[NSNumber numberWithInteger:0] forKey:@"BASS"];
        [liveEffect.parameters setObject:[NSNumber numberWithInteger:0] forKey:@"TREBLE"];
        //SET UP SUPERBASS EFFECT
        superbassEffect=[NewEffect new];
        superbassEffect.enable=@0;
        superbassEffect.name=@"SUPERBASS";
        superbassEffect.version=@1;
        superbassEffect.preset=@"DEFAULT";
        superbassEffect.type=@"VOCAL";
        
        
        superbassEffect.parameters=[NSMutableDictionary new];
        self.superBassEffectEchoLabel.text=@"50";
        self.superBassEffectEchoSlider.value=50;
        self.superBassEffectBassLabel.text=@"70";
        self.superBassEffectBassSlider.value=70;
        self.superBassEffectTrebleLabel.text=@"50";
        self.superBassEffectTrebleSlider.value=50;
        [superbassEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"ECHO"];
        [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(self.superBassEffectBassSlider.value-50)*2] forKey:@"BASS"];
        [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(self.superBassEffectTrebleSlider.value-50)*2] forKey:@"TREBLE"];
        
        //SET UP BOLERO EFFECT
        boleroEffect=[NewEffect new];
        boleroEffect.enable=@0;
        boleroEffect.name=@"BOLERO";
        boleroEffect.version=@1;
        boleroEffect.preset=@"DEFAULT";
        boleroEffect.type=@"VOCAL";
        
        
        boleroEffect.parameters=[NSMutableDictionary new];
        self.boleroEffectEchoLabel.text=@"60";
        self.boleroEffectEchoSlider.value=60;
        self.boleroEffectBassLabel.text=@"50";
        self.boleroEffectBassSlider.value=50;
        self.boleroEffectTrebleLabel.text=@"50";
        self.boleroEffectTrebleSlider.value=50;
        self.boleroEffectDelayLabel.text=@"80";
        self.boleroEffectDelaySlider.value=80;
        [boleroEffect.parameters setObject:[NSNumber numberWithInteger:60] forKey:@"ECHO"];
        [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(self.boleroEffectBassSlider.value-50)*2] forKey:@"BASS"];
        [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(self.boleroEffectTrebleSlider.value-50)*2] forKey:@"TREBLE"];
        
        remixEffect=[NewEffect new];
        remixEffect.enable=@0;
        remixEffect.name=@"REMIX";
        remixEffect.version=@1;
        remixEffect.preset=@"DEFAULT";
        remixEffect.type=@"VOCAL";
        
        
        remixEffect.parameters=[NSMutableDictionary new];
        self.remixEffectEchoLabel.text=@"40";
        self.remixEffectEchoSlider.value=40;
        self.remixEffectBassLabel.text=@"50";
        self.remixEffectBassSlider.value=50;
        self.remixEffectTrebleLabel.text=@"50";
        self.remixEffectTrebleSlider.value=50;
        [remixEffect.parameters setObject:Key_Remix_FLANGERTYPE_CLASSIC forKey:Key_Remix_FLANGERTYPE];
        [remixEffect.parameters setObject:[NSNumber numberWithInteger:40] forKey:@"ECHO"];
        [remixEffect.parameters setObject:[NSNumber numberWithInteger:(self.remixEffectBassSlider.value-50)*2] forKey:@"BASS"];
        [remixEffect.parameters setObject:[NSNumber numberWithInteger:(self.remixEffectTrebleSlider.value-50)*2] forKey:@"TREBLE"];
        // [boleroEffect.parameters setObject:[NSNumber numberWithInteger:80] forKey:@"DELAY"];
        catalogKey=[NSMutableArray new];
        [catalogKey addObjectsFromArray:@[@"Auto",@"Ab",@"A",@"Bb",@"B",@"C",@"Db",@"D",@"Eb",@"E",@"F",@"Gb",@"G"]];
        autotuneKeyMenu = [[DemoTableController alloc] init];
        
        autotuneKeyMenu.array=catalogKey;
        autotuneKeyMenu.hideIcon=@1;
        
        amgiai=@"M";
        self.autotuneChuAm.text=@"   Auto";
        
            self.xulyViewAutotuneAmGiaiLabel.text=[NSString stringWithFormat:@"    %@", amgiai];
    
        chuam=@"Auto";
        autotuneKeyMenu.title=@"";
        autotuneKeyMenu.delegate = self;
        //controllerRecord.view.center=self.view.center;
        autotuneKeyMenu.view.layer.cornerRadius=5;
        autotuneKeyMenu.view.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        autotuneKeyMenu.view.layer.masksToBounds=YES;
        autotuneKeyMenu.view.backgroundColor=[UIColor whiteColor];
        [autotuneKeyMenu.view setFrame:CGRectMake(-40, 0, 100, (autotuneKeyMenu.array.count)*50+20)];
        //  [self.saveRecordView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        autotuneAmGiaiMenu = [[DemoTableController alloc] init];
        catalogAmGiai=[NSMutableArray new];
        [catalogAmGiai addObject:@"M"];
        [catalogAmGiai addObject:@"m"];
        autotuneAmGiaiMenu.array=catalogAmGiai;
        autotuneAmGiaiMenu.hideIcon=@1;
        
        autotuneAmGiaiMenu.title=@"";
        autotuneAmGiaiMenu.delegate = self;
        //controllerRecord.view.center=self.view.center;
        autotuneAmGiaiMenu.view.layer.cornerRadius=5;
        autotuneAmGiaiMenu.view.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
        autotuneAmGiaiMenu.view.layer.masksToBounds=YES;
        autotuneAmGiaiMenu.view.backgroundColor=[UIColor whiteColor];
        [autotuneAmGiaiMenu.view setFrame:CGRectMake(-40, 0, 150, (autotuneAmGiaiMenu.array.count)*50+20)];
        
        
        [NSThread detachNewThreadSelector:@selector(getBpmAndKey) toTarget:self withObject:nil];
        
        
        
        karaokeEffect=[NewEffect new];
        karaokeEffect.enable=@0;
        karaokeEffect.name=@"KARAOKE";
        karaokeEffect.version=@1;
        karaokeEffect.preset=@"DEFAULT";
        karaokeEffect.type=@"VOCAL";
        
        karaokeEffect.parameters=[NSMutableDictionary new];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"ECHO"];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"BASS"];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"TREBLE"];
        self.karaokeEffectBassLabel.text=@"65";
        self.karaokeEffectBassSlider.value=65;
        self.karaokeEffectTrebleLabel.text=@"70";
        self.karaokeEffectTrebleSlider.value=70;
        if (VipMember  ) {
            self.karaokeEffectThickVIPIcoin.hidden=YES;
            self.karaokeEffectWarmVIPIcoin.hidden=YES;
            self.karaokeEffectThickLabel.text=@"20";
            self.karaokeEffectWarmLabel.text=@"50";
            self.karaokeEffectThickSlider.value=20;
            self.karaokeEffectWarmSlider.value=50;
            [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:20] forKey:@"THICK"];
            [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:50] forKey:@"WARM"];
        }else{
            self.karaokeEffectThickVIPIcoin.hidden=NO;
            self.karaokeEffectWarmVIPIcoin.hidden=NO;
            self.karaokeEffectThickLabel.text=@"0";
            self.karaokeEffectWarmLabel.text=@"0";
            self.karaokeEffectThickSlider.value=0;
            self.karaokeEffectWarmSlider.value=0;
        }
        
        studioEffect=[NewEffect new];
        studioEffect.enable=@0;
        studioEffect.name=@"STUDIO";
        studioEffect.version=@1;
        studioEffect.preset=@"DEFAULT";
        studioEffect.type=@"VOCAL";
        studioEffect.parameters=[NSMutableDictionary new];
        [self changeStudioGender:1];
        [self changeStudioCG:2];
        //[self changeStudioTL:2];
        self.studioEffectEchoLabel.text=@"40";
        self.studioEffectEchoSlider.value=40;
        [studioEffect.parameters setObject:[NSNumber numberWithInteger:40] forKey:@"ECHO"];
        karaokeEffect.enable=@1;
        
        if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
            songRec.effectsNew=[NewEffects new];
            
            songRec.effectsNew.vocalVolume=@80;
            songRec.effectsNew.beatVolume=@80;
            songRec.effectsNew.effects=[NSMutableDictionary new];
            [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary]forKey:@"KARAOKE"];
        }
        songRec.effectsNew.masterVolume=@100;
        songRec.effectsNew.toneShift=@0;
        if (![songRec.effectsNew.effects isKindOfClass:[NSMutableDictionary class] ]) {
            songRec.effectsNew.effects=[NSMutableDictionary new];
            [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary]forKey:@"KARAOKE"];
        }
        songRec.effectsNew.delay=[NSNumber numberWithLong: [songRec.delay longValue]];
        
        
        autotuneEffect=[NewEffect new];
        autotuneEffect.enable=@0;
        autotuneEffect.type=@"VOCAL";
        autotuneEffect.name=@"AUTOTUNE";
        autotuneEffect.version=@1;
        autotuneEffect.preset=@"DEFAULT";
        autotuneEffect.parameters=[NSMutableDictionary new];
        [autotuneEffect.parameters setObject:@"Auto" forKey:@"KEY"];
        denoiseEffect=[NewEffect new];
        denoiseEffect.enable=@0;
        denoiseEffect.name=@"DENOISE";
        denoiseEffect.version=@1;
        denoiseEffect.type=@"VOCAL";
        denoiseEffect.preset=@"DEFAULT";
        denoiseEffect.parameters=[NSMutableDictionary new];
        [self changeDenoiseLevel:0];
      
        //self.rulerDelay.center=self.xulyViewRulerDelay.center;
        
        //creat stream
        [self borderEffectButton];
        if (!VipMember ) {
            
            studioEffect.enable=@0;
            liveEffect.enable=@0;
            NSString *info=@"";
            NSMutableDictionary *effectDict=[songRec.effectsNew.effects objectForKey:@"KARAOKE"];
            NewEffect *effect=[[NewEffect alloc] initWithDict:effectDict];
            
            karaokeEffect.enable=@1;
            if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                self.karaokeEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                self.karaokeEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
            }
            if ([[effect.parameters objectForKey:@"BASS"] integerValue]) {
                self.karaokeEffectBassSlider.value=[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50;
                self.karaokeEffectBassLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50];
            }
            if ([[effect.parameters objectForKey:@"TREBLE"] integerValue]) {
                self.karaokeEffectTrebleSlider.value=[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50;
                self.karaokeEffectTrebleLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50];
            }
            if ([[effect.parameters objectForKey:@"THICK"] integerValue]) {
                self.karaokeEffectThickSlider.value=[[effect.parameters objectForKey:@"THICK"] integerValue];
                self.karaokeEffectThickLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"THICK"] integerValue]];
            }
            if ([[effect.parameters objectForKey:@"WARM"] integerValue]) {
                self.karaokeEffectWarmSlider.value=[[effect.parameters objectForKey:@"WARM"] integerValue];
                self.karaokeEffectWarmLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"WARM"] integerValue]];
            }
        }else{
            for (NSString *key in songRec.effectsNew.effects.allKeys) {
                
                NSMutableDictionary *effectDict=[songRec.effectsNew.effects objectForKey:key];
                
                NewEffect* effect=[[NewEffect alloc] initWithDict:effectDict];
                
                NSString *info=@"";
                if ([effect.name isEqualToString:@"KARAOKE"]) {
                    
                    karaokeEffect.enable=@1;
                    studioEffect.enable=@0;
                    liveEffect.enable=@0;
                    NSString *info=@"";
                    if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                        self.karaokeEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                        self.karaokeEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"BASS"] integerValue]) {
                        self.karaokeEffectBassSlider.value=[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50;
                        self.karaokeEffectBassLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"TREBLE"] integerValue]) {
                        self.karaokeEffectTrebleSlider.value=[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50;
                        self.karaokeEffectTrebleLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"THICK"] integerValue]) {
                        self.karaokeEffectThickSlider.value=[[effect.parameters objectForKey:@"THICK"] integerValue];
                        self.karaokeEffectThickLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"THICK"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"WARM"] integerValue]) {
                        self.karaokeEffectWarmSlider.value=[[effect.parameters objectForKey:@"WARM"] integerValue];
                        self.karaokeEffectWarmLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"WARM"] integerValue]];
                    }
                }else if ([effect.name isEqualToString:@"SUPERBASS"]) {
                    
                    karaokeEffect.enable=@0;
                    studioEffect.enable=@0;
                    liveEffect.enable=@0;
                    superbassEffect.enable=@1;
                    NSString *info=@"";
                    if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                        self.superBassEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                        self.superBassEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"BASS"] integerValue]) {
                        self.superBassEffectBassSlider.value=[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50;
                        self.superBassEffectBassLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"TREBLE"] integerValue]) {
                        self.superBassEffectTrebleSlider.value=[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50;
                        self.superBassEffectTrebleLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50];
                    }
                    
                }else if ([effect.name isEqualToString:Key_Remix]) {
                    
                    karaokeEffect.enable=@0;
                    studioEffect.enable=@0;
                    liveEffect.enable=@0;
                    superbassEffect.enable=@0;
                    remixEffect.enable=@1;
                    NSString *info=@"";
                    if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                        self.remixEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                        self.remixEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"BASS"] integerValue]) {
                        self.remixEffectBassSlider.value=[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50;
                        self.remixEffectBassLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"TREBLE"] integerValue]) {
                        self.remixEffectTrebleSlider.value=[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50;
                        self.remixEffectTrebleLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50];
                    }
                    NSString *flangertype=[effect.parameters objectForKey:Key_Remix_FLANGERTYPE];
                    if (flangertype.length>0) {
                        
                        if ([flangertype isEqualToString:Key_Remix_FLANGERTYPE_CLASSIC]) {
                            [self remixFlangerSelect:2];
                        }else
                            if ([flangertype isEqualToString:Key_Remix_FLANGERTYPE_SOFT]) {
                                [self remixFlangerSelect:1];
                            }
                            else
                                if ([flangertype isEqualToString:Key_Remix_FLANGERTYPE_SLOWBASS]) {
                                    [self remixFlangerSelect:3];
                                }
                        
                    }
                    
                }else if ([effect.name isEqualToString:@"BOLERO"]) {
                    
                    karaokeEffect.enable=@0;
                    studioEffect.enable=@0;
                    liveEffect.enable=@0;
                    boleroEffect.enable=@1;
                    NSString *info=@"";
                    if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                        self.boleroEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                        self.boleroEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"BASS"] integerValue]) {
                        self.boleroEffectBassSlider.value=[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50;
                        self.boleroEffectBassLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"BASS"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"TREBLE"] integerValue]) {
                        self.boleroEffectTrebleSlider.value=[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50;
                        self.boleroEffectTrebleLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"TREBLE"] integerValue]/2+50];
                    }
                    if ([[effect.parameters objectForKey:@"DELAY"] integerValue]) {
                        self.boleroEffectDelaySlider.value=[[effect.parameters objectForKey:@"DELAY"] integerValue];
                        self.boleroEffectDelayLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"DELAY"] integerValue]];
                    }
                }else  if ([effect.name isEqualToString:@"STUDIO"]) {
                    studioEffect.enable=@1;
                    karaokeEffect.enable=@0;
                    liveEffect.enable=@0;
                    NSString *sex=[effect.parameters objectForKey:@"SEX"];
                    if (sex.length>4) {
                        [self changeStudioGender:2];
                    }else{
                        [self changeStudioGender:1];
                    }
                    NSString *chatgiong=[effect.parameters objectForKey:@"VOICETYPE"];
                    if (chatgiong.length>0){
                        if ([chatgiong isEqualToString:@"LOW"]){
                            [self changeStudioCG:1];
                        }else if ([chatgiong isEqualToString:@"MID"]){
                            [self changeStudioCG:2];
                        }else if ([chatgiong isEqualToString:@"HIGH"]){
                            [self changeStudioCG:3];
                        }
                    }
                    NSString *theloai=[effect.parameters objectForKey:@"TEMPOLEVEL"];
                    if (theloai.length>0){
                        if ([theloai isEqualToString:@"SLOW"]){
                            [self changeStudioTL:1];
                        }else if ([theloai isEqualToString:@"MEDIUM"]){
                            [self changeStudioTL:2];
                        }else if ([theloai isEqualToString:@"FAST"]){
                            [self changeStudioTL:3];
                        }
                    }
                }else  if ([effect.name isEqualToString:@"DENOISE"]) {
                    denoiseEffect.enable=@1;
                    NSString *chatgiong=[effect.parameters objectForKey:@"DENOISELEVEL"];
                    
                    if (chatgiong.length>0){
                        if ([chatgiong isEqualToString:@"LOW"]){
                            [self changeDenoiseLevel:1];
                        }else if ([chatgiong isEqualToString:@"MID"]){
                            [self changeDenoiseLevel:2];
                        }else if ([chatgiong isEqualToString:@"HIGH"]){
                            [self changeDenoiseLevel:3];
                        }
                    }else{
                        [self changeDenoiseLevel:2];
                    }
                    
                }else  if ([effect.name isEqualToString:@"AUTOTUNE"]) {
                    autotuneEffect.enable=@1;
                    NSString *key=[effect.parameters objectForKey:@"KEY"];
                    if (key.length>0) {
                        autotuneKey=key;
                        if ([key isEqualToString:@"Auto"]) {
                            [self changeAutotuneAmGiai:1];
                            self.autotuneChuAm.text=@"Auto";
                        }else{
                            NSString *chuam=[key substringToIndex:1];
                            if ([chuam isEqualToString:@"M"]) {
                                [self changeAutotuneAmGiai:1];
                            }else{
                                [self changeAutotuneAmGiai:2];
                            }
                            
                        }
                    }
                    NSString *chatgiong=[effect.parameters objectForKey:@"VIBRATOLEVEL"];
                    if (chatgiong.length>0){
                        if ([chatgiong isEqualToString:@"LOW"]){
                            [self changeAutotuneVibratoLevel:1];
                        }else if ([chatgiong isEqualToString:@"MID"]){
                            [self changeAutotuneVibratoLevel:2];
                        }else if ([chatgiong isEqualToString:@"HIGH"]){
                            [self changeAutotuneVibratoLevel:3];
                        }
                    }
                    chatgiong=[effect.parameters objectForKey:@"AUTOTUNELEVEL"];
                    if (chatgiong.length>0){
                        if ([chatgiong isEqualToString:@"LOW"]){
                            [self changeAutotuneLevel:1];
                        }else if ([chatgiong isEqualToString:@"MID"]){
                            [self changeAutotuneLevel:2];
                        }else if ([chatgiong isEqualToString:@"HIGH"]){
                            [self changeAutotuneLevel:3];
                        }else if ([chatgiong isEqualToString:@"SUPERHIGH"]){
                            [self changeAutotuneLevel:4];
                        }
                    }
                }else  if ([effect.name isEqualToString:@"LIVE"]) {
                    studioEffect.enable=@0;
                    karaokeEffect.enable=@0;
                    liveEffect.enable=@1;
                    NSString *info=@"";
                    if ([[effect.parameters objectForKey:@"ECHO"] integerValue]) {
                        self.liveEffectEchoSlider.value=[[effect.parameters objectForKey:@"ECHO"] integerValue];
                        self.liveEffectEchoLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"ECHO"] integerValue]];
                    }
                    
                    if ([[effect.parameters objectForKey:@"THICK"] integerValue]) {
                        self.liveEffectThickSlider.value=[[effect.parameters objectForKey:@"THICK"] integerValue];
                        self.liveEffectThickLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"THICK"] integerValue]];
                    }
                    if ([[effect.parameters objectForKey:@"WARM"] integerValue]) {
                        self.liveEffectWarmSlider.value=[[effect.parameters objectForKey:@"WARM"] integerValue];
                        self.liveEffectWarmLabel.text=[NSString stringWithFormat:@"%d",[[effect.parameters objectForKey:@"WARM"] integerValue]];
                    }
                }else  if ([effect.name isEqualToString:@"VOICECHANGER"]) {
                    voicechangerEffect.enable=@1;
                    NSString *chatgiong=[effect.parameters objectForKey:@"TYPE"];
                    if (chatgiong.length>0){
                        if ([chatgiong isEqualToString:MALE2FEMALE]){
                            [self changeVoiceChangerEffect:3];
                        }else if ([chatgiong isEqualToString:FEMALE2MALE]){
                            [self changeVoiceChangerEffect:4];
                        }else if ([chatgiong isEqualToString:BABY]){
                            [self changeVoiceChangerEffect:1];
                        }else if ([chatgiong isEqualToString:OLDPERSON]){
                            [self changeVoiceChangerEffect:2];
                        }
                    }
                }
                
            }
        }
        
        [self.xulyViewEffectCollectionView reloadData];
    }
    if (isrecord ){
        [self creatAudioEngine];
        if (audioEngine2.audioController.running==NO) {
            NSError* error;
            
            [audioEngine2.audioController start:&error];
        }
        if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2 ) {
            [audioEngine2 playthroughSwitchChanged:YES];
            [audioEngine2 reverbSwitchChanged:YES];
            [audioEngine2 expanderSwitchChanged:YES];
        }
    }
    [super viewDidAppear:YES];
    if (videoRecord && isrecord) {
        // Start running the flow of buffers
        if (![recorder startRunning]) {
            NSLog(@"Something wrong there: %@", recorder.error);
        }
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    frameNotFull=self.previewView.frame;
    isTabKaraoke=YES;
    isKaraokeTab=YES;
    if (isrecord && !videoRecord) {
        self.recordImage.hidden=NO;
    }else {
        self.recordImage.hidden=YES;
    }
    if (![Language hasSuffix:@"kara"] ){
        if (!playRecord && self.view.frame.size.width>320 && !changeBackground) {
            changeBackground=[NSTimer scheduledTimerWithTimeInterval:timeChangeBackground target:self selector:@selector(changeBackgroun) userInfo:nil repeats:YES];
        }
    }
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(checkHeadSet)
                                                 name: AVAudioSessionRouteChangeNotification
                                               object: session];
}

- (void)highlightButtonDelayed:(UIButton*)button {
    button.highlighted = YES;
}
#pragma mark - MYAudioTabProcessorDelegate

- (void)audioTabProcessor:(MYAudioTapProcessor *)audioTabProcessor hasNewLeftChannelValue:(float)leftChannelValue rightChannelValue:(float)rightChannelValue
{
    // Update left and right channel volume unit meter.
    CGRect frame=self.rulerVolumeV.frame;
    CGRect frame2=self.rulerVolumeView.frame;
    float max=MAX(leftChannelValue, rightChannelValue);
    maxV=MAX(max, maxV);
    if (maxV<0.7) {
        self.rulerVolumMaxView.backgroundColor=UIColorFromRGB(0x62C47B);
    }else if (maxV<1.0) {
        self.rulerVolumMaxView.backgroundColor=UIColorFromRGB(0xFDA945);
    }else if (maxV<20) {
        self.rulerVolumMaxView.backgroundColor=UIColorFromRGB(ColorSlider);
    }
    if (max>1.5) max=1.5;
    frame2.origin.x=frame.origin.x+1+(frame.size.width*max/1.5);
    frame2.size.width=frame.size.width-(frame.size.width*max/1.5)-1;
    self.rulerVolumeView.frame=frame2;
   // self.rightChannelVolumeUnitMeterView.value = rightChannelValue;
}

#pragma mark Effect Video



- (IBAction)showMenuEffects:(id)sender {
    if (self.colectionView.isHidden){
        // self.colectionView.hidden=NO;
        self.xulyView.hidden=YES;
    }
    else{
        // self.colectionView.hidden=YES;
        self.xulyView.hidden=NO;
    }
}
- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}
- (void)createListEffectVideo:(NSString *)path{
    
    SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:[NSURL fileURLWithPath:path] info:nil];
    //recordSession=[SCRecordSession recordSession];
   // [recordSession addSegment:segment];
    audioPlayer = [SCPlayer player];
    currentEffectID=0;
    self.currentFilter=[SCFilter emptyFilter];
    //video effects
    if (![songRec->hasUpload isEqualToString:@"YES"]) {
        self.hieuungButton.hidden=NO;
        
    }
    self.playerLayerViewRec.hidden=NO;
    // playerLayerViewRec.frame=CGRectMake(0,self.headerView.frame.size.height+self.colectionView.frame.size.height,self.view.frame.size.width, self.view.frame.size.height-self.toolBar.frame.origin.y-self.colectionView.frame.size.height) ;
  //  [audioPlayer setItemByAsset:recordSession.assetRepresentingSegments];
    //SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:audioPlayer];
    //playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // [self.playerLayerViewRec.playerLayer setPlayer:audioPlayer];
    //NSLog(@"%f %f %f",.frame.size.width,self.playerLayerViewRec.frame.size.width,self.view.frame.size.width);
    // [self.ToolbarView setFrame:CGRectMake(0,self.playerLayerView.frame.origin.y+ self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height-self.playerLayerView.frame.size.height)];
    /*
     if ([[NSProcessInfo processInfo] activeProcessorCount] > 1) {
     self.filterSwitcherView.contentMode = UIViewContentModeScaleAspectFit;
     self.filterSwitcherView.frame=audioPlayer.SCImageView.bounds;
     SCFilter *emptyFilter = [SCFilter emptyFilter];
     emptyFilter.name = @"#nofilter";
     
     self.filterSwitcherView.filters = @[
     emptyFilter,
     [SCFilter filterWithCIFilterName:@"CIColorCube"],
     [SCFilter filterWithCIFilterName:@"CILightenBlendMode"],[SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"],
     [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
     [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
     [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"],
     [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"]
     // Adding a filter created using CoreImageShop
     //[SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]]
     //  [self createAnimatedFilter]
     ];
     audioPlayer.SCImageView = self.filterSwitcherView;
     // [self.filterSwitcherView addObserver:self forKeyPath:@"selectedFilter" options:NSKeyValueObservingOptionNew context:nil];
     } else {
     SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:audioPlayer];
     playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
     playerView.frame = self.filterSwitcherView.frame;
     playerView.autoresizingMask = self.filterSwitcherView.autoresizingMask;
     [self.filterSwitcherView.superview insertSubview:playerView aboveSubview:self.filterSwitcherView];
     [self.filterSwitcherView removeFromSuperview];
     }*/
    
    //audioPlayer.loopEnabled=YES;
    // dispatch_async( dispatch_get_main_queue(),
    //              ^{
    //self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
   // filterView = [[SCFilterImageView alloc] initWithFrame:CGRectMake(0, 0, self.playerLayerViewRec.layer.frame.size.width, self.playerLayerViewRec.layer.frame.size.height)];
    filterView.scaleAndResizeCIImageAutomatically=YES;
    filterView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  //  [filterView setFilter:[SCFilter emptyFilter]];
//    audioPlayer.SCImageView = filterView;
    // [audioPlayer.SCImageView setContentMode:UIViewContentModeTopRight];
    
    [self.playerLayerViewRec insertSubview:filterView atIndex:2];
    //            });
    NSLog(@"filterView %f %f %f",filterView.frame.size.width,filterView.frame.size.height,self.playerLayerViewRec.frame.origin.y);
    NSBundle* bun = [YokaraSDK resourceBundle];
    [self.colectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
    //self.colectionView.backgroundColor=[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.8];
    self.colectionView.delegate=self;
    self.colectionView.dataSource=self;
    
    if (isKaraokeTab){
        // [self initScrubberTimer2];
    }
    //[self enableScrubber];
    //[self enablePlayerButtons];
    
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem2 = [audioPlayer currentItem];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem2 addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext2];
    hasObser2=YES;
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd2:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem2];
    
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=audioPlayer.currentItem;
    if (item != playerItem2)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [audioPlayer replaceCurrentItemWithPlayerItem:playerItem2];
        item=nil;
        //[self syncPlayPauseButtons];
    }
    
    
    if (listEffect==nil) listEffect=[NSMutableArray new];
    Effect * ef=[Effect new];
    ef.name=NSLocalizedString( @"None",nil);
    ef.filter=[SCFilter emptyFilter];
    ef.image=@"song_Hye_Kyo.png";
    [listEffect addObject:ef];
    currentEffect=ef;
    Effect * ef1=[Effect new];
    ef1.name=NSLocalizedString( @"Mono",nil);
    ef1.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectMono"];
    ef1.image=@"hieu_ung_(1).png";
    [listEffect addObject:ef1];
    Effect * ef5=[Effect new];
    ef5.name=NSLocalizedString( @"Tonal",nil);
    ef5.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"];
    ef5.image=@"hieu_ung_(2).png";
    [listEffect addObject:ef5];
    Effect * ef6=[Effect new];
    Effect * ef2=[Effect new];
    ef2.name=NSLocalizedString( @"Noir",nil);
    ef2.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"];
    ef2.image=@"hieu_ung_(3).png";
    [listEffect addObject:ef2];
    ef6.name=NSLocalizedString( @"Fade",nil);
    ef6.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"];
    ef6.image=@"hieu_ung_(4).png";
    [listEffect addObject:ef6];
    Effect * ef3=[Effect new];
    ef3.name=NSLocalizedString( @"Chrome",nil);
    ef3.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"];
    ef3.image=@"hieu_ung_(5).png";
    [listEffect addObject:ef3];
    Effect * ef7=[Effect new];
    ef7.name=NSLocalizedString( @"Process",nil);
    ef7.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectProcess"];
    ef7.image=@"hieu_ung_(6).png";
    [listEffect addObject:ef7];
    Effect * ef9=[Effect new];
    ef9.name=NSLocalizedString( @"Transfer",nil);
    ef9.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectTransfer"];
    ef9.image=@"hieu_ung_(7).png";
    [listEffect addObject:ef9];
    Effect * ef4=[Effect new];
    ef4.name=NSLocalizedString( @"Instant",nil);
    ef4.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
    ef4.image=@"hieu_ung_(8).png";
    [listEffect addObject:ef4];
    
    /*
     
     Effect * ef8=[Effect new];
     ef8.name=@"SepiaTone";
     ef8.filter=[SCFilter filterWithCIFilterName:@"CISepiaTone"];
     ef8.image=@"song_Hye_Kyo.png";
     [listEffect addObject:ef6];
     Effect * ef19=[Effect new];
     ef19.name=@"Image Shop";
     ef19.filter=[SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]];
     ef19.image=@"song_Hye_Kyo.png";
     [listEffect addObject:ef19];*/
}

- (void) updateFilterFrame{
    @autoreleasepool {
        
        
        filterView.frame=CGRectMake(0,0, playerLayerViewRec.playerLayer.videoRect.size.width, playerLayerViewRec.playerLayer.videoRect.size.height) ;
        if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
            CGPoint center=filterView.center;
            center.y=self.playerLayerViewRec.center.y;
            filterView.center=center;
        }else{
            CGPoint center=filterView.center;
            center.x=self.playerLayerViewRec.center.x;
            filterView.center=center;
        }
    }
}
- (IBAction)hideDelayVIPView:(id)sender {

   // [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
 
    if (VipMember ) {
        [_audioTapProcessor updateVolumeVideo:0 ];
        [_audioTapProcessor updateVolumeAudio:0 ];
        maxV=0;
    }
    playerMain.muted=YES;
    if (duetVideoPlayer ) {
        duetVideoPlayer.muted=YES;
    }
    
   
    //[self checkPlaying1];
}
- (IBAction)showDelayVIPView:(id)sender {
    
    [self.karaokeEffectPlayerView removeFromSuperview];
   
    self.karaokeEffectPlayerView.hidden=NO;
    
   // if (![songRec.performanceType isEqualToString:@"DUET"]) {
   
    //}
   
    
    [_audioTapProcessor updateVolumeVideo:(int)(powf((float)[songRec.effectsNew.vocalVolume intValue]/100,1.6666)*100 )];
    [_audioTapProcessor updateVolumeAudio:(int)(powf((float)[songRec.effectsNew.beatVolume intValue]/100,1.6666)*100 )];
    
    maxV=0;
   // [self checkPlaying1];
    
}
#pragma mark collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView==self.xulyViewEffectCollectionView) {
        return 6;
    }
    if (collectionView==self.xulyMenuToolbarCollectionView) {
        return 5;
    }
    if (collectionView==self.xulyViewAutotuneEffectCollectionView) {
        return 5;
    }
    if (collectionView==self.xulyViewChangeVoiceEffectCollectionView) {
        return 5;
    }
    if (collectionView==self.xulyViewDenoiseEffectCollectionView) {
        return 4;
    }
    return [listEffect  count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.xulyViewEffectCollectionView) {
        return CGSizeMake(80 , 80 );
    }
    if (collectionView==self.xulyMenuToolbarCollectionView) {
        return CGSizeMake(80   , 50 );
    }
    if (collectionView==self.xulyViewAutotuneEffectCollectionView) {
        return CGSizeMake(80  , 80 );
    }
    if (collectionView==self.xulyViewChangeVoiceEffectCollectionView) {
        return CGSizeMake(80  , 80 );
    }
    if (collectionView==self.xulyViewDenoiseEffectCollectionView) {
        return CGSizeMake(80  , 80 );
    }
    CGSize size= CGSizeMake(60  , 85  );
    
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    if (collectionView==self.xulyMenuToolbarCollectionView) {
        EffectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.isChosse.hidden=YES;
        cell.titleLabel.font=[UIFont systemFontOfSize:9];
        if (xulyViewMenuSelected==indexPath.row) {
            cell.isSelected.hidden=NO;
        }else{
            cell.isSelected.hidden=YES;
        }
        cell.icnVip.hidden=YES;
        switch (indexPath.row) {
            case 0:
                if (xulyViewMenuSelected==0) {
                    cell.imageView.image=[UIImage imageNamed:@"Artboard 1.1.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    
                }else
                cell.imageView.image=[UIImage imageNamed:@"Artboard 1.2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=AMLocalizedString(@"ÂM LƯỢNG", nil);
                
                break;
            case 1:
                if (xulyViewMenuSelected==1) {
                    cell.imageView.image=[UIImage imageNamed:@"Artboard 2.1.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else
                cell.imageView.image=[UIImage imageNamed:@"Artboard 2.2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=AMLocalizedString(@"CƠ BẢN", nil);
                
                break;
            case 2:
                if (xulyViewMenuSelected==2) {
                    cell.imageView.image=[UIImage imageNamed:@"Artboard 3.1.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else
                cell.imageView.image=[UIImage imageNamed:@"Artboard 3.2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"LỌC ỒN";
                if (!VipMember) {
                    cell.icnVip.hidden=NO;
                }
                break;
            case 3:
                if (xulyViewMenuSelected==3) {
                    cell.imageView.image=[UIImage imageNamed:@"Artboard 4.1.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else
                cell.imageView.image=[UIImage imageNamed:@"Artboard 4.2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"AUTOTUNE";
                if (!VipMember) {
                    cell.icnVip.hidden=NO;
                }
                break;
            case 4:
                if (xulyViewMenuSelected==4) {
                    cell.imageView.image=[UIImage imageNamed:@"Artboard 6.1.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else
                cell.imageView.image=[UIImage imageNamed:@"Artboard 6.2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"GIẢ GIỌNG";
                if (!VipMember) {
                    cell.icnVip.hidden=NO;
                }
                break;
            
            default:
                break;
        }
        
        cell.actionButton.tag=indexPath.row;
         [cell.actionButton addTarget:self action:@selector(xulyViewMenuSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else if (collectionView==self.xulyViewDenoiseEffectCollectionView) {
        EffectCollectionViewCell4 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.isChoose.hidden=YES;
        if (denoiseEffectLevel!=indexPath.row) {
            cell.imageView.layer.borderColor=[[UIColor clearColor] CGColor];
        }else{
            cell.isChoose.hidden=NO;
            cell.imageView.layer.borderColor=[UIColorFromRGB(ColorSlider)   CGColor];
        }
        [cell.isChoose setImage:[UIImage imageNamed:@"noedit.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        cell.imageView.layer.borderWidth=1;
        switch (indexPath.row) {
            case 0:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_none.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Không";
                
                break;
            case 1:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_little.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Ít";
                break;
            case 2:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_medium.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Vừa";
                break;
            case 3:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_much.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Nhiều";
                break;
            
            default:
                break;
        }
         [cell.actionButton addTarget:self action:@selector(selectDenoiseEffect:) forControlEvents:UIControlEventTouchUpInside];
        cell.actionButton.tag=indexPath.row;
        return cell;
    }else  if (collectionView==self.xulyViewAutotuneEffectCollectionView) {
        EffectCollectionViewCell4 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.isChoose.hidden=YES;
        if (autotuneEffectLevel!=indexPath.row) {
            cell.imageView.layer.borderColor=[[UIColor clearColor] CGColor];
            
        }else{
            cell.imageView.layer.borderColor=[UIColorFromRGB(ColorSlider)   CGColor];
            if (indexPath.row!=0) {
                [cell.isChoose setImage:[UIImage imageNamed:@"canedit.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }else{
                [cell.isChoose setImage:[UIImage imageNamed:@"noedit.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }
            cell.isChoose.hidden=NO;
        }
        
        cell.imageView.layer.borderWidth=1;
        switch (indexPath.row) {
            case 0:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_none.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Không";
                
                break;
            case 1:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_little.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Ít";
                break;
            case 2:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_medium.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Vừa";
                break;
            case 3:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_much.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Nhiều";
                break;
            case 4:
                [cell.imageView setImage:[UIImage imageNamed:@"effect_verymuch.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                cell.titleLabel.text=@"Rất nhiều";
                break;
            default:
                break;
        }
        [cell.actionButton addTarget:self action:@selector(selectAutotuneEffect:) forControlEvents:UIControlEventTouchUpInside];
        cell.actionButton.tag=indexPath.row;
        [cell.isChoose addTarget:self action:@selector(selectAutotuneEffect:) forControlEvents:UIControlEventTouchUpInside];
        cell.isChoose.tag=indexPath.row;
        return cell;
    }else
        if (collectionView==self.xulyViewChangeVoiceEffectCollectionView) {
            EffectCollectionViewCell4 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.isChoose.hidden=YES;
           [cell.isChoose setImage:[UIImage imageNamed:@"noedit.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            if (changeVoiceEffectLevel!=indexPath.row) {
                cell.imageView.layer.borderColor=[[UIColor clearColor] CGColor];
            }else{
                cell.isChoose.hidden=NO;
                cell.imageView.layer.borderColor=[UIColorFromRGB(ColorSlider)   CGColor];
            }
            cell.imageView.layer.borderWidth=1;
            switch (indexPath.row) {
                case 0:
                    [cell.imageView setImage:[UIImage imageNamed:@"effect_none.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    cell.titleLabel.text=@"Không";
                    
                    break;
                case 1:
                    [cell.imageView setImage:[UIImage imageNamed:@"effect_voicechange_baby.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                   
                    cell.titleLabel.text=@"Em bé";
                    break;
                case 2:
                    [cell.imageView setImage:[UIImage imageNamed:@"effect_voicechange_oldman.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    cell.titleLabel.text=@"Người già";
                    break;
                case 3:
                    [cell.imageView setImage:[UIImage imageNamed:@"effect_voicechange_male2female.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    cell.titleLabel.text=@"Nam giả nữ";
                    break;
                case 4:
                    [cell.imageView setImage:[UIImage imageNamed:@"effect_voicechange_female2male.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    cell.titleLabel.text=@"Nữ giả nam";
                    break;
                default:
                    break;
            }
            [cell.actionButton addTarget:self action:@selector(selectVoiceChangerEffect:) forControlEvents:UIControlEventTouchUpInside];
            cell.actionButton.tag=indexPath.row;
            return cell;
        }else
    if (collectionView==self.xulyViewEffectCollectionView) {
        EffectCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.isChosse.hidden=YES;
        cell.isChosse.layer.borderColor=[UIColorFromRGB(ColorSlider)   CGColor];
        cell.isChosse.layer.borderWidth=1;
        switch (indexPath.row) {
            case 0:
                cell.imageView.image=[UIImage imageNamed:@"karaoke.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Karaoke";
                if ([karaokeEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=YES;
                break;
            case 1:
                cell.imageView.image=[UIImage imageNamed:@"live.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Live";
                if ([liveEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            case 2:
                cell.imageView.image=[UIImage imageNamed:@"studio.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Studio";
                if ([studioEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            case 3:
                cell.imageView.image=[UIImage imageNamed:@"SuperBass.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Super Bass";
                if ([superbassEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            case 4:
                cell.imageView.image=[UIImage imageNamed:@"Bolero.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Bolero";
                if ([boleroEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            case 5:
                cell.imageView.image=[UIImage imageNamed:@"Remix.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Remix";
                if ([remixEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            /*case 6:
                cell.imageView.image=[UIImage imageNamed:@"denoise.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Lọc ồn";
                if ([denoiseEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            case 7:
                cell.imageView.image=[UIImage imageNamed:@"autotune.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Auto tune";
                if ([autotuneEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;
            
            case 8:
                cell.imageView.image=[UIImage imageNamed:@"voicechanger.jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.titleLabel.text=@"Chuyển giọng";
                if ([voicechangerEffect.enable integerValue]) {
                    cell.isChosse.hidden=NO;
                }else{
                    cell.isChosse.hidden=YES;
                }
                cell.icnVIP.hidden=NO;
                break;*/
            default:
                break;
        }
        
        if (VipMember  ) {
            cell.icnVIP.hidden=YES;
        }
        
        // [cell.actionButton addTarget:self action:@selector(selectSoundEffect:) forControlEvents:UIControlEventTouchUpInside];
        // [cell.tapGestureActionButton addTarget:self action:@selector(selectSoundEffect:)];
        //[cell.longPressGestureActionButton addTarget:self action:@selector(selectSoundEffectInfo:)];
        //[cell.tapGestureActionButton requireGestureRecognizerToFail:cell.longPressGestureActionButton];
        cell.actionButton.tag=indexPath.row;
        if (cell.actionButton.gestureRecognizers.count==0) {
            
            UITapGestureRecognizer *tapOnButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSoundEffect:)];
            // while (cell.actionButton.gestureRecognizers.count) {
            //    [cell.actionButton removeGestureRecognizer:[cell.actionButton.gestureRecognizers objectAtIndex:0]];
            // }
            
            [cell.actionButton addGestureRecognizer:tapOnButton];
            
            UILongPressGestureRecognizer *longPressOnButton = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selectSoundEffectInfo:)];
            // longPressOnButton.delegate = self;
            cell.actionButton.userInteractionEnabled = YES;
            
            [cell.actionButton addGestureRecognizer:longPressOnButton];
            [tapOnButton requireGestureRecognizerToFail:longPressOnButton];
        }
        
        
        
        return cell;
    }else{
        EffectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        Effect * effect;
        effect=[listEffect objectAtIndex:indexPath.row];
        // recipeImageView.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
        //[cell.imageView setImageWithURL:[NSURL URLWithString:[effect.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]  placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType type){  }];
        cell.imageView.image=[UIImage imageNamed:effect.image];
        cell.actionButton.tag=indexPath.row;
        [cell.actionButton addTarget:self action:@selector(selectEffect:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel.text=[NSString stringWithFormat:@"%@",effect.name ];
        if (currentEffectID==indexPath.row) {
            // cell.backgroundColor=[UIColor brownColor];
            cell.isChosse.image=[UIImage imageNamed:@"chon_hieu_ung.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }else{
            cell.isChosse.image=[UIImage imageNamed:@"khong_hieu_ung.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            //cell.backgroundColor=[UIColor colorWithRed:211/255.0f green:214/255.0f blue:219/255.0f alpha:0.79f];
        }
        
        return cell;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)removeAllNormalEffect{
    if ([karaokeEffect.enable integerValue]) {
        karaokeEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:@"KARAOKE"];
    }
    if ([studioEffect.enable integerValue]) {
        studioEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:@"STUDIO"];
    }
    if ([liveEffect.enable integerValue]) {
        liveEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:@"LIVE"];
    }
    if ([superbassEffect.enable integerValue]) {
        superbassEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:Key_SuperBass];
    }
    if ([boleroEffect.enable integerValue]) {
        boleroEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:Key_Bolero];
    }
    if ([remixEffect.enable integerValue]) {
        remixEffect.enable=@0;
        [songRec.effectsNew.effects removeObjectForKey:Key_Remix];
    }
}
- (IBAction)selectSoundEffect:(id)sender{
    // UIButton *btn=(UIButton *) sender;
    //NSInteger row=btn.tag;
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    NSInteger row=recognizer.view.tag;
    NSLog(@"selectSoundEffect %d",row);
    
    switch (row) {
        case 0:
           
            if (![karaokeEffect.enable integerValue]) {
                [self removeAllNormalEffect];
                karaokeEffect.enable=@1;
                
                [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
                
            }else{
                [self hideAllXulySubView];
                self.xulyMenuToolbarCollectionView.hidden=YES;
                self.karaokeEffectView.hidden=NO;
                //[self.karaokeEffectView addSubview:self.karaokeEffectPlayerView];
               
                self.karaokeEffectBassLabel.text=[NSString stringWithFormat:@"%.0f",[[karaokeEffect.parameters objectForKey:@"BASS"] floatValue] /2+50];
                self.karaokeEffectBassSlider.value=[[karaokeEffect.parameters objectForKey:@"BASS"] floatValue]/2+50;
                self.karaokeEffectEchoLabel.text=[NSString stringWithFormat:@"%.0f",[[karaokeEffect.parameters objectForKey:@"ECHO"] floatValue] ];
                self.karaokeEffectEchoSlider.value=[[karaokeEffect.parameters objectForKey:@"ECHO"] floatValue];
                self.karaokeEffectTrebleLabel.text=[NSString stringWithFormat:@"%.0f",[[karaokeEffect.parameters objectForKey:@"TREBLE"] floatValue]/2+50 ];
                self.karaokeEffectTrebleSlider.value=[[karaokeEffect.parameters objectForKey:@"TREBLE"] floatValue]/2+50;
            }
            if (VipMember  ) {
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
            }
            [self.xulyViewEffectCollectionView reloadData];
            break;
        case 1:
            if (VipMember  ) {
                if (![liveEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    liveEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
                    
                    
                }else{
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.liveEffectView.hidden=NO;
                    self.liveEffectSwitch.on=[liveEffect.enable integerValue]==1;
                    if (![liveEffect isKindOfClass:[NewEffect class]]) {
                        liveEffect=[NewEffect new];
                        liveEffect.preset=@"DEFAULT";
                        liveEffect.version=@1;
                        liveEffect.name=@"LIVE";
                        
                    }
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 2:
            if (VipMember  ) {
                if (![studioEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    studioEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
                    
                    
                }else{
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.studioEffectView.hidden=NO;
                    //[self.studioEffectView addSubview:self.karaokeEffectPlayerView];
                   /* self.studioEffectSwitch.on=[studioEffect.enable integerValue]==1;
                    if ([songRec.song.bpm integerValue]==0) {
                        [self changeStudioTL:2];
                    }else
                        if ([songRec.song.bpm integerValue]<=90) {
                            [self changeStudioTL:1];
                        }else if ([songRec.song.bpm integerValue]>120) {
                            [self changeStudioTL:3];
                        }else{
                            [self changeStudioTL:2];
                        }*/
                }
                [self.xulyViewEffectCollectionView reloadData];
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 3:
            if (VipMember  ) {
                if (![superbassEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    superbassEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
                    
                    
                }else{
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.superBassEffectView.hidden=NO;
                    
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 4:
            if (VipMember  ) {
                if (![boleroEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    boleroEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
                    
                    
                }else{
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.boleroEffectView.hidden=NO;
                   
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 5:
            if (VipMember  ) {
                if (![remixEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    remixEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
                    
                    
                }else{
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.remixEffectView.hidden=NO;
                    
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 6:
            if (VipMember  ) {
                if (![denoiseEffect.enable integerValue]) {
                    denoiseEffect.enable=@1;
                    [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
                }else{
                    denoiseEffect.enable=@0;
                    [songRec.effectsNew.effects  removeObjectForKey:@"DENOISE"];
                }
                [self.xulyViewEffectCollectionView reloadData];
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 7:
            if (VipMember  ) {
                if (![autotuneEffect.enable integerValue]) {
                    autotuneEffect.enable=@1;
                    [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
                }else{
                    autotuneEffect.enable=@0;
                    [songRec.effectsNew.effects  removeObjectForKey:@"AUTOTUNE"];
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        case 8:
            if (VipMember  ) {
                
                if (![voicechangerEffect.enable integerValue]) {
                    voicechangerEffect.enable=@1;
                    
                    [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
                    
                    
                }else{
                    voicechangerEffect.enable=@0;
                    [songRec.effectsNew.effects removeObjectForKey:@"VOICECHANGER"];
                }
                [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                [self.xulyViewEffectCollectionView reloadData];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            break;
        default:
            break;
    }
}
- (IBAction)selectSoundEffectInfo:(id)sender{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        NSInteger row=recognizer.view.tag;
        NSLog(@"selectSoundEffectInfo %d",row);
        switch (row) {
            case 0:
                if (![karaokeEffect.enable integerValue]) {
                    [self removeAllNormalEffect];
                    karaokeEffect.enable=@1;
                   
                    
                    [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
                    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    
                }
                [self hideAllXulySubView];
                self.xulyMenuToolbarCollectionView.hidden=YES;
                self.karaokeEffectView.hidden=NO;
                
                break;
            case 1:
                if (VipMember  ) {
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.liveEffectView.hidden=NO;
                   
                    if (![liveEffect.enable integerValue]) {
                        [self removeAllNormalEffect];
                        liveEffect.enable=@1;
                        
                        [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
                        
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                break;
            case 2:
                if (VipMember  ) {
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.studioEffectView.hidden=NO;
                    
                    if (![studioEffect.enable integerValue]) {
                        [self removeAllNormalEffect];
                        studioEffect.enable=@1;
                      
                        [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
                        
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                
                break;
            case 3:
                if (VipMember  ) {
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.superBassEffectView.hidden=NO;
                    
                    if (![superbassEffect.enable integerValue]) {
                        [self removeAllNormalEffect];
                        superbassEffect.enable=@1;
                        
                        [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
                        
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                
                break;
            case 4:
                if (VipMember  ) {
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.boleroEffectView.hidden=NO;
                    
                    if (![boleroEffect.enable integerValue]) {
                        [self removeAllNormalEffect];
                        boleroEffect.enable=@1;
                        
                        [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                
                break;
            case 5:
                if (VipMember  ) {
                    [self hideAllXulySubView];
                    self.xulyMenuToolbarCollectionView.hidden=YES;
                    self.remixEffectView.hidden=NO;
                    
                    /* if ([songRec.song.bpm integerValue]==0) {
                     [self changeStudioTL:2];
                     }else
                     if ([songRec.song.bpm integerValue]<=90) {
                     [self changeStudioTL:1];
                     }else if ([songRec.song.bpm integerValue]>120) {
                     [self changeStudioTL:3];
                     }else{
                     [self changeStudioTL:2];
                     }*/
                    if ([remixEffect.enable integerValue]==0) {
                        [self removeAllNormalEffect];
                        remixEffect.enable=@1;
                        
                        [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
                        
                        [self.xulyViewEffectCollectionView reloadData];
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                
                break;
            case 6:
                if (VipMember  ) {
                    self.denoiseEffectView.hidden=NO;
                    self.denoiseEffectSwitch.on=[denoiseEffect.enable integerValue]==1;
                    if (![denoiseEffect.enable integerValue]) {
                        denoiseEffect.enable=@1;
                        [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
                        [self.xulyViewEffectCollectionView reloadData];
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                break;
            case 7:
                if (VipMember  ) {
                    self.autotuneEffectView.hidden=NO;
                    self.autotuneEffectSwitch.on=[autotuneEffect.enable integerValue]==1;
                    if (![autotuneEffect isKindOfClass:[NewEffect class]]) {
                        autotuneEffect=[NewEffect new];
                        autotuneEffect.preset=@"DEFAULT";
                        autotuneEffect.version=@1;
                        autotuneEffect.name=@"AUTOTUNE";
                        [self changeAutotuneLevel:0];
                    }
                    if (songRec.song.key.length>0) {
                        [autotuneEffect.parameters setObject:songRec.song.key forKey:@"KEY"];
                    }else{
                        [autotuneEffect.parameters setObject:@"Auto" forKey:@"KEY"];
                    }
                    if (![autotuneEffect.enable integerValue]) {
                        autotuneEffect.enable=@1;
                        [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                        
                        [self.xulyViewEffectCollectionView reloadData];
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                break;
                
            case 8:
                if (VipMember  ) {
                    self.voiceChangerEffectView.hidden=NO;
                    self.voiceChangerEffectSwitch.on=[voicechangerEffect.enable integerValue]==1;
                    if (![voicechangerEffect isKindOfClass:[NewEffect class]]) {
                        voicechangerEffect=[NewEffect new];
                        voicechangerEffect.preset=@"DEFAULT";
                        voicechangerEffect.version=@1;
                        voicechangerEffect.name=@"VOICECHANGER";
                        
                    }
                    if (![voicechangerEffect.enable integerValue]) {
                        voicechangerEffect.enable=@1;
                        
                        [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
                        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                        [self.xulyViewEffectCollectionView reloadData];
                        
                    }
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                break;
            default:
                break;
        }
    }
    
}
- (IBAction)selectEffect:(id)sender{
    UIButton *btn=(UIButton *) sender;
    NSInteger row=btn.tag;
    
    currentEffect=[listEffect objectAtIndex:row];
    currentEffectID=row;
    songRec.effects.effectVideo=currentEffect.name;
  
    [self.colectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
}
#pragma mark Xu Ly Record
- (void) gotoXulyView:(NSString *)path{
    if (path==nil) {
        path=@"";
    }
    NSURL *audioFileURL= [NSURL fileURLWithPath:path];
    
    
    if (isVoice && audioEngine2) {
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 reverbSwitchChanged:NO];
    }
    if (recorder.isPrepared) {
        [recorder unprepare];
        [recorder stopRunning];
    }
    
    NSError *error;
    if (videoRecord) {
        playVideoRecorded=YES;
    }else{
        playVideoRecorded=NO;
    }
    
   // do {
    //    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    //} while (songRec->isConvert);
    iSongPlay=songRec;
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (haveS)  {
        
        if (songRec){
            // if ([songRec->hasUpload isEqualToString:@"YES"]) {
            self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
            /*  }else{
             self.deplayLabel.text=[NSString stringWithFormat:@"%d",(int)([songRec.delay floatValue]*1000)];
             }*/
        }
        self.volumeMusic.value=[songRec.effectsNew.beatVolume floatValue];
      
        //[audioPlayRecorder setVolume:[songRec.effects.vocalVolume floatValue]/100];
        self.volumeVocal.value=[songRec.effectsNew.vocalVolume floatValue];
      
        self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeMusic.value] intValue]];
       
        self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeVocal.value] intValue]];
        self.xulyView.hidden=NO;
        
        
        if (haveS)  {
            isPlayingAu=NO;
            
            playRecord=YES;
            
            songRec.owner=currentFbUser;
            
            /*
             if (songRec.mixedRecordingVideoUrl){
             if (songRec.mixedRecordingVideoUrl.length>5)
             playVideoRecorded=YES;
             else playVideoRecorded=NO;
             }else playVideoRecorded=NO;*/
            isrecord=NO;
            videoRecord=NO;
            playTopRec=NO;
            playRecUpload =NO;
            
            if ([self isPlayingAudio])
                [audioPlayer pause];
          
            unload =YES;
            if ([self isPlaying]) [playerMain pause];
            [checkPlaying invalidate];
            checkPlaying=nil;
            vitriUpRec=dataRecord.count-1;
            StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
            // [[MainViewController alloc] initWithPlayer:nil];
            if (![songRec.performanceType isEqualToString:@"SOLO"]) {
                mainv.delayLyricDuet=self.delayLyricDuet;
            }
            mainv.deviceCamera=self.deviceCamera;
            if (self.recordSession) {
                mainv.recordSession=self.recordSession;
                mainv.currentFilter=self.currentFilter;
            }
           // gotoXulyView = YES;
           [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushViewFromPrepare" object:mainv];
            
           // [self.navigationController pushViewController:mainv animated:NO];
        }
        
        
        
        
    }
}
- (void) addrecordS{
    @autoreleasepool {
        
        
        [[LoadData2 alloc] addRecord:songRec];
    }
}
NSInteger vitriuploadRec;
- (IBAction)reRecordPress:(id)sender {
    alertReRecord=[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                             message:AMLocalizedString(@"Quá trình thu âm bị lỗi bạn nên bắt đầu thu âm lại!", nil)
                                            delegate:self
                                   cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                   otherButtonTitles:nil];
    [alertReRecord show];
}
- (IBAction)continueRecordMenuPress:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordImage.hidden=NO;
        self.saveRecordView.hidden=YES;
    });
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
}
- (IBAction)saveRecordMenuPress:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
    
    if (youtubePlayer.currentTime>60 || (CMTimeGetSeconds(playerMain.currentTime)>60)){
        self.isLoading.hidden=NO;
        if (videoRecord) {
            
            isrecord=NO;
            isRecorded=NO;
            //songRec.performanceType=@"SOLO";
            
            if (hasHeadset) {
                songRec.recordDevice=@"HEADSET";
            }else{
                songRec.recordDevice=@"NOHEADSET";
            }
            if ( audioPlayer) [audioPlayer pause];
            [audioPlayRecorder pause];
            if ([self isPlaying]) [playerMain pause];
            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                [youtubePlayer pauseVideo];
            }
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            isPlayingAu=NO;
            if (isVoice  && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            [recorder pause:^{
                
                if (playTopRec) {
                    //playTopRec=NO;
                    if (iSongPlay){
                        if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                    }
                }
                
                
                
                self.finishRecordView.hidden=YES;
                if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                    songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                }else{
                    songRec.song.songUrl=songPlay.songUrl;
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                    self.delayLyricDuet=delayRec;
                }
                if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                    songRec.effectsNew=[NewEffects new];
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                
                songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                
                songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                songRec.effects.treble=[NSNumber numberWithInt: 30];
                songRec.effects.echo=[NSNumber numberWithInt: 50];
                songRec.effects.bass=[NSNumber numberWithInt: 20];
                songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                
                songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                ///
                isRecorded=NO;
                
                vitriuploadRec++;
                
                isrecord=NO;
                delayRec=0;
                //songRecOld=nil;
                if (isVoice  && audioEngine2) {
                    [audioEngine2 playthroughSwitchChanged:NO];
                    [audioEngine2 reverbSwitchChanged:NO];
                }
                
                // [[MainViewController alloc] initWithPlayer:nil];
                //   [self presentViewController:mainv animated:YES completion:nil];
                
                
                self.recordSession=[recorder session];
                if (videoRecord) {
                    // pushRecordTab=YES;
                    [self gotoXulyView:songRec.vocalUrl];
                    //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    // [self.navigationController popViewControllerAnimated:YES];
                   // NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                   // songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    
                    
                    
                    
                }
                else{
                    [self gotoXulyView:songRec.vocalUrl];
                    
                }
                
               // [dataRecord insertObject:songRec atIndex:0];
                //[NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                
            }];
            
        }else{
            isRecorded=NO;
            // songRec.performanceType=@"SOLO";
            
            if (hasHeadset) {
                songRec.recordDevice=@"HEADSET";
            }else{
                songRec.recordDevice=@"NOHEADSET";
            }
            if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                songRec.effectsNew=[NewEffects new];
            }
            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
            songRec.effectsNew.delay=songRec.delay;
            
            songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
            songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
            
            songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
            songRec.effects.treble=[NSNumber numberWithInt: 30];
            songRec.effects.echo=[NSNumber numberWithInt: 50];
            songRec.effects.bass=[NSNumber numberWithInt: 20];
            songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
            
            songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
            songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
            /*    if (recordWithBluetooth) {
             
             [recordBluetooth stop];
             }else{*/
            [audioEngine2 record];
            audioEngine2.recorder=nil;
            
            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                [youtubePlayer pauseVideo];
            }
            if (playTopRec) {
                //playTopRec=NO;
                if (iSongPlay){
                    if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                }
            }
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            isPlayingAu=NO;
            if (isVoice  && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            
            
            if ( audioPlayer.rate) [audioPlayer pause];
            
            if ([self isPlaying]) [playerMain pause];
            
            
            // recoder =[RecorderController new];
            // [recoder stopRecord];
            //isrecord=NO;
            
            self.finishRecordView.hidden=YES;
            if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
            }else{
                songRec.song.songUrl=songPlay.songUrl;
            }
            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
            songRec.effectsNew.delay=songRec.delay;
            if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                self.delayLyricDuet=delayRec;
            }
            if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                songRec.effectsNew=[NewEffects new];
            }
            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
            songRec.effectsNew.delay=songRec.delay;
            
            songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
            songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
            
            songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
            songRec.effects.treble=[NSNumber numberWithInt: 30];
            songRec.effects.echo=[NSNumber numberWithInt: 50];
            songRec.effects.bass=[NSNumber numberWithInt: 20];
            songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
            
            songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
            songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
            ///
            isRecorded=NO;
            
            vitriuploadRec++;
            
            isrecord=NO;
            delayRec=0;
            //songRecOld=nil;
            if (isVoice  && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            
            // [[MainViewController alloc] initWithPlayer:nil];
            //   [self presentViewController:mainv animated:YES completion:nil];
            NSURL *audioFileURL= [NSURL fileURLWithPath:songRec.vocalUrl];
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:songRec.vocalUrl];
            NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:songRec.vocalUrl error:nil];
            unsigned long long filesize=[fileinfo fileSize];
            if (haveS && filesize>1000)  {
                
                if (videoRecord) {
                    // pushRecordTab=YES;
                    [self gotoXulyView:songRec.vocalUrl];
                    //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    // [self.navigationController popViewControllerAnimated:YES];
                    //NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    //songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                }
                else{
                    [self gotoXulyView:songRec.vocalUrl];
                    /*
                     menuSelected=10;
                     RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
                     [self.navigationController pushViewController:mainv animated:YES];*/
                }
                //[dataRecord insertObject:songRec atIndex:0];
                //[NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
               
            }else{
                
                NSLog(@"Lỗi thu âm không có file");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[[[iToast makeText:AMLocalizedString(@"Lỗi không xác định.", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Bài thu phải trên 60 giây mới được phép lưu! Mời bạn tiếp tục thu âm!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
        /**/
    }
    

}
- (IBAction)recordAgainMenuPress:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
    alertReRecord=[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                             message:AMLocalizedString(@"Bạn muốn thu âm lại?", nil)
                                            delegate:self
                                   cancelButtonTitle:AMLocalizedString(@"Có", nil)
                                   otherButtonTitles:AMLocalizedString(@"Không", nil),nil];
    [alertReRecord show];
    
    
    
    
}
- (IBAction)exitRecordMenuPress:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
    if ([duetVideoPlayer rate]) {
        [duetVideoPlayer pause];
    }
    isPlayingAu=NO;
    if (isVoice && audioEngine2) {
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 reverbSwitchChanged:NO];
    }
    
    
    if ( [audioPlayer rate]!=0) [audioPlayer pause];
    
    if ([self isPlaying]) [playerMain pause];
    BOOL videoRecording=videoRecord;
    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
        [youtubePlayer pauseVideo];
    }
    if (videoRecord) {
        isrecord=NO;
        isRecorded=NO;
        //songRec.performanceType=@"SOLO";
        songRec.deviceName=[[LoadData2 alloc] getDeviceName];
        if (hasHeadset) {
            songRec.recordDevice=@"HEADSET";
        }else{
            songRec.recordDevice=@"NOHEADSET";
        }
        [recorder pause:^{
            SCRecordSession *recordSession = recorder.session;
            
            if (recordSession != nil) {
                recorder.session = nil;
                
                [recordSession cancelSession:nil];
                
            }
        }];
        if (recorder.isPrepared) {
            [recorder unprepare];
            [recorder stopRunning];
        }
    }else{
        isRecorded=NO;
        // songRec.performanceType=@"SOLO";
        songRec.deviceName=[[LoadData2 alloc] getDeviceName];
        if (hasHeadset) {
            songRec.recordDevice=@"HEADSET";
        }else{
            songRec.recordDevice=@"NOHEADSET";
        }
        
        [audioEngine2 record];
        audioEngine2.recorder=nil;
    }
    
    
    
    
    
    // recoder =[RecorderController new];
    // [recoder stopRecord];
    //isrecord=NO;
    playTopRec=NO;
    playRecUpload=NO;
   
    if (!songRec->isConvert) {
        isRecorded=NO;
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
        if (videoRecord) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRecOld.recordingTime]];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        if (success){ NSLog(@"[deleteFile] success");}
        // songRecOld=nil;
    }
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    songRec.recordingTime=dateString;
    isrecord=YES;
    playRecord=NO;
    playVideoRecorded=NO;
    // StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
    // [[MainViewController alloc] initWithPlayer:self.song._id];
    
    unload = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
    
    
}
- (IBAction)hideRecordMenu:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
}

-(void)popoverMenu:(DemoTableController *)tableController  selectedTableRow:(NSUInteger)rowNum
{
    if (tableController==voiceChangerMenu){
        [popover dismissPopoverAnimated:YES];
        NSString *key=[ catalogVoiceChanger objectAtIndex:rowNum];
        NSString *voice=[ catalogVoiceChanger objectAtIndex:rowNum];
        self.voiceChangerEffectVoice.text=voice;
        [voicechangerEffect.parameters setObject:key forKey:@"TYPE"];
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
        return;
    }
    if (tableController==autotuneKeyMenu){
        [popover dismissPopoverAnimated:YES];
        NSString *key=[ catalogKey objectAtIndex:rowNum];
        self.autotuneChuAm.text=[NSString stringWithFormat:@"    %@", key];
        chuam=key;
        autotuneKey=[NSString stringWithFormat:@"%@%@",chuam,amgiai];
        if ([chuam isEqualToString:@"Auto"]) autotuneKey=@"Auto";
        [autotuneEffect.parameters setObject:autotuneKey forKey:@"KEY"];
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
        return;
    }
    if (tableController==autotuneAmGiaiMenu){
        [popover dismissPopoverAnimated:YES];
        NSString *key=[ catalogAmGiai objectAtIndex:rowNum];
        self.xulyViewAutotuneAmGiaiLabel.text=[NSString stringWithFormat:@"     %@", key];
        amgiai=key;
        autotuneKey=[NSString stringWithFormat:@"%@%@",chuam,amgiai];
        if ([chuam isEqualToString:@"Auto"]) autotuneKey=@"Auto";
        [autotuneEffect.parameters setObject:autotuneKey forKey:@"KEY"];
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
        return;
    }
    NSLog(@"SELECTED ROW %d",rowNum);
    // [popover dismissPopoverAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
    switch (rowNum) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recordImage.hidden=NO;
            });
        }
            break;
        case 1:
        {
            if (youtubePlayer.currentTime>60 || (CMTimeGetSeconds(playerMain.currentTime)>60)){
                self.isLoading.hidden=NO;
                if (videoRecord) {
                    /*isrecord=NO;
                    isRecorded=NO;
                    //songRec.performanceType=@"SOLO";
                    songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                    if (hasHeadset) {
                        songRec.recordDevice=@"HEADSET";
                    }else{
                        songRec.recordDevice=@"NOHEADSET";
                    }
                    [[self movieFileOutput] stopRecording];*/
                    isrecord=NO;
                    isRecorded=NO;
                    //songRec.performanceType=@"SOLO";
                    
                    if (hasHeadset) {
                        songRec.recordDevice=@"HEADSET";
                    }else{
                        songRec.recordDevice=@"NOHEADSET";
                    }
                    if ( audioPlayer) [audioPlayer pause];
                    [audioPlayRecorder pause];
                    if ([self isPlaying]) [playerMain pause];
                    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                        [youtubePlayer pauseVideo];
                    }
                    if ([duetVideoPlayer rate]) {
                        [duetVideoPlayer pause];
                    }
                    isPlayingAu=NO;
                    if (isVoice  && audioEngine2) {
                        [audioEngine2 playthroughSwitchChanged:NO];
                        [audioEngine2 reverbSwitchChanged:NO];
                    }
                    [recorder pause:^{
                        
                        if (playTopRec) {
                            //playTopRec=NO;
                            if (iSongPlay){
                                if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                            }
                        }
                        
                        
                        
                        self.finishRecordView.hidden=YES;
                        if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                            songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                        }else{
                            songRec.song.songUrl=songPlay.songUrl;
                        }
                        songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                        songRec.effectsNew.delay=songRec.delay;
                        if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                            self.delayLyricDuet=delayRec;
                        }
                        if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                            songRec.effectsNew=[NewEffects new];
                        }
                        songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                        songRec.effectsNew.delay=songRec.delay;
                        
                        songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                        songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                        
                        songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                        songRec.effects.treble=[NSNumber numberWithInt: 30];
                        songRec.effects.echo=[NSNumber numberWithInt: 50];
                        songRec.effects.bass=[NSNumber numberWithInt: 20];
                        songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                        
                        songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                        songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                        ///
                        isRecorded=NO;
                        
                        vitriuploadRec++;
                        
                        isrecord=NO;
                        delayRec=0;
                        //songRecOld=nil;
                        if (isVoice  && audioEngine2) {
                            [audioEngine2 playthroughSwitchChanged:NO];
                            [audioEngine2 reverbSwitchChanged:NO];
                        }
                        
                        // [[MainViewController alloc] initWithPlayer:nil];
                        //   [self presentViewController:mainv animated:YES completion:nil];
                       
                        
                        self.recordSession=[recorder session];
                            if (videoRecord) {
                                // pushRecordTab=YES;
                                [self gotoXulyView:songRec.vocalUrl];
                                //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                // [self.navigationController popViewControllerAnimated:YES];
                                //  NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                //songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                                
                                
                                
                              
                            }
                            else{
                                [self gotoXulyView:songRec.vocalUrl];
                                
                            }
                    
                        [dataRecord insertObject:songRec atIndex:0];
                        [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                        songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                       
                    }];
                    /*[recorder.session mergeSegmentsUsingPreset:AVAssetExportPresetHighestQuality completionHandler:^(NSURL *url, NSError *error) {
                        if (error == nil) {
                            // Easily save to camera roll
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
                            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           
                            songRec.vocalUrl=[url path];
                            if ([fileManager fileExistsAtPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]]] == YES) {
                                [fileManager removeItemAtPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]] error:&error];
                            }
                          
                            //NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
                            [fileManager copyItemAtPath:songRec.vocalUrl toPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]] error:&error];
                            [fileManager removeItemAtPath:songRec.vocalUrl error:&error];
                            songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                                [youtubePlayer pauseVideo];
                            }
                            if (playTopRec) {
                                //playTopRec=NO;
                                if (iSongPlay){
                                    if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                                }
                            }
                            if ([duetVideoPlayer rate]) {
                                [duetVideoPlayer pause];
                            }
                            isPlayingAu=NO;
                            if (isVoice ) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                            }
                            
                            
                            if ( audioPlayer) [audioPlayer pause];
                            [audioPlayRecorder pause];
                            if ([self isPlaying]) [playerMain pause];
                            if (playRecord) {
                                
                                
                                if (isVoice) {[audioEngine2 playthroughSwitchChanged:NO];
                                    [audioEngine2 reverbSwitchChanged:NO];
                                }
                                
                                
                            }
                            
                            // recoder =[RecorderController new];
                            // [recoder stopRecord];
                            //isrecord=NO;
                            [self showPlayButton];
                            
                            self.finishRecordView.hidden=YES;
                            if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                                songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                            }else{
                                songRec.song.songUrl=songPlay.songUrl;
                            }
                            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                            songRec.effectsNew.delay=songRec.delay;
                            if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                                self.delayLyricDuet=delayRec;
                            }
                            if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                                songRec.effectsNew=[NewEffects new];
                            }
                            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                            songRec.effectsNew.delay=songRec.delay;
                            
                            songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                            songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                            
                            songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                            songRec.effects.treble=[NSNumber numberWithInt: 30];
                            songRec.effects.echo=[NSNumber numberWithInt: 50];
                            songRec.effects.bass=[NSNumber numberWithInt: 20];
                            songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                            
                            songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                            songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                            ///
                            isRecorded=NO;
                            
                            vitriuploadRec++;
                            
                            isrecord=NO;
                            delayRec=0;
                            //songRecOld=nil;
                            if (isVoice ) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                            }
                            
                            // [[MainViewController alloc] initWithPlayer:nil];
                            //   [self presentViewController:mainv animated:YES completion:nil];
                            NSURL *audioFileURL= [NSURL fileURLWithPath:songRec.vocalUrl];
                            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:songRec.vocalUrl];
                            NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:songRec.vocalUrl error:nil];
                            unsigned long long filesize=[fileinfo fileSize];
                            if (haveS && filesize>1000)  {
                                [dataRecord insertObject:songRec atIndex:0];
                                [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                                
                                if (videoRecord) {
                                    // pushRecordTab=YES;
                                    [self gotoXulyView:songRec.vocalUrl];
                                    //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                    // [self.navigationController popViewControllerAnimated:YES];
                                    videoRecord=NO;
                                }
                                else{
                                    [self gotoXulyView:songRec.vocalUrl];
                                    
                                }
                                //[Answers logCustomEventWithName:@"Record"
                                               customAttributes:@{ @"Custom String": @"Save"}];
                            }else{
                                
                                NSLog(@"Lỗi thu âm không có file");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [[[[iToast makeText:@"(Test) Bài thu đã bị lỗi không thể save"]
                                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                });
                            }
                        } else {
                            NSLog(@"Bad things happened: %@", error);
                        }
                    }];*/
                   /* NSFileManager *fileManager = [NSFileManager defaultManager];
                    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    
                    AVAsset *asset =recorder. session.assetRepresentingSegments;
                    SCAssetExportSession* assetExportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *dataPath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
                        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
                        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
                    }
                    // NSString* outputFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    songRec.vocalUrl=filePath;
                    
                    assetExportSession.outputUrl = [NSURL fileURLWithPath:filePath];
                    assetExportSession.outputFileType = AVFileTypeMPEG4;
                    assetExportSession.videoConfiguration.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
                    assetExportSession.videoConfiguration.preset = SCPresetHighestQuality;
                    assetExportSession.audioConfiguration.preset = SCPresetMediumQuality;
                    CFTimeInterval time = CACurrentMediaTime();
                    
                    [assetExportSession exportAsynchronouslyWithCompletionHandler: ^{
                        if (!assetExportSession.cancelled) {
                            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
                        }
                        
                        
                        
                        NSError *error = assetExportSession.error;
                        if (assetExportSession.cancelled) {
                            NSLog(@"Export was cancelled");
                        } else if (error == nil) {
                            NSLog(@"Save record video sussess");
                            
                            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                                [youtubePlayer pauseVideo];
                            }
                            if (playTopRec) {
                                //playTopRec=NO;
                                if (iSongPlay){
                                    if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                                }
                            }
                            if ([duetVideoPlayer rate]) {
                                [duetVideoPlayer pause];
                            }
                            isPlayingAu=NO;
                            if (isVoice ) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                            }
                            
                            
                            if ( audioPlayer) [audioPlayer pause];
                            [audioPlayRecorder pause];
                            if ([self isPlaying]) [playerMain pause];
                            if (playRecord) {
                                
                                
                                if (isVoice) {[audioEngine2 playthroughSwitchChanged:NO];
                                    [audioEngine2 reverbSwitchChanged:NO];
                                }
                                
                                
                            }
                            
                            // recoder =[RecorderController new];
                            // [recoder stopRecord];
                            //isrecord=NO;
                            [self showPlayButton];
                            
                            self.finishRecordView.hidden=YES;
                            if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                                songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                            }else{
                                songRec.song.songUrl=songPlay.songUrl;
                            }
                            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                            songRec.effectsNew.delay=songRec.delay;
                            if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                                self.delayLyricDuet=delayRec;
                            }
                            if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                                songRec.effectsNew=[NewEffects new];
                            }
                            songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                            songRec.effectsNew.delay=songRec.delay;
                            
                            songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                            songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                            
                            songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                            songRec.effects.treble=[NSNumber numberWithInt: 30];
                            songRec.effects.echo=[NSNumber numberWithInt: 50];
                            songRec.effects.bass=[NSNumber numberWithInt: 20];
                            songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                            
                            songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                            songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                            ///
                            isRecorded=NO;
                            
                            vitriuploadRec++;
                            
                            isrecord=NO;
                            delayRec=0;
                            //songRecOld=nil;
                            if (isVoice ) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                            }
                            
                            // [[MainViewController alloc] initWithPlayer:nil];
                            //   [self presentViewController:mainv animated:YES completion:nil];
                            NSURL *audioFileURL= [NSURL fileURLWithPath:songRec.vocalUrl];
                            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:songRec.vocalUrl];
                            NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:songRec.vocalUrl error:nil];
                            unsigned long long filesize=[fileinfo fileSize];
                            if (haveS && filesize>1000)  {
                                [dataRecord insertObject:songRec atIndex:0];
                                [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                                
                                if (videoRecord) {
                                    // pushRecordTab=YES;
                                    [self gotoXulyView:songRec.vocalUrl];
                                    //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                    // [self.navigationController popViewControllerAnimated:YES];
                                    videoRecord=NO;
                                }
                                else{
                                    [self gotoXulyView:songRec.vocalUrl];
                    
                                }
                                //[Answers logCustomEventWithName:@"Record"
                                               customAttributes:@{ @"Custom String": @"Save"}];
                            }else{
                                
                                NSLog(@"Lỗi thu âm không có file");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [[[[iToast makeText:@"(Test) Bài thu đã bị lỗi không thể save"]
                                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                });
                            }
                        } else {
                            if (!assetExportSession.cancelled) {
                                [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            }
                        }
                    }];*/
                }else{
                    isRecorded=NO;
                    // songRec.performanceType=@"SOLO";
                   
                    if (hasHeadset) {
                        songRec.recordDevice=@"HEADSET";
                    }else{
                        songRec.recordDevice=@"NOHEADSET";
                    }
                    if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                        songRec.effectsNew=[NewEffects new];
                    }
                    songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                    songRec.effectsNew.delay=songRec.delay;
                   
                        songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                        songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                    
                    songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                    songRec.effects.treble=[NSNumber numberWithInt: 30];
                    songRec.effects.echo=[NSNumber numberWithInt: 50];
                    songRec.effects.bass=[NSNumber numberWithInt: 20];
                    songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                    
                    songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                    songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                    /*    if (recordWithBluetooth) {
                     
                     [recordBluetooth stop];
                     }else{*/
                    [audioEngine2 record];
                    audioEngine2.recorder=nil;
                
                    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                        [youtubePlayer pauseVideo];
                    }
                if (playTopRec) {
                    //playTopRec=NO;
                    if (iSongPlay){
                        if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                    }
                }
                if ([duetVideoPlayer rate]) {
                    [duetVideoPlayer pause];
                }
                isPlayingAu=NO;
                if (isVoice  && audioEngine2) {
                    [audioEngine2 playthroughSwitchChanged:NO];
                    [audioEngine2 reverbSwitchChanged:NO];
                }
                
                
                if ( audioPlayer.rate) [audioPlayer pause];
           
                if ([self isPlaying]) [playerMain pause];
                
                
                // recoder =[RecorderController new];
                // [recoder stopRecord];
                //isrecord=NO;
                
                self.finishRecordView.hidden=YES;
                if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                    songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                }else{
                    songRec.song.songUrl=songPlay.songUrl;
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                    self.delayLyricDuet=delayRec;
                }
                if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                    songRec.effectsNew=[NewEffects new];
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
               
                    songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                
                songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                songRec.effects.treble=[NSNumber numberWithInt: 30];
                songRec.effects.echo=[NSNumber numberWithInt: 50];
                songRec.effects.bass=[NSNumber numberWithInt: 20];
                songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                
                songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                ///
                isRecorded=NO;
               
                vitriuploadRec++;
               
                isrecord=NO;
                delayRec=0;
                //songRecOld=nil;
                if (isVoice  && audioEngine2) {
                    [audioEngine2 playthroughSwitchChanged:NO];
                    [audioEngine2 reverbSwitchChanged:NO];
                }
                
                // [[MainViewController alloc] initWithPlayer:nil];
                //   [self presentViewController:mainv animated:YES completion:nil];
                NSURL *audioFileURL= [NSURL fileURLWithPath:songRec.vocalUrl];
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:songRec.vocalUrl];
                NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:songRec.vocalUrl error:nil];
                unsigned long long filesize=[fileinfo fileSize];
                if (haveS && filesize>1000)  {
                 
                    if (videoRecord) {
                        // pushRecordTab=YES;
                        [self gotoXulyView:songRec.vocalUrl];
                        //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                        // [self.navigationController popViewControllerAnimated:YES];
                       // NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                      //songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    }
                    else{
                        [self gotoXulyView:songRec.vocalUrl];
                        /*
                         menuSelected=10;
                         RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
                         [self.navigationController pushViewController:mainv animated:YES];*/
                    }
                    [dataRecord insertObject:songRec atIndex:0];
                    [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                    
                     songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                  
                }else{
                    
                    NSLog(@"Lỗi thu âm không có file");
                    dispatch_async(dispatch_get_main_queue(), ^{

                    });
                }
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Bài thu phải trên 60s mới được phép lưu! Mời bạn tiếp tục thu âm!", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
                /**/
            }
            
        }
            break;
        case 2:
        {
        alertReRecord=[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                 message:AMLocalizedString(@"Quá trình thu âm bị lỗi bạn nên bắt đầu thu âm lại!", nil)
                                                delegate:self
                                       cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                       otherButtonTitles:nil];
        [alertReRecord show];
            
            
            
            
        }
            break;
        case 3:
        {
           
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            isPlayingAu=NO;
            if (isVoice && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            
            
            if ( [audioPlayer rate]!=0) [audioPlayer pause];
            
            if ([self isPlaying]) [playerMain pause];
            BOOL videoRecording=videoRecord;
            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                [youtubePlayer pauseVideo];
            }
            if (videoRecord) {
                isrecord=NO;
                isRecorded=NO;
                //songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                [recorder pause:^{
                    SCRecordSession *recordSession = recorder.session;
                    
                    if (recordSession != nil) {
                        recorder.session = nil;
                        
                        [recordSession cancelSession:nil];
                        
                    }
                }];
                if (recorder.isPrepared) {
                    [recorder unprepare];
                    [recorder stopRunning];
                }
            }else{
                isRecorded=NO;
                // songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                
                [audioEngine2 record];
                audioEngine2.recorder=nil;
            }
           
            
            
            
            
            // recoder =[RecorderController new];
            // [recoder stopRecord];
            //isrecord=NO;
            playTopRec=NO;
            playRecUpload=NO;
           
            if (!songRec->isConvert) {
                isRecorded=NO;
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
                if (videoRecord) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRecOld.recordingTime]];
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                if (success){ NSLog(@"[deleteFile] success");}
                // songRecOld=nil;
            }
            
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
            [dateFormatter setLocale:[NSLocale systemLocale]];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            
            songRec.recordingTime=dateString;
            isrecord=YES;
            playRecord=NO;
            playVideoRecorded=NO;
            // StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
            // [[MainViewController alloc] initWithPlayer:self.song._id];
            
            unload = YES;
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                
            
            });
           
            
        }
            break;
        default:
            break;
    }
}
- (IBAction)chooseAutotuneAmGiai:(UIButton *)sender {
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:autotuneAmGiaiMenu];
    popover.tint = FPPopoverWhiteTint;
    popover.keyboardHeight = _keyboardHeight;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (autotuneAmGiaiMenu.array.count)*50+22);
    }
    else {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (autotuneAmGiaiMenu.array.count)*50+22);
    }
    
    popover.arrowDirection = FPPopoverNoArrow;
    NSLog(@"%f %f",self.view.center.y,self.view.frame.size.height/2);
    [popover presentPopoverFromPoint:CGPointMake(sender.center.x, sender.center.y+self.xulyView.frame.origin.y+34) ];
}
- (IBAction)choseAutotuneKey:(UIButton *)sender{
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:autotuneKeyMenu];
    popover.tint = FPPopoverWhiteTint;
    popover.keyboardHeight = _keyboardHeight;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (autotuneKeyMenu.array.count)*50+42);
    }
    else {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (autotuneKeyMenu.array.count)*50+42);
    }
    
    //sender is the UIButton view
    //  popover.arrowDirection = FPPopoverArrowDirectionVertical;
    //  [popover presentPopoverFromView:sender];
    popover.arrowDirection = FPPopoverNoArrow;
    NSLog(@"%f %f",self.view.center.y,self.view.frame.size.height/2);
    [popover presentPopoverFromPoint: CGPointMake(sender.center.x, sender.center.y+self.xulyView.frame.origin.y+34) ];
}
-(IBAction)popover
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=NO;
    });
    self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height-290, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height-290, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
    //NSLog(@"popover retain count: %d",[popover retainCount]);
    /*  UIButton *btn=(UIButton *) sender;
     SAFE_ARC_RELEASE(popover); popover=nil;
     
     //the controller we want to present as a popover
     DemoTableController *controller = [[DemoTableController alloc] init];
     
     controller.array=[NSMutableArray arrayWithObjects:AMLocalizedString(@"Tiếp tục thu",nil),AMLocalizedString(@"Lưu lại",nil),AMLocalizedString(@"Thu lại",nil),AMLocalizedString(@"Thoát",nil), nil];
     controller.arrayImage=[NSMutableArray arrayWithObjects:@"tiep_tuc_thu.png",@"mn_tai_xuong.png",@"thu_lai.png",@"Cancel_thu_am.png", nil];
     
     controller.title=@"";
     controller.delegate = self;
     popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
     popover.tint = FPPopoverWhiteTint;
     popover.keyboardHeight = _keyboardHeight;
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
     popover.contentSize = CGSizeMake(self.view.frame.size.width-2, (controller.array.count)*40+20);
     }
     else {
     popover.contentSize = CGSizeMake(self.view.frame.size.width-2, (controller.array.count)*40+20);
     }
     //sender is the UIButton view
     //  popover.arrowDirection = FPPopoverArrowDirectionVertical;
     //  [popover presentPopoverFromView:sender];
     popover.arrowDirection = FPPopoverNoArrow;
     [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.bounds.size.height/2 - popover.contentSize.height/2) andView:2];
     //   }*/
    
    
}
- (IBAction)saveRecordClick:(id)sender {
    /*[Answers logContentViewWithName:@"Save"
     contentType:@"Process Record"
     contentId:@"PRSave"
     customAttributes:@{}];*/
    
    self.finishRecordView.hidden=YES;
    if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
        songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
    }else{
        songRec.song.songUrl=songPlay.songUrl;
    }
    
    if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
        self.delayLyricDuet=delayRec;
    }
    if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
        songRec.effectsNew=[NewEffects new];
    }
    songRec.delay=[NSNumber numberWithLong:delayRec*1000];
    songRec.effectsNew.delay=songRec.delay;
    
    songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
    
    songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
    songRec.effects.treble=[NSNumber numberWithInt: 30];
    songRec.effects.echo=[NSNumber numberWithInt: 50];
    songRec.effects.bass=[NSNumber numberWithInt: 20];
    songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
    
    songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
    songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
    ///
    isRecorded=NO;
    isrecord=NO;
    delayRec=0;
    //songRecOld=nil;
    
    
    // [[MainViewController alloc] initWithPlayer:nil];
    //   [self presentViewController:mainv animated:YES completion:nil];
    if ( audioPlayer) [audioPlayer pause];
    [audioPlayRecorder pause];
    if ([self isPlaying]) [playerMain pause];
    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
        [youtubePlayer pauseVideo];
    }
    if ([duetVideoPlayer rate]) {
        [duetVideoPlayer pause];
    }
    isPlayingAu=NO;
    if (isVoice  && audioEngine2) {
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 reverbSwitchChanged:NO];
    }
    NSURL *audioFileURL= [NSURL fileURLWithPath:songRec.vocalUrl];
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:songRec.vocalUrl];
    NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:songRec.vocalUrl error:nil];
    unsigned long long filesize=[fileinfo fileSize];
    songRec.deviceName=[[LoadData2 alloc] getDeviceName];
    if (videoRecord) {
        // pushRecordTab=YES;
        
       
        //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        // [self.navigationController popViewControllerAnimated:YES];
       
       
        [self gotoXulyView:songRec.vocalUrl];
       // NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
       
    }else
        if (haveS && filesize>1000)  {
            songRec.deviceName=[[LoadData2 alloc] getDeviceName];
            
            if (videoRecord) {
                // pushRecordTab=YES;
               
                [self gotoXulyView:songRec.vocalUrl];
                //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                // [self.navigationController popViewControllerAnimated:YES];
              //  NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
               // songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
            }
            else{
                [self gotoXulyView:songRec.vocalUrl];
                /*
                 menuSelected=10;
                 RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
                 [self.navigationController pushViewController:mainv animated:YES];*/
            }
            // [dataRecord insertObject:songRec atIndex:0];
            // [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
            
            
        }else{
            NSLog(@"Lỗi thu âm không có file");
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
}
- (IBAction)cancelAutoPlayList:(id)sender {
    cancelAutoPlaylist=YES;
    self.finishRecordView.hidden=YES;
}
- (IBAction)cancelGotoNextSong:(id)sender {
    self.finishRecordView.hidden=YES;
}
- (IBAction)goToNextSong:(id)sender {
    cancelAutoPlaylist=NO;
    [self nextSongPlay];
    
}

- (IBAction)cancelRecordClick:(id)sender {
    self.finishRecordView.hidden=YES;
    /*[Answers logContentViewWithName:@"Cancel"
     contentType:@"Process Record"
     contentId:@"PRCancel"
     customAttributes:@{}];*/
   
    if (!songRec->isConvert) {
        isRecorded=NO;
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
        if (videoRecord) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRecOld.recordingTime]];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        if (success){ NSLog(@"[deleteFile] success");}
        // songRecOld=nil;
    }
    isRecorded=NO;
    isrecord=NO;
    if (recorder.isPrepared) {
        [recorder unprepare];
        [recorder stopRunning];
    }
    videoRecord=NO;
    [self showPlayButton];
    if (videoRecord && [Language hasSuffix:@"kara"]){
        [youtubePlayer pauseVideo];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
    //  if (videoRecord) [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    
}
- (void) deleteRecord:(Recording *) record{
    @autoreleasepool {
        
        
        if ([[DBHelperYokaraSDK alloc] removeRecordIntoRecord:record.recordingTime]) {
            
            NSLog(@"remove record song");
        }
        
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",record.recordingTime]];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",record.recordingTime]];
        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        if (success){ NSLog(@"[deleteFile] success");}
        else{
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",record.recordingTime]];
            success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",record.recordingTime]];
            success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            if (success) NSLog(@"[deleteFile] old success");
        }
        if (isIphone5s) {
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.aif",record.recordingTime]];
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            
            if (success){ NSLog(@"[deleteFile] success");}
            else{
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aif",record.recordingTime]];
                success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            }
        }
        if ([record->hasUpload isEqualToString:@"YES"]) {
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            
            dispatch_async(queue, ^{
                DeleteRecordingResponse* responeDelete= [[LoadData2 alloc] deleteRecording:record.recordingId];
                if (responeDelete.status.length>0){
                    if ([responeDelete.status isEqualToString:@"OK"]){
                        
                        [dataRecord removeObject:recordingPlaying];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[[iToast makeText:AMLocalizedString(@"Bài thu đã bị xóa",nil)]
                               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            
                        });
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (responeDelete.message.length>0) {
                                [[[[iToast makeText:responeDelete.message]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            }else
                                [[[[iToast makeText:AMLocalizedString(@"Có lỗi khi xóa bài thu này.", nil)]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Có lỗi khi xóa bài thu này.", nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        
                    });
                }
            });
        }
        
        // [[LoadData2 alloc] deleteRecording:recordingPlaying.recordingId];
        
        // [[LoadData2 alloc] removeRecord:iSong.date];
    }
}
BOOL resetRecord;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==alertReRecord){
        alerReRecordIsShow=NO;
        if (buttonIndex==0){
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            isPlayingAu=NO;
            if (isVoice && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            
            
            if ( [audioPlayer rate]!=0) [audioPlayer pause];
            
            if ([self isPlaying]) [playerMain pause];
            BOOL videoRecording=videoRecord;
            if (videoRecord) {
                isrecord=NO;
                isRecorded=NO;
                //songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                [recorder pause:^{
                    SCRecordSession *recordSession = recorder.session;
                    
                    if (recordSession != nil) {
                        recorder.session = nil;
                        
                        [recordSession cancelSession:nil];
                        
                    }
                }];
               
            }else{
                isRecorded=NO;
                // songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                
                [audioEngine2 record];
                audioEngine2.recorder=nil;
            }
            if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying){
                [youtubePlayer pauseVideo];
            }
           
           
            
            
            // recoder =[RecorderController new];
            // [recoder stopRecord];
            //isrecord=NO;
            playTopRec=NO;
            playRecUpload=NO;
            
            if (!songRec->isConvert) {
                isRecorded=NO;
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
                if (videoRecord) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRecOld.recordingTime]];
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                if (success){ NSLog(@"[deleteFile] success");}
                // songRecOld=nil;
            }
            
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
            [dateFormatter setLocale:[NSLocale systemLocale]];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            
            songRec.recordingTime=dateString;
            isrecord=YES;
            playRecord=NO;
            playVideoRecorded=NO;
            // StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
            // [[MainViewController alloc] initWithPlayer:self.song._id];
            
            unload = YES;
            if (connectBluetooth){
                if (isrecord) {
                    isrecord=NO;
                    videoRecord=NO;
                    unload=NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:AMLocalizedString(@"Hiện Yokara chưa hỗ trợ thu âm khi kết nối Bluetooth, vui lòng sử dụng kết nối có dây",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationLong] show];
                    });
                }
            }//else{
            //  NavigationTopViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
            // [[MainViewController alloc] initWithPlayer:self.song._id];
            // [self presentViewController:mainv animated:YES completion:nil];
            //   [self.parentNavigationController presentViewController:mainv animated:YES completion:nil];
            resetRecord=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
        }
    }  else
        if (alertView==alertHuyEditRecord){
            if (buttonIndex==0){
                [playerMain pause];
                
                    [audioPlayer pause];
                //audioPlayer.currentItem.audioMix=nil;
                
                if (audioPlayRecorder) {
                    [audioPlayRecorder pause];
                }
                if ([duetVideoPlayer rate]) {
                    [duetVideoPlayer pause];
                }
                isPlayingAu=NO;
               
                selectedMenuIndex=4;
                 songRec->isUploading=NO;
                songRec.effectsNew.effects=[NSMutableDictionary new];
                if ([karaokeEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
                }else if ([studioEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
                    
                    
                }else  if ([liveEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
                    
                    
                }else  if ([superbassEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
                    
                    
                }else  if ([remixEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
                    
                    
                }else  if ([boleroEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
                    
                    
                }
                if ([voicechangerEffect.enable integerValue]) {
                    
                    
                    [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
                    
                    
                }
                if ([autotuneEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
                }
                if ([denoiseEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
                }
                 if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_NEWEFFECTS fieldValue1:[songRec.effectsNew toJSONString] withCondition:R_DATE conditionValue:songRec.recordingTime]) NSLog(@"update effect record");
                 [NSThread detachNewThreadSelector:@selector(createSilentPCMFileWithDuration:) toTarget:self withObject:[NSNumber numberWithInt:60*8*8]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinishNotPublic" object:songRec];
                dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                });
            }
        }  else if (alertView==alertDeleteRecord) {
            if (buttonIndex == 0)
            {
                [NSThread detachNewThreadSelector:@selector(deleteRecord:) toTarget:self withObject:songRec];
                [audioPlayer pause];
                [playerMain pause];
                if ([dataRecord containsObject:songRec]) {
                    [dataRecord removeObject:songRec];
                }
                if ([listSongMyAskDuet containsObject:songRec]) {
                    [listSongMyAskDuet removeObject:songRec];
                }
               // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUserInfo" object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                });
                
            }
            
        }else
            if (alertView==alertLinkFacebook){
                if (buttonIndex==1){
                  //  [AppDelegate showLoginView];
                    /*FBLoginViewViewController * mainVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DangNhapViewC"];
                    mainVC.delegate=self;
                    self.providesPresentationContextTransitionStyle = YES;
                    self.definesPresentationContext = YES;
                    [mainVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                    [self presentViewController:mainVC animated:NO completion:nil];*/
                }
            }else
                if (alertOpenSetting==alertView){
                    if (buttonIndex==0){
                        [LoadData2 openSettings];
                    }
                }else
                    if (alertHuyUpload==alertView){
                        /*if (buttonIndex==1){
                            if (isExporting) {
                                isExporting=NO;
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelExportVideo" object:nil];
                            }
                            _doneUploadingToIkara=YES;
                        }*/
                    }else
                        if (alertNangCapVIP==alertView){
                            if (buttonIndex==1){
                              //  AccountViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TaiKhoanVipView"];
                                // [[MainViewController alloc] initWithPlayer:theSong._id];
                                
                                //[self.navigationController pushViewController:mainv animated:YES];
                            }
                        }else
                            if (alertView==alert) {
                                
                                if (buttonIndex == 0)
                                {
                                    // Yes, do something
                                    songRec.song.songUrl=songPlay.songUrl;
                                    if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                                        songRec.effectsNew=[NewEffects new];
                                    }
                                    songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                                    songRec.effectsNew.delay=songRec.delay;
                                    
                                        songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                                        songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                                    
                                    songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                                    songRec.effects.treble=[NSNumber numberWithInt: 30];
                                    songRec.effects.echo=[NSNumber numberWithInt: 50];
                                    songRec.effects.bass=[NSNumber numberWithInt: 20];
                                    songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                                    
                                    songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                                    songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                                    ///
                                    isRecorded=NO;
                                    [dataRecord addObject:songRec];
                                    [NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                                    isrecord=NO;
                                    delayRec=0;
                                    //songRecOld=nil;
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinish" object:songRec];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                    });
                                    // [[MainViewController alloc] initWithPlayer:nil];
                                    //   [self presentViewController:mainv animated:YES completion:nil];
                                    
                                    if (videoRecord) {
                                        videoRecord=NO;
                                        if (recorder.isPrepared) {
                                            [recorder unprepare];
                                            [recorder stopRunning];
                                        }
                                        //  [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                       // [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                        // [self.navigationController popViewControllerAnimated:YES];
                                    }
                                    else{
                                        menuSelected=10;
                                        //  RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
                                        selectedMenuIndex=4;
                                        
                                        //[self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                        //[self.navigationController popViewControllerAnimated:YES];
                                    }
                                    // [audioEngine2.audioController stop];
                                    
                                    
                                    
                                }
                                else if (buttonIndex == 1)
                                {
                                    // No
                                    
                                    if (!songRec->isConvert) {
                                        isRecorded=NO;
                                        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRecOld.recordingTime]];
                                        if (videoRecord) filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRecOld.recordingTime]];
                                        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                                        if (success){ NSLog(@"[deleteFile] success");}
                                        // songRecOld=nil;
                                    }
                                    isRecorded=NO;
                                    isrecord=NO;
                                    [self showPlayButton];
                                    //  if (videoRecord) [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                    videoRecord=NO;
                                    
                                }
                            }else if (alertView==alertChangePlayList){
                                
                            }
    
}
- (IBAction)markButtonPress:(id)sender {
    
    /*
     if (VipMember) {
     
     }else {
     dispatch_async(dispatch_get_main_queue(), ^{
     alertNangCapVIP=[[UIAlertView alloc] initWithTitle:@"VIP Member" message:@"Chức năng dành cho thành viên VIP. Bạn có muốn nâng cấp VIP không?" delegate:self cancelButtonTitle:AMLocalizedString(@"Không",nil) otherButtonTitles:AMLocalizedString(@"Có",nil), nil];
     [alertNangCapVIP show];
     //  [[[[iToast makeText:AMLocalizedString(@"Chỉ có thành viên VIP mới sử dụng được chức năng chấm điểm! Vui lòng nâng cấp VIP và thử lại nhé! Cảm ơn!!", nil)]     setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
     });
     }*/
}
- (void) demMarkTime{
    if (demMark<=mark){
        demMark=demMark+1;
        [self performSelectorOnMainThread:@selector(setDemMark) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(demMarkTime) withObject:nil afterDelay:0.08];
    }else{
        [self performSelectorOnMainThread:@selector(setMark) withObject:nil waitUntilDone:NO];
        [demMarkTimer invalidate];
        demMarkTimer=nil;

    }
}
- (void) setDemMark{
    self.markLabel.text=[NSString stringWithFormat:@"%d",demMark];
    int hangchuc=(int) demMark/10;
    if (hangchuc>9) hangchuc=9;
    int hangDonvi=(int) demMark%10;
    self.markImage1.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",hangchuc]];
    self.markImage2.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",hangDonvi]];
}
- (void) setMark{
    self.markLabel.text=[NSString stringWithFormat:@"%d",mark];
    int hangchuc=(int) mark/10;
    if (hangchuc>9) hangchuc=9;
    int hangDonvi=(int) mark%10;
    self.markImage1.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",hangchuc]];
    self.markImage2.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",hangDonvi]];
}
- (void) showAlert{
    demMark=0;
    mark=RAND_FROM_TO(75, 100);
    demMarkTimer=[NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(demMarkTime)
                                                userInfo:nil
                                                 repeats:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordImage.hidden=YES;
        self.recordAlertImage.hidden=YES;
        self.finishRecordView.hidden=NO;
        self.finishViewHuyButton.hidden=YES;
        self.finishViewChangePlaylistNoButton.hidden=YES;
        self.finishViewChangePlaylistYesButton.hidden=YES;
        self.finishViewLabel.text = AMLocalizedString(@"Bạn có muốn lưu bài thu?", nil);
        self.finishViewNoButton.hidden=NO;
        self.finishViewYesButton.hidden=NO;
    });
    
}
/*
 - (void)startNewRecord
 {
 
 // Disable Stop/Play button when application launches
 if ( !recorder.recording ) {
 
 
 // Set the audio file
 NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *dataPath =[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
 
 if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
 [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
 [[StreamingMovieViewController alloc] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
 }
 NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
 
 NSURL *outputFileURL = [NSURL fileURLWithPath: path];
 
 // Setup audio session
 AVAudioSession *session = [AVAudioSession sharedInstance];
 [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
 
 // Define the recorder setting
 NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
 
 [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
 [recordSetting setValue:[NSNumber numberWithInteger:44100.0] forKey:AVSampleRateKey];
 [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
 [recordSetting setValue:[NSNumber numberWithInt: 32] forKey:AVEncoderBitRateKey];
 [recordSetting setObject:[NSNumber numberWithInt: AVAudioQualityMax] forKey: AVEncoderAudioQualityKey];
 // Initiate and prepare the recorder
 recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
 recorder.delegate = self;
 
 [recorder prepareToRecord];
 recorder.meteringEnabled = YES;
 NSError * error = nil;
 
 [session setActive:YES error:&error];
 
 if (error)
 {
 NSLog(@"%@", [error description]);
 }
 UInt32 allowMixing = YES;
 checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing),
 "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers)");
 UInt32 toSpeaker = YES;
 checkResult(AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (toSpeaker), &toSpeaker), "AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker)");
 // Start recording
 NSLog(@"a");
 [recorder recordAtTime:recorder.deviceCurrentTime+ 2.0];
 NSLog(@"abc");
 } else{
 [recorder stop];
 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 [audioSession setActive:NO error:nil];
 recorder.delegate=nil;
 recorder=nil;
 }
 }
 - (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorde successfully:(BOOL)flag{
 NSLog(@"total %f",recorde.currentTime);
 }
 - (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
 if (timeRecord==0){
 timeRecord=CACurrentMediaTime();
 }
 }*/
- (void)record {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isLoading.hidden=YES;
        
    });
    if ( videoRecord ){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.warningVideoRecord.hidden=YES;
           
        });
        [self  startRecordVideo];
        //  if (!self.recordImage.isHidden) {
       
        //}else
        //[self performSelector:@selector(startRecordVideo) withObject:nil afterDelay:1];
        //[self performSelectorOnMainThread:@selector(startRecordVideo) withObject:nil waitUntilDone:NO ];
    }else{
        
        if ( isRecorded ) {
            
            
            ///
            //[self startNewRecord];
            if (seekToZeroBeforePlay) {
                isRecorded=NO;
                // songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                    songRec.effectsNew=[NewEffects new];
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                
                    songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                
                songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                songRec.effects.treble=[NSNumber numberWithInt: 30];
                songRec.effects.echo=[NSNumber numberWithInt: 50];
                songRec.effects.bass=[NSNumber numberWithInt: 20];
                songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                
                songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                /*    if (recordWithBluetooth) {
                 
                 [recordBluetooth stop];
                 }else{*/
                [audioEngine2 record];
                audioEngine2.recorder=nil;
                [self
                 performSelectorOnMainThread:@selector(showAlert)
                 withObject:nil
                 waitUntilDone:NO];
            }else{
                //  [self popover];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.saveRecordView.hidden=NO;
                });
                self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
                [UIView animateWithDuration: 0.3f animations:^{
                    
                    self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height-290, self.saveRecordMenuSubview.frame.size.width, 290);
                    
                } completion:^(BOOL finish){
                    
                    self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height-290, self.saveRecordMenuSubview.frame.size.width, 290);
                    
                }];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recordImage.hidden=YES;
            });
            ////
        } else {
            isRecorded=YES;
            /*if (recordWithBluetooth) {
             NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *dataPath =[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
             
             if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
             [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
             [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
             }
             
             
             NSString *path2 = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
             songRec.vocalUrl=path2;
             
             NSURL *outputFileURL = [NSURL fileURLWithPath:path2];
             
             // Setup audio session
             AVAudioSession *session = [AVAudioSession sharedInstance];
             // [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
             [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
             // Define the recorder setting
             NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
             
             [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
             [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
             [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
             
             recordBluetooth = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
             [recordBluetooth prepareToRecord];
             
             
             }else{*/
           [audioEngine2 record];
            //   }
            //  [self startNewRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recordImage.hidden=NO;
                [self.pauseBtt setImage:nil forState:UIControlStateNormal];
                self.recordAlertImage.hidden=NO;
            });
            songRecOld = songRec;
        }
    }
}
/*
 
 static inline float translate(float val, float min, float max) {
 if ( val < min ) val = min;
 if ( val > max ) val = max;
 return (val - min) / (max - min);
 }*/



/////
#pragma mark -
#pragma mark View Controller
#pragma mark -

- (void)viewDidUnload
{
    // self.toolBar = nil;
    // self.playButton = nil;
    // self.stopButton = nil;
    //  self.movieTimeControl = nil;
    // self.movieURLTextField = nil;
    // self.isPlayingAdText = nil;
    //self.playerLayerView=nil;
    [super viewDidUnload];
}
- (NSMutableArray<Line> *) getLyric: (NSString *) lyricInXml{
    
    // NSString *lyricInXml=[[LoadData2 alloc] getLyricData:url];
    ///NSLog(@"lời %@",lyricInXml);
    Lyrics *lyricsInObject = [[UtilsK alloc] convertXmlToObject:lyricInXml];
    
    // lyricsInObject = [[UtilsK alloc] splitTooLongLine:lyricsInObject andMaxLen:20];
    return [[UtilsK alloc] convertLyricsInObjectToRKL:lyricsInObject];
}
- (IBAction)morong:(id)sender{
    karaokeDisplayElement.frame=self.view.frame;
    self.navigationController.navigationBarHidden =YES;
    
}
- (IBAction)hideToolBar:(id)sender {
    [self hideToolbar];
}

- (void) hideToolbar {
    
    /*if (self.navigationController.navigationBarHidden){
     self.navigationController.navigationBarHidden =NO;
     }else{
     self.navigationController.navigationBarHidden =YES;
     }*/
    self.microVolumeView.hidden=YES;
    self.onOffPlaythroughView.hidden=YES;
   
       
    
    
}

/*
 - (void) checkHeadset2 {
 @autoreleasepool {
 UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
 AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
 UInt32 routeSize = sizeof (CFStringRef); CFStringRef route;
 AudioSessionGetProperty (kAudioSessionProperty_AudioRoute, &routeSize, &route);
 
 //NSLog(@"Error >>>>>>>>>> :%@", error);
 
 
 NSString* routeStr =(__bridge NSString *) route;
 
 NSRange headsetRange = [routeStr rangeOfString : @"Head"];
 NSRange receiverRange = [routeStr rangeOfString : @"Receiver"];
 
 if(headsetRange.location != NSNotFound) {
 // Don't change the route if the headset is plugged in.
 
 // [self performSelectorOnMainThread:@selector(coHeadset) withObject:nil waitUntilDone:NO];
 
 } else{
 //[self performSelectorOnMainThread:@selector(koHeadset) withObject:nil waitUntilDone:NO];
 }
 [self syncPlayPauseButtons];
 }
 }*/


-(void)dismissKeyboard {
    [messageUpload resignFirstResponder];
    [NameUpload resignFirstResponder];
}
- (IBAction)dismisKey1:(id)sender {
    [NameUpload resignFirstResponder];
}
- (IBAction)dimisKey:(id)sender {
    [messageUpload resignFirstResponder];
    
}
- (NSString *) convertTimeToString:(CMTime ) time{
    NSString *result;
    double timeplay= CMTimeGetSeconds(time);
    int second=[[NSNumber numberWithDouble:timeplay] intValue]%60;
    NSString *secondstring=(second>9)?[NSString stringWithFormat:@"%d",second]:[NSString stringWithFormat:@"0%d",second];
    int minute=timeplay/60;
    NSString *minutestring=(minute>9)?[NSString stringWithFormat:@"%d",minute]:[NSString stringWithFormat:@"0%d",minute];
    result = [NSString stringWithFormat:@"%@:%@",minutestring,secondstring];
    return result;
}
- (NSString *) convertTimeToString2:(double ) time{
    NSString *result;
    double timeplay= time;
    int second=[[NSNumber numberWithDouble:timeplay] intValue]%60;
    NSString *secondstring=(second>9)?[NSString stringWithFormat:@"%d",second]:[NSString stringWithFormat:@"0%d",second];
    int minute=timeplay/60;
    NSString *minutestring=(minute>9)?[NSString stringWithFormat:@"%d",minute]:[NSString stringWithFormat:@"0%d",minute];
    result = [NSString stringWithFormat:@"%@:%@",minutestring,secondstring];
    return result;
}
- (IBAction)revealMenu2:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}

- (NSTimeInterval) availableDuration;
{
    NSArray *loadedTimeRanges = [[playerMain currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count>0){
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }else return 0;
}
- (NSTimeInterval) availableDurationDuet;
{
    NSArray *loadedTimeRanges = [[duetVideoPlayer currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count>0){
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }else return 0;
}
- (NSTimeInterval) availableDurationAudio;
{
    NSArray *loadedTimeRanges = [[audioPlayer currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count>0){
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }
    else return 0;
}
- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                alertOpenSetting= [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Mở quyền truy cập", nil)
                                                             message:[NSString stringWithFormat: AMLocalizedString(@"Ứng dụng cần truy cập %@ để có thể thu âm. Bạn có thể mở quyền trong cài đặt ứng dụng", nil),AMLocalizedString(@"Máy ảnh", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:AMLocalizedString(@"Xác nhận", nil)
                                                   otherButtonTitles:nil];
                [alertOpenSetting show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}
#pragma mark Device Configuration
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}
- (void)setBluetoothAudioInput
{
    // create and set up the audio session
    
    
    self.session.usesApplicationAudioSession = true;
    self.session.automaticallyConfiguresApplicationAudioSession = false;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
}
- (void) startRecordVideo{
    if (recorder.isRecording) {
        
        if (!seekToZeroBeforePlay) {
             [self performSelectorOnMainThread:@selector(popover) withObject:nil waitUntilDone:NO ];
           
            // [self.assetWriter finishWriting];
           
            
        }else{
            //[self saveRecordMenuPress:[UIButton new]];
            isrecord=NO;
            isRecorded=NO;
            //songRec.performanceType=@"SOLO";
            songRec.deviceName=[[LoadData2 alloc] getDeviceName];
            if (hasHeadset) {
                songRec.recordDevice=@"HEADSET";
            }else{
                songRec.recordDevice=@"NOHEADSET";
            }
            [recorder pause:^{
                
                if (playTopRec) {
                    //playTopRec=NO;
                    if (iSongPlay){
                        if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                    }
                }
                
                
                
                self.finishRecordView.hidden=YES;
                if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10) {
                    songRec.song.songUrl=songRec.mixedRecordingVideoUrl;
                }else{
                    songRec.song.songUrl=songPlay.songUrl;
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]){
                    self.delayLyricDuet=delayRec;
                }
                if (![songRec.effectsNew isKindOfClass:[NewEffects class]]) {
                    songRec.effectsNew=[NewEffects new];
                }
                songRec.delay=[NSNumber numberWithLong:delayRec*1000];
                songRec.effectsNew.delay=songRec.delay;
                
                songRec.effects.vocalVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.vocalVolume=[NSNumber numberWithInt: 80];
                
                songRec.effects.musicVolume=[NSNumber numberWithInt: 80];
                songRec.effects.treble=[NSNumber numberWithInt: 30];
                songRec.effects.echo=[NSNumber numberWithInt: 50];
                songRec.effects.bass=[NSNumber numberWithInt: 20];
                songRec.effects.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                
                songRec.effectsNew.beatVolume=[NSNumber numberWithInt: 80];
                songRec.effectsNew.toneShift=[NSNumber numberWithInt:songPlay.pitchShift*2];
                ///
                isRecorded=NO;
                
                vitriuploadRec++;
                
                isrecord=NO;
                delayRec=0;
                //songRecOld=nil;
                if (isVoice  && audioEngine2) {
                    [audioEngine2 playthroughSwitchChanged:NO];
                    [audioEngine2 reverbSwitchChanged:NO];
                }
                
                // [[MainViewController alloc] initWithPlayer:nil];
                //   [self presentViewController:mainv animated:YES completion:nil];
                
                
                self.recordSession=[recorder session];
                /*if (videoRecord) {
                    // pushRecordTab=YES;
                    [self gotoXulyView:songRec.vocalUrl];
                    //   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    // [self.navigationController popViewControllerAnimated:YES];
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                    
                    
                    
                    
                }
                else{
                    [self gotoXulyView:songRec.vocalUrl];
                    
                }*/
                [self
                 performSelectorOnMainThread:@selector(showAlert)
                 withObject:nil
                 waitUntilDone:NO];
                // [dataRecord insertObject:songRec atIndex:0];
                //[NSThread detachNewThreadSelector:@selector(addrecordS) toTarget:self withObject:nil];
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                
            }];
            /*[recorder pause:^{
                
                self.recordSession=[recorder session];
                [self
                 performSelectorOnMainThread:@selector(showAlert)
                 withObject:nil
                 waitUntilDone:NO];
                
            }];*/
        /*
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
        
        AVAsset *asset =recorder. session.assetRepresentingSegments;
        SCAssetExportSession* assetExportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dataPath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
        }
       // NSString* outputFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
        songRec.vocalUrl=filePath;
        
        assetExportSession.outputUrl = [NSURL fileURLWithPath:filePath];
        assetExportSession.outputFileType = AVFileTypeMPEG4;
        assetExportSession.videoConfiguration.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
        assetExportSession.videoConfiguration.preset = SCPresetHighestQuality;
        assetExportSession.audioConfiguration.preset = SCPresetMediumQuality;
         CFTimeInterval time = CACurrentMediaTime();
        
        [assetExportSession exportAsynchronouslyWithCompletionHandler: ^{
            if (!assetExportSession.cancelled) {
                NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
            }
            
           
            
            NSError *error = assetExportSession.error;
            if (assetExportSession.cancelled) {
                NSLog(@"Export was cancelled");
            } else if (error == nil) {
                NSLog(@"Save record video sussess");
                [self
                 performSelectorOnMainThread:@selector(showAlert)
                 withObject:nil
                 waitUntilDone:NO];
            } else {
                if (!assetExportSession.cancelled) {
                    [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        }];*/
        }
    }else{
        [recorder record];
        isRecorded=YES;
    }
}
/*- (void) startRecordVideo{
    //[[self recordButton] setEnabled:NO];
    @autoreleasepool{
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording])
        {
            if ([[UIDevice currentDevice] isMultitaskingSupported])
            {
                // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam returns to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the assets library when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in -recorder:recordingDidFinishToOutputFileURL:error: after the recorded file has been saved.
                [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            [self setLockInterfaceRotation:YES];
            isRecorded=YES;
           // dispatch_async(dispatch_get_main_queue(), ^{
               
             //   [self.pauseBtt setImage:[UIImage imageNamed:@"icn_thu_am.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            //});
            
            // timeRecord=CACurrentMediaTime();
            NSLog(@"start record");
            // Update the orientation on the movie file output video connection before starting recording.
            // recordvideo use file
           dispatch_async(dispatch_get_main_queue(), ^{
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
           });
            // Turning OFF flash for video recording
            [StreamingMovieViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            
            // Start recording to a temporary file.
            //NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *dataPath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
                [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
            }
            NSString* outputFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
            songRec.vocalUrl=outputFilePath;
            
            // NSLog(@"delay 2 %f", CACurrentMediaTime()-timeRecord);
            AVCaptureConnection *c = [[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo];
            if (c.active) {
                //connection is active
                [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
            } else {
                isrecord=NO;
                [[[[iToast makeText:AMLocalizedString(@"Yokara không thể thu âm video. Kiểm tra quyền truy cập camera và thử lại!",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationLong] show];
            }
            // recordvideo use assetwriter
           
            
                
              //  self.outputConnection = connection
            
            
            
            //[self.assetWriter startWriting];
          
            songRecOld = songRec;
            
        }
        else
        {
            if (seekToZeroBeforePlay) {
                
                isrecord=NO;
                isRecorded=NO;
                //songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
               // [self.assetWriter finishWriting];
                [[self movieFileOutput] stopRecording];
                
            }else{
                
                [self performSelectorOnMainThread:@selector(popover) withObject:nil waitUntilDone:NO ];
            }
        }
    });
    }
}*/
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
   
    
    AVAssetWriterInput* audio = self.assetWriterInputAudio;
    if (connection.audioChannels.count > 0 && audio.readyForMoreMediaData) {
        dispatch_async(bufferAudioQueue, ^{
            [audio appendSampleBuffer:sampleBuffer];
        });
        
        return;
    }
    AVAssetWriterInput* camera = self.assetWriterInputCamera;
    if (camera.readyForMoreMediaData) {
        dispatch_async(bufferVideoQueue, ^{
             [camera appendSampleBuffer:sampleBuffer];
        });
        
        return;
    }
   
}
- (IBAction)changeCamera:(id)sender
{
    if (canChangeCamera){
        canChangeCamera=NO;
        
        dispatch_async([self sessionQueue], ^{
            AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
            AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
            AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
            
            switch (currentPosition)
            {
                case AVCaptureDevicePositionUnspecified:
                    preferredPosition = AVCaptureDevicePositionBack;
                    break;
                case AVCaptureDevicePositionBack:
                    preferredPosition = AVCaptureDevicePositionFront;
                    break;
                case AVCaptureDevicePositionFront:
                    preferredPosition = AVCaptureDevicePositionBack;
                    break;
            }
            
            AVCaptureDevice *videoDevice = [StreamingMovieViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
            AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
            
            [[self session] beginConfiguration];
            
            [[self session] removeInput:[self videoDeviceInput]];
            if ([[self session] canAddInput:videoDeviceInput])
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
                
                [StreamingMovieViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
                
                [[self session] addInput:videoDeviceInput];
                [self setVideoDeviceInput:videoDeviceInput];
            }
            else
            {
                [[self session] addInput:[self videoDeviceInput]];
            }
            
            [[self session] commitConfiguration];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                canChangeCamera=YES;
            });
        });
    }
}

#pragma mark File Output Delegate
/*
 - (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput {
 return NO;
 }*/
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    timeRecord=CACurrentMediaTime()-CMTimeGetSeconds(captureOutput.recordedDuration);
    NSLog(@"%f delay 1 %f",CMTimeGetSeconds(captureOutput.recordedDuration), CACurrentMediaTime()-timeRecord);
    if ([self addSkipBackupAttributeToItemAtURL:fileURL]) NSLog(@"skip backup");
   
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
#ifndef NSURLIsExcludedFromBackupKey
    // iOS <= 5.0.1.
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
#else
    // iOS >= 5.1
    // First try and remove the extended attribute if it is present
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
#endif
}
- (void)recorder:(SCRecorder *__nonnull)recorder didBeginSegmentInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error{
   // NSLog(@"record video start");
    
   /* if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2 && videoRecord) {
        [audioEngine2 playthroughSwitchChanged:YES];
        [audioEngine2 reverbSwitchChanged:YES];
        [audioEngine2 expanderSwitchChanged:YES];
    }*/
    NSLog(@"record video start delay video %f player time %f record duration %f segment %f",CMTimeGetSeconds(session.duration)-CMTimeGetSeconds(playerMain.currentTime),CMTimeGetSeconds(playerMain.currentTime),CMTimeGetSeconds(session.duration),CMTimeGetSeconds(session.currentSegmentDuration));

    dispatch_async(dispatch_get_main_queue(), ^{
        self.playButt.hidden=YES;
        [self.pauseBtt setImage:nil forState:UIControlStateNormal];
        self.recordAlertImage.hidden=NO;
    });
}

- (void)recorder:(SCRecorder *__nonnull)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *__nonnull)session{
    if ([songRec.performanceType isEqualToString:@"DUET"] && duetVideoPlayer) {
        if (CMTimeGetSeconds(session.duration)>2 && CMTimeGetSeconds(session.duration)<2.999) {
            delayRec=CMTimeGetSeconds(session.duration)-CMTimeGetSeconds(duetVideoPlayer.currentTime) ;
           // NSLog(@"Video - delay video duet %f player time %f",delayRec,CMTimeGetSeconds(duetVideoPlayer.currentTime));
        }
    }else{
        if (CMTimeGetSeconds(session.duration)>2.5 && CMTimeGetSeconds(session.duration)<2.999) {
            delayRec= CMTimeGetSeconds(session.duration)-youtubePlayer.currentTime;
            
           // NSLog(@"Video - delay video %f player time %f record duration %f",CMTimeGetSeconds(session.duration)-youtubePlayer.currentTime,youtubePlayer.currentTime,CMTimeGetSeconds(session.duration));
        }
    }
}
- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
    songRec.vocalUrl=[segment.url path];
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error)
        NSLog(@"%@", error);
    songRec.song.duration=[NSNumber numberWithInt:CMTimeGetSeconds([playerMain currentItem].currentTime)];
    [self setLockInterfaceRotation:NO];
    
    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
    UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
    /*
     AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
     NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString* videoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",songRec.recordingTime]];
     // NSString* videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mp4"]];
     
     if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
     {
     AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
     // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     
     exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
     NSLog(@"videopath of your mp4 file = %@",videoPath);  // PATH OF YOUR .mp4 FILE
     exportSession.outputFileType = AVFileTypeAppleM4V;
     
     //  CMTime start = CMTimeMakeWithSeconds(1.0, 600);
     //  CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
     //  CMTimeRange range = CMTimeRangeMake(start, duration);
     //   exportSession.timeRange = range;
     //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
     [exportSession exportAsynchronouslyWithCompletionHandler:^{
     
     switch ([exportSession status]) {
     
     case AVAssetExportSessionStatusFailed:
     NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
     
     break;
     
     case AVAssetExportSessionStatusCancelled:
     
     NSLog(@"Export canceled");
     
     break;
     
     default:
     
     break;
     
     }
     
     UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, nil, nil);
     [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
     if (backgroundRecordingID != UIBackgroundTaskInvalid)
     [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
     }];
     
     }
     
     
     [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
     if (error)
     NSLog(@"%@", error);
     */
    //[[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
    
    if (backgroundRecordingID != UIBackgroundTaskInvalid)
        [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
    if (seekToZeroBeforePlay) {
        [self
         performSelectorOnMainThread:@selector(showAlert)
         withObject:nil
         waitUntilDone:NO];
    }
    //}];
}
- (IBAction)exitFullScreen:(id)sender {
    if ([[self movieFileOutput] isRecording] )
    {
        
        [self pause:nil];
    }
    else{
        isrecord=NO;
        //songRecOld=nil;
        isPlayingAu=NO;
        if (isVoice  && audioEngine2) {
            [audioEngine2 playthroughSwitchChanged:NO];
            [audioEngine2 reverbSwitchChanged:NO];
            [audioEngine2 expanderSwitchChanged:NO];
        }
        // menuSelected=10;
        //RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
        // [[MainViewController alloc] initWithPlayer:nil];
        //   [self presentViewController:mainv animated:YES completion:nil];
        videoRecord=NO;
        if ([self isPlaying]) [playerMain pause];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (void) setVideoRec{
    recorder= [SCRecorder recorder]; // You can also use +[SCRecorder sharedRecorder]
    
   
    
    // Create a new session and set it to the recorder
    
    recorder.session = [SCRecordSession recordSession];
   
    recorder.captureSessionPreset =AVCaptureSessionPresetMedium;
     //   recorder.maxRecordDuration = CMTimeMake(10, 1);
    //    _recorder.fastRecordMethodEnabled = YES;
    
   
    recorder.autoSetVideoOrientation = NO; //YES causes bad orientation for video from camera roll
    if ([songRec.performanceType isEqualToString:@"DUET"]) {
        if (self.view.frame.size.width+playerLayerView.frame.size.height+60>self.view.frame.size.height) {
            self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-playerLayerView.frame.size.height-60);
        }else
            self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
    }else{
        if (self.view.frame.size.width+playerLayerView.frame.size.height+60>self.view.frame.size.height) {
            self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-playerLayerView.frame.size.height-60);
        }else
            self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
    }
    //recorder.initializeSessionLazily = NO;
    UIView *previewView = self.previewView;
    
    //recorder.previewView.center=CGPointMake(self.view.frame.size.width/2,( self.view.frame.size.height-youtubePlayer.frame.size.height)/2);
   
    //recorder.previewView.layer.masksToBounds=YES;
    // Set the AVCaptureSessionPreset for the underlying AVCaptureSession.
   // recorder.captureSessionPreset = AVCaptureSessionPresetHigh;
    
    // Set the video device to use
    recorder.device = self.deviceCamera;
    
    // Set the maximum record duration
    //recorder.maxRecordDuration = CMTimeMake(10, 1);
    
    // Listen to the messages SCRecorder can send
    recorder.delegate = self;
    
    // Get the video configuration object
   SCVideoConfiguration *video = recorder.videoConfiguration;
    
    // Whether the video should be enabled or not
    video.enabled = YES;
    // The bitrate of the video video
    video.bitrate = 400000; // 2Mbit/s
    // Size of the video output
   // video.size = CGSizeMake(720, 720);
    // Scaling if the output aspect ratio is different than the output one
    //video.scalingMode = AVVideoScalingModeFit;
    // The timescale ratio to use. Higher than 1 makes a slow motion, between 0 and 1 makes a timelapse effect
    //video.timeScale = 1;
    /// Whether the output video size should be infered so it creates a square video
    video.sizeAsSquare = YES;
    // The filter to apply to each output video buffer (this do not affect the presentation layer)
    /*if (self.currentFilterCIName.length>0) {
        
        if (self.enableBeauty) {
            YUCIHighPassSkinSmoothing* skinsmooth=[[YUCIHighPassSkinSmoothing alloc] init];
            skinsmooth.inputAmount=[NSNumber numberWithFloat:0.6];
            SCFilter * filter=[SCFilter filterWithFilters:@[[SCFilter filterWithCIFilterName:self.currentFilterCIName],[SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"] ]] ;
             video.filter=filter;
        }else{
            SCFilter * filter=[SCFilter filterWithCIFilterName:self.currentFilterCIName];
            video.filter=filter;
        }
       
        
    }*/
    
    recorder.mirrorOnFrontCamera=YES;
    
    if (self.currentFilterCIName.length>0 ) {
        if (!self.currentFilter.isEmpty) {
            
        
        //video.filter = self.currentFilter;
        filterView = [[SCSwipeableFilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*1.333333)];
        //filterView.scaleAndResizeCIImageAutomatically=NO;
        //filterView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            SCFilter * filter2=[SCFilter filterWithCIFilterName:self.currentFilterCIName];
            
        filterView.filters = @[filter2];
        //[filterView setContentMode:UIViewContentModeCenter];
        recorder.SCImageView = filterView;
        
        [self.previewView addSubview:filterView];
        filterView.frame=CGRectMake(0, (self.previewView.frame.size.height-filterView.frame.size.height)/2, self.view.frame.size.width, filterView.frame.size.height);
            
        }
    }else{
        recorder.previewView = previewView;
    }
    
    
    // Get the audio configuration object
    SCAudioConfiguration *audio = recorder.audioConfiguration;
    
    // Whether the audio should be enabled or not
    audio.enabled = YES;
    // the bitrate of the audio output
    audio.bitrate = 128000; // 128kbit/s
    // Number of audio output channels
    audio.channelsCount = 2; // Mono output
    // The sample rate of the audio output
    audio.sampleRate = 44100; // Use same input
    // The format of the audio output
    audio.format = kAudioFormatMPEG4AAC; // AAC
    /*recorder.previewView = previewView;
    if ([songRec.performanceType isEqualToString:@"DUET"]) {
        
        recorder.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width,  self.view.frame.size.width);
    }else
        recorder.previewView.frame=CGRectMake(0, youtubePlayer.frame.size.height, self.view.frame.size.width,  self.view.frame.size.width);*/
    // Get the photo configuration object
    //SCPhotoConfiguration *photo = recorder.photoConfiguration;
    //photo.enabled = NO;
    NSError *error;
    if (![recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}/*
  - (void) setVideoRec{
  AVCaptureSession *session = [[AVCaptureSession alloc] init];
  [self setSession:session];
  canChangeCamera=YES;
  // Setup the preview view
  [[self previewView] setSession:session];
  
  
  // Check for device authorization
  [self checkDeviceAuthorizationStatus];
  
  // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
  // Why not do all of this on the main queue?
  // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
  
  dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
  [self setSessionQueue:sessionQueue];
  
  dispatch_async([self sessionQueue], ^{
  [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
  
  NSError *error = nil;
  AVCaptureDevice *videoDevice;
  if (useBackCamera){
  videoDevice = [StreamingMovieViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
  }else{
  videoDevice = [StreamingMovieViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
  }
  
  
  
  AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
  
  if (error)
  {
  NSLog(@"setting camera error: %@", error);
  }
  [session beginConfiguration];
  if ([session canAddInput:videoDeviceInput])
  {
  [session addInput:videoDeviceInput];
  [self setVideoDeviceInput:videoDeviceInput];
  
  dispatch_async(dispatch_get_main_queue(), ^{
  // Why are we dispatching this to the main queue?
  // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
  // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
  
  
  [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[[UIApplication sharedApplication] statusBarOrientation]];
  CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(videoDeviceInput.device.activeFormat.formatDescription);
  CGRect frame=self.previewView.frame;
  frame.size.height=self.previewView.frame.size.width/dimensions.height*dimensions.width;
  self.previewView.frame=frame;
  });
  }
  
  if (recordVieoQuality){
  if ([session canSetSessionPreset:recordVieoQuality]) {
  session.sessionPreset = recordVieoQuality;
  }
  }else {
  if ([session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
  session.sessionPreset = AVCaptureSessionPresetMedium;
  }
  }
  // Remove an existing capture device.
  // Add a new capture device.
  // Reset the preset.
  
  
  AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
  AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
  
  if (error)
  {
  NSLog(@"%@", error);
  }
  
  if ([session canAddInput:audioDeviceInput])
  {
  [session addInput:audioDeviceInput];
  }
  AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
  if ([session canAddOutput:movieFileOutput])
  {
  [session addOutput:movieFileOutput];
  AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
  if ([connection isVideoStabilizationSupported])
  [connection setEnablesVideoStabilizationWhenAvailable:YES];
  if (connection.supportsVideoStabilization) {
  connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
  }
  [self setMovieFileOutput:movieFileOutput];
  }
  [session commitConfiguration];
  });
  }*/
- (IBAction)showReviewViewRecordFullscreen:(id)sender {
    
    if ([songRec.performanceType isEqualToString:@"DUET"]) {
        
        if (layerRecordIsFullscreen){
            // self.webContentView.frame = CGRectMake(0, 0, 20, 20);
            self.duetVideoLayer.backgroundColor=[UIColor blackColor];
            self.previewView.backgroundColor=[UIColor clearColor];
            CGPoint center = self.view.center;
            [UIView animateWithDuration: 1.0f animations:^{
                self.previewView.frame = CGRectMake(frameNotFull.origin.x, frameNotFull.origin.y, frameNotFull.size.width, frameNotFull.size.height);
                if (self.duetVideoLayer.isHidden==YES) {
                    self.fullScreenVideoPrivewButton.frame = CGRectMake(frameNotFull.origin.x, frameNotFull.origin.y, frameNotFull.size.width, frameNotFull.size.height);
                }
                //
                // self.view.center = center;
            }];
            [UIView animateWithDuration: 1.0f animations:^{
                self.duetVideoLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                // self.fullScreenVideoPrivewButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                // self.view.center = center;
            }];
            // self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
            [self.editScrollView insertSubview:self.duetVideoLayer belowSubview:self.previewView];
            layerRecordIsFullscreen=NO;
        }else {
            self.duetVideoLayer.backgroundColor=[UIColor clearColor];
            self.previewView.backgroundColor=[UIColor blackColor];
            // frameNotFull=self.previewView.frame;
            [UIView animateWithDuration: 1.0f animations:^{
                self.duetVideoLayer.frame = CGRectMake(frameNotFull.origin.x, frameNotFull.origin.y, frameNotFull.size.width, frameNotFull.size.height);
                //self.fullScreenVideoPrivewButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                // self.view.center = center;
            }];
            [UIView animateWithDuration: 1.0f animations:^{
                self.previewView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                if (self.duetVideoLayer.isHidden==YES) {
                    self.fullScreenVideoPrivewButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                }
                // self.view.center = center;
            }];
            [self.editScrollView insertSubview:self.previewView belowSubview:self.duetVideoLayer];
            // self.playerLayerViewRec.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
            layerRecordIsFullscreen=YES;
        }
    }
    
    else if (layerRecordIsFullscreen){
        // self.webContentView.frame = CGRectMake(0, 0, 20, 20);
        self.previewView.backgroundColor=[UIColor clearColor];
        CGPoint center = self.view.center;
        [UIView animateWithDuration: 1.0f animations:^{
            self.previewView.frame = CGRectMake(frameNotFull.origin.x, frameNotFull.origin.y, frameNotFull.size.width, frameNotFull.size.height);
            self.fullScreenVideoPrivewButton.frame = CGRectMake(frameNotFull.origin.x, frameNotFull.origin.y, frameNotFull.size.width, frameNotFull.size.height);
            // self.view.center = center;
        }];
        // self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        layerRecordIsFullscreen=NO;
    }else {
        self.previewView.backgroundColor=[UIColor blackColor];
        frameNotFull=self.previewView.frame;
        [UIView animateWithDuration: 1.0f animations:^{
            self.previewView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.fullScreenVideoPrivewButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            // self.view.center = center;
        }];
        // self.playerLayerViewRec.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        layerRecordIsFullscreen=YES;
    }
}
- (IBAction)showLayerViewRecordFullScreen:(id)sender {
    if (layerRecordIsFullscreen){
        // self.webContentView.frame = CGRectMake(0, 0, 20, 20);
        self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
        CGPoint center = self.view.center;
        [UIView animateWithDuration: 1.0f animations:^{
            self.playerLayerViewRec.frame = CGRectMake(self.previewView.frame.origin.x, self.previewView.frame.origin.y, self.previewView.frame.size.width, self.previewView.frame.size.height);
            filterView.frame=CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height);
            // self.view.center = center;
        }];
        // self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        layerRecordIsFullscreen=NO;
    }else {
        self.playerLayerViewRec.backgroundColor=[UIColor blackColor];
        CGPoint center = self.view.center;
        [UIView animateWithDuration: 1.0f animations:^{
            self.playerLayerViewRec.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            filterView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
            // self.view.center = center;
        }];
        // self.playerLayerViewRec.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        layerRecordIsFullscreen=YES;
    }
}
- (void) checkHeadSet{
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    AVAudioSessionPortDescription *input = [[session.currentRoute.outputs count]?session.currentRoute.outputs:nil objectAtIndex:0];
    NSLog(@"tai nghe doi%@",input.portType);
	 NSRange bluetooth=[input.portType rangeOfString : @"Bluetooth"];

	 NSRange headsetRange = [input.portType rangeOfString : @"Head"];
	 if(headsetRange.location != NSNotFound || bluetooth.location!=NSNotFound) {
        // Don't change the route if the headset is plugged in.
        
        hasHeadset=YES;
        // if (isKaraokeTab){
        // controller.warningHeadset.hidden=YES;
        //}
        
        if (!isVoice  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && [audioEngine2 isKindOfClass:[audioEngine class]] && isKaraokeTab) {
            [audioEngine2 playthroughSwitchChanged:YES];
            [audioEngine2 reverbSwitchChanged:YES];
            [audioEngine2 expanderSwitchChanged:YES];
        }
        
    } else
    {
        hasHeadset=NO;
        // if (isKaraokeTab){
        //   controller.warningHeadset.hidden=NO;
        //}
        if (isVoice  && [audioEngine2 isKindOfClass:[audioEngine class]]&& isKaraokeTab) {
            [audioEngine2 playthroughSwitchChanged:NO];
            [audioEngine2 reverbSwitchChanged:NO];
            [audioEngine2 expanderSwitchChanged:NO];
        }

        
        //if (playRecord
        // Change to play on the speaker
        //   NSLog(@"play on the speaker");
    }
}
- (void) homePress{
    if (videoRecord) {
        //[self.navigationController dismissViewControllerAnimated:NO completion:nil];
        if (recorder.isPrepared) {
            [recorder unprepare];
            [recorder stopRunning];
        }
        //[self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
        // [self.navigationController popViewControllerAnimated:NO];
        videoRecord=NO;
    }else{
        //[self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
        // [self.navigationController popViewControllerAnimated:NO];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
    if (audioPlayRecorder) {
        [audioPlayRecorder pause];
    }
    if (audioPlayer) {
        if ([audioPlayer rate]!=0) {
            [audioPlayer pause];
        }
    }
    if (playerMain) {
        if ([self isPlaying]) {
            [playerMain pause];
        }
    }
    if (duetVideoPlayer) {
        if ([duetVideoPlayer rate]!=0) {
            [duetVideoPlayer pause];
        }
    }
    if (isVoice  && audioEngine2) {
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 reverbSwitchChanged:NO];
        [audioEngine2 expanderSwitchChanged:NO];
    }
    if (audioEngine2.audioController.running) {
        [audioEngine2 stopP];
       
    }
    
}
- (void) hideBar{
    @autoreleasepool {
        if (isTabKaraoke) {
            
            
            
            
           
        }
    }
    
}
- (void) animateButton{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.xulyButt.transform = CGAffineTransformMakeScale(1.1,1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.xulyButt.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (IBAction)hideSaveRecordView:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveRecordView.hidden=YES;
    });
    [UIView animateWithDuration: 0.3f animations:^{
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    } completion:^(BOOL finish){
        
        self.saveRecordMenuSubview.frame=CGRectMake(0, self.saveRecordView.frame.size.height, self.saveRecordMenuSubview.frame.size.width, 290);
        
    }];
}
UIButton * buttonConnectTV;
- (void) loadLyricDuet {
    @autoreleasepool {
        
        
        
        NSLog(@"load duet lyric");
        
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            if (![songRec.lyric.content isKindOfClass:[NSString class]]) {
                
                if ([songRec.lyric.key isKindOfClass:[NSString class]]) {
                    songRec.lyric.content=[[NSUserDefaults standardUserDefaults] objectForKey:songRec.lyric.key];
                    if (songRec.lyric.content.length<10) {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:songRec.lyric.key];
                        if (isrecord) {
                            songPlay.selectedLyric=songRec.lyric.key;
                            songRec.selectedLyric=songRec.lyric.key;
                        }
                        songRec.lyric.content=lyricRespone.content;
                    }
                }else{
                    songRec.lyric=[Lyric new];
                    if ([songRec.performanceType isEqualToString:@"DUET"] &&[songRec.selectedLyric isKindOfClass:[NSString class]]) {
                        songRec.lyric.key=songRec.selectedLyric;
                    }else
                        songRec.lyric.key=[NSString stringWithFormat:@"%@-%@",[[LoadData2 alloc] idForDevice],songRec.song.videoId];
                    songRec.lyric.content=[[NSUserDefaults standardUserDefaults] objectForKey:songRec.lyric.key];
                    if (songRec.lyric.content.length<10) {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:songRec.lyric.key];
                        songRec.lyric.content=lyricRespone.content;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //NSLog(@"%@",urlyric);
                
                
                
                //if (!playRecord) {
                    movieTimeControl.maximumTrackTintColor=[UIColor clearColor];
                    movieTimeControl.minimumTrackTintColor=[UIColor clearColor];
                    self.progressBuffer.hidden=YES;
                    self.duetLyricView.hidden=NO;
                    if (playRecord || [songRec.performanceType isEqualToString:@"DUET"]) {
                        self.lyricView=[[DuetLyricView alloc] initWithLyric:songRec.lyric andDuration:CMTimeGetSeconds([self playerItemDuration])];
                    }else
                        self.lyricView=[[DuetLyricView alloc] initWithLyric:songRec.lyric andDuration:youtubePlayer.duration];
                self.duetLyricView.frame=CGRectMake(0, 0, self.movieTimeControl.frame.size.width, 4);
                self.duetLyricView.center=self.movieTimeControl.center;
                    self.lyricView.frame=CGRectMake(0, 0, self.duetLyricView.frame.size.width, self.duetLyricView.frame.size.height);
                    self.lyricView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                    [self.duetLyricView addSubview:_lyricView];
                    ///  [self.movieTimeControl setThumbTintColor:self.lyricView.genderColor];
                    [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
                    self.userImage1.layer.borderColor=[self.lyricView.genderColor CGColor];
                    [self user1Sing];
                    if ([songRec.performanceType isEqualToString:@"DUET"] ){
                        
                        [self.lyricView updateColor:[UIColor whiteColor] andOther:namColor];
                        NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                        if (gender.length>0) {
                            if ([gender isEqualToString:@"female"]) {
                                [self.lyricView updateColor:[UIColor whiteColor] andOther:nuColor];
                            }
                        }
                        
                        
                    }
               // }
            });
        });
        
        
    }
}
- (IBAction)showConnectTV:(id)sender {
    if ([self.menuLyric isHidden]) {
        self.menuLyric.hidden=NO;
        CGRect nframe= self.menuLyric.frame;
        nframe.size.height=videoQualityList.count*44+55;
        nframe.size.width=200;
        if (nframe.size.height>200) {
            nframe.size.height=182;
        }
        nframe.origin.x=self.view.frame.size.width/2-nframe.size.width/2;
        nframe.origin.y=self.view.frame.size.height/2-nframe.size.height/2-50;
        self.menuLyric.frame=nframe;
    }else {
        self.menuLyric.hidden=YES;
    }
}
- (IBAction)showPlaythroughOnOff:(id)sender {
    if (self.onOffPlaythroughView.isHidden) {
        if (!hasHeadset) {
             [self.onOffPlaythroughSwitch setOn:NO];
        }else
        [self.onOffPlaythroughSwitch setOn:!playthroughOn];
        self.onOffPlaythroughView.hidden=NO;
        self.microVolumeView.hidden=YES;
    }else{
        self.onOffPlaythroughView.hidden=YES;
    }
   
}
- (IBAction)recordVoiceVolumeButtonPress:(id)sender {
    if (self.microVolumeView.isHidden==YES) {
        self.microVolumeView.hidden=NO;
        self.onOffPlaythroughView.hidden=YES;
        if (hasHeadset && audioEngine2 && !playthroughOn && isVoice) {
            self.recordToolbarVoiceVolumeSlider.value=(pow( [audioEngine2 getPlaythroughVolume],1/1.666));
            self.microVolumeLabel.text=[NSString stringWithFormat:@"%.0f",self.recordToolbarVoiceVolumeSlider.value*100];
            self.microEchoSlider.value= [audioEngine2 getEchoVolume];
            self.microEchoLabel.text=[NSString stringWithFormat:@"%.0f",self.microEchoSlider.value];//*2.5+50];
        }else{
            if (!hasHeadset){
                self.recordToolbarVoiceVolumeSlider.value=1;
                self.microVolumeLabel.text=@"100";
                self.microEchoSlider.value=50;
                self.microEchoLabel.text=@"50";
            }
        }
    }else{
        self.microVolumeView.hidden=YES;
    }
    
}
- (IBAction)onOffPlaythroughChange:(UISwitch *)sender {
    if (!hasHeadset) {
         [[[[iToast makeText:AMLocalizedString(@"Gắn tai nghe để có chất lượng tốt nhất",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }else{
    playthroughOn=!sender.isOn;
    if (sender.isOn) {
        if (!isVoice  && audioEngine2) {
            [audioEngine2 playthroughSwitchChanged:sender.isOn];
             [audioEngine2 reverbSwitchChanged:sender.isOn];
            float playthroughVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"playthroghVolume"];
            float micoEchoVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"EchoVolume"];
            if (playthroughVolume>0 && audioEngine2) {
                [audioEngine2 setPlaythroughVolume:playthroughVolume];
            }
            if (micoEchoVolume>0 && micoEchoVolume<101 && audioEngine2) {
                [audioEngine2 setEchoVolume:micoEchoVolume];
            }
        }
    }else{
        if (isVoice && audioEngine2) {
            [audioEngine2 playthroughSwitchChanged:sender.isOn];
            [audioEngine2 reverbSwitchChanged:sender.isOn];
        }
    }
    }
}
- (IBAction)microEchoChange:(UISlider *)sender {
    if (audioEngine2 && hasHeadset && !playthroughOn) {
        float value=sender.value;
        [audioEngine2 setEchoVolume:value];
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"EchoVolume"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.microEchoLabel.text=[NSString stringWithFormat:@"%.0f",sender.value];//*2.5+50];
    }else{
       
        if (playthroughOn) {
            [[[[iToast makeText:AMLocalizedString(@"Nghe trực tiếp đã tắt!\nVui lòng mở lại chế độ này!",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng kết nối tai nghe để điều chỉnh âm lượng",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
}
- (IBAction)recordVoiceVolumeChange:(UISlider *)sender {
    if (audioEngine2 && hasHeadset && !playthroughOn) {
        float value=powf(sender.value, 1.666);
        [audioEngine2 setPlaythroughVolume:value];
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"playthroghVolume"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.microVolumeLabel.text=[NSString stringWithFormat:@"%.0f",sender.value*100];
    }else{
    
        if (playthroughOn) {
            [[[[iToast makeText:AMLocalizedString(@"Nghe trực tiếp đã tắt!\nVui lòng mở lại chế độ này!",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng kết nối tai nghe để điều chỉnh âm lượng",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
}
- (IBAction)recordMusicVolumeButtonPress:(id)sender {
    self.recordToolbarMusicVolumeSlider.hidden=NO;
    self.recordToolbarMusicVolumeSlider.center=CGPointMake(self.recordToolbarMusicButton.center.x, self.recordToolbarMusicButton.frame.origin.y-self.recordToolbarMusicVolumeSlider.frame.size.width/2);
    self.recordToolbarMusicVolumeSlider.transform=CGAffineTransformRotate(self.recordToolbarMusicVolumeSlider.transform,270.0/180*M_PI);
}
- (IBAction)recordMusicVolumeChange:(id)sender {
    
}
- (IBAction)xulyViewEffectTab:(id)sender {
    self.xulyViewEffectView.hidden=NO;
    self.xulyViewVolumeView.hidden=YES;
    [self.xulyViewEffectTapButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.xulyViewVolumeTapButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
- (IBAction)xulyviewVolumeTab:(id)sender {
    self.xulyViewEffectView.hidden=YES;
    self.xulyViewVolumeView.hidden=NO;
    [self.xulyViewEffectTapButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.xulyViewVolumeTapButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
}
#pragma mark Karaoke Effect
- (void) addTapSlider{
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedKaraokeEffectEcho:)];
    [self.karaokeEffectEchoSlider addGestureRecognizer:gr];
    UITapGestureRecognizer *gr1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedkaraokeEffectBassChange:)];
    [self.karaokeEffectBassSlider addGestureRecognizer:gr1];
    UITapGestureRecognizer *gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedkaraokeEffectTrebleChange:)];
    [self.karaokeEffectTrebleSlider addGestureRecognizer:gr2];
    UITapGestureRecognizer *gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedkaraokeEffectThickChange:)];
    [self.karaokeEffectThickSlider addGestureRecognizer:gr3];
    UITapGestureRecognizer *gr4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedkaraokeEffectWarmChange:)];
    [self.karaokeEffectWarmSlider addGestureRecognizer:gr4];
    UITapGestureRecognizer *gr5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedsuperBassBassChange:)];
    [self.superBassEffectBassSlider addGestureRecognizer:gr5];
    UITapGestureRecognizer *gr6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedsuperBassTrebleChange:)];
    [self.superBassEffectTrebleSlider addGestureRecognizer:gr6];
    UITapGestureRecognizer *gr7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedsuperBassEchoChange:)];
    [self.superBassEffectEchoSlider addGestureRecognizer:gr7];
    
    UITapGestureRecognizer *gr8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedBoleroBassChange:)];
    [self.boleroEffectBassSlider addGestureRecognizer:gr8];
    UITapGestureRecognizer *gr9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedBoleroTrebleChange:)];
    [self.boleroEffectTrebleSlider addGestureRecognizer:gr9];
    UITapGestureRecognizer *gr10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedBoleroEchoChange:)];
    [self.boleroEffectEchoSlider addGestureRecognizer:gr10];
    
    UITapGestureRecognizer *gr11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedremixBassChange:)];
    [self.remixEffectBassSlider addGestureRecognizer:gr11];
    UITapGestureRecognizer *gr12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedremixEchoChange:)];
    [self.remixEffectEchoSlider addGestureRecognizer:gr12];
    UITapGestureRecognizer *gr13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedremixTrebleChange:)];
    [self.remixEffectTrebleSlider addGestureRecognizer:gr13];
    
    UITapGestureRecognizer *gr14 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedliveEffectBassChange:)];
    [self.liveEffectBassSlider addGestureRecognizer:gr14];
    UITapGestureRecognizer *gr15 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedliveEffectTrebleChange:)];
    [self.liveEffectTrebleSlider addGestureRecognizer:gr15];
    UITapGestureRecognizer *gr16 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedliveEffectEchoChange:)];
    [self.liveEffectEchoSlider addGestureRecognizer:gr16];
    UITapGestureRecognizer *gr17 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedliveEffectThickChange:)];
    [self.liveEffectThickSlider addGestureRecognizer:gr17];
    UITapGestureRecognizer *gr18 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedliveEffectWarmChange:)];
    [self.liveEffectWarmSlider addGestureRecognizer:gr18];
    
    UITapGestureRecognizer *gr19 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedstudioEffecEchoChange:)];
    [self.studioEffectEchoSlider addGestureRecognizer:gr19];
}
- (IBAction)updateEffectSlider:(id)sender {
    if (VipMember    ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}

- (IBAction)karaokeEffectEchoChange:(UISlider *)sender {
    self.karaokeEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInt:(int) sender.value] forKey:@"ECHO"];
    
}
- (IBAction)karaokeUpdateEcho:(id)sender{
    
    
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else {
         [self.audioTapProcessor updateEffectEcho:[[karaokeEffect.parameters objectForKey:@"ECHO"] intValue] ];
    }
}
- (void)sliderTappedKaraokeEffectEcho:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.karaokeEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInt:(int)sender.value] forKey:@"ECHO"];
    
    if (VipMember ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
        [self.audioTapProcessor updateEffectEcho:[[karaokeEffect.parameters objectForKey:@"ECHO"] intValue] ];
    
}
- (IBAction)karaokeEffectSwitchChange:(UISwitch *)sender {
    karaokeEffect.enable=self.karaokeEffectSwitch.isOn?@1:@0;
    if ([karaokeEffect.enable integerValue]) {
        if ([studioEffect.enable integerValue]) {
            studioEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"STUDIO"];
        }
        if ([liveEffect.enable integerValue]) {
            liveEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"LIVE"];
        }
        
        [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
        
    }else{
        
        [songRec.effectsNew.effects removeObjectForKey:@"KARAOKE"];
    }
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)karaokeEffectBassChange:(UISlider*)sender {
    self.karaokeEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInt:(int)((sender.value-50)*2)] forKey:@"BASS"];
   
}
- (IBAction)karaokeUpdateBass:(id)sender{
    
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else {
        [self.audioTapProcessor updateEffectBass:[[karaokeEffect.parameters objectForKey:@"BASS"] intValue] ];
    }
}
- (void)sliderTappedkaraokeEffectBassChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.karaokeEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:(int)((sender.value-50)*2)] forKey:@"BASS"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
        [self.audioTapProcessor updateEffectBass:[[karaokeEffect.parameters objectForKey:@"BASS"] intValue] ];
    
}
- (IBAction)karaokeEffectTrebleChange:(UISlider *)sender {
    self.karaokeEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:(int)((sender.value -50)*2)] forKey:@"TREBLE"];
   
}
- (IBAction)karaokeUpdateTreble:(id)sender{
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else
    [self.audioTapProcessor updateEffectTreble:[[karaokeEffect.parameters objectForKey:@"TREBLE"] intValue] ];
}
- (void)sliderTappedkaraokeEffectTrebleChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.karaokeEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
        [self.audioTapProcessor updateEffectTreble:[[karaokeEffect.parameters objectForKey:@"TREBLE"] intValue] ];
    
}
- (IBAction)karaokeEffectThickChange:(UISlider*)sender {
    if (VipMember  ) {
        self.karaokeEffectThickLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:(int)sender.value] forKey:@"THICK"];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }
}
- (void)sliderTappedkaraokeEffectThickChange:(UIGestureRecognizer *)g{
     if (VipMember  ) {
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
         self.karaokeEffectThickLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
         [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"THICK"];

        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    
     }else{
         dispatch_async(dispatch_get_main_queue(), ^{
             [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
                setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
         });
     }
}
- (IBAction)karaokeEffectWarmChange:(UISlider*)sender {
    if (VipMember  ) {
        self.karaokeEffectWarmLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:(int)sender.value] forKey:@"WARM"];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }
}
- (void)sliderTappedkaraokeEffectWarmChange:(UIGestureRecognizer *)g{
    if (VipMember  ) {
        UISlider* sender = (UISlider*)g.view;
        // if (s.highlighted)
        //     return; // tap on thumb, let slider deal with it
        CGPoint point = [g locationInView: sender];
        CGFloat percentage = point.x / sender.bounds.size.width;
        CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
        CGFloat value = sender.minimumValue + delta;
        [sender setValue:value animated:YES];
        
        self.karaokeEffectWarmLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
        [karaokeEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"WARM"];
        
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }
}
#pragma mark SuperBass Effect
- (IBAction)hideSuperBassEffectView:(id)sender {
    self.superBassEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
   
}
- (IBAction) superBassEchoChange:(UISlider *)sender {
    self.superBassEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
}
- (void)sliderTappedsuperBassEchoChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.superBassEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)superBassBassChange:(UISlider*)sender {
    self.superBassEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(int)((sender.value -50)*2)] forKey:@"BASS"];
    
}
- (void)sliderTappedsuperBassBassChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.superBassEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)superBassTrebleChange:(UISlider *)sender {
    self.superBassEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
}
- (void)sliderTappedsuperBassTrebleChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.superBassEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [superbassEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
#pragma mark Bolero Effect
- (IBAction)hideBoleroEffectView:(id)sender {
    self.boleroEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
    
}
- (IBAction) BoleroEchoChange:(UISlider *)sender {
    self.boleroEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
}
- (void)sliderTappedBoleroEchoChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.boleroEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)BoleroBassChange:(UISlider*)sender {
    self.boleroEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(int)((sender.value -50)*2)] forKey:@"BASS"];
    
}
- (void)sliderTappedBoleroBassChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.boleroEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)BoleroTrebleChange:(UISlider *)sender {
    self.boleroEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
}
- (void)sliderTappedBoleroTrebleChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.boleroEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)BoleroDelayChange:(UISlider *)sender {
    self.boleroEffectDelayLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [boleroEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"DELAY"];
    
}
#pragma mark Remix Effect
- (IBAction)hideRemixEffectView:(id)sender {
    self.remixEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
}
- (void) remixFlangerSelect:(int)select{
    self.remixEffectSoftButton.layer.borderWidth=0;
    self.remixEffectClassicButton.layer.borderWidth=0;
    self.remixEffectSlowBassButton.layer.borderWidth=0;
    switch (select) {
        case 1:
            self.remixEffectSoftButton.layer.borderWidth=1;
              [remixEffect.parameters setObject:Key_Remix_FLANGERTYPE_SOFT forKey:Key_Remix_FLANGERTYPE];
            break;
        case 2:
            self.remixEffectClassicButton.layer.borderWidth=1;
            [remixEffect.parameters setObject:Key_Remix_FLANGERTYPE_CLASSIC forKey:Key_Remix_FLANGERTYPE];
            break;
        case 3:
            self.remixEffectSlowBassButton.layer.borderWidth=1;
             [remixEffect.parameters setObject:Key_Remix_FLANGERTYPE_SLOWBASS forKey:Key_Remix_FLANGERTYPE];
            break;
        default:
            break;
    }
    self.remixEffectSoftButton.layer.masksToBounds=YES;
    self.remixEffectClassicButton.layer.masksToBounds=YES;
    self.remixEffectSlowBassButton.layer.masksToBounds=YES;
}
- (IBAction)remixSoftSelect:(id)sender {
    [self remixFlangerSelect:1];
   [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];

}
- (IBAction)remixClassicSelect:(id)sender {
    [self remixFlangerSelect:2];
    
 [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)remixSlowBassSelect:(id)sender {
    [self remixFlangerSelect:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction) remixEchoChange:(UISlider *)sender {
    self.remixEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
}
- (void)sliderTappedremixEchoChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.remixEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)remixBassChange:(UISlider*)sender {
    self.remixEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
}
- (void)sliderTappedremixBassChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.remixEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)remixTrebleChange:(UISlider *)sender {
    self.remixEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
}
- (void)sliderTappedremixTrebleChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.remixEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [remixEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
#pragma mark Live Effect
- (void)updateStreamEffect{
    @autoreleasepool{
        if (streamName.length>0) {
            songRec.effectsNew.effects=[NSMutableDictionary new];
            if ([karaokeEffect.enable integerValue]) {
                [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
            }else if ([studioEffect.enable integerValue]) {
                
                [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
                
                
            }else  if ([liveEffect.enable integerValue]) {
                
                [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
                
                
            }else  if ([superbassEffect.enable integerValue]) {
                
                [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
                
                
            }else  if ([remixEffect.enable integerValue]) {
                
                [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
                
                
            }else  if ([boleroEffect.enable integerValue]) {
                
                [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
                
                
            }
            if ([voicechangerEffect.enable integerValue]) {
                
                
                [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
                
                
            }
            if ([autotuneEffect.enable integerValue]) {
                [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
            }
            if ([denoiseEffect.enable integerValue]) {
                [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
            }
           
            [self sendUPDATESTREAM:CMTimeGetSeconds(audioPlayer.currentTime)];
        }
        
    }
}
- (IBAction)hideLiveEffect:(id)sender {
    self.liveEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)liveEffectSwitchChange:(UISwitch*)sender {
    liveEffect.enable=sender.isOn?@1:@0;
    
    if ([liveEffect.enable integerValue]) {
        if ([karaokeEffect.enable integerValue]) {
            karaokeEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"KARAOKE"];
        }
        if ([studioEffect.enable integerValue]) {
            studioEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"STUDIO"];
        }
        [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
        
        
    }else{
        
        [songRec.effectsNew.effects removeObjectForKey:@"LIVE"];
    }
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)liveEffectEchoChange:(UISlider*)sender {
    self.liveEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
}
- (void)sliderTappedliveEffectEchoChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.liveEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)liveEffectWarmChange:(UISlider*)sender {
    self.liveEffectWarmLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"WARM"];
}
- (void)sliderTappedliveEffectWarmChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.liveEffectWarmLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"WARM"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)liveEffectThickChange:(UISlider*)sender {
    self.liveEffectThickLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"THICK"];
}
- (void)sliderTappedliveEffectThickChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.liveEffectThickLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"THICK"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)liveEffectBassChange:(UISlider*)sender {
    self.liveEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
    
}
- (void)sliderTappedliveEffectBassChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.liveEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"BASS"];
    
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)liveEffectTrebleChange:(UISlider *)sender {
    self.liveEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
}
- (void)sliderTappedliveEffectTrebleChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.liveEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [liveEffect.parameters setObject:[NSNumber numberWithInteger:(sender.value -50)*2] forKey:@"TREBLE"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
#pragma mark Studio Effect

- (IBAction)studioNuPress:(id)sender {
    [self changeStudioGender:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioNamPress:(id)sender {
    [self changeStudioGender:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (void) changeStudioGender:(int)level{
    self.studioNuButton.layer.borderWidth=0;
    self.studioNamButton.layer.borderWidth=0;
    if (level==1) {
        self.studioNamButton.layer.borderWidth=1;
        [studioEffect.parameters setObject:@"MALE" forKey:@"SEX"];
    }else
        if (level==2) {
           self.studioNuButton.layer.borderWidth=1;
            [studioEffect.parameters setObject:@"FEMALE" forKey:@"SEX"];
        }
    self.studioNamButton.layer.masksToBounds=YES;
    self.studioNuButton.layer.masksToBounds=YES;
}
- (IBAction)studioCGTram:(id)sender {
    [self changeStudioCG:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioCGTrung:(id)sender {
    [self changeStudioCG:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioCGThanh:(id)sender {
    [self changeStudioCG:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (void) changeStudioCG:(int)level{
    self.studioCGThanh.layer.borderWidth=0;
    self.stutioCGTram.layer.borderWidth=0;
    self.stutioCGTrung.layer.borderWidth=0;
    if (level==1) {
        self.stutioCGTram.layer.borderWidth=1;
        [studioEffect.parameters setObject:@"LOW" forKey:@"VOICETYPE"];
       
    }else
        if (level==2) {
            self.stutioCGTrung.layer.borderWidth=1;
            [studioEffect.parameters setObject:@"MID" forKey:@"VOICETYPE"];
           
        }else
            if (level==3) {
             self.studioCGThanh.layer.borderWidth=1;
                [studioEffect.parameters setObject:@"HIGH" forKey:@"VOICETYPE"];
               
            }
    self.studioCGThanh.layer.masksToBounds=YES;
    self.stutioCGTram.layer.masksToBounds=YES;
    self.stutioCGTrung.layer.masksToBounds=YES;
}
- (IBAction)studioTLCham:(id)sender {
    [self changeStudioTL:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioTLVua:(id)sender {
    [self changeStudioTL:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioTLNhanh:(id)sender {
    [self changeStudioTL:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (void) changeStudioTL:(int)level{
    self.studioTLCham.backgroundColor=[UIColor clearColor];
    self.studioTLCham.tintColor=UIColorFromRGB(HeaderColor);
    
    [self.studioTLCham setImage:[UIImage imageNamed:@"voice_type_slow_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.studioTLVua.backgroundColor=[UIColor clearColor];
    self.studioTLVua.tintColor=UIColorFromRGB(HeaderColor);
    
    [self.studioTLVua setImage:[UIImage imageNamed:@"voice_type_medium_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.studioTLNhanh.backgroundColor=[UIColor clearColor];
    self.studioTLNhanh.tintColor=UIColorFromRGB(HeaderColor);
    
    [self.studioTLNhanh setImage:[UIImage imageNamed:@"voice_type_fast_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (level==1) {
        self.studioTLCham.backgroundColor=UIColorFromRGB(HeaderColor);
        self.studioTLCham.tintColor=[UIColor whiteColor];
        [studioEffect.parameters setObject:@"SLOW" forKey:@"TEMPOLEVEL"];
        [self.studioTLCham setImage:[UIImage imageNamed:@"voice_type_slow.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else
        if (level==2) {
            self.studioTLVua.backgroundColor=UIColorFromRGB(HeaderColor);
            self.studioTLVua.tintColor=[UIColor whiteColor];
            [studioEffect.parameters setObject:@"MEDIUM" forKey:@"TEMPOLEVEL"];
            [self.studioTLVua setImage:[UIImage imageNamed:@"voice_type_medium.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else
            if (level==3) {
                self.studioTLNhanh.backgroundColor=UIColorFromRGB(HeaderColor);
                self.studioTLNhanh.tintColor=[UIColor whiteColor];
                [studioEffect.parameters setObject:@"FAST" forKey:@"TEMPOLEVEL"];
                [self.studioTLNhanh setImage:[UIImage imageNamed:@"voice_type_fast.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }
    
}
- (IBAction)studioEffectSwitchChange:(id)sender {
    studioEffect.enable=self.studioEffectSwitch.isOn?@1:@0;
    if ([studioEffect.enable integerValue]) {
        if ([karaokeEffect.enable integerValue]) {
            karaokeEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"KARAOKE"];
        }
        if ([liveEffect.enable integerValue]) {
            liveEffect.enable=@0;
            [songRec.effectsNew.effects removeObjectForKey:@"LIVE"];
        }
        [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
        
        
    }else{
        
        [songRec.effectsNew.effects removeObjectForKey:@"STUDIO"];
    }
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)hideStudioEffect:(id)sender {
    self.studioEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction) studioEffecEchoChange:(UISlider *)sender {
    self.studioEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
}
- (void)sliderTappedstudioEffecEchoChange:(UIGestureRecognizer *)g{
    UISlider* sender = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: sender];
    CGFloat percentage = point.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value animated:YES];
    
    self.studioEffectEchoLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)studioEffectDeesserChange:(UISlider *)sender {
    self.studioEffectDeesserLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"DEESSER"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectBassChange:(UISlider *)sender {
    self.studioEffectBassLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"BASS"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectTrebleChang:(UISlider *)sender {
    self.studioEffectTrebleLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"TREBLE"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectMidChange:(UISlider *)sender {
    self.studioEffectMidLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"MID"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectReverbChange:(UISlider *)sender {
    self.studioEffectReverbLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"REVERB"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectDelayChange:(UISlider *)sender {
    self.studioEffectDelayLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"ECHO"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)studioEffectHarmony:(UISlider *)sender {
    self.studioEffectHarmonyLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [studioEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"HARMONY"];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
#pragma mark Voicechanger Effect

- (IBAction)voicechangerEffectSwitchChange:(id)sender {
    voicechangerEffect.enable=self.voiceChangerEffectSwitch.isOn?@1:@0;
    if ([voicechangerEffect.enable integerValue]) {
        
        
        [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
        
        
    }else{
        
        [songRec.effectsNew.effects removeObjectForKey:@"VOICECHANGER"];
    }
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)voiceChangerEffectHide:(id)sender {
    self.voiceChangerEffectView.hidden=YES;
    [self.xulyViewEffectCollectionView reloadData];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)voiceChangeMaleToFemale:(id)sender {
    [self changeVoiceChangerEffect:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)voiceChangeFemaleToMale:(id)sender {
    [self changeVoiceChangerEffect:4];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)voiceChangeBaby:(id)sender {
    [self changeVoiceChangerEffect:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)voiceChangeOlder:(id)sender {
    [self changeVoiceChangerEffect:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)selectVoiceChangerEffect:(id)sender{
    if (!VipMember) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }else{
    UIButton *button=(UIButton *) sender;
    NSInteger row=button.tag;
    [self changeVoiceChangerEffect:row];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (void) changeVoiceChangerEffect:(NSInteger) level{
    changeVoiceEffectLevel=level;
    if (level!=0) {
        voicechangerEffect.enable=@1;
    }
    if (level==0) {
        voicechangerEffect.enable=@0;
    }else if (level==1) {
       
        [voicechangerEffect.parameters setObject:BABY forKey:@"TYPE"];
    }else
        if (level==2) {
            
            [voicechangerEffect.parameters setObject:OLDPERSON forKey:@"TYPE"];
            
        }else
            if (level==3) {
               
                [voicechangerEffect.parameters setObject:MALE2FEMALE forKey:@"TYPE"];
                
            }else
                if (level==4) {
                    
                    [voicechangerEffect.parameters setObject:FEMALE2MALE forKey:@"TYPE"];
                    
                }
    [self.xulyViewChangeVoiceEffectCollectionView reloadData];
    
    /*self.voiceChangerMaleToFemale.backgroundColor=[UIColor clearColor];
    self.voiceChangerMaleToFemale.tintColor=UIColorFromRGB(HeaderColor);
    [self.voiceChangerMaleToFemale setImage:[UIImage imageNamed:@"female_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.voiceChangerFemaleToMale.backgroundColor=[UIColor clearColor];
    self.voiceChangerFemaleToMale.tintColor=UIColorFromRGB(HeaderColor);
    [self.voiceChangerFemaleToMale setImage:[UIImage imageNamed:@"male_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.voiceChangerBaby.backgroundColor=[UIColor clearColor];
    self.voiceChangerBaby.tintColor=UIColorFromRGB(HeaderColor);
    [self.voiceChangerBaby setImage:[UIImage imageNamed:@"baby_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.voiceChangerOlder.backgroundColor=[UIColor clearColor];
    self.voiceChangerOlder.tintColor=UIColorFromRGB(HeaderColor);
    [self.voiceChangerOlder setImage:[UIImage imageNamed:@"old_person_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (level==1) {
        self.voiceChangerMaleToFemale.backgroundColor=UIColorFromRGB(HeaderColor);
        self.voiceChangerMaleToFemale.tintColor=[UIColor whiteColor];
        
        [self.voiceChangerMaleToFemale setImage:[UIImage imageNamed:@"female.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [voicechangerEffect.parameters setObject:MALE2FEMALE forKey:@"TYPE"];
    }else
        if (level==2) {
            self.voiceChangerFemaleToMale.backgroundColor=UIColorFromRGB(HeaderColor);
            self.voiceChangerFemaleToMale.tintColor=[UIColor whiteColor];
            
            [self.voiceChangerFemaleToMale setImage:[UIImage imageNamed:@"male.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            [voicechangerEffect.parameters setObject:FEMALE2MALE forKey:@"TYPE"];
            
        }else
            if (level==3) {
                self.voiceChangerBaby.backgroundColor=UIColorFromRGB(HeaderColor);
                self.voiceChangerBaby.tintColor=[UIColor whiteColor];
                [self.voiceChangerBaby setImage:[UIImage imageNamed:@"baby.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                [voicechangerEffect.parameters setObject:BABY forKey:@"TYPE"];
                
            }else
                if (level==4) {
                    self.voiceChangerOlder.backgroundColor=UIColorFromRGB(HeaderColor);
                    self.voiceChangerOlder.tintColor=[UIColor whiteColor];
                    [self.voiceChangerOlder setImage:[UIImage imageNamed:@"old_person.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    [voicechangerEffect.parameters setObject:OLDPERSON forKey:@"TYPE"];
                    
                }*/
}
- (IBAction)voiceChangerSelect:(UIButton *)sender {
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:voiceChangerMenu];
    popover.tint = FPPopoverWhiteTint;
    popover.keyboardHeight = _keyboardHeight;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(200, (voiceChangerMenu.array.count)*50+42);
    }
    else {
        popover.contentSize = CGSizeMake(200, (voiceChangerMenu.array.count)*50+42);
    }
    
    
    popover.arrowDirection = FPPopoverNoArrow;
    NSLog(@"%f %f",self.view.center.y,self.view.frame.size.height/2);
    [popover presentPopoverFromPoint: sender.center];
}
#pragma mark Autotune Effect


- (IBAction)hideAutotuneEffectView:(id)sender {
    self.autotuneEffectView.hidden=YES;
    self.xulyViewAutotuneSubView.hidden=NO;
    self.xulyMenuToolbarCollectionView.hidden=NO;
}
- (IBAction)autotuneEffectSwitchChange:(UISwitch *)sender {
    autotuneEffect.enable=sender.isOn?@1:@0;
    if ([autotuneEffect.enable integerValue]) {
        [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
    }else{
        [songRec.effectsNew.effects  removeObjectForKey:@"AUTOTUNE"];
    }
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneItPress:(id)sender {
    [self changeAutotuneLevel:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneVuaPress:(id)sender {
    [self changeAutotuneLevel:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneNhieuPress:(id)sender {
    [self changeAutotuneLevel:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneRatNhieuPress:(id)sender {
    [self changeAutotuneLevel:4];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneEffectVirIt:(id)sender {
    [self changeAutotuneVibratoLevel:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneEffectVibVua:(id)sender {
    [self changeAutotuneVibratoLevel:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneEffectVirNhieu:(id)sender {
    [self changeAutotuneVibratoLevel:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneTruong:(id)sender {
    [self changeAutotuneAmGiai:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)autotuneThu:(id)sender {
    [self changeAutotuneAmGiai:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (void) changeAutotuneAmGiai:(int)level{
    self.autotuneAmTruong.backgroundColor=[UIColor clearColor];
    self.autotuneAmTruong.tintColor=UIColorFromRGB(HeaderColor);
    [self.autotuneAmTruong setImage:[UIImage imageNamed:@"music_major_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.autotuneAmthu.backgroundColor=[UIColor clearColor];
    self.autotuneAmthu.tintColor=UIColorFromRGB(HeaderColor);
    [self.autotuneAmthu setImage:[UIImage imageNamed:@"music_minor_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (level==1) {
        self.autotuneAmTruong.backgroundColor=UIColorFromRGB(HeaderColor);
        self.autotuneAmTruong.tintColor=[UIColor whiteColor];
        [self.autotuneAmTruong setImage:[UIImage imageNamed:@"music_major.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        amgiai=@"M";
    }else
        if (level==2) {
            self.autotuneAmthu.backgroundColor=UIColorFromRGB(HeaderColor);
            self.autotuneAmthu.tintColor=[UIColor whiteColor];
            
            [self.autotuneAmthu setImage:[UIImage imageNamed:@"music_minor.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            amgiai=@"m";
        }
    
    autotuneKey=[NSString stringWithFormat:@"%@%@",chuam,amgiai];
    if ([chuam isEqualToString:@"Auto"]) autotuneKey=@"Auto";
    [autotuneEffect.parameters setObject:autotuneKey forKey:@"KEY"];
    
}
- (void) changeAutotuneVibratoLevel:(int)level{
    self.autotuneEffectVibNhieu.layer.borderWidth=0;
    self.autotuneEffectVibVua.layer.borderWidth=0;
    self.autotuneEffectVibIt.layer.borderWidth=0;
    
    if (level==1) {
       self.autotuneEffectVibIt.layer.borderWidth=1;
        [autotuneEffect.parameters setObject:@"LOW" forKey:@"VIBRATOLEVEL"];
    }else
        if (level==2) {
           self.autotuneEffectVibVua.layer.borderWidth=1;
            [autotuneEffect.parameters setObject:@"MID" forKey:@"VIBRATOLEVEL"];
            
        }else
            if (level==3) {
               self.autotuneEffectVibNhieu.layer.borderWidth=1;
                [autotuneEffect.parameters setObject:@"HIGH" forKey:@"VIBRATOLEVEL"];
            }
    
}
- (IBAction)selectAutotuneEffect:(id)sender{
    if (!VipMember) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }else{
    UIButton *button=(UIButton *) sender;
    NSInteger row=button.tag;
        if (autotuneEffectLevel==row && row!=0) {
            
            [self hideAllXulySubView];
            self.autotuneEffectView.hidden=NO;
            self.xulyMenuToolbarCollectionView.hidden=YES;
        }else{
    [self changeAutotuneLevel:row];
            [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];}
    }
}
- (void) changeAutotuneLevel:(NSInteger)level{
    autotuneEffectLevel=level;
    
    if (level!=0) {
        autotuneEffect.enable=@1;
    }
    if (level==0) {
        autotuneEffect.enable=@0;
    }else
    if (level==1) {
       
        [autotuneEffect.parameters setObject:@"LOW" forKey:@"AUTOTUNELEVEL"];
    }else
        if (level==2) {
           
            [autotuneEffect.parameters setObject:@"MID" forKey:@"AUTOTUNELEVEL"];
            
        }else
            if (level==3) {
                
                [autotuneEffect.parameters setObject:@"HIGH" forKey:@"AUTOTUNELEVEL"];
                
            }else
                if (level==4) {
                   
                    [autotuneEffect.parameters setObject:@"SUPERHIGH" forKey:@"AUTOTUNELEVEL"];
                    
                }
    [self.xulyViewAutotuneEffectCollectionView reloadData];
   /* self.autotuneIt.backgroundColor=[UIColor clearColor];
    self.autotuneIt.tintColor=UIColorFromRGB(HeaderColor);
    
    [self.autotuneIt setImage:[UIImage imageNamed:@"autotune_low_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.autotuneVua.backgroundColor=[UIColor clearColor];
    self.autotuneVua.tintColor=UIColorFromRGB(HeaderColor);
    [self.autotuneVua setImage:[UIImage imageNamed:@"autotune_medium_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.autotuneNhieu.backgroundColor=[UIColor clearColor];
    self.autotuneNhieu.tintColor=UIColorFromRGB(HeaderColor);
    [self.autotuneNhieu setImage:[UIImage imageNamed:@"autotune_high_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.autotuneRatNhieu.backgroundColor=[UIColor clearColor];
    self.autotuneRatNhieu.tintColor=UIColorFromRGB(HeaderColor);
    [self.autotuneRatNhieu setImage:[UIImage imageNamed:@"autotune_superhigh_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (level==1) {
        self.autotuneIt.backgroundColor=UIColorFromRGB(HeaderColor);
        self.autotuneIt.tintColor=[UIColor whiteColor];
        [self.autotuneIt setImage:[UIImage imageNamed:@"autotune_low.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [autotuneEffect.parameters setObject:@"LOW" forKey:@"AUTOTUNELEVEL"];
    }else
        if (level==2) {
            self.autotuneVua.backgroundColor=UIColorFromRGB(HeaderColor);
            self.autotuneVua.tintColor=[UIColor whiteColor];
            
            [self.autotuneVua setImage:[UIImage imageNamed:@"autotune_medium.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            [autotuneEffect.parameters setObject:@"MID" forKey:@"AUTOTUNELEVEL"];
            
        }else
            if (level==3) {
                self.autotuneNhieu.backgroundColor=UIColorFromRGB(HeaderColor);
                self.autotuneNhieu.tintColor=[UIColor whiteColor];
                [self.autotuneNhieu setImage:[UIImage imageNamed:@"autotune_high.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                [autotuneEffect.parameters setObject:@"HIGH" forKey:@"AUTOTUNELEVEL"];
                
            }else
                if (level==4) {
                    self.autotuneRatNhieu.backgroundColor=UIColorFromRGB(HeaderColor);
                    self.autotuneRatNhieu.tintColor=[UIColor whiteColor];
                    [autotuneEffect.parameters setObject:@"SUPERHIGH" forKey:@"AUTOTUNELEVEL"];
                    
                    [self.autotuneRatNhieu setImage:[UIImage imageNamed:@"autotune_superhigh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }*/
}
#pragma mark Denoise Effect


- (IBAction)hideDenoiseEffectView:(id)sender {
    self.denoiseEffectView.hidden=YES;
    [self.xulyViewEffectCollectionView reloadData];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)denoiseIt:(id)sender {
    [self changeDenoiseLevel:1];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)denoiseVua:(id)sender {
    [self changeDenoiseLevel:2];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)denoiseNhieu:(id)sender {
    [self changeDenoiseLevel:3];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)selectDenoiseEffect:(id)sender{
    if (!VipMember) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng nâng cấp VIP để sử dụng chức năng này!", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        });
    }else{
    UIButton *button=(UIButton *) sender;
    NSInteger row=button.tag;
    [self changeDenoiseLevel:row];
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (void) changeDenoiseLevel:(NSInteger)level{
    denoiseEffectLevel=level;
    if (level!=0) {
        denoiseEffect.enable=@1;
    }
    if (level==0) {
        denoiseEffect.enable=@0;
    }else if (level==1) {
       
        [denoiseEffect.parameters setObject:@"LOW" forKey:@"DENOISELEVEL"];
    }else
        if (level==2) {
            [denoiseEffect.parameters setObject:@"MID" forKey:@"DENOISELEVEL"];
            
        }else
            if (level==3) {
                [denoiseEffect.parameters setObject:@"HIGH" forKey:@"DENOISELEVEL"];
                
            }
    [self.xulyViewDenoiseEffectCollectionView reloadData];
   /* self.denoiseIt.backgroundColor=[UIColor clearColor];
    self.denoiseIt.tintColor=UIColorFromRGB(HeaderColor);
    
    [self.denoiseIt setImage:[UIImage imageNamed:@"small_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.denoiseVua.backgroundColor=[UIColor clearColor];
    self.denoiseVua.tintColor=UIColorFromRGB(HeaderColor);
    [self.denoiseVua setImage:[UIImage imageNamed:@"normal_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.denoiseNhieu.backgroundColor=[UIColor clearColor];
    self.denoiseNhieu.tintColor=UIColorFromRGB(HeaderColor);
    [self.denoiseNhieu setImage:[UIImage imageNamed:@"large_select.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (level==1) {
        self.denoiseIt.backgroundColor=UIColorFromRGB(HeaderColor);
        self.denoiseIt.tintColor=[UIColor whiteColor];
        [denoiseEffect.parameters setObject:@"LOW" forKey:@"DENOISELEVEL"];
        [self.denoiseIt setImage:[UIImage imageNamed:@"small.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else
        if (level==2) {
            self.denoiseVua.backgroundColor=UIColorFromRGB(HeaderColor);
            self.denoiseVua.tintColor=[UIColor whiteColor];
            [denoiseEffect.parameters setObject:@"MID" forKey:@"DENOISELEVEL"];
            
            [self.denoiseVua setImage:[UIImage imageNamed:@"normal.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else
            if (level==3) {
                self.denoiseNhieu.backgroundColor=UIColorFromRGB(HeaderColor);
                self.denoiseNhieu.tintColor=[UIColor whiteColor];
                [denoiseEffect.parameters setObject:@"HIGH" forKey:@"DENOISELEVEL"];
                
                [self.denoiseNhieu setImage:[UIImage imageNamed:@"large.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }*/
}
- (IBAction)denoiseEffectSwitchChange:(UISwitch*)sender {
    denoiseEffect.enable=sender.isOn?@1:@0;
    if ([denoiseEffect.enable integerValue]) {
        [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
    }else{
        [songRec.effectsNew.effects  removeObjectForKey:@"DENOISE"];
    }
    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (IBAction)denoiseEffectValueChange:(UISlider *)sender {
    self.denoiseEffectLabel.text=[NSString stringWithFormat:@"%0.f",sender.value];
    [denoiseEffect.parameters setObject:[NSNumber numberWithInteger:sender.value] forKey:@"DENOISE"];
     [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
}
- (void) borderEffectButton{
    
    /*self.autotuneAmTruong.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.autotuneAmTruong.layer.borderWidth=1;
    self.autotuneAmTruong.layer.cornerRadius=3;
    self.autotuneAmTruong.layer.masksToBounds=YES;
    self.autotuneAmthu.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.autotuneAmthu.layer.borderWidth=1;
    self.autotuneAmthu.layer.cornerRadius=3;
    self.autotuneAmthu.layer.masksToBounds=YES;
    [self changeAutotuneAmGiai:1];*/
    
    
    self.autotuneEffectVibNhieu.layer.borderColor= [UIColorFromRGB(ColorSlider) CGColor];
    self.autotuneEffectVibNhieu.layer.borderWidth=1;
    self.autotuneEffectVibNhieu.layer.cornerRadius=55/2;
    self.autotuneEffectVibNhieu.layer.masksToBounds=YES;
    self.autotuneEffectVibVua.layer.borderColor=[UIColorFromRGB(ColorSlider)  CGColor];
    self.autotuneEffectVibVua.layer.borderWidth=1;
    self.autotuneEffectVibVua.layer.cornerRadius=55/2;
    self.autotuneEffectVibVua.layer.masksToBounds=YES;
    self.autotuneEffectVibIt.layer.borderColor=[UIColorFromRGB(ColorSlider)  CGColor];
    self.autotuneEffectVibIt.layer.borderWidth=1;
    self.autotuneEffectVibIt.layer.cornerRadius=55/2;
    self.autotuneEffectVibIt.layer.masksToBounds=YES;
    [self changeAutotuneVibratoLevel:1];
    
    /*self.autotuneRatNhieu.layer.borderColor= [UIColorFromRGB(HeaderColor) CGColor];
    self.autotuneRatNhieu.layer.borderWidth=1;
    self.autotuneRatNhieu.layer.cornerRadius=3;
    self.autotuneRatNhieu.layer.masksToBounds=YES;
    self.autotuneNhieu.layer.borderColor= [UIColorFromRGB(HeaderColor) CGColor];
    self.autotuneNhieu.layer.borderWidth=1;
    self.autotuneNhieu.layer.cornerRadius=3;
    self.autotuneNhieu.layer.masksToBounds=YES;
    self.autotuneVua.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.autotuneVua.layer.borderWidth=1;
    self.autotuneVua.layer.cornerRadius=3;
    self.autotuneVua.layer.masksToBounds=YES;
    self.autotuneIt.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.autotuneIt.layer.borderWidth=1;
    self.autotuneIt.layer.cornerRadius=3;
    self.autotuneIt.layer.masksToBounds=YES;
    [self changeAutotuneLevel:0];
    self.denoiseIt.layer.borderColor= [UIColorFromRGB(HeaderColor) CGColor];
    self.denoiseIt.layer.borderWidth=1;
    self.denoiseIt.layer.cornerRadius=3;
    self.denoiseIt.layer.masksToBounds=YES;
    self.denoiseVua.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.denoiseVua.layer.borderWidth=1;
    self.denoiseVua.layer.cornerRadius=3;
    self.denoiseVua.layer.masksToBounds=YES;
    self.denoiseNhieu.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.denoiseNhieu.layer.borderWidth=1;
    self.denoiseNhieu.layer.cornerRadius=3;
    self.denoiseNhieu.layer.masksToBounds=YES;*/
    [self changeDenoiseLevel:0];
    self.studioNamButton.layer.borderColor= [UIColorFromRGB(ColorSlider)    CGColor];
    self.studioNamButton.layer.borderWidth=1;
    self.studioNamButton.layer.cornerRadius=55/2;
    self.studioNamButton.layer.masksToBounds=YES;
    self.studioNuButton.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.studioNuButton.layer.borderWidth=1;
    self.studioNuButton.layer.cornerRadius=55/2;
    self.studioNuButton.layer.masksToBounds=YES;
    [self changeStudioGender:1];
    self.studioCGThanh.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.studioCGThanh.layer.borderWidth=1;
    self.studioCGThanh.layer.cornerRadius=55/2;
    self.studioCGThanh.layer.masksToBounds=YES;
    self.stutioCGTrung.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.stutioCGTrung.layer.borderWidth=1;
    self.stutioCGTrung.layer.cornerRadius=55/2;
    self.stutioCGTrung.layer.masksToBounds=YES;
    self.stutioCGTram.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.stutioCGTram.layer.borderWidth=1;
    self.stutioCGTram.layer.cornerRadius=55/2;
    self.stutioCGTram.layer.masksToBounds=YES;
    [self changeStudioCG:2];
    self.studioTLCham.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.studioTLCham.layer.borderWidth=1;
    self.studioTLCham.layer.cornerRadius=55/2;
    self.studioTLCham.layer.masksToBounds=YES;
    self.studioTLVua.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.studioTLVua.layer.borderWidth=1;
    self.studioTLVua.layer.cornerRadius=55/2;
    self.studioTLVua.layer.masksToBounds=YES;
    self.studioTLNhanh.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.studioTLNhanh.layer.borderWidth=1;
    self.studioTLNhanh.layer.cornerRadius=55/2;
    self.studioTLNhanh.layer.masksToBounds=YES;
    //[self changeStudioTL:2];
   /* self.voiceChangerOlder.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.voiceChangerOlder.layer.borderWidth=1;
    self.voiceChangerOlder.layer.cornerRadius=3;
    self.voiceChangerOlder.layer.masksToBounds=YES;
    self.voiceChangerBaby.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.voiceChangerBaby.layer.borderWidth=1;
    self.voiceChangerBaby.layer.cornerRadius=3;
    self.voiceChangerBaby.layer.masksToBounds=YES;
    self.voiceChangerFemaleToMale.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.voiceChangerFemaleToMale.layer.borderWidth=1;
    self.voiceChangerFemaleToMale.layer.cornerRadius=3;
    self.voiceChangerFemaleToMale.layer.masksToBounds=YES;
    self.voiceChangerMaleToFemale.layer.borderColor=[UIColorFromRGB(HeaderColor)  CGColor];
    self.voiceChangerMaleToFemale.layer.borderWidth=1;
    self.voiceChangerMaleToFemale.layer.cornerRadius=3;
    self.voiceChangerMaleToFemale.layer.masksToBounds=YES;
    [self changeVoiceChangerEffect:0];*/
    
    self.remixEffectClassicButton.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.remixEffectClassicButton.layer.borderWidth=1;
    self.remixEffectClassicButton.layer.cornerRadius=60/2;
    self.remixEffectClassicButton.layer.masksToBounds=YES;
    self.remixEffectSlowBassButton.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.remixEffectSlowBassButton.layer.borderWidth=1;
    self.remixEffectSlowBassButton.layer.cornerRadius=60/2;
    self.remixEffectSlowBassButton.layer.masksToBounds=YES;
    self.remixEffectSoftButton.layer.borderColor=[UIColorFromRGB(ColorSlider)    CGColor];
    self.remixEffectSoftButton.layer.borderWidth=1;
    self.remixEffectSoftButton.layer.cornerRadius=60/2;
    self.remixEffectSoftButton.layer.masksToBounds=YES;
    [self remixFlangerSelect:2];
}
- (void) getBpmAndKey{
    @autoreleasepool{
       
    }
}
- (void) updateSlider:(UISlider *)slider withSize:(CGFloat) thumbSize andColor:(UIColor *)color{
    UIImage* thumbImage =[self  createThumbImage:thumbSize andColor: color];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
}

- (UIImage *) createThumbImage:(CGFloat )size andColor:(UIColor *)color {
    CGRect layerFrame = CGRectMake(0, 0, size, size);
    
    CAShapeLayer* shapeLayer =[[CAShapeLayer alloc] init];
    shapeLayer.path = CGPathCreateWithEllipseInRect(CGRectInset(layerFrame, 1, 1), nil);
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.strokeColor =[ [color colorWithAlphaComponent:0.65] CGColor];
    
    CALayer* layer = [[CALayer alloc] init];
    layer.frame = layerFrame;
    [layer addSublayer:shapeLayer];
    return [self imageFromLayer:layer];
}

-(UIImage *) imageFromLayer:(CALayer *)layer{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
#pragma mark new interface xuly
- (void) hideAllXulySubView{
    self.xulyViewLechNhipSubView.hidden=YES;
    self.xulyViewEffectView.hidden=YES;
    self.xulyViewVolumeView.hidden=YES;
    self.xulyViewChangeVoiceSubview.hidden=YES;
    self.xulyViewAutotuneSubView.hidden=YES;
    self.xulyViewDenoiseSubview.hidden=YES;
    self.karaokeEffectView.hidden=YES;
    self.remixEffectView.hidden=YES;
    self.boleroEffectView.hidden=YES;
    self.superBassEffectView.hidden=YES;
    self.liveEffectView.hidden=YES;
    self.studioEffectView.hidden=YES;
}
- (IBAction)liveEffectViewMenuChange:(id)sender {
    switch (self.liveEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllLiveEffectSubView];
            self.liveEffectEchoSubView.hidden=NO;
            break;
        case 1:
            [self hideAllLiveEffectSubView];
            self.liveEffectBassSubView.hidden=NO;
            break;
        case 2:
            [self hideAllLiveEffectSubView];
            self.liveEffectTrebleSubView.hidden=NO;
            break;
        case 3:
            [self hideAllLiveEffectSubView];
            self.liveEffectWarmSubView.hidden=NO;
            break;
        case 4:
            [self hideAllLiveEffectSubView];
            self.liveEffectThickSubView.hidden=NO;
            break;
        default:
            break;
    }
}
- (void) hideAllLiveEffectSubView{
    self.liveEffectThickSubView.hidden=YES;
    self.liveEffectWarmSubView.hidden=YES;
    self.liveEffectTrebleSubView.hidden=YES;
    self.liveEffectBassSubView.hidden=YES;
    self.liveEffectEchoSubView.hidden=YES;
}
- (IBAction)superBassEffectViewMenuChange:(id)sender {
    switch (self.superbassEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllSuperbassEffectSubView];
            self.superbassEffectEchoSubView.hidden=NO;
            break;
        case 1:
            [self hideAllSuperbassEffectSubView];
            self.superbassEffectBassSubView.hidden=NO;
            break;
        case 2:
            [self hideAllSuperbassEffectSubView];
            self.superbassEffectTrebleSubView.hidden=NO;
            break;
            
        default:
            break;
    }
}
- (void) hideAllSuperbassEffectSubView{
    self.superbassEffectBassSubView.hidden=YES;
    self.superbassEffectTrebleSubView.hidden=YES;
    self.superbassEffectEchoSubView.hidden=YES;
}
- (IBAction)autotuneEffectViewMenuChange:(id)sender {
    switch (self.xulyViewAutotuneMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllAutotuneEffectSubView];
            self.xulyViewAutotuneTuyChinhSubView.hidden=NO;
            break;
        case 1:
            [self hideAllAutotuneEffectSubView];
            self.xulyViewAutotuneDoRungSubView.hidden=NO;
            break;
        
            
        default:
            break;
    }
}
- (void) hideAllAutotuneEffectSubView{
    self.xulyViewAutotuneDoRungSubView.hidden=YES;
    self.xulyViewAutotuneTuyChinhSubView.hidden=YES;
}
- (IBAction)boleroEffectViewMenuChange:(id)sender {
    switch (self.boleroEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllBoleroEffectSubView];
            self.boleroEffectEchoSubView.hidden=NO;
            break;
        case 1:
            [self hideAllBoleroEffectSubView];
            self.boleroEffectBassSubView.hidden=NO;
            break;
        case 2:
            [self hideAllBoleroEffectSubView];
            self.boleroEffectTrebleSubView.hidden=NO;
            break;
            
        default:
            break;
    }
}
- (void) hideAllBoleroEffectSubView{
    self.boleroEffectBassSubView.hidden=YES;
    self.boleroEffectEchoSubView.hidden=YES;
    self.boleroEffectTrebleSubView.hidden=YES;
}
- (IBAction)remixEffectViewMenuChange:(id)sender {
    switch (self.remixEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllRemixEffectSubView];
            self.RemixEffectRemixSubView.hidden=NO;
            break;
        case 1:
            [self hideAllRemixEffectSubView];
            self.remixEffectEchoSubView.hidden=NO;
            break;
        case 2:
            [self hideAllRemixEffectSubView];
            self.remixEffectBassSubView.hidden=NO;
            break;
        case 3:
            [self hideAllRemixEffectSubView];
            self.remixEffectTrebleSubview.hidden=NO;
            break;
        
        default:
            break;
    }
}
- (void) hideAllRemixEffectSubView{
    self.remixEffectBassSubView.hidden=YES;
    self.remixEffectEchoSubView.hidden=YES;
    self.remixEffectTrebleSubview.hidden=YES;
    self.RemixEffectRemixSubView.hidden=YES;
}
- (IBAction)karaokeEffectViewMenuChange:(id)sender {
    switch (self.karaokeEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllKaraokeEffectSubView];
            self.karaokeEffectEchoSubview.hidden=NO;
            break;
        case 1:
            [self hideAllKaraokeEffectSubView];
            self.karaokeEffectBassSubview.hidden=NO;
            break;
        case 2:
            [self hideAllKaraokeEffectSubView];
            self.karaokeEffectTrebleSubView.hidden=NO;
            break;
        case 3:
            [self hideAllKaraokeEffectSubView];
            self.karaokeEffectWarmSubView.hidden=NO;
            break;
        case 4:
            [self hideAllKaraokeEffectSubView];
            self.karaokeEffectThickSubView.hidden=NO;
            break;
        default:
            break;
    }
}
- (void) hideAllKaraokeEffectSubView{
    self.karaokeEffectEchoSubview.hidden=YES;
    self.karaokeEffectTrebleSubView.hidden=YES;
    self.karaokeEffectBassSubview.hidden=YES;
    self.karaokeEffectWarmSubView.hidden=YES;
    self.karaokeEffectThickSubView.hidden=YES;
}
- (void) hideAllStudioEffectSubView{
    self.studioEffectEchoSubView.hidden=YES;
    self.studioEffectVoiceSubView.hidden=YES;
    self.studioEffectGenderSubView.hidden=YES;
}
- (IBAction)studioEffectViewMenuChange:(id)sender {
    switch (self.studioEffectMenuSegment.selectedSegmentIndex) {
        case 0:
            [self hideAllStudioEffectSubView];
            self.studioEffectGenderSubView.hidden=NO;
            break;
        case 1:
            [self hideAllStudioEffectSubView];
            self.studioEffectVoiceSubView.hidden=NO;
            break;
        case 2:
            [self hideAllStudioEffectSubView];
            self.studioEffectEchoSubView.hidden=NO;
            break;
       
        default:
            break;
    }
}
- (IBAction)hideKaraokeEffectView:(id)sender {
    self.karaokeEffectView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewEffectView.hidden=NO;
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
}
- (IBAction)xulyViewMenuSelect:(id)sender{
    UIButton *btn=(UIButton *) sender;
    NSInteger row=btn.tag;
    xulyViewMenuSelected=row;
    [self.xulyMenuToolbarCollectionView reloadData];
    switch (xulyViewMenuSelected) {
        case 0:
            [self hideAllXulySubView];
            self.xulyViewVolumeView.hidden=NO;
            break;
        case 1:
            [self hideAllXulySubView];
            self.xulyViewEffectView.hidden=NO;
			  if (!IPAD)
            [self.xulyMenuToolbarCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 2:
           
            [self hideAllXulySubView];
            self.xulyViewDenoiseSubview.hidden=NO;
			  if (!IPAD)
            [self.xulyMenuToolbarCollectionView setContentOffset:CGPointMake(90, 0) animated:YES];
            break;
        case 3:
           
            [self hideAllXulySubView];
			  if (!IPAD)
            [self.xulyMenuToolbarCollectionView setContentOffset:CGPointMake(self.xulyMenuToolbarCollectionView.contentSize.width-self.view.frame.size.width, 0) animated:YES];
            self.xulyViewAutotuneSubView.hidden=NO;
            break;
        case 4:
            
            [self hideAllXulySubView];
			  if (!IPAD)
            [self.xulyMenuToolbarCollectionView setContentOffset:CGPointMake(self.xulyMenuToolbarCollectionView.contentSize.width-self.view.frame.size.width, 0) animated:YES];
            self.xulyViewChangeVoiceSubview.hidden=NO;
            break;
            
        default:
            break;
    }
}
- (IBAction)showLechNhipSubView:(id)sender {
    
    [self hideAllXulySubView];
    self.xulyViewLechNhipSubView.hidden=NO;
    self.xulyMenuToolbarCollectionView.hidden=YES;
}
- (IBAction)hideLechNhipSubView:(id)sender {
    self.xulyViewLechNhipSubView.hidden=YES;
    self.xulyMenuToolbarCollectionView.hidden=NO;
    self.xulyViewVolumeView.hidden=NO;
    
}

- (void) downloadSongMp3{
    @autoreleasepool{
        if (songPlay.songUrl.length==0) {
            Song * song=[Song new];
            song.videoId=songPlay.videoId;
            song._id=songPlay._id;
            song.songName=songPlay.songName;
            song.singerName=songPlay.singerName;
            song.approvedLyric=songPlay.approvedLyric;
            song.videoId=songPlay.videoId;
            song.thumbnailUrl=songPlay.thumbnailUrl;
            song.likeCounter=songPlay.likeCounter;
            song.dislikeCounter=songPlay.dislikeCounter;
            song.duration=songPlay.duration;

            song.mp4link=songPlay.mp4link;
            GetYoutubeMp3LinkRespone *res= [[LoadData2 alloc] GetYoutubeMp3Link:song];
            if ([res.url isKindOfClass:[NSString class]]) {
                songPlay.songUrl=res.url;
            }
        }
        if (songPlay.songUrl.length>0 || ([songRec.performanceType isEqualToString:@"DUET"] && songRec.originalRecording.length>0)) {
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
            if ([songPlay.songUrl isKindOfClass:[NSString class]])
            if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
            }
            if (songPlay.videoId.length>2){
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
                
            }
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
            }

                //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswidutch_on.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];

            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (haveS ){
                AVAudioMix *audioMix = self.audioTapProcessor.audioMix;
                if (audioMix)
                    {
                        // Add audio mix with first audio track.
                    audioPlayer.currentItem.audioMix = audioMix;

                    }


            }else{


                    // self.startButton.backgroundColor=UIColorFromRGB(0x959595);

                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

                    //  NSURL *URL = [NSURL URLWithString:fileURL];
                NSURLRequest *request ;
                if ([songRec.performanceType isEqualToString:@"DUET"]) {
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:songRec.onlineMp3Recording]];
                }else{
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:songPlay.songUrl]];
                }
                self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{




                    });
                }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                        //  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
                    if ([songPlay.songUrl isKindOfClass:[NSString class]])
                    if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
                    }
                    if (songPlay.videoId.length>2){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
                        
                    }
                    if ([songRec.performanceType isEqualToString:@"DUET"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
                    }
                    return [NSURL fileURLWithPath: filePath];

                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    if (error) {

                    }else{

                        AVAudioMix *audioMix = self.audioTapProcessor.audioMix;
                        if (audioMix)
                            {
                                // Add audio mix with first audio track.
                            audioPlayer.currentItem.audioMix = audioMix;

                            }

                       








                    }
                }];
                [self.downloadTask resume];
                    // [self.download startWithDelegate:self];
            }
        }

    }
}
- (void)viewDidLoad
{
    @autoreleasepool {
        if (![songRec.song.songUrl isKindOfClass:[NSString class]]) {
            songRec.song.songUrl=@"";
        }
        if (isrecord) {
            [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA06_recording",@"description":@"Thu Âm"}];
        }
        float playthroughVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"playthroghVolume"];
        float micoEchoVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"EchoVolume"];
        if (playthroughVolume==0.0f) {
            playthroughVolume = 1;
            micoEchoVolume = 100;
            [[NSUserDefaults standardUserDefaults] setFloat:playthroughVolume forKey:@"playthroghVolume"];
            [[NSUserDefaults standardUserDefaults] setFloat:micoEchoVolume forKey:@"EchoVolume"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSBundle* bun = [YokaraSDK resourceBundle];
        intervalRender = 0.1f;
        self.xulyViewLechNhipTitle.text = AMLocalizedString(@"Hát lệch nhịp?", nil);
        [self.xulyViewLechNhipLoiChamButton setTitle:[NSString stringWithFormat:@"  %@",AMLocalizedString(@"Lời Chậm", nil)] forState:UIControlStateNormal];
        [self.xulyViewLechNhipLoiNhanhButton setTitle:[NSString stringWithFormat:@"  %@",AMLocalizedString(@"Lời Nhanh", nil)] forState:UIControlStateNormal];
        self.karaokeEffectEchoDesLabel.text = AMLocalizedString(@"Tiếng vang tạo độ dày và sự hòa quyện", nil);
        self.karaokeEffectBassDesLabel.text = AMLocalizedString(@"Âm trầm tăng giảm sự trầm ấm của giọng hát", nil);
        self.karaokeEffectTrebleDesLabel.text = AMLocalizedString(@"Âm bổng sự trong sáng và sắc bén", nil);
        self.saveRecordMenuSubViewLabel1.text = AMLocalizedString(@"Tiếp tục thu", nil);
        self.saveRecordMenuSubViewLabel2.text = AMLocalizedString(@"Lưu lại", nil);
        self.saveRecordMenuSubViewLabel3.text = AMLocalizedString(@"Thu lại", nil);
        self.saveRecordMenuSubViewLabel4.text = AMLocalizedString(@"Thoát", nil);
        self.finishRecordSubViewDiemLabel.text = AMLocalizedString(@"Điểm", nil);
        self.finishViewLabel.text = AMLocalizedString(@"Bạn có muốn lưu bài thu?", nil);
        [self.finishViewHuyButton setTitle:AMLocalizedString(@"Hủy", nil) forState:UIControlStateNormal];
        [self.finishViewNoButton setTitle:AMLocalizedString(@"Không", nil) forState:UIControlStateNormal];
        [self.finishViewYesButton setTitle:AMLocalizedString(@"Có", nil) forState:UIControlStateNormal];
        [self.finishViewChangePlaylistYesButton setTitle:AMLocalizedString(@"Có", nil) forState:UIControlStateNormal];
        [self.finishViewChangePlaylistNoButton setTitle:AMLocalizedString(@"Không", nil) forState:UIControlStateNormal];
        self.onOffPlaythroughLabel.text = AMLocalizedString(@"Nghe trực tiếp", nil);
        self.XulyButton.hidden=YES;
        if (isrecord && VipMember) {
           
            [NSThread detachNewThreadSelector:@selector(createSilentPCMFileWithDuration:) toTarget:self withObject:[NSNumber numberWithInt:60*8*8]];
        }
        if (playRecord) {
            [self.loiChamButton setTitle:AMLocalizedString(@"Lời Chậm", nil) forState:UIControlStateNormal];
            [self.loiNhanhButton setTitle:AMLocalizedString(@"Lời Nhanh", nil) forState:UIControlStateNormal];
            //[movieTimeControl setMinimumTrackTintColor:UIColorFromRGB(ColorSlider)];
            CGRect frameHeader=self.headerView.frame;
            frameHeader.size.height=45;
            self.headerView.frame=frameHeader;
            [self hideAllXulySubView];
            self.xulyViewVolumeView.hidden=NO;
            self.XulyButton.hidden=NO;
            /*self.rulerVolumeV.layer.borderColor=[[UIColor brownColor] CGColor];
            
            self.rulerVolumeV.layer.borderWidth=1;
            self.rulerVolumeV.layer.cornerRadius=2;
            self.rulerVolumeV.layer.masksToBounds=YES;*/
            self.rulerVolumeImage.hidden=YES;
            CGRect frameV=self.rulerVolumeV.frame;
            CGRect frameV2=self.rulerVolume100Mark.frame;
            CGRect frameV3=self.volumeMusic100Mark.frame;
            CGRect frameV4=self.volumeVocal100Mark.frame;
            frameV2.origin.x=frameV.origin.x+(frameV.size.width*1/1.5);
            frameV3.origin.x=frameV2.origin.x;
            frameV4.origin.x=frameV2.origin.x;
            self.volumeMusic100Mark.frame=frameV3;
            self.volumeVocal100Mark.frame=frameV4;
            self.rulerVolume100Mark.frame=frameV2;
            CGRect frame=self.rulerVolumeV.frame;
            CGRect frame2=self.rulerVolumeView.frame;
            float max=1;
            maxV=MAX(max, maxV);
            
            
            
            frame2.origin.x=frame.origin.x+1+(frame.size.width*max/1.5);
            frame2.size.width=frame.size.width-(frame.size.width*max/1.5)-1;
            self.rulerVolumeView.frame=frame2;
            self.xulyViewLechNhipLoiChamButton.layer.cornerRadius=14;
            self.xulyViewLechNhipLoiChamButton.layer.masksToBounds=YES;
            self.xulyViewLechNhipLoiNhanhButton.layer.cornerRadius=14;
            self.xulyViewLechNhipLoiNhanhButton.layer.masksToBounds=YES;
            NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:AMLocalizedString(@"Hát lệch nhịp?", nil)];
            [attString2 addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                               range:(NSRange){0,attString2.length}];
            [attString2 addAttribute:NSForegroundColorAttributeName
                               value:UIColorFromRGB(0x9A99A9)
                               range:(NSRange){0,attString2.length}];
            self.xulyViewVolumeLechNhipLabel.attributedText=attString2;
            self.titleName.hidden=NO;
        }else{
            self.titleName.hidden=YES;
        }
        if (isrecord && [songRec.performanceType isEqualToString:@"SOLO"]) {
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
            //self.progressBuffer.transform = transform;
            //CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
            //movieTimeControl.transform = transform;
        }
        
        self.microEchoSlider.maximumValue=100;
        self.microEchoSlider.minimumValue=0;
        
        if ([songRec.performanceType isEqualToString:@"DUET"] && !playRecord && videoRecord) {
            self.duetVideoLayer.layer.cornerRadius=5;
            self.duetVideoLayer.layer.borderColor=[[UIColor whiteColor] CGColor];
            
            self.duetVideoLayer.layer.borderWidth=1;
            self.duetVideoLayer.layer.masksToBounds=YES;
        }
        if (isrecord) {
            self.startRecordView.hidden=NO;
            self.startRecordView.delegate = self;
            self.startRecordView.center=self.view.center;
            self.isLoading.center=self.view.center;
            self.startRecordView.timerLabelHidden=NO;
            self.startRecordView.timerLabel.textColor=[UIColor whiteColor];
            [self.startRecordView.timerLabel setFont:[UIFont systemFontOfSize:50 weight:UIFontWeightBold]];
            self.startRecordView.circleBackgroundColor=UIColorFromRGB(HeaderColor);
            self.startRecordView.circleColor=[UIColor whiteColor];
             [self.startRecordView startWithSeconds:3];
           /* __weak typeof(self) weakSelf = self;
            self.startRecordView.progressChanged =  ^(CircularProgressView *progressView, CGFloat progress) {
                __strong typeof(self) self = weakSelf;
                self.startRecordTime.text = [NSString stringWithFormat:@"%ld", round((1-progress)*3)];
            };*/
        }
        self.timeplay.text=@"00:00";
        self.timeDuration.text=@"00:00";
        streamSV=streamServer;
        if (streamSV.length==0) {
            streamSV=@"data.ikara.co";
        }
        [self addTapSlider];
        if (isrecord ) {
            [self.movieTimeControl setThumbTintColor:[UIColor clearColor]];
            [movieTimeControl setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        }
        if (playRecord) {
            if (playVideoRecorded) {
                NSLog(@"play video record");
            }else{
                NSLog(@"play audio record");
            }
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                NSLog(@"play duet record");
            }
        }
        self.playButt.layer.cornerRadius=self.playButt.frame.size.height/2;
        self.playButt.layer.borderWidth=1;
        self.playButt.layer.borderColor=[[UIColor whiteColor] CGColor];
        self.playButt.layer.masksToBounds=YES;
        self.pauseBtt.layer.cornerRadius=self.pauseBtt.frame.size.height/2;
        self.pauseBtt.layer.borderWidth=1;
        self.pauseBtt.layer.borderColor=[[UIColor whiteColor] CGColor];
        self.pauseBtt.layer.masksToBounds=YES;
       
        
        [self.xulyViewEffectCollectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell2" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
        [self.xulyMenuToolbarCollectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
        //self.colectionView.backgroundColor=[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.8];
        self.xulyViewEffectCollectionView.delegate=self;
        self.xulyViewEffectCollectionView.dataSource=self;
        self.xulyMenuToolbarCollectionView.delegate=self;
        self.xulyMenuToolbarCollectionView.dataSource=self;
        self.saveRecordView.hidden=YES;
        [self.view bringSubviewToFront:self.saveRecordView];
        isRecorded=NO;
         [self.editButt removeFromSuperview];
        if (videoRecord && isrecord) {
            [self checkDeviceAuthorizationStatus];
        }
        if (!playRecord) {
            if (videoRecord) {
                self.playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16);
            }else{
                self.playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
        }else{
            
            [self.xulyViewDenoiseEffectCollectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell4" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
            self.xulyViewDenoiseEffectCollectionView.delegate=self;
            self.xulyViewDenoiseEffectCollectionView.dataSource=self;
            [self.xulyViewChangeVoiceEffectCollectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell4" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
            self.xulyViewChangeVoiceEffectCollectionView.delegate=self;
            self.xulyViewChangeVoiceEffectCollectionView.dataSource=self;
            [self.xulyViewAutotuneEffectCollectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell4" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
            self.xulyViewAutotuneEffectCollectionView.delegate=self;
            self.xulyViewAutotuneEffectCollectionView.dataSource=self;
            if (self.view.frame.size.height>570){
            self.playerLayerView.frame=CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
            //self.headerView.backgroundColor=UIColorFromRGB(0x333333);
            self.xulyView.frame=CGRectMake(0,self.playerLayerView.frame.size.height+self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.playerLayerView.frame.size.height-self.headerView.frame.size.height);
            }else {
                self.playerLayerView.frame=CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width*9/16);
                    //self.headerView.backgroundColor=UIColorFromRGB(0x333333);
                self.xulyView.frame=CGRectMake(0,self.playerLayerView.frame.size.height+self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.playerLayerView.frame.size.height-self.headerView.frame.size.height);
            }
           /* CGRect xulyviewframe=self.xulyViewEffectCollectionView.frame;
            xulyviewframe.origin.y=self.xulyviewEffectLineView.frame.origin.y+5;
            xulyviewframe.size.height=285;
            self.xulyViewEffectCollectionView.frame=xulyviewframe;*/
            //self.xulyViewEffectView.contentSize=CGSizeMake(self.view.frame.size.width, self.xulyViewEffectCollectionView.fôtrame.origin.y+self.xulyViewEffectCollectionView.frame.size.height);
            self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
          
            /*if (VipMember){
                self.editViewDelaySubview.hidden=YES;
            }else{*/
            
            //}
            //stream player
            self.xulyviewEffectLineView.layer.cornerRadius=5;
            self.xulyviewEffectLineView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
            self.xulyviewEffectLineView.layer.borderWidth=1;
            self.xulyviewEffectLineView.layer.masksToBounds=YES;
            UITapGestureRecognizer *tap19 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(hideToolbar)];
            [self.loadingViewVIP addGestureRecognizer:tap19];
        }
        
        NSDictionary *playerVars = @{
                                     @"controls" : @0,
                                     @"playsinline" : @1,
                                     @"autohide" : @1,
                                     @"iv_load_policy" : @3,
                                     @"modestbranding" : @1,
                                     @"fs":@0
                                     
                                     };
        if (!playRecord) {
              self.editBackgroundImage.hidden=YES;
        }
        if ([Language hasSuffix:@"kara"] && isrecord && ![songRec.performanceType isEqualToString:@"DUET"] && NO){
          
            self.volumeMusic.hidden=YES;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receivedPlaybackStartedNotification:)
                                                         name:@"Playback started"
                                                       object:nil];
            
            
            if (videoRecord ||playRecord) {
                youtubePlayer=[[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16)];
                playerLayerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16);
                CGRect frame=_duetUserView.frame;
                frame.origin.x=0;
                frame.origin.y=youtubePlayer.frame.size.height;
                _duetUserView.frame=frame;
            }else{
                youtubePlayer=[[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                CGRect frame=_duetUserView.frame;
                if (videoRecord) {
                    frame.origin.y=youtubePlayer.frame.size.height;
                }else{
                     frame.origin.y=_headerView.frame.size.height;
                }

                frame.origin.x=0;
                _duetUserView.frame=frame;
                playerLayerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
            
            youtubePlayer.backgroundColor=[UIColor blackColor];
            self.view.backgroundColor=[UIColor blackColor];

                if (self.view.frame.size.width+playerLayerView.frame.size.height+60>self.view.frame.size.height) {
                    self.previewView.frame=CGRectMake(0, youtubePlayer.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-playerLayerView.frame.size.height-60);
                }else
                    self.previewView.frame=CGRectMake(0, youtubePlayer.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);

            //self.previewView.center=CGPointMake(self.view.frame.size.width/2,( self.view.frame.size.height-youtubePlayer.frame.size.height)/2);
            youtubePlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
           [self.view insertSubview:youtubePlayer atIndex:1];
            self.playerLayerView.hidden=YES;
            self.editScrollView.backgroundColor=[UIColor clearColor];
            youtubePlayer.delegate=self;
          
        }else{

            self.volumeMusic.hidden=NO;
            if (self.view.frame.size.width+playerLayerView.frame.size.height+60>self.view.frame.size.height) {
                self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-playerLayerView.frame.size.height-60);
            }else
                self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
            
            CGRect frame=_duetUserView.frame;
            if (videoRecord || songRec.mixedRecordingVideoUrl.length>10) {
                frame.origin.y=playerLayerView.frame.size.height;
            }else{
                 frame.origin.y=_headerView.frame.size.height;
            }
            
            frame.origin.x=0;
            _duetUserView.frame=frame;
        }
        
        if (([songRec.performanceType isEqualToString:@"DUET"]|| [songRec.performanceType isEqualToString:@"ASK4DUET"])  ){
            self.duetLyricView.hidden=NO;
            
            self.progressBuffer.hidden=YES;
            self.userImage1.frame=CGRectMake(20, 20, 60, 60);
            self.userImage2.frame=CGRectMake(70, 20, 60, 60);
            if (!playRecord) {
                 self.duetUserView.hidden=NO;
            }else{
                 self.duetUserView.hidden=YES;
            }
            [self.userImage1 sd_setImageWithURL:[NSURL URLWithString:currentFbUser.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            [self.userImage2 sd_setImageWithURL:[NSURL URLWithString:songRec.owner2.profileImageLink ] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            self.userImage1.layer.cornerRadius=self.userImage1.frame.size.width/2;
            self.userImage2.layer.cornerRadius=self.userImage2.frame.size.width/2;
            self.userImage1.layer.borderWidth=1;
            self.userImage1.layer.borderColor=[[UIColor whiteColor] CGColor];
            self.userImage2.layer.borderWidth=1;
            self.userImage2.layer.borderColor=[[UIColor whiteColor] CGColor];
            self.userImage1.layer.masksToBounds=YES;
            self.userImage2.layer.masksToBounds=YES;
            
            NSString* gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
            if (gender.length==0) {
                
                genderColor=namColor;
            }else if ([gender isEqualToString:@"male"]){
                
                genderColor=namColor;
            }else{
                
                genderColor=nuColor;
            }
            meSingThumbImage=[self createThumbImage:12 andColor:genderColor];
            otherSingThumbImage=[self createThumbImage:12 andColor:[UIColor whiteColor]];
            duetSingThumbImage=[self createThumbImage:12 andColor:songCaColor];
        }else {
            self.duetLyricView.hidden=YES;
            self.duetUserView.hidden=YES;
        }
        if (isrecord) {
            if ([songRec.thumbnailImageUrl isKindOfClass:[NSString class]]) {
                [self.saveRecordMenuThumbnailImage sd_setImageWithURL:[NSURL URLWithString: songRec.thumbnailImageUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            }else{
               
                    [self.saveRecordMenuThumbnailImage sd_setImageWithURL:[NSURL URLWithString: songRec.song.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                }
            self.saveRecordMenuSongName.text=[NSString stringWithFormat:@"%@",songRec.song.songName];
        }
         /*
            controllerRecord = [[DemoTableController alloc] init];
            
            controllerRecord.array=[NSMutableArray arrayWithObjects:AMLocalizedString(@"Tiếp tục thu",nil),AMLocalizedString(@"Lưu lại",nil),AMLocalizedString(@"Thu lại",nil),AMLocalizedString(@"Thoát",nil), nil];
            controllerRecord.arrayImage=[NSMutableArray arrayWithObjects:@"ic_continue.png",@"ic_download.png",@"ic_restart.png",@"ic_topbar_close_red.png", nil];
            
            controllerRecord.title=@"";
            controllerRecord.delegate = self;
            //controllerRecord.view.center=self.view.center;
            controllerRecord.view.layer.cornerRadius=5;
            controllerRecord.view.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
            controllerRecord.view.layer.masksToBounds=YES;
            controllerRecord.view.backgroundColor=[UIColor whiteColor];
            [controllerRecord.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-8, (controllerRecord.array.count)*50)];
            //  [self.saveRecordView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            controllerRecord.tableView.alwaysBounceVertical=NO;
            controllerRecord.view.center=self.saveRecordView.center;
            [self.saveRecordView addSubview:controllerRecord.view];
            //*/
        
        recordStated=NO;
        [self checkHeadSet];
        if (!playRecord) {
            
           
            if (audioEngine2.audioController.running==NO) {
                
                if (audioEngine2.audioController.running==NO) {
                    NSError* error;
                    
                    [audioEngine2.audioController start:&error];
                }
                
            }
        }
        
        //  NSLog(@"video %@", [AVCaptureDevice devices]);
        
        
        self.xulyViewBG.layer.cornerRadius=4;
        self.xulyViewBG.layer.masksToBounds=YES;
        self.effectViewBG.layer.cornerRadius=4;
        self.effectViewBG.layer.masksToBounds=YES;
        [self.xulyViewBG.layer setBorderColor:[UIColorFromRGB(HeaderColor) CGColor]];
        [self.xulyViewBG.layer setBorderWidth:1];
        [self.effectViewBG.layer setBorderColor:[UIColorFromRGB(HeaderColor) CGColor]];
        [self.effectViewBG.layer setBorderWidth:1];
        [self.effectViewButton setBackgroundColor:[UIColor clearColor]];
        [self.editMoreButton setBackgroundColor:[UIColor clearColor]];
        // UIImage *originalImage= self.movieTimeControl.currentThumbImage;
        // UIImage *scaledImage =
        //[UIImage imageWithCGImage:[originalImage CGImage]           scale:(originalImage.scale * 2.0)  orientation:(originalImage.imageOrientation)];
        self.startRecordTime.layer.borderColor=[[UIColor whiteColor] CGColor];
        self.startRecordTime.layer.borderWidth=3;
        self.startRecordTime.layer.cornerRadius=self.startRecordTime.frame.size.width/2;
        self.startRecordTime.layer.masksToBounds=YES;
        //[self.movieTimeControl setThumbTintColor:UIColorFromRGB(HeaderColor)];
        // NSLog(@"%@", thumbImage.size);
        //[self.movieTimeControl setThumbImage:[UIImage imageNamed:@"hinh_hinh_hinh_hinh_hinh_thumb.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        if ([songRec.performanceType isEqualToString:@"SOLO"] || (!playRecord && !isrecord)){
            self.editButt.hidden=NO;
        }else{
            self.editButt.hidden=YES;
            
        }
        if ([songRec.performanceType isEqualToString:@"DUET"] && songRec.mixedRecordingVideoUrl.length>10 && playRecord) {
            self.duetVideoLayer.hidden=NO;
            
             [NSThread detachNewThreadSelector:@selector(loadDuetVideo:) toTarget:self withObject:songRec.mixedRecordingVideoUrl];
            
        }else{
            self.duetVideoLayer.hidden=YES;
        }
        self.editScrollView.hidden=NO;
        if (playRecord) {
            if (self.view.frame.size.width>320) {
                //  [self animateButton];
                //  buttonTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animateButton) userInfo:nil repeats:YES];
            }
            
            self.xulyButt.layer.cornerRadius=4;
            self.xulyButt.layer.masksToBounds=YES;
            
            //self.xulyButt.layer.borderWidth = 5;
            // self.xulyButt.layer.borderColor=[[UIColor colorWithRed:5/255.0 green:5/255.0 blue:5/255.0 alpha:0.1] CGColor];
            //   [self.xulyButt.layer addAnimation:border forKey:@"border"];
            self.bgViewWhenEditVideo.hidden=NO;
            self.editButt.hidden=NO;
            [self.editButt setImage:[UIImage imageNamed:@"icn_delete.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
            //
            
            CGRect frameSlider=self.movieTimeControl.frame;
            frameSlider.origin.x=-1;
            frameSlider.size.width=self.view.frame.size.width+2;
            frameSlider.origin.y=self.toolBar.frame.size.height-37;
            self.movieTimeControl.frame=frameSlider;
            
            CGRect frameProcessBuffer=self.progressBuffer.frame;
            frameProcessBuffer.origin.x=2;
            frameProcessBuffer.size.width=self.view.frame.size.width;
            frameProcessBuffer.size.height=4;
            frameProcessBuffer.origin.y=frameSlider.origin.y+14;
            //self.progressBuffer.frame=frameProcessBuffer;
            CGRect frameProcessBuffer2=self.playButt.frame;
            frameProcessBuffer2.origin.y=frameProcessBuffer2.origin.y-23;
            self.playButt.frame=frameProcessBuffer2;
            CGRect frameProcessBuffer3=self.pauseBtt.frame;
            frameProcessBuffer3.origin.y=frameProcessBuffer3.origin.y-23;
            self.pauseBtt.frame=frameProcessBuffer3;
            CGRect frameProcessBuffer4=self.timeDuration.frame;
            frameProcessBuffer4.origin.y=frameProcessBuffer4.origin.y-23;
            self.timeDuration.frame=frameProcessBuffer4;
            CGRect frameProcessBuffer5=self.timeplay.frame;
            frameProcessBuffer5.origin.y=frameProcessBuffer5.origin.y-23;
            self.timeplay.frame=frameProcessBuffer5;
            if (playVideoRecorded && ![songRec->hasUpload isEqualToString:@"YES"]) {
                
                
                /*
                 self.editViewButton.frame=CGRectMake(0,self.effectView.frame.origin.y+self.effectView.frame.size.height, self.view.frame.size.width , 60);
                 self.editViewButton.layer.masksToBounds=YES;
                 self.effectView.hidden=NO;
                 self.effectView.frame=CGRectMake(0, self.xulyView.frame.size.height+self.xulyView.frame.origin.y, self.view.frame.size.width, 40);
                 self.effectView.layer.masksToBounds=YES;
                 self.xulyView.frame=CGRectMake(0,self.toolBar.frame.origin.y+ self.toolBar.frame.size.height, self.view.frame.size.width, 40);
                 self.xulyView.layer.masksToBounds=YES;
                 self.toolBar.frame=CGRectMake(0,self.toolBar.frame.origin.y+ self.toolBar.frame.size.height, self.view.frame.size.width, 40);
                 self.toolBar.layer.masksToBounds=YES;*/
                self.editViewButton.frame=CGRectMake(0,self.view.frame.size.height-70, self.view.frame.size.width , 70);
                self.editViewButton.layer.masksToBounds=YES;
                self.effectView.hidden=YES;
                /*if (self.view.frame.size.height>600) {
                 self.effectView.frame=CGRectMake(0, self.view.frame.size.height-self.editViewButton.frame.size.height-137, self.view.frame.size.width, 137);
                 self.colectionView.hidden=NO;
                 }else{
                 self.effectView.frame=CGRectMake(0, self.view.frame.size.height-self.editViewButton.frame.size.height-40, self.view.frame.size.width, 40);
                 }*/
                self.effectView.layer.masksToBounds=YES;
                //self.xulyView.frame=CGRectMake(0, self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height, self.view.frame.size.width, self.xulyView.frame.size.height);
                self.xulyView.layer.masksToBounds=YES;
                // self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
                self.toolBar.layer.masksToBounds=YES;
                // self.editScrollView.layer.masksToBounds=YES;
                
                self.playerLayerViewRec.frame=CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width );
                if ([songRec.performanceType isEqualToString:@"DUET"] && [songRec.song.songUrl hasSuffix:@"mp4"]) {
                    self.playerLayerViewRec.frame=CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width/2,  self.view.frame.size.width);
                    /*if (VipMember && playRecord) {
                        self.duetVideoLayer.frame=CGRectMake(0,0, self.view.frame.size.width,  self.view.frame.size.width/16*9);
                    }else*/
                        self.duetVideoLayer.frame=CGRectMake(self.view.frame.size.width/2,self.headerView.frame.size.height, self.view.frame.size.width/2,  self.view.frame.size.width);
                }
                self.editScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.xulyView.frame.size.height+self.editViewButton.frame.size.height+self.playerLayerViewRec.frame.size.height);
                
            }else{
                /*
                 self.xulyView.frame=CGRectMake(0,self.toolBar.frame.origin.y+ self.toolBar.frame.size.height, self.view.frame.size.width, 40);
                 self.effectView.hidden=YES;
                 self.effectView.frame=CGRectMake(0, self.xulyView.frame.size.height+self.xulyView.frame.origin.y, self.view.frame.size.width, 0);
                 self.editViewButton.frame=CGRectMake(0,self.effectView.frame.origin.y+self.effectView.frame.size.height, self.view.frame.size.width , 60);
                 */
                self.editViewButton.frame=CGRectMake(0,self.view.frame.size.height-70, self.view.frame.size.width , 70);
                self.editViewButton.layer.masksToBounds=YES;
                self.effectView.hidden=YES;
                self.effectView.frame=CGRectMake(0, self.view.frame.size.height-self.editViewButton.frame.size.height, self.view.frame.size.width, 0);
                self.effectView.layer.masksToBounds=YES;
                /*if (self.view.frame.size.height>600) {
                 
                 self.xulyView.frame=CGRectMake(0,self.view.frame.size.width*3/4, self.view.frame.size.width, self.view.frame.size.height-self.editViewButton.frame.size.height-self.view.frame.size.width*3/4);
                 self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
                 }else{
                 self.xulyView.frame=CGRectMake(0, self.view.frame.size.height-self.editViewButton.frame.size.height-self.effectView.frame.size.height-230, self.view.frame.size.width, 230);
                 }*/
                
                self.xulyView.layer.masksToBounds=YES;
                // self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
                self.toolBar.layer.masksToBounds=YES;
                self.playerLayerViewRec.frame=CGRectMake(0,  self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
                if ([songRec.performanceType isEqualToString:@"DUET"] && [songRec.song.songUrl hasSuffix:@"mp4"]) {
                    if (playVideoRecorded ){
                        self.playerLayerViewRec.frame=CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width/2,  self.view.frame.size.width);
                        self.duetVideoLayer.frame=CGRectMake(self.view.frame.size.width/2,self.headerView.frame.size.height, self.view.frame.size.width/2,  self.view.frame.size.width);
                    }else{
                        self.duetVideoLayer.frame=CGRectMake(0,self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
                        self.duetVideoLayer.layer.masksToBounds=YES;
                    }
                }else{
                    self.duetVideoLayer.hidden=YES;
                }
                self.editScrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.xulyView.frame.size.height+self.editViewButton.frame.size.height+self.playerLayerViewRec.frame.size.height);
                
            }
            if (iOSVersion >= 8.0f && playRecord)
            {
                if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    CGRect fram=CGRectMake(0,self.headerView.frame.size.height , self.view.frame.size.width, self.view.frame.size.width);

                    // fram.size.height=self.editScrollView.contentSize.height;
                    blurEffectView.frame = fram;
                    blurEffectView.alpha=0.8;
                    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    //[cell.thumnailView insertSubview:blurEffectView belowSubview:cell.likeCmtView];
                    // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
                    // cell.likeCmtView=blurEffectView;
                  
                        [self.editScrollView insertSubview:blurEffectView atIndex:1];
                    //self.backgroundImage.frame=CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height);
                    self.editBackgroundImage.image=[UIImage imageNamed:@"bgMo2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    /*if ([songRec.thumbnailImageUrl isKindOfClass:[NSString class]]) {
                        [self.editBackgroundImage sd_setImageWithURL:[NSURL URLWithString: songRec.thumbnailImageUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    }else{
                        if ([songRec.song.thumbnailUrl isKindOfClass:[NSString class]]) {
                             [self.editBackgroundImage sd_setImageWithURL:[NSURL URLWithString: songRec.song.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        }else{
                            self.editBackgroundImage.image=[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }
                       
                    }*/
                    self.playerLayerViewRec.hidden=YES;
                    
                    // [blurEffectView addGestureRecognizer:tap19];
                    //cell.likeCmtView.backgroundColor=[UIColor clearColor];
                }
            }
            
            // self.toolBar.frame=CGRectMake(0, self.view.frame.size.height-self.toolBar.frame.size.height-self.editScrollView.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
        }else{
            UITapGestureRecognizer *tap119 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(hideToolbar)];
            // [self.editScrollView addGestureRecognizer:tap119];
            self.editScrollView.backgroundColor=[UIColor clearColor];
            CGRect frameEdit=self.toolBar.frame;
            frameEdit.origin.y=self.view.frame.size.height-self.toolBar.frame.size.height;
            self.toolBar.frame=frameEdit;
            self.effectView.hidden=YES;
            self.editViewButton.hidden=YES;
            self.xulyView.hidden=YES;
        }
        if (isrecord && videoRecord) {
            self.bgViewWhenEditVideo.hidden=NO;
            [self.bgViewWhenEditVideo removeFromSuperview];
            UITapGestureRecognizer *tap119 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(hideToolbar)];
            // [self.bgViewWhenEditVideo addGestureRecognizer:tap119];
            // self.editButt.hidden=YES;
            float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
            if (iOSVersion >= 8.0f )
            {
                if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    blurEffectView.frame = self.view.frame;
                    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    //[cell.thumnailView insertSubview:blurEffectView belowSubview:cell.likeCmtView];
                    // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
                    // cell.likeCmtView=blurEffectView;
                    //[self.view insertSubview:blurEffectView atIndex:1];
                    UITapGestureRecognizer *tap19 = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(hideToolbar)];
                    // [blurEffectView addGestureRecognizer:tap19];
                    //cell.likeCmtView.backgroundColor=[UIColor clearColor];
                }
            }
            
        }
        if (isrecord){
            self.recordToolbar.hidden=NO;
            
            
            //[self.pauseBtt setBackgroundImage:[UIImage imageNamed:@"thu_am.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            // [self.playButt setBackgroundImage:[UIImage imageNamed:@"thu_am.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            CGRect frameToolbar=self.toolBar.frame;
            
            
            if (videoRecord) {
                if ([songRec.performanceType isEqualToString:@"DUET"]){
                    frameToolbar.origin.y=self.playerLayerView.frame.size.height-self.toolBar.frame.size.height;
                }else
                    frameToolbar.origin.y=playerLayerView.frame.size.height-self.toolBar.frame.size.height;
            }else{
                
                frameToolbar.origin.y=self.view.frame.size.height-self.toolBar.frame.size.height-self.recordToolbar.frame.size.height;
            }
            
            if (videoRecord) {
               
                int y=self.previewView.frame.origin.y+self.previewView.frame.size.height;
                    self.recordToolbar.frame=CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y);
               
            }else{
                
               self.recordToolbar.frame=CGRectMake(0, self.view.frame.size.height-90, self.view.frame.size.width, 80);
            }
            
           
            self.toolBar.backgroundColor=[UIColor clearColor];
            self.toolBar.frame=frameToolbar;
            CGRect frameSlider=self.movieTimeControl.frame;
            if ([songRec.performanceType isEqualToString:@"SOLO"] && NO) {
                frameSlider.origin.x=-2;
                frameSlider.size.width=self.view.frame.size.width+4;
                frameSlider.origin.y=self.toolBar.frame.size.height-frameSlider.size.height*0.5;
            }else{
                frameSlider.origin.x=-2;
                frameSlider.size.width=self.view.frame.size.width+4;
                //frameSlider.size.height = 33;
                frameSlider.origin.y=-frameSlider.size.height*0.5-2;
                self.progressBuffer.hidden = YES;
                [self.recordToolbar insertSubview:self.progressBuffer atIndex:0];
                [self.recordToolbar insertSubview:self.duetLyricView atIndex:1];
                [self.recordToolbar insertSubview:movieTimeControl atIndex:2];
                
                self.duetLyricView.center=movieTimeControl.center;
            }
            
            [self.recordToolbar addSubview:self.playButt];
            [self.recordToolbar addSubview:self.pauseBtt];
            
            self.playButt.center=CGPointMake(self.recordToolbar.frame.size.width/2, self.recordToolbar.frame.size.height/2);
            self.pauseBtt.center=self.playButt.center;
            self.recordAlertImage.center=self.playButt.center;
            
            
            self.movieTimeControl.frame=frameSlider;
            CGRect frameProcessBuffer=self.progressBuffer.frame;
            frameProcessBuffer.origin.x=-1;
            frameProcessBuffer.size.width=self.view.frame.size.width+2;
            frameProcessBuffer.size.height = 2;
            frameProcessBuffer.origin.y=frameSlider.origin.y+14;
            self.progressBuffer.frame=frameProcessBuffer;
            if (!videoRecord || YES) {
                [self.recordToolbar addSubview:self.timeplay];
                [self.recordToolbar addSubview:self.timeDuration];
                CGPoint frameProcessBuffer4=self.timeDuration.center;
                frameProcessBuffer4.y=self.recordToolbar.frame.size.height/2;
                self.timeDuration.center=frameProcessBuffer4;
                CGPoint frameProcessBuffer5=self.timeplay.center;
                frameProcessBuffer5.y=self.recordToolbar.frame.size.height/2;
                self.timeplay.center=frameProcessBuffer5;
                self.progressBuffer.center=self.movieTimeControl.center;
            }else{
                CGRect frameProcessBuffer4=self.timeDuration.frame;
                frameProcessBuffer4.origin.y=frameProcessBuffer4.origin.y+10;
                self.timeDuration.frame=frameProcessBuffer4;
                CGRect frameProcessBuffer5=self.timeplay.frame;
                frameProcessBuffer5.origin.y=frameProcessBuffer5.origin.y+10;
                self.timeplay.frame=frameProcessBuffer5;
            }
            self.recordToolbarReRecordButton.center=CGPointMake(self.view.frame.size.width/4+10, self.recordToolbarVoiceButton.center.y);
            self.recordToolbarVoiceButton.center=CGPointMake(self.view.frame.size.width/4*3-10, self.recordToolbarVoiceButton.center.y);
            self.recordImage.center=CGPointMake(self.view.frame.size.width/4-20, self.recordToolbarVoiceButton.center.y);
            self.recordToolbarVoiceVolumeSlider.value=[audioEngine2 getPlaythroughVolume];
            self.microVolumeView.frame=CGRectMake(10, self.recordToolbar.frame.origin.y-self.microVolumeView.frame.size.height-10, self.recordToolbar.frame.size.width-20, self.microVolumeView.frame.size.height);
            self.onOffPlaythroughView.frame=CGRectMake(self.onOffPlaythroughView.frame.origin.x, self.recordToolbar.frame.origin.y-self.onOffPlaythroughView.frame.size.height-10, self.onOffPlaythroughView.frame.size.width, self.onOffPlaythroughView.frame.size.height);
            self.onOffPlaythroughView.layer.cornerRadius=6;
            self.onOffPlaythroughView.layer.masksToBounds=YES;
            self.microVolumeView.layer.cornerRadius=6;
            self.microVolumeView.layer.masksToBounds=YES;
            //self.onOffPlaythroughSwitch.frame=CGRectMake(self.onOffPlaythroughSwitch.frame.origin.x, self.onOffPlaythroughSwitch.frame.origin.y+self.onOffPlaythroughSwitch.frame.size.height/4, self.onOffPlaythroughSwitch.frame.size.width, self.onOffPlaythroughSwitch.frame.size.height/2);
            //self.recordToolbarVoiceVolumeSlider.center=CGPointMake(self.recordToolbarVoiceButton.center.x, self.recordToolbar.frame.origin.y-self.recordToolbarVoiceVolumeSlider.frame.size.width/2);
            //self.recordToolbarVoiceVolumeSlider.transform=CGAffineTransformRotate(self.recordToolbarVoiceVolumeSlider.transform,270.0/180*M_PI);
            self.duetLyricView.center=self.movieTimeControl.center;
        }
        else{
            self.recordToolbar.hidden=YES;
        }
        self.loiChamButton.layer.cornerRadius=5;
        self.loiChamButton.layer.masksToBounds=YES;
        self.finishRecordSubview.layer.cornerRadius=5;
        self.finishRecordSubview.layer.masksToBounds=YES;
        self.finishViewNoButton.layer.cornerRadius=self.finishViewNoButton.frame.size.height/2;
        self.finishViewNoButton.layer.masksToBounds=YES;
        self.finishViewYesButton.layer.cornerRadius=self.finishViewYesButton.frame.size.height/2;
        self.finishViewYesButton.layer.masksToBounds=YES;
        self.loiNhanhButton.layer.cornerRadius=5;
        self.loiNhanhButton.layer.masksToBounds=YES;
        self.xulyButton.layer.cornerRadius=5;
        self.xulyButton.layer.masksToBounds=YES;
        self.uploadViewXulyButton.layer.cornerRadius=5;
        self.uploadViewXulyButton.layer.masksToBounds=YES;
        self.uploadViewHuyButton.layer.cornerRadius=5;
        self.uploadViewHuyButton.layer.masksToBounds=YES;
        self.finishViewNoButton.layer.cornerRadius=5;
        self.finishViewNoButton.layer.masksToBounds=YES;
        self.finishViewYesButton.layer.cornerRadius=5;
        self.finishViewYesButton.layer.masksToBounds=YES;
        self.finishViewHuyButton.layer.cornerRadius=5;
        self.finishViewHuyButton.layer.masksToBounds=YES;
        DuetPreviewViewFrame=self.previewView.frame;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(homePress)
                                                     name:@"homePress" object:nil];
        
        self.privacyLabelButton.text=NSLocalizedString(@"Chế độ công khai", nil);
        privacyRecordingisPrivate=[[NSUserDefaults standardUserDefaults] boolForKey:@"privacyRecordingisPrivate"];
        if (!privacyRecordingisPrivate) {
            self.privacyTickerImage.image=[UIImage imageNamed:@"da_check.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }else{
            self.privacyTickerImage.image=[UIImage imageNamed:@"khong_checked.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }
        
        if (videoRecord){
            
            //[self initializeMotionManager];
        }
        if (isrecord) {
            // self.startRecordView.hidden=NO;
            startRecordDem=3;
            self.startRecordTime.text=[NSString stringWithFormat:@"%d",startRecordDem];
        }else{
            startRecordDem=0;
            self.startRecordView.hidden=YES;
        }
        isTabKaraoke=YES;
        float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
        if (iOSVersion >= 8.0f )
        {
            if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                blurEffectView.frame = self.colectionView.bounds;
                blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
                // [self.colectionView insertSubview:blurEffectView atIndex:0];
            }
        }
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            NSLog(@"Landscape");
        }
        videoQualityList=[[NSArray alloc] initWithObjects:@"small",@"medium",@"hd720", nil];
        [super viewDidLoad];
        // [self destroy];
        if(isrecord){
            demQuangCao=1;
        }
        
        if (isrecord && videoRecord ){
            
            //    self.fullScreenButton.hidden=NO;
            [self setVideoRec];
            self.previewView.hidden=NO;
            self.fullScreenVideoPrivewButton.hidden=NO;
            
        }
        else{
            self.previewView.hidden=YES;
            self.fullScreenVideoPrivewButton.hidden=YES;
        }
        
        // if(VipMember){
        //   UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        // UIVisualEffectView * viewWithBlurredBackground =    [[UIVisualEffectView alloc] initWithEffect:effect];
        self.markImage1.hidden=YES;
        self.markImage2.hidden=YES;
        self.markLabel.hidden=NO;
        /* }else{
         self.markImage1.hidden=NO;
         self.markImage2.hidden=NO;
         self.markLabel.hidden=YES;
         }*/
        menuSelected = 0;
        isFavoriteTable=NO;
        isTableSearch=NO;
        //show=NO;
        isKaraokeTab=YES;
        //[self checkHeadset];
        
        /* if (!hasHeadset && isrecord  && [Language hasSuffix:@"kara"]) {
         isrecord=NO;
         UIAlertView* alert2 = [[UIAlertView alloc] init];
         self.recordImage.hidden=YES;
         [alert2 setTitle:AMLocalizedString(@"Chú ý",nil)];
         [alert2 setMessage:AMLocalizedString(@"Vui lòng kết nối tay nghe để có thể thu âm!",nil)];
         // [alert2 setDelegate:self];
         [alert2 addButtonWithTitle:AMLocalizedString(@"OK",nil)];
         [alert2 performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
         }*/
        // if (isLastestVersion && [Language hasSuffix:@"kara"]) {
        //  self.xulyButt.hidden=YES;
        //}
        
        // if (unload==NO && ![Language hasSuffix:@"kara"]){
        
        // }
        //  self.progressBuffer.frame=CGRectMake(self.progressBuffer.frame.origin.x, self.progressBuffer.frame.origin.y, self.movieTimeControl.frame.size.width, 4);
        // [[AVAudioSession sharedInstance] setDelegate: self];
        
        if (hasHeadset || playRecord || playRecUpload || playTopRec) self.warningHeadset.hidden=YES;
        else self.warningHeadset.hidden=NO;
        
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [movieTimeControl addGestureRecognizer:gr];
        UITapGestureRecognizer *grk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [self.karaokeEffectTimeSlider addGestureRecognizer:grk];
        if (playRecord || playRecUpload){
            
            UITapGestureRecognizer *gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedEcho:)];
            [self.volumEcho addGestureRecognizer:gr2];
            UITapGestureRecognizer *gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedMusicVolume:)];
            [self.volumeMusic addGestureRecognizer:gr3];
            UITapGestureRecognizer *gr4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedTreble:)];
            [self.volumeTreble addGestureRecognizer:gr4];
            UITapGestureRecognizer *gr5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedVocalVolume:)];
            [self.volumeVocal addGestureRecognizer:gr5];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
            
            [uploadView addGestureRecognizer:tap];
        }
        /* UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_Button99.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]
         landscapeImagePhone:[UIImage imageNamed:@"menu_Button99.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(revealMenu:)];
         
         [button setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];*/
        // self.navigationItem.leftBarButtonItem=button;
        self.showSongName.textColor=[UIColor whiteColor];
        self.showSingerName.textColor=[UIColor whiteColor];
        
        if ([Language hasSuffix:@"kara"]){
            //self.menuLyric.allowsSelection=NO;
            [self.editButt setImage:[UIImage imageNamed:@"Video_1289.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            
            UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(hideToolbar)];
            [self.playerLayerView addGestureRecognizer:tap9];
            self.MenuRightButton.customView.hidden=YES;
            self.showSongName.textColor=[UIColor whiteColor];
            self.showSingerName.textColor=[UIColor whiteColor];
        }else {
            if (!playRecord && playVideoRecorded){
                UITapGestureRecognizer *tap39 = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(hideToolbar)];
                [self.playerLayerView addGestureRecognizer:tap39];
               // self.playerLayerView.hidden=NO;
                
            }else{
                self.playerLayerView.hidden=YES;
            }
        }
        if (videoRecord){
           // UITapGestureRecognizer *tap19 = [[UITapGestureRecognizer alloc]       initWithTarget:self action:@selector(showReviewViewRecordFullscreen:)];
           // [self.previewView addGestureRecognizer:tap19];
        }
        
        movieTimeControl.minimumTrackTintColor=UIColorFromRGB(HeaderColor);
        movieTimeControl.maximumTrackTintColor = [UIColor whiteColor];
        if (songRec){
            if ([songRec->hasUpload isEqualToString:@"YES"]) {
                
                
                [self.xulyButt setTitle: AMLocalizedString(@"Cập nhật",nil) forState:UIControlStateNormal];
                
            }else {
                [self.xulyButt setTitle:  AMLocalizedString(@"Xử lý",nil) forState:UIControlStateNormal];
                
                
            }
        }
        
        if (playRecord) {
            self.volumeMusic.value=[songRec.effectsNew.beatVolume floatValue];
            
            
            self.volumeVocal.value=[songRec.effectsNew.vocalVolume floatValue];
           
            self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d" ,[songRec.effectsNew.beatVolume intValue]];
            if (songRec){
                //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
                /*
                 }else{
                 self.deplayLabel.text=[NSString stringWithFormat:@"%d",(int)([songRec.delay floatValue]*1000)];
                 }*/
            }
           
            
            self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[songRec.effectsNew.vocalVolume intValue]];
            /*if ((uploadProssesing && songRec->isUploading) || isExporting) {
             demperc= [NSTimer
             scheduledTimerWithTimeInterval:1
             target:self
             selector:@selector(dempercen)
             userInfo:nil
             repeats:YES];
             }*/
        }
        
        //  self.showplainText.font=[UIFont fontWithName:@"Arial" size:25];
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            CGRect framee= CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
            self.navigationController.navigationBarHidden =YES;
          
            self.view.frame=framee;
            self.showplainText.font=[UIFont fontWithName:@"Arial" size:30];
        }
        if (videoRecord) {
           
            self.navigationController.navigationBarHidden=YES;
        }
        //showplainText.hidden = YES;
        CGRect nframe= CGRectMake(80, 70, 100, ListLyric.count*44-1);
        menuLyric.frame=nframe;
        self.menuLyric.delegate=self;
        self.menuLyric.dataSource=self;
        menuLyric.hidden=YES;
        menuLyric.backgroundColor=[UIColor clearColor];
        if (songPlay.songUrl ==nil && !([Language hasSuffix:@"kara"] && songPlay.videoId!=nil)) {
            isLoading.hidden=YES;
        }else{
            
            
            
            
            [MenuRec setHidden:YES];
            
            ///////
            // Do any additional setup after loading the view.
            if (playRecord || playRecUpload) {
                if (playRecUpload) {
                    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
                    
                    
                    if (songRec.mixedRecordingVideoUrl.length>5){
                        path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                    }else{
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                    }
                    
                    NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                    
                    if (isVoice && audioEngine2) {
                        [audioEngine2 playthroughSwitchChanged:NO];
                        [audioEngine2 reverbSwitchChanged:NO];
                        [audioEngine2 expanderSwitchChanged:NO];
                    }
                    NSError *error;
                    
                    if (haveS)  {
                        [self.editButt setImage:[UIImage imageNamed:@"cap_nhat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    }else{
                        self.editButt.hidden=YES;
                        //[self.editButt setBackgroundImage:[UIImage imageNamed:@"Video_1289.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    }
                }else
                    [self.editButt setImage:[UIImage imageNamed:@"icn_delete.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }else if  ([Language hasSuffix:@"kara"]){
                [self.editButt setImage:[UIImage imageNamed:@"Video_1289.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }else{
                
                
                [self.editButt setImage:[UIImage imageNamed:@"menu_context.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }
            
            self.view.layer.shadowOpacity = 0.75f;
            self.view.layer.shadowRadius = 10.0f;
            self.view.layer.shadowColor = [UIColor blackColor].CGColor;
            
            
            UIView* view  = [self view];
           // UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer allocWithZone:nil] initWithTarget:self action:@selector(handleSwipe:)];
           // [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
          //  [view addGestureRecognizer:swipeUpRecognizer];
            
          //  UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer allocWithZone:nil] initWithTarget:self action:@selector(handleSwipe:)];
          //  [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
          //  [view addGestureRecognizer:swipeDownRecognizer];
            //CGRect framSli= movieTimeControl.frame;
            //framSli.size.width=self.view.frame.size.width - 100;
            // movieTimeControl.frame=framSli;
            // UIBarButtonItem *scrubberItem = [[UIBarButtonItem alloc] initWithCustomView:movieTimeControl];
            
            // UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            // toolBar.items = [NSArray arrayWithObjects:playButton,scrubberItem,selectLyricButton, nil];
            
            
            //toolBar.frame =newfr;
            
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
            if ([songPlay.songUrl isKindOfClass:[NSString class]])
            if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
            }
            if ([Language hasSuffix:@"kara"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
            }else
                if ([songRec.effects.toneShift integerValue]!=0 && playRecord){
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",songPlay._id,(NSInteger)([songRec.effects.toneShift integerValue]/2)]];
                }
                else    if (songPlay.pitchShift!=0) {
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",songPlay._id,songPlay.pitchShift]];
                }
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
            }
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (haveS) isDownload=YES;
            else {

                    [NSThread detachNewThreadSelector:@selector(downloadSongMp3) toTarget:self withObject:nil];
                    isDownload = YES;


            }
            if (isrecord) {
                isDownload=NO;
            }
            //[self reverbSwitchChanged:YES];
            if (unload==YES) {
                // isVoice=NO;
                if (audioPlayRecorder) {
                    if (audioPlayRecorder.isPlaying)
                        [audioPlayRecorder pause];
                    audioPlayRecorder=nil;
                }
                
                
                if (ListLyric.count>0) [ListLyric removeAllObjects];
                
                if (iSongPlay && !playTopRec && !playRecUpload){
                    if (iSongPlay->isPlaying) iSongPlay->isPlaying=0;
                }
                
                isPlayingAu=NO;
                // [self playthroughSwitchChanged:YES];
                //dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                //dispatch_async(queue, ^{
                //code to executed in the background
                if (audioPlayer){
                    if ([self isPlayingAudio]){
                        [audioPlayer pause];
                    }
                }
                if (playerMain){
                    if ([self isPlaying]){
                        [playerMain pause];
                    }
                }
                
                //  dispatch_async(dispatch_get_main_queue(), ^{
                
                /*if (![Language hasSuffix:@"kara"]){
                 
                 [NSThread detachNewThreadSelector:@selector(loadOneLyric) toTarget:self withObject:nil];
                 self.showSingerName.text=songPlay.singerName;
                 
                 Lyric *lr;
                 if (songPlay.lyrics.count>0){
                 lr=songPlay.lyrics[0];
                 if (isrecord) {
                 songPlay.selectedLyric=lr.key;
                 songRec.selectedLyric=lr.key;
                 
                 }
                 }
                 
                 if (playRecord ||lr==nil) {
                 tieude=[NSString stringWithFormat:@"%@",songPlay.songName];
                 }else{
                 tieude=[NSString stringWithFormat:@"%@ - %@: %@",songPlay.songName,AMLocalizedString(@"Lời", @"Lời"),lr.privatedId];
                 }
                 CGRect nframe= self.menuLyric.frame;
                 nframe.size.height=ListLyric.count*44-1;
                 self.menuLyric.frame=nframe;
                 
                 if (isDownload) {
                 NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                 NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
                 if ([songRec.effects.toneShift integerValue]!=0 && playRecord){
                 filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",songPlay._id,(NSInteger)([songRec.effects.toneShift integerValue]/2)]];
                 }else if (songPlay.pitchShift!=0) {
                 filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",songPlay._id,songPlay.pitchShift]];
                 }
                 if ([songRec.performanceType isEqualToString:@"DUET"]) {
                 filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
                 }
                 BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                 if (haveS){
                 NSURL *urlLocal= [NSURL fileURLWithPath:filePath];
                 urlSong=[NSString stringWithFormat:@"%@",urlLocal];
                 }else{
                 filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",songPlay._id]];
                 NSURL *urlLocal= [NSURL fileURLWithPath:filePath];
                 urlSong=[NSString stringWithFormat:@"%@",urlLocal];
                 }
                 }else{
                 urlSong=songPlay.mp4link;
                 if (isrecord)
                 songRec.song.songUrl=songPlay.songUrl;
                 NSLog(@"%@",urlSong);
                 //[NSThread detachNewThreadSelector:@selector(playAudio) toTarget:self withObject:nil];
                 
                 if (urlSong!=nil && ![urlSong isKindOfClass:[NSNull class]]){
                 if ([urlSong hasSuffix:@".jpg"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]) urlSong=[NSString stringWithFormat:@"http://data.ikara.co/data/karaokes/zg/%@.mp3",songPlay._id];
                 }
                 }
                 }else{*/
                
                if (songPlay.singerName!=nil && ![songPlay.singerName isKindOfClass:[NSNull class]])
                    if (![songPlay.singerName isEqualToString:@"null"]) self.showSingerName.text=songPlay.singerName;
                tieude=[NSString stringWithFormat:@"%@",songPlay.songName];
                //  if ( [songRec.performanceType isEqualToString:@"DUET"] ) {
                urlSong=songPlay.songUrl;
                /// }else
                //  urlSong=songPlay.mp4link;
                // }
                self.titleName.text=tieude;
                showSongName.text=tieude;
                //self.selectMenuLyric= [[SelectLyricViewController alloc] initWithArrayData:ListLyric];
                
                ////////
                
                
                
                if (playRecord){
                    
                    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
                    if ([songRec.recordingType isEqualToString:@"VIDEO"] || playVideoRecorded) {
                        path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                    }else {
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                    }
                    NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                    
                    if (isVoice && audioEngine2) {
                        [audioEngine2 playthroughSwitchChanged:NO];
                        [audioEngine2 reverbSwitchChanged:NO];
                        [audioEngine2 expanderSwitchChanged:NO];
                    }
                    NSError *error;
                    if (self.recordSession) {
                        recordSessionTmp=self.recordSession;
                        
                        if (self.currentFilter && !self.currentFilter.isEmpty ) {
                            isExportingVideoWithEffect=YES;
                               
                            
                            
                            
                            AVAsset *asset = self.recordSession.assetRepresentingSegments;
                            SCAssetExportSession* assetExportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
                            assetExportSession.outputUrl = [NSURL fileURLWithPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]]];
                            assetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
                            
                            assetExportSession.videoConfiguration.filter = self.currentFilter;
                            assetExportSession.videoConfiguration.preset = SCPresetMediumQuality;
                            assetExportSession.audioConfiguration.preset = SCPresetHighestQuality;
                            assetExportSession.videoConfiguration.maxFrameRate = 35;
                           //[[NSNotificationCenter defaultCenter] postNotificationName:@"exportVideoWithEffect" object:assetExportSession];
                            [self exportVideoWithEffect:assetExportSession];
                             
                        }else{
                           isExportingVideo=YES;
                            [self exportVideo:self.recordSession];
                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"exportVideo" object:self.recordSession];
                       
                            
                        }
                    }
                    if (haveS || self.recordSession)  {
                        if (VipMember   && ([songRec.onlineVocalUrl isKindOfClass:[NSString class]]||[songRec.onlineVoiceUrl isKindOfClass:[NSString class]]))  {
                            NSLog(@"co roi songRec.onlineVoiceUrl %@   \n songRec.onlineVocalUrl %@",songRec.onlineVoiceUrl,songRec.onlineVocalUrl);
                        }else{
                            //if (playVideoRecorded) {
                                
                                /*if (!VipMember) {
                                    [self createListEffectVideo:path];
                                }*/
                           
                            
                          
                            [self.playerLayerViewRec insertSubview:filterView atIndex:2];
                            if (songRec->isExportVideo && (isExportingVideo || isExportingVideoWithEffect)) {
                               
                                [NSThread detachNewThreadSelector:@selector(loadMovie2:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songRec.vocalUrl]];
                            }else
                                [NSThread detachNewThreadSelector:@selector(loadMovie2:) toTarget:self withObject:[NSString stringWithFormat:@"%@",audioFileURL]];
                                
                        
                        }
                    }
                    else {
                        [[[[iToast makeText:AMLocalizedString(@"File thu âm đã bị lỗi nên không thể xử lý bài thu. Vui lòng xóa bài và thu lại bài khác",nil)]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    }
                    if (error) NSLog(@"%@",error);
                }
                // if ([self isPlaying]) [playerMain pause];
                /*if ((playTopRec||playRecUpload)&& playVideoRecorded){
                 
                 [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:songRec.mixedRecordingVideoUrl];
                 if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
                 playerMain.volume=1;
                 }else{
                 NSArray *audioTracks = [assetLoadmovie1 tracksWithMediaType:AVMediaTypeAudio];
                 
                 // Mute all the audio tracks
                 NSMutableArray *allAudioParams = [NSMutableArray array];
                 for (AVAssetTrack *track in audioTracks) {
                 AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
                 
                 
                 [audioInputParams setVolume:1 atTime:kCMTimeZero];
                 // playerMain.volume=1;
                 
                 [audioInputParams setTrackID:[track trackID]];
                 [allAudioParams addObject:audioInputParams];
                 }
                 AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
                 [audioZeroMix setInputParameters:allAudioParams];
                 
                 // Create a player item
                 AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:assetLoadmovie1];
                 [playerItem1 setAudioMix:audioZeroMix]; // Mute the player item
                 
                 // Create a new Player, and set the player to use the player item
                 // with the muted audio mix
                 
                 
                 // assign player object to an instance variable
                 CMTime currentTime= [playerMain currentTime];
                 
                 // play the muted audio
                 if (playerItem1) {
                 [playerMain replaceCurrentItemWithPlayerItem:playerItem1];
                 [playerMain seekToTime:currentTime];
                 [playerMain play];
                 }
                 }
                 }else*/
                if ([urlSong isKindOfClass:[NSString class]] && [songRec.performanceType isEqualToString:@"DUET"]){ //&& ![Language hasSuffix:@"kara"]){
                    //if (VipMember) {
                    //  [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSong];
                    // }else
                    if (!playRecord ) {
                        if (playVideoRecorded || isrecord) {
                             [NSThread detachNewThreadSelector:@selector(loadDuetVideo:) toTarget:self withObject:urlSong];
                        }
                       
                    }else if (playVideoRecorded && !VipMember){
                       // [NSThread detachNewThreadSelector:@selector(loadDuetVideo:) toTarget:self withObject:urlSong];
                    }
                    
                    
                    
                    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
                        
                        playerMain.volume=1;
                    }else{
                        NSArray *audioTracks = [assetLoadmovie1 tracksWithMediaType:AVMediaTypeAudio];
                        
                        // Mute all the audio tracks
                        NSMutableArray *allAudioParams = [NSMutableArray array];
                        for (AVAssetTrack *track in audioTracks) {
                            AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
                            
                            
                            [audioInputParams setVolume:1 atTime:kCMTimeZero];
                            // playerMain.volume=1;
                            
                            [audioInputParams setTrackID:[track trackID]];
                            [allAudioParams addObject:audioInputParams];
                        }
                        AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
                        [audioZeroMix setInputParameters:allAudioParams];
                        
                        // Create a player item
                        AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:assetLoadmovie1];
                        [playerItem1 setAudioMix:audioZeroMix]; // Mute the player item
                        
                        // Create a new Player, and set the player to use the player item
                        // with the muted audio mix
                        
                        
                        // assign player object to an instance variable
                        CMTime currentTime= [playerMain currentTime];
                        
                        // play the muted audio
                        if (playerItem1) {
                            [playerMain replaceCurrentItemWithPlayerItem:playerItem1];
                            [playerMain seekToTime:currentTime];
                            [playerMain play];
                        }
                    }
                }//else {
                
                
                
                [self.toolBar setHidden:NO];
                [self disablePlayerButtons];
                [self disableScrubber];
                if (timeRestore==0){
                    [movieTimeControl setValue:0.0];
                    if (playerMain) [playerMain seekToTime:kCMTimeZero];
                }
                
              
                    if (isPlayingRecordFromEdit && playRecord && !playVideoRecorded && !isDownload && [Language hasSuffix:@"kara"]){
                        isPlayingRecordFromEdit=NO;
                        if (isTabKaraoke) isKaraokeTab=YES;
                        if (isKaraokeTab){/*
                                           urlSong=[videoYoutubeDictionary objectForKey:videoQuality];
                                           if (!urlSong) urlSong=[videoYoutubeDictionary objectForKey:@"small"];
                                           if (!urlSong) urlSong=[videoYoutubeDictionary objectForKey:@"medium"];
                                           if (!urlSong) urlSong=[videoYoutubeDictionary objectForKey:@"hd720"];*/
                            //  songPlay.songUrl=urlSong;
                            // [playerYoutube prepareToPlay];
                            //  playerYoutube.view.frame = CGRectMake(0, 0, 350, 350);
                            // if ([songRec.performanceType isEqualToString:@"DUET"] && VipMember && playRecord) {
                            
                            //}else
                            if ([songRec.performanceType isEqualToString:@"DUET"] || playRecord || YES) {
                                if (songPlay.mp4link.length>10 ){
                                    
                                    [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songRec.song.mp4link]];
                                }else {
                                    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                                    dispatch_async(queue, ^{
                                        YoutubeMp4Respone *res=[[LoadData2 alloc] GetYoutubeMp4Link:songPlay.videoId];
                                        if ([res isKindOfClass:[YoutubeMp4Respone class]]) {
                                            if (res.videos.count==0) {
                                                
                                            }else{
                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
                                                NSArray *filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                if (filteredArray.count>0) {
                                                    YoutubeMp4* linkMp4=filteredArray[0];
                                                    songPlay.mp4link=linkMp4.url;
                                                }else{
                                                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                                                    filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                    if (filteredArray.count>0) {
                                                        YoutubeMp4* linkMp4=filteredArray[0];
                                                        songPlay.mp4link=linkMp4.url;
                                                    }else{
                                                        predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                                                        filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                        if (filteredArray.count>0) {
                                                            YoutubeMp4* linkMp4=filteredArray[0];
                                                            songPlay.mp4link=linkMp4.url;
                                                        }
                                                    }
                                                }
                                                
                                            }
                                           
                                            [self loadMovi:songPlay.mp4link];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (res.videos.count==0) {
                                                [[[[iToast makeText:AMLocalizedString(@"Video này đã bị xóa!", nil)]  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                            }
                                        });
                                    });
                                }
                            }else
                                [youtubePlayer loadWithVideoId:songPlay.videoId playerVars:playerVars];
                            // [youtubePlayer setPlaybackQuality:kYTPlaybackQualityMedium];
                            //videoQualityList=youtubePlayer.availablePlaybackRates;
                            
                            ///youtube [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSong];
                        }
                    }else{
                        if (isDownload){
                            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
                            if ([songPlay.songUrl isKindOfClass:[NSString class]])
                            if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
                            }
                            if (songPlay.videoId.length>2){
                                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
                                
                            }
                            if ([songRec.performanceType isEqualToString:@"DUET"]) {
                                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
                            }
                            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                            if (haveS){
                                NSURL *urlLocal= [NSURL fileURLWithPath:filePath];
                                urlSong=[NSString stringWithFormat:@"%@",urlLocal];
                                //[NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSong];
                                if ([Language hasSuffix:@"karaokestar"]) {
                                    
                                }else
                                if (([songRec.performanceType isEqualToString:@"DUET"] &&  [songRec.song.songUrl hasSuffix:@"mp4"]) || playVideoRecorded) {
                                    
                                }else
                                if (songPlay.mp4link.length>10 ){
                                    
                                    [NSThread detachNewThreadSelector:@selector(loadYoutubeVideoTmp:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songPlay.mp4link]];
                                }else {
                                    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                                    dispatch_async(queue, ^{
                                        YoutubeMp4Respone *res=[[LoadData2 alloc] GetYoutubeMp4Link:songPlay.videoId];
                                        if ([res isKindOfClass:[YoutubeMp4Respone class]]) {
                                            if (res.videos.count==0) {
                                                
                                            }else{
                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
                                                NSArray *filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                if (filteredArray.count>0) {
                                                    YoutubeMp4* linkMp4=filteredArray[0];
                                                    songPlay.mp4link=linkMp4.url;
                                                    
                                                }else{
                                                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                                                    filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                    if (filteredArray.count>0) {
                                                        YoutubeMp4* linkMp4=filteredArray[0];
                                                        songPlay.mp4link=linkMp4.url;
                                                    }else{
                                                        predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                                                        filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                        if (filteredArray.count>0) {
                                                            YoutubeMp4* linkMp4=filteredArray[0];
                                                            songPlay.mp4link=linkMp4.url;
                                                        }
                                                    }
                                                }
                                                
                                            }
                                          
                                            songRec.song.mp4link=songPlay.mp4link;
                                            [self loadYoutubeVideoTmp:songPlay.mp4link];
                                        } dispatch_async(dispatch_get_main_queue(), ^{
                                            if (res.videos.count==0) {
                                                [[[[iToast makeText:AMLocalizedString(@"Beat đã bị xóa", nil)]  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                            }
                                        });
                                    });
                                }
                            }else{
                                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay._id]];
                                if ([songPlay.songUrl isKindOfClass:[NSString class]])
                                if ([songPlay.songUrl hasSuffix:@"m4a"]) {
                                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",songPlay._id]];
                                }
                                if (songPlay.videoId.length>2){
                                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songPlay.videoId]];
                                    
                                }
                                if ([songRec.performanceType isEqualToString:@"DUET"]) {
                                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",songRec.originalRecording]];
                                    // [youtubePlayer loadWithVideoId:songPlay.videoId playerVars:playerVars];
                                    
                                }
                                NSURL *urlLocal= [NSURL fileURLWithPath:filePath];
                                urlSong=[NSString stringWithFormat:@"%@",urlLocal];
                                //[NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSong];
                                
                            }
                        }else{
                            //  if (getLinkFromYoutube==NO) {
                            if ([songRec.performanceType isEqualToString:@"DUET"] || playRecord  || YES) {
                                /*if (songPlay.songUrl.length>5 && [songRec.performanceType isEqualToString:@"DUET"]) {
                                    [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songPlay.songUrl]];
                                }else*/
                                if (songPlay.mp4link.length>10 ){
                                    
                                    [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:[NSString stringWithFormat:@"%@",songPlay.mp4link]];
                                }else {
                                    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                                    dispatch_async(queue, ^{
                                        YoutubeMp4Respone *res=[[LoadData2 alloc] GetYoutubeMp4Link:songPlay.videoId];
                                        if ([res isKindOfClass:[YoutubeMp4Respone class]]) {
                                            if (res.videos.count==0) {
                                                
                                            }else{
                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
                                                NSArray *filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                if (filteredArray.count>0) {
                                                    YoutubeMp4* linkMp4=filteredArray[0];
                                                    songPlay.mp4link=linkMp4.url;
                                                }else{
                                                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                                                    filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                    if (filteredArray.count>0) {
                                                        YoutubeMp4* linkMp4=filteredArray[0];
                                                        songPlay.mp4link=linkMp4.url;
                                                    }else{
                                                        predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                                                        filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                                        if (filteredArray.count>0) {
                                                            YoutubeMp4* linkMp4=filteredArray[0];
                                                            songPlay.mp4link=linkMp4.url;
                                                        }
                                                    }
                                                }
                                                
                                            }
                                           
                                            [self loadMovi:songPlay.mp4link];
                                        } dispatch_async(dispatch_get_main_queue(), ^{
                                            if (res.videos.count==0) {
                                                [[[[iToast makeText:AMLocalizedString(@"Beat đã bị xóa", nil)]  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                            }
                                        });
                                    });
                                }
                            }else
                                [youtubePlayer loadWithVideoId:songPlay.videoId playerVars:playerVars];
                        }
                    }
                
                //}
                // [self loadMovie:urlSong];
                
                
            }else{
                if (playTopRec || playRecord || playRecUpload) self.warningHeadset.hidden=YES;
                
                if (playerMain){
                    
                    if (![Language hasSuffix:@"kara"]){
                        playerItem=[playerMain currentItem];
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:playerItem];
                    }
                    CMTime playerDuration = [self playerItemDuration];
                    if ([Language hasSuffix:@"kara"] && !playTopRec && !playRecUpload) {
                        songPlay.singerName=@"";
                        [youtubePlayer loadWithVideoId:songPlay.videoId playerVars:playerVars];
                        double duration = youtubePlayer.duration;
                    }
                    if (!playTopRec && !playRecUpload && ![Language hasSuffix:@"kara"]) {
                        if (showPlain) {
                            self.showplainText.hidden=NO;
                            karaokeDisplayElement.hidden=YES;
                            self.showplainText.text = contentPlaintext;
                        }
                        else {
                            self.showplainText.hidden=YES;
                            karaokeDisplayElement.hidden=NO;
                            if (lyric  && ![Language hasSuffix:@"kara"]) {
                                [karaokeDisplay setSimpleTiming:lyric];
                                [karaokeDisplay reset];
                                [karaokeDisplay _updateOrientation ];
                                [karaokeDisplay render:CMTimeGetSeconds([playerMain currentTime])];
                            }
                        }
                    }
                    [toolBar setHidden:NO];
                    [showSongName setHidden:NO];
                    showSongName.text=tieude;
                    self.titleName.text=tieude;
                    [isLoading setHidden:YES];
                    
                    movieTimeControl.hidden = NO;
                    [self initScrubberTimer];
                    [self enableScrubber];
                   
                    self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:[playerMain currentTime]]];
                    self.timeDuration.text=[NSString stringWithFormat:@"%@",[self convertTimeToString:playerDuration]];
                    double duration = CMTimeGetSeconds(playerDuration);
                    showSongName.text=tieude;
                    self.titleName.text=tieude;
                    if ([Language hasSuffix:@"kara"] ) songPlay.singerName=@"";
                    self.showSingerName.text=songPlay.singerName;
                    //[self enablePlayerButtons];
                    float minValue = [movieTimeControl minimumValue];
                    float maxValue = [movieTimeControl maximumValue];
                    double time = CMTimeGetSeconds([playerMain currentTime]);
                    double tim=(maxValue - minValue) * time / duration + minValue;
                    [movieTimeControl setValue:tim];
                    [self syncScrubber];
                    if ((playTopRec || playRecUpload) && ![Language hasSuffix:@"kara"]) {
                        //[self loadLyric];
                        [NSThread detachNewThreadSelector:@selector(loadLyric) toTarget:self withObject:nil];
                    }
                    //     [self syncPlayPauseButtons];
                    if (([Language hasSuffix:@"kara"]&&!(playRecUpload&& !playVideoRecorded)) || (!playRecord && playVideoRecorded)){
                        playerLayerView.playerLayer.hidden = NO;
                        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                        [playerLayerView.playerLayer setPlayer:playerMain];
                        
                    }
                    if (playVideoRecorded && playRecord){
                        //[self createListEffectVideo:<#(NSString *)#>]
                        //playerLayerViewRec.playerLayer.backgroundColor = [[UIColor clearColor] CGColor];
                        //[playerLayerViewRec.playerLayer setPlayer:audioPlayer]
                        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                        
                        // audioPlayer = [SCPlayer player];
                        
                        
                        self.playerLayerViewRec.hidden=NO;
                        //  [audioPlayer setItemByAsset:recordSession.assetRepresentingSegments];
                        
                        
                        NSLog(@"%f %f %f",self.playerLayerViewRec.frame.size.height,self.playerLayerViewRec.frame.size.width,self.view.frame.size.width);
                      
                       
                        [self.colectionView registerNib:[UINib nibWithNibName:@"EffectCollectionViewCell" bundle:bun]  forCellWithReuseIdentifier:@"Cell"];
                        //self.colectionView.backgroundColor=[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:0.8];
                        self.colectionView.delegate=self;
                        self.colectionView.dataSource=self;
                        
                        if (isKaraokeTab){
                            // [self initScrubberTimer2];
                        }
                        //[self enableScrubber];
                        //[self enablePlayerButtons];
                        
                        
                        /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
                        playerItem2 = [audioPlayer currentItem];
                        
                        /* Observe the player item "status" key to determine when it is ready to play. */
                        [playerItem2 addObserver:self
                                      forKeyPath:@"status"
                                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                         context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext2];
                        hasObser2=YES;
                        /* When the player item has played to its end time we'll toggle
                         the movie controller Pause button to be the Play button */
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd2:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem2];
                        
                        
                        /* Make our new AVPlayerItem the AVPlayer's current item. */
                        AVPlayerItem *item=audioPlayer.currentItem;
                        if (item != playerItem2)
                        {
                            /* Replace the player item with a new player item. The item replacement occurs
                             asynchronously; observe the currentItem property to find out when the
                             replacement will/did occur*/
                            [audioPlayer replaceCurrentItemWithPlayerItem:playerItem2];
                            item=nil;
                            //[self syncPlayPauseButtons];
                        }
                        
                        
                        if (listEffect==nil) listEffect=[NSMutableArray new];
                        Effect * ef=[Effect new];
                        ef.name=@"None";
                        ef.filter=[SCFilter emptyFilter];
                        ef.image=@"song_Hye_Kyo.png";
                        [listEffect addObject:ef];
                        currentEffect=ef;
                        Effect * ef1=[Effect new];
                        ef1.name=@"Mono";
                        ef1.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectMono"];
                        ef1.image=@"hieu_ung_(1).png";
                        [listEffect addObject:ef1];
                        Effect * ef5=[Effect new];
                        ef5.name=@"Tonal";
                        ef5.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"];
                        ef5.image=@"hieu_ung_(2).png";
                        [listEffect addObject:ef5];
                        Effect * ef6=[Effect new];
                        Effect * ef2=[Effect new];
                        ef2.name=@"Noir";
                        ef2.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"];
                        ef2.image=@"hieu_ung_(3).png";
                        [listEffect addObject:ef2];
                        ef6.name=@"Fade";
                        ef6.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"];
                        ef6.image=@"hieu_ung_(4).png";
                        [listEffect addObject:ef6];
                        Effect * ef3=[Effect new];
                        ef3.name=@"Chrome";
                        ef3.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"];
                        ef3.image=@"hieu_ung_(5).png";
                        [listEffect addObject:ef3];
                        Effect * ef7=[Effect new];
                        ef7.name=@"Process";
                        ef7.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectProcess"];
                        ef7.image=@"hieu_ung_(6).png";
                        [listEffect addObject:ef7];
                        Effect * ef9=[Effect new];
                        ef9.name=@"Transfer";
                        ef9.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectTransfer"];
                        ef9.image=@"hieu_ung_(7).png";
                        [listEffect addObject:ef9];
                        Effect * ef4=[Effect new];
                        ef4.name=@"Instant";
                        ef4.filter=[SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
                        ef4.image=@"hieu_ung_(8).png";
                        [listEffect addObject:ef4];
                        
                    }else if (playRecord){
                        if (audioPlayRecorder.delegate==nil) {
                            audioPlayRecorder.delegate=self;
                        }
                    }
                    [self syncPlayPauseButtons];
                    //
                }
            }
        }
        
        unload=NO;
        
        if ([Language hasSuffix:@"kara"]) {self.navigationController.navigationBarHidden =YES;
            self.headerView.hidden=NO;
        }
    }
    if (playRecord) {
        self.headerView.hidden=NO;
        [self.xulyViewVolumeTapButton setTitleColor:UIColorFromRGB(0x9c9c9c) forState:UIControlStateNormal];
        CGRect frameplaybutton=self.playButt.frame;
        frameplaybutton.origin.x=10;
        frameplaybutton.origin.y=50;
        self.playButt.frame=frameplaybutton;
        self.pauseBtt.frame=frameplaybutton;
        CGRect frameTimeLabel=self.timeplay.frame;
        frameTimeLabel.origin.x=frameplaybutton.size.width+10;
        frameTimeLabel.origin.y=58;
        self.timeplay.frame=frameTimeLabel;
        CGRect frameTimeLabel2=self.timeDuration.frame;
        frameTimeLabel2.origin.x=self.view.frame.size.width- frameTimeLabel2.size.width;
        frameTimeLabel2.origin.y=58;
        self.timeDuration.frame=frameTimeLabel2;
        
        self.movieTimeControl.frame=CGRectMake(frameTimeLabel.origin.x+frameTimeLabel.size.width, 55, frameTimeLabel2.origin.x-(frameTimeLabel.origin.x+frameTimeLabel.size.width), 28);
        CGRect frameProcessBuffer=self.progressBuffer.frame;
        frameProcessBuffer.origin.x=self.movieTimeControl.frame.origin.x;
        frameProcessBuffer.size.width=self.movieTimeControl.frame.size.width-4;
        frameProcessBuffer.origin.y=self.movieTimeControl.frame.origin.y+14;
        
        self.progressBuffer.frame=frameProcessBuffer;
        self.progressBuffer.center=self.movieTimeControl.center;
         if (!UIAccessibilityIsReduceTransparencyEnabled()) {
         UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
         UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
         CGRect fram=self.editScrollView.frame;
         fram.size.height=self.editScrollView.contentSize.height+50;
         blurEffectView.frame = fram;
         
         blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         //[cell.thumnailView insertSubview:blurEffectView belowSubview:cell.likeCmtView];
         // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
         // cell.likeCmtView=blurEffectView;
             if ([songRec.thumbnailImageUrl isKindOfClass:[NSString class]]) {
                 [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:songRec.thumbnailImageUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
             }else  if ([songRec.song.thumbnailUrl isKindOfClass:[NSString class]]) {
             [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:songRec.song.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
             }
       //  [self.backgroundImage setFrame:fram];
          self.backgroundImage.hidden=NO;
         //[self.editScrollView insertSubview:self.backgroundImage atIndex:0];
         [self.editScrollView insertSubview:blurEffectView atIndex:0];
         
         // [blurEffectView addGestureRecognizer:tap19];
         //cell.likeCmtView.backgroundColor=[UIColor clearColor];
         }
        
    }
    [self performSelector:@selector(hideBar) withObject:nil afterDelay:5];
    if (playRecord) {
        if (VipMember  ) {
            streamName= [NSString stringWithFormat:@"%@-stream-%@",[[LoadData2 alloc] idForDevice], [[NSProcessInfo processInfo] globallyUniqueString]];
           
            [self setupAssynSocket];
            ringBufferData=[[CircularQueue alloc] initWithCapacity:300];
            
            [NSThread detachNewThreadSelector:@selector(loadStream) toTarget:self withObject:nil];
            playerMain.muted=YES;
            audioPlayRecorder.volume=0;
            self.isLoading.center=self.loadingViewVipLoad.center;
        }else
        
        self.isLoading.center=self.playerLayerView.center;
        self.isLoading.hidden=YES;
    }
	 if (hasHeadset) {
		  self.recordToolbarVoiceVolumeSlider.value=(pow( [audioEngine2 getPlaythroughVolume],1/1.6666));
		  self.microVolumeLabel.text=[NSString stringWithFormat:@"%.0f",self.recordToolbarVoiceVolumeSlider.value*100];

		  self.microEchoSlider.value= [audioEngine2 getEchoVolume];
		  self.microEchoLabel.text=[NSString stringWithFormat:@"%.0f",self.microEchoSlider.value];//*2.5+50];
	 }else{
		  self.recordToolbarVoiceVolumeSlider.value=100;
		  self.microVolumeLabel.text=[NSString stringWithFormat:@"%.0f",self.recordToolbarVoiceVolumeSlider.value*100];
		  self.microEchoSlider.value= 50;
		  self.microEchoLabel.text=[NSString stringWithFormat:@"%.0f",self.microEchoSlider.value];//*2.5+50];
	 }
	 if (VipMember && playRecord  ) {
		  self.loadingViewVIP.frame=CGRectMake(0, 0, self.view.frame.size.width, self.xulyView.frame.origin.y);
	 }
	 if (![songPlay.songUrl isKindOfClass:[NSString class]] ){

	 }else
    if (videoRecord  && [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"] ) {
        playerLayerView.playerLayer.hidden = NO;
        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        playerMain.muted=YES;
        
        //[playerLayerView.playerLayer setPlayer:playerMain];
        //playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
        //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
        NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
        self.duetVideoLayer.frame=CGRectMake(self.view.frame.size.width-110, self.previewView.frame.origin.y+self.previewView.frame.size.height-110, 100, 100);
        
      
        
    }else if (videoRecord  && [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"]) {
        playerLayerView.playerLayer.hidden = NO;
        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        playerMain.muted=YES;
        
        // [playerLayerView.playerLayer setPlayer:playerMain];
        // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
        //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
        NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
        // self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        CGRect frameToolbar=self.toolBar.frame;
        
        
        frameToolbar.origin.y=playerLayerView.frame.size.height-self.toolBar.frame.size.height;
        
        
        
        self.toolBar.backgroundColor=[UIColor clearColor];
        self.toolBar.frame=frameToolbar;
        CGRect frame=_duetUserView.frame;
        frame.origin.x=0;
        frame.origin.y=playerLayerView.frame.size.height;
        _duetUserView.frame=frame;
       // self.previewView.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.previewView.frame.size.width, self.previewView.frame.size.height);
        
        
	}else if (isrecord  && [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"]) {
        playerLayerView.playerLayer.hidden = NO;
        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        playerMain.muted=YES;
        
        // [playerLayerView.playerLayer setPlayer:playerMain];
        // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
        NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
        // self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        
        
        //self.previewView.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        
        
    }else if ( [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"] && !playVideoRecorded) {
        playerLayerView.playerLayer.hidden = NO;
        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        playerMain.muted=YES;
        playerLayerView.hidden =YES;
        // [playerLayerView.playerLayer setPlayer:playerMain];
         // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.view.frame.size.width-self.recordToolbar.frame.size.height);
       
        //self.previewView.frame=CGRectMake(self.view.frame.size.width/2, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        if (isrecord) {

            self.duetVideoLayer.frame=CGRectMake(0,self.view.frame.size.height- self.recordToolbar.frame.size.height-self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.width);
            playerLayerView.frame=CGRectMake(0,0, self.view.frame.size.width, self.duetVideoLayer.frame.origin.y);
        }

        NSLog(@"duet video layer %f",self.duetVideoLayer.frame.size.height);
        /*if (self.view.frame.size.width+self.playerLayerView.frame.size.height+self.recordToolbar.frame.size.height>self.view.frame.size.height) {
             self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.playerLayerView.frame.size.height-self.recordToolbar.frame.size.height);
        }else*/
        //self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height-1, self.view.frame.size.width, self.view.frame.size.width);
    }else if (( [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"] && !playVideoRecorded)) {
        playerLayerView.playerLayer.hidden = NO;
        playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        if (!isDownload && !VipMember) {
            playerMain.muted=YES;
        }
        
        
        // [playerLayerView.playerLayer setPlayer:playerMain];
        // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
        //self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        //self.previewView.frame=CGRectMake(self.view.frame.size.width/2, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
        // playerLayerView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
        NSLog(@"duet video layer %f",self.duetVideoLayer.frame.size.height);
    }

}
- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
    if([notification.name isEqual:@"Playback started"] && notification.object != self) {
        [youtubePlayer pauseVideo];
    }
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{
     NSLog(@"play youtube error %@",error);
}
- (nullable UIView *)playerViewPreferredInitialLoadingView:(nonnull YTPlayerView *)playerView{
    UIView * viewB=[[UIView alloc] init];
    viewB.backgroundColor=[UIColor blackColor];
    return viewB;
}
- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    //float progress = playTime/playerView.duration;
    //[self.movieTimeControl setValue:progress];
    if (isrecord && videoRecord && !isRecorded && youtubePlayer.playerState==kYTPlayerStatePlaying && playTime>0){
        [self record];
    }
   /* if (youtubePlayer.currentTime>1&& youtubePlayer.currentTime<10 && videoRecord && isrecord) {
      //  delayRec= CMTimeGetSeconds(recorder.session.duration)-youtubePlayer.currentTime;
        
      //  NSLog(@"playerView delay video %f player time %f record duration %f segment %f",delayRec,youtubePlayer.currentTime,CMTimeGetSeconds(recorder.session.duration),CMTimeGetSeconds(recorder.session.currentSegmentDuration));
    }*/
    if (isrecord && (recorder.isRecording || audioEngine2.recorder.recording)) {
        dispatch_async(dispatch_get_main_queue(), ^{
        self.recordAlertImage.hidden=!self.recordAlertImage.isHidden;
        });
    }
    double duration = playerView.duration;
    if (  (playRecord && playVideoRecorded) && audioPlayer && !isrecord  ){
        duration=CMTimeGetSeconds([self playerItemDuration2]);
        if (youtubePlayer.currentTime>duration) {
            [youtubePlayer stopVideo];
            seekToZeroBeforePlay = YES;
            isPlayingAu=NO;
            
            
            
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
            
            
            isLoading.hidden=YES;
            [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
            
        }
    }else if (playRecord && !playVideoRecorded){
        duration=audioPlayRecorder.duration;
        if (youtubePlayer.currentTime>audioPlayRecorder.duration) {
            [youtubePlayer stopVideo];
            seekToZeroBeforePlay = YES;
            isPlayingAu=NO;
            
            
            
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
            
            
            isLoading.hidden=YES;
            [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
        }
    }
    
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [movieTimeControl minimumValue];
        float maxValue = [movieTimeControl maximumValue];
        //double time = CMTimeGetSeconds([playerMain currentTime]);
        //delayRec=0.28;
        [movieTimeControl setValue:(maxValue - minValue) * playTime / duration + minValue];
        if (playRecord && (self.karaokeEffectView.isHidden==NO || !self.studioEffectView.isHidden )) {
            self.karaokeEffectTime.text=[NSString stringWithFormat:@"%@ | %@",[self convertTimeToString2:playTime],[self convertTimeToString2:duration]];
            
            [self.karaokeEffectTimeSlider setValue:(maxValue - minValue) * playTime / duration + minValue];
        }
        
        self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:playTime]];
        self.timeDuration.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:duration]];
        if (([songRec.performanceType isEqualToString:@"DUET"] || [songRec.performanceType isEqualToString:@"ASK4DUET"]) && isrecord) {
            UIColor *color=[UIColor whiteColor];
            NSInteger gen;
            for (int i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
                ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
                if (ct.time<=playTime+1) {
                    color=ct.color;
                    gen=ct.gender;
                    break;
                }
            }
            
            
            
            if (gen==0) {
                // [self user1Sing];
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
                }else{
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }
            }else if (gen==1){
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user2Sing];
                    }else{
                        [self user1Sing];
                    }
                }else
                    if ([songRec.sex isEqualToString:@"m"]) {
                        [self user1Sing];
                    }else{
                        [self user2Sing];
                    }
            }else{
                [self bothSing];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //  [self.movieTimeControl setThumbTintColor:color];
                if ([color isEqual:genderColor]) {
                    [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
                }else if ([color isEqual:[UIColor whiteColor]]) {
                    [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
                }else{
                    [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
                }
            });
        }
        
        
    }
    if (isRecorded && !videoRecord && playTime>10 && !alerReRecordIsShow) {
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
        NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        unsigned long long filesize=[fileinfo fileSize];
        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (!haveS || filesize<1000) {
            NSLog(@"Lỗi thu âm không có file");
            alerReRecordIsShow=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                alertReRecord=[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                         message:AMLocalizedString(@"Quá trình thu âm bị lỗi bạn nên bắt đầu thu âm lại!", nil)
                                                        delegate:self
                                               cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
                [alertReRecord show];
            });
        }
    }
    if (playRecord && !muteYoutube){
        if (playVideoRecorded) {
            if ((fabs(CMTimeGetSeconds([audioPlayer currentTime])-[youtubePlayer currentTime]-[songRec.delay doubleValue]/1000) > intervalRender*2 ) &&(fabs(CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([self playerItemDuration2]))) > 4 && ([youtubePlayer currentTime]+[songRec.delay doubleValue]/1000)>0 && [youtubePlayer currentTime]>0&& CMTimeGetSeconds([audioPlayer currentTime])>0 ) {
                //[audioPlayRecorder pause];
                //[youtubePlayer pauseVideo];
                ///if ([songRec.delay doubleValue]>0){
                [audioPlayer seekToTime:CMTimeMakeWithSeconds([youtubePlayer currentTime]+[songRec.delay doubleValue]/1000, NSEC_PER_SEC)];
                
                //  audioPlayRecorder.currentTime=[youtubePlayer currentTime]+[songRec.delay doubleValue]/1000.0f;
              //  NSLog(@"Dong bo %f  player video %f",[youtubePlayer currentTime]+[songRec.delay doubleValue]/1000.0f,CMTimeGetSeconds([audioPlayer currentTime]));
                //[self performSelector:@selector(dongBoPlayer) withObject:nil afterDelay:0.5];
            }
        }else
            if ((fabs(audioPlayRecorder.currentTime-[youtubePlayer currentTime]-[songRec.delay doubleValue]/1000) > intervalRender*2 ) &&(fabs(audioPlayRecorder.currentTime-audioPlayRecorder.duration)) > 4 && ([youtubePlayer currentTime]+[songRec.delay doubleValue]/1000)>0 && [youtubePlayer currentTime]>0&& audioPlayRecorder.currentTime>0 && [youtubePlayer currentTime]+[songRec.delay doubleValue]/1000.0f<audioPlayRecorder.duration) {
                //[audioPlayRecorder pause];
                //[youtubePlayer pauseVideo];
                
                audioPlayRecorder.currentTime=[youtubePlayer currentTime]+[songRec.delay doubleValue]/1000.0f;
                //NSLog(@"Dong bo %f  player %f",[youtubePlayer currentTime]+[songRec.delay doubleValue]/1000.0f,audioPlayRecorder.currentTime);
                //[self performSelector:@selector(dongBoPlayer) withObject:nil afterDelay:0.5];
            }
    }
    double time = playTime;
    
    if (isrecord && !videoRecord && youtubePlayer.playerState==kYTPlayerStatePlaying && time>3&& time<10){
        //CACurrentMediaTime()
        delayRec=audioEngine2.recorder.currentTime-youtubePlayer.currentTime;
        
        //NSLog(@"delay youtube check 2 %f",delayRec);
        //timeRecord=0;
    }
}

- (void) dongBoPlayer{
    [youtubePlayer playVideo];
    [audioPlayRecorder play];
    
}
-(void)getAudioFromVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingLabelVip.text=[NSString stringWithFormat:@"Trích xuất audio"];
    });
    float startTime = 0;
    float endTime =CMTimeGetSeconds( [self playerItemDuration2]);
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *audioPath = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
    
    NSString *     path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
    AVAsset *myasset;
    if (self.recordSession) {
        myasset = self.recordSession.assetRepresentingSegments;
    }else
    myasset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    AVAssetExportSession *exportSession=[AVAssetExportSession exportSessionWithAsset:myasset presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL=[NSURL fileURLWithPath:audioPath];
    exportSession.outputFileType=AVFileTypeAppleM4A;
    
    CMTime vocalStartMarker = CMTimeMake((int)(floor(startTime * 100)), 100);
    CMTime vocalEndMarker = CMTimeMake((int)(ceil(endTime * 100)), 100);
    
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(vocalStartMarker, vocalEndMarker);
    exportSession.timeRange= exportTimeRange;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
    }
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status==AVAssetExportSessionStatusFailed) {
            NSLog(@"failed");
        }
        else {
            NSLog(@"AudioLocation : %@",audioPath);
            NSString *typeKey=@".m4a";
            NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:audioPath error:nil];
            unsigned long long filesize=[fileinfo fileSize];
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:audioPath];
            if (haveS && filesize>1000) {
                
                NSData *dataF=[NSData dataWithContentsOfFile:audioPath];
                
                NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
                songRec.mixedRecordingVideoUrl=nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    songRec->isUploading=YES;
                    self.loadingLabelVip.text=[NSString stringWithFormat:@"Gửi audio lên server"];
                 
                });
                percent=0;
                songRec.onlineVoiceUrl=[[UploadToServerYokara alloc] multipartUpload:audioPath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                if (songRec.onlineVoiceUrl.length>3){
                    if (![songRec.onlineVoiceUrl hasPrefix:@"http://data"])
                    {
                        percent=0;
                        songRec.onlineVoiceUrl=[[UploadToServerYokara alloc] multipartUpload:audioPath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                        
                    }
                }else{
                    percent=0;
                    songRec.onlineVoiceUrl=[[UploadToServerYokara alloc] multipartUpload:audioPath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                }
                if (songRec.onlineVoiceUrl.length>3){
                    if (![songRec.onlineVoiceUrl hasPrefix:@"http://data"])
                    {
                        percent=0;
                        songRec.onlineVoiceUrl=[[UploadToServerYokara alloc] multipartUpload:audioPath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                        
                    }
                }else{
                    percent=0;
                    songRec.onlineVoiceUrl=[[UploadToServerYokara alloc] multipartUpload:audioPath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                }
               
                if (songRec.onlineVoiceUrl.length>10) {
                    [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineVoiceUrl" fieldValue1:songRec.onlineVoiceUrl withCondition:R_DATE conditionValue:songRec.recordingTime];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        songRec->isUploading=NO;
                        self.loadingLabelVip.text=[NSString stringWithFormat:@"Chuẩn bị giao diện"];
                    });
                    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                    
                    dispatch_async(queue, ^{
                         dispatch_async(dispatch_get_main_queue(), ^{
                        
                    
                        [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.5];
                        [NSThread detachNewThreadSelector:@selector(processDataAudio) toTarget:self withObject:nil];
                      
                        [self performSelector:@selector(sendCREATSTREAM) withObject:nil afterDelay:0];
                       
                        if (doNothingStreamTimer==nil) {
                            doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
                        }
                             });
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        songRec->isUploading=NO;
                        self.loadingLabelVip.text=[NSString stringWithFormat:@"Đã xảy ra lỗi khi upload"];
                    });
                }
            }
        }
    }];
}

NSString * streamServer;
- (void) configeDBStreamStatus{
    self.ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    
    NSString *url1=[NSString stringWithFormat: @"ikara/streams/%@",streamName];
    
    self.refHandle= [[self.ref child:url1] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSDictionary<NSString *, id > *streamdict = snapshot.value;
            
            StreamFirebase * stream=[StreamFirebase new];
            stream.offsetPosition=streamdict[@"offsetPosition"];
            stream.status=streamdict[@"status"];
            stream.message=streamdict[@"message"];
            stream.duration=streamdict[@"duration"];
            NSLog(@"streamfirebase status %@ offset %@ duration %@",stream.status,stream.offsetPosition,stream.duration);
            offsetPositionStream=[stream.offsetPosition longValue];
            if ([stream.duration longValue]) {
                streamDuration=[stream.duration longValue];
            }
            if (stream.message.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.loadingLabelVip.text=stream.message;
                });
            }
            if ([stream.status isEqualToString:@"READY"] && [stream.duration longValue]>0) {
              
                            streamIsPlay=YES;
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loadingViewVIP.hidden=YES;
                    self.loadingViewVIP2.hidden=YES;
                    self.isLoading.center=self.playerLayerView.center;
                   
                    if (demperc) {
                        [demperc invalidate];
                        demperc=nil;
                    }
                });
                //vitriupload=99999999;
                
            }else
                if ([stream.status isEqualToString:@"PLAYING"]) {
                    //[[self.ref child:url1] removeAllObservers];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.loadingViewVIP.hidden=YES;
                        self.loadingViewVIP2.hidden=YES;
                       
                        if (demperc) {
                            [demperc invalidate];
                            demperc=nil;
                        }
                    });
                    
                    //vitriupload=99999999;
                    
                }else  if ([stream.status isEqualToString:@"PAUSE"]) {
                    
                }else{
                    
                    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                    dispatch_async(queue, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                        });
                    });
                }
        }else{
            
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }
        
    }];
    
    
}
- (void) dempercen{
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[self.xulyButt setTitle:AMLocalizedString(@"Hủy",nil) forState:UIControlStateNormal];
            if (songRec->isUploading) {
                
                self.loadingLabelVip.text=[NSString stringWithFormat:@"%@ %d%%",AMLocalizedString(@"Đang upload bài thu", nil), [[NSNumber numberWithFloat:percent] intValue]];
                
            }else
            {
                
            }
        });
    }
}
- (void) loadStream{
    @autoreleasepool{
       // if ([songRec.recordingType isEqualToString:@"AUDIO"]) {
        
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loadingViewVIP.hidden=NO;
            self.loadingViewVIP.backgroundColor=[UIColor colorWithRed:55/255.0 green:64/255.0 blue:81/255.0 alpha:0.69];
            self.loadingViewVIP2.hidden=NO;
          
            self.loadingLabelVip.text=[NSString stringWithFormat:@"Chuẩn bị giao diện"];
            demperc= [NSTimer
                      
                      
                      scheduledTimerWithTimeInterval:1
                      target:self
                      selector:@selector(dempercen)
                      userInfo:nil
                      repeats:YES];
        });
         
        /* FIRDatabaseReference * ref = [[FIRDatabase database] reference];
         bgTask= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
         // Clean up any unfinished task business by marking where you
         // stopped or ending the task outright.
         [[UIApplication sharedApplication] endBackgroundTask:bgTask];
         bgTask = UIBackgroundTaskInvalid;
         }];
         
         // Start the long-running task and return immediately.
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{*/
       // [NSThread detachNewThreadSelector:@selector(processMixOffline) toTarget:self withObject:nil];
         if (songRec.onlineVoiceUrl.length>15 ) {
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            
            dispatch_async(queue, ^{
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.5];
                [NSThread detachNewThreadSelector:@selector(processDataAudio) toTarget:self withObject:nil];
                
                [self performSelector:@selector(sendCREATSTREAM) withObject:nil afterDelay:0];
          
                if (doNothingStreamTimer==nil) {
                    doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
                }
                     });
            });
         }else if (songRec.onlineVocalUrl.length>15) {
            // dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
             
            // dispatch_async(queue, ^{
             
              dispatch_async(dispatch_get_main_queue(), ^{
       
               
                 [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.5];
                 [NSThread detachNewThreadSelector:@selector(processDataAudio) toTarget:self withObject:nil];
                
            // [self sendCREATSTREAM];
                 [self performSelector:@selector(sendCREATSTREAM) withObject:nil afterDelay:0];
                
                 if (doNothingStreamTimer==nil) {
                     doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
                 }
             });
         }else{
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath;
            NSString *typeKey=@".m4a";
            
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
             NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
             unsigned long long filesize=[fileinfo fileSize];
             BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
           
            if (([songRec.vocalUrl hasSuffix:@"mov"] || [songRec.recordingType isEqualToString:@"VIDEO"])&& !(haveS && filesize>1000)){
                dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                
                dispatch_async(queue, ^{
                    
                    
                              [self getAudioFromVideo];
                    
                    
                });
              
            }else{
                
                NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                unsigned long long filesize=[fileinfo fileSize];
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if (haveS && filesize>1000) {
                    NSData *dataF=[NSData dataWithContentsOfFile:filePath];
                    
                    
                    //  [[UploadS3 alloc] upload:dataF inBucket:@"ikara" forKey:[NSString stringWithFormat:@"recordings/%@.m4a",GUID ]];
                    /*
                     if (filesize>90000000){
                     [[UploadS3 alloc] upload:dataF inBucket:@"ikara" forKey:[NSString stringWithFormat:@"recordings/%@%@",GUID,typeKey ]];
                     
                     if (percent==100) {
                     tmp.onlineVocalUrl=[NSString stringWithFormat:@"https://ikara.s3.amazonaws.com/recordings/%@%@",GUID,typeKey ];
                     [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineVocalUrl" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                     }
                     }else{*/
                    dispatch_async(dispatch_get_main_queue(), ^{
                        songRec->isUploading=YES;
                        self.loadingLabelVip.text=[NSString stringWithFormat:@"Upload audio"];
                    });
                    NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
                    songRec.mixedRecordingVideoUrl=nil;
                    songRec.onlineVocalUrl=[[UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                    if (songRec.onlineVocalUrl.length>3){
                        if (![songRec.onlineVocalUrl hasPrefix:@"http://data"])
                        {
                            percent=0;
                           songRec.onlineVocalUrl=[[UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                            
                        }
                    }else{
                        percent=0;
                        songRec.onlineVocalUrl=[[UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                    }
                    if (songRec.onlineVocalUrl.length>3){
                        if (![songRec.onlineVocalUrl hasPrefix:@"http://data"])
                        {
                            percent=0;
                            songRec.onlineVocalUrl=[[UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                            
                        }
                    }else{
                        percent=0;
                        songRec.onlineVocalUrl=[[UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                    }
                    
                    [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineVocalUrl" fieldValue1:songRec.onlineVocalUrl withCondition:R_DATE conditionValue:songRec.recordingTime];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        songRec->isUploading=NO;
                        self.loadingLabelVip.text=[NSString stringWithFormat:@"Chuẩn bị giao diện"];
                    });
                    if (songRec.onlineVocalUrl.length>10){
                    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                    
                    dispatch_async(queue, ^{
                         dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.5];
                        [NSThread detachNewThreadSelector:@selector(processDataAudio) toTarget:self withObject:nil];
                      
                        [self performSelector:@selector(sendCREATSTREAM) withObject:nil afterDelay:0];
                       
                        if (doNothingStreamTimer==nil) {
                            doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
                        }
                              });
                    });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            songRec->isUploading=NO;
                            self.loadingLabelVip.text=[NSString stringWithFormat:@"Đã xảy ra lỗi khi upload"];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.loadingViewVIP.hidden=YES;
                        self.loadingViewVIP2.hidden=YES;
                       
                        if (demperc) {
                            [demperc invalidate];
                            demperc=nil;
                        }
                    });
                }
            }
            
            
        }
        
        //  });
        
    }
    
}
- (void) doNoThingStream{
    @autoreleasepool{
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
        
        dispatch_async(queue, ^{
            if (streamSVIsConnect) {
                [self sendDoNothingStream];
            }
            
            //[[LoadData2 alloc] DoNoThingStream:streamName andSV:streamSV];
        });
        
    }
}
- (void) playYoutube{
    
    
    //[youtubePlayer playVideo];
    /*if ((UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) && videoRecord)||  !videoRecord){
        if (playVideoRecorded && playRecord) {
            [youtubePlayer loadVideoById:songPlay.videoId startSeconds:0.0f suggestedQuality:kYTPlaybackQualitySmall];  // Force awful quality at start
        }else
            [youtubePlayer loadVideoById:songPlay.videoId startSeconds:0.0f suggestedQuality:[videoQuality integerValue]];  // Force awful quality at start
    }*/
    
    if (isrecord) {
        NSLog(@"isrecord");
        //[playerMain play];
        if (isObser==NO){
            if (isKaraokeTab){
                
                
                //  if (startRecord){
                NSLog(@"thu_am");
                //////timeRecord=CACurrentMediaTime();
                /* if ((UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) && videoRecord) ) {
                 [self record];
                 startRecord=YES;
                 }else{*/
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // self.warningVideoRecord.hidden=NO;
                    [self showPlayButton];
                });
              
                // if ( checkStartRecordTimer==nil)
                //   checkStartRecordTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkStartRecord) userInfo:nil repeats:YES];
                //}
                isObser=YES;
                
                
            }
            
        }
        [self creatAudioEngine];
        if (audioEngine2.audioController.running==NO) {
            NSError* error;
            
            [audioEngine2.audioController start:&error];
        }
        if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2 ) {
            [audioEngine2 playthroughSwitchChanged:YES];
            [audioEngine2 reverbSwitchChanged:YES];
            [audioEngine2 expanderSwitchChanged:YES];
        }
    }else
        if (playRecord){
            if (!VipMember) {
               
                    [audioPlayer play];
                
            }
            
            //[playerMain play];
            
            
            if (isVoice && audioEngine2) {[audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
                [audioEngine2 expanderSwitchChanged:NO];
            }
        }else if ((playTopRec||playRecUpload) &&!playVideoRecorded && [Language hasSuffix:@"kara"]) {
            // if (audioPlayer)
            
            
            if (timeRestore!=0){
                /////  [playerView seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
                [audioPlayer seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
               
                timeRestore=0;
            }
            // [playerMain play];
            // [audioPlayer play];
            if (isVoice && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
                [audioEngine2 expanderSwitchChanged:NO];
            }
        }else{
            
            // while(playerMain.status!=AVPlayerStatusReadyToPlay){
            
            
            
            if (timeRestore!=0){
                //// [playerView seekToTime:CMTimeMakeWithSeconds(timeRestore, NSEC_PER_SEC)];
                timeRestore=0;
            }
            [self creatAudioEngine];
            if (audioEngine2.audioController.running==NO) {
                NSError* error;
                
                [audioEngine2.audioController start:&error];
            }
            if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:YES];
                [audioEngine2 reverbSwitchChanged:YES];
                [audioEngine2 expanderSwitchChanged:YES];
            }
            
        }
    [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
    isPlayingAu=YES;
}
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
        if (isKaraokeTab){
        if ([songRec.performanceType isEqualToString:@"DUET" ] || [songRec.performanceType isEqualToString:@"ASK4DUET"] ) {
            if (!_lyricView) {
                [self loadLyricDuet];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (playRecord) {
                self.xulyView.hidden=NO;
                if (![songRec->hasUpload isEqualToString:@"YES"]  && playVideoRecorded) {
                    self.colectionView.hidden=NO;
                }else{
                    self.colectionView.hidden=YES;
                }
            }
            else self.xulyView.hidden=YES;
        });
        double duration = playerView.duration;
        if (  (playRecord && playVideoRecorded) && audioPlayer && !isrecord  ){
            duration=CMTimeGetSeconds([self playerItemDuration2]);
            
        }else if (playRecord && !playVideoRecorded){
            duration=audioPlayRecorder.duration;
            
        }
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
            //interval = 0.2f ;//* duration / width;
        }
        
        
        
        if ((playTopRec || playRecUpload )&& duration>60 && arrayIncreaseView.count==0){
            arrayIncreaseView=[NSMutableArray new];
            
            NSInteger soPT=duration /10;
            for (int i=0;i<soPT; i++){
                [arrayIncreaseView addObject:[NSNumber numberWithInt:0]];
            }
        }
        // if ( checkPlaying==nil)
        //   checkPlaying=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkPlaying1) userInfo:nil repeats:YES];
        [self enableScrubber];
        [self enablePlayerButtons];
    }
    
    // [self playYoutube];
    if (isrecord   && !isRecorded  ) {
        // [self checkStartRecord];
        if (startRecordDem==0) {
            [self playYoutube];
             [youtubePlayer playVideo];
        }
    }else
    [self performSelector:@selector(playYoutube) withObject:nil afterDelay:0];
    
}
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            seekToZeroBeforePlay = NO;
            if ([songRec.performanceType isEqualToString:@"DUET"]) {
               // [youtubePlayer setMute:NO];
            }
            videoQualityList=[NSMutableArray arrayWithArray: youtubePlayer.availableQualityLevels];
           // [self.menuLyric reloadData];
            float playthroughVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"playthroghVolume"];
            float micoEchoVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"EchoVolume"];
            if (playthroughVolume>0 && audioEngine2) {
                [audioEngine2 setPlaythroughVolume:playthroughVolume];
            }
            if (micoEchoVolume>0 && micoEchoVolume<101 && audioEngine2) {
                [audioEngine2 setEchoVolume:micoEchoVolume];
            }
            [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
            if (isrecord && !videoRecord) [self record];
            //  if (isrecord &&( !videoRecord || [songRec.performanceType isEqualToString:@"DUET"])) [self record];
            NSLog(@"Ready youtube %f",timeRecord);
            self.recordToolbarVoiceVolumeSlider.value=[audioEngine2 getPlaythroughVolume];
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
            break;
        case kYTPlayerStateEnded:
            seekToZeroBeforePlay = YES;
            isPlayingAu=NO;
            
            
            
            [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
            if (isVoice && audioEngine2) {
                [audioEngine2 reverbSwitchChanged:NO];
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 expanderSwitchChanged:NO];
            }
            
            isLoading.hidden=YES;
            [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
            
            if (isrecord) [self record];
            
            break;
        default:
            break;
    }
}
- (void) loadYoutubeVieo:(NSString *) videoId{
    @autoreleasepool {
        
        if (isTabKaraoke) isKaraokeTab=YES;
        NSString * content=[[LoadData2 alloc] getUrlWithYoutubeVideoId:videoId];
        //  songPlay.songUrl=urlSong;
        // [playerYoutube prepareToPlay];
        //  playerYoutube.view.frame = CGRectMake(0, 0, 350, 350);
        /*
         NSMutableDictionary *parts = [content dictionaryFromQueryStringComponents];
         
         if (parts) {
         NSString *fmtStreamMapString = [[parts objectForKey:@"url_encoded_fmt_stream_map"] objectAtIndex:0];
         NSLog(@"stream_map:\"%@\"",fmtStreamMapString);
         //  [NSThread detachNewThreadSelector:@selector(getYoutubeVideolink:) toTarget:self withObject:fmtStreamMapString];@"(stream_map\": \"(.*?)?\")"
         }*/
        if (content.length>0) {
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:nil];
            [regex enumerateMatchesInString:content options:0 range:NSMakeRange(0, [content length]) usingBlock:
             ^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                 NSRange range = [match rangeAtIndex:1]; // range of string in first parens
                 NSString* oneWord = [content substringWithRange:range];
                 if (oneWord.length>0)
                     [NSThread detachNewThreadSelector:@selector(getYoutubeVideolink:) toTarget:self withObject:oneWord];
             }
             ];
            
        }
    }
}
- (void) getYoutubeVideolink:(NSString *) content{
    @autoreleasepool {
        
        
        GetYoutubeVideoLinksResponse *responeVideo=[[LoadData2 alloc] getYoutubeVideoLinks:songPlay.videoId andContent:content];
        if (!responeVideo) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:AMLocalizedString(@"error when load video", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }else{
            NSString *videoQua=@"720p";
            
            NSString *urlSo;
            videoYoutubeDictionary=[NSMutableDictionary new];
            for (Video * videoTmp in responeVideo.links){
                // Video *videoTmp= [responeVideo.links objectAtIndex:i];
                
                if (videoTmp && ![videoTmp isKindOfClass:[NSNull class]])
                {
                    if (videoTmp.ext && videoTmp.def){
                        NSString *ext=[NSString stringWithFormat:@"%@",videoTmp.ext];
                        NSString *def=[NSString stringWithFormat:@"%@",videoTmp.def];
                        if ([ext isEqualToString:@"MP4"] && [def isEqualToString:@"240p"] && videoTmp.url) {
                            urlSo=[NSString stringWithFormat:@"%@", videoTmp.url ];
                            [videoYoutubeDictionary setObject:urlSo forKey:@"small"];
                        }else if ([ext isEqualToString:@"MP4"] && ([def isEqualToString:@"480p"] || [def isEqualToString:@"360p"]) && videoTmp.url) {
                            urlSo=[NSString stringWithFormat:@"%@", videoTmp.url ];
                            [videoYoutubeDictionary setObject:urlSo forKey:@"medium"];
                        }else if ([ext isEqualToString:@"MP4"] && [def isEqualToString:@"720p"] && videoTmp.url) {
                            urlSo=[NSString stringWithFormat:@"%@", videoTmp.url ];
                            [videoYoutubeDictionary setObject:urlSo forKey:@"hd720"];
                        }
                    }
                }
            }
            if (urlSo) {
                if ([urlSo hasPrefix:@"http:"]){
                    
                    [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSo];
                    
                }
                else{
                    urlSo=[videoYoutubeDictionary objectForKey:@"small"];
                    if (!urlSo) urlSo=[videoYoutubeDictionary objectForKey:@"medium"];
                    if (!urlSo) urlSo=[videoYoutubeDictionary objectForKey:@"hd720"];
                    [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSo];
                }
            }else{
                urlSo=[videoYoutubeDictionary objectForKey:@"small"];
                if (!urlSo) urlSo=[videoYoutubeDictionary objectForKey:@"medium"];
                if (!urlSo) urlSo=[videoYoutubeDictionary objectForKey:@"hd720"];
                [NSThread detachNewThreadSelector:@selector(loadMovi:) toTarget:self withObject:urlSo];
            }
            
        }
    }
}
- (BOOL) checkDuration:(NSNumber *) duration{
    
    return NO;
}
- (void) showPopover:(id)sender withImage:(UIImage *) image andMessage:(NSString* ) message{
    if ([[LoadData2 alloc] checkNetwork]){
        SAFE_ARC_RELEASE(popover); popover=nil;
        UIViewController * controller=[[UIViewController alloc] init];
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(5, 70, 300, 60)];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        
        label.numberOfLines=3;
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 60, 60)];
        imageView.image=image;
        [controller.view setFrame:CGRectMake(0, 0, 300, 150)];
        
        
        label.text=message;
        [controller.view addSubview:imageView];
        [controller.view addSubview:label];
        popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
        popover.tint = FPPopoverWhiteTint;
        popover.keyboardHeight = _keyboardHeight;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            popover.contentSize = CGSizeMake(320, 160);
        }
        else {
            popover.contentSize = CGSizeMake(320, 160);
        }
        //sender is the UIButton view
        popover.arrowDirection = FPPopoverArrowDirectionUp;
        [popover presentPopoverFromView:sender];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void) showPopover:(id)sender andMessage:(NSString* ) message{
    if ([[LoadData2 alloc] checkNetwork]){
        SAFE_ARC_RELEASE(popover); popover=nil;
        UIViewController * controller=[[UIViewController alloc] init];
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 260, 70)];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        label.numberOfLines=4;
        
        
        [controller.view setFrame:CGRectMake(0, 0, 260, 70)];
        
        
        label.text=message;
        [controller.view addSubview:label];
        popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
        popover.tint = FPPopoverWhiteTint;
        popover.keyboardHeight = _keyboardHeight;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            popover.contentSize = CGSizeMake(300, 90);
        }
        else {
            popover.contentSize = CGSizeMake(300, 90);
        }
        //sender is the UIButton view
        popover.arrowDirection = FPPopoverArrowDirectionRight;
        [popover presentPopoverFromView:sender];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (IBAction)getInfoTangDelay:(id)sender {
    
    [self showPopover:sender withImage:[UIImage imageNamed:@"loi_cham.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] andMessage:AMLocalizedString(@"Nếu lời hát của bạn chậm hơn nhạc nền hãy nhấn nút này để lời nhanh lên cho đến khi lời và nhạc khớp nhau", nil)];
    
}
- (IBAction)getInfoGiamDelay:(id)sender {
    [self showPopover:sender withImage:[UIImage imageNamed:@"loi_nhanh.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] andMessage:AMLocalizedString(@"Nếu lời hát của bạn nhanh hơn nhạc nền hãy nhấn nút này để lời chậm lại cho đến khi lời và nhạc khớp nhau", nil)];
}
- (IBAction)getInfoAmNhacNen:(id)sender {
    [self showPopover:sender andMessage:AMLocalizedString(@"Nếu bạn thu âm không sử dụng tai nghe hãy chỉnh âm lượng nhạc nền về 0 để tránh tình trạng có 2 nhạc nền cùng phát.", nil)];
}
- (IBAction)getInfoAmVoice:(id)sender {
    [self showPopover:sender andMessage:AMLocalizedString(@"Nếu giọng hát của bạn quá to so với nhạc hãy giảm âm lượng của giọng hát xuống", nil)];
}
- (IBAction)getInfoEcho:(id)sender {
    [self showPopover:sender andMessage:AMLocalizedString(@"Tiếng vang chỉ có hiệu lực sau khi bài hát được xử lý trên máy chủ. Sau khi xử lý xong, bạn vẫn có thể chỉnh sửa thông số này để máy chủ xử lý lại", nil)];
}
- (IBAction)getInfoTreble:(id)sender {
    [self showPopover:sender andMessage:AMLocalizedString(@"Âm bổng chỉ có hiệu lực sau khi bài hát được xử lý trên máy chủ. Sau khi xử lý xong, bạn vẫn có thể chỉnh sửa thông số này để máy chủ xử lý lại", nil)];
}
- (IBAction)getInfoBass:(id)sender {
    [self showPopover:sender andMessage:AMLocalizedString(@"Âm trầm chỉ có hiệu lực sau khi bài hát được xử lý trên máy chủ. Sau khi xử lý xong, bạn vẫn có thể chỉnh sửa thông số này để máy chủ xử lý lại", nil)];
}
- (IBAction)delayRulerChange:(id)sender {
    songRec.delay=[NSNumber numberWithInt:self.rulerDelay.value];
    songRec.effectsNew.delay=songRec.delay;
    self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else
        if (playRecord ) {
            if (playVideoRecorded && audioPlayer){
              
                if (VipMember && playRecord  ) {
                    
                    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                }
            }
            else {audioPlayRecorder.currentTime=CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue]/1000;
                if (VipMember && playRecord  ) {
                    
                    [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
                }
            }
            
        }
    
}
- (IBAction)hintGiamDelay:(id)sender {
}
- (IBAction)giamDeplay:(id)sender {
    // if ([songRec->hasUpload isEqualToString:@"YES"]) {
    NSLog(@"delay %d",[songRec.delay intValue]);
    songRec.delay=[NSNumber numberWithInt:[songRec.delay intValue]-30];
    songRec.effectsNew.delay=songRec.delay;
    self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
    
    NSLog(@"delay %d",[songRec.delay intValue]);
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }
   else
    [_audioTapProcessor setDelay:[songRec.delay intValue] ];
    /*
     }else{
     
     songRec.delay=[NSNumber numberWithFloat:[songRec.delay floatValue]-0.05];
     if (playRecord ) {
     if (playVideoRecorded && audioPlayer)
     [audioPlayer seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue], NSEC_PER_SEC)];
     else audioPlayRecorder.currentTime=CMTimeGetSeconds([playerMain currentTime])+[songRec.delay doubleValue];
     }
     self.deplayLabel.text=[NSString stringWithFormat:@"%d",(int)([songRec.delay floatValue]*1000)];
     }*/
    
}
- (IBAction)hintTangDelay:(id)sender {
}
- (IBAction)tangDeplay:(id)sender {
    // if ([songRec->hasUpload isEqualToString:@"YES"]) {
    NSLog(@"delay %d",[songRec.delay intValue]);
    songRec.delay=[NSNumber numberWithInt:[songRec.delay intValue]+30];
    
    songRec.effectsNew.delay=songRec.delay;
    self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
    
    NSLog(@"delay %d",[songRec.delay intValue]);
    if (VipMember  ) {
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else
   [_audioTapProcessor setDelay:[songRec.delay intValue] ];
   
}

- (void) loadOneLyric{
    @autoreleasepool {
        Lyric * lyr=[Lyric new];
        if ([songRec.performanceType isEqualToString:@"ASK4DUET"] || [songRec.performanceType isEqualToString:@"DUET"]) {
            lyr=songRec.lyric;
            if (![lyr isKindOfClass:[Lyric class]]) {
                lyr=[Lyric new];
                lyr.key=songRec.selectedLyric;
                if (lyr.key.length>0) {
                    lyr.type=[NSNumber numberWithInt:XML];
                    NSString* lyricJson=[[NSUserDefaults standardUserDefaults] objectForKey:lyr.key];
                    if (lyricJson.length>4) {
                        lyr.content=lyricJson;
                        if ([songRec.performanceType isEqualToString:@"ASK4DUET"] && ![songRec.lyric isKindOfClass:[Lyric class]]) {
                            songRec.lyric=lyr;
                        }
                    }
                    
                    
                }
                
                
                
            }
            if ([lyr.type integerValue]!=XML) {
                lyr.type=@1;
            }
            if (lyr.content.length<10) {
                GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                lyr.content=lyricRespone.content;
            }
        }else
            if (isDownload ) {
                lyr=[[DBHelperYokaraSDK alloc]loadLyric:[NSString stringWithFormat:@"%@", songPlay._id ]];
                // songPlay.lyrics = [NSMutableArray new];
                
                if (lyr.content.length<10) {
                    if (songPlay.lyrics==nil || songPlay.lyrics.count==0){
                        songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                        lyr=songs.song.lyrics[0];
                    }else{
                        lyr=songPlay.lyrics[0];
                        if ([lyr.type integerValue]!=XML) {
                            songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                            lyr=songs.song.lyrics[0];
                        }
                    }
                    if (lyr.content.length<10) {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                        lyr.content=lyricRespone.content;
                    }
                }
                if ([lyr.privatedId integerValue]==0 ){
                    tieude=[NSString stringWithFormat:@"%@",songPlay.songName];
                }
                else{
                    tieude=[NSString stringWithFormat:@"%@ - %@: %@",songPlay.songName,AMLocalizedString(@"Lời", @"Lời"),lyr.privatedId];
                }
                showSongName.text=tieude;
                self.titleName.text=tieude;
            }else{
                
                if ([[LoadData2 alloc] checkNetwork]) {
                    //   songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                    
                    // lyric = [self getLyric:@"http://www.ikara.vn/test/getlyric?lyrickey=aglzfmlrYXJhNG1yDQsSBUx5cmljGIKcBww"];
                    
                    //  CGFloat ratemax = -1;
                    
                    if (!playRecord || ![songRec.performanceType isEqualToString:@"SOLO"]){
                        if (songPlay.lyrics==nil || songPlay.lyrics.count==0){
                            songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                            CGFloat ratemax = -1;
                            for (Lyric *lyric in songs.song.lyrics) {
                                ///  NSString *list=[NSString stringWithFormat:@"MS: %@",lyric.privatedId];
                                
                                
                                
                                if ([lyric.key isEqualToString:songPlay.approvedLyric]) {
                                    lyr = lyric;
                                    break;
                                }
                                int avgrate;
                                if ([lyric.ratingCount intValue]==0) avgrate=3;
                                else avgrate=[lyric.totalRating intValue]/[lyric.ratingCount intValue] ;
                                if (avgrate > ratemax && [lyric.type integerValue]==XML && [lyric.key isKindOfClass:[NSString class]]) {
                                    lyr = lyric;
                                    ratemax = avgrate;
                                }
                                
                            }
                        }else{
                            lyr=songPlay.lyrics[0];
                            if ([lyr.type integerValue]!=XML) {
                                songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                                CGFloat ratemax = -1;
                                for (Lyric *lyric in songs.song.lyrics) {
                                    
                                    
                                    
                                    int avgrate;
                                    if ([lyric.ratingCount intValue]==0) avgrate=3;
                                    else avgrate=[lyric.totalRating intValue]/[lyric.ratingCount intValue] ;
                                    if (avgrate > ratemax && [lyric.type integerValue]==XML && [lyric.key isKindOfClass:[NSString class]]) {
                                        lyr = lyric;
                                        ratemax = avgrate;
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        if (lyr.content.length<10) {
                            GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                            lyr.content=lyricRespone.content;
                        }
                        
                    }else {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:songRec.selectedLyric];
                        lyr.content=lyricRespone.content;
                        if (![lyr.content isKindOfClass:[NSNull class]]){
                            if ([lyr.content hasPrefix:@"{"]){
                                lyr.type=[NSNumber numberWithInt:XML];
                            }else{
                                lyr.type=[NSNumber numberWithInt:PLAINTEXT];
                            }
                        }
                    }
                }
                
            }
        if (isrecord) {
            songPlay.selectedLyric=lyr.key;
            songRec.selectedLyric=lyr.key;
        }
        tieude=[NSString stringWithFormat:@"%@ - %@: %d",songPlay.songName,AMLocalizedString(@"Lời", nil),[lyr.privatedId integerValue]];
        
        showSongName.text=tieude;
        self.titleName.text=tieude;
        // Lyric * lyr=[songs.song.lyrics objectAtIndex:0];
        if ([lyr.type intValue] == PLAINTEXT && [lyr isKindOfClass:[Lyric class]]) {
            
            
            contentPlaintext= lyr.content;
            
            karaokeDisplayElement.hidden=YES;
            self.showplainText.hidden=NO;
            [self.showplainText performSelectorOnMainThread:@selector(setText:) withObject:contentPlaintext waitUntilDone:NO];
            showPlain = YES;
        }
        
        else {
            showPlain=NO;
            self.showplainText.hidden=YES;
            karaokeDisplayElement.hidden=NO;
            
            
            NSString *lyricInXml;
            if (isDownload) {
                lyricInXml = lyr.content;
            }
            else
                lyricInXml = lyr.content;
            lyric = [self getLyric:lyricInXml];
            // lyric=nil;
            if (lyric  && ![Language hasSuffix:@"kara"]) {
                [self performSelectorOnMainThread:@selector(updateLyric) withObject:nil waitUntilDone:NO];
            }else if (!lyric){
                if ([songRec.performanceType isEqualToString:@"ASK4DUET"] || [songRec.performanceType isEqualToString:@"DUET"]) {
                    lyr=songRec.lyric;
                    if (![lyr isKindOfClass:[Lyric class]]) {
                        lyr=[Lyric new];
                        lyr.key=songRec.selectedLyric;
                        if (lyr.key.length>0) {
                            lyr.type=[NSNumber numberWithInt:XML];
                            NSString* lyricJson=[[NSUserDefaults standardUserDefaults] objectForKey:lyr.key];
                            if (lyricJson.length>4) {
                                lyr.content=lyricJson;
                                if ([songRec.performanceType isEqualToString:@"ASK4DUET"] && ![songRec.lyric isKindOfClass:[Lyric class]]) {
                                    songRec.lyric=lyr;
                                }
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    if ([lyr.type integerValue]!=XML) {
                        lyr.type=@1;
                    }
                    if (lyr.content.length<10) {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                        lyr.content=lyricRespone.content;
                    }
                }else{
                    songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                    NSString * lyricTemp=lyr.key;
                    CGFloat ratemax = -1;
                    for (Lyric *lyric in songs.song.lyrics) {
                        ///  NSString *list=[NSString stringWithFormat:@"MS: %@",lyric.privatedId];
                        
                        
                        if ([lyricTemp isKindOfClass:[NSString class]]  && [lyric.key isKindOfClass:[NSString class]]) {
                            if ([lyric.key isEqualToString:songPlay.approvedLyric] && ![lyric.key isEqualToString:lyricTemp]) {
                                lyr = lyric;
                                break;
                            }
                            
                        }
                        int avgrate;
                        if ([lyric.ratingCount intValue]==0) avgrate=3;
                        else avgrate=[lyric.totalRating intValue]/[lyric.ratingCount intValue] ;
                        if ([lyricTemp isKindOfClass:[NSString class]]) {
                            if (avgrate > ratemax && [lyric.type integerValue]==XML && [lyric.key isKindOfClass:[NSString class]] ) {
                                if (![lyric.key isEqualToString:lyricTemp]) {
                                    lyr = lyric;
                                    ratemax = avgrate;
                                }
                                
                            }
                        }else{
                            if (avgrate > ratemax && [lyric.type integerValue]==XML && [lyric.key isKindOfClass:[NSString class]]) {
                                lyr = lyric;
                                ratemax = avgrate;
                            }
                        }
                    }
                    if (lyr.content.length<10) {
                        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                        lyr.content=lyricRespone.content;
                    }
                }
                if (isrecord) {
                    songPlay.selectedLyric=lyr.key;
                    songRec.selectedLyric=lyr.key;
                }
                tieude=[NSString stringWithFormat:@"%@ - %@: %d",songPlay.songName,AMLocalizedString(@"Lời", nil),[lyr.privatedId integerValue]];
                
                showSongName.text=tieude;
                self.titleName.text=tieude;
                lyricInXml = lyr.content;
                lyric = [self getLyric:lyricInXml];
                if (lyric  && ![Language hasSuffix:@"kara"]) {
                    [self performSelectorOnMainThread:@selector(updateLyric) withObject:nil waitUntilDone:NO];
                }
                
            }
            
        }
        
    }
}
- (void) updateLyric{
    [karaokeDisplay setSimpleTiming:lyric];
    [karaokeDisplay reset];
    [karaokeDisplay _updateOrientation ];
    [karaokeDisplay render:CMTimeGetSeconds([playerMain currentTime])];
    CGFloat height=[karaokeDisplay getHeight:@"Karaoke" andSize:[karaokeDisplay.paint.getPaint fontsize] ];
    karaokeDisplayElement.frame=CGRectMake(20, 180,karaokeDisplayElement.frame.size.width,height*(numDisplayLineLyric+1) );
    if (playRecord) {
        karaokeDisplayElement.center=CGPointMake(self.view.frame.size.width/2, self.playerLayerViewRec.center.y) ;
    }else
        karaokeDisplayElement.center=self.editScrollView.center;
}
- (void)sliderTappedTreble:(UIGestureRecognizer *)g{
    UISlider* s = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: s];
    CGFloat percentage = point.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    self.volumeTrebleLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:s.value] intValue]];
    songRec.effects.treble=[NSNumber numberWithInt:s.value];
}
- (void)sliderTappedVocalVolume:(UIGestureRecognizer *)g{
    UISlider* s = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: s];
    CGFloat percentage = point.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:s.value] intValue]];
    songRec.effects.vocalVolume=[NSNumber numberWithInt:s.value];
    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt:s.value];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else
        [self.audioTapProcessor updateVolumeVideo:(int)(powf(s.value/100,1.6666)*100)];
    maxV=0;
}
- (void)sliderTappedEcho:(UIGestureRecognizer *)g{
    UISlider* s = (UISlider*)g.view;
    //  if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: s];
    CGFloat percentage = point.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    self.volumEchoLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:s.value] intValue]];
    songRec.effects.echo=[NSNumber numberWithInt:s.value];
}
- (void)sliderTappedMusicVolume:(UIGestureRecognizer *)g{
    UISlider* s = (UISlider*)g.view;
    // if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: s];
    CGFloat percentage = point.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    
    self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:s.value] intValue]];
    songRec.effects.musicVolume=[NSNumber numberWithInt:s.value];
    songRec.effectsNew.beatVolume=[NSNumber numberWithInt:s.value];
    
    if (VipMember  ) {
        
        [NSThread detachNewThreadSelector:@selector(updateStreamEffect) toTarget:self withObject:nil];
    }else
    [self.audioTapProcessor updateVolumeAudio:(int)(powf(s.value/100,1.6666)*100)];
    maxV=0;
}
- (void)sliderTapped:(UIGestureRecognizer *)g
{
    /////////////// For TapCount////////////
    isTapSlider=YES;
    //tapCount = tapCount + 1;
    //NSLog(@"Tap Count -- %d",tapCount);
    
    /////////////// For TapCount////////////
    if (!isrecord) {
        UISlider* s = (UISlider*)g.view;
        //if (s.highlighted)
        //     return; // tap on thumb, let slider deal with it
        CGPoint point = [g locationInView: s];
        CGFloat percentage = point.x / s.bounds.size.width;
        CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
        CGFloat valueS = s.minimumValue + delta;
        [s setValue:valueS animated:YES];
        float minValue = [s minimumValue];
        float maxValue = [s maximumValue];
        float value = [s value];
        
        restoreAfterScrubbingRate = [audioPlayer rate];
        if (playerMain) {
             [playerMain pause];
        }
       
       
        if (audioPlayer.rate)
            [audioPlayer pause];
            //if ([audioPlayer rate]!=0) [audioPlayer pause];
        
        /* Remove previous timer. */
        //[self removePlayerTimeObserver2];
        
        
        CMTime playerDuration = [self playerItemDuration2];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        
        if (isfinite(duration))
        {
            
            
            double time = duration * (value - minValue) / (maxValue - minValue);
            
            if (playerMain) {
                [playerMain seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
            }
            
            if (audioPlayer && playRecord) {
                [audioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
                
                
            }
            if (VipMember && playRecord  ) {
                dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
                
                dispatch_async(queue, ^{
                    [self sendUPDATESTREAM:time];
                });
            }
            
        }
        
        /*if (!timeObserver)
        {
            CMTime playerDuration = [self playerItemDuration];
            if (CMTIME_IS_INVALID(playerDuration))
            {
                return;
            }
            
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration))
            {
                CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
                /// double tolerance = 0.2f;// * duration / width;
                // if (tolerance > 0.1) tolerance=0.1;
                // if (tolerance < 0.05) tolerance= 0.05;
                if (!playRecord && playerMain) {
                    timeObserver = [playerMain addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                    ^(CMTime time)
                                    {
                                        [self syncScrubber];
                                    }];
                }
                
                if ([Language hasSuffix:@"kara"]&& playRecord  && audioPlayer){
                    timeObserver2 = [audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                     ^(CMTime time)
                                     {
                                         //[self checkPlaying];
                                          [self syncScrubber2];
                                     }];
                }
            }
        }*/
        if (restoreAfterScrubbingRate)
        {
            if (playerMain) {
                [playerMain setRate:restoreAfterScrubbingRate];
            }
            
            
                if (restoreAfterScrubbingRate!=0) {
                    [audioPlayer play];
                }
           
            if (duetVideoPlayer && fabs( CMTimeGetSeconds([audioPlayer currentTime])-CMTimeGetSeconds([duetVideoPlayer currentTime]))>1 && (CMTimeGetSeconds([audioPlayer currentTime]))<CMTimeGetSeconds([duetVideoPlayer.currentItem duration])) {
                [duetVideoPlayer pause];
                [duetVideoPlayer seekToTime:audioPlayer.currentTime];
                if (restoreAfterScrubbingRate!=0) {
                    [duetVideoPlayer play];
                }
            }
            restoreAfterScrubbingRate = 0.f;
        }
        
        //   [self checkPlaying];
        //. [playerMain play];
        //. if ([Language hasSuffix:@"kara"] && (playRecUpload || playTopRec) && audioPlayer && [self isPlaying] ) [audioPlayer play];
    }
    
    isTapSlider=NO;
    //NSString *str=[NSString stringWithFormat:@"%.f",[movieTimeControl value]];
    // self.lbl.text=str;
}

- (void) loadLyric {
    @autoreleasepool {
        
        Lyric *lyr;
        for (Lyric *i in iSongPlay.song.lyrics){
            lyr=i;
        }
        if (lyr) {
            dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
            dispatch_async(queue, ^{
                if ([[LoadData2 alloc] checkNetwork]) {
                    GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
                    lyr.content=lyricRespone.content;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([lyr.type intValue] == PLAINTEXT ) {
                        // NSLog(@"%@",lyr.url);
                        
                        if (loadlaiLyric) {
                            if (isDownload) {
                                contentPlaintext=lyr.content;
                            }
                            else {
                                contentPlaintext= lyr.content;
                            }
                            loadlaiLyric=NO;
                        }
                        
                        karaokeDisplayElement.hidden=YES;
                        self.showplainText.hidden=NO;
                        showPlain = YES;
                        
                    }
                    
                    else {showPlain=NO;
                        self.showplainText.hidden=YES;
                        karaokeDisplayElement.hidden=NO;
                        NSString *urlyric=lyr.url;
                        //NSLog(@"%@",urlyric);
                        
                        NSString *lyricInXml;
                     
                        //  dispatch_async(dispatch_get_main_queue(), ^{
                        if (![Language hasSuffix:@"kara"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                lyric = [self getLyricJSON:lyr.content];
                                numDisplayLineLyric = lyric.count;
                                CGRect newframe= self.view.frame;
                                CGFloat height=[karaokeDisplay getHeight:@"Karaoke" andSize:[karaokeDisplay.paint.getPaint fontsize] ];
                                CGRect windowFrame= CGRectMake(0, 80, newframe.size.width,height*numDisplayLineLyric );
                                
                                karaokeDisplayElement = [[CSLinearLayoutView alloc] initWithFrame:self.lyricView.bounds];
                                
                                karaokeDisplayElement.orientation = CSLinearLayoutViewOrientationVertical;
                                karaokeDisplayElement.scrollEnabled = YES;
                                karaokeDisplayElement.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                                
                                
                                karaokeDisplay =  [[KaraokeDisplay alloc] initKaraokeDisplay:nil andLine:karaokeDisplayElement];
                                height=[karaokeDisplay getHeight:@"Karaoke" andSize:[karaokeDisplay.paint.getPaint fontsize] ];
                                
                                
                                
                                /*
                                 
                                 
                                 if ([songRec.performanceType isEqualToString:@"DUET"] ){
                                 if ([songRec.sex isEqualToString:@"m"]) {
                                 [karaokeDisplay updateSettings:(int)numDisplayLineLyric  andMale:[UIColor whiteColor] andFemale:namColor andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                                 if (gender.length>0) {
                                 if ([gender isEqualToString:@"female"]) {
                                 [karaokeDisplay updateSettings:(int)numDisplayLineLyric andMale:[UIColor whiteColor] andFemale:nuColor andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 }
                                 }
                                 }else{
                                 [karaokeDisplay updateSettings:(int)numDisplayLineLyric andMale:namColor andFemale:[UIColor whiteColor] andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                                 if (gender.length>0) {
                                 if ([gender isEqualToString:@"female"]) {
                                 [karaokeDisplay updateSettings:(int)numDisplayLineLyric andMale:nuColor andFemale:[UIColor whiteColor] andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 }
                                 }
                                 }
                                 }else if ( [songRec.performanceType isEqualToString:@"ASK4DUET"] ){
                                 NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                                 [karaokeDisplay updateSettings:numDisplayLineLyric andMale:namColor andFemale:[UIColor whiteColor] andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 if (gender.length>0) {
                                 if ([gender isEqualToString:@"female"]) {
                                 [karaokeDisplay updateSettings:numDisplayLineLyric andMale:[UIColor whiteColor] andFemale:nuColor andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 }
                                 }
                                 
                                 }else {
                                 [karaokeDisplay updateSettings:numDisplayLineLyric andMale:[UIColor whiteColor] andFemale:nuColor andDuet:songCaColor andOverlay:UIColorFromRGB(0x50FFF2)];
                                 }*/
                                [karaokeDisplay updateSettings:numDisplayLineLyric andMale:[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.6] andFemale:[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.6] andDuet:[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.6] andOverlay:[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:1]];
                                [self.editScrollView addSubview:self->karaokeDisplayElement];
                                //self.lyricView.backgroundColor = [UIColor clearColor];
                                //self.lyricView.hidden = NO;
                            });
                        }
                        
                    }
                });
            });
        }
        
    }
}
- (NSMutableArray<Line> *) getLyricJSON: (NSString *) lyricInJson{
    
    // NSString *lyricInXml=[[LoadData2 alloc] getLyricData:url];
    ///NSLog(@"lời %@",lyricInXml);
    NSError *error= nil;
    Lyrics *lyricsInObject =[[Lyrics alloc] initWithString:lyricInJson error:&error];
    
    lyricsInObject = [[UtilsK alloc] splitTooLongLine:lyricsInObject andMaxLen:20];
    return [[UtilsK alloc] convertLyricsInObjectToRKL:lyricsInObject];
}
- (IBAction)changeMusicVolumeYokara:(id)sender {
    UISwitch* musicBtton=(UISwitch *)sender;
    if (musicBtton.isOn) {
        self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",100];
        songRec.effects.musicVolume=[NSNumber numberWithInt:100];
        muteYoutube=NO;
        [youtubePlayer playVideo];
        if (timerWhenMuteYoutube) {
            
            [timerWhenMuteYoutube invalidate];
            timerWhenMuteYoutube=nil;
        }
        if (playVideoRecorded) {
            
            [youtubePlayer seekToSeconds:CMTimeGetSeconds([audioPlayer currentTime]) allowSeekAhead:YES];
            
        }else
            [youtubePlayer seekToSeconds:audioPlayRecorder.currentTime allowSeekAhead:YES];
    }else{
        if (timerWhenMuteYoutube==nil) {
            timerWhenMuteYoutube= [NSTimer
                                   scheduledTimerWithTimeInterval:1
                                   target:self
                                   selector:@selector(scrubAudio)
                                   userInfo:nil
                                   repeats:YES];
        }
        self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",0];
        songRec.effects.musicVolume=[NSNumber numberWithInt:0];
        muteYoutube=YES;
        [youtubePlayer pauseVideo];
    }
}
- (IBAction)changeMusicVolume:(UISlider*)sender {
    
    self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.musicVolume=[NSNumber numberWithInt:sender.value];
}
- (IBAction)changeValueMusicVolume:(UISlider*)sender {
    
    self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.musicVolume=[NSNumber numberWithInt:sender.value];
    songRec.effectsNew.beatVolume=[NSNumber numberWithInt:sender.value];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
        if (!VipMember ) {
            [self.audioTapProcessor updateVolumeAudio:(int)(powf(sender.value/100,1.6666)*100)];
        }

        maxV=0;
            /*if (![songRec.performanceType isEqualToString:@"DUET"] || isDownload) {
                playerMain.volume=sender.value/100;
            }else{
                duetVideoPlayer.volume=sender.value/100;
            }*/
        
        
    }else{
        NSArray *audioTracks = [assetLoadmovie1 tracksWithMediaType:AVMediaTypeAudio];
        
        // Mute all the audio tracks
        NSMutableArray *allAudioParams = [NSMutableArray array];
        for (AVAssetTrack *track in audioTracks) {
            AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
            [audioInputParams setVolume:sender.value/100 atTime:kCMTimeZero];
            [audioInputParams setTrackID:[track trackID]];
            [allAudioParams addObject:audioInputParams];
        }
        AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
        [audioZeroMix setInputParameters:allAudioParams];
        
        // Create a player item
        AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:assetLoadmovie1];
        [playerItem1 setAudioMix:audioZeroMix]; // Mute the player item
        
        // Create a new Player, and set the player to use the player item
        // with the muted audio mix
        
        
        // assign player object to an instance variable
        CMTime currentTime= [playerMain currentTime];
        
        // play the muted audio
        if (playerItem1) {
            [playerMain replaceCurrentItemWithPlayerItem:playerItem1];
            [playerMain seekToTime:currentTime];
            [playerMain play];
        }
    }
    //if ([[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_MUSICVOLUME fieldValue1:[NSString stringWithFormat:@"%d",[songRec.musicVolume intValue]] withCondition:R_IDR conditionValue:[NSString stringWithFormat:@"%@",songRec._id]]) NSLog(@"change volume");
}
- (IBAction)changeEcho:(UISlider*)sender {
    self.volumEchoLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.echo=[NSNumber numberWithInt:sender.value];
}
- (IBAction)changeValueEcho:(UISlider*)sender {
    self.volumEchoLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.echo=[NSNumber numberWithInt:sender.value];
    // if ([[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_ECHO fieldValue1:[NSString stringWithFormat:@"%d",[songRec.echo intValue]] withCondition:R_IDR conditionValue:[NSString stringWithFormat:@"%@",songRec._id]]) NSLog(@"change echo");
}
- (IBAction)changeVocalVolume:(UISlider*)sender {
    //[audioPlayRecorder setVolume:sender.value/100];
    self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt:sender.value];
    
}
- (IBAction)changeValueVocalVolume:(UISlider*)sender {
    self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.vocalVolume=[NSNumber numberWithInt:sender.value];
    songRec.effectsNew.vocalVolume=[NSNumber numberWithInt:sender.value];
    if (!VipMember ) {
        [self.audioTapProcessor updateVolumeVideo:(int)(powf(sender.value/100,1.6666)*100)];
    }

     maxV=0;
    //if ([[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_VOCALVULUME fieldValue1:[NSString stringWithFormat:@"%d",[songRec.vocalVolume intValue]] withCondition:R_IDR conditionValue:[NSString stringWithFormat:@"%@",songRec._id]]) NSLog(@"change volume vocal");
}
- (IBAction)changeTreble:(UISlider*)sender {
    self.volumeTrebleLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.treble=[NSNumber numberWithInt:sender.value];
    
}
- (IBAction)changeValueTreble:(UISlider*)sender {
    self.volumeTrebleLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.treble=[NSNumber numberWithInt:sender.value];
    //if ([[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_TREBLE fieldValue1:[NSString stringWithFormat:@"%d",[songRec.treble intValue]] withCondition:R_IDR conditionValue:[NSString stringWithFormat:@"%@",songRec._id]]) NSLog(@"change treble");
}
- (IBAction)changeBass:(UISlider*)sender {
    self.volumeBassLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.bass=[NSNumber numberWithInt:sender.value];
    
}
- (IBAction)changeValueBass:(UISlider*)sender {
    self.volumeBassLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:sender.value] intValue]];
    songRec.effects.bass=[NSNumber numberWithInt:sender.value];
    //if ([[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_TREBLE fieldValue1:[NSString stringWithFormat:@"%d",[songRec.treble intValue]] withCondition:R_IDR conditionValue:[NSString stringWithFormat:@"%@",songRec._id]]) NSLog(@"change treble");
}
- (void) loadListLyric {
    @autoreleasepool {
        
        
        if (ListLyric.count==0) {
            if ([[LoadData2 alloc] checkNetwork]) {
                songs =[[LoadData2 alloc] getDataSong:songPlay._id];
            }
            if (!ListLyric){
                ListLyric=[NSMutableArray new];
            }else{
                [ListLyric removeAllObjects];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.menuLyric reloadData];
            });
            for (Lyric *lyric in songs.song.lyrics) {
                ///  NSString *list=[NSString stringWithFormat:@"MS: %@",lyric.privatedId];
                [ListLyric addObject:lyric];
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.menuLyric reloadData];
        });
    }
}
- (IBAction)showListLyric :(id)sender {
    if ([Language hasSuffix:@"kara"]){
        if (playRecord) {
            
            alertDeleteRecord = [[UIAlertView alloc] init];
            
            [alertDeleteRecord setTitle:AMLocalizedString(@"Xóa bài thu",nil)];
            [alertDeleteRecord setMessage:AMLocalizedString(@"Bạn muốn xóa bài thu âm?",nil)];
            [alertDeleteRecord setDelegate:self];
            [alertDeleteRecord addButtonWithTitle:AMLocalizedString(@"Có",nil)];
            [alertDeleteRecord addButtonWithTitle:AMLocalizedString(@"Không",nil)];
            [alertDeleteRecord performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }else
            if (  playRecUpload) {
                NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
                if ([songRec->hasUpload isEqualToString:@"YES"]){
                    
                    if (songRec.mixedRecordingVideoUrl.length>5){
                        path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                    }
                    
                }else{
                    if ([songRec.vocalUrl hasSuffix:@"mov"]){
                        path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                    }else{
                        BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                        if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                    }
                }
                NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                
                if (isVoice  && audioEngine2) {
                    [audioEngine2 playthroughSwitchChanged:NO];
                    [audioEngine2 reverbSwitchChanged:NO];
                    [audioEngine2 expanderSwitchChanged:NO];
                }
                NSError *error;
                
                if (haveS)  {
                    
                    if (self.xulyView.hidden==YES) {
                        if (songRec){
                            // if ([songRec->hasUpload isEqualToString:@"YES"]) {
                            self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
                            /*  }else{
                             self.deplayLabel.text=[NSString stringWithFormat:@"%d",(int)([songRec.delay floatValue]*1000)];
                             }*/
                        }
                        self.volumeMusic.value=[songRec.effectsNew.beatVolume floatValue];
                        
                        //[audioPlayRecorder setVolume:[songRec.effects.vocalVolume floatValue]/100];
                        self.volumeVocal.value=[songRec.effectsNew.vocalVolume floatValue];
                        
                        
                        self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeMusic.value] intValue]];
                        
                        self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeVocal.value] intValue]];
                        self.xulyView.hidden=NO;
                        if (playRecUpload) {
                            /*
                             NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                             if (songRec.mixedRecordingVideoUrl){
                             if (songRec.mixedRecordingVideoUrl.length>5)
                             path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                             }
                             NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                             BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                             
                             if (isVoice) {
                             [audioEngine2 playthroughSwitchChanged:NO];
                             [audioEngine2 reverbSwitchChanged:NO];
                             }
                             NSError *error;
                             */
                            if (haveS)  {
                                isPlayingAu=NO;
                              
                                playRecord=YES;
                                /*
                                 if (songRec.mixedRecordingVideoUrl){
                                 if (songRec.mixedRecordingVideoUrl.length>5)
                                 playVideoRecorded=YES;
                                 else playVideoRecorded=NO;
                                 }else playVideoRecorded=NO;*/
                                isrecord=NO;
                                videoRecord=NO;
                                playTopRec=NO;
                                playRecUpload =NO;
                                
                                if ([self isPlayingAudio])
                                    [audioPlayer pause];
                                //  audioPlayer=nil;
                                
                                if (iSongPlay) {iSongPlay->isPlaying=0;}
                                unload =YES;
                                if ([self isPlaying]) [playerMain pause];
                                [checkPlaying invalidate];
                                checkPlaying=nil;
                                isPlayingRecordFromEdit=YES;
                                
                                StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
                                // [[MainViewController alloc] initWithPlayer:nil];
                                
                                [self.navigationController pushViewController:mainv animated:NO];
                            }
                            
                        }
                        
                    }else{
                        self.xulyView.hidden=YES;
                    }
                }else{
                    if ([self.menuLyric isHidden]) {
                        self.menuLyric.hidden=NO;
                        CGRect nframe= self.menuLyric.frame;
                        nframe.size.height=videoQualityList.count*44+55;
                        nframe.size.width=200;
                        if (nframe.size.height>200) {
                            nframe.size.height=182;
                        }
                        nframe.origin.x=self.view.frame.size.width/2-nframe.size.width/2;
                        nframe.origin.y=self.view.frame.size.height/2-nframe.size.height/2-50;
                        self.menuLyric.frame=nframe;
                    }else {
                        self.menuLyric.hidden=YES;
                    }
                }
            }else {
                if ([self.menuLyric isHidden]) {
                    self.menuLyric.hidden=NO;
                    CGRect nframe= self.menuLyric.frame;
                    nframe.size.height=videoQualityList.count*44+55;
                    nframe.size.width=200;
                    if (nframe.size.height>200) {
                        nframe.size.height=182;
                    }
                    nframe.origin.x=self.view.frame.size.width/2-nframe.size.width/2;
                    nframe.origin.y=self.view.frame.size.height/2-nframe.size.height/2-50;
                    self.menuLyric.frame=nframe;
                }else {
                    self.menuLyric.hidden=YES;
                }
            }
    }else{
        if (playRecord) {
            
            alertDeleteRecord = [[UIAlertView alloc] init];
            
            [alertDeleteRecord setTitle:AMLocalizedString(@"Xóa bài thu",nil)];
            [alertDeleteRecord setMessage:AMLocalizedString(@"Bạn muốn xóa bài thu âm?",nil)];
            [alertDeleteRecord setDelegate:self];
            [alertDeleteRecord addButtonWithTitle:AMLocalizedString(@"Có",nil)];
            [alertDeleteRecord addButtonWithTitle:AMLocalizedString(@"Không",nil)];
            [alertDeleteRecord performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }else
            if ([[LoadData2 alloc] checkNetwork]) {
                
                if (playRecord || playRecUpload ) {
                    if (self.xulyView.hidden==YES) {
                        if (songRec){
                            //if ([songRec->hasUpload isEqualToString:@"YES"]) {
                            self.deplayLabel.text=[NSString stringWithFormat:@"%d",[songRec.delay intValue]];
                            /* }else{
                             self.deplayLabel.text=[NSString stringWithFormat:@"%d",(int)([songRec.delay floatValue]*1000)];
                             }*/
                        }
                        self.volumeMusic.value=[songRec.effectsNew.beatVolume floatValue];
                        
                        //[audioPlayRecorder setVolume:[songRec.effects.vocalVolume floatValue]/100];
                        self.volumeVocal.value=[songRec.effectsNew.vocalVolume floatValue];
                        
                        self.volumeMusicLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeMusic.value] intValue]];
                       
                        self.volumeVocalLabel.text=[NSString stringWithFormat:@"%d",[[NSNumber numberWithInteger:self.volumeVocal.value] intValue]];
                        self.xulyView.hidden=NO;
                        // self.colectionView.hidden=YES;
                        if (playRecUpload) {
                            
                            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
                            if ([songRec->hasUpload isEqualToString:@"YES"]){
                                
                                if (songRec.mixedRecordingVideoUrl.length>5){
                                    path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                                    BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                                    if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                                }
                            }else{
                                if ([songRec.vocalUrl hasSuffix:@"mov"]){
                                    path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                                    BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                                    if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",songRec.recordingTime]];
                                }else{
                                    BOOL haveSong= [[NSFileManager defaultManager] fileExistsAtPath:path];
                                    if (!haveSong) path=[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                                }
                            }
                            NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                            
                            if (isVoice && audioEngine2) {
                                [audioEngine2 playthroughSwitchChanged:NO];
                                [audioEngine2 reverbSwitchChanged:NO];
                                [audioEngine2 expanderSwitchChanged:NO];
                            }
                            NSError *error;
                            
                            if (haveS)  {
                              
                                
                                playRecord=YES;
                                isrecord=NO;
                                videoRecord=NO;
                                playTopRec=NO;
                                playRecUpload =NO;
                                if (iSongPlay) {iSongPlay->isPlaying=0;}
                                unload =YES;
                                [checkPlaying invalidate];
                                checkPlaying=nil;
                                isPlayingAu=NO;
                                
                                isPlayingRecordFromEdit=YES;
                                if ([self isPlaying]) [playerMain pause];
                                StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
                                // [[MainViewController alloc] initWithPlayer:nil];
                                
                                [self.navigationController pushViewController:mainv animated:NO];
                            }
                            /*
                             playRecUpload=NO;
                             playRecord=YES;
                             songPlay.songUrl=songRec.song.songUrl;
                             songPlay.songName=songRec.song.songName;
                             songPlay._id=songRec.song._id;
                             playerItem=nil;
                             //
                             
                             NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",songRec.recordingTime]];
                             NSURL *audioFileURL= [NSURL fileURLWithPath:path];
                             BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:path];
                             
                             if (isVoice) {
                             [audioEngine2 playthroughSwitchChanged:NO];
                             [audioEngine2 reverbSwitchChanged:NO];
                             }
                             NSError *error;
                             
                             if (haveS)  {
                             
                             
                             audioPlayRecorder = [[AVAudioPlayer alloc]initWithContentsOfURL:audioFileURL error:&error];
                             if (playerMain) {
                             [playerMain pause];
                             }
                             if (songRec.song.songUrl){
                             // [NSThread detachNewThreadSelector:@selector(loadMovie:) toTarget:self withObject:songRec.song.songUrl];
                             }
                             }
                             else NSLog(@"ko co file record");
                             if (error) NSLog(@"%@",error);
                             
                             [self.view setNeedsDisplay];*/
                        }
                    }else{
                        if (![songRec->hasUpload isEqualToString:@"YES"]) {
                            //  self.colectionView.hidden=NO;
                        }
                        
                        self.xulyView.hidden=YES;
                    }
                }else {
                    
                    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                    dispatch_async(queue, ^{
                        //code to executed in the background
                        if (ListLyric.count==0) {
                            if ([[LoadData2 alloc] checkNetwork]) {
                                songs =[[LoadData2 alloc] getDataSong:songPlay._id];
                            }
                            if (!ListLyric){
                                ListLyric=[NSMutableArray new];
                            }else{
                                [ListLyric removeAllObjects];
                            }
                            for (Lyric *lyric in songs.song.lyrics) {
                                ///  NSString *list=[NSString stringWithFormat:@"MS: %@",lyric.privatedId];
                                [ListLyric addObject:lyric];
                                
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([self.menuLyric isHidden]) {
                                
                                self.menuLyric.hidden=NO;
                                CGRect nframe= self.menuLyric.frame;
                                nframe.size.height=ListLyric.count*44-1+50;
                                nframe.size.width=250;
                                if (nframe.size.height>300) {
                                    nframe.size.height=270;
                                }
                                
                                self.menuLyric.tableHeaderView.backgroundColor=[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:0.2];
                                self.menuLyric.layer.cornerRadius=5;
                                self.menuLyric.layer.masksToBounds=YES;
                                self.menuLyric.frame=nframe;
                                self.menuLyric.center=self.view.center;
                                float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
                                if (iOSVersion >= 8.0f )
                                {
                                    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                                        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                                        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                                        
                                        blurEffectView.frame = CGRectMake(0, 0, self.menuLyric.contentSize.width, self.menuLyric.contentSize.height);
                                        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                                        //[cell.thumnailView insertSubview:blurEffectView belowSubview:cell.likeCmtView];
                                        // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
                                        // cell.likeCmtView=blurEffectView;
                                        [self.menuLyric insertSubview:blurEffectView atIndex:0];
                                        self.menuLyric.backgroundColor=[UIColor clearColor];
                                        
                                        //cell.likeCmtView.backgroundColor=[UIColor clearColor];
                                    }
                                }
                            }else {
                                self.menuLyric.hidden=YES;
                            }
                            
                            [self.menuLyric reloadData];
                            
                        });
                    });
                    
                    
                }
            }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([Language hasSuffix:@"kara"]){
        return videoQualityList.count;
    }else
        // Return the number of rows in the section.
        return ListLyric.count;
}
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 if ([Language hasSuffix:@"kara"]){
 return [NSString stringWithFormat:AMLocalizedString(@"Chất lượng video",@"Chất lượng video")];
 }else
 return [NSString stringWithFormat:AMLocalizedString(@"Danh sách lời (%d)",@"Danh sách lời (%d)"),ListLyric.count];
 }*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    /* Section header is in 0th index... */
    if ([Language hasSuffix:@"kara"]){
        [label setText:[NSString stringWithFormat:AMLocalizedString(@"Chất lượng video",@"Chất lượng video")]];
    }else
        [label setText:[NSString stringWithFormat:AMLocalizedString(@"Danh sách lời (%d)",@"Danh sách lời (%d)"),ListLyric.count]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.1]]; //your background color...
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
NSString static *const kYTPlaybackQualitySmallQuality = @"240p";
NSString static *const kYTPlaybackQualityMediumQuality = @"360p";
NSString static *const kYTPlaybackQualityLargeQuality = @"480p";
NSString static *const kYTPlaybackQualityHD720Quality = @"720p";
NSString static *const kYTPlaybackQualityHD1080Quality = @"1080p";
NSString static *const kYTPlaybackQualityHighResQuality = @"4k";
NSString static *const kYTPlaybackQualityAutoQuality = @"auto";
NSString static *const kYTPlaybackQualityDefaultQuality = @"mac_dinh";
NSString static *const kYTPlaybackQualityUnknownQuality = @"unknown";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =[NSString stringWithFormat: @"Cell %ld",(long)indexPath.row];
    if ([Language hasSuffix:@"kara"]){
        NSNumber*  quality=[videoQualityList objectAtIndex:indexPath.row];
        NSString* quaString;
        switch ([quality intValue]) {
            case kYTPlaybackQualitySmall:
                quaString= kYTPlaybackQualitySmallQuality;
                break;
            case kYTPlaybackQualityMedium:
                quaString= kYTPlaybackQualityMediumQuality;
                break;
            case kYTPlaybackQualityLarge:
                quaString= kYTPlaybackQualityLargeQuality;
                break;
            case kYTPlaybackQualityHD720:
                quaString= kYTPlaybackQualityHD720Quality;
                break;
            case kYTPlaybackQualityHD1080:
                quaString= kYTPlaybackQualityHD1080Quality;
                break;
            case kYTPlaybackQualityHighRes:
                quaString= kYTPlaybackQualityHighResQuality;
                break;
            case kYTPlaybackQualityAuto:
                quaString= kYTPlaybackQualityAutoQuality;
                break;
            default:
                quaString= kYTPlaybackQualityUnknownQuality;
                break;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        // DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 15, 230, 14)] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            
            
            
            
            // Configure the cell...
        }
        
        cell.textLabel.text = quaString;  // Configure the cell...
        
        cell.imageView.image =[UIImage imageNamed:@"Video_den.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        if ([quality integerValue]== [videoQuality integerValue]) {
            // [cell setSelected:YES];
            cell.contentView.backgroundColor=UIColorFromRGB(0xEFEFEF);
        }else {
            //[cell setSelected:NO];
            cell.contentView.backgroundColor=[UIColor clearColor];
        }
        return cell;
    }else{
        if (indexPath.row<ListLyric.count) {
            
            
            Lyric * lyri=[ListLyric objectAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 15, 230, 14)] ;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                
                if ([lyri.ratingCount intValue]==0){
                    rateView.rate = 3;
                }
                else {
                    int rate=round( [lyri.totalRating floatValue]/[lyri.ratingCount floatValue]);
                    rateView.rate=rate;
                }
                
                cell.backgroundColor=[UIColor clearColor];
                
                rateView.alignment = RateViewAlignmentRight;
                [cell.contentView addSubview:rateView];
                // Configure the cell...
                
            }
            
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"Lời", @"Lời"), lyri.privatedId];    // Configure the cell...
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", lyri.ratingCount,AMLocalizedString(@"lượt", @" lượt")];
            cell.imageView.image =[UIImage imageNamed:@"Loi_nhac_icon.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];///loi_nhac-128.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 15, 230, 14)] ;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if ([Language hasSuffix:@"kara"]){
        videoQuality=[videoQualityList objectAtIndex:indexPath.row];
        if (!isrecord){
            timeRestore=CMTimeGetSeconds(playerMain.currentTime);
            if (self.loadingViewVIP.isHidden && self.startRecordView.isHidden) {
                self.isLoading.hidden=NO;
            }
            isPlayingAu=NO;
            if ([self isPlaying]) [playerMain pause];
            if ([self isPlayingAudio]) [audioPlayer pause];
            //unload =YES;
            // StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
            [self.menuLyric reloadData];
            //[self.navigationController pushViewController:mainv animated:NO];
            //   if (getLinkFromYoutube==NO) {
            
            //  playerYoutube = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[videoDictionary objectForKey:@"small"]]];
            if (isKaraokeTab){
                
                //[youtubePlayer loadVideoById:songPlay.videoId startSeconds:youtubePlayer.currentTime suggestedQuality:[videoQuality integerValue]];
            }
            /*
             
             }else{
             if (isTabKaraoke) isKaraokeTab=YES;
             if (isKaraokeTab){
             [NSThread detachNewThreadSelector:@selector(loadYoutubeVieo:) toTarget:self withObject:songPlay.videoId];
             
             }
             }*/
        }else{
            [self.menuLyric reloadData];
            //[[[[iToast makeText:AMLocalizedString(@"Chất lượng video sẽ thay đổi ở lần hát sau", nil)]  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
        self.menuLyric.hidden=YES;
    }else{
        Lyric * lyra=[ListLyric objectAtIndex:indexPath.row];
        if (isrecord) {
            songRec.selectedLyric=lyra.key;
        }
        if ([lyra.type intValue] == PLAINTEXT ) {
            
            contentPlaintext= [[UtilsK alloc] getText:lyra.url];
            
            karaokeDisplayElement.hidden=YES;
            self.showplainText.hidden=NO;
            showPlain = YES;
        }
        
        else {
            showPlain=NO;
            self.showplainText.hidden=YES;
            karaokeDisplayElement.hidden=NO;
            NSString *urlyric=lyra.url;
            NSString *lyricInXml = [[UtilsK alloc] getText:urlyric];
            //  GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyra.key];
            //NSString *lyricInXml=lyricRespone.content;
            lyric = [self getLyric:lyricInXml];
        }
        if (showPlain) {
            self.showplainText.hidden=NO;
            karaokeDisplayElement.hidden=YES;
            [self.showplainText setText: contentPlaintext];
        }
        else {
            self.showplainText.hidden=YES;
            karaokeDisplayElement.hidden=NO;
            if (lyric  && ![Language hasSuffix:@"kara"]) {
                [self performSelectorOnMainThread:@selector(updateLyric) withObject:nil waitUntilDone:NO];
            }
        }
        if (lyra.privatedId==nil){
            tieude=[NSString stringWithFormat:@"%@",songPlay.songName];
        }
        else{
            tieude=[NSString stringWithFormat:@"%@ - %@: %@",songPlay.songName,AMLocalizedString(@"Lời", @"Lời"),lyra.privatedId];
        }
        self.showSingerName.text=songPlay.singerName;
        showSongName.text=tieude;
        self.titleName.text=tieude;
        self.menuLyric.hidden =YES;
    }
}
/*
 - (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touched: paddle"); // <-- check for null paddle
 // <-- check touchOffset
 if (!self.navigationController.navigationBarHidden){
 self.navigationController.navigationBarHidden =YES;
 [toolBar setHidden:YES];
 }else {
 self.navigationController.navigationBarHidden =NO;
 [toolBar setHidden:NO];
 }
 }*/
- (void) configeDBRecordingStatus:(Recording *)recording{
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    
    NSString *url1=[NSString stringWithFormat: @"ikara/recordings/%@/process/",recording._id];
    
    [[ref child:url1] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSString * status=cmtdict[@"status"];
            NSString* message=cmtdict[@"message"];
            
            if ([status isEqualToString:@"MIXED"]) {
                if ([dataRecord containsObject:recording] && [recording.performanceType isEqualToString:@"ASK4DUET"]) {
                    
                    [dataRecord removeObject:recording];
                    [listSongMyAskDuet insertObject:recording atIndex:0];
                    
                    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                     [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                     [dateFormatter setLocale:[NSLocale systemLocale]];
                     NSDate *currDate = [dateFormatter dateFromString:recording.recordingTime];
                     NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                     [dateFormatter setTimeZone:gmtZone];
                     
                     NSString *dateString = [dateFormatter stringFromDate:currDate];*/
                    //recording.recordingTime=dateString;
                }
                
                [[ref child:url1] removeAllObservers];
                recording->statusUpload=nil;
                
              //  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUser" object:recording];
                
                
                vitriuploadRec=99999999;
                
                
                
            }else  if ([status isEqualToString:@"ERROR"]) {
                
                recording->statusUpload= AMLocalizedString(message, nil) ;
            }else{
                
                recording->statusUpload=AMLocalizedString(message, nil) ;
                
            }
        }else{
            
            recording->statusUpload=AMLocalizedString(@"Bài thu đã gửi lên server đang chờ xử lý", nil);
        }
        
    }];
    //  NSString *url2=[NSString stringWithFormat: @"ikara/devices/%@/viewing/",[[LoadData alloc] idForDevice]];
    
    // [[self.ref child:url2] setValue:recordingCurrentUpload._id];
    
}
Recording *recordingCurrentUpload;
UIBackgroundTaskIdentifier bgTask;
UIBackgroundTaskIdentifier bgMixTask;
- (void) uploadFileToServerIkara:(Recording *)tmp{
    @autoreleasepool {
        if ([[LoadData2 alloc] checkNetwork] && !uploadProssesing) {
            mixOfflineProssesing=NO;
            mixOfflineMessage=@"";
            //hasShowPushRecording=NO;
            uploadProssesing=YES;
            FIRDatabaseReference * ref = [[FIRDatabase database] reference];
            bgTask= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
                // Clean up any unfinished task business by marking where you
                // stopped or ending the task outright.
                [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }];
            
            // Start the long-running task and return immediately.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // [self backgroundAction];
                // timerBG=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backgroundAction) userInfo:nil repeats:YES];
                
                NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
                //  Recording *tmp= [dataRecord objectAtIndex:[vitriup intValue]];
                
                //TheRecord *dateUp=[dataRecord objectAtIndex:vitri];
                
                vitriuploadRec=(int)[dataRecord indexOfObject:tmp];
                
                //[self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                do {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                while (isExportingVideo || isExportingVideoWithEffect);
                
                
                [[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_MUSICVOLUME fieldValue1:[NSString stringWithFormat:@"%d",[tmp.effects.musicVolume intValue]] withCondition:R_DATE conditionValue:[NSString stringWithFormat:@"%@",tmp.recordingTime]] && [[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_ECHO fieldValue1:[NSString stringWithFormat:@"%d",[tmp.effects.echo intValue]] withCondition:R_DATE conditionValue:[NSString stringWithFormat:@"%@",tmp.recordingTime]] && [[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_TREBLE fieldValue1:[NSString stringWithFormat:@"%d",[tmp.effects.treble intValue]] withCondition:R_DATE conditionValue:[NSString stringWithFormat:@"%@",tmp.recordingTime]] && [[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_VOCALVULUME fieldValue1:[NSString stringWithFormat:@"%d",[tmp.effects.vocalVolume intValue]] withCondition:R_DATE conditionValue:[NSString stringWithFormat:@"%@",tmp.recordingTime]]  && [[DBHelperYokaraSDK alloc ] updateTable:R_Table withField1:R_BASS fieldValue1:[NSString stringWithFormat:@"%d",[tmp.effects.bass intValue]] withCondition:R_DATE conditionValue:[NSString stringWithFormat:@"%@",tmp.recordingTime]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                });
                
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePath;
                NSString *typeKey=@".m4a";
                NSLog(@"upload url %@",tmp.vocalUrl);
                if ([tmp.vocalUrl isKindOfClass:[NSString class]]) {
                    if ([tmp.vocalUrl hasSuffix:@"mp4"] || [tmp.vocalUrl hasSuffix:@"mov"]) {
                        tmp.recordingType=@"VIDEO";
                    }else{
                        tmp.recordingType=@"AUDIO";
                    }
                }
                if ([tmp.recordingType isEqualToString:@"VIDEO"]){
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mp4",tmp.recordingTime]];
                    BOOL haveSs= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    typeKey=@".mp4";
                    if (!haveSs){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]];
                        typeKey=@".mov";
                    }
                }else{
                    filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mp3",tmp.recordingTime]];
                    typeKey=@".mp3";
                    BOOL haveSs= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    if (!haveSs){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",tmp.recordingTime]];
                        typeKey=@".m4a";
                    }
                }
                //NSString *filePath=[NSString stringWithFormat:@"%@",tmp.vocalUrl];
                NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                unsigned long long filesize=[fileinfo fileSize];
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if ([tmp->hasUpload isEqualToString:@"YES"] && VipMember){
                    
                    UpdateFacebookNoForRecordingResponse* respone= [[LoadData2 alloc] updateRecording:tmp];
                    if ([respone.status isKindOfClass:[NSString class]]) {
                        if ([respone.status isEqualToString:@"OK"]) {
                            
                            
                            // Listen for new messages in the Firebase database
                            SetProcessRecordingRequest *firRequest = [SetProcessRecordingRequest new];
                            
                            firRequest.recordingId = tmp._id;
                            firRequest.message =@"Đang xử lý bài thu";
                            firRequest.status = @"MIXING";
                            
                            
                            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                            FIRFunctions * functions = [FIRFunctions functions];
                            
                            
                            [[functions HTTPSCallableWithName:Fir_SetProcessRecording] callWithObject:@{@"parameters":requestString}
                                                                                           completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                                if (error) {
                                   
                                    // ...
                                }
                                NSString *stringReply = (NSString *)result.data;
                                NSLog(@"Fir_SetProcessRecording %@",stringReply);
                                FirebaseFuntionResponse *respone = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                                // Some debug code, etc.
                                
                                
                            }];/*
                                NSString *url1=[NSString stringWithFormat: @"ikara/recordings/%@/process/",recordingCurrentUpload._id];
                                [[ref child:url1] setValue:@{@"status":@"MIXING",@"message":@"Đang xử lý bài thu"}  withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                                if (error==nil) {
                                //[self configeDBRecordingStatus:tmp];
                                }
                                }];*/
                            
                            
                            
                            
                            tmp->statusUpload=nil;
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[[iToast makeText:AMLocalizedString(@"Cập nhật bài thu thành công", @"")]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                
                                
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                
                            });
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUser" object:tmp];
                            
                            
                            vitriuploadRec=99999999;
                            uploadProssesing=NO;
                            tmp->isUploading=NO;
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[[iToast makeText:respone.message]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            });
                            uploadProssesing=NO;
                            tmp->isUploading=NO;
                            
                        }
                    }else{
                        if ([respone.message isKindOfClass:[NSString class]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[[iToast makeText:respone.message]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            });
                        }
                        
                        uploadProssesing=NO;
                        tmp->isUploading=NO;
                    }
                    uploadProssesing=NO;
                    
                }else{
                    
                    NSLog(@"file size %lu",filesize);
                    if (haveS && filesize>1000) {
                        NSLog(@"onlineVocalUrl chua upload %@",tmp.onlineVocalUrl);
                        NSLog(@"file path %@ %@",filePath,typeKey);
                        
                        if ( ![tmp.onlineVocalUrl isKindOfClass:[NSString class]] || !VipMember)  {
                            NSData *dataF=[NSData dataWithContentsOfFile:filePath];
                            tmp->isUploading=YES;
                            
                            tmp.mixedRecordingVideoUrl=nil;
                            if (VipMember) {
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                            }else
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                            NSLog(@"onlineVocalUrl lan 1 upload %@",tmp.onlineVocalUrl);
                            if (tmp.onlineVocalUrl.length>3){
                                if (![tmp.onlineVocalUrl hasPrefix:@"http://data"])
                                {
                                    if (!VipMember) {
                                        tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                                    }else
                                        tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                                    NSLog(@"onlineVocalUrl lan 2 upload %@",tmp.onlineVocalUrl);
                                }
                            }else{
                                if (!VipMember) {
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                                }else
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                                NSLog(@"onlineVocalUrl lan 2 upload %@",tmp.onlineVocalUrl);
                            }
                            if (tmp.onlineVocalUrl.length>3){
                                if (![tmp.onlineVocalUrl hasPrefix:@"http://data"])
                                {
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                                    NSLog(@"onlineVocalUrl lan 3 upload %@",tmp.onlineVocalUrl);
                                }
                            }else{
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                                NSLog(@"onlineVocalUrl lan 3 upload %@",tmp.onlineVocalUrl);
                            }
                            
                            
                        }else if (![tmp.onlineVocalUrl hasPrefix:@"http://data"]){
                            NSData *dataF=[NSData dataWithContentsOfFile:filePath];
                            tmp->isUploading=YES;
                            
                            if (VipMember) {
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                            }else
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                            NSLog(@"onlineVocalUrl lan 1 upload %@",tmp.onlineVocalUrl);
                            if (tmp.onlineVocalUrl.length>3){
                                if (![tmp.onlineVocalUrl hasPrefix:@"http://data"])
                                {
                                    if (!VipMember) {
                                        tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                                    }else
                                        tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                                    NSLog(@"onlineVocalUrl lan 2 upload %@",tmp.onlineVocalUrl);
                                }
                            }else{
                                if (!VipMember) {
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:1];
                                }else
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:2];
                                NSLog(@"onlineVocalUrl lan 2 upload %@",tmp.onlineVocalUrl);
                            }
                            if (tmp.onlineVocalUrl.length>3){
                                if (![tmp.onlineVocalUrl hasPrefix:@"http://data"])
                                {
                                    tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                                    NSLog(@"onlineVocalUrl lan 3 upload %@",tmp.onlineVocalUrl);
                                }
                            }else{
                                tmp.onlineVocalUrl=[[ UploadToServerYokara alloc] multipartUpload:filePath forKey:[NSString stringWithFormat:@"%@%@",GUID,typeKey ] andServer:3];
                                NSLog(@"onlineVocalUrl lan 3 upload %@",tmp.onlineVocalUrl);
                            }
                            tmp.mixedRecordingVideoUrl=nil;
                            
                            
                            
                        }
                        NSLog(@"onlineVocalUrl sau upload %@",tmp.onlineVocalUrl);
                       
                        tmp.message=messUp;
                        tmp.yourName=nameUp;
                        UploadRecordingResponse * uploadRes;
                        if ([tmp->hasUpload isEqualToString:@"YES"]&& !VipMember){
                            if ([tmp.onlineVocalUrl isKindOfClass:[NSString class]] ) {
                                if ([tmp.onlineVocalUrl hasPrefix:@"http"]){
                                    if ([typeKey hasSuffix:@"mp3"]) {
                                        tmp.onlineMp3Recording=[NSString stringWithFormat:@"%@", tmp.onlineVocalUrl];
                                        tmp.onlineVocalUrl=nil;
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineMp3Recording" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }else if ([typeKey hasSuffix:@"mp4"]){
                                        tmp.mixedRecordingVideoUrl=[NSString stringWithFormat:@"%@", tmp.onlineVocalUrl];
                                        tmp.onlineVocalUrl=nil;
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"mixedRecordingVideoUrl" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }else{
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineVocalUrl" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }
                                    
                                    
                                }
                            }
                            UpdateFacebookNoForRecordingResponse* respone= [[LoadData2 alloc] updateRecording:tmp];
                            if ([respone.status isKindOfClass:[NSString class]]) {
                                if ([respone.status isEqualToString:@"OK"]) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                    });
                                    // Listen for new messages in the Firebase database
                                    
                                    tmp->statusUpload=nil;
                                    uploadProssesing=NO;
                                    tmp->isUploading=NO;
                                }else{
                                    tmp->statusUpload=nil;
                                    uploadProssesing=NO;
                                    tmp->isUploading=NO;
                                }
                                tmp->statusUpload=nil;
                                
                               // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUser" object:tmp];
                                
                                
                                vitriuploadRec=99999999;
                            }else{
                                if ([respone.message isKindOfClass:[NSString class]]) {
                                    tmp->statusUpload=respone.message;
                                }
                                
                                uploadProssesing=NO;
                                tmp->isUploading=NO;
                            }
                            tmp->statusUpload=nil;
                            tmp->isUploading=NO;
                            uploadProssesing=NO;
                        }else{
                            if ([tmp.onlineVocalUrl isKindOfClass:[NSString class]] ) {
                                if ([tmp.onlineVocalUrl hasPrefix:@"http"]){
                                    if ([typeKey hasSuffix:@"mp3"]) {
                                        tmp.onlineMp3Recording=[NSString stringWithFormat:@"%@", tmp.onlineVocalUrl];
                                        tmp.onlineVocalUrl=nil;
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineMp3Recording" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }else if ([typeKey hasSuffix:@"mp4"]){
                                        tmp.mixedRecordingVideoUrl=[NSString stringWithFormat:@"%@", tmp.onlineVocalUrl];
                                        tmp.onlineVocalUrl=nil;
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"mixedRecordingVideoUrl" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }else{
                                        [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:@"onlineVocalUrl" fieldValue1:tmp.onlineVocalUrl withCondition:R_DATE conditionValue:tmp.recordingTime];
                                    }
                                    
                                    uploadRes = [[LoadData2 alloc] uploadRecordToServer:tmp andSong:tmp.song andName:nameUp andMessage:messUp andUrl:tmp.onlineVocalUrl];
                                    
                                }
                            }
                            NSLog(@"uploadRespone %@",uploadRes.recording.recordingId);
                            if([uploadRes.recording isKindOfClass:[Recording class]]){
                                tmp.statusOfProcessing=uploadRes.recording.statusOfProcessing;
                                tmp._id=uploadRes.recording._id;
                                tmp.onlineRecordingUrl= uploadRes.recording.onlineRecordingUrl ;
                                tmp.recordingId=uploadRes.recording.recordingId;
                                tmp.owner2=uploadRes.recording.owner2;
                                
                                tmp->hasUpload=@"YES";
                                if (tmp.onlineMp3Recording.length>4 || tmp.mixedRecordingVideoUrl.length>4 || VipMember) {
                                    
                                    if ([dataRecord containsObject:tmp] && [tmp.performanceType isEqualToString:@"ASK4DUET"]) {
                                        
                                        [dataRecord removeObject:tmp];
                                        [listSongMyAskDuet insertObject:tmp atIndex:0];
                                        
                                        
                                    }
                                    
                                    tmp->statusUpload=nil;
                                    
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUser" object:tmp];
                                    
                                    
                                    
                                    vitriuploadRec=99999999;
                                }else
                                    [self configeDBRecordingStatus:tmp];
                                //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideStatusView" object:nil];
                                if ([tmp._id longValue]>0) {
                                    if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_IDR fieldValue1:[NSString stringWithFormat:@"%@",tmp._id] withCondition:R_DATE conditionValue:tmp.recordingTime]) {
                                        NSLog(@"update record id" );
                                    }
                                }
                                if (tmp.recordingId.length>10) {
                                    [[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_PRIVATEID fieldValue1:[NSString stringWithFormat:@"%@",tmp.recordingId] withCondition:R_DATE conditionValue:tmp.recordingTime];
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[[[iToast makeText:AMLocalizedString(@"Xử lý bài thu thất bại", @"")]
                                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                });
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            tmp->statusUpload=nil;
                            tmp->isUploading=NO;
                            uploadProssesing=NO;
                        });
                        uploadProssesing=NO;
                        tmp->isUploading=NO;
                    }
                    else{
                        uploadProssesing=NO;
                        tmp->isUploading=NO;
                        vitriuploadRec=99999999;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            tmp->statusUpload=nil;
                            tmp->isUploading=NO;
                            uploadProssesing=NO;
                            [[[[iToast makeText:AMLocalizedString(@"Bài thu quá ngắn hoặc không có trong máy", @"")]
                               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                    }
                }
                uploadProssesing=NO;
                NSLog(@"%@",tmp.onlineVocalUrl);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinish" object:tmp];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                });
                [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
                
            });
            
            
        }else{
            if (uploadProssesing) {
                uploadProssesing=NO;
            }
        }
    }
}
- (void) uploadFileToS3 {
    @autoreleasepool {
        
           if (!VipMember) {
                [self processMixOffline:songRec];
            }else
                [self  uploadFileToServerIkara:songRec];
    }
}
- (IBAction)revealMenu:(id)sender
{
    if (isRecorded && isrecord) {
        
        [self record];
    }else
        if (playRecord) {
            alertHuyEditRecord = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                            message:AMLocalizedString(@"Bài thu chưa xử lý sẽ được lưu trong tab Cá nhân.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:AMLocalizedString(@"Thoát", nil)
                                    otherButtonTitles:AMLocalizedString(@"Quay lại", nil), nil];

            [alertHuyEditRecord performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }else{
            isrecord=NO;
            //songRecOld=nil;
            isPlayingAu=NO;
            if ( audioPlayer.rate) [audioPlayer pause];
            
            if ([self isPlaying]) [playerMain pause];
            if ([Language hasSuffix:@"kara"] && youtubePlayer){
                [youtubePlayer pauseVideo];
            }
            if ([duetVideoPlayer rate]) {
                [duetVideoPlayer pause];
            }
            isPlayingAu=NO;
            if (isVoice && audioEngine2) {
                [audioEngine2 playthroughSwitchChanged:NO];
                [audioEngine2 reverbSwitchChanged:NO];
            }
            
            if (videoRecord) {
                isrecord=NO;
                isRecorded=NO;
                //songRec.performanceType=@"SOLO";
                songRec.deviceName=[[LoadData2 alloc] getDeviceName];
                if (hasHeadset) {
                    songRec.recordDevice=@"HEADSET";
                }else{
                    songRec.recordDevice=@"NOHEADSET";
                }
                [recorder pause:^{
                    SCRecordSession *recordSession = recorder.session;
                    
                    if (recordSession != nil) {
                        recorder.session = nil;
                        
                        [recordSession cancelSession:nil];
                        
                    }
                }];
                if (recorder.isPrepared) {
                    [recorder unprepare];
                    [recorder stopRunning];
                }
            }
           
            videoRecord=NO;
            // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            if (playRecord) {
                 songRec->isUploading=NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinishNotPublic" object:songRec];
                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                });
            }
             });
        }
    
    // [self.slidingViewController anchorTopViewTo:ECRight];
}
-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
BOOL isKaraokeTab;
-(void) okPress:(BOOL) isPress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPress) {
            [LoadData2  openSettings];
        }
        
        
        [popover dismissPopoverAnimated:YES];
        self.songNameUpload.text=songPlay.songName;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString * facebookId=[prefs objectForKey:@"facebookId"];
        if (facebookId.length<3 || [currentFbUser.facebookId isKindOfClass:[NSString class]]) {
            facebookId=currentFbUser.facebookId;
        }
        if (facebookId.length>0){
            self.NameUpload.text = [prefs objectForKey:@"userName"];
            self.NameUpload.enabled=NO;
        }else{
            self.NameUpload.text = [prefs objectForKey:@"nameUpload"];
            self.NameUpload.enabled=YES;
        }
        
        self.messageUpload.text =[prefs objectForKey:@"messageUpload"];
        // [prefs setObject:nameUp forKey:@"nameUpload"];
        //[prefs setObject:messUp forKey:@"messageUpload"];
        uploadView.hidden=NO;
    });
}
- (void) checkBoxChange:(BOOL) isCheck{
    showAlertEnablePush=isCheck;
}
BOOL showAlertEnablePush;
- (IBAction)showUpload:(id)sender {
    if (isExportingVideo ||  isExportingVideoWithEffect ) {
        // [[[[iToast makeText:AMLocalizedString(@"iKara đang xử lý bài hát vui lòng chờ giây lát", @"")]
        //  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                    message:AMLocalizedString(@"Yokara đang xử lý bài thu! Vui lòng chờ trong giây lát!", nil)
                                                   delegate:self
                                          cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
        [alertV performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }else
    if ([[LoadData2 alloc]checkNetwork]) {
        
        
        self.uploadViewHuyButton.layer.cornerRadius=self.uploadViewHuyButton.frame.size.width/2;
        self.uploadViewHuyButton.layer.masksToBounds=YES;
       
        songRec.effectsNew.masterVolume=@100;
        songRec.effectsNew.delay=songRec.delay;
        songRec.effectsNew.toneShift=@0;
        if (uploadProssesing ||  mixOfflineProssesing || isExportingVideo ||  isExportingVideoWithEffect) {
         
        
            // [[[[iToast makeText:AMLocalizedString(@"iKara đang xử lý bài hát vui lòng chờ giây lát", @"")]
            //  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            alertHuyUpload = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                        message:AMLocalizedString(@"Yokara đang xử lý bài thu. Vui lòng chờ trong giây lát!", nil)
                                                       delegate:self
                                              cancelButtonTitle:AMLocalizedString(@"Hủy", nil)
                                              otherButtonTitles:nil];
            [alertHuyUpload performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }else{
             isKaraokeTab=NO;
            [NSThread detachNewThreadSelector:@selector(createSilentPCMFileWithDuration:) toTarget:self withObject:[NSNumber numberWithInt:60*8*8]];
            if (![LoadData2 isHaveRegistrationForNotification] && !showAlertEnablePush) {
                showAlertEnablePush = YES;
                AlertViewController *controller=[[AlertViewController alloc] init];
                
                controller.contentMess=[NSString stringWithFormat:AMLocalizedString(@"Vui lòng Bật Thông Báo để Yokara có thể thông báo cho bạn khi bài thu xử lý xong!", nil)];
                controller.contentAdd=AMLocalizedString(@"Không hiện lại nữa", nil);
                controller.view.frame=CGRectMake(0, 0, 320, 160);
                NSString *untickedBoxStr = @"\u2610";
                controller.checkboxLabel.text=untickedBoxStr;
                controller.delegate=self;
                popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
                popover.tint = FPPopoverWhiteTint;
                popover.keyboardHeight = _keyboardHeight;
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    popover.contentSize = CGSizeMake(self.view.frame.size.width-2, 165);
                }
                else {
                    popover.contentSize = CGSizeMake(self.view.frame.size.width-2, 165);
                }
                popover.arrowDirection = FPPopoverNoArrow;
                [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height/2)];
            }else{
                
                //if ((playVideoRecorded && CMTimeGetSeconds([self playerItemDuration2])>60) ||( !playVideoRecorded && audioPlayRecorder.duration>60)){
                streamPlay=NO;
                isPlayingAu=NO;
                if (playerMain.rate) {
                    [playerMain pause];
                }
                if (audioPlayer.rate){
                    [audioPlayer pause];
                }
                
                
                songRec.effectsNew.effects=[NSMutableDictionary new];
                if ([karaokeEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
                }else if ([studioEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
                    
                    
                }else  if ([liveEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
                    
                    
                }else  if ([superbassEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
                    
                    
                }else  if ([remixEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
                    
                    
                }else  if ([boleroEffect.enable integerValue]) {
                    
                    [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
                    
                    
                }
                if ([voicechangerEffect.enable integerValue]) {
                    
                    
                    [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
                    
                    
                }
                if ([autotuneEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
                }
                if ([denoiseEffect.enable integerValue]) {
                    [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
                }
                if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_NEWEFFECTS fieldValue1:[songRec.effectsNew toJSONString] withCondition:R_DATE conditionValue:songRec.recordingTime]) NSLog(@"update effect record");
               
               
                   
                    UploadRecordingViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadBaiThuView"];
                    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
                    // [[MainViewController alloc] initWithPlayer:theSong._id];
                    mainv.recording=songRec;
                    
                    [self.navigationController pushViewController:mainv animated:NO];
            
                /*
                 self.songNameUpload.text=songPlay.songName;
                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                 NSString * facebookId=[prefs objectForKey:@"facebookId"];
                 if (facebookId.length>0){
                 self.NameUpload.text = [prefs objectForKey:@"userName"];
                 self.NameUpload.enabled=NO;
                 }else{
                 self.NameUpload.text = [prefs objectForKey:@"nameUpload"];
                 self.NameUpload.enabled=YES;
                 }
                 
                 self.messageUpload.text =[prefs objectForKey:@"messageUpload"];
                 // [prefs setObject:nameUp forKey:@"nameUpload"];
                 //[prefs setObject:messUp forKey:@"messageUpload"];
                 uploadView.hidden=NO;
                 CGRect frame=self.uploadView.frame;
                 frame.origin.y=self.view.frame.size.height;
                 self.uploadView.frame=frame;
                 [UIView animateWithDuration:0.5 animations:^{
                 CGRect frame=self.uploadView.frame;
                 frame.origin.y=0;
                 self.uploadView.frame=frame;
                 }];
                 if (!showLoginAlert && facebookId.length==0) {
                 showLoginAlert=YES;
                 alertLinkFacebook=[[UIAlertView alloc] initWithTitle:@"Đăng Nhập" message:@"Để quản lý bài thu tốt hơn, bạn nên đăng nhập ứng dụng. Bạn có muốn đăng nhập ngay bây giờ?" delegate:self cancelButtonTitle:AMLocalizedString(@"Không",nil) otherButtonTitles:AMLocalizedString(@"Có",nil), nil];
                 [alertLinkFacebook show];
                 }
                 }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                 [[[[iToast makeText:AMLocalizedString(@"Bài thu phải trên 60s mới được xử lý", nil)]
                 setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                 });
                 
                 }*/
            }
        }
    }
}
- (void)loginSussess{
    
}
- (void)dismissView{
    
}
- (IBAction)hideXuly:(id)sender {
    self.xulyView.hidden=YES;
    
}

- (IBAction)uploadRec:(id)sender {
    if ([[LoadData2 alloc] checkNetwork]){
        // if ((playVideoRecorded && CMTimeGetSeconds([self playerItemDuration2])>60) ||( !playVideoRecorded && audioPlayRecorder.duration>60)){
       
        /* [Answers logContentViewWithName:@"Process"
         contentType:@"Process Record"
         contentId:@"PRProcess"
         customAttributes:@{}];*/
        //uploadProssesing=YES;
        if (playerMain.rate) {
            [playerMain pause];
        }
        if (audioPlayer.rate){
            [audioPlayer pause];
        }
       
        songRec.effectsNew.vocalVolume=songRec.effects.vocalVolume;
        songRec.effectsNew.beatVolume=songRec.effects.musicVolume;
        songRec.effectsNew.delay=songRec.delay;
        songRec.effectsNew.toneShift=songRec.effects.toneShift;
        songRec.effectsNew.masterVolume=@100;
        nameUp = NameUpload.text;
        messUp= messageUpload.text;
        if (nameUp==nil) nameUp=@" ";
        if (messUp == nil) messUp=@" ";
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //self.NameUpload.text = [prefs objectForKey:@"nameUpload"];
        //self.messageUpload.text =[prefs objectForKey:@"messageUpload"];
        [prefs setObject:nameUp forKey:@"nameUpload"];
        [prefs setObject:messUp forKey:@"messageUpload"];
        
        //messUp=@"Fun";
        if (privacyRecordingisPrivate) {
            songRec.privacyLevel=@"PRIVATE";
        }else
            songRec.privacyLevel=@"PUBLIC";
        
         //   [NSThread detachNewThreadSelector:@selector(uploadFileToS3) toTarget:self withObject:nil];
        
        songRec.effectsNew.effects=[NSMutableDictionary new];
        if ([karaokeEffect.enable integerValue]) {
            [songRec.effectsNew.effects setObject:[karaokeEffect toDictionary] forKey:@"KARAOKE"];
        }else if ([studioEffect.enable integerValue]) {
            
            [songRec.effectsNew.effects setObject:[studioEffect toDictionary] forKey:@"STUDIO"];
            
            
        }else  if ([liveEffect.enable integerValue]) {
            
            [songRec.effectsNew.effects setObject:[liveEffect toDictionary] forKey:@"LIVE"];
            
            
        }else  if ([superbassEffect.enable integerValue]) {
            
            [songRec.effectsNew.effects setObject:[superbassEffect toDictionary] forKey:Key_SuperBass];
            
            
        }else  if ([remixEffect.enable integerValue]) {
            
            [songRec.effectsNew.effects setObject:[remixEffect toDictionary] forKey:Key_Remix];
            
            
        }else  if ([boleroEffect.enable integerValue]) {
            
            [songRec.effectsNew.effects setObject:[boleroEffect toDictionary] forKey:Key_Bolero];
            
            
        }
        if ([voicechangerEffect.enable integerValue]) {
            
            
            [songRec.effectsNew.effects setObject:[voicechangerEffect toDictionary] forKey:@"VOICECHANGER"];
            
            
        }
        if ([autotuneEffect.enable integerValue]) {
            [songRec.effectsNew.effects setObject:[autotuneEffect toDictionary] forKey:@"AUTOTUNE"];
        }
        if ([denoiseEffect.enable integerValue]) {
            [songRec.effectsNew.effects setObject:[denoiseEffect toDictionary]forKey:@"DENOISE"];
        }
       // if ([[DBHelperYokaraSDK alloc] updateTable:R_Table withField1:R_NEWEFFECTS fieldValue1:[songRec.effectsNew toJSONString] withCondition:R_DATE conditionValue:songRec.recordingTime]) NSLog(@"update url song");
         [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"showStatusView" object:nil];
      /*  StatusUploadRecordingViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrangThaiUploadBaithuView"];
        //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
        // [[MainViewController alloc] initWithPlayer:theSong._id];
        recordingCurrentUpload=songRec;
        
        [self.navigationController pushViewController:mainv animated:NO];
       */
        /*}else{
         dispatch_async(dispatch_get_main_queue(), ^{
         [[[[iToast makeText:AMLocalizedString(@"Bài thu phải trên 60s mới được xử lý", nil)]
         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
         });
         
         }*/
    }
    uploadView.hidden = YES;
}
- (IBAction)huyUpload:(id)sender {
    uploadView.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame=self.uploadView.frame;
        frame.origin.y=self.view.frame.size.height;
        self.uploadView.frame=frame;
    }];
    
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
   /* [controllerRecord.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-8, (controllerRecord.array.count)*50+20)];
    controllerRecord.view.center=self.saveRecordView.center;*/
    [self.lyricView setNeedsDisplay];
    //karaokeDisplayElement.frame=self.view.frame;
   
            // self.navigationController.navigationBarHidden =YES;
    
            if (![self.xulyView isHidden]){
                self.xulyView.hidden=YES;
            }
           
    
    if (![Language hasSuffix:@"kara"]){
        [karaokeDisplay reset];
        
        [karaokeDisplay _updateOrientation ];
        CGFloat height=[karaokeDisplay getHeight:@"Karaoke" andSize:[karaokeDisplay.paint.getPaint fontsize] ];
        karaokeDisplayElement.frame=CGRectMake(20, 180,karaokeDisplayElement.frame.size.width,height*(numDisplayLineLyric +1));
        karaokeDisplayElement.center=self.view.center;
        self.menuLyric.hidden=YES;
        
        /// playerLayer.frame=self.playerView.frame;
    }
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        
        self.showplainText.font=[UIFont fontWithName:@"Arial" size:30];
    }else self.showplainText.font=[UIFont fontWithName:@"Arial" size:25];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //  if (videoRecord)
    //     return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return NO;
}

/*
 - (NSInteger)supportedInterfaceOrientations
 {
 if (videoRecord)
 return UIInterfaceOrientationMaskLandscapeLeft;
 else return UIInterfaceOrientationMaskAll;
 }*/
- (BOOL)shouldAutorotate{
    if (videoRecord)
        return NO;
    else return YES;
}
/*
 - (BOOL)shouldAutorotate
 {
 // Disable autorotation of the interface when recording is in progress.
 return ![self lockInterfaceRotation];
 }
 - (BOOL)shouldAutorotate{
 if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||[[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
 {
 return YES;
 }
 else{
 return NO;
 }
 }*/
- (void) nextSongPlay{
    [self performSelectorOnMainThread:@selector(gotoNextSong) withObject:nil waitUntilDone:NO];
}
- (void) gotoNextSong{
    // if (VipMember){
   
}
UIBackgroundTaskIdentifier bgTask12;
- (void) exportVideoWithEffect:(SCAssetExportSession *) assetExport{
    isExportingVideoWithEffect=YES;
   assetExportSession =assetExport;
    Recording * tmp=songRec;
    tmp->isExportVideo=YES;
    double timeExport=CACurrentMediaTime();
    bgTask12= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"MyTaskEx" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [[UIApplication sharedApplication] endBackgroundTask:bgTask12];
        bgTask12 = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [assetExportSession exportAsynchronouslyWithCompletionHandler: ^{
            if (assetExportSession.error == nil) {
                // We have our video and/or audio file
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                tmp.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]];
                songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                
            } else {
                // Something bad happened
            }
            tmp->isExportVideo=NO;
            isExportingVideoWithEffect=NO;
            
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUserInfo" object:nil];
            NSLog(@"time export %f",CACurrentMediaTime()-timeExport);
            [[UIApplication sharedApplication] endBackgroundTask:bgTask12];
            bgTask12 = UIBackgroundTaskInvalid;
            recordSessionTmp=nil;
        }];
        
    });
}
UIBackgroundTaskIdentifier bgTask22;
- (void) exportVideo:(SCRecordSession *) recordSession{
    NSString *recordingTime=songRec.recordingTime;
    isExportingVideo=YES;
    
    Recording * tmp=songRec;
    tmp->isExportVideo=YES;
    double timeExport=CACurrentMediaTime();
    bgTask22= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"MyTaskEx" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [[UIApplication sharedApplication] endBackgroundTask:bgTask22];
        bgTask22 = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        assetExportSessionNoEffect= [recordSession mergeSegmentsUsingPreset:AVAssetExportPresetHighestQuality completionHandler:^(NSURL *url, NSError *error) {
            NSLog(@"exportVideo %@ error %@",url,error.debugDescription);
            if (error == nil) {
                // Easily save to camera roll
                NSFileManager *fileManager = [NSFileManager defaultManager];
                //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                if ([fileManager fileExistsAtPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",recordingTime]]] == YES) {
                    [fileManager removeItemAtPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",recordingTime]] error:&error];
                    
                }
                
                //NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
                [fileManager copyItemAtPath:[url path] toPath:[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]] error:&error];
                [fileManager removeItemAtPath:[url path] error:&error];
                tmp.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",tmp.recordingTime]];
                songRec.vocalUrl=[documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.mov",songRec.recordingTime]];
                NSLog(@"time export %f",CACurrentMediaTime()-timeExport);
            }
            tmp->isExportVideo=NO;
            isExportingVideo=NO;
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUserInfo" object:nil];
            [[UIApplication sharedApplication] endBackgroundTask:bgTask22];
            bgTask22 = UIBackgroundTaskInvalid;
            recordSessionTmp=nil;
        }];
    });
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    UIView* view = [self view];
    UISwipeGestureRecognizerDirection direction = [gestureRecognizer direction];
    CGPoint location = [gestureRecognizer locationInView:view];
    
    if (location.y < CGRectGetMidY([view bounds]))
    {
        if (direction == UISwipeGestureRecognizerDirectionUp)
        {
            [UIView animateWithDuration:0.2f animations:
             ^{
                 [[self navigationController] setNavigationBarHidden:YES animated:YES];
             } completion:
             ^(BOOL finished)
             {
                 [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
             }];
        }
        if (direction == UISwipeGestureRecognizerDirectionDown)
        {
            [UIView animateWithDuration:0.2f animations:
             ^{
                 [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
             } completion:
             ^(BOOL finished)
             {
                 [[self navigationController] setNavigationBarHidden:YES animated:YES];
             }];
        }
    }
    else
    {
        if (direction == UISwipeGestureRecognizerDirectionDown)
        {
            if (![toolBar isHidden])
            {
                [toolBar setHidden:YES];
                [showSongName setHidden:YES];/*
                                              [UIView animateWithDuration:0.2f animations:
                                              ^{
                                              [toolBar setTransform:CGAffineTransformMakeTranslation(0.f, CGRectGetHeight([toolBar bounds]))];
                                              } completion:
                                              ^(BOOL finished)
                                              {
                                              
                                              }];*/
            }
        }
        else if (direction == UISwipeGestureRecognizerDirectionUp)
        {
            if ([toolBar isHidden])
            {
                [toolBar setHidden:NO];
                [showSongName setHidden:NO];
                showSongName.text=tieude;
                [isLoading setHidden:YES];
                /*[UIView animateWithDuration:0.2f animations:
                 ^{
                 [toolBar setTransform:CGAffineTransformIdentity];
                 } completion:^(BOOL finished){}];*/
            }
        }
    }
}




@end

@implementation StreamingMovieViewController (Player)

#pragma mark -

#pragma mark Player

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
    
    AVPlayerItem *thePlayerItem ;
    if ( playRecord  && audioPlayer && !isrecord  ){
        thePlayerItem= [audioPlayer currentItem];
    }/*else if  (playRecord && audioPlayRecorder ){
      return CMTimeMakeWithSeconds(audioPlayRecorder.duration, NSEC_PER_SEC);
      }
    
    else if (isrecord && [songRec.performanceType isEqualToString:@"DUET"] && duetVideoPlayer){
        thePlayerItem=[duetVideoPlayer currentItem];
    }*/else
        thePlayerItem= [playerMain currentItem];
    
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        
        CMTime itemDuration = [thePlayerItem duration];
        if (CMTimeGetSeconds( itemDuration)>1260 ) {
            itemDuration=CMTimeMakeWithSeconds(1260, NSEC_PER_SEC);
        }
        if (streamDuration>60000 ) {
            itemDuration=CMTimeMakeWithSeconds(streamDuration/1000, NSEC_PER_SEC);
        }
        return(itemDuration);
    }
    
    return(kCMTimeInvalid);
    /*
     CMTime itemDuration = kCMTimeInvalid;
     
     // Once the AVPlayerItem becomes ready to play, i.e. [playerItem status] == AVPlayerItemStatusReadyToPlay),
     // its duration can be fetched from the item as follows.
     if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
     {
     if ([AVPlayerItem instancesRespondToSelector:@selector (duration)]) {
     
     // Fetch the duration directly from the AVPlayerItem.
     
     itemDuration = [playerItem duration];
     }
     else {
     // Reach through the AVPlayerItem to its asset to get the duration.
     itemDuration = [[playerItem asset] duration];
     }
     }
     return itemDuration;*/
}
- (CMTime)playerItemDuration2
{
    
    AVPlayerItem *thePlayerItem ;
    
    thePlayerItem= [audioPlayer currentItem];
    
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        
        CMTime itemDuration = [thePlayerItem duration];
        if (CMTimeGetSeconds( itemDuration)>1000) {
            itemDuration=CMTimeMakeWithSeconds(500, NSEC_PER_SEC);
        }
        return(itemDuration);
    }
    
    return(kCMTimeInvalid);
    /*
     CMTime itemDuration = kCMTimeInvalid;
     
     // Once the AVPlayerItem becomes ready to play, i.e. [playerItem status] == AVPlayerItemStatusReadyToPlay),
     // its duration can be fetched from the item as follows.
     if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
     {
     if ([AVPlayerItem instancesRespondToSelector:@selector (duration)]) {
     
     // Fetch the duration directly from the AVPlayerItem.
     
     itemDuration = [playerItem duration];
     }
     else {
     // Reach through the AVPlayerItem to its asset to get the duration.
     itemDuration = [[playerItem asset] duration];
     }
     }
     return itemDuration;*/
}
- (BOOL)isPlaying
{
    
    return restoreAfterScrubbingRate != 0.f || [playerMain rate] != 0.f;
}
- (BOOL) isPlayingAudio{
    return restoreAfterScrubbingRate != 0.f ||[audioPlayer rate] != 0.f;
}
#pragma mark Player Notifications
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    audioEnd = YES;
    
}

/* Called when the player item has played to its end time. */
- (void) playerItemDidReachEnd:(NSNotification*) aNotification
{
    /* Hide the 'Pause' button, show the 'Play' button in the slider control */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        seekToZeroBeforePlay = YES;
    isPlayingAu=NO;
    NSLog(@"end player");
        [self showPlayButton];
   // [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
    if (isVoice && audioEngine2) {
        [audioEngine2 reverbSwitchChanged:NO];
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 expanderSwitchChanged:NO];
    }
    if ([duetVideoPlayer isKindOfClass:[AVPlayer class]]) {
        if ([duetVideoPlayer rate]) {
            [duetVideoPlayer pause];
        }
    }
  
    isLoading.hidden=YES;
        self.movieTimeControl.value = 0;
    //[self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
    
    if (isrecord && isRecorded) [self record];
    /* After the movie has played to its end time, seek back to time zero
     to play it again */
    
    });
    
}
BOOL autoChangePlayList;
- (void) showAlertChangePlayList{
    /*
     alertChangePlayList = [[UIAlertView alloc] init];
     self.recordImage.hidden=YES;
     [alertChangePlayList setTitle:AMLocalizedString(@"Bài Kế Tiếp",nil)];
     [alertChangePlayList setMessage:AMLocalizedString(@"Bạn có muốn hát bài kế tiếp?",nil)];
     [alertChangePlayList setDelegate:self];
     [alertChangePlayList addButtonWithTitle:AMLocalizedString(@"Có",nil)];
     [alertChangePlayList addButtonWithTitle:AMLocalizedString(@"Không",nil)];
     [alertChangePlayList performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];*/
    
    if (!autoChangePlayList && !cancelAutoPlaylist){
        self.finishViewHuyButton.hidden=NO;
        //if (VipMember){
        self.finishViewLabel.text=@"Tự động chuyển bài sau 5 giây.";
        /* }else {
         self.finishViewLabel.text=@"Nâng cấp VIP để hiện điểm!";
         }*/
        self.finishViewNoButton.hidden=YES;
        self.finishViewYesButton.hidden=YES;
        self.finishViewChangePlaylistNoButton.hidden=YES;
        self.finishViewChangePlaylistYesButton.hidden=YES;
        [self performSelector:@selector(nextSongPlay) withObject:nil afterDelay:5];
    }else {
        self.finishViewHuyButton.hidden=YES;
        self.finishViewLabel.text=@"Bạn muốn phát bài kế tiếp!";
        self.finishViewNoButton.hidden=YES;
        self.finishViewYesButton.hidden=YES;
        self.finishViewChangePlaylistNoButton.hidden=YES;
        self.finishViewChangePlaylistYesButton.hidden=YES;
    }
    self.finishRecordView.hidden=NO;
    demMark=0;
    mark=RAND_FROM_TO(75, 100);
    demMarkTimer=[NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(demMarkTime)
                                                userInfo:nil
                                                 repeats:NO];
    
}
- (void) playerItemDidReachEnd2:(NSNotification*) aNotification
{
    if (playRecord ) {
        NSLog(@"end and play again");
        
      [self.audioTapProcessor seekToZero];
        
                [audioPlayer seekToTime:kCMTimeZero];
            
        
        
      
        if (audioPlayer.rate==0) {
            [audioPlayer play];
        }
        
        
        
        if (playerYoutubeVideoTmp) {
            [playerYoutubeVideoTmp seekToTime:kCMTimeZero];
            [playerYoutubeVideoTmp play];
        }
        
       
            
        
    }else
    if (isrecord) {
        
    
    if ([duetVideoPlayer rate]) {
        [duetVideoPlayer pause];
    }
    seekToZeroBeforePlay = YES;
    isPlayingAu=NO;
    if ([playerMain rate]!=0) [playerMain pause];
  
    /* Hide the 'Pause' button, show the 'Play' button in the slider control */
    isLoading.hidden=YES;
    if (isVoice && audioEngine2) {
        [audioEngine2 reverbSwitchChanged:NO];
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 expanderSwitchChanged:NO];
    }
    NSLog(@"end audio");
    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying) {
        [youtubePlayer pauseVideo];
    }
    [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
    [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
    // if (isrecord) [self record];
    /* After the movie has played to its end time, seek back to time zero
     to play it again */
    }
    
    //tangLuotNghe=YES;
}
- (void) playerItemDidReachEnd3:(NSNotification*) aNotification
{
    if (isrecord) {
        seekToZeroBeforePlay = YES;
        isPlayingAu=NO;
    
    if (isrecord && isRecorded) [self record];
   
    if ([playerMain rate]!=0) [playerMain pause];
  
    /* Hide the 'Pause' button, show the 'Play' button in the slider control */
    isLoading.hidden=YES;
    if (isVoice && audioEngine2) {
        [audioEngine2 reverbSwitchChanged:NO];
        [audioEngine2 playthroughSwitchChanged:NO];
        [audioEngine2 expanderSwitchChanged:NO];
    }
    NSLog(@"end duet video");
    if ([Language hasSuffix:@"kara"] && youtubePlayer.playerState==kYTPlayerStatePlaying) {
        [youtubePlayer pauseVideo];
    }
    [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
    [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
    // if (isrecord) [self record];
    /* After the movie has played to its end time, seek back to time zero
     to play it again */
    }
    
    //tangLuotNghe=YES;
}
#pragma mark -
#pragma mark Timed metadata
#pragma mark -

- (void)handleTimedMetadata:(AVMetadataItem*)timedMetadata
{
    /* We expect the content to contain plists encoded as timed metadata. AVPlayer turns these into NSDictionaries. */
    if ([(NSString *)[timedMetadata key] isEqualToString:AVMetadataID3MetadataKeyGeneralEncapsulatedObject])
    {
        if ([[timedMetadata value] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *propertyList = (NSDictionary *)[timedMetadata value];
            
            /* Metadata payload could be the list of ads. */
            NSArray *newAdList = [propertyList objectForKey:@"ad-list"];
            if (newAdList != nil)
            {
                [self updateAdList:newAdList];
                NSLog(@"ad-list is %@", newAdList);
            }
            
            /* Or it might be an ad record. */
            NSString *adURL = [propertyList objectForKey:@"url"];
            if (adURL != nil)
            {
                if ([adURL isEqualToString:@""])
                {
                    /* Ad is not playing, so clear text. */
                    self.isPlayingAdText.text = @"";
                    
                    [self enablePlayerButtons];
                    [self enableScrubber]; /* Enable seeking for main content. */
                    
                    NSLog(@"enabling seek at %g", CMTimeGetSeconds([playerMain currentTime]));
                }
                else
                {
                    /* Display text indicating that an Ad is now playing. */
                    self.isPlayingAdText.text = @"< Ad now playing, seeking is disabled on the movie controller... >";
                    
                    [self disablePlayerButtons];
                    [self disableScrubber];     /* Disable seeking for ad content. */
                    
                    NSLog(@"disabling seek at %g", CMTimeGetSeconds([playerMain currentTime]));
                }
            }
        }
    }
}

#pragma mark Ad list

/* Update current ad list, set slider to match current player item seekable time ranges */
- (void)updateAdList:(NSArray *)newAdList
{
    if (!adList || ![adList isEqualToArray:newAdList])
    {
        newAdList = [newAdList copy];
        adList = newAdList;
        
        [self sliderSyncToPlayerSeekableTimeRanges];
    }
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    
    
    
    //if (playerMain && ![Language hasSuffix:@"kara"]) playerMain=nil;
    
    /* Display the error. */
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

#pragma mark Prepare to play asset

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            
            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:error waitUntilDone:NO];
            return;
        }
        /* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail
         out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = AMLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = AMLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        
        [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:assetCannotBePlayedError waitUntilDone:NO];
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    if (isKaraokeTab){
        [self initScrubberTimer];
        [self enableScrubber];
        [self enablePlayerButtons];
    }
    /* Stop observing our prior AVPlayerItem, if we have one. */
    /*if (playerItem)
    {
     
        [playerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:playerItem];
    }*/
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    
    seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if ( playerMain==nil)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        playerMain=[AVPlayer playerWithPlayerItem:playerItem];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        //if (![Language hasSuffix:@"kara"])
            [playerMain addObserver:self
                         forKeyPath:kCurrentItemKey
                            options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                            context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        
        [playerMain addObserver:self
                     forKeyPath:kTimedMetadataKey
                        options:0
                        context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        [playerMain addObserver:self
                     forKeyPath:kRateKey
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:MyStreamingMovieViewControllerRateObservationContext];
    }else{
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        //  if (![Language hasSuffix:@"kara"])
        [playerMain addObserver:self
                     forKeyPath:kCurrentItemKey
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        
        [playerMain addObserver:self
                     forKeyPath:kTimedMetadataKey
                        options:0
                        context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        [playerMain addObserver:self
                     forKeyPath:kRateKey
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:MyStreamingMovieViewControllerRateObservationContext];
        
    }
    hasObser=YES;
    /* Make our new AVPlayerItôtotem the AVPlayer's current item. */
    AVPlayerItem *item=playerMain.currentItem;
    if (item != playerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [playerMain replaceCurrentItemWithPlayerItem:playerItem];
        item=nil;
        if (isKaraokeTab)
            [self syncPlayPauseButtons];
    }
    
    
}
- (void)prepareToPlayAsset2:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            
            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:error waitUntilDone:NO];
            return;
        }
        /* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail
         out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = AMLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = AMLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        
        [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:assetCannotBePlayedError waitUntilDone:NO];
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    if (isKaraokeTab){
         //[self initScrubberTimer2];
        [self enableScrubber];
        [self enablePlayerButtons];
    }
    //[self enableScrubber];
    //[self enablePlayerButtons];
    /*if (playerItem2)
    {
     
        
        [playerItem2 removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem2];
    }*/
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem2 = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem2 addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext2];
    hasObser2=YES;
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd2:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem2];
    
    ///seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if ( audioPlayer==nil)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        audioPlayer=[AVPlayer playerWithPlayerItem:playerItem2];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [audioPlayer addObserver:self  forKeyPath:kCurrentItemKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew  context:MyStreamingMovieViewControllerCurrentItemObservationContext2];
        
        /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
        [audioPlayer addObserver:self  forKeyPath:kTimedMetadataKey    options:0 context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [audioPlayer addObserver:self    forKeyPath:kRateKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew   context:MyStreamingMovieViewControllerRateObservationContext2];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=audioPlayer.currentItem;
    if (item != playerItem2)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [audioPlayer replaceCurrentItemWithPlayerItem:playerItem2];
        item=nil;
        //[self syncPlayPauseButtons];
    }
    
    
}
- (void)prepareToPlayAsset3:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            
            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:error waitUntilDone:NO];
            return;
        }
        /* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail
         out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = AMLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = AMLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        
        [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:assetCannotBePlayedError waitUntilDone:NO];
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    //[self enableScrubber];
    //[self enablePlayerButtons];
  /*  if (playerItem3)
    {
        
        [playerItem3 removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem3];
    }
    */
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem3 = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem3 addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext3];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd3:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem3];
    
    ///seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if ( duetVideoPlayer==nil)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        duetVideoPlayer=[AVPlayer playerWithPlayerItem:playerItem3];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        //[duetVideoPlayer addObserver:self  forKeyPath:kCurrentItemKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew  context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        
        /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
        // [duetVideoPlayer addObserver:self  forKeyPath:kTimedMetadataKey    options:0 context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
         [duetVideoPlayer addObserver:self    forKeyPath:kRateKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew   context:MyStreamingMovieViewControllerRateObservationContext3];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=duetVideoPlayer.currentItem;
    if (item != playerItem3)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [duetVideoPlayer replaceCurrentItemWithPlayerItem:playerItem3];
        item=nil;
        //[self syncPlayPauseButtons];
    }
    
    
}
- (void)prepareToPlayAsset4:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            
            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:error waitUntilDone:NO];
            return;
        }
        /* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail
         out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = AMLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = AMLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        
        [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:assetCannotBePlayedError waitUntilDone:NO];
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    //[self enableScrubber];
    //[self enablePlayerButtons];
   /* if (playerItem4)
    {
    
        [playerItem4 removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem4];
    }*/
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem4 = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem4 addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext4];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd3:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem4];
    
    ///seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if ( playerYoutubeVideoTmp==nil)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        playerYoutubeVideoTmp=[AVPlayer playerWithPlayerItem:playerItem4];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        //[duetVideoPlayer addObserver:self  forKeyPath:kCurrentItemKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew  context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        
        /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
        // [duetVideoPlayer addObserver:self  forKeyPath:kTimedMetadataKey    options:0 context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        // [duetVideoPlayer addObserver:self    forKeyPath:kRateKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew   context:MyStreamingMovieViewControllerRateObservationContext2];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=playerYoutubeVideoTmp.currentItem;
    if (item != playerItem4)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [playerYoutubeVideoTmp replaceCurrentItemWithPlayerItem:playerItem4];
        item=nil;
        //[self syncPlayPauseButtons];
    }
    
    
}
#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    
    /* AVPlayerItem "status" property value observer. */
    
    if (context == RecordingContext)
    {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        
        
        if (isRecording)
        {
            NSLog(@"đang record");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recordImage.hidden=NO;
                [self.pauseBtt setImage:nil forState:UIControlStateNormal];
                self.recordAlertImage.hidden=NO;
            });
        }
        else
        {
            NSLog(@"không record");
            if (isrecord) {
                isrecord=NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.recordImage.hidden=YES;
                    self.recordAlertImage.hidden=YES;
                     [self.pauseBtt setImage:[UIImage imageNamed:@"pause64p.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    [[[[iToast makeText:AMLocalizedString(@"Thiết lập camera thất bại không thể ghi hình! Vui lòng thử lại!",nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                });
            }
            
        }
        
    }
    else if (context == SessionRunningAndDeviceAuthorizedContext)
    {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRunning)
            {
                //self.recordImage.hidden=NO;
                NSLog(@"đang run record");
            }
            else
            {
                NSLog(@"không run record");
                // self.recordImage.hidden=YES;
            }
        });
    }else
#pragma mark MyStreamingMovieViewControllerPlayerItemStatusObserverContext
        // if (isKaraokeTab){
        if (context == MyStreamingMovieViewControllerPlayerItemStatusObserverContext)
        {
            if (isKaraokeTab){
                [self syncPlayPauseButtons];
                NSLog(@"change status player");
                AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
                switch (status)
                {
                        /* Indicates that the status of the player is not yet known because
                         it has not tried to load new media resources for playback */
                    case AVPlayerStatusUnknown:
                    {
                        if (isKaraokeTab){
                            [self removePlayerTimeObserver];
                            [self syncScrubber];
                            
                            [self disableScrubber];
                            [self disablePlayerButtons];
                        }
                    }
                        break;
                        
                    case AVPlayerStatusReadyToPlay:
                    {
                        /* Once the AVPlayerItem becomes ready to play, i.e.
                         [playerItem status] == AVPlayerItemStatusReadyToPlay,
                         its duration can be fetched from the item. */
                        
                        if (isKaraokeTab){
                            self.isLoading.hidden=YES;
                            playerLayerView.hidden=NO;
                            float playthroughVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"playthroghVolume"];
                            float micoEchoVolume=[[NSUserDefaults standardUserDefaults] floatForKey:@"EchoVolume"];
                            if (playthroughVolume>0 && audioEngine2) {
                                [audioEngine2 setPlaythroughVolume:playthroughVolume];
                            }
                            if (micoEchoVolume>0 && micoEchoVolume<=100 && audioEngine2) {
                                [audioEngine2 setEchoVolume:micoEchoVolume];
                            }
                            if ([songRec.performanceType isEqualToString:@"DUET" ] || [songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                                if (!_lyricView) {
                                    [self loadLyricDuet];
                                }
                            }
                            if (isrecord) {
                                if (!isVoice && hasHeadset  && !playRecord && !playRecUpload && !playTopRec && !playthroughOn && audioEngine2) {
                                    [audioEngine2 playthroughSwitchChanged:YES];
                                    [audioEngine2 reverbSwitchChanged:YES];
                                }
                            }
                            NSLog(@"ready play");
                            [toolBar setHidden:NO];
                            if (playRecord) {self.xulyView.hidden=NO;
                                if (![songRec->hasUpload isEqualToString:@"YES"] && playVideoRecorded) {
                                    //  self.colectionView.hidden=NO;
                                }else{
                                    
                                    //self.colectionView.hidden=YES;
                                }
                            }
                            else self.xulyView.hidden=YES;
                            
                            [showSongName setHidden:NO];
                            showSongName.text=tieude;
                            [isLoading setHidden:YES];
                            /* Show the movie slider control since the movie is now ready to play. */
                            movieTimeControl.hidden = NO;
                            
                            [self enableScrubber];
                            [self enablePlayerButtons];
                            [self initScrubberTimer];
                            if (hasHeadset || playTopRec || playRecord||playRecUpload) self.warningHeadset.hidden=YES;
                            else self.warningHeadset.hidden=NO;
                            if ( [songRec.performanceType isEqualToString:@"DUET"] && !playRecord && isDownload) {
                                playerMain.muted=YES;
                            }
                            if (playRecord && isDownload) {
                                
                            }else
                            if (playRecord && VipMember  ){
                                
                                playerLayerView.playerLayer.hidden = NO;
                                playerLayerViewRec.hidden=YES;
                                playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                
                                
                                [playerLayerView.playerLayer setPlayer:playerMain];
                                // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                
                                
                            }else
                                if ((!(playRecord && playVideoRecorded) && ![songRec.performanceType isEqualToString:@"DUET"])|| (playRecord && VipMember && ![songRec.performanceType isEqualToString:@"DUET"])) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerViewRec.hidden=YES;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                    // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                   // self.previewView.frame=CGRectMake(0, playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-playerLayerView.frame.size.height);
                                }else if (videoRecord  && [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"]) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    playerMain.muted=YES;
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                    // playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                    //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
                                    NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
                                  
                                    self.previewView.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width);
                                   
                                    
                                }else if (videoRecord  && [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"]) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    playerMain.muted=YES;
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                    //playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                    //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
                                    NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
                                  
                                    CGRect frameToolbar=self.toolBar.frame;
                                    
                                    
                                    frameToolbar.origin.y=playerLayerView.frame.size.height-self.toolBar.frame.size.height;
                                    
                                    
                                    
                                    self.toolBar.backgroundColor=[UIColor clearColor];
                                    //  self.toolBar.frame=frameToolbar;
                                    CGRect frame=_duetUserView.frame;
                                    frame.origin.x=0;
                                    frame.origin.y=playerLayerView.frame.size.height;
                                    _duetUserView.frame=frame;
                                    self.previewView.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.previewView.frame.size.width, self.previewView.frame.size.width);
                                    
                                    
                                }else if (isrecord  && [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"]) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    playerMain.muted=YES;
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                  //  playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                                    //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
                                    NSLog(@"duet video layer %f",playerLayerView.playerLayer.frame.size.height);
                                 
                                    
                                    
                                }else if ( [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"] && !playVideoRecorded) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    playerMain.muted=YES;
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                    //playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                  
                                    NSLog(@"duet video layer %f",self.duetVideoLayer.frame.size.height);
                                }else if (( [songPlay.songUrl hasSuffix:@"mp3"] && [songRec.performanceType isEqualToString:@"DUET"] && !playVideoRecorded)) {
                                    playerLayerView.playerLayer.hidden = NO;
                                    playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    playerMain.muted=YES;
                                    
                                    [playerLayerView.playerLayer setPlayer:playerMain];
                                   
                                    NSLog(@"duet video layer %f",self.duetVideoLayer.frame.size.height);
                                }
                            /* if (playRecord && (!playVideoRecorded || VipMember)) {
                             self.xulyView.frame=CGRectMake(0,self.playerLayerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.editViewButton.frame.size.height-self.playerLayerView.frame.size.height);
                             self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
                             }*/
                            
                            //if (!([Language hasSuffix:@"kara"] && (playTopRec || playRecUpload))){
                            
                            // }
                            
                            
                            
                            
                            if (isrecord && isObser==NO){
                                if (isKaraokeTab){
                                    
                                    
                                    //  if (startRecord){
                                    NSLog(@"thu_am");
                                    timeRecord=0;
                                    
                                    if (isKaraokeTab && [Language hasSuffix:@"kara"] && isrecord && CMTimeGetSeconds([self playerItemDuration])<1200 && songPlay.songUrl.length ==0){
                                        GetYoutubeMp3LinkRespone*res= [[LoadData2 alloc] GetYoutubeMp3Link:songRec.song];
                                        if (![songRec.performanceType isEqualToString:@"DUET"]) {
                                            songPlay.songUrl=res.url;
                                            
                                            songRec.song.songUrl=res.url;
                                        }
                                        
                                    }
                                    isObser=YES;
                                    
                                    //  }
                                    startRecord=YES;
                                    
                                }
                                
                            }
                        }
                    }
                        break;
                        
                    case AVPlayerStatusFailed:
                    {
                        if (isKaraokeTab){
                            AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];
                        }
                    }
                        break;
                }
            }
        }
#pragma mark MyStreamingMovieViewControllerPlayerItemStatusObserverContext2 audioplayer
        else if (context == MyStreamingMovieViewControllerPlayerItemStatusObserverContext2)
        {
            if (isKaraokeTab){
                [self syncPlayPauseButtonsAudio];
                NSLog(@"change status audio");
                AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
                switch (status)
                {
                        /* Indicates that the status of the player is not yet known because
                         it has not tried to load new media resources for playback */
                    case AVPlayerStatusUnknown:
                    {
                        if (isKaraokeTab){
                            [self removePlayerTimeObserver];
                            [self syncScrubber];
                            
                            [self disableScrubber];
                            [self disablePlayerButtons];
                        }
                    }
                        break;
                        
                    case AVPlayerStatusReadyToPlay:
                    {
                        /* Once the AVPlayerItem becomes ready to play, i.e.
                         [playerItem status] == AVPlayerItemStatusReadyToPlay,
                         its duration can be fetched from the item. */
                        if (isKaraokeTab){
                            if ([songRec.performanceType isEqualToString:@"DUET" ] || [songRec.performanceType isEqualToString:@"ASK4DUET"]) {
                                if (!_lyricView) {
                                    [self loadLyricDuet];
                                }
                            }
                            
                            if (playVideoRecorded && playRecord) {
                                playerLayerViewRec.hidden=NO;
                                // [[[[iToast makeText:AMLocalizedString(@"Nhấn vào Video của bạn để mở lớn Video",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                                // CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
                                // self.playerLayerViewRec.transform = transform;
                            }else{
                                playerLayerViewRec.hidden=YES;
                                
                            }
                            NSLog(@"audio ready play");
                            if (playRecord){
                            AVAudioMix *audioMix = self.audioTapProcessor.audioMix;
                            if (audioMix)
                            {
                                // Add audio mix with first audio track.
                                audioPlayer.currentItem.audioMix = audioMix;
                                
                            }
                            }
                            [self initScrubberTimer2];
                            [self enableScrubber];
                            [self enablePlayerButtons];
                            /*if (playRecord){
                             
                             }else*/
                            if (playVideoRecorded && playRecord ){
                                
                                // playerLayerViewRec.playerLayer.hidden = NO;
                                playerLayerViewRec.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                
                                
                                [playerLayerViewRec.playerLayer setPlayer:audioPlayer];
                           
                                self.playerLayerViewRec.hidden=NO;
                               
                                if (playRecord && playVideoRecorded && NO) {
                                    //self.xulyView.frame=CGRectMake(0,self.playerLayerViewRec.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.editViewButton.frame.size.height-self.playerLayerViewRec.frame.size.height);
                                    //self.toolBar.frame=CGRectMake(0,self.view.frame.size.height-self.editViewButton.frame.size.height-self.xulyView.frame.size.height- self.toolBar.frame.size.height, self.view.frame.size.width, self.toolBar.frame.size.height);
                                    
                                }
                               
                                //[playerLayerViewRec.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                            }
                        }
                    }
                        break;
                        
                    case AVPlayerStatusFailed:
                    {
                        if (isKaraokeTab){
                            AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];
                        }
                    }
                        break;
                }
            }
        }
#pragma mark MyStreamingMovieViewControllerPlayerItemStatusObserverContext3 duetplayer
        else if (context == MyStreamingMovieViewControllerPlayerItemStatusObserverContext3)
        {
            if (isKaraokeTab){
                NSLog(@"change status duet");
                AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
                switch (status)
                {
                        /* Indicates that the status of the player is not yet known because
                         it has not tried to load new media resources for playback */
                    case AVPlayerStatusUnknown:
                    {
                        
                    }
                        break;
                        
                    case AVPlayerStatusReadyToPlay:
                    {
                        /* Once the AVPlayerItem becomes ready to play, i.e.
                         [playerItem status] == AVPlayerItemStatusReadyToPlay,
                         its duration can be fetched from the item. */
                        if (isKaraokeTab){
                            
                            NSLog(@"duet ready play");
                            
                            //  [self initScrubberTimer2];
                            //if (playVideoRecorded && playRecord){
                            
                            // playerLayerViewRec.playerLayer.hidden = NO;
                            if (!playRecord) {
                                self.duetVideoLayer.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                            }else{
                                self.duetVideoLayer.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                            }
                           
                                if (![songPlay.songUrl hasSuffix:@".mp3"]  ) {
                                    [self.duetVideoLayer.playerLayer setPlayer:duetVideoPlayer];
                                    
                                    self.duetVideoLayer.playerLayer.hidden = NO;
                                    self.duetVideoLayer.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                    
                                    
                                    /* if (videoRecord && [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"]) {
                                     
                                     
                                     
                                     
                                     playerLayerView.frame=CGRectMake(0, 0, self.view.frame.size.width, playerLayerView.playerLayer.videoRect.size.height);
                                     //playerLayerView.frame=CGRectMake(0, self.duetVideoLayer.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
                                     NSLog(@"duet video layer %f", playerLayerView.frame.size.height);
                                     self.duetVideoLayer.frame=CGRectMake(0, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
                                     self.previewView.frame=CGRectMake(self.view.frame.size.width/2, self.playerLayerView.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height-self.playerLayerView.frame.size.height);
                                     }else if ( [songPlay.songUrl hasSuffix:@"mp4"] && [songRec.performanceType isEqualToString:@"DUET"] && playVideoRecorded) {
                                     
                                     playerLayerView.frame=CGRectMake(0,0, self.view.frame.size.width/2, playerLayerView.playerLayer.videoRect.size.height);
                                     self.duetVideoLayer.frame=CGRectMake(0, self.view.frame.size.width/2, self.view.frame.size.width/2, self.playerLayerView.frame.size.height);
                                     // playerLayerView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-self.duetVideoLayer.frame.size.height);
                                     NSLog(@"duet video layer %f",self.duetVideoLayer.frame.size.height);
                                     }*/
                                }
                            
                            //[playerLayerViewRec.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                            //  }
                        }
                    }
                        break;
                        
                    case AVPlayerStatusFailed:
                    {
                        if (isKaraokeTab){
                            AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];
                        }
                    }
                        break;
                }
            }
        }
#pragma mark MyStreamingMovieViewControllerPlayerItemStatusObserverContext4 yotubeplayer tmp
        else if (context == MyStreamingMovieViewControllerPlayerItemStatusObserverContext4)
        {
            if (isKaraokeTab){
                NSLog(@"change status yotubeplayer tmp");
                AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
                switch (status)
                {
                        /* Indicates that the status of the player is not yet known because
                         it has not tried to load new media resources for playback */
                    case AVPlayerStatusUnknown:
                    {
                        
                    }
                        break;
                        
                    case AVPlayerStatusReadyToPlay:
                    {
                        /* Once the AVPlayerItem becomes ready to play, i.e.
                         [playerItem status] == AVPlayerItemStatusReadyToPlay,
                         its duration can be fetched from the item. */
                        if (isKaraokeTab){
                            
                            NSLog(@"yotubeplayer tmp ready play");
                            
                            //  [self initScrubberTimer2];
                            //if (playVideoRecorded && playRecord){
                            
                            // playerLayerViewRec.playerLayer.hidden = NO;
                            playerYoutubeVideoTmp.muted=YES;
                            
                            if ( playVideoRecorded) {
                                
                            }else
                            if ( playRecord ){
                                playerLayerViewRec.hidden=YES;
                               
                                playerLayerView.hidden=NO;
                                if (VipMember  ) {
                                    self.duetVideoLayer.hidden=YES;
                                }
                                self.playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                                [self.playerLayerView.playerLayer setPlayer:playerYoutubeVideoTmp];
                                [self.playerLayerView.playerLayer setHidden:NO];
                            }
                        }
                    }
                        break;
                        
                    case AVPlayerStatusFailed:
                    {
                        if (isKaraokeTab){
                            AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                            [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];
                        }
                    }
                        break;
                }
            }
        }
    /* AVPlayer "rate" property value observer. */
    
    /* AVPlayer "rate" property value observer. */
        else if (context == MyStreamingMovieViewControllerRateObservationContext)
        {
            if (isKaraokeTab){
               [self syncPlayPauseButtons];
               
                NSLog(@"change rate player");
            }
        }else if (context == MyStreamingMovieViewControllerRateObservationContext2)
        {
            if (isKaraokeTab){
                NSLog(@"change rate audio");


                    [self syncPlayPauseButtonsAudio];

                
            }
        }
        else if (context == MyStreamingMovieViewControllerRateObservationContext3)
        {
            if (isKaraokeTab){
                NSLog(@"change rate duet");
                
                
            }
        }
    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
        else if (context == MyStreamingMovieViewControllerCurrentItemObservationContext)
        {
            if (isKaraokeTab){
                AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
                NSLog(@"change current player");
                /* New player item null? */
                if (newPlayerItem == (id)[NSNull null])
                {
                    if (isKaraokeTab){
                        [self disablePlayerButtons];
                        [self disableScrubber];
                        NSLog(@"change current player 2");
                        // self.isPlayingAdText.text = @"";
                    }
                }
                else /* Replacement of player currentItem has occurred */
                {
                    /* Set the AVPlayer for which the player layer displays visual output.*/
                    if (isKaraokeTab){
                        if ([Language hasSuffix:@"kara"] || (!playRecord && playVideoRecorded)){
                            
                            [playerLayerView.playerLayer setPlayer:playerMain];
                            
                            [playerLayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                            
                        }
                        [self syncPlayPauseButtons];
                    }
                }
                
            }
        }
        else if (context == MyStreamingMovieViewControllerCurrentItemObservationContext2)
        {
            if (isKaraokeTab){
                AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
                NSLog(@"change current player audio");
                /* New player item null? */
                if (newPlayerItem == (id)[NSNull null])
                {
                    if (isKaraokeTab){
                        [self disablePlayerButtons];
                        [self disableScrubber];
                        NSLog(@"change current player 2 audio");
                        // self.isPlayingAdText.text = @"";
                    }
                }
                else /* Replacement of player currentItem has occurred */
                {
                    /* Set the AVPlayer for which the player layer displays visual output.*/
                    if (isKaraokeTab){
                        if ([Language hasSuffix:@"kara"]){
                            
                            [playerLayerViewRec.playerLayer setPlayer:audioPlayer];
                            
                            
                        }
                        [self syncPlayPauseButtons];
                    }
                }
                
            }
        }
    /* Observe the AVPlayer "currentItem.timedMetadata" property to parse the media stream
     timed metadata. */
        else if (context == MyStreamingMovieViewControllerTimedMetadataObserverContext)
        {
            
        }
        else
        {
            [super observeValueForKeyPath:path ofObject:object change:change context:context];
        }
    
    return;
}



@end


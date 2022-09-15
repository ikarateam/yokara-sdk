//
//  ViewController.m
//  Audio Controller Test Suite
//
//  Created by Michael Tyson on 13/02/2012.
//  Copyright (c) 2012 A Tasty Pixel. All rights reserved.
//


#import "audioEngine.h"

#import <TheAmazingAudioEngine/AEReverbFilter.h>
#import <QuartzCore/QuartzCore.h>
#import "Recording.h"
#import "Song.h"
//#import "LoadData.h"
//#import "StreamingMovieViewController.h"
//#import  "SettingViewController.h"
#import "Constant.h"
#import "convertAudio.h"
#include "RingBuffer.h"
#import <TheAmazingAudioEngine/AEAudioFilePlayer.h>
#import <TheAmazingAudioEngine/AEExpanderFilter.h>
#import <TheAmazingAudioEngine/AEPlaythroughChannel.h>
#import <TheAmazingAudioEngine/AELimiterFilter.h>
extern RingBuffer *ringBufferAudioLive;
#define checkResult(result,operation) (_checkResult((result),(operation),strrchr(__FILE__, '/')+1,__LINE__))
static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        int fourCC = CFSwapInt32HostToBig(result);
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&fourCC);
        return NO;
    }
    return YES;
}

static int kInputChannelsChangedContext;


#define kAuxiliaryViewTag 251


@interface audioEngine () {
    AudioFileID _audioUnitFile;
    AEChannelGroupRef _group;
	 unsigned char tmp[1024];

}

@property (nonatomic, retain) AEAudioFilePlayer *loop1;
@property (nonatomic, retain) AEAudioFilePlayer *loop2;
@property (nonatomic, retain) AEBlockChannel *oscillator;
@property (nonatomic, retain) AEAudioUnitChannel *audioUnitPlayer;
@property (nonatomic, retain) AEAudioFilePlayer *oneshot;
@property (nonatomic, retain) AEPlaythroughChannel *playthrough;
@property (nonatomic, retain) AELimiterFilter *limiter;
@property (nonatomic, retain) AEExpanderFilter *expander;
@property (nonatomic, retain) AEReverbFilter *reverb;
@property (nonatomic, retain) CALayer *inputLevelLayer;
@property (nonatomic, retain) CALayer *outputLevelLayer;
@property (nonatomic, assign) NSTimer *levelsTimer;
@property (nonatomic, retain)  id<AEAudioReceiver> receiver;



@end

BOOL isExpand;
BOOL xulyTrucTiep;
static BOOL thuInput;
@implementation audioEngine
- (id)initWithAudioController:(AEAudioController*)audioControlle {
    if ( !(self = [super init]) ) return nil;
    
    self.audioController = audioControlle;
    
     // Create the first loop player
    /*
     self.loop1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Drums" withExtension:@"m4a"]
     audioController:_audioController
     error:NULL];
     _loop1.volume = 1.0;
     _loop1.channelIsMuted = YES;
     _loop1.loop = YES;
     
     // Create the second loop player
     self.loop2 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Organ" withExtension:@"m4a"]
     audioController:_audioController
     error:NULL];
     _loop2.volume = 1.0;
     _loop2.channelIsMuted = YES;
     _loop2.loop = YES;
     
    // Create a block-based channel, with an implementation of an oscillator
    __block float oscillatorPosition = 0;
    __block float oscillatorRate = 622.0/44100.0;
    _oscillator = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                    UInt32           frames,
                                                    AudioBufferList *audio) {
        for ( int i=0; i<frames; i++ ) {
            // Quick sin-esque oscillator
            float x = oscillatorPosition;
            x *= x; x -= 1.0; x *= x;       // x now in the range 0...1
            x *= INT16_MAX;
            x -= INT16_MAX / 2;
            oscillatorPosition += oscillatorRate;
            if ( oscillatorPosition > 1.0 ) oscillatorPosition -= 2.0;
            
            ((SInt16*)audio->mBuffers[0].mData)[i] = x;
            ((SInt16*)audio->mBuffers[1].mData)[i] = x;
        }
    }];
    _oscillator.audioDescription = [AEAudioController nonInterleaved16BitStereoAudioDescription];
    
    _oscillator.channelIsMuted = YES;
    */
    // Create an audio unit channel (a file player)
   // self.audioUnitPlayer = [[AEAudioUnitChannel alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer)];
    
   // _group = [_audioController createChannelGroup];
   // [_audioController addChannels:@[_loop1, _loop2] toChannelGroup:_group];
    
    // Finally, add the audio unit player
   // [_audioController addChannels:@[_audioUnitPlayer]];
    //NSLog(@"addObser numberOfInputChannels");
   // [_audioController addObserver:self forKeyPath:@"numberOfInputChannels" options:0 context:(void*)&kInputChannelsChangedContext];
    // Create a block-based channel, with an implementation of an oscillator
	ringBufferAudioLive=new RingBuffer(4096 * 2 * 5);

    return self;
}
- (void) stopP{
    self.sendLive = NO;
    if ([self.audioController running])
    [self.audioController stop];
    if (ringBufferAudioLive)
	 ringBufferAudioLive->empty();
}
-(void) startP{
    if (![self.audioController running])
    [self.audioController start:nil];
}
- (void) destroy{
    if (ringBufferAudioLive)
	 ringBufferAudioLive->empty();
	 ringBufferAudioLive = nil;
}
BOOL isVoice;
-(void)dealloc {
   // [_audioController removeObserver:self forKeyPath:@"numberOfInputChannels"];
    //NSLog(@"removeObser numberOfInputChannels");
    isVoice=NO;
    self.sendLive = NO;
    if (ringBufferAudioLive)
	 ringBufferAudioLive->empty();
    if ( _audioUnitFile ) {
        AudioFileClose(_audioUnitFile);
    }
	 [self removeOutPutReceive];
    if ( _levelsTimer ) [_levelsTimer invalidate];
    
    NSMutableArray *channelsToRemove = [NSMutableArray arrayWithObjects:_oscillator, nil];
    
    self.loop1 = nil;
    self.loop2 = nil;
    
    if ( _player ) {
        [channelsToRemove addObject:_player];
        self.player = nil;
    }
    
    if ( _oneshot ) {
        [channelsToRemove addObject:_oneshot];
        self.oneshot = nil;
    }
    
    if ( _playthrough ) {
        [channelsToRemove addObject:_playthrough];
        [_audioController removeInputReceiver:_playthrough];
        self.playthrough = nil;
    }
    
    [_audioController removeChannels:channelsToRemove];
    
    if ( _limiter ) {
        [_audioController removeFilter:_limiter];
        self.limiter = nil;
    }
    
    if ( _expander ) {
        [_audioController removeFilter:_expander];
        self.expander = nil;
    }
    
    if ( _reverb ) {
        [_audioController removeFilter:_reverb];
        self.reverb = nil;
    }
   
    self.audioController =nil;
    self.recorder = nil;
    self.inputLevelLayer = nil;
    self.outputLevelLayer = nil;
    //self.audioController = nil;
    _group=nil;
    
    _audioUnitPlayer=nil;
   // self=nil;
}


/*
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.levelsTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLevels:) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_levelsTimer invalidate];
    self.levelsTimer = nil;
}
*/



- (void)loop1SwitchChanged:(UISwitch*)sender {
    _loop1.channelIsMuted = !sender.isOn;
}

- (void)loop1VolumeChanged:(UISlider*)sender {
    _loop1.volume = sender.value;
}

- (void)loop2SwitchChanged:(UISwitch*)sender {
    _loop2.channelIsMuted = !sender.isOn;
}

- (void)loop2VolumeChanged:(UISlider*)sender {
    _loop2.volume = sender.value;
}

- (void)oscillatorSwitchChanged:(UISwitch*)sender {
    _oscillator.channelIsMuted = !sender.isOn;
}

- (void)oscillatorVolumeChanged:(UISlider*)sender {
    _oscillator.volume = sender.value;
}

- (void)channelGroupSwitchChanged:(UISwitch*)sender {
    [_audioController setMuted:!sender.isOn forChannelGroup:_group];
}

- (void)channelGroupVolumeChanged:(UISlider*)sender {
    [_audioController setVolume:sender.value forChannelGroup:_group];
}



- (void)oneshotAudioUnitPlayButtonPressed:(UIButton*)sender {
    if ( !_audioUnitFile ) {
        NSURL *playerFile = [[NSBundle mainBundle] URLForResource:@"Organ Run" withExtension:@"m4a"];
       // checkResult(AudioFileOpenURL((CFURLRef)CFBridgingRetain(playerFile, kAudioFileReadPermission, 0, &_audioUnitFile), "AudioFileOpenURL");
    }
    
    // Set the file to play
    checkResult(AudioUnitSetProperty(_audioUnitPlayer.audioUnit, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, &_audioUnitFile, sizeof(_audioUnitFile)),
                "AudioUnitSetProperty(kAudioUnitProperty_ScheduledFileIDs)");
    
    // Determine file properties
    UInt64 packetCount;
	UInt32 size = sizeof(packetCount);
	checkResult(AudioFileGetProperty(_audioUnitFile, kAudioFilePropertyAudioDataPacketCount, &size, &packetCount),
                "AudioFileGetProperty(kAudioFilePropertyAudioDataPacketCount)");
	
	AudioStreamBasicDescription dataFormat;
	size = sizeof(dataFormat);
	checkResult(AudioFileGetProperty(_audioUnitFile, kAudioFilePropertyDataFormat, &size, &dataFormat),
                "AudioFileGetProperty(kAudioFilePropertyDataFormat)");
    
	// Assign the region to play
	ScheduledAudioFileRegion region;
	memset (&region.mTimeStamp, 0, sizeof(region.mTimeStamp));
	region.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
	region.mTimeStamp.mSampleTime = 0;
	region.mCompletionProc = NULL;
	region.mCompletionProcUserData = NULL;
	region.mAudioFile = _audioUnitFile;
	region.mLoopCount = 0;
	region.mStartFrame = 0;
	region.mFramesToPlay = packetCount * dataFormat.mFramesPerPacket;
	checkResult(AudioUnitSetProperty(_audioUnitPlayer.audioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &region, sizeof(region)),
                "AudioUnitSetProperty(kAudioUnitProperty_ScheduledFileRegion)");
	
	// Prime the player by reading some frames from disk
	UInt32 defaultNumberOfFrames = 0;
	checkResult(AudioUnitSetProperty(_audioUnitPlayer.audioUnit, kAudioUnitProperty_ScheduledFilePrime, kAudioUnitScope_Global, 0, &defaultNumberOfFrames, sizeof(defaultNumberOfFrames)),
                "AudioUnitSetProperty(kAudioUnitProperty_ScheduledFilePrime)");
    
    // Set the start time (now = -1)
    AudioTimeStamp startTime;
	memset (&startTime, 0, sizeof(startTime));
	startTime.mFlags = kAudioTimeStampSampleTimeValid;
	startTime.mSampleTime = -1;
	checkResult(AudioUnitSetProperty(_audioUnitPlayer.audioUnit, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, sizeof(startTime)),
                "AudioUnitSetProperty(kAudioUnitProperty_ScheduleStartTimeStamp)");
    
}
- (void)limiterSwitchChanged:(BOOL)sender {
    /*
    if ( sender ) {
        self.limiter = [[[AELimiterFilter alloc] initWithAudioController:_audioController] autorelease];
        _limiter.level = 0.1;
        [_audioController addFilter:_limiter];
    } else {
        [_audioController removeFilter:_limiter];
        self.limiter = nil;
    }*/
}

- (void)expanderSwitchChanged:(BOOL)sender {
    /*
    isExpand=sender;
    if ( sender ) {
        if (self.expander) {
            [_audioController removeFilter:_expander];
            self.expander = nil;
        }
        self.expander = [[AEExpanderFilter alloc] init];
                        
        [_audioController addFilter:_expander];
    } else {
        [_audioController removeFilter:_expander];
        self.expander = nil;
    }*/
}
- (void) setPlaythroughVolume:(float)volume{
    if (self.playthrough) {
        self.playthrough.volume=volume;
    }
}
- (float) getPlaythroughVolume{
    if (self.playthrough) {
       return   self.playthrough.volume;
    }
    else return 0;
}
- (void)playthroughSwitchChanged:(BOOL)ida {
    ringBufferAudioLive->empty();
    if ([self.audioController isKindOfClass:[AEAudioController class]]) {
        NSLog(@"change playthrough");
        isVoice=ida;
        if ( ida ) {
            if (self.playthrough) {
                [self.audioController removeChannels:@[self.playthrough]];
                [self.audioController removeInputReceiver:self.playthrough];
                self.playthrough = nil;
            }
            
            self.playthrough = [[AEPlaythroughChannel alloc] init];
            
            if (self.playthrough) {
                [self.audioController addInputReceiver:self.playthrough];
                [self.audioController addChannels:@[self.playthrough]];
            }
            self.sendLive = YES;
        } else {
            if (self.playthrough) {
                self.sendLive = NO;
                [self.audioController removeChannels:@[self.playthrough]];
                [self.audioController removeInputReceiver:self.playthrough];
                self.playthrough = nil;
            }


        }
    }
     
}

- (void) removeOutPutReceive{
	 if (self.receiver){
         if (self.sendMicMC) {
             [_audioController removeInputReceiver:self.receiver];
             self.sendMicMC = NO;
         }
         else
		   [_audioController removeOutputReceiver:self.receiver];
		  self.receiver = nil;
		  ringBufferAudioLive->empty();
	 }
}
- (void) addOutPutReceive {
	 if (!self.receiver) {
		  ringBufferAudioLive->empty();
		  self.receiver = [AEBlockAudioReceiver audioReceiverWithBlock:
					 ^(void *source,
					 const AudioTimeStamp *time,
					 UInt32 frames,
					 AudioBufferList *audio) {
					 // Do something with 'audio'
              if (audio!=NULL && frames>0 && self.sendLive) {
										  float * output=(float *)audio->mBuffers[0].mData;
								float * output2=(float *)audio->mBuffers[1].mData;
							 
							   for (int j = 0; j<frames; j++) {
									ringBufferAudioLive->push((float)output[j]);
									ringBufferAudioLive->push((float)output2[j]);
							   }
              }else if (self.sendLive && frames>0){
                  for (int j = 0; j<frames; j++) {
                      ringBufferAudioLive->push(0);
                      ringBufferAudioLive->push(0);
                  }
                  NSLog(@"addOutputReceiver 0 frame %d",frames);
              }

					}];
         if (self.sendMicMC)
             [_audioController addInputReceiver:self.receiver];
         else
					 [_audioController addOutputReceiver:self.receiver];

	 }
}
- (void) setEchoVolume:(float)volume{
    if (self.reverb) {
        self.reverb.dryWetMix=volume;
    }
}
- (float) getEchoVolume{
    if (self.reverb) {
        return   self.reverb.dryWetMix;
    }
    else return 0;
}
int playthroughVolume;
- (void)reverbSwitchChanged:(BOOL)sender {
    
    if ( sender ) {
        
        if (self.reverb) {
            [self.audioController removeFilter:self.reverb];
            self.reverb = nil;
        }
       
        self.reverb = [[AEReverbFilter alloc]init];
            self.reverb.gain=0;
            self.reverb.dryWetMix=50;
            self.reverb.minDelayTime=0.07;
            self.reverb.maxDelayTime=0.14;
            self.reverb.decayTimeAt0Hz=4;
            self.reverb.decayTimeAtNyquist=3;
            
            if (self.audioController) {
                [self.audioController addFilter:self.reverb];
            }
          
        
    } else {
        if (self.reverb) {
            [self.audioController removeFilter:self.reverb];
            self.reverb = nil;
        }
       
    }
}
double delayRec;
- (void)channelButtonPressed:(UIButton*)sender {
    BOOL selected = [_audioController.inputChannelSelection containsObject:[NSNumber numberWithInt:sender.tag]];
    selected = !selected;
    if ( selected ) {
        _audioController.inputChannelSelection = [[_audioController.inputChannelSelection arrayByAddingObject:[NSNumber numberWithInt:sender.tag]] sortedArrayUsingSelector:@selector(compare:)];
        [self performSelector:@selector(highlightButtonDelayed:) withObject:sender afterDelay:0.01];
    } else {
        NSMutableArray *channels = [_audioController.inputChannelSelection mutableCopy];
        [channels removeObject:[NSNumber numberWithInt:sender.tag]];
        _audioController.inputChannelSelection = channels;
     
        sender.highlighted = NO;
    }
}

- (void)highlightButtonDelayed:(UIButton*)button {
    button.highlighted = YES;
}
- (void) convert:(Recording *)song{
    @autoreleasepool {
        [[convertAudio alloc] convertAudio:song];
    }
}

- (void)record {
    if ( self.recorder ) {
        [self.recorder finishRecording];
        if (thuInput){
            [self.audioController removeOutputReceiver:self.recorder];
        }else{
            [self.audioController removeInputReceiver:self.recorder];
        }
        self.recorder = nil;
        
        ///
       
        
        
        
        
        ////
    } else {
        self.recorder=nil;
        self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dataPath =[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
            ////[[LoadData alloc] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
        }
       
           
             NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",songRec.recordingTime]];
        songRec.vocalUrl=path;
            ////[[LoadData alloc] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
        NSError *error = nil;//sua o day kAudioFileAIFFType
        if ( ![self.recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] ;
            [al performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            isrecord=NO;
            self.recorder = nil;
            return;
        }
        
        //songRecOld = songRec;
       
        if (xulyTrucTiep){
        [self.audioController addOutputReceiver:self.recorder];
            thuInput=YES;
        }else{
            [self.audioController addInputReceiver:self.recorder];
            thuInput=NO;
        }
    }
}
- (void)pause{
	 if ( self.player ) {
		  
		  [self.audioController removeChannels:[NSArray arrayWithObject:self.player]];
		  self.player = nil;

	 }
}
- (void)play:(NSString *)path {
	 if ( self.player ) {
		  [self.audioController removeChannels:[NSArray arrayWithObject:self.player]];
        self.player = nil;
        
    }

        
		 if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
        
        NSError *error = nil;
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath: path]  error:&error];
        
        if ( !self.player ) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                        delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:@"OK", nil] show];
            return;
        }
        
        self.player.removeUponFinish = YES;
        
        if (self.player)
        [self.audioController addChannels:[NSArray arrayWithObject:self.player]];
        
        

}

static inline float translate(float val, float min, float max) {
    if ( val < min ) val = min;
    if ( val > max ) val = max;
    return (val - min) / (max - min);
}

- (void)updateLevels:(NSTimer*)timer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    Float32 inputAvg, inputPeak, outputAvg, outputPeak;
    [_audioController inputAveragePowerLevel:&inputAvg peakHoldLevel:&inputPeak];
    [_audioController outputAveragePowerLevel:&outputAvg peakHoldLevel:&outputPeak];
       [CATransaction commit];
}




@end

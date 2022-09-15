//
//  audioEngine.h
//  Yokara
//
//  Created by Rain Nguyen on 9/18/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import <TheAmazingAudioEngine/AERecorder.h>
#import <TheAmazingAudioEngine/TheAmazingAudioEngine.h>
#import "Recording.h"
@class AEAudioController;
@interface audioEngine : NSObject
{
  //  UIAlertView *alert;
  
}
@property (nonatomic, assign) BOOL sendLive;
@property (nonatomic, assign) BOOL sendMicMC;
@property (nonatomic, retain) AEAudioFilePlayer *player;
@property (nonatomic, retain) AERecorder *recorder;
@property (nonatomic, retain) AEAudioController *audioController;
- (void)play:(NSString *)fileUrl;
- (void)pause;
- (id)initWithAudioController:(AEAudioController * )audioController;
- (void)playthroughSwitchChanged:(BOOL)ida ;
- (void)reverbSwitchChanged:(BOOL)sender;
- (void) addOutPutReceive;
- (void) removeOutPutReceive;
- (void)record ;
-(void) startP;
- (void) stopP;
- (void) destroy;
- (void)limiterSwitchChanged:(BOOL)sender;
- (void)expanderSwitchChanged:(BOOL)sender;
- (void) setPlaythroughVolume:(float)volume;
- (float) getPlaythroughVolume;
- (void) setEchoVolume:(float)volume;
- (float) getEchoVolume;

@end


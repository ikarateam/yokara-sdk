//
//  LiveViewController.m
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "LiveViewController.h"
#import "CommentLiveTableViewCell.h"
#import "UserOnlineCollectionViewCell.h"
#import "UserOnlineRoomTableViewCell.h"
#import "GiftCollectionViewCell2.h"
#import "MenuUserOnlineInfoViewController.h"
#import "OpenLiveRoomModel.h"
#define kOutputBus 0
#define kInputBus 1
#define checkStatus(status) \
if ( (status) != noErr ) {\
	NSLog(@"Error: %ld -> %s:%d", (status), __FILE__, __LINE__);\
}
#import "AACDecoder.h"
#import "MYAudioTapProcessor.h"
#import "AACEncoder.h"
#include "RingBuffer.h"
//#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import "UserCell2.h"
#import <SDWebImage/SDWebImage.h>
#import <SVGAPlayer/SVGA.h>
#import "LuckyGiftCollectionViewCell.h"
#import "LuckyGiftHistoryTableViewCell.h"
@interface LiveViewController ()<GCDAsyncSocketDelegate,SVGAPlayerDelegate>{

	 AudioFileID destinationFileaac ;
    AudioFileID destinationFile ;
    AudioConverterRef _audioConverter;
    AudioFileID outputFileID;
	
}
//@property ( strong, nonatomic) MYAudioTapProcessor *audioTapProcessor;
@property (readonly, nonatomic, strong) NSURL *destinationURL;
@property (nonatomic, strong) SDAnimatedImageView *animatedWebPImageView;
@property (nonatomic, strong) SVGAPlayer *playerSvga;
@end

@implementation LiveViewController
@synthesize movieTimeControl,playButt,pauseBtt,socket,playerSvga;
Song *userSinging;
Song *userShowTime;
NSString *liveRoomID;
GetAllGiftsResponse * allGiftRespone;
GetAllLuckyGiftsResponse * allLuckyGiftRespone;
NSMutableArray * listQueueSing;
NSMutableArray * listQueueSingPK;
NSMutableArray * listQueueSingPKTemp;

typedef struct   {
    UInt32 mChannels;
    UInt32 mDataSize;
    const void* mData;
    AudioStreamPacketDescription mPacket;
}PassthroughUserData3;


OSStatus inInputDataProc3(AudioConverterRef aAudioConverter,
                          UInt32* aNumDataPackets,
                          AudioBufferList* aData ,
                          AudioStreamPacketDescription** aPacketDesc,
                          void* aUserData)
{

    PassthroughUserData3* userData = (PassthroughUserData3*)aUserData;

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

    // No more data to provide following this run.
    userData->mDataSize = 0;

    return noErr;
}
static OSStatus playbackCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags *ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData) {
    // Notes: ioData contains buffers (may be more than one!)
    // Fill them up as much as you can. Remember to set the size value in each buffer to match how
    // much data is in the buffer.
    return noErr;
}
- (void) setupAudioStream {
	 OSStatus status;
	 AudioComponentInstance audioUnit;

	 // Describe audio component
	 AudioComponentDescription desc;
	 desc.componentType = kAudioUnitType_Output;
	 desc.componentSubType = kAudioUnitSubType_RemoteIO;
	 desc.componentFlags = 0;
	 desc.componentFlagsMask = 0;
	 desc.componentManufacturer = kAudioUnitManufacturer_Apple;

	 // Get component
	 AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);

	 // Get audio units
	 status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	 checkStatus(status);

	 // Enable IO for recording
	 UInt32 flag = 1;
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioOutputUnitProperty_EnableIO,
								   kAudioUnitScope_Input,
								   kInputBus,
								   &flag,
								   sizeof(flag));
	 checkStatus(status);

	 // Enable IO for playback
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioOutputUnitProperty_EnableIO,
								   kAudioUnitScope_Output,
								   kOutputBus,
								   &flag,
								   sizeof(flag));
	 checkStatus(status);
	 AudioStreamBasicDescription audioFormat;
	 // Describe format
	 audioFormat.mSampleRate			= 44100.00;
	 audioFormat.mFormatID			= kAudioFormatLinearPCM;
	 audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	 audioFormat.mFramesPerPacket	= 1;
	 audioFormat.mChannelsPerFrame	= 1;
	 audioFormat.mBitsPerChannel		= 16;
	 audioFormat.mBytesPerPacket		= 2;
	 audioFormat.mBytesPerFrame		= 2;

	 // Apply format
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioUnitProperty_StreamFormat,
								   kAudioUnitScope_Output,
								   kInputBus,
								   &audioFormat,
								   sizeof(audioFormat));
	 checkStatus(status);
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioUnitProperty_StreamFormat,
								   kAudioUnitScope_Input,
								   kOutputBus,
								   &audioFormat,
								   sizeof(audioFormat));
	 checkStatus(status);


	 // Set input callback
	 AURenderCallbackStruct callbackStruct;
	// callbackStruct.inputProc = recordingCallback;
	 callbackStruct.inputProcRefCon = (void*) CFBridgingRetain(self);
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioOutputUnitProperty_SetInputCallback,
								   kAudioUnitScope_Global,
								   kInputBus,
								   &callbackStruct,
								   sizeof(callbackStruct));
	 checkStatus(status);

	 // Set output callback
	 callbackStruct.inputProc = playbackCallback;
	 callbackStruct.inputProcRefCon = (void*) CFBridgingRetain(self);
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioUnitProperty_SetRenderCallback,
								   kAudioUnitScope_Global,
								   kOutputBus,
								   &callbackStruct,
								   sizeof(callbackStruct));
	 checkStatus(status);

	 // Disable buffer allocation for the recorder (optional - do this if we want to pass in our own)
	 flag = 0;
	 status = AudioUnitSetProperty(audioUnit,
								   kAudioUnitProperty_ShouldAllocateBuffer,
								   kAudioUnitScope_Output,
								   kInputBus,
								   &flag,
								   sizeof(flag));

	 // TODO: Allocate our own buffers if we want

	 // Initialise
	 status = AudioUnitInitialize(audioUnit);
	 checkStatus(status);
}
#pragma mark Player
/*- (MYAudioTapProcessor *)audioTapProcessor
{
    if (!_audioTapProcessor )
    {
        AVAssetTrack *firstAudioAssetTrack;
        for (AVAssetTrack *assetTrack in playerVideo.currentItem.asset.tracks)
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
            NSString*     filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"Output.caf"]];

            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (haveS ) {

                _audioTapProcessor = [[MYAudioTapProcessor alloc] initWithAudioAssetTrack:firstAudioAssetTrack andPlayer:playerVideo andAudioPath:filePath];

                    [_audioTapProcessor updateVolumeVideo:0 ];
                    [_audioTapProcessor updateVolumeAudio:100 ];

                    [_audioTapProcessor setDelay:0 ];



            }

        }
    }
    return _audioTapProcessor;
}*/
- (void) updateLiveRoomProperty :(NSNotification *)noti{
    NSString * liveS = (NSString *) noti.object;
    LiveRoom * liver = [[LiveRoom alloc] initWithString:liveS error:nil];
    if ([liver isKindOfClass:[LiveRoom class]]) {
        self.liveroom = liver;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusAndCommentTableView reloadData];
        });
        
    }
    
}
- (void) deleteLiveRoom :(NSNotification *)noti{
    alertOutRoom = NO;
    if (ringBufferAudioLive)
        ringBufferAudioLive->empty();
    //  self.liveroom.noOnlineMembers --;
    [self.roomShowTimeView removeFromSuperview];
    
    [self sendSTOPSENDStream];
    [self removeHandle];
    [self.playerLayerView removeFromSuperview];
    [self.playerLayerView.playerLayer setPlayer:nil];
    self.playerLayerView=nil;
    [self.liveAnimation stop];
    self.liveAnimation = nil;
    demConnect = 1;
    [socket disconnect];
    socket.delegate=nil;
    socket = nil;
    [playerVideo pause];
    isReceiveLive = NO;
    isStartingLive = NO;
    [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
    // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
    [audioEngine3 stopP];
    audioEngine3.sendLive = NO;
    //[audioEngine3 destroy];
    audioEngine3 = nil;
    if (doNothingStreamTimer) {
        [doNothingStreamTimer invalidate];
        doNothingStreamTimer=nil;
    }
    if (changeBGtimer) {
        [changeBGtimer invalidate];
        changeBGtimer=nil;
    }
    if (timerPlayer) {
        [timerPlayer invalidate];
        timerPlayer= nil;
    }
    userShowTime = nil;
    [playerNode stop];
    // playerNode = nil;
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"outLiveRoom"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"loadStreamLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"homePressLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"homeComebackLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"startAudiEngine"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"stopLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
    
    isInLiveView = NO;
    self.functions = nil;
    [self deallocLive];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)showMenuUser:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        MenuUserOnlineInfoViewController * mainVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MenuUserOnlineInfo"];
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        mainVC.currUser=(User *)noti.object;
        [self.view addSubview:mainVC.view];
        mainVC.view.frame = self.view.frame;
        [self addChildViewController:mainVC];
        //[mainVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        
        //[self presentViewController:mainVC animated:NO completion:nil];
        
    });
}
- (void)showMenuUserFamily:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        MenuUserOnlineInfoViewController * mainVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MenuUserOnlineInfo"];
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        mainVC.isFamilyRoom = YES;
        mainVC.currUser=(User *)noti.object;
        [self.view addSubview:mainVC.view];
        mainVC.view.frame = self.view.frame;
        [self addChildViewController:mainVC];
       // [mainVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        //UIViewController *  view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        //[view presentViewController:mainVC animated:NO completion:nil];
        
    });
}
- (IBAction)playPausePress:(id)sender {
	 if (isStartingLive) {
		  alertStopLiveShow = YES;
         self.liveAlertHeightConstrainst.constant = 200;
		  [self.liveAlertYesButton setTitle:AMLocalizedString(@"Dừng", nil) forState:UIControlStateNormal];
		  self.liveAlertTitleLabel.text = AMLocalizedString(@"Thông báo", nil);
		  self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn đang trực tiếp! Bạn có muốn dừng trực tiếp?", nil);
		  self.liveAlertView.hidden = NO;
		  //
	 }
}
#pragma mark - Stream Socket

- (void) setupAssynSocket{
	  socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
	 if (serverLive.length>3 && portLive>0 ) {
		  if (![socket connectToHost:serverLive onPort:portLive error:&err]) // Asynchronous!
			  {
					// If there was an error, it's likely something like "already connected" or "no delegate set"
			   NSLog(@"I goofed: %@", err);
			  }
	 }else
    if (![socket connectToHost:@"data3.ikara.co" onPort:9191 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
    }
    //[socket acceptOnPort:9090 error:nil];
}
- (void) reconnectAssynSocket{
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![socket connectToHost:serverLive onPort:portLive error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
    }
	  NSLog(@"reconnectAssynSocket");
    //[socket acceptOnPort:9090 error:nil];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    streamSVIsConnect=NO;
	 if (ringBufferAudioLive)
		  ringBufferAudioLive->empty();
	 alertEndLiveShow=NO;
	 if (demConnect == 1)
		  return;


	 if (demConnect==0) {
         demConnect = 2;
		  if (!streamSVIsConnect) {

			   [self reconnectAssynSocket];


          }else {
		  
		  if (isReceiveLive) {
			   [self sendRECEIVEStream];
			   [self sendSTOPSENDStream];
		  }else if (isStartingLive){
			   [self sendSENDStream];
			   [self sendSTOPRECEIVEStream];
		  }
          }
	 }else {

	 if (isReceiveLive || isStartingLive){
	 isReceiveLive = NO;
	 isStartingLive = NO;
     dispatch_async(dispatch_get_main_queue(), ^{

			   [[[[iToast makeText:AMLocalizedString(@"Kết nối với server bị gián đoạn! Vui lòng vào lại phòng hoặc liên hệ chúng tôi để được hỗ trợ!", nil)]
				  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];


		  [self sendSTOPSENDStream];
		  [self removeHandle];
			   // self.liveroom.noOnlineMembers --;
		 // [socket disconnect];
		  socket.delegate=nil;
		  [playerVideo pause];

		  [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
			   // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
		  [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
		  [audioEngine3 stopP];
			   //  [audioEngine3 destroy];
		  audioEngine3 = nil;
			    [self.roomShowTimeView removeFromSuperview];

		  [self.playerLayerView removeFromSuperview];
		  [self.playerLayerView.playerLayer setPlayer:nil];
		  self.playerLayerView=nil;
		  if (doNothingStreamTimer) {
			   [doNothingStreamTimer invalidate];
			   doNothingStreamTimer=nil;
		  }
		  if (changeBGtimer) {
			   [changeBGtimer invalidate];
			   changeBGtimer=nil;
		  }
		  if (timerPlayer) {
			   [timerPlayer invalidate];
			   timerPlayer= nil;
		  }
		  AVAudioSession *session = [ AVAudioSession sharedInstance ];
		  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"outLiveRoom"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"loadStreamLive"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"homePressLive"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"homeComebackLive"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"startAudiEngine"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:@"stopLive"
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:UIKeyboardWillShowNotification
														object:nil];

		  [[NSNotificationCenter defaultCenter] removeObserver:self
														  name:UIKeyboardWillHideNotification
														object:nil];
		  [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
		  socket = nil;
		   isInLiveView = NO;
         [self deallocLive];
		  [self dismissViewControllerAnimated:YES completion:nil];

     });
	 if (userShowTime) {
		
		  dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		  dispatch_async(queue, ^{
		  Song *newSong = [Song new];
		  newSong.songName = userShowTime.songName;
		  newSong.firebaseId = userShowTime.firebaseId;
		  newSong._id = userShowTime._id;
		  newSong.videoId = userShowTime.videoId;


		  newSong.owner = userShowTime.owner;
		  newSong.status = 5;

		  DoneSongRequest *firRequest = [DoneSongRequest new];
		  firRequest.roomId = liveRoomID;
		  firRequest.song = newSong;
		  if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
			   NSLog(@"sock ket firebaseId nil");
		  }
              if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                  self.functions = [FIRFunctions functions];
                  __block BOOL isLoadFir = NO;
                  __block FirebaseFuntionResponse *getResponse=nil;
                  [[_functions HTTPSCallableWithName:Fir_StopSongPK] callWithObject:@{@"parameters":requestString}
                                                                         completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                      
                      NSString *stringReply = (NSString *)result.data;
                      
                          //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                          // Some debug code, etc.
                      NSLog(@"stop song PK %@",stringReply);
                      isLoadFir = YES;
                      
                  }];
              }else{
		  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
		  self.functions = [FIRFunctions functions];
		  __block BOOL isLoadFir = NO;
		  __block FirebaseFuntionResponse *getResponse=nil;
		  [[_functions HTTPSCallableWithName:Fir_StopSong] callWithObject:@{@"parameters":requestString}
															   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {

			   NSString *stringReply = (NSString *)result.data;

			 //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
					// Some debug code, etc.
			   NSLog(@"stop song socket dis %@",stringReply);
			   isLoadFir = YES;

		  }];
              }
		  userShowTime = nil;
		  });
	 }
	 }
	 }
}
- (IBAction)cmtViewBackground:(id)sender {
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

    }else if (tag == 3){
       // NSLog(@"Send audio data");

    }
}
BOOL isRECEIVE;
BOOL isSEND;
- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)dataT withTag:(long)tag
{


    NSMutableData *result;
    NSMutableData *data=[NSMutableData dataWithData:dataT];

    NSString *received;

    short size=0;
    NSInteger leng=[data length];
    char* bytes;
    bytes=(char *)[data bytes];
    u.bytes[0]=bytes[1];
    u.bytes[1]=bytes[0];
    size=u.s;
    leng=[data length];
    //if (size<=0 || leng<size+2) {
      
        
    //}
    while(leng>=size+2 && size>0)  {
        
        //  NSLog(@"socket read data %ld and size %d",leng,size);
        
        short status=(short)bytes[2];

            if (status==0 ) {//bo 3 byte dau
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
                UpdateBitrateRequest * updateBitrate =[[UpdateBitrateRequest alloc] initWithString:received error:nil];
                if (updateBitrate.bitrate>0 && updateBitrate.bitrate<=128000) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                   // encoder = [[AACEncoder alloc] init];
                   // [encoder initAAC:updateBitrate.bitrate sampleRate:44100 channels:2];
                        [[[[iToast makeText:[NSString stringWithFormat:@"Update bitrate %d",updateBitrate.bitrate]]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                    NSLog(@"updateBitrate %ld",updateBitrate.bitrate);
                }
               
                if ([getSongResponse.status isKindOfClass:[NSString class]]) {
                    if ([getSongResponse.status isEqualToString:@"READY"] && isKaraokeTab) {

                        dispatch_async(dispatch_get_main_queue(), ^{
                            streamIsPlay=YES;

                            /* Show the movie slider control since the movie is now ready to play. */

                        });
                    }else if([getSongResponse.status isEqualToString:@"ERROR"] && isKaraokeTab){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            streamIsPlay=NO;

                        });
                    }
                    if ([getSongResponse.action isKindOfClass:[NSString class]]) {
                        if ([getSongResponse.action isEqualToString:@"RECEIVE"]) {
                            isRECEIVE = YES;
                            
                        }else if ([getSongResponse.action isEqualToString:@"SEND"]) {
                           
                            isSEND = YES;
                        }
                    }
                }
            }else  if (status==1 || status==3){//bỏ 26 byte đầu 2 byte lenght,  1 byte phân type,8 byte possition,8 byte HASH và 7 byte header AAC

              kieuL.longs[0]=bytes[10];
			   kieuL.longs[1]=bytes[9];
			   kieuL.longs[2]=bytes[8];
			   kieuL.longs[3]=bytes[7];
			   kieuL.longs[4]=bytes[6];
			   kieuL.longs[5]=bytes[5];
			   kieuL.longs[6]=bytes[4];
			   kieuL.longs[7]=bytes[3];
				 long lenghtAudio=kieuL.l;
                NSRange range =NSMakeRange(0, size+2);//NSMakeRange(0, size+2);//




                //result=[[NSMutableData alloc] initWithBytes:bytes length:size+2];
                if (data.length>=size+2){
                result=[NSMutableData dataWithData: [data subdataWithRange:range]];
                    [ringBufferData enqObject:result];
                    [data replaceBytesInRange:NSMakeRange(0, size+2) withBytes:nil length:0];
                }
                
				// NSLog(@"receice data %d ring lenght %d",ringBufferData.count,size);
               
				/* //NSMutableData *dataEncoded=(NSMutableData *)[ringBufferData deqObject];
				 if ([result isKindOfClass:[NSMutableData class]]) {
					  if (result.length>26) {

								// NSData * dataEncoded= [[NSUserDefaults standardUserDefaults] objectForKey:@"dataEncoded"];
						   NSRange range =NSMakeRange(11, result.length-11);
						   char* bytes=(char *)[result bytes];
						   NSMutableData *result2=[NSMutableData dataWithData:[result subdataWithRange:range]];
						   kieuL.longs[0]=bytes[10];
						   kieuL.longs[1]=bytes[9];
						   kieuL.longs[2]=bytes[8];
						   kieuL.longs[3]=bytes[7];
						   kieuL.longs[4]=bytes[6];
						   kieuL.longs[5]=bytes[5];
						   kieuL.longs[6]=bytes[4];
						   kieuL.longs[7]=bytes[3];
						   u.bytes[0]=bytes[1];
						   u.bytes[1]=bytes[0];
								// NSLog(@"audio data %d posstion %ld %d %d",(short)bytes[2],kieuL.l,( short)bytes[11],( short)bytes[12]);
						   int curr=(int)(kieuL.l/1024);


						   [self decodeAudioAAC:result2 withPts:kieuL.l];



					  }
				 }*/
            }else  if (status==1){//bỏ 9 byte đầu là 1 byte phân type,8 byte possition,8byte hash
                kieuL.longs[0]=bytes[8];
                kieuL.longs[1]=bytes[7];
                kieuL.longs[2]=bytes[6];
                kieuL.longs[3]=bytes[5];
                kieuL.longs[4]=bytes[4];
                kieuL.longs[5]=bytes[3];
                kieuL.longs[6]=bytes[2];
                kieuL.longs[7]=bytes[1];
                //NSLog(@"audio data %d posstion %lld",(short)bytes[2],kieuL.l);
                NSRange range =NSMakeRange(11, size-11);




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
    }

     //NSLog(@"Start read data %ld and size %d",leng,size);
    [socket readDataWithTimeout:-1 tag:0];
}

- (void) processDataAudio{
   @autoreleasepool{
       NSRange range;
       char* bytes;
       int curr=0;
        while (YES) {
			 if (!isReceiveLive) {
                 [NSThread sleepForTimeInterval:0.05f];
				  break;
			 }

            if (ringBufferData.count>0 && !playXong  ) {
                //pop data ra va xu ly data
				 playXong = YES;
				 @try {
                   
                 dataEncoded=(NSMutableData *)[ringBufferData deqObject];
                if ([dataEncoded isKindOfClass:[NSMutableData class]]) {
                    if (dataEncoded.length>26 && dataEncoded) {

						// NSData * dataEncoded= [[NSUserDefaults standardUserDefaults] objectForKey:@"dataEncoded"];
                         range =NSMakeRange(11, dataEncoded.length-11);
                        bytes=(char *)[dataEncoded bytes];
                        resultDecode=[NSMutableData dataWithData:[dataEncoded subdataWithRange:range]];
                        kieuL.longs[0]=bytes[10];
                        kieuL.longs[1]=bytes[9];
                        kieuL.longs[2]=bytes[8];
                        kieuL.longs[3]=bytes[7];
                        kieuL.longs[4]=bytes[6];
                        kieuL.longs[5]=bytes[5];
                        kieuL.longs[6]=bytes[4];
                        kieuL.longs[7]=bytes[3];
						 u.bytes[0]=bytes[1];
						 u.bytes[1]=bytes[0];
						 //NSLog(@"audio data %d posstion %ld %d %d",(short)bytes[2],kieuL.l,( short)bytes[11],( short)bytes[12]);
                         curr=(int)(kieuL.l/1024);

                       /* NSError *error = nil;
                        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                              NSUserDomainMask, YES);
                        
                        NSString * dirPath = [paths firstObject];
                        NSString * path = [dirPath stringByAppendingPathComponent:@"audioDataError"];
                          BOOL success = [dataEncoded writeToFile:path options:NSDataWritingAtomic error:&error];*/
                        [self decodeAudioAAC:resultDecode withPts:kieuL.l];
                      //  free(bytes);
                      //  resultDecode = nil;
                       // playXong = NO;
                        //dataEncoded= nil;
                            resultDecode = nil;
					}else {
						 playXong = NO;
					}
				}else {
					 playXong = NO;
				}
				 } @catch (NSException *exception) {
					  NSLog(@"MYAudioTapProcessor %@", exception.reason);
                     NSString *mess = [NSString stringWithFormat:[NSString stringWithFormat:@"Decode data receice Live exception %@",exception.reason]];
                     [self sendLogInfoStream:mess];
				 }
                playXong = NO;
            }else{
                [NSThread sleepForTimeInterval:0.03f];
            }
            //dataEncoded= nil;
           // resultDecode = nil;
        }
   
    }
}
BOOL isInLiveView;
RingBuffer *ringBufferAudioLive;
- (void) showRulerDataAudio:(float) audio {
	 dispatch_async(dispatch_get_main_queue(), ^{
	 CGRect frame=self.rulerVolumeV.frame;
	 CGRect frame2=self.rulerVolumeView.frame;
	 float max=audio;
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
	 });
}
static BOOL sendingAudioLive;
- (void) processDataAudioLive{
    @autoreleasepool{
        int i = 0;
        int j = 0;
        float  pcmData[2048+200];
        short  shortData[2048+200];
        unsigned char audioData[4096+200];
        sendingAudioLive = NO;
        isStartingLive = YES;
        tellSendAudio = 0;
        int demKoSend = 0;
       
        while (YES) {
			// int32_t availableBytes ;
			// AudioBufferList *tail = TPCircularBufferHead(ringBufferAudioLive, &availableBytes);
			 if (!isStartingLive ) {
                 tellSendAudio = 0;
                 sendingAudioLive = NO;
				  return;
			 }
			
			// NSLog(@"send audio buffer lenght %d",ringBufferAudioLive->length());
			 if (ringBufferAudioLive->length()>2048 && !sendingAudioLive && isStartingLive) {
                //pop data ra va xu ly data
				 sendingAudioLive = YES;
                 demKoSend = 0;
                 //@try {
				  i = 0;
				 while (i<2048) {
					  pcmData[i] = ringBufferAudioLive->pop();
					  //[self showRulerDataAudio:pcmData[i]];
					  if (pcmData[i]>1) {
						   pcmData[i] = 1.0;
					  }else if (pcmData[i]<-1 ) {
						   pcmData[i] = -1.0;

										   }
					  shortData[i] = (short) (pcmData[i]*32767.0f);

					  i++;

				 }
				  j=0;
				  while (j<2048) {
					   audioData[(j*2)] = (unsigned char) shortData[j];
					   audioData[(j*2+1)] = (unsigned char) (shortData[j]>>8);
					   j++;

				  }
				 /* AudioBufferList decBuffer;
				  decBuffer.mNumberBuffers = 1;
				  decBuffer.mBuffers[0].mNumberChannels = 2;
				  decBuffer.mBuffers[0].mDataByteSize = 2048 * sizeof(float);
				  decBuffer.mBuffers[0].mData = pcmData;

					 OSStatus result;
				  UInt32 numByte=decBuffer.mBuffers[0].mDataByteSize;
							 result = AudioFileWriteBytes(destinationFile,false,tell,
														  &numByte,
														  decBuffer.mBuffers[0].mData);
							 tell+=numByte;
							 if(result!= noErr){
								 NSLog(@"ExtAudioFileWrite failed with code %i \n", result);
							 }*/
                 if (tellSendAudio ==0){
                     [self setSendStartLive];
                 }
				  [self sendAudioToSocket:audioData lenght:4096 sample:tellSendAudio];
				  tellSendAudio  = tellSendAudio + 1024;
                 /*}@catch (NSException *exception ){
                     NSLog(@"processDataAudioLive %@",exception);
                 }*/
				  sendingAudioLive = NO;
                 
            }else{
                
                [NSThread sleepForTimeInterval:0.02f];
                demKoSend ++;
                if ( isStartingLive && demKoSend==30 && tellSendAudio>0){
                    NSString *mess= @"";
                    if (ringBufferAudioLive){
                    mess = [NSString stringWithFormat:[NSString stringWithFormat:@"Ko send audio khi live Sample %d Ring lenght %ld Gui SendRequest %d AudioEngineEnable %d Playthrough enable %d - SendLive %d",tellSendAudio, ringBufferAudioLive->length(),isSEND,[audioEngine3.audioController running],isVoice, audioEngine3.sendLive]];
                    }else {
                        mess = [NSString stringWithFormat:[NSString stringWithFormat:@"Ko send audio khi live Sample %d Ring NULL Gui SendRequest %d AudioEngineEnable %d Playthrough enable %d",tellSendAudio,isSEND,[audioEngine3.audioController running],isVoice]];
                    }
                    [self sendLogInfoStream:mess];
                    NSLog(@"%@",mess);
                    demKoSend = 0;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:mess]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                    
                }
            }
        }
    }
}
- (void) processDataMC {
    @autoreleasepool{
        float  pcmData[2048];
        short  shortData[2048];
        unsigned char audioData[4096];
        sendingAudioLiveMC = NO;
        int i = 0;
        int j=0;
        while (YES) {
            // int32_t availableBytes ;
            // AudioBufferList *tail = TPCircularBufferHead(ringBufferAudioLive, &availableBytes);
             if (!isSendingMicMC) {
                  return;
             }
            
             //NSLog(@"send audio buffer lenght %ònd",ringBufferAudioLive->length());
             if (ringBufferAudioLive->length()>2048 && !sendingAudioLiveMC && isSendingMicMC) {
                //pop data ra va xu ly data
                 sendingAudioLiveMC = YES;

                  i = 0;
                 while (i<2048) {
                      pcmData[i] = ringBufferAudioLive->pop();
                      //[self showRulerDataAudio:pcmData[i]];
                      if (pcmData[i]>1) {
                           pcmData[i] = 1.0;
                      }else if (pcmData[i]<-1 ) {
                           pcmData[i] = -1.0;

                                           }
                      shortData[i] = (short) (pcmData[i]*32767.0f);

                      i++;

                 }
                  j=0;
                  while (j<2048) {
                       audioData[(j*2)] = (unsigned char) shortData[j];
                       audioData[(j*2+1)] = (unsigned char) (shortData[j]>>8);
                       j++;

                  }
              

                  [self sendAudioToSocket:audioData lenght:4096 sample:tellSendAudio];
                  tellSendAudio  = tellSendAudio + 1024;
                  sendingAudioLiveMC = NO;
            }else{
                [NSThread sleepForTimeInterval:0.02f];
            }
        }
    }
}
- (void)testDecode {
	 NSData * dataEncoded= [[NSUserDefaults standardUserDefaults] objectForKey:@"dataEncoded"];
							NSRange range =NSMakeRange(11, dataEncoded.length-11);
							unsigned char* bytes=(unsigned char *)[dataEncoded bytes];
							NSMutableData *result=[NSMutableData dataWithData:[dataEncoded subdataWithRange:range]];
							kieuL.longs[0]=bytes[10];
							kieuL.longs[1]=bytes[9];
							kieuL.longs[2]=bytes[8];
							kieuL.longs[3]=bytes[7];
							kieuL.longs[4]=bytes[6];
							kieuL.longs[5]=bytes[5];
							kieuL.longs[6]=bytes[4];
							kieuL.longs[7]=bytes[3];
							 u.bytes[0]=bytes[1];
							 u.bytes[1]=bytes[0];
							 //NSLog(@"audio data %d posstion %ld %d %d",(short)bytes[2],kieuL.l,( short)bytes[11],( short)bytes[12]);
							int curr=(int)(kieuL.l/1024);

							//	dataHash[curr]=hashL.l;

								[self decodeAudioAAC:result withPts:kieuL.l];
}
- (long) timeBuffer{
    long timeBuffe=0;
    long curr=0;
    //curr=CMTimeGetSeconds(audioPlayer.currentTime)*44100/1024;
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



        if (!streamSVIsConnect) {
            demConnect++;
            if (demConnect>3) {
                demConnect=0;
                [self reconnectAssynSocket];
				 [NSThread detachNewThreadSelector:@selector(loadStreamLive) toTarget:self withObject:nil];
				//  [[NSNotificationCenter defaultCenter] postNotificationName:@"loadStreamLive" object:nil];
				NSLog(@"reload stream checkring");
            }
        }

        [self performSelector:@selector(checkRing) withObject:nil afterDelay:0.4];
	}
}

- (void) sendDestroy{
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:0];
    NSString *stringEffect=[songRec.effectsNew toJSONString];
    songRec.effectsNew.hashCode=[NSNumber numberWithUnsignedInteger:stringEffect.hash/1000];
    hashEffect=[songRec.effectsNew.hashCode longValue];
    NSString *original =[[LoadData2 alloc ] getParaDestroyStream:streamName andEffect:songRec];
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


- (void) sendDoNothingStream{

	 NSString *original = [[LoadData2 alloc ] getSendDoNothingLiveStream:liveRoomID andDevice:currentFbUser.facebookId];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length]+1;
    // char* head=(char *)&len;
   unsigned char byte_arr[3] ;
	 byte_arr[2] = 0;
	byte_arr[0] =(len>>8) & 0x00FF;
	byte_arr[1] = len & 0x00FF;
    u.s=len;

    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) sendRECEIVEStream{
    isRECEIVE = NO;
	 NSString *original = [[LoadData2 alloc ] getSendDataStream:liveRoomID andDevice:currentFbUser.facebookId andAction:@"RECEIVE"];
	 NSLog(@"sendRECEIVEStream %@",liveRoomID);
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
   short len=[data length]+1;
   //  char* head=(char *)&len;
    unsigned char byte_arr[3] ;
	  byte_arr[2] = 0;
	 byte_arr[0] =(len>>8) & 0x00FF;
	 byte_arr[1] = len & 0x00FF;
    u.s=len;

    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
	 char* bytes=(char *)[data bytes];
			u.bytes[0]=bytes[0];
			u.bytes[1]=bytes[1];
			long size=u.s;
			  long leng=[data length];
			//  NSLog(@"socket read data %ld and size %d",leng,size);

			short status=(short)bytes[2];
    [socket writeData:data withTimeout:-1 tag:2];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self performSelector:@selector(checkIsRECEIVE) withObject:nil afterDelay:5];
    });
}
- (void) sendSTOPRECEIVEStream{

	 NSString *original = [[LoadData2 alloc ] getSendDataStream:liveRoomID andDevice:currentFbUser.facebookId andAction:@"STOPRECEIVE"];
	 NSLog(@"sendSTOPRECEIVEStream %@",liveRoomID);
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
   short len=[data length]+1;
   //  char* head=(char *)&len;
    unsigned char byte_arr[3] ;
	  byte_arr[2] = 0;
	 byte_arr[0] =(len>>8) & 0x00FF;
	 byte_arr[1] = len & 0x00FF;
    u.s=len;

    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
	 char* bytes=(char *)[data bytes];
			u.bytes[0]=bytes[0];
			u.bytes[1]=bytes[1];
			long size=u.s;
			  long leng=[data length];
			//  NSLog(@"socket read data %ld and size %d",leng,size);

			short status=(short)bytes[2];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) checkIsRECEIVE {
    if (!isRECEIVE) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
                [[[[iToast makeText:AMLocalizedString(@"Kết nối với server bị gián đoạn!", nil)]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
         
           
            [self removeHandle];
                // self.liveroom.noOnlineMembers --;
            demConnect = 1;
            [socket disconnect];
            socket.delegate=nil;
            [playerVideo pause];
            isReceiveLive = NO;
            isStartingLive = NO;
            [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
                // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
            [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
            [audioEngine3 stopP];
                //  [audioEngine3 destroy];
            audioEngine3 = nil;
                 [self.roomShowTimeView removeFromSuperview];
            
            [self.playerLayerView removeFromSuperview];
            [self.playerLayerView.playerLayer setPlayer:nil];
            self.playerLayerView=nil;
            if (doNothingStreamTimer) {
                [doNothingStreamTimer invalidate];
                doNothingStreamTimer=nil;
            }
            if (timerPlayer) {
                [timerPlayer invalidate];
                timerPlayer= nil;
            }
            if (changeBGtimer) {
                [changeBGtimer invalidate];
                changeBGtimer=nil;
            }
            AVAudioSession *session = [ AVAudioSession sharedInstance ];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"outLiveRoom"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"loadStreamLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"homePressLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"homeComebackLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"startAudiEngine"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"stopLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillShowNotification
                                                          object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillHideNotification
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
            socket = nil;
            isInLiveView = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
           
        });
        return;
    }
}
- (void) checkIsSEND {
    if (!isSEND) {
        isSEND = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[[iToast makeText:AMLocalizedString(@"Kết nối với server bị gián đoạn!", nil)]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
          
            [self removeHandle];
                // self.liveroom.noOnlineMembers --;
            demConnect = 1;
            [socket disconnect];
            socket.delegate=nil;
            [playerVideo pause];
            isReceiveLive = NO;
            isStartingLive = NO;
            [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
                // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
            [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
            [audioEngine3 stopP];
                //  [audioEngine3 destroy];
            audioEngine3 = nil;
                [self.roomShowTimeView removeFromSuperview];
            
            [self.playerLayerView removeFromSuperview];
            [self.playerLayerView.playerLayer setPlayer:nil];
            self.playerLayerView=nil;
            if (doNothingStreamTimer) {
                [doNothingStreamTimer invalidate];
                doNothingStreamTimer=nil;
            }
            if (timerPlayer) {
                [timerPlayer invalidate];
                timerPlayer= nil;
            }
            if (changeBGtimer) {
                [changeBGtimer invalidate];
                changeBGtimer=nil;
            }
            AVAudioSession *session = [ AVAudioSession sharedInstance ];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"outLiveRoom"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"loadStreamLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"homePressLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"homeComebackLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"startAudiEngine"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"stopLive"
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillShowNotification
                                                          object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillHideNotification
                                                          object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
            socket = nil;
            isInLiveView = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
        return;
    }
}
- (void) sendSENDStream{
    isSEND = NO;
	 NSString *original = [[LoadData2 alloc ] getSendDataStream:liveRoomID andDevice:currentFbUser.facebookId andAction:@"SEND"];
    NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
   short len=[data length]+1;
   //  char* head=(char *)&len;
    unsigned char byte_arr[3] ;
	  byte_arr[2] = 0;
	 byte_arr[0] =(len>>8) & 0x00FF;
	 byte_arr[1] = len & 0x00FF;
    u.s=len;

    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
	 char* bytes=(char *)[data bytes];
			u.bytes[0]=bytes[0];
			u.bytes[1]=bytes[1];
			long size=u.s;
			  long leng=[data length];
			//  NSLog(@"socket read data %ld and size %d",leng,size);

			short status=(short)bytes[2];
    [socket writeData:data withTimeout:-1 tag:2];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self performSelector:@selector(checkIsSEND) withObject:nil afterDelay:5];
    });
}
- (void) sendLogInfoStream:(NSString *)message {
    LogStreamRequest *streamRequest = [[LogStreamRequest alloc] init];
    streamRequest.streamId = self.liveroom.roomId;
    streamRequest.facebookId = currentFbUser.facebookId;
    streamRequest.message = message;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"POST\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"LOG\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),self.liveroom.roomId,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    NSMutableData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length]+1;
        //  char* head=(char *)&len;
    unsigned char byte_arr[3] ;
    byte_arr[2] = 0;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
    char* bytes=(char *)[data bytes];
    u.bytes[0]=bytes[0];
    u.bytes[1]=bytes[1];
    long size=u.s;
    long leng=[data length];
        //  NSLog(@"socket read data %ld and size %d",leng,size);
    
    short status=(short)bytes[2];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) sendMoreInfoStream {
    MoreInforDataRequest *streamRequest = [[MoreInforDataRequest alloc] init];
    streamRequest.streamId = self.liveroom.roomId;
    streamRequest.facebookId = currentFbUser.facebookId;
    streamRequest.streamName = self.liveroom.name;
    streamRequest.facebookName = currentFbUser.name;
    NSString *parameters = [streamRequest toJSONString];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    
    [postString appendFormat:( @"{\"method\":\"POST\",\"remoteAddr\":\"\",\"params\":{\"action\":[\"MOREINFOR\"],\"streamName\":[\"%@\"],\"parameters\":[\"%@\"]}}"),self.liveroom.roomId,[[iosDigitalSignature alloc] encryptionV19:parameters]];
    NSMutableData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    short len=[data length]+1;
        //  char* head=(char *)&len;
    unsigned char byte_arr[3] ;
    byte_arr[2] = 0;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
    u.s=len;
    
    [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
    char* bytes=(char *)[data bytes];
    u.bytes[0]=bytes[0];
    u.bytes[1]=bytes[1];
    long size=u.s;
    long leng=[data length];
        //  NSLog(@"socket read data %ld and size %d",leng,size);
    
    short status=(short)bytes[2];
    [socket writeData:data withTimeout:-1 tag:2];
}
- (void) sendSTOPSENDStream{

     NSString *original = [[LoadData2 alloc ] getSendDataStream:liveRoomID andDevice:currentFbUser.facebookId andAction:@"STOPSEND"];
	   NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
	  short len=[data length]+1;
	  //  char* head=(char *)&len;
	   unsigned char byte_arr[3] ;
		 byte_arr[2] = 0;
		byte_arr[0] =(len>>8) & 0x00FF;
		byte_arr[1] = len & 0x00FF;
	   u.s=len;

	   [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
		char* bytes=(char *)[data bytes];
			   u.bytes[0]=bytes[0];
			   u.bytes[1]=bytes[1];
			   long size=u.s;
				 long leng=[data length];
			   //  NSLog(@"socket read data %ld and size %d",leng,size);

			   short status=(short)bytes[2];
	   [socket writeData:data withTimeout:-1 tag:2];
}

- (void)setupAudioConverter{
   
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
    NSURL * destinationURL = [NSURL fileURLWithPath:destinationFilePath];
    UInt32 size ;

	//  AudioFileCreateWithURL((__bridge CFURLRef)destinationURL, kAudioFileM4AType, &inFormat, kAudioFileFlags_EraseFile, &destinationFile);
    if (![self checkError:AudioFileOpenURL((__bridge CFURLRef _Nonnull)(destinationURL),kAudioFileReadWritePermission,0, &destinationFile) withErrorString:[NSString stringWithFormat:@"ExtAudioFileOpenURL failed for destinationFile with URL: %@", destinationURL]]) {
        return ;
    }
    AudioStreamBasicDescription clientFormat =audioFormat;
    size = sizeof(clientFormat);
    OSStatus result = 0;
    result = AudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
    if(result != noErr)
        NSLog(@"error on ExtAudioFileSetProperty for output File with result code %i \n", result);

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

- (void) decodeAudioAAC:(NSData *)frame withPts:(SInt64)pts{
	
	// dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		//	dispatch_async(queue, ^{
				// const uint32_t MAX_AUDIO_FRAMES = 2048;
					//	const uint32_t maxDecodedSamples = MAX_AUDIO_FRAMES * 1;
    @try {
					float  outDataDecodeAAC [2048 ];

				 unsigned char * encoded=(unsigned char * )[frame bytes];
	 //unsigned char inData [frame.length];
	// memcpy(inData, encoded, frame.length);
				 int returnSize = [decoder decodeFrame:encoded outData:outDataDecodeAAC Lenght:frame.length];
	// NSLog(@"returnsize %d outdata %f %f",returnSize,outData[20],outData[21]);
	 AVAudioPCMBuffer * bufferAudio ;
	 AVAudioChannelLayout *chLayout = [[AVAudioChannelLayout alloc] initWithLayoutTag:kAudioChannelLayoutTag_Stereo];
	 AVAudioFormat *chFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32
															   sampleRate:44100.0
															   interleaved:NO
															 channelLayout:chLayout];
	 bufferAudio = [[AVAudioPCMBuffer alloc] initWithPCMFormat:chFormat frameCapacity:1024];
	 bufferAudio.frameLength  = 1024;
	 //memcpy(bufferAudio.floatChannelData, outData, sizeof(outData));

	// bufferAudio.audioBufferList = decBuffer;
	 for (int i =0 ; i<returnSize/2 ; i++){
		  bufferAudio.floatChannelData[0][i] = outDataDecodeAAC[i*2];
		  bufferAudio.floatChannelData[1][i] = outDataDecodeAAC[i*2+1];
	 }
    if (!engine.isRunning ){
            // [engine startAndReturnError:nil];
        engine = [AVAudioEngine new];
        tell = 0;
        playerNode = [AVAudioPlayerNode new];
        NSLog(@"play lai engine");
        AVAudioFormat * audioFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100 channels:2 interleaved:NO];
       // [engine detachNode:playerNode];
        
        [engine attachNode:playerNode];
        AVAudioMixerNode * mixerNode= engine.mainMixerNode;
        [engine connect:playerNode to:mixerNode format:audioFormat];
        [engine prepare];
        [engine startAndReturnError:nil];
        [playerNode play];
    }
    
	 [playerNode scheduleBuffer:bufferAudio completionHandler:^{

	 }];
    if (!playerNode.isPlaying){
        [playerNode play];
        NSLog(@"play lai playerNode");
    }
    }@catch (NSException *exception) {
        NSLog(@"decode AAC error %@",exception);
        
    }
	  playXong = NO;
   // free(encoded);
	// float *buffer = (float *)malloc(maxDecodedSamples * sizeof(float));
	/*AudioBufferList decBuffer;
	 decBuffer.mNumberBuffers = 1;
	 decBuffer.mBuffers[0].mNumberChannels = 2;
	 decBuffer.mBuffers[0].mDataByteSize = maxDecodedSamples * sizeof(float);
	 decBuffer.mBuffers[0].mData = outData;

		OSStatus result;
	 UInt32 numByte=decBuffer.mBuffers[0].mDataByteSize;
				result = AudioFileWriteBytes(destinationFile,false,tell,
											 &numByte,
											 decBuffer.mBuffers[0].mData);
				tell+=numByte;
				if(result!= noErr){
					NSLog(@"ExtAudioFileWrite failed with code %i \n", result);
				}
	 playXong = NO;*/


}

- (void)sendAudioToSocket:(unsigned char []) bufferIn lenght:(long) lenghT sample: (long) sampleI{
	 if(!destinationFile){
			// [self setupAudioConverter];
		 }
	
	// [encoder initAAC:128000 sampleRate:44100 channels:2];
	 int encodeSize = [encoder encodeFrame:bufferIn outData:encodedDataD Lenght:lenghT];
	short realDataLength = (short) (encodeSize + 9);
	 unsigned char realDataType[1];
	 realDataType[0]= (unsigned char) 1;
	 NSData* dataLenght = [[NSData alloc] initWithBytes:&realDataLength length:2];
	// [dataLenght getBytes:&realDataLength length:2];
	 NSData* sampleByte = [[NSData alloc] initWithBytes:&sampleI length:8];
	// [sampleByte getBytes:&sample length:8];
	NSMutableData* sendByteBuffer =[[NSMutableData alloc] initWithLength:realDataLength+2];

	 //  char* head=(char *)&len;
	  
    byte_arrSend[2] = 1;
    byte_arrSend[0] =(realDataLength>>8) & 0x00FF;
    byte_arrSend[1] = realDataLength & 0x00FF;
	 sampleAudioL.l = sampleI;
	
	 byte_arrS[0] = sampleAudioL.longs[7];
	 byte_arrS[1] = sampleAudioL.longs[6];
	 byte_arrS[2] = sampleAudioL.longs[5];
	 byte_arrS[3] = sampleAudioL.longs[4];
	 byte_arrS[4] = sampleAudioL.longs[3];
	 byte_arrS[5] = sampleAudioL.longs[2];
	 byte_arrS[6] = sampleAudioL.longs[1];
	 byte_arrS[7] = sampleAudioL.longs[0];

	  [sendByteBuffer replaceBytesInRange:NSMakeRange(0, 3) withBytes:byte_arrSend length:3];

	 [sendByteBuffer replaceBytesInRange:NSMakeRange(3, 8) withBytes:byte_arrS length:8];
	 [sendByteBuffer replaceBytesInRange:NSMakeRange(11, encodeSize) withBytes:encodedDataD length:encodeSize];
	// NSLog(@"data lenght %d send %c sample %ld",sendByteBuffer.length,encodedDataD[50], sampleAudioL.l);
    
	[socket writeData:sendByteBuffer withTimeout:-1 tag:3];

	
}
- (void )decodeAudioFrame:(NSData *)frame withPts:(SInt64)pts{
   
    @try {
    AudioStreamPacketDescription packetDescription;
    memset(&packetDescription, 0, sizeof(AudioStreamPacketDescription));
    packetDescription.mStartOffset=0;
    packetDescription.mDataByteSize=(UInt32)frame.length;
    packetDescription.mVariableFramesInPacket=0;
    PassthroughUserData3 userData = { 2, (UInt32)frame.length, [frame bytes],packetDescription};


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
                                                      inInputDataProc3,
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
    }@catch (NSException *exception) {
        NSLog(@"decode AAC error %@",exception);
        
    }
    // return decodedData;
    //audioRenderer->Render(&pData, decodedData.length, pts);
}

- (void) creatAudioEngine{
    @autoreleasepool {
        if (audioEngine3 ==nil ){
            //dispatch_async(dispatch_get_main_queue(), ^{
            AEAudioController * audioController1 = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
            audioController1.preferredBufferDuration = 0.005;
			// audioController1.useMeasurementMode = YES;
            //audioController1.inputGain=1;
            audioController1.enableBluetoothInput=YES;
            [audioController1 start:nil];
            //[audioController1 performSelectorInBackground:@selector(start:) withObject:nil];
            //[NSThread detachNewThreadSelector:@selector(start) toTarget:audioController1 withObject:nil];
            audioEngine3=[[audioEngine alloc] initWithAudioController:audioController1];
          
            //[audioEngine3 expanderSwitchChanged:YES];
            //});
		}
    }
}
- (void) demTimeHideRoomShowTime {
	 demTimeHideRoomShowTime --;
	 if (demTimeHideRoomShowTime > 20) {
		  return;
	 }
	 if (demTimeHideRoomShowTime>0) {
		  dispatch_async(dispatch_get_main_queue(), ^{
			   self.roomShowTimeTimerLabel.text =[NSString stringWithFormat:@"%@",[self convertTimeToString2:demTimeHideRoomShowTime]];
		  });
		  [self performSelector:@selector(demTimeHideRoomShowTime) withObject:nil afterDelay:1];
	 }else {
	 dispatch_async(dispatch_get_main_queue(), ^{
		  self.roomShowTimeView.hidden = YES;
         [self.view addSubview:self.roomShowTimeView];
		 // [self.roomShowTimeView removeFromSuperview];
	 });
		   [self performSelectorOnMainThread:@selector(removeSongLive) withObject:nil waitUntilDone:NO];
	 }
}
 int demTimeHideRoomShowTime;
- (IBAction)roomShowTimeStart:(id)sender {
	 if (hasHeadset) {
		  self.roomShowTimeView.hidden = YES;
         [self.view addSubview:self.roomShowTimeView];
		  demTimeHideRoomShowTime = 100;
     
		  [self startLive];

		  [self updateSongLive];
	 }else {

			   //[self.roomShowTimeView removeFromSuperview];
		  demTimeHideRoomShowTime = 100;

		  self.roomShowTimeView.hidden = YES;
         [self.view addSubview:self.roomShowTimeView];
		  [self removeSongLive];
		  UIAlertController*  alertDisconnectStream=[UIAlertController alertControllerWithTitle:@"Yêu cầu tai nghe"
																						message:@"Vui lòng gắn tai nghe để bắt đầu live!\n Lượt hát này sẽ bị hủy bỏ. Vui lòng gắn tai nghe và xếp lượt lại!"
																				 preferredStyle:UIAlertControllerStyleAlert];

		  UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
															  style:UIAlertActionStyleDefault
															handler:^(UIAlertAction * action)
									  {
		   /** What we write here???????? **/

		   streamPlay=NO;

				// call method whatever u need
		  }];
		  NSLog(@"tai nghe");
		  [alertDisconnectStream addAction:yesButton];
		  [self presentViewController:alertDisconnectStream animated:YES completion:nil];
	 }

}
- (IBAction)roomShowTimeCancel:(id)sender {
	 demTimeHideRoomShowTime = 100;

	  self.roomShowTimeView.hidden = YES;
    [self.view addSubview:self.roomShowTimeView];
	 [self removeSongLive];
}

- (void) startAudiEngine{
    
	 dispatch_async(dispatch_get_main_queue(), ^{
	 self.startStreamLoading.hidden = YES;
         
     });
    encoder = [[AACEncoder alloc] init];
    [encoder initAAC:128000 sampleRate:44100 channels:2];
	  [self creatAudioEngine];
    [audioEngine3 addOutPutReceive];
	 if (audioEngine3.audioController.running==NO) {
		  NSError* error;

		  [audioEngine3.audioController start:&error];
	 }
	 if (ringBufferAudioLive)
	 ringBufferAudioLive->empty();
    self.isLoading.hidden = NO;
    [NSThread detachNewThreadSelector:@selector(waitStartLive) toTarget:self withObject:nil];
    //[self performSelector:@selector(setSendStartLive) withObject:nil afterDelay:0.5];
   
}
- (void) waitStartLive {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging._id]];
    if ([userSinging.songUrl isKindOfClass:[NSString class]]){
        if ([userSinging.songUrl hasSuffix:@"m4a"]) {
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",userSinging._id]];
    }
    }
    if (userSinging.videoId.length>2){
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging.videoId]];
        
    }
        //__weak typeof(self) weakSelf = self;
    /*if ([recordingIdLiveDuet isKindOfClass:[NSString class]]) {
     filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",recordingIdLiveDuet]];
     }*/
    while ([self availableDurationVideo]<3) {
        [NSThread sleepForTimeInterval:0.05];
    }
    dispatch_async( dispatch_get_main_queue(),
                   ^{
        self.isLoading.hidden = YES;
        [playerVideo play];
        [self performSelector:@selector(checkDongBoVideo) withObject:nil afterDelay:4];
    });
   
    [audioEngine3 play:filePath];
    audioEngine3.player.volume = musicVolumeLive;
    audioEngine3.player.completionBlock = ^{
        endSong = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
        
    };
    if ( audioEngine3 && isStartingLive) {
        [audioEngine3 playthroughSwitchChanged:YES];
        [audioEngine3 setPlaythroughVolume:vocalVolumeLive];
        
        [audioEngine3 reverbSwitchChanged:YES];
        audioEngine3.sendLive = YES;
    }
    if (threadEncodeAudio) {
        [ threadEncodeAudio cancel];
    }
    threadEncodeAudio = [[NSThread alloc] initWithTarget:self selector:@selector(processDataAudioLive) object:nil];
    [threadEncodeAudio setName:@"encodeAudioLive"];
    [threadEncodeAudio start];
}
- (void) setSendStartLive{
    [self sendSENDStream];
    [self sendSTOPRECEIVEStream];
}
NSMutableArray * recordingIdLiveDuet;
- (NSTimeInterval) availableDurationVideo;
{
    NSArray *loadedTimeRanges = [[playerVideo currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count>0){
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }
    else return 0;
}
//AVPlayer *playerVideo;
- (void) checkDongBoVideo{
    if (!isStartingLive) return;
    dispatch_async(dispatch_get_main_queue(), ^{
  
    NSLog(@"checkDongBoVideo %f %f %f",CMTimeGetSeconds([playerVideo currentTime]),audioEngine3.player.currentTime,[self availableDurationVideo]);
        //  dispatch_async(dispatch_get_main_queue(), ^{
    if (CMTimeGetSeconds([playerVideo currentTime])>3 && audioEngine3.player.currentTime>=0 &&  fabs(CMTimeGetSeconds([playerVideo currentTime])-audioEngine3.player.currentTime) > 0.8 && !isSeekPlayer && [self availableDurationVideo]>0.5) {
        isSeekPlayer = YES;
            //NSLog(@"seek truoc %0.f",playerVideo.rate);
            //    NSLog(@"%f %f",CMTimeGetSeconds([playerVideo currentTime]),audioEngine3.player.currentTime);
            //double timeAudio = audioEngine3.player.currentTime;
        int32_t timeScale = playerVideo.currentItem.asset.duration.timescale;
        
        CMTime time = CMTimeMakeWithSeconds(audioEngine3.player.currentTime, NSEC_PER_SEC);//(timeAudio, timeScale);
            // [playerVideo seekToTime:CMTimeMake(audioEngine3.player.currentTime, NSEC_PER_SEC)];
            //  dispatch_async(dispatch_get_main_queue(), ^{
        if (CMTimeGetSeconds(time)>0  && CMTimeGetSeconds(time) <CMTimeGetSeconds([self playerVideoDuration])){
            dispatch_async(dispatch_get_main_queue(), ^{
            //if (playerVideo.rate)
              //  [playerVideo pause];
                //if (playerVideo) {
            [playerVideo seekToTime:CMTimeMakeWithSeconds(audioEngine3.player.currentTime+0.5, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero  completionHandler:^(BOOL finished) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    
                    NSLog(@"seek %0.f %f %f",playerVideo.rate,CMTimeGetSeconds([playerVideo currentTime]),audioEngine3.player.currentTime);
                }
                      [playerVideo setRate:1.0f];
                isSeekPlayer = NO;
                 });
                
            }];
            });
           // audioEngine3.player.currentTime = CMTimeGetSeconds(playerVideo.currentTime);
           // isSeekPlayer = NO;
        }
        
    
    }
    });
    [self performSelector:@selector(checkDongBoVideo) withObject:nil afterDelay:15];
}
- (void) startLive {

	  isStartingLive = YES;
	 //isReceiveLive = NO;
	 tellSendAudio = 0;
	 userShowTime = userSinging;
	// dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 //dispatch_async(queue, ^{
			   NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				 NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging._id]];
    if ([userSinging.songUrl isKindOfClass:[NSString class]]){
        if ([userSinging.songUrl hasSuffix:@"m4a"]) {
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",userSinging._id]];
    }
    }
    if (userSinging.videoId.length>2){
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging.videoId]];
        
    }
   /* if ([recordingIdLiveDuet isKindOfClass:[NSString class]]) {
       filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",recordingIdLiveDuet]];
    }*/
			   if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
                  // [NSThread detachNewThreadSelector:@selector(loadVideo:) toTarget:self withObject:[NSString stringWithFormat:@"%@",userSinging.mp4link]];
                   if ([urlVideoMp4 isEqualToString:userSinging.mp4link] ){
                      
                      
                       dispatch_async(dispatch_get_main_queue(), ^{
                       self.playerLayerView.playerLayer.hidden = NO;
                           //self.playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                      
                          
                       });
                   }else {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           self.playerLayerView.playerLayer.hidden = NO;
                           //self.playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                           
                           
                       });
                       [NSThread detachNewThreadSelector:@selector(loadVideo:) toTarget:self withObject:[NSString stringWithFormat:@"%@",userSinging.mp4link]];
                   }
                  
                   [self startAudiEngine];
                 
					dispatch_async(dispatch_get_main_queue(), ^{
						 self.startLiveView.hidden = NO;
						 self.commentTextFieldLeftConstrainst.constant = -80;
						 self.menuToolBarView.hidden = YES;
						  self.BeatInfoImageView.hidden = YES;
                        self.beatInfoImageBG.hidden = YES;
						 [self.circleProgressBar setProgress:0 animated:NO];
                        self.statusViewBottomConstrainst.constant = -60;
                        self.statusViewBottomConstrainst2.constant = -130;
                        self.statusViewBottomConstrainst3.constant = -190;
                        self.pkBattleViewBottomConstrainst.constant = 105;
                        if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                        self.commentTableViewTopConstrainst.constant = 100;
                           // self.giftViewInfo.hidden = YES;
                          //  self.giftViewInfoTopConstrainst.constant = -38;
                            self.notifiView.hidden = YES;
                            self.beatInfoView.hidden = NO;
                            //self.playerViewBottomConstrainst.constant = 30;
                        }
						 [self.view layoutIfNeeded];
						  });

                   


			   }else {
					 [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
					self->isStartingLive = NO;
			   }







	// });
	 if (doNothingStreamTimer==nil) {
		 doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
	 }
}
- (void) stopLive {
    if (ringBufferAudioLive)
        ringBufferAudioLive->empty();
	  isStartingLive = NO;
    urlVideoMp4 = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        self.giftViewInfoImage.image = [UIImage imageNamed:@"ic_Live_ScoreGift.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        //self.pkBattleViewBottomConstrainst.constant = 0;
        self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: self.liveroom.totalGiftScore]];
    });
	 dispatch_async(dispatch_get_main_queue(), ^{
         self.playerLayerView.playerLayer.hidden = YES;
	 self.startStreamLoading.hidden = YES;
	 self.liveVolumeMenuView.hidden = YES;
	 self.startLiveView.hidden = YES;
	 self.menuToolBarView.hidden = NO;
	 self.commentTextFieldLeftConstrainst.constant = 0;
         recordingIdLiveDuet = nil;
	 if (timerPlayer) {
		  [timerPlayer invalidate];
		  timerPlayer= nil;
	 }
        
	 //self.UserSingingInfoView.hidden = YES;
	 self.playerToolbar.hidden = YES;
		  if (self.playerLayerView) {
					// [self.playerLayerView removeFromSuperview];
			   [self.playerLayerView.playerLayer setPlayer:nil];
					//   self.playerLayerView=nil;
		  }
         self.statusViewBottomConstrainst.constant = 0;
         self.statusViewBottomConstrainst2.constant = 70;
         self.statusViewBottomConstrainst3.constant = 120;
         if ([self.liveroom.type isEqualToString:@"VERSUS"]){
             self.playerViewBottomConstrainst.constant = 0;
         //self.commentTableViewTopConstrainst.constant = 100;
             //self.giftViewInfo.hidden = NO;
             //self.giftViewInfoTopConstrainst.constant = 8;
             self.beatInfoView.hidden = YES;
             self.notifiView.hidden = NO;
         }
		  	  [self.view layoutIfNeeded];
	 });



	 NSLog(@"stop live");
	[audioEngine3 pause];
	 [playerVideo pause];
	 [playerNode pause];
	 [engine stop];
    
 
	 if (isVoice && audioEngine3) {
		 [audioEngine3 playthroughSwitchChanged:NO];

		 [audioEngine3 reverbSwitchChanged:NO];
	 }
    audioEngine3.sendLive = NO;
	  [audioEngine3 removeOutPutReceive];
	 [audioEngine3 stopP];
    tell = 0;
    
    if (threadEncodeAudio) {
        [ threadEncodeAudio cancel];
    }
    isReceiveLive = YES;
    [self sendRECEIVEStream];
    [self sendSTOPSENDStream];
   
    [[AVAudioSession sharedInstance]  setCategory: AVAudioSessionCategoryPlayback  error: nil];
    NSError *error = nil;
    if ( ![((AVAudioSession*)[AVAudioSession sharedInstance]) setActive:YES error:&error] ) {
        NSLog(@"TAAE: Couldn't deactivate audio session: %@", error);
    }
  
    audioEngine3 =nil;
    if (endSong){
        endSong = NO;
    
	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 dispatch_async(queue, ^{
	 if (userShowTime) {
	
		  Song *newSong = [Song new];
		  newSong.songName = userShowTime.songName;
		  newSong.firebaseId = userShowTime.firebaseId;
		  newSong._id = userShowTime._id;
		  newSong.videoId = userShowTime.videoId;


		  newSong.owner = userShowTime.owner;
		  newSong.status = 5;
         if ([self.liveroom.type isEqualToString:@"VERSUS"]){
             DoneSongRequest *firRequest = [DoneSongRequest new];
             firRequest.roomId = liveRoomID;
             firRequest.song = newSong;
             if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
                 NSLog(@"DoneSongFirPK firebaseId nil");
             }
             NSString * requestString = [[firRequest toJSONString] base64EncodedString];
             self.functions = [FIRFunctions functions];
             __block BOOL isLoadFir = NO;
             __block FirebaseFuntionResponse *getResponse=nil;
             [[_functions HTTPSCallableWithName:Fir_DoneSongPK] callWithObject:@{@"parameters":requestString}
                                                                  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                 
                 NSString *stringReply = (NSString *)result.data;
                 
                     //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                     // Some debug code, etc.
                 NSLog(@"done song pk %@",stringReply);
                 isLoadFir = YES;
                 
             }];
         }else{
		  DoneSongRequest *firRequest = [DoneSongRequest new];
		  firRequest.roomId = liveRoomID;
		  firRequest.song = newSong;
		  if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
			   NSLog(@"DoneSongFir firebaseId nil");
		  }
		  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
		  self.functions = [FIRFunctions functions];
		  __block BOOL isLoadFir = NO;
		  __block FirebaseFuntionResponse *getResponse=nil;
		  [[_functions HTTPSCallableWithName:Fir_DoneSong] callWithObject:@{@"parameters":requestString}
															   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {

			   NSString *stringReply = (NSString *)result.data;

					//  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
					// Some debug code, etc.
			   NSLog(@"done song %@",stringReply);
			   isLoadFir = YES;

		  }];
         }
	 userShowTime = nil;
	 }
	 });
    }else {
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
        
        dispatch_async(queue, ^{
            if (userShowTime) {
                
                Song *newSong = [Song new];
                newSong.songName = userShowTime.songName;
                newSong.firebaseId = userShowTime.firebaseId;
                newSong._id = userShowTime._id;
                newSong.videoId = userShowTime.videoId;
                
                
                newSong.owner = userShowTime.owner;
                newSong.status = 5;
                
                DoneSongRequest *firRequest = [DoneSongRequest new];
                firRequest.roomId = liveRoomID;
                firRequest.song = newSong;
                
                if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
                    NSLog(@"StopSongFir firebaseId nil");
                }
                if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                    self.functions = [FIRFunctions functions];
                    __block BOOL isLoadFir = NO;
                    __block FirebaseFuntionResponse *getResponse=nil;
                    [[_functions HTTPSCallableWithName:Fir_StopSongPK] callWithObject:@{@"parameters":requestString}
                                                                         completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                        
                        NSString *stringReply = (NSString *)result.data;
                        
                            //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                            // Some debug code, etc.
                        NSLog(@"stop song PK %@",stringReply);
                        isLoadFir = YES;
                        
                    }];
                }else{
                NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                self.functions = [FIRFunctions functions];
                __block BOOL isLoadFir = NO;
                __block FirebaseFuntionResponse *getResponse=nil;
                [[_functions HTTPSCallableWithName:Fir_StopSong] callWithObject:@{@"parameters":requestString}
                                                                     completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                    
                    NSString *stringReply = (NSString *)result.data;
                    
                        //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                        // Some debug code, etc.
                    NSLog(@"stop song %@",stringReply);
                    isLoadFir = YES;
                    
                }];
                }
                userShowTime = nil;
            }
        });
    }
}
AVPlayer *playerVideo;
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
		  dispatch_async(dispatch_get_main_queue(), ^{
			   self.roomShowTimeStartButton.enabled = YES;
			   [self.roomShowTimeStartButton setBackgroundImage:[UIImage imageNamed:@"hinh_nen_27.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
			   self.roomShowTimeHeadsetLabel.text = @"";
		  });
         if (isStartingLive) {
             if (playerVideo) {
                 [playerVideo play];
             }
         }
		/*  if (!isVoice   && [audioEngine3 isKindOfClass:[audioEngine class]] && isStartingLive) {
			   [audioEngine3 playthroughSwitchChanged:YES];
			   [audioEngine3 reverbSwitchChanged:YES];
		  }*/

	 } else
		 {
		  dispatch_async(dispatch_get_main_queue(), ^{
			   self.roomShowTimeStartButton.enabled = NO;
			   [self.roomShowTimeStartButton setBackgroundImage:[UIImage imageNamed:@"hinh_nen_25.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
			   self.roomShowTimeHeadsetLabel.text = AMLocalizedString(@"Bạn chưa kết nối tai nghe, Vui lòng gắn tai nghe để có thể bắt đầu live!", nil);
		  });
		  hasHeadset=NO;
			   // if (isKaraokeTab){
			   //   controller.warningHeadset.hidden=NO;
			   //}
		 /* if (isVoice  && [audioEngine3 isKindOfClass:[audioEngine class]]&& isStartingLive) {
			   [audioEngine3 playthroughSwitchChanged:NO];
			   [audioEngine3 reverbSwitchChanged:NO];
		  }*/


			   //if (playRecord
			   // Change to play on the speaker
			   //   NSLog(@"play on the speaker");
		 }
}
LiveRoom * currentRoomLive;
- (void) changeNoticeRoom:(NSNumber *) change {
	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 dispatch_async(queue, ^{
	 changeNotifi = ![change boolValue];
	 	dispatch_async(dispatch_get_main_queue(), ^{

			 if (changeNotifi) {
				   self.notifiLabel.text = self.liveroom.name;
			 }else {
				  self.notifiLabel.text = [NSString stringWithFormat:@"Room ID: %ld",self.liveroom.uid];
			 }

		});

	 });
	  [self performSelector:@selector(changeNoticeRoom:) withObject:[NSNumber numberWithBool:changeNotifi] afterDelay:4];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.commentTextField.isFirstResponder) {
        [self hideKeyboard];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	 if (scrollView==self.giftStoreViewCollectionView) {
		  CGFloat pageWidth = self.giftStoreViewCollectionView.frame.size.width;
		  self.giftStoreViewPageControl.currentPage = ceil(self.giftStoreViewCollectionView.contentOffset.x / pageWidth);
     }if (scrollView == self.topUserScrollView) {
         CGFloat pageWidth = self.topUserScrollView.frame.size.width;
         [self.topUserSegment setSelectedSegmentIndex:pageWidth];
         return;
     }
    if (self.sendLGCollectionView==scrollView){
        CGFloat pageWidth = self.sendLGCollectionView.frame.size.width;
        self.sendLGPageControl.currentPage = ceil(self.sendLGCollectionView.contentOffset.x / pageWidth);
        selectedLuckyGift = [allLuckyGiftRespone.luckyGifts objectAtIndex:self.sendLGPageControl.currentPage];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   /* if (self.statusAndCommentTableView==scrollView){
        NSArray *visibleCells = [self.statusAndCommentTableView visibleCells];
        
        if (visibleCells != nil  &&  [visibleCells count] != 0) {       // Don't do anything for empty table view
            
           
            UITableViewCell *topCell = [visibleCells objectAtIndex:0];
            UITableViewCell *bottomCell = [visibleCells lastObject];
            
          
                // Avoids issues with skipped method calls during rapid scrolling
            for (UITableViewCell *cell in visibleCells) {
                cell.contentView.alpha = 1.0;
            }
            
          
            NSInteger cellHeight = topCell.frame.size.height - 1;   // -1 To allow for typical separator line height
            NSInteger tableViewTopPosition = self.statusAndCommentTableView.frame.origin.y;
            NSInteger tableViewBottomPosition = self.statusAndCommentTableView.frame.origin.y + self.statusAndCommentTableView.frame.size.height;
            
    
            CGRect topCellPositionInTableView = [self.statusAndCommentTableView rectForRowAtIndexPath:[self.statusAndCommentTableView indexPathForCell:topCell]];
            CGRect bottomCellPositionInTableView = [self.statusAndCommentTableView rectForRowAtIndexPath:[self.statusAndCommentTableView indexPathForCell:bottomCell]];
            CGFloat topCellPosition = [self.statusAndCommentTableView convertRect:topCellPositionInTableView toView:[self.statusAndCommentTableView superview]].origin.y;
            CGFloat bottomCellPosition = ([self.statusAndCommentTableView convertRect:bottomCellPositionInTableView toView:[self.statusAndCommentTableView superview]].origin.y + cellHeight);
            
         
            CGFloat modifier = 1.5;
            CGFloat topCellOpacity = (1.0f - ((tableViewTopPosition - topCellPosition) / cellHeight) * modifier);
            CGFloat bottomCellOpacity = (1.0f - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * modifier);
            
            if (topCell) {
                topCell.contentView.alpha = topCellOpacity;
            }
            if (bottomCell) {
                bottomCell.contentView.alpha = bottomCellOpacity;
            }
        }
    }*/
	
	  if (self.statusAndCommentTableView.contentOffset.y>self.statusAndCommentTableView.contentSize.height - self.statusAndCommentTableView.frame.size.height-60){
		   self.cmtNotifyView.hidden = YES;
	  }
}
- (IBAction)cmtTextFieldChange:(id)sender {
	 if (self.commentTextField.text.length>0) {
		  [self.cmtViewSendButton setTitleColor:UIColorFromRGB(HeaderColor) forState:UIControlStateNormal];
	 }else {
		  [self.cmtViewSendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	 }
}
- (void) hideKeyboard {
	dispatch_async(dispatch_get_main_queue(), ^{
		 [self.commentTextField resignFirstResponder];
	});
}

- (IBAction)alertViewYesPress:(id)sender {
	  self.liveAlertView.hidden = YES;
    if (alertInviteMemberFamily){
        alertInviteMemberFamily = NO;
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
        
        dispatch_async(queue, ^{
            PromotedResponse * getRespone = [[LoadData2 alloc  ]AcceptInviteJoinFamily:acceptInviteFromFBId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[[iToast makeText:getRespone.message]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
        });
    }
    if (alertOutRoom){
        alertOutRoom = NO;
        if (ringBufferAudioLive)
            ringBufferAudioLive->empty();
            //  self.liveroom.noOnlineMembers --;
        [self.roomShowTimeView removeFromSuperview];
        
        [self sendSTOPSENDStream];
        [self removeHandle];
        [self.playerLayerView removeFromSuperview];
        [self.playerLayerView.playerLayer setPlayer:nil];
        self.playerLayerView=nil;
        [self.liveAnimation stop];
        self.liveAnimation = nil;
        demConnect = 1;
        [socket disconnect];
        socket.delegate=nil;
        socket = nil;
        [playerVideo pause];
        isReceiveLive = NO;
        isStartingLive = NO;
        [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
            // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
        [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
        [audioEngine3 stopP];
        audioEngine3.sendLive = NO;
            //[audioEngine3 destroy];
        audioEngine3 = nil;
        if (doNothingStreamTimer) {
            [doNothingStreamTimer invalidate];
            doNothingStreamTimer=nil;
        }
        if (changeBGtimer) {
            [changeBGtimer invalidate];
            changeBGtimer=nil;
        }
        if (timerPlayer) {
            [timerPlayer invalidate];
            timerPlayer= nil;
        }
        userShowTime = nil;
        [playerNode stop];
       // playerNode = nil;
        AVAudioSession *session = [ AVAudioSession sharedInstance ];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"outLiveRoom"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"loadStreamLive"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"homePressLive"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"homeComebackLive"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"startAudiEngine"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"stopLive"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
      
        isInLiveView = NO;
        self.functions = nil;
        [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
      
        ///[self.navigationController popViewControllerAnimated:YES];
    }else
	 if (alertAddMicMCShow) {
		  alertAddMicMCShow = NO;
		  [self addMC];
	 }else
	 if (alertRemoveMicMCShow) {
		  alertRemoveMicMCShow = NO;
		  [self removeMC];
	 }else
	 if (alertStopLiveShow) {
		  alertStopLiveShow = NO;
         endSong = NO;
		  [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
	 }else
	 if (alertEndLiveShow) {
		  alertEndLiveShow=NO;
         endSong = NO;
         isReceiveLive = NO;
         isSEND = NO;
         isStartingLive = NO;
         if (ringBufferAudioLive)
             ringBufferAudioLive->empty();
         [self removeHandle];
         if (threadEncodeAudio) {
             [ threadEncodeAudio cancel];
         }
         NSLog(@"stop live");
         [audioEngine3 pause];
         [playerVideo pause];
         [playerNode pause];
         [engine stop];
        
         [self sendSTOPSENDStream];
        
         [socket disconnect];
         socket.delegate=nil;
         dispatch_async(dispatch_get_main_queue(), ^{
          
             self.isLoading.hidden = YES;
         });
        
         
         
         if (isVoice && audioEngine3) {
             [audioEngine3 playthroughSwitchChanged:NO];
             
             [audioEngine3 reverbSwitchChanged:NO];
         }
         audioEngine3.sendLive = NO;
         [audioEngine3 removeOutPutReceive];
         [audioEngine3 stopP];
         tell = 0;
         
       
        
        
         
         dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
         
         dispatch_async(queue, ^{
        
                 if (userShowTime) {
                     
                     Song *newSong = [Song new];
                     newSong.songName = userShowTime.songName;
                     newSong.firebaseId = userShowTime.firebaseId;
                     newSong._id = userShowTime._id;
                     newSong.videoId = userShowTime.videoId;
                     
                     
                     newSong.owner = userShowTime.owner;
                     newSong.status = 5;
                     
                     DoneSongRequest *firRequest = [DoneSongRequest new];
                     firRequest.roomId = liveRoomID;
                     firRequest.song = newSong;
                     if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
                         NSLog(@"StopSongFir firebaseId nil");
                     }
                     if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                         NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                         self.functions = [FIRFunctions functions];
                         __block BOOL isLoadFir = NO;
                         __block FirebaseFuntionResponse *getResponse=nil;
                         [[_functions HTTPSCallableWithName:Fir_StopSongPK] callWithObject:@{@"parameters":requestString}
                                                                                completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                             
                             NSString *stringReply = (NSString *)result.data;
                             
                                 //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                                 // Some debug code, etc.
                             NSLog(@"stop song PK %@",stringReply);
                             isLoadFir = YES;
                             
                         }];
                     }else{
                     NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                     self.functions = [FIRFunctions functions];
                     __block BOOL isLoadFir = NO;
                     __block FirebaseFuntionResponse *getResponse=nil;
                     [[_functions HTTPSCallableWithName:Fir_StopSong] callWithObject:@{@"parameters":requestString}
                                                                          completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                         
                         NSString *stringReply = (NSString *)result.data;
                         
                             //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                             // Some debug code, etc.
                         NSLog(@"stop song %@",stringReply);
                         isLoadFir = YES;
                         [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
                     }];
                     }
                     userShowTime = nil;
                 }
         });
         
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
        
             //  self.liveroom.noOnlineMembers --;
        
       
         demConnect = 1;
      
       
         
         [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
             // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
         [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
      
         if (doNothingStreamTimer) {
             [doNothingStreamTimer invalidate];
             doNothingStreamTimer=nil;
         }
         if (changeBGtimer) {
             [changeBGtimer invalidate];
             changeBGtimer=nil;
         }
         if (timerPlayer) {
             [timerPlayer invalidate];
             timerPlayer= nil;
         }
    
        
        
        
   
     
                 
         isInLiveView = NO;
	/// [self.navigationController popViewControllerAnimated:YES];

	 }else if (alertGiaHanShow	){
		  alertGiaHanShow = NO;
		  self.isLoading.hidden = NO;
		  dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		  dispatch_async(queue, ^{

			   RenewLiveRoomResponse * respone = [[LoadData2 alloc ]RenewLiveRoom:self.liveroom._id];

			   dispatch_async(dispatch_get_main_queue(), ^{
					[[[[iToast makeText:respone.message]
					   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
					self.isLoading.hidden = YES;
					if (respone.status.length!=2) {
						 /*[self sendSTOPSENDStream];
						 [self removeHandle];
						 [self.playerLayerView removeFromSuperview];
						 [self.playerLayerView.playerLayer setPlayer:nil];
						 self.playerLayerView=nil;
						 [socket disconnect];
						 socket.delegate=nil;
						 [playerVideo pause];
						 isReceiveLive = NO;
						 isStartingLive = NO;

							  // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
						 [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
						 [audioEngine3 stopP];
						// [audioEngine3 destroy];
						 audioEngine3 = nil;
						 if (doNothingStreamTimer) {
							  [doNothingStreamTimer invalidate];
							  doNothingStreamTimer=nil;
						 }
						 [self.navigationController popViewControllerAnimated:YES];*/


					}else {
                        self.liveroom.expiredDate = respone.expiredDate;
					}

			   });
		  });
	 }
}
- (IBAction)alertViewNoPress:(id)sender {
	 alertGiaHanShow = NO;
	 alertEndLiveShow = NO;
	 alertStopLiveShow = NO;
    alertAddMicMCShow = NO;
    alertRemoveMicMCShow = NO;
     alertOutRoom = NO;
	 self.liveAlertView.hidden = YES;
}
- (IBAction)showLiveVolumeView:(id)sender {
	 echoVolumeLive = [audioEngine3 getEchoVolume];
	 self.volumeEchoLabel.text = [NSString stringWithFormat:@"%.0f",echoVolumeLive];
	 self.liveVolumeMenuView.hidden = NO;
	 [UIView animateWithDuration: 0.3f animations:^{
		  self.liveVolumeMenuSubBottomConstrainst.constant = -50;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){

		  self.liveVolumeMenuView.hidden = NO;
	 }];
}
- (IBAction)resetLiveVolumeView:(id)sender {
	 echoVolumeLive =50;
	 [audioEngine3 setEchoVolume:echoVolumeLive];
	 self.volumeEcho.value = echoVolumeLive;
	 self.volumeEchoLabel.text = [NSString stringWithFormat:@"%.0f",echoVolumeLive];
	 [[NSUserDefaults standardUserDefaults] setFloat:echoVolumeLive forKey:@"echoVolumeLive"];

	 musicVolumeLive = 0.8f;
	 audioEngine3.player.volume = musicVolumeLive;
	  self.volumeMusic.value = musicVolumeLive*100;
	 self.volumeMusicLabel.text = [NSString stringWithFormat:@"%.0f",musicVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:musicVolumeLive forKey:@"musicVolumeLive"];

	 vocalVolumeLive = 0.8f;
	 [audioEngine3 setPlaythroughVolume:vocalVolumeLive];
	 self.volumeVocal.value = vocalVolumeLive*100;
	 self.volumeVocalLabel.text = [NSString stringWithFormat:@"%.0f",vocalVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:vocalVolumeLive forKey:@"vocalVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)hideLiveVolumeMenu:(id)sender {

	 [UIView animateWithDuration: 0.3f animations:^{
		  self.liveVolumeMenuSubBottomConstrainst.constant = -300;

		  [self.view layoutIfNeeded];
	 } completion:^(BOOL finish){
		  self.liveVolumeMenuSubBottomConstrainst.constant = -300;
		  self.liveVolumeMenuView.hidden = YES;
	 }];
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
	 vocalVolumeLive = s.value/100;
	 [audioEngine3 setPlaythroughVolume:vocalVolumeLive];
	 self.volumeVocalLabel.text = [NSString stringWithFormat:@"%.0f",vocalVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:vocalVolumeLive forKey:@"vocalVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
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

	 echoVolumeLive = s.value;
	 [audioEngine3 setEchoVolume:echoVolumeLive];
	 self.volumeEchoLabel.text = [NSString stringWithFormat:@"%.0f",echoVolumeLive];
	 [[NSUserDefaults standardUserDefaults] setFloat:echoVolumeLive forKey:@"echoVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
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

	 musicVolumeLive = s.value/100;
	 audioEngine3.player.volume = musicVolumeLive;
	 self.volumeMusicLabel.text = [NSString stringWithFormat:@"%.0f",musicVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:musicVolumeLive forKey:@"musicVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)changeEchoVolume:(id)sender {
	 echoVolumeLive = self.volumeEcho.value;
	 [audioEngine3 setEchoVolume:echoVolumeLive];
	 self.volumeEchoLabel.text = [NSString stringWithFormat:@"%.0f",echoVolumeLive];
	 [[NSUserDefaults standardUserDefaults] setFloat:echoVolumeLive forKey:@"echoVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)changeMusicVolume:(id)sender {
	 musicVolumeLive = self.volumeMusic.value/100;
	 audioEngine3.player.volume = musicVolumeLive;
	 self.volumeMusicLabel.text = [NSString stringWithFormat:@"%.0f",musicVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:musicVolumeLive forKey:@"musicVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)changeVocalVolume:(id)sender {
	 vocalVolumeLive = self.volumeVocal.value/100;
	 [audioEngine3 setPlaythroughVolume:vocalVolumeLive];
	 self.volumeVocalLabel.text = [NSString stringWithFormat:@"%.0f",vocalVolumeLive*100];
	 [[NSUserDefaults standardUserDefaults] setFloat:vocalVolumeLive forKey:@"vocalVolumeLive"];
	 [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) homeComebackLive {
	  dispatch_async(dispatch_get_main_queue(), ^{
		   if (self.liveAnimation && !self.liveAnimation.isAnimationPlaying){
				self.liveAnimation.loopAnimation = YES;
				[ self.liveAnimation playWithCompletion:^(BOOL animationFinished) {
						  // Do Something
				}];
		   }
	  });
}
- (void) outLiveRoom {

	 if (ringBufferAudioLive)
		  ringBufferAudioLive->empty();
		  //  self.liveroom.noOnlineMembers --;
		   [self.roomShowTimeView removeFromSuperview];

	 [self sendSTOPSENDStream];
	 [self removeHandle];
	 [self.playerLayerView removeFromSuperview];
	 [self.playerLayerView.playerLayer setPlayer:nil];
	 self.playerLayerView=nil;
	 [self.liveAnimation stop];
	 self.liveAnimation = nil;
	 demConnect = 1;
	 [socket disconnect];
	 socket.delegate=nil;
	 socket = nil;
	 [playerVideo pause];
	 isReceiveLive = NO;
	 isStartingLive = NO;
	 [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
		  // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
	 [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
	 [audioEngine3 stopP];
		  //[audioEngine3 destroy];
	 audioEngine3 = nil;
	 if (doNothingStreamTimer) {
		  [doNothingStreamTimer invalidate];
		  doNothingStreamTimer=nil;
	 }
	 if (changeBGtimer) {
		  [changeBGtimer invalidate];
		  changeBGtimer=nil;
	 }
	 if (timerPlayer) {
		  [timerPlayer invalidate];
		  timerPlayer= nil;
	 }
	 userShowTime = nil;
	 [playerNode stop];
	 //playerNode = nil;
	 AVAudioSession *session = [ AVAudioSession sharedInstance ];
	 [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"outLiveRoom"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"loadStreamLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"homePressLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"homeComebackLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"startAudiEngine"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"stopLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:UIKeyboardWillShowNotification
												   object:nil];

	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:UIKeyboardWillHideNotification
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
	
    [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
	 //[self.navigationController popViewControllerAnimated:YES];
	 isInLiveView = NO;
}
- (void) inComingCall{
    if (isStartingLive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
    }
}
- (void) homePressLive{

	 dispatch_async(dispatch_get_main_queue(), ^{
		  if (isStartingLive || isSendingMicMC) {
			    isStartingLive = NO;
              isSendingMicMC = NO;
			   isReceiveLive = NO;
			   if (ringBufferAudioLive)
			   ringBufferAudioLive->empty();
			  // [self sendRECEIVEStream];
			  // [self sendSTOPSENDStream];
			  // [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
			   self.startStreamLoading.hidden = YES;
			   self.liveVolumeMenuView.hidden = YES;
			   self.startLiveView.hidden = YES;
			   self.menuToolBarView.hidden = NO;
			   self.commentTextFieldLeftConstrainst.constant = 0;
			   if (timerPlayer) {
					[timerPlayer invalidate];
					timerPlayer= nil;
			   }
//self.UserSingingInfoView.hidden = YES;
			   self.playerToolbar.hidden = YES;
			   if (self.playerLayerView) {
						 // [self.playerLayerView removeFromSuperview];
					[self.playerLayerView.playerLayer setPlayer:nil];
						 //   self.playerLayerView=nil;
			   }

		  NSLog(@"stop live");
		  [audioEngine3 pause];
		  [playerVideo pause];

		  if (isVoice && audioEngine3) {
			   [audioEngine3 playthroughSwitchChanged:NO];

			   [audioEngine3 reverbSwitchChanged:NO];
              audioEngine3.sendLive = NO;
		  }
		  [audioEngine3 removeOutPutReceive];
		  [audioEngine3 stopP];
		  audioEngine3 =nil;





	 /*[self sendSTOPSENDStream];
		 [self removeHandle];
		  [self->socket disconnect];
		  self->socket.delegate=nil;
		 [playerVideo pause];
		  self->isReceiveLive = NO;
		  self->isStartingLive = NO;
		  if (self.playerLayerView) {
			   [self.playerLayerView removeFromSuperview];
			   [self.playerLayerView.playerLayer setPlayer:nil];
			   self.playerLayerView=nil;
		  }

		 [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
		// [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
		 [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
		  [audioEngine3 stopP];
			 //   audioEngine3 = nil;
		 // [self.roomShowTimeView removeFromSuperview];
			   if (changeBGtimer) {
					[changeBGtimer invalidate];
					changeBGtimer=nil;
			   }*/
			  [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
			     [NSThread detachNewThreadSelector:@selector(removeSongLive) toTarget:self withObject:nil];
			   //[self removeUserOnLine];
			   [self removeHandle];
			   demConnect = 1;
			   [self->socket disconnect];
			   self->socket.delegate=nil;
			   if (changeBGtimer) {
					[changeBGtimer invalidate];
					changeBGtimer=nil;
			   }
			   if (doNothingStreamTimer) {
					[doNothingStreamTimer invalidate];
					doNothingStreamTimer=nil;
			   }
			    // [NSThread detachNewThreadSelector:@selector(loadStream) toTarget:self withObject:nil];
			   AVAudioSession *session = [ AVAudioSession sharedInstance ];
			   [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"outLiveRoom"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"loadStreamLive"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"homePressLive"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"homeComebackLive"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"startAudiEngine"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:@"stopLive"
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:UIKeyboardWillShowNotification
															 object:nil];

			   [[NSNotificationCenter defaultCenter] removeObserver:self
															   name:UIKeyboardWillHideNotification
															 object:nil];
			   [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
			    socket = nil;
			    isInLiveView = NO;
             
              [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];

		  }else
		  if (audioEngine3) {
              [audioEngine3 removeOutPutReceive];
              [audioEngine3 stopP];
              audioEngine3 =nil;
		  }
	 });
}
- (void) changeBGLayer{

		  if (demBglayer<listImage.count) {

					//blurEffectView.hidden=YES;
			   int randomEffect=RAND_FROM_TO(0, 100);
			   if (randomEffect%2==0 ) {
					[self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
                  
					CATransition *transition = [CATransition animation];
					transition.duration = 2.0f;
					transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
					randomEffect=RAND_FROM_TO(0, 100);
					if (randomEffect%5==0) {
						 transition.type = kCATransitionFade;
					}else if (randomEffect%5==1) {
						 transition.type = kCATransitionReveal;
					}else if (randomEffect%5==2) {
						 transition.type = kCATransitionPush;
					}else if (randomEffect%5==3) {
						 transition.type = kCATransitionMoveIn;
					}  else {
						 transition.type = kCATransitionFade;
					}
					randomEffect=RAND_FROM_TO(0, 80);
					if (randomEffect%5==0) {
						 transition.subtype=kCATransitionFromBottom;
					}else if (randomEffect%5==1) {
						 transition.subtype=kCATransitionFromLeft;
					}else if (randomEffect%5==2) {
						 transition.subtype=kCATransitionFromTop;
					}else if (randomEffect%5==3) {
						 transition.subtype=kCATransitionFromRight;
					}
					[self.BeatInfoImageView.layer removeAllAnimations];
					[self.BeatInfoImageView.layer addAnimation:transition forKey:nil];
			   }else {
					randomEffect=RAND_FROM_TO(0, 60);
					if (randomEffect%5==0) {
						 [UIView transitionWithView:self.BeatInfoImageView
										   duration:2.0f
											options:UIViewAnimationOptionTransitionCrossDissolve
										 animations:^{
							  [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
						 } completion:nil];
                       
					}else if (randomEffect%5==1) {
						 [UIView transitionWithView:self.BeatInfoImageView
										   duration:2.0f
											options:UIViewAnimationOptionTransitionCurlUp
										 animations:^{
							  [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
						 } completion:nil];
                       
					}else if (randomEffect%5==2) {
						 [UIView transitionWithView:self.BeatInfoImageView
										   duration:2.0f
											options:UIViewAnimationOptionTransitionCurlDown
										 animations:^{
							  [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:nil options:SDWebImageRetryFailed];
						 } completion:nil];
                       
					}else if (randomEffect%5==3) {
						 [UIView transitionWithView:self.BeatInfoImageView
										   duration:2.0f
											options:UIViewAnimationOptionTransitionFlipFromRight
										 animations:^{
							  [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
						 } completion:nil];
					}else{
						 [UIView transitionWithView:self.BeatInfoImageView
										   duration:2.0f
											options:UIViewAnimationOptionTransitionFlipFromLeft
										 animations:^{
							  [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
						 } completion:nil];
					}
			   }
              [self.beatInfoImageBG sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  options:SDWebImageRetryFailed];
			   UIImageView *imageView=[UIImageView new];
			   if (demBglayer<listImage.count-1) {
					[imageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:demBglayer]] placeholderImage:nil];
			   }

			   demBglayer++;
			   if (demBglayer==listImage.count) {
					demBglayer=0;
			   }
		  }else{
			   demBglayer=0;
		  }


}

#pragma mark PK
- (void) updatePKScore{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [UIView animateWithDuration:1.0f animations:^{
            long percentScore = userPKRedScore.totalScore*(self.pkBattleScoreView.frame.size.width-80)/(userPKRedScore.totalScore+userPKBluedScore.totalScore);
            if (percentScore< 0 ){
                percentScore=0;
                self.pkBattleFireImageConstrainst.constant = percentScore+30;
                self.pkBattleRulerRedWidthContrainst.constant = percentScore+40;
            }else if(userPKRedScore.totalScore==0 && userPKBluedScore.totalScore==0) {
                
                self.pkBattleFireImageConstrainst.constant = self.pkBattleScoreView.frame.size.width/2-10;
                self.pkBattleRulerRedWidthContrainst.constant = self.pkBattleScoreView.frame.size.width/2;
            }else {
                self.pkBattleFireImageConstrainst.constant = percentScore+30;
                self.pkBattleRulerRedWidthContrainst.constant = percentScore+40;
            }
            
            [self.pkBattleView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.pkBattleScoreL.text=[NSString stringWithFormat:@"%ld",userPKRedScore.totalScore ];
            self.pkBattleScoreR.text=[NSString stringWithFormat:@"%ld",userPKBluedScore.totalScore  ];
        }];
        
    });
}
- (IBAction)pkResultHide:(id)sender {
    self.pkResultView.hidden = YES;
    self.pkStartView.hidden = NO;
}
- (IBAction)pkSelectUserViewHide:(id)sender {
   
   
    [UIView animateWithDuration:0.5f animations:^{
      
        self.pkSelectUserViewBottomConstrainst.constant = -300;
        [self.pkSelectUserView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.pkSelectUserView.hidden = YES;
    }];
}
- (IBAction)pkSelectUserViewLeft:(id)sender {
    self.pkSelectUserView.hidden = YES;
    self.pkSelectUserViewBottomConstrainst.constant = -300;
    userPKSelected= userPKRedScore;
    [self.pkGiftUserImage sd_setImageWithURL:[NSURL URLWithString:userPKSelected.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    self.pkGiftUserNameLabel.text = userPKSelected.name;
    self.giftView.hidden=NO;
    self.giftExpView.hidden = YES;
    self.pkGiftSubView.hidden = NO;
    [self.view bringSubviewToFront:self.giftView];
    numberGiftToBuy=1;
    self.giftStoreViewNoItemBuy.text=[NSString stringWithFormat:@"  %d",numberGiftToBuy];
    self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];
    if (allGiftRespone.gifts.count==0){
        [self getAllGifts];
        
    }else{
        selectedGift=[allGiftRespone.gifts objectAtIndex:0];
        self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
    }
    
    [self.giftStoreViewCollectionView reloadData];
    int num=self.giftStoreViewCollectionView.frame.size.width/100;
    self.giftStoreViewPageControl.numberOfPages=ceil(allGiftRespone.gifts.count*1.0f/num/2) ;
}
- (IBAction)pkSelectUserViewRight:(id)sender {
    self.pkSelectUserView.hidden = YES;
    self.pkSelectUserViewBottomConstrainst.constant = -300;
    userPKSelected= userPKBluedScore;
    [self.pkGiftUserImage sd_setImageWithURL:[NSURL URLWithString:userPKSelected.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    self.pkGiftUserNameLabel.text = userPKSelected.name;
    self.giftView.hidden=NO;
    self.giftExpView.hidden = YES;
    self.pkGiftSubView.hidden = NO;
    [self.view bringSubviewToFront:self.giftView];
    numberGiftToBuy=1;
    self.giftStoreViewNoItemBuy.text=[NSString stringWithFormat:@"  %d",numberGiftToBuy];
    self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];
    if (allGiftRespone.gifts.count==0){
        [self getAllGifts];
        
    }else{
        selectedGift=[allGiftRespone.gifts objectAtIndex:0];
        self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
    }
    
    [self.giftStoreViewCollectionView reloadData];
    int num=self.giftStoreViewCollectionView.frame.size.width/100;
    self.giftStoreViewPageControl.numberOfPages=ceil(allGiftRespone.gifts.count*1.0f/num/2) ;
}
- (IBAction)pkGiftMore:(id)sender {
}
- (IBAction)pkGiftUserSelect:(id)sender {
}
- (IBAction)pkStartUserRPress:(id)sender {
}
- (IBAction)pkStartUserLPress:(id)sender {
}
- (IBAction)pkStartButtonPress:(id)sender {
    if (listQueueSingPKTemp.count>1 && ([currentFbUser.roomUserType isEqualToString:@"OWNER"] || [currentFbUser.roomUserType isEqualToString:@"ADMIN"])) {
        [self startPK];
    }
}
- (IBAction)pkResultUserRPress:(id)sender {
}
- (IBAction)pkResultUserLPress:(id)sender {
}
- (IBAction)pkResultFollowUserR:(id)sender {
    if (![userPKBluedScore.friendStatus isEqualToString:@"FRIEND"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            AddFriendResponse*res=   [[LoadData2 alloc ] AddFriend:userPKBluedScore.facebookId];
            userPKBluedScore.friendStatus=res.status;
            if (res.status.length==2){
                User *userF = userPKBluedScore;
                [allFollowingUsers addObject:userF];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([userPKBluedScore.friendStatus isEqualToString:@"FRIEND"]) {
                    [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }else {
                    [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }
            });
        });
    }else{
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            RemoveFriendResponse*res=   [[LoadData2 alloc ] RemoveFriend: userPKBluedScore.facebookId];
            userPKBluedScore.friendStatus=res.status;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([userPKBluedScore.friendStatus isEqualToString:@"FRIEND"]) {
                    [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    
                }else {
                    
                    [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }
            });
        });
    }
}
- (IBAction)pkResultFollowUserL:(id)sender {
    if (![userPKRedScore.friendStatus isEqualToString:@"FRIEND"]) {
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            AddFriendResponse*res=   [[LoadData2 alloc ] AddFriend:userPKRedScore.facebookId];
            userPKRedScore.friendStatus=res.status;
            if (res.status.length==2){
                User *userF = userPKRedScore;
                [allFollowingUsers addObject:userF];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([userPKRedScore.friendStatus isEqualToString:@"FRIEND"]) {
                    [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    
                }else {
                    
                    [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }
            });
        });
    }else{
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            RemoveFriendResponse*res=   [[LoadData2 alloc ] RemoveFriend: userPKRedScore.facebookId];
            userPKRedScore.friendStatus=res.status;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([userPKRedScore.friendStatus isEqualToString:@"FRIEND"]) {
                    [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    
                }else {
                    
                    [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                }
            });
        });
    }
}
CircularQueue *ringBufferData;
#pragma mark Viewdidload
AACEncoder * encoder;
AACDecoder * decoder;
AACDecoder * decoder2;
AVAudioPlayerNode *playerNode;
AVAudioEngine *engine;
SInt64 tell;
SInt64 tellSendAudio;
- (void)updateIcoinLive {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"PL_kara_room",@"description":@"Vào phòng kara"}];
    self.commentTextField.textColor = UIColorFromRGB(0x000000);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMenuUser:)
                                                 name:@"showMenuUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLiveRoomProperty:)
                                                 name:@"updateLiveRoomProperty" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteLiveRoom:)
                                                 name:@"deleteLiveRoom" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMenuUserFamily:)
                                                 name:@"showMenuUserFamily" object:nil];
    if ([Language hasSuffix:@"karaokestar"]){
        self.lbCollor.backgroundColor =
        [UIColor whiteColor];
//        [UIColor [CGColor UIColorFromRGB(0xEE8778) ]];
        self.iconGiftLive.image = [UIImage imageNamed: @"iconScoreGiftKS.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        self.iconClock.image = [UIImage imageNamed:@"iconClockLiveKS.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        self.micMCLabel.text = AMLocalizedString(@"Ghế MC", nil);
        [self.buttonGift setImage:[UIImage imageNamed:@"iconGiftKS.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.buttonShare setImage:[UIImage imageNamed:@"iconShareKS.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.buttonSing setImage:[UIImage imageNamed:@"iconSing.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        self.lbInviteSing.text = AMLocalizedString(@"Chưa có ai hát \nMời chọn bài để hát", nil);
        [self.btSmall setTitle:AMLocalizedString(@"Thu nhỏ", nil) forState:UIControlStateNormal];
        [self.btInforRoom setTitle:AMLocalizedString(@"Thông tin phòng", nil) forState:UIControlStateNormal];
     }
//    else {
//         self.iconGiftLive.image = [UIImage imageNamed:@"ic_Live_ScoreGift.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
//     }
    self.sendLGCollectionView.layer.cornerRadius = 10;
    self.sendLGCollectionView.layer.masksToBounds = YES;
    self.takeLuckyGiftView.layer.cornerRadius = 10;
    self.takeLuckyGiftView.layer.masksToBounds = YES;
    self.takeLuckyFirstView.layer.cornerRadius = 10;
    self.takeLuckyFirstView.layer.masksToBounds = YES;
    self.gaveLGInfoView.layer.cornerRadius = 10;
    self.gaveLGInfoView.layer.masksToBounds = YES;
    self.sendLuckyGiftView.layer.cornerRadius = 10;
    self.sendLuckyGiftView.layer.masksToBounds = YES;
    self.takeLGFirstUser.layer.borderWidth = 2;
    self.takeLGFirstUser.layer.borderColor = [UIColorFromRGB(0xFFF077) CGColor];
    self.takeLGFirstUser.layer.cornerRadius = self.takeLGFirstUser.frame.size.width/2;
    self.takeLGFirstUser.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadVideoLazy:)
                                                 name:@"loadVideoLazy" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inComingCall)
                                                 name:@"inComingCall" object:nil];
    playerVideo=[AVPlayer new];
    //[playerVideo addObserver:self    forKeyPath:@"rate"   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew   context:PlayLiveStreamViewControllerPlayerItemRateObserverContext];
    pkStatus = @"";
    self.beatInfoView.hidden = YES;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.beatInfoImageBG.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.alpha=0.85;
        //[cell.thumnailView insertSubview:blurEffectView belowSubview:cell.likeCmtView];
        // self.playerLayerViewRec.backgroundColor=[UIColor clearColor];
    [self.beatInfoImageBG addSubview:blurEffectView];
    self.beatInfoImageBG.alpha = 0.3;
    self.pkBattleFireImage.animationImages = @[[UIImage imageNamed:@"ic_fire1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],[UIImage imageNamed:@"ic_fire2.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    self.pkBattleFireImage.animationDuration = 0.8f;
    self.pkBattleFireImage.animationRepeatCount = 0;
    [self.pkBattleFireImage startAnimating];
    self.backgroundImage.image = [UIImage imageNamed:@"BACKGROUND1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    CAGradientLayer *gradientRed = [CAGradientLayer layer];
    gradientRed.startPoint = CGPointMake(0, 0.5);
    gradientRed.endPoint = CGPointMake(1, 0.5);
    gradientRed.frame = self.pkStartViewBGLeft.bounds;
    gradientRed.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)UIColorFromRGB(0xEF8181).CGColor];
    
    [self.pkStartViewBGLeft.layer insertSublayer:gradientRed atIndex:0];
    CAGradientLayer *gradientBlue = [CAGradientLayer layer];
    gradientBlue.startPoint = CGPointMake(1, 0.5);
    gradientBlue.endPoint = CGPointMake(0, 0.5);
    gradientBlue.frame = self.pkStartViewBGRight.bounds;
    gradientBlue.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)UIColorFromRGB(0x0C82EE).CGColor];
    
    [self.pkStartViewBGRight.layer insertSublayer:gradientBlue atIndex:0];
    
    
    self.pkSelectUserView.hidden = YES;
    self.pkGiftUserImage.layer.cornerRadius = self.pkGiftUserImage.frame.size.height/2;
    self.pkGiftUserImage.layer.masksToBounds = YES;
    self.pkGiftUserView.layer.cornerRadius = self.pkGiftUserView.frame.size.height/2;
    self.pkGiftUserView.layer.masksToBounds = YES;
    self.pkSelectUserLeftImage.layer.cornerRadius = self.pkSelectUserLeftImage.frame.size.height/2;
    self.pkSelectUserLeftImage.layer.masksToBounds = YES;
    self.pkSelectUserRightImage.layer.cornerRadius = self.pkSelectUserRightImage.frame.size.height/2;
    self.pkSelectUserRightImage.layer.masksToBounds = YES;
    
    self.pkBattleUserLTop1.layer.cornerRadius = self.pkBattleUserLTop1.frame.size.height/2;
    self.pkBattleUserLTop1.layer.masksToBounds = YES;
    self.pkBattleUserLTop2.layer.cornerRadius = self.pkBattleUserLTop2.frame.size.height/2;
    self.pkBattleUserLTop2.layer.masksToBounds = YES;
    self.pkBattleUserLTop3.layer.cornerRadius = self.pkBattleUserLTop3.frame.size.height/2;
    self.pkBattleUserLTop3.layer.masksToBounds = YES;
    self.pkBattleUserRTop1.layer.cornerRadius = self.pkBattleUserRTop1.frame.size.height/2;
    self.pkBattleUserRTop1.layer.masksToBounds = YES;
    self.pkBattleUserRTop2.layer.cornerRadius = self.pkBattleUserRTop1.frame.size.height/2;
    self.pkBattleUserRTop2.layer.masksToBounds = YES;
    self.pkBattleUserRTop3.layer.cornerRadius = self.pkBattleUserRTop1.frame.size.height/2;
    self.pkBattleUserRTop3.layer.masksToBounds = YES;
    
    self.pkStartUserL.layer.cornerRadius = self.pkStartUserL.frame.size.height/2;
    self.pkStartUserL.layer.masksToBounds = YES;
    self.pkStartUserR.layer.cornerRadius = self.pkStartUserR.frame.size.height/2;
    self.pkStartUserR.layer.masksToBounds = YES;
    self.pkBattleUserL.layer.cornerRadius = self.pkBattleUserL.frame.size.height/2;
    self.pkBattleUserL.layer.masksToBounds = YES;
    self.pkBattleUserR.layer.cornerRadius = self.pkBattleUserR.frame.size.height/2;
    self.pkBattleUserR.layer.masksToBounds = YES;
    self.pkResultUserL.layer.cornerRadius = self.pkResultUserL.frame.size.height/2;
    self.pkResultUserL.layer.masksToBounds = YES;
    self.pkResultUserR.layer.cornerRadius = self.pkResultUserR.frame.size.height/2;
    self.pkResultUserR.layer.masksToBounds = YES;
    self.pkBattleUserView.layer.cornerRadius = self.pkBattleUserView.frame.size.height/2;
    self.pkBattleUserView.layer.masksToBounds = YES;
    self.pkBattleScoreView.layer.cornerRadius = self.pkBattleScoreView.frame.size.height/2;
    self.pkBattleScoreView.layer.masksToBounds = YES;
    self.pkResultSubView.layer.cornerRadius = 15;
    self.pkResultSubView.layer.masksToBounds = YES;
    self.pkResultFollowButtonL.layer.cornerRadius = self.pkResultFollowButtonL.frame.size.height/2;
    
    self.pkResultFollowButtonL.layer.borderWidth=1;
    self.pkResultFollowButtonL.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pkResultFollowButtonL.layer.masksToBounds = YES;
    self.pkResultFollowButtonR.layer.cornerRadius = self.pkResultFollowButtonR.frame.size.height/2;
    self.pkResultFollowButtonR.layer.borderWidth=1;
    self.pkResultFollowButtonR.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pkResultFollowButtonR.layer.masksToBounds = YES;
    self.pkBattleUserLeftSingAnimation = [LOTAnimationView animationNamed:@"ringer_ani.json" inBundle:[YokaraSDK resourceBundle]];
    [self.pkBattleView addSubview:self.pkBattleUserLeftSingAnimation];
    self.pkBattleUserRightSingAnimation = [LOTAnimationView animationNamed:@"ringer_ani.json" inBundle:[YokaraSDK resourceBundle]];
    [self.pkBattleView addSubview:self.pkBattleUserRightSingAnimation];
    if ([self.liveroom.type isEqualToString:@"VERSUS"]){
       
        self.pkStartView.hidden = NO;
        //self.beatInfoImageWidthConstrainst.constant = 100;
        //self.beatInfoImageCenterYContrainst.constant = -35;
        self.commentTableViewTopConstrainst.constant = 0;
        self.pkBattleViewBottomConstrainst.constant = 105;
        
        
        isPKRoom = YES;
    }else {
        isPKRoom = NO;
        self.pkStartView.hidden = YES;
    }
    //[self performSelector:@selector(addGradient) withObject:nil afterDelay:0.5];
    if ([self.liveroom.status isKindOfClass:[NSString class]]){
    if ([self.liveroom.status isEqualToString:@"DELETED"]){
        [[[[iToast makeText:@"Phòng live đã bị xóa! Vui lòng liên hệ Admin nếu muốn khôi phục lại phòng"]
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    }
    self.emptyView=[[EmptyListView alloc] init];
    self.emptyView.frame=CGRectMake(0, 0, self.view.frame.size.width, 300);
        //[self.tableView addSubview:self.emptyView ];
    self.emptyView.titleLabel.text=AMLocalizedString(@"Không có dữ liệu!", nil);
    self.emptyView.center = self.view.center;
    [self.topUserSubView insertSubview:self.emptyView belowSubview:self.topUserScrollView];
    self.emptyView.center = self.topUserScrollView.center;
    self.topUserViewBottomContrainst.constant = -self.topUserSubView.frame.size.height;
    self.topUserScrollView.delegate = self;
    self.topUserSubView.layer.cornerRadius = 10;
    self.topUserSubView.layer.masksToBounds = YES;
    self.topUserSegment.backgroundColor = [UIColor whiteColor];
    [self.topUserSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(HeaderColor)} forState:UIControlStateNormal];
    [self.topUserSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
   
    self.topUserSegment.layer.borderColor = [UIColorFromRGB(HeaderColor) CGColor];
    self.topUserSegment.layer.borderWidth = 1;
    self.topUserSegment.layer.masksToBounds = YES;
    self.topUserDayTableView.delegate=self;
    self.topUserDayTableView.dataSource=self;
    [self.topUserDayTableView registerNib:[UINib nibWithNibName:@"UserCell2" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"CellDay"];
    self.topUserWeekTableView.delegate=self;
    self.topUserWeekTableView.dataSource=self;
    [self.topUserWeekTableView registerNib:[UINib nibWithNibName:@"UserCell2" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"CellWeek"];
    self.topUserMonthTabelView.delegate=self;
    self.topUserMonthTabelView.dataSource=self;
    [self.topUserMonthTabelView registerNib:[UINib nibWithNibName:@"UserCell2" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"CellMonth"];
    
    self.takeLGTableView.delegate=self;
    self.takeLGTableView.dataSource=self;
    [self.takeLGTableView registerNib:[UINib nibWithNibName:@"LuckyGiftHistoryTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"CellLGHistory"];
    self.gaveLGInfoTableView.delegate=self;
    self.gaveLGInfoTableView.dataSource=self;
    [self.gaveLGInfoTableView registerNib:[UINib nibWithNibName:@"LuckyGiftHistoryTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"CellLGHistory"];
    ShowComboGift = NO;
	//  socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	 //[self setupAudioConverter];
	// serverLive = @"data3.ikara.co";
	// portLive = 9191;
    self.bottomMenuSubViewContrainst.constant = -150;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deallocLive)
                                                 name:@"deallocLive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateIcoinLive)
                                                 name:@"updateIcoinLive" object:nil];
    self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
    queueGifts = [NSMutableArray new];
    playerSvga = [[SVGAPlayer alloc] initWithFrame:self.view.bounds];
    playerSvga.delegate = self;
    [self.view insertSubview:self.playerSvga aboveSubview:self.statusView3];
    playerSvga.hidden = YES;
    
    
    [SDImageCache.sharedImageCache clearDiskOnCompletion:nil];
    self.animatedWebPImageView = [SDAnimatedImageView new];
    self.animatedWebPImageView.frame = self.view.bounds;
    self.animatedWebPImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animatedWebPImageView.shouldIncrementalLoad = YES;
   [self.view insertSubview:self.animatedWebPImageView aboveSubview:self.statusView3];
    self.animatedWebPImageView.hidden = YES;
   
   
    isRECEIVE = NO;
    isSEND = NO;
    recordingIdLiveDuet = nil;
    self.userSingDuetView.layer.cornerRadius = self.userSingDuetView.frame.size.height/2;
    self.userSingDuetView.layer.masksToBounds = YES;
    self.giftViewInfoImage.layer.cornerRadius = self.giftViewInfoImage.frame.size.width/2;
    self.giftViewInfoImage.layer.masksToBounds = YES;
    self.micMCImage.image = [UIImage imageNamed:@"ic_micMC.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    self.micMCImage.layer.cornerRadius = 18;
    self.micMCImage.layer.masksToBounds = YES;
    self.micMCLabel.font = [UIFont systemFontOfSize:9];
    self.micMCButton.backgroundColor = [UIColor clearColor];
    self.btnMicMCRecord.layer.cornerRadius = 14;
    self.btnMicMCRecord.layer.masksToBounds = YES;
    self.micMCRecordingImage.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"speak_0.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],
                                     [UIImage imageNamed:@"speak_1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],
                                     [UIImage imageNamed:@"speak_2.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],
                                     [UIImage imageNamed:@"speak_3.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],
                                    [UIImage imageNamed:@"speak_4.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil],nil];
    self.micMCRecordingImage.contentMode=UIViewContentModeScaleAspectFit;
    self.micMCRecordingImage.animationDuration = 0.8f;
    self.micMCRecordingImage.animationRepeatCount = 0;
    self.micMCRecordingImage.image=[UIImage imageNamed:@"speak_0.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];\
    self.micMCRecordingImage.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	 self.cmtViewBottomConstrainst.constant = 40;
	 
	 isInLiveView = YES;
	 // [self setupAssynSocket];
	 self.cmtView.hidden = YES;
    self.giftBuyComboTimeProcess = [[CircleProgressBar alloc] initWithFrame:self.giftBuyComboView.bounds];
    self.giftBuyComboTimeProcess.progressBarWidth = 3;
    self.giftBuyComboTimeProcess.startAngle = 270;
    self.giftBuyComboTimeProcess.hintHidden = YES;
    self.giftBuyComboTimeProcess.progressBarProgressColor = [UIColor whiteColor];
    self.giftBuyComboTimeProcess.progressBarTrackColor = [UIColor clearColor];
    self.giftBuyComboTimeProcess.backgroundColor = [UIColor clearColor];
    self.giftBuyComboTimeProcess.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
   //// [self.giftBuyComboView insertSubview:self.giftBuyComboTimeProcess atIndex:1];
    self.circleProgressBar = [[CircleProgressBar alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.startLiveView insertSubview:self.circleProgressBar belowSubview:self.playPauseButton];
    self.startLiveView.backgroundColor = [UIColor clearColor];
    self.circleProgressBar.center = self.playPauseButton.center;
    self.circleProgressBar.progressBarWidth = 3;
    self.circleProgressBar.startAngle = 270;
    self.circleProgressBar.hintHidden = YES;
    self.circleProgressBar.progressBarProgressColor = UIColorFromRGB(HeaderColor);
    self.circleProgressBar.progressBarTrackColor = [UIColor whiteColor];
	 //self.circleProgressBar.layer.cornerRadius = 30;
	 self.circleProgressBar.layer.masksToBounds = YES;
    self.circleProgressBar.backgroundColor = [UIColor clearColor];
	  self.tabBarController.tabBar.hidden = YES;
    if (![self.liveroom.type isEqualToString:@"VERSUS"]){
	 self.liveAnimation = [LOTAnimationView animationNamed:@"musicfly.json" inBundle:[YokaraSDK resourceBundle]];
   /// [self.view insertSubview:self.liveAnimation aboveSubview:self.roomInfoView];
        self.liveAnimation.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        self.liveAnimation.center = self.view.center;
        self.liveAnimation.loopAnimation = YES;
        [ self.liveAnimation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
        }];
    }
 
    self.micMCAnimation = [LOTAnimationView animationNamed:@"micMC.json" inBundle:[YokaraSDK resourceBundle]];
    [self.MicMCView insertSubview:self.micMCAnimation aboveSubview:self.micMCImage];
    self.micMCAnimation.frame =CGRectMake(-20, -20, 76,76);
    //self.micMCAnimation.center = self.micMCImage.center;
    self.micMCAnimation.loopAnimation = YES;
	  self.notifiLabel.text = [NSString stringWithFormat:@"Room ID: %ld",self.liveroom.uid];
	
    self.micMCAnimation.hidden = YES;
	
    [ self.micMCAnimation playWithCompletion:^(BOOL animationFinished) {
            // Do Something
    }];
	 liveRoomID = self.liveroom.roomId;
	 if (doNothingStreamTimer==nil) {
		  doNothingStreamTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doNoThingStream) userInfo:nil repeats:YES];
	 }
	 AVAudioSession *session = [ AVAudioSession sharedInstance ];
	 [[NSNotificationCenter defaultCenter] addObserver: self
											  selector: @selector(checkHeadSet)
												  name: AVAudioSessionRouteChangeNotification
												object: session];
	 [self checkHeadSet];
	 UITapGestureRecognizer *gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedEcho:)];
	 [self.volumeEcho addGestureRecognizer:gr2];
	 UITapGestureRecognizer *gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedMusicVolume:)];
	 [self.volumeMusic addGestureRecognizer:gr3];
	 UITapGestureRecognizer *gr4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTappedVocalVolume:)];
	 [self.volumeVocal addGestureRecognizer:gr4];

	 self.liveVolumeMenuSubBottomConstrainst.constant = -300;
	 vocalVolumeLive = [[NSUserDefaults standardUserDefaults] floatForKey:@"vocalVolumeLive"];
	 musicVolumeLive = [[NSUserDefaults standardUserDefaults] floatForKey:@"musicVolumeLive"];
	 echoVolumeLive = [[NSUserDefaults standardUserDefaults] floatForKey:@"echoVolumeLive"];
	 if (vocalVolumeLive==0 || musicVolumeLive==0 || echoVolumeLive==0) {
		  vocalVolumeLive = 0.8f;
		  musicVolumeLive = 0.8f;
		  echoVolumeLive = 50;
		  [[NSUserDefaults standardUserDefaults] setFloat:vocalVolumeLive forKey:@"vocalVolumeLive"];
		  [[NSUserDefaults standardUserDefaults] setFloat:musicVolumeLive forKey:@"musicVolumeLive"];
		  [[NSUserDefaults standardUserDefaults] setFloat:echoVolumeLive forKey:@"echoVolumeLive"];
		  [[NSUserDefaults standardUserDefaults] synchronize];

	 }

	 self.volumeMusic.value = musicVolumeLive*100;
	 self.volumeVocal.value = vocalVolumeLive*100;
	 self.volumeEcho.value = echoVolumeLive;
	 self.volumeEchoLabel.text = [NSString stringWithFormat:@"%.0f",echoVolumeLive];
	  self.volumeVocalLabel.text = [NSString stringWithFormat:@"%.0f",vocalVolumeLive*100];
	 self.volumeMusicLabel.text = [NSString stringWithFormat:@"%.0f",musicVolumeLive*100];
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


	 decoder = [[AACDecoder alloc] init];
		 [decoder setUp];
	 decoder2 = [[AACDecoder alloc] init];
	 [decoder2 setUp];
	 encoder = [[AACEncoder alloc] init];
	 [encoder initAAC:128000 sampleRate:44100 channels:2];
	  self.statusViewLeftConstrainst.constant = - self.statusView.frame.size.width-20;
    self.statusViewLeftConstrainst2.constant = - self.statusView2.frame.size.width-20;
    self.statusViewLeftConstrainst3.constant = - self.statusView3.frame.size.width-20;
	 engine = [AVAudioEngine new];
	 tell = 0;
	 playerNode = [AVAudioPlayerNode new];
AVAudioFormat * audioFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100 channels:2 interleaved:NO];
	 [engine attachNode:playerNode];
	 AVAudioMixerNode * mixerNode= engine.mainMixerNode;
	 [engine connect:playerNode to:mixerNode format:audioFormat];
    [engine prepare];
	 [engine startAndReturnError:nil];
	
	 noItemGiftList=[NSMutableArray new];
		[noItemGiftList addObjectsFromArray:@[@"1",@"2",@"5",@"10"]];
		sendGiftNoItemView = [[DemoTableController alloc] init];

		sendGiftNoItemView.array=noItemGiftList;
		sendGiftNoItemView.hideIcon=@1;


		sendGiftNoItemView.title=@"";
		sendGiftNoItemView.delegate = self;
		//controllerRecord.view.center=self.view.center;

		//sendGiftNoItemView.view.layer.shadowColor=[[UIColor darkGrayColor] CGColor];
		sendGiftNoItemView.view.layer.masksToBounds=YES;
		sendGiftNoItemView.view.backgroundColor=[UIColor whiteColor];
		[sendGiftNoItemView.view setFrame:CGRectMake(-40, 0, self.giftStoreViewNoItemBuy.frame.size.width, (sendGiftNoItemView.array.count)*50+20)];

		[self.giftStoreViewPageControl  addTarget:self    action:@selector(pageControlChanged:)   forControlEvents:UIControlEventValueChanged ];
    [self.sendLGPageControl  addTarget:self    action:@selector(sendLGpageControlChanged:)   forControlEvents:UIControlEventValueChanged ];

		// Set the number of pages to the number of pages in the paged interface
		// and let the height flex so that it sits nicely in its frame

		self.giftView.hidden=YES;
	  [self.giftStoreViewCollectionView registerNib:[UINib nibWithNibName:@"GiftCollectionViewCell2" bundle:[YokaraSDK resourceBundle]]  forCellWithReuseIdentifier:@"Cell3"];
	 self.giftStoreViewCollectionView.delegate=self;
		self.giftStoreViewCollectionView.dataSource=self;
    self.giftStoreViewCollectionView.allowsSelection = NO;
    [self.sendLGCollectionView registerNib:[UINib nibWithNibName:@"LuckyGiftCollectionViewCell" bundle:[YokaraSDK resourceBundle]]  forCellWithReuseIdentifier:@"CellLG"];
   self.sendLGCollectionView.delegate=self;
      self.sendLGCollectionView.dataSource=self;
    self.sendLGCollectionView.allowsSelection = NO;
		if (allGiftRespone.gifts.count==0){
		[self getAllGifts];
		}else{
			selectedGift=[allGiftRespone.gifts objectAtIndex:0];
            self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
		}
	 currentRoomLive = self.liveroom;
	// [self changeNoticeRoom:@0];

    self.UserSingingInfoView.hidden = YES;
    // Do any additional setup after loading the view.
    self.userNameLabel.text = currentFbUser.name;
    [self.userProfileImage sd_setImageWithURL:[NSURL URLWithString:currentFbUser.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
	 self.passwordSubView.layer.cornerRadius = 15;
	 self.passwordSubView.layer.masksToBounds = YES;

	 [self.cmtViewProfileImage sd_setImageWithURL:[NSURL URLWithString:currentFbUser.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
	 self.cmtViewProfileImage.layer.cornerRadius = self.cmtViewProfileImage.frame.size.height/2;
	 self.cmtViewProfileImage.layer.masksToBounds = YES;

	 self.cmtNotifyView.layer.borderColor = [UIColorFromRGB(HeaderColor) CGColor];
	 self.cmtNotifyView.layer.borderWidth = 1;
	 self.cmtNotifyView.layer.cornerRadius = 5;
	 self.cmtNotifyView.layer.masksToBounds = YES;



	 self.liveAlertNoButton.layer.cornerRadius = 5;
	 self.liveAlertNoButton.layer.masksToBounds = YES;
	 self.liveAlertYesButton.layer.cornerRadius = 5;
	 self.liveAlertYesButton.layer.masksToBounds = YES;
	 self.liveAlertSubView.layer.cornerRadius = 15;
	 self.liveAlertSubView.layer.masksToBounds = YES;

	 self.liveAlertIcon.layer.cornerRadius = self.liveAlertIcon.frame.size.height/2;


	 self.liveAlertIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
	 self.liveAlertIcon.layer.borderWidth = 1;
	 self.liveAlertIcon.layer.masksToBounds = YES;

	 self.playPauseButton.layer.cornerRadius = self.playPauseButton.frame.size.height/2;


	 self.playPauseButton.layer.borderColor = [[UIColor clearColor] CGColor];
	 self.playPauseButton.layer.borderWidth = 2;
	 self.playPauseButton.layer.masksToBounds = YES;

	 /*self.cmtViewSendButton.layer.cornerRadius = self.cmtViewSendButton.frame.size.height/2;


	 self.cmtViewSendButton.layer.borderColor = [UIColorFromRGB(HeaderColor) CGColor];
	 self.cmtViewSendButton.layer.borderWidth = 1;
	 self.cmtViewSendButton.layer.masksToBounds = YES;*/

	 self.roomShowTimeCancelButton.layer.cornerRadius = 5;
		self.roomShowTimeCancelButton.layer.masksToBounds = YES;
		self.roomShowTimeStartButton.layer.cornerRadius = 5;
		   self.roomShowTimeStartButton.layer.masksToBounds = YES;
	 self.BeatInfoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
	 self.BeatInfoImageView.layer.borderWidth = 2;
	 self.BeatInfoImageView.layer.cornerRadius = 5;
	 self.BeatInfoImageView.layer.masksToBounds = YES;
	 self.roomShowTimeSubView.layer.cornerRadius = 10;
		self.roomShowTimeSubView.layer.masksToBounds = YES;
	 self.roomShowTimeIcon.frame = CGRectMake(self.roomShowTimeIcon.frame.origin.x, self.roomShowTimeSubView.frame.origin.y-30, self.roomShowTimeIcon.frame.size.width, self.roomShowTimeIcon.frame.size.height);
		self.roomShowTimeIcon.layer.cornerRadius = self.roomShowTimeIcon.frame.size.height/2;


	 self.roomShowTimeIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
	 self.roomShowTimeIcon.layer.borderWidth = 1;
	  self.roomShowTimeIcon.layer.masksToBounds = YES;
    self.userProfileImage.layer.borderColor = [UIColorFromRGB(0xFFD601) CGColor];
    self.userProfileImage.layer.borderWidth = 1.5;
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height/2;
    self.userProfileImage.layer.masksToBounds = YES;
    self.noUserOnlineView.layer.cornerRadius = self.noUserOnlineView.frame.size.height/2;
       self.noUserOnlineView.layer.masksToBounds = YES;
    self.noBodyImage.layer.cornerRadius = self.noBodyImage.frame.size.height/2;
       self.noBodyImage.layer.masksToBounds = YES;
    self.noBodySing.layer.cornerRadius = self.noBodySing.frame.size.height/2;
       self.noBodySing.layer.masksToBounds = YES;
	 self.giftStoreViewBuyButton.layer.cornerRadius = self.giftStoreViewBuyButton.frame.size.height/2;
		self.giftStoreViewBuyButton.layer.masksToBounds = YES;
	 self.giftBuyView.layer.cornerRadius = self.giftBuyView.frame.size.height/2;
		self.giftBuyView.layer.masksToBounds = YES;
    self.giftBuyView.hidden = YES;
    self.giftViewLevelExpLabel.layer.cornerRadius = self.giftViewLevelExpLabel.frame.size.height/2;
    self.giftViewLevelExpLabel.layer.masksToBounds = YES;
    self.giftExpView.layer.cornerRadius = 10;
    self.giftExpView.layer.masksToBounds = YES;
	 self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height/2;
	 self.closeButton.layer.masksToBounds = YES;
	 self.notifiView.layer.cornerRadius = self.notifiView.frame.size.height/2;
	 self.notifiView.layer.masksToBounds = YES;
	 self.statusSubView1.layer.cornerRadius = self.statusSubView1.frame.size.height/2;
	 self.statusSubView1.layer.masksToBounds = YES;
    self.statusSubView2.layer.cornerRadius = self.statusSubView2.frame.size.height/2;
    self.statusSubView2.layer.masksToBounds = YES;
    self.statusSubView3.layer.cornerRadius = self.statusSubView3.frame.size.height/2;
    self.statusSubView3.layer.masksToBounds = YES;
	 self.UserSingingInfoView.layer.cornerRadius = self.UserSingingInfoView.frame.size.height/2;
	 self.UserSingingInfoView.layer.masksToBounds = YES;
	 self.noBodySing.hidden = NO;
    self.statusUserProfileImage.layer.cornerRadius = self.statusUserProfileImage.frame.size.height/2;
    self.statusUserProfileImage.layer.masksToBounds = YES;
    self.statusUserProfileImage2.layer.cornerRadius = self.statusUserProfileImage.frame.size.height/2;
    self.statusUserProfileImage2.layer.masksToBounds = YES;
    self.statusUserProfileImage3.layer.cornerRadius = self.statusUserProfileImage.frame.size.height/2;
    self.statusUserProfileImage3.layer.masksToBounds = YES;
    self.commentTextFieldToolbar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:AMLocalizedString(@"Nói gì đi nào!", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.giftViewInfo.layer.cornerRadius = self.giftViewInfo.frame.size.height/2;
    self.giftViewInfo.layer.masksToBounds = YES;
	 self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: self.liveroom.totalGiftScore]];

    self.notifiLabel.layer.cornerRadius = self.notifiLabel.frame.size.height/2;
    self.notifiLabel.layer.masksToBounds = YES;

    self.commentTextField.delegate = self;
	  self.commentTextFieldToolbar.delegate = self;
    [self.statusAndCommentTableView registerNib:[UINib nibWithNibName:@"CommentLiveTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"Cell"];

       [self.statusAndCommentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       self.statusAndCommentTableView.delegate=self;
       self.statusAndCommentTableView.dataSource=self;
    
    [self.tagUserTableView registerNib:[UINib nibWithNibName:@"UserOnlineRoomTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"Cell"];
    
    [self.tagUserTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tagUserTableView.delegate=self;
    self.tagUserTableView.dataSource=self;
    
    [self.userOnlineTableView registerNib:[UINib nibWithNibName:@"UserOnlineRoomTableViewCell" bundle:[YokaraSDK resourceBundle]] forCellReuseIdentifier:@"Cell"];

          [self.userOnlineTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
          self.userOnlineTableView.delegate=self;
          self.userOnlineTableView.dataSource=self;

    self.statusAndCommentTableView.backgroundColor = [UIColor clearColor];

    self.userOnlineCollectionView.delegate=self;
       self.userOnlineCollectionView.dataSource=self;

       [self.userOnlineCollectionView registerNib:[UINib nibWithNibName:@"UserOnlineCollectionViewCell"  bundle:[YokaraSDK resourceBundle]]  forCellWithReuseIdentifier:@"Cell4"];

	 if (!ringBufferData) {
		  ringBufferData=[[CircularQueue alloc] initWithCapacity:30];
	 }else {
		  [ringBufferData removeAllObjects];
	 }


	 [[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(outLiveRoom)
												  name:@"outLiveRoom"
												object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(loadStreamLive)
												  name:@"loadStreamLive"
												object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(keyboardWillShow2:)
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
       // register for keyboard notifications
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(keyboardWillHide2:)
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeType:) name:UIKeyboardDidChangeFrameNotification object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePressLive) name:@"homePressLive" object:nil];
	  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeComebackLive) name:@"homeComebackLive" object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(startAudiEngine)
												  name:@"startAudiEngine" object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(stopLive)
												  name:@"stopLive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replyComment:)
                                                 name:@"replyCommentLive" object:nil];
	 UITapGestureRecognizer *gr33 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
		[self.view addGestureRecognizer:gr33];

     [self performSelector:@selector(loadFriendStatus) withObject:nil afterDelay:3];
	 if ([self.liveroom.privacyLevel isEqualToString:@"PRIVATE"] && ![self.liveroom.owner.facebookId isEqualToString:currentFbUser.facebookId]) {
		  self.passwordView.hidden = NO;

		  [self.passLabel1 becomeFirstResponder];
	 }else {
		  self.passwordView.hidden = YES;
		  [self configureDatabase];
			   //[self addUserOnline];
			   // self.prepareRoomLoadingView.hidden = YES;
		  [NSThread detachNewThreadSelector:@selector(addUserOnline) toTarget:self withObject:nil];

	 }
    isReceiveLive = YES;
    threadDecodeAudio = [[NSThread alloc] initWithTarget:self selector:@selector(processDataAudio) object:nil];
    [threadDecodeAudio start];
     //[NSThread detachNewThreadSelector:@selector(processDataAudio) toTarget:self withObject:nil];
}
- (void)dealloc{
   // playerNode = nil;
    //engine = nil;
    isPKRoom = NO;
    playerSvga.delegate= nil;
    sendGiftNoItemView.delegate = nil;
    [threadDecodeAudio cancel];
	 NSLog(@"dealloc LiveView");
	 isInLiveView = NO;
	 demConnect = 1;
	 [socket disconnect];
	 socket.delegate=nil;
	 socket = nil;
	 [self.roomShowTimeView removeFromSuperview];
   // [playerVideo removeObserver:self forKeyPath:@"rate" context:PlayLiveStreamViewControllerPlayerItemRateObserverContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadVideoLazy" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"inComingCall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateIcoinLive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"replyCommentLive"
                                                  object:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    /*if ([string isEqualToString:@"@"]){
        showTagUserView = range.location;
       
    }
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (showTagUserView>0 && text.length>showTagUserView) {
        
        NSString * key = [text substringFromIndex:showTagUserView+1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@",key  ] ;
        tagUserList = [NSMutableArray arrayWithArray:[listUserOnline filteredArrayUsingPredicate:predicate]];
        if (tagUserList.count>5) {
            self.tagUserTableViewHeightConstrainst.constant = 200;
        }else
            self.tagUserTableViewHeightConstrainst.constant = tagUserList.count*40;
        [self.view layoutIfNeeded];
        self.tagUserTableView.hidden = NO;
        [self.tagUserTableView reloadData];
    }else {
        showTagUserView = 0;
    }*/
    return YES;
}
- (void)keyboardChangeType:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];


    //isScrollFromChangeKeyboard=YES;
    // get the size of the keyboard
	 CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	 keyboardHeightG=keyboardSize.height;
		  // UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
		  // NSInteger animationCurveOption = (animationCurve << 16);

	 double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   if (!keyboardIsShown) {
        NSLog(@"keyboard hide");
        dispatch_async( dispatch_get_main_queue(),
                       ^{
  [UIView animateWithDuration:animationDuration animations:^{
            self.cmtViewBottomConstrainst.constant = 40;
			// self.cmtToolbarViewBottomConstraint.constant = 0;

	   [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
	   self.cmtView.hidden = YES;
	   self.cmtToolBarView.hidden = NO;
  }];
                       });

    }else   if (self.passwordView.isHidden){


        dispatch_async( dispatch_get_main_queue(),
                       ^   {
                          [UIView animateWithDuration:animationDuration animations:^{

                                       // self.playerLayerViewParent.hidden=YES;
                                 //self.scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
							//	self.cmtToolbarViewBottomConstraint.constant = keyboardHeightG;
                                       self.cmtViewBottomConstrainst.constant = -keyboardHeightG;
								[self.view layoutIfNeeded];
                                  } completion:^(BOOL finished) {

                                  }];
                       });

    }
}
- (void)keyboardWillHide2:(NSNotification *)n
{

    NSDictionary* userInfo = [n userInfo];

    // get the size of the keyboard
 double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	 dispatch_async( dispatch_get_main_queue(),
					^{
		  
		  [UIView animateWithDuration:animationDuration animations:^{
			   self.cmtViewBottomConstrainst.constant = 40;
					// self.cmtToolbarViewBottomConstraint.constant = 0;

			   [self.view layoutIfNeeded];
		  } completion:^(BOOL finished) {
			   self.cmtView.hidden = YES;
			   self.cmtToolBarView.hidden = NO;
		  }];
	 });


     keyboardIsShown = NO;



}
CGFloat  keyboardHeightG;

- (void)keyboardWillShow2:(NSNotification *)n
{


    NSDictionary* userInfo = [n userInfo];

    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeightG=keyboardSize.height;
	 keyboardIsShown = YES;
	 self.cmtView.hidden = NO;
	 self.cmtToolBarView.hidden = YES;
    if (self.passwordView.isHidden){
	  double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	 dispatch_async( dispatch_get_main_queue(),
					^   {
		  [UIView animateWithDuration:animationDuration animations:^{

					// self.playerLayerViewParent.hidden=YES;
					//self.scrollView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
					//	self.cmtToolbarViewBottomConstraint.constant = keyboardHeightG;
			   self.cmtViewBottomConstrainst.constant = -keyboardHeightG;
			   [self.view layoutIfNeeded];
		  } completion:^(BOOL finished) {

		  }];
	 });
    }
}
- (void) clearAllSongOfUserQueue{
	 FirebaseFuntionResponse * respone = [[LoadData2 alloc ]ClearAllSongOfUserInQueueFir:liveRoomID andUserId:currentFbUser.facebookId];
			if (respone.status.length!=2) {
				dispatch_async(dispatch_get_main_queue(), ^{

						   [[[[iToast makeText:respone.message]
						   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
				});

			}
}
- (void) startPK {
    StartPKRequest *firRequest = [StartPKRequest new];
    firRequest.roomId = liveRoomID;
    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
    self.functions = [FIRFunctions functions];
    
    __block FirebaseFuntionResponse *getResponse=nil;
    
    [[_functions HTTPSCallableWithName:Fir_StartPK] callWithObject:@{@"parameters":requestString}
                                                        completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
        
        NSString *stringReply = (NSString *)result.data;
        NSLog(@"Fir_StartPK %@",stringReply);
        getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
        
        if ([getResponse.message isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[[[iToast makeText:getResponse.message]
                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            });
        }
        
    }];
    
}
- (void) removeSongLive {
	  @autoreleasepool {
		   dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		   dispatch_async(queue, ^{
		   if (userShowTime) {
				
               Song *newSong = [Song new];
               newSong.songName = userShowTime.songName;
               newSong.firebaseId = userShowTime.firebaseId;
               newSong._id = userShowTime._id;
               newSong.videoId = userShowTime.videoId;


               newSong.owner = userShowTime.owner;
               newSong.status = userShowTime.status;
             RemoveSongRequest *firRequest = [RemoveSongRequest new];
              firRequest.roomId = liveRoomID;
              firRequest.song = newSong;
               if (![firRequest.song.firebaseId isKindOfClass:[NSString class]]) {
                    NSLog(@"RemoveSongFir firebaseId nil");
               }else {
                    NSLog(@"RemoveSongFir firebaseId %@",firRequest.song.firebaseId);
               }
               if ([self.liveroom.type isEqualToString:@"VERSUS"]) {
                   NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                   self.functions = [FIRFunctions functions];
                   
                   __block FirebaseFuntionResponse *getResponse=nil;
                   
                   [[_functions HTTPSCallableWithName:Fir_RemoveSongPK] callWithObject:@{@"parameters":requestString}
                                                                          completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                       
                       NSString *stringReply = (NSString *)result.data;
                       NSLog(@"RemoveSongPKFir %@",stringReply);
                       getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                       
                       if ([getResponse.message isKindOfClass:[NSString class]]){
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [[[[iToast makeText:getResponse.message]
                                  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                           });
                       }
                       userShowTime = nil;
                   }];
               }else {
              NSString * requestString = [[firRequest toJSONString] base64EncodedString];
              self.functions = [FIRFunctions functions];
         
              __block FirebaseFuntionResponse *getResponse=nil;

              [[_functions HTTPSCallableWithName:Fir_RemoveSong] callWithObject:@{@"parameters":requestString}
                                                                    completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
               
                  NSString *stringReply = (NSString *)result.data;
                   NSLog(@"RemoveSongFir %@",stringReply);
                  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
               
                   if ([getResponse.message isKindOfClass:[NSString class]]){
                        dispatch_async(dispatch_get_main_queue(), ^{

                             [[[[iToast makeText:getResponse.message]
                                setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                   }
                  userShowTime = nil;
              }];
               }
		   }
		   });
	  }

}
- (void) updateSongLive {
	 @autoreleasepool {
		  dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		  dispatch_async(queue, ^{
		  if (userShowTime) {

			   Song *newSong = [Song new];
			   newSong.songName = userShowTime.songName;
			   newSong.firebaseId = userShowTime.firebaseId;
			   newSong._id = userShowTime._id;
			   newSong.videoId = userShowTime.videoId;

			   newSong.owner = [User new];
			   newSong.owner.facebookId = currentFbUser.facebookId;
			   newSong.owner.profileImageLink = currentFbUser.profileImageLink;
			   newSong.owner.name = currentFbUser.name;
			   newSong.owner.roomUserType = currentFbUser.roomUserType;
			   newSong.owner.uid = currentFbUser.uid;
			   newSong.status = 5;
			   AddSongRequest *firRequest = [AddSongRequest new];
			   firRequest.roomId = liveRoomID;
			   firRequest.song = newSong;
              if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                  self.functions = [FIRFunctions functions];
                  __block BOOL isLoadFir = NO;
                  __block FirebaseFuntionResponse *getResponse=nil;
                  [[_functions HTTPSCallableWithName:Fir_UpdateSongPK] callWithObject:@{@"parameters":requestString}
                                                                         completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                      
                      NSString *stringReply = (NSString *)result.data;
                      
                          //  getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                          // Some debug code, etc.
                      NSLog(@"UpdateSongFir PK %@",stringReply);
                      isLoadFir = YES;
                      
                  }];
              }else{
			   NSString * requestString = [[firRequest toJSONString] base64EncodedString];
			   self.functions = [FIRFunctions functions];
			   __block BOOL isLoadFir = NO;
			   __block FirebaseFuntionResponse *getResponse=nil;
			   [[self.functions HTTPSCallableWithName:Fir_UpdateSong] callWithObject:@{@"parameters":requestString}
																		  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {

					NSString *stringReply = (NSString *)result.data;
					NSLog(@"UpdateSongFir %@",stringReply);
				//	getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
						 // Some debug code, etc.
					isLoadFir = YES;

			   }];
              }
		  }
		  });
	 }

}
- (void) deallocLive {
    NSNotificationCenter *notiCenter =[NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:@"exitLiveRoom" object:self.liveroom];
    if (ringBufferAudioLive)
        ringBufferAudioLive->empty();
        //  self.liveroom.noOnlineMembers --;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.roomShowTimeView removeFromSuperview];
    self.topUserScrollView.delegate = nil;
    [self sendSTOPSENDStream];
    [self removeHandle];
    if (self.playerLayerView){
    [self.playerLayerView removeFromSuperview];
    [self.playerLayerView.playerLayer setPlayer:nil];
    self.playerLayerView=nil;
    }
    if (self.liveAnimation) {
    [self.liveAnimation stop];
    self.liveAnimation = nil;
    }
    demConnect = 1;
    [socket disconnect];
    socket.delegate=nil;
    socket = nil;
    [playerVideo pause];
    isReceiveLive = NO;
    isStartingLive = NO;
    //[NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
        // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
    [audioEngine3 stopP];
    audioEngine3.sendLive = NO;
        //[audioEngine3 destroy];
    audioEngine3 = nil;
    if (doNothingStreamTimer) {
        [doNothingStreamTimer invalidate];
        doNothingStreamTimer=nil;
    }
    if (changeBGtimer) {
        [changeBGtimer invalidate];
        changeBGtimer=nil;
    }
    if (timerPlayer) {
        [timerPlayer invalidate];
        timerPlayer= nil;
    }
    userShowTime = nil;
    [playerNode stop];
   // playerNode = nil;
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateLiveRoomProperty"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"deleteLiveRoom"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"showMenuUser"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"showMenuUserFamily"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"deallocLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"outLiveRoom"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"loadStreamLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"homePressLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"homeComebackLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"startAudiEngine"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"stopLive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
  
    isInLiveView = NO;
    isPKRoom = NO;
    self.functions = nil;
}
- (IBAction)minimizeView:(id)sender {
	 if (isStartingLive ) {
         alertStopLiveShow = YES;
         self.liveAlertHeightConstrainst.constant = 200;
         [self.liveAlertYesButton setTitle:AMLocalizedString(@"Dừng", nil) forState:UIControlStateNormal];
         self.liveAlertTitleLabel.text = AMLocalizedString(@"Thông báo", nil);
         self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn đang trực tiếp! Bạn có muốn dừng trực tiếp?", nil);
         self.liveAlertSubView.hidden = NO;
         self.liveAlertView.hidden = NO;
         /*
		  alertEndLiveShow = YES;
         self.liveAlertHeightConstrainst.constant = 200;
		  [self.liveAlertYesButton setTitle:AMLocalizedString(@"Thoát", nil) forState:UIControlStateNormal];
		  self.liveAlertTitleLabel.text = AMLocalizedString(@"Thông báo", nil);
		  self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn đang trực tiếp! Bạn có muốn thoát phòng?", nil);
		  self.liveAlertView.hidden = NO;*/

	 }else {
         alertOutRoom = YES;
         self.liveAlertHeightConstrainst.constant = 200;
         [self.liveAlertYesButton setTitle:AMLocalizedString(@"Thoát", nil) forState:UIControlStateNormal];
         self.liveAlertTitleLabel.text = AMLocalizedString(@"Thông báo", nil);
         self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn có muốn thoát phòng?", nil);
         self.liveAlertSubView.hidden = NO;
         self.liveAlertView.hidden = NO;
     }
		 
    [self.view bringSubviewToFront:self.liveAlertView];

}
- (IBAction)passwordViewBack:(id)sender {
	 if (doNothingStreamTimer) {
		  [doNothingStreamTimer invalidate];
		  doNothingStreamTimer=nil;
	 }
	 isReceiveLive = NO;
	 isStartingLive = NO;
	 if (audioEngine3) {
		  [audioEngine3 stopP];
		//[audioEngine3 destroy];
		 audioEngine3 = nil;
	 }
	 if (changeBGtimer) {
		  [changeBGtimer invalidate];
		  changeBGtimer=nil;
	 }
	 if (timerPlayer) {
		  [timerPlayer invalidate];
		  timerPlayer= nil;
	 }
	 demConnect = 1;
	 [socket disconnect];
	 socket.delegate=nil;
	 AVAudioSession *session = [ AVAudioSession sharedInstance ];
	 [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"outLiveRoom"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"loadStreamLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"homePressLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"homeComebackLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"startAudiEngine"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:@"stopLive"
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:UIKeyboardWillShowNotification
												   object:nil];

	 [[NSNotificationCenter defaultCenter] removeObserver:self
													 name:UIKeyboardWillHideNotification
												   object:nil];
	 [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
	  socket = nil;
	  isInLiveView = NO;
    [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
	//  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showGiftView:(id)sender {
	NSString* facebookId=[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
	 if (facebookId.length<3 || [currentFbUser.facebookId isKindOfClass:[NSString class]]) {
		 facebookId = currentFbUser.facebookId;
	 }
	 if (facebookId.length>3 && currentFbUser.facebookId.length>3) {
         if ([self.liveroom.type isEqualToString:@"VERSUS"]) {
             if ([pkStatus isEqualToString:ENDPK] || pkStatus.length==0){
                 [[[[iToast makeText:AMLocalizedString(@"Trận đấu chưa bắt đầu", nil)]
                    setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
             }else {
             self.pkSelectUserView.hidden = NO;
             [self.pkSelectUserRightImage sd_setImageWithURL:[NSURL URLWithString:userPKBluedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
             [self.pkSelectUserLeftImage sd_setImageWithURL:[NSURL URLWithString:userPKRedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
             self.pkSelectUserLeftLabel.text = userPKRedScore.name;
             self.pkSelectUserRightLabel.text = userPKBluedScore.name;
             [UIView animateWithDuration:0.5f animations:^{
                 self.pkSelectUserViewBottomConstrainst.constant= 0;
                
                 [self.pkSelectUserView layoutIfNeeded];
                  
             } completion:^(BOOL finished) {
                
             }];
             }
         }else {
         self.giftViewLevelLabel.text = [NSString stringWithFormat:@"  Lv%d  ",[currentFbUser.level integerValue] ];
         NSString *color=[NSString stringWithFormat:@"%@",currentFbUser.levelColor];
         const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
         long x = strtol(cStr+1, NULL, 16);
         if (currentFbUser.levelColor.length>=1) { self.giftViewLevelLabel.backgroundColor=UIColorFromRGB(x);
         }
         self.giftViewLevelLabel.layer.cornerRadius = self.giftViewLevelLabel.frame.size.height/2;
         self.giftViewLevelLabel.layer.masksToBounds = YES;
         
        // long exp=currentFbUser.totalScore ;
        // long totalExp=[[LoadData2 alloc ]getMinScoreFromLevel:[currentFbUser.level intValue] +1];
         self.giftViewLvProcess.progress = (currentFbUser.totalScore -  currentFbUser.minScoreOfCurrentLevel)*1.0f/(currentFbUser.minScoreOfNextLevel - currentFbUser.minScoreOfCurrentLevel);
         self.giftViewLevelLabel.textColor = [UIColor whiteColor];
		 self.giftView.hidden=NO;
		 [self.view bringSubviewToFront:self.giftView];
		 numberGiftToBuy=1;
		 self.giftStoreViewNoItemBuy.text=[NSString stringWithFormat:@"  %d",numberGiftToBuy];
		 self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];
		 if (allGiftRespone.gifts.count==0){
			 [self getAllGifts];

		 }else{
			 selectedGift=[allGiftRespone.gifts objectAtIndex:0];
             if ([selectedGift.type isEqualToString:@"LG"]) {
                 self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"Gửi lì xì cho mọi người trong phòng"];

             }else
             self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
		 }
         
		 [self.giftStoreViewCollectionView reloadData];
         int num=self.giftStoreViewCollectionView.frame.size.width/100;
		 self.giftStoreViewPageControl.numberOfPages=ceil(allGiftRespone.gifts.count*1.0f/num/2) ;
         }
	 }else{

		 [[[[iToast makeText:AMLocalizedString(@"Bạn cần đăng nhập để sử dụng chức năng này", nil)]
			setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        
        
	 }
}
- (IBAction)chooseNumberGiftToBuy:(UIButton *)sender {
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:sendGiftNoItemView];
    popover.tint = FPPopoverWhiteTint;
    popover.keyboardHeight = _keyboardHeight;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (sendGiftNoItemView.array.count)*50+42);
    }
    else {
        popover.contentSize = CGSizeMake(sender.frame.size.width, (sendGiftNoItemView.array.count)*50+42);
    }

    //sender is the UIButton view
    //  popover.arrowDirection = FPPopoverArrowDirectionVertical;
    //  [popover presentPopoverFromView:sender];
    popover.arrowDirection = FPPopoverNoArrow;
    NSLog(@"%f %f",self.view.center.y,self.view.frame.size.height/2);
    [popover presentPopoverFromPoint:CGPointMake(self.giftBuyView.center.x- self.giftBuyView.frame.size.width/4
                                                 , self.view.frame.size.height-2) withView:self.view];
}
-(void)popoverMenu:(DemoTableController *)tableController  selectedTableRow:(NSUInteger)rowNum
{
    if (tableController==sendGiftNoItemView){
        [popover dismissPopoverAnimated:YES];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[sendGiftNoItemView.array objectAtIndex:rowNum]];
        numberGiftToBuy= [myNumber intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.giftStoreViewNoItemBuy.text=[NSString stringWithFormat:@"  %d",numberGiftToBuy];
        });
        return;
    }
}
- (IBAction)hideGiftStoreView:(id)sender {
    self.giftView.hidden=YES;
    sendGiftRequest.comboId = nil;
    timeGiftCombo= 0;
    self.giftBuyComboView.hidden = YES;
    self.giftBuyComboButton.hidden = YES;
    self.giftStoreViewBuyButton.hidden = NO;
}
- (IBAction)showIcoinView:(id)sender {
    NSString* facebookId=[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
    if (facebookId.length<3 || [currentFbUser.facebookId isKindOfClass:[NSString class]]) {
        facebookId=currentFbUser.facebookId;
    }
    if (facebookId.length>3 && currentFbUser.facebookId.length>3) {
        if (!isStartingLive){
            currentFbUser.totalIcoin = [AccountVIPInfo.totalIcoin longValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showWallet" object:currentFbUser];
        if (playerVideo) {
            [playerVideo pause];
        }

        if ([audioPlayRecorder isPlaying]) {
            [audioPlayRecorder pause];
        }
        }
    }else{

        [[[[iToast makeText:AMLocalizedString(@"Bạn cần đăng nhập để sử dụng chức năng này", nil)]
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
      
    }

}
- (void) hideAnimatedWebp {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.animatedWebPImageView.hidden = YES;
    });
}
- (void) hideAnimatedPNG {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.giftAnimationImageView.hidden = YES;
        [self.giftAnimationImageView stopAnimating];
        [[SDImageCache sharedImageCache] clearMemory];
        
    });
    currentStatusAnimate=nil;
}
- (void)hideAnimatedSVga{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.playerSvga stopAnimation];
        [[SDImageCache sharedImageCache] clearMemory];
        self.playerSvga.hidden = YES;
    });
}

long timeGiftCombo;
- (IBAction)buyGiftCombo:(id)sender {
}
- (IBAction)showLevelUser:(id)sender {
    if (!isStartingLive){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showRank" object:currentFbUser];
   
    }
}
SendGiftInLiveRoomRequest *sendGiftRequest;
BOOL ShowComboGift;
- (void) demShowComboGift{
  //  dispatch_async(dispatch_get_main_queue(), ^{
        if (timeGiftCombo>0 && [sendGiftRequest.comboId isKindOfClass:[NSString class]]) {
            ShowComboGift = YES;
            self.giftBuyComboView.hidden = NO;
            self.giftBuyComboButton.hidden = NO;
            self.giftStoreViewBuyButton.hidden = YES;
            NSLog(@"combo time %ld %.0f",timeGiftCombo,CACurrentMediaTime());
            
            timeGiftCombo --;
            [self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f animated:YES duration:1.0f];
            self.giftBuyComboViewWidthConstraint.constant= 70;
            [self.view layoutIfNeeded];
           /* [CATransaction begin]; {
                [CATransaction setAnimationDuration:0.5f];
                [CATransaction setCompletionBlock:^{
                    [CATransaction begin]; {
                        [CATransaction setAnimationDuration:0.5f];
                        [CATransaction setCompletionBlock:^{
                            NSLog(@"combo show %.0f",CACurrentMediaTime());
                            [self performSelectorOnMainThread:@selector(demShowComboGift) withObject:nil waitUntilDone:NO];
                        }];
                        self.giftBuyComboViewWidthConstraint.constant= 70;
                        self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
                            //[self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f+0.1 animated:YES];
                        [self.view layoutIfNeeded];
                    } [CATransaction commit];
                }];
                self.giftBuyComboViewWidthConstraint.constant= 60;
                self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:10];
                    //[self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f animated:YES];
                [self.view layoutIfNeeded];
            } [CATransaction commit];*/
            [UIView animateWithDuration:5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                NSLog(@"combo test %.0f",CACurrentMediaTime());
                self.giftBuyComboViewWidthConstraint.constant= 60;
                self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:10];
                    //[self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f animated:YES];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                NSLog(@"combo test 2 - %.0f",CACurrentMediaTime());
            }];
       [UIView animateWithDuration:1.5f animations:^{
            //dispatch_async(dispatch_get_main_queue(), ^{
            self.giftBuyComboViewWidthConstraint.constant= 60;
            self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:10];
            //[self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f animated:YES];
            [self.view layoutIfNeeded];
            //});
        } completion:^(BOOL finished) {
           // dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.5f animations:^{
                self.giftBuyComboViewWidthConstraint.constant= 70;
                self.giftBuyNoComboLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
                //[self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f+0.1 animated:YES];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                NSLog(@"combo show %.0f",CACurrentMediaTime());
                // [self performSelectorOnMainThread:@selector(demShowComboGift) withObject:nil waitUntilDone:NO];
                [self demShowComboGift];
                /*[UIView animateWithDuration:0.25f animations:^{
                    self.giftBuyComboViewWidthConstraint.constant= 60;
                    self.giftBuyNoComboLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
                    [self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f+0.075 animated:YES];
                    [self.giftView layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.25f animations:^{
                        self.giftBuyNoComboLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                        self.giftBuyComboViewWidthConstraint.constant= 70;
                        [self.giftBuyComboTimeProcess setProgress:1-timeGiftCombo/10.0f+0.1 animated:YES];
                        [self.giftView layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        self.giftBuyComboViewWidthConstraint.constant= 70;
                        
                        [self demShowComboGift];
                    }];
                }];*/
            }];
          
        }];
       
            
           
                // self.giftBuyNoComboLabel.text = [NSString stringWithFormat:@"x%d",sendGiftRequest.noItemSent];
        }else {
            NSLog(@"combo time end %ld %.0f",timeGiftCombo,CACurrentMediaTime());
            timeGiftCombo = 0;
            ShowComboGift = NO;
            sendGiftRequest.comboId = nil;
            self.giftBuyComboView.hidden = YES;
            self.giftBuyComboButton.hidden = YES;
            self.giftStoreViewBuyButton.hidden = NO;
        }
   // });
}
- (IBAction)buyGift:(id)sender {
   //
    NSString* facebookId=[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
    if (facebookId.length<3 || [currentFbUser.facebookId isKindOfClass:[NSString class]]) {
        facebookId=currentFbUser.facebookId;
    }
    if ([selectedGift.type isEqualToString:@"LG"]){
        if (allLuckyGiftRespone.luckyGifts.count==0){
            [[[[iToast makeText:AMLocalizedString(@"Quà lì xì chưa có", nil)]
                        setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else {
        selectedLuckyGift = [allLuckyGiftRespone.luckyGifts objectAtIndex:0];
        self.sendLGPageControl.currentPage = 0;
        self.sendLGPageControl.numberOfPages = [allLuckyGiftRespone.luckyGifts count];
        self.giftView.hidden = YES;
        self.sendLuckyGiftView.hidden = NO;
            [self.sendLGCollectionView setContentOffset:CGPointMake(0, 0)];
        [self.sendLGCollectionView reloadData];
        }
    }else
	 if (![userSinging.owner.facebookId isKindOfClass:[NSString class]]) {
         self.giftView.hidden=YES;
		  dispatch_async(dispatch_get_main_queue(), ^{

					[[[[iToast makeText:AMLocalizedString(@"Chưa có ai xếp lượt", nil)]
								setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

					//self.giftView.hidden=YES;
						 self.giftStoreViewLoading.hidden=YES;
						 self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];

					 });
	 }else
    if (facebookId.length>3 && currentFbUser.facebookId.length>3) {
        
        if ([selectedGift.type isEqualToString:GIFT_TYPE_ANIMATED] || [selectedGift.type isEqualToString:GIFT_TYPE_STATIC]) {
            self.giftView.hidden=YES;
        }
         //   self.giftStoreViewLoading.hidden=NO;
       
        if ([selectedGift.type isEqualToString:@"COMBO"] ) {
            if ([sendGiftRequest.comboId isKindOfClass:[NSString class]] ) {
                if ([sendGiftRequest.giftId isEqualToString:selectedGift.giftId]) {
                    long totalItem = sendGiftRequest.noItemSent + numberGiftToBuy;
                    sendGiftRequest.noItem = numberGiftToBuy;
                    sendGiftRequest.noItemSent = totalItem;
                    if ((totalItem *[ selectedGift.buyPrice integerValue])>= 100){
                        sendGiftRequest.isFinishCombo = YES;
                        timeGiftCombo = 0;
                    }else {
                        sendGiftRequest.isFinishCombo = NO;
                        timeGiftCombo = 10;
                        if (!ShowComboGift)
                             [self performSelectorOnMainThread:@selector(demShowComboGift) withObject:nil waitUntilDone:NO];
                      //  [self performSelector:@selector(demShowComboGift) withObject:nil ];
                    }
                }else {
                    NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
                    sendGiftRequest = [[SendGiftInLiveRoomRequest alloc] init];
                    sendGiftRequest.userId = [[LoadData2 alloc ] idForDevice];
                    sendGiftRequest.platform=@"IOS";
                    sendGiftRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
                    sendGiftRequest.language=Language;
                    sendGiftRequest.toFacebookId=userSinging.owner.facebookId;
                    sendGiftRequest.liveRoomId=currentRoomLive._id;
                    sendGiftRequest.giftId=selectedGift.giftId;
                    sendGiftRequest.noItem=numberGiftToBuy;
                    sendGiftRequest.comboId = GUID;
                    sendGiftRequest.noItemSent = numberGiftToBuy;
                    if ((numberGiftToBuy *[ selectedGift.buyPrice integerValue])>= 100){
                        sendGiftRequest.isFinishCombo = YES;
                        timeGiftCombo = 0;
                    }else {
                        sendGiftRequest.isFinishCombo = NO;
                        timeGiftCombo = 10;
                        if (!ShowComboGift)
                             [self performSelectorOnMainThread:@selector(demShowComboGift) withObject:nil waitUntilDone:NO];
                      //  [self performSelector:@selector(demShowComboGift) withObject:nil ];
                    }
                }
            }else {
                NSString * GUID = [[NSProcessInfo processInfo] globallyUniqueString];
                sendGiftRequest = [[SendGiftInLiveRoomRequest alloc] init];
                sendGiftRequest.userId = [[LoadData2 alloc ] idForDevice];
                sendGiftRequest.platform=@"IOS";
                sendGiftRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
                sendGiftRequest.language=Language;
                sendGiftRequest.toFacebookId=userSinging.owner.facebookId;
                sendGiftRequest.liveRoomId=currentRoomLive._id;
                sendGiftRequest.giftId=selectedGift.giftId;
                sendGiftRequest.noItem=numberGiftToBuy;
                sendGiftRequest.comboId = GUID;
                sendGiftRequest.noItemSent = numberGiftToBuy;
                if ((numberGiftToBuy *[ selectedGift.buyPrice integerValue])>= 100){
                    sendGiftRequest.isFinishCombo = YES;
                    timeGiftCombo = 0;
                }else {
                    sendGiftRequest.isFinishCombo = NO;
                    timeGiftCombo = 10;
                    if (!ShowComboGift)
                       // [self demShowComboGift];
                        [self performSelectorOnMainThread:@selector(demShowComboGift) withObject:nil waitUntilDone:NO];
                   // [self performSelector:@selector(demShowComboGift) withObject:nil ];
                }
                
            }
        }else {
        sendGiftRequest = [[SendGiftInLiveRoomRequest alloc] init];
        sendGiftRequest.userId = [[LoadData2 alloc ] idForDevice];
        sendGiftRequest.platform=@"IOS";
        sendGiftRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
        sendGiftRequest.language=Language;
        sendGiftRequest.toFacebookId=userSinging.owner.facebookId;
        sendGiftRequest.liveRoomId=currentRoomLive._id;
        sendGiftRequest.giftId=selectedGift.giftId;
        sendGiftRequest.noItem=numberGiftToBuy;
        
        sendGiftRequest.noItemSent = numberGiftToBuy;
        }
        long scoreGift = selectedGift.score;
        if ([sendGiftRequest.comboId isKindOfClass:[NSString class]]) {
            self.giftBuyComboView.hidden = NO;
            self.giftBuyComboButton.hidden = NO;
            self.giftStoreViewBuyButton.hidden = YES;
            [self.giftBuyComboTimeProcess setProgress:0 animated:NO];
            int noItemFinish =100/[ selectedGift.buyPrice integerValue];
            self.giftBuyNoComboLabel.text = [NSString stringWithFormat:@"x%d",noItemFinish-sendGiftRequest.noItemSent];
        }
        self.giftStoreViewLoading.hidden=YES;
        if (sendGiftRequest.isFinishCombo) {
            sendGiftRequest.comboId = nil;
            timeGiftCombo= 0;
            self.giftBuyComboView.hidden = YES;
            self.giftBuyComboButton.hidden = YES;
            self.giftStoreViewBuyButton.hidden = NO;
            self.giftView.hidden=YES;
        }
        
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

        dispatch_async(queue, ^{
            [FIRAnalytics logEventWithName:@"SPEND_VIRTUAL_CURRENCY" parameters:@{@"VIRTUAL_CURRENCY_NAME":@"VND",@"ITEM_NAME":@"send_gift_in_liveroom",@"VALUE":[NSNumber numberWithLong:numberGiftToBuy*[selectedGift.buyPrice intValue] ]}];
            SendGiftInLiveRoomResponse * respone;
            if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                sendGiftRequest.toFacebookId = userPKSelected.facebookId;
                respone  = [[LoadData2 alloc ]SendGiftInPKRoom:sendGiftRequest];
            }else
            respone  = [[LoadData2 alloc ]SendGiftInLiveRoom:sendGiftRequest];

            
           
                if (respone.status.length==2) {
                   // long exp=currentFbUser.totalScore ;
                    //long totalExp=[[LoadData2 alloc ]getMinScoreFromLevel:[currentFbUser.level intValue] +1];
                    if (currentFbUser.totalScore+scoreGift>currentFbUser.minScoreOfNextLevel) {
                        [[LoadData2 alloc ] GetMyProfile];
                    }else{
                        currentFbUser.totalScore = currentFbUser.totalScore+scoreGift;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.giftViewLevelLabel.text = [NSString stringWithFormat:@"  Lv%d  ",[currentFbUser.level integerValue] ];
                    
                    
                    self.giftViewLvProcess.progress =( currentFbUser.totalScore- currentFbUser.minScoreOfCurrentLevel)*1.0f/(currentFbUser.minScoreOfNextLevel- currentFbUser.minScoreOfCurrentLevel);
                    });
                }else {
          
                if (respone.message.length>0) {
                    if (respone.status.length!=2) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [[[[iToast makeText:respone.message]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                    }else{
                       // self.giftView.hidden=YES;
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [[[[iToast makeText:AMLocalizedString(@"Đã xảy ra lỗi khi tặng quà", nil)]
                       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                    });
                }
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.giftStoreViewTotalIcoin.text=[NSString stringWithFormat:@"%d",[AccountVIPInfo.totalIcoin integerValue] ];
            

            });
        });
        
    }else{
        [[[[iToast makeText:AMLocalizedString(@"Bạn cần đăng nhập để sử dụng chức năng này", nil)]
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        
    }

}
- (IBAction)hideTopUserView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = -self.topUserSubView.frame.size.height;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topUserView.hidden = YES;
    }];
}
- (void) loadTopUser:(NSNumber *)type{
    switch ([type intValue]) {
        case 0:
        {
        if (!isFinishLoadTopUserDay) {
            isFinishLoadTopUserDay = YES;
            topUserResponeD = [[LoadData2 alloc ] TopUsersInLiveRoom:topUserResponeD.cursor liveRoom:self.liveroom._id andType:0];
            if (listTopUserDay==nil) {
                listTopUserDay = [NSMutableArray new];
            }
            if (topUserResponeD.users.count>0){
                [listTopUserDay addObjectsFromArray:topUserResponeD.users];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.topUserDayTableView reloadData];
            });
            isFinishLoadTopUserDay = NO;
        }
        }
            break;
        case 1:
        {
        if (!isFinishLoadTopUserWeek) {
            isFinishLoadTopUserWeek = YES;
            topUserResponeW = [[LoadData2 alloc ] TopUsersInLiveRoom:topUserResponeW.cursor liveRoom:self.liveroom._id andType:1];
            if (listTopUserWeek==nil) {
                listTopUserWeek = [NSMutableArray new];
            }
            if (topUserResponeW.users.count>0){
                [listTopUserWeek addObjectsFromArray:topUserResponeW.users];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.topUserWeekTableView reloadData];
            });
            isFinishLoadTopUserWeek = NO;
        }
        }
            break;
        case 2:
        {
        if (!isFinishLoadTopUserMonth) {
            isFinishLoadTopUserMonth = YES;
            topUserResponeM = [[LoadData2 alloc ] TopUsersInLiveRoom:topUserResponeM.cursor liveRoom:self.liveroom._id andType:2];
            if (listTopUserMonth==nil) {
                listTopUserMonth = [NSMutableArray new];
            }
            if (topUserResponeM.users.count>0){
                [listTopUserMonth addObjectsFromArray:topUserResponeM.users];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.topUserMonthTabelView reloadData];
            });
            isFinishLoadTopUserMonth = NO;
        }
        }
            break;
        default:
            break;
    }
}
- (IBAction)topUserSegmentChange:(id)sender {
    switch (self.topUserSegment.selectedSegmentIndex) {
        case 0:
        {
        [self.topUserScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.topUserDayTableView reloadData];
        }
            break;
        case 1:
        {
        [self.topUserScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        if (listTopUserWeek.count==0) {
            [NSThread detachNewThreadSelector:@selector(loadTopUser:) toTarget:self withObject:@1];
        }else
        [self.topUserWeekTableView reloadData];
        }
            break;
        case 2:
        {
        [self.topUserScrollView setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:YES];
        if (listTopUserMonth.count==0) {
            [NSThread detachNewThreadSelector:@selector(loadTopUser:) toTarget:self withObject:@2];
        }else
        [self.topUserMonthTabelView reloadData];
        }
            break;
        default:
            break;
    }
}
- (IBAction)shopTopUserView:(id)sender {
    if ([userSinging.owner2.facebookId isKindOfClass:[NSString class]]){
        User *userO = userSinging.owner2;
        userO.roomUserActionType = currentFbUser.roomUserType;
        userO.roomId = liveRoomID;
        if (!isStartingLive){
            /*flutter
            if ([self.liveroom.family isKindOfClass:[Family class]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
            }else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];*/
        }
    }else {
    self.topUserView.hidden = NO;
        if (listTopUserDay.count==0) {
            [NSThread detachNewThreadSelector:@selector(loadTopUser:) toTarget:self withObject:@0];
        }
        if (listTopUserWeek.count==0) {
            [NSThread detachNewThreadSelector:@selector(loadTopUser:) toTarget:self withObject:@1];
        }
        if (listTopUserMonth.count==0) {
            [NSThread detachNewThreadSelector:@selector(loadTopUser:) toTarget:self withObject:@2];
        }
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = 0;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
//    UITouch *touch = [touches anyObject];
//    if(touch.view != self.topUserView&&touch.view !=self.menuView){
//        self.topUserView.hidden = YES;
//        self.menuView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = -self.topUserView.frame.size.height;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topUserView.hidden = YES;
    }];
}
- (IBAction)showMenu:(id)sender {
    self.menuView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomMenuSubViewContrainst.constant = 0;
        [self.menuView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)minimizeLiveView:(id)sender {
    self.menuView.hidden = YES;
    [self deallocLive];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideLiveView" object:nil];
}
- (IBAction)hideMenu:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomMenuSubViewContrainst.constant = -150;
        [self.menuView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.menuView.hidden = YES;
    }];
}
- (IBAction)showRoomInfoView:(id)sender {
    self.menuView.hidden = YES;
    if (!isStartingLive){
        OpenLiveRoomModel * oLv = [OpenLiveRoomModel new];
        oLv.liveRoom = [self.liveroom toJSONString];
        oLv.user = [currentFbUser toJSONString];
        oLv.backgroundId = backgroundId;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLiveRoomInfo" object:oLv];
    }
}
- (IBAction)shareMenu:(id)sender {
	// [[NSNotificationCenter defaultCenter] postNotificationName:@"shareFacebook" object:self.liveroom.onlineLiveRoomUrl];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"shareMore" object:self.liveroom.onlineLiveRoomUrl];
    NSString *urlString=self.liveroom.onlineLiveRoomUrl;
    
    NSString *textObject = @"Cùng thưởng thức nhé!";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSArray *activityItems = [NSArray arrayWithObjects:textObject, url,  nil];
    
    //-- initialYokara the activity view controller
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    [self presentViewController:avc animated:YES completion:nil];
	//  [NSThread detachNewThreadSelector:@selector(testDecode) toTarget:self withObject:nil];
}
- (IBAction)selectSong:(id)sender {
    if (!isStartingLive){
        OpenLiveRoomModel * oLv = [OpenLiveRoomModel new];
        oLv.liveRoom = [self.liveroom toJSONString];
        oLv.user = [currentFbUser toJSONString];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xepluot" object:oLv];
       
    }
}
- (IBAction)followUser:(id)sender {
	 if (![userSinging.owner.friendStatus isEqualToString:@"FRIEND"]) {
		  dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
		  dispatch_async(queue, ^{
			   AddFriendResponse*res=   [[LoadData2 alloc ] AddFriend:userSinging.owner.facebookId];
			   userSinging.owner.friendStatus=res.status;
              if (res.status.length==2){
                  User *userF = userSinging.owner;
                  [allFollowingUsers addObject:userF];
              }
			   dispatch_async(dispatch_get_main_queue(), ^{
					if ([userSinging.owner.friendStatus isEqualToString:@"FRIEND"]) {
						 [self.followButton setImage:[UIImage imageNamed:@"ic_unfollow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        self.followButton.hidden = YES;
                        self.userInfoNameLabelLeftContrainst.constant = 5;
                    }else {
                        self.userInfoNameLabelLeftContrainst.constant = 30;
                        self.followButton.hidden = NO;
						 [self.followButton setImage:[UIImage imageNamed:@"ic_follow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
					}
			   });
		  });
	 }else{
	 dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
	 dispatch_async(queue, ^{
		  RemoveFriendResponse*res=   [[LoadData2 alloc ] RemoveFriend: userSinging.owner.facebookId];
		  userSinging.owner.friendStatus=res.status;

		  dispatch_async(dispatch_get_main_queue(), ^{
			   if ([userSinging.owner.friendStatus isEqualToString:@"FRIEND"]) {
					[self.followButton setImage:[UIImage imageNamed:@"ic_unfollow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                   self.followButton.hidden = YES;
                   self.userInfoNameLabelLeftContrainst.constant = 5;
               }else {
                   self.userInfoNameLabelLeftContrainst.constant = 30;
                   self.followButton.hidden = NO;
					[self.followButton setImage:[UIImage imageNamed:@"ic_follow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
			   }
		  });
	 });
	 }
}
- (IBAction)showCommentHide:(id)sender {
	 noUpdateComment = 0;
	 self.cmtNotifyView.hidden = YES;
	 NSIndexPath *lastCell = [NSIndexPath indexPathForItem:([self.statusAndCommentTableView numberOfRowsInSection:0] - 1) inSection:0];
	 [self.statusAndCommentTableView scrollToRowAtIndexPath:lastCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
	  [self performSelector:@selector(changeNoticeRoom:) withObject:[NSNumber numberWithBool:changeNotifi] afterDelay:4];

}
- (void)maskUIViewHorizontally:(UIView *)view {
    view.layer.mask = nil;
    CAGradientLayer* _maskLayer = nil;
    
    if (!_maskLayer) {
        _maskLayer = [CAGradientLayer layer];
        
        UIColor *outerColor = [UIColor colorWithWhite:1.0 alpha:0.0]; // transparent
        UIColor *innerColor = [UIColor colorWithWhite:1.0 alpha:1.0]; // opaque
        
        _maskLayer.colors = [NSArray arrayWithObjects:(id)[outerColor CGColor], (id)[innerColor CGColor],
                             (id)[innerColor CGColor], (id)[outerColor CGColor], nil];
        _maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.0125],
                                [NSNumber numberWithFloat:0.9875],
                                [NSNumber numberWithFloat:1.0], nil];
        _maskLayer.startPoint = CGPointMake(0.0, 0.5);
        _maskLayer.endPoint = CGPointMake(1.0, 0.5);
        
        _maskLayer.bounds = view.bounds;
        _maskLayer.anchorPoint = CGPointZero;
        
        view.layer.mask = _maskLayer;
    }
}
- (void) addGradient {
    dispatch_async(dispatch_get_main_queue(), ^{
        /*CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame =  self.statusAndCommentTableView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor ,(id)[UIColor blackColor].CGColor ,(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor, nil];
        gradientLayer.locations = @[@0.0, @0.15, @0.25, @0.75, @0.85, @1.0];
        self.statusAndCommentTableView.tableHeaderView.layer.mask = gradientLayer;*/
       
    CAGradientLayer *gradientRed2 = [CAGradientLayer layer];
    gradientRed2.startPoint = CGPointMake(0, 0.5);
    gradientRed2.endPoint = CGPointMake(1, 0.5);
    gradientRed2.frame = CGRectMake(0, 0, self.pkBattleUserView.frame.size.width/2, self.pkBattleUserView.frame.size.height);
    gradientRed2.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)UIColorFromRGB(0xEF8181).CGColor];
    
    [self.pkBattleUserView.layer insertSublayer:gradientRed2 atIndex:0];
    CAGradientLayer *gradientBlue2 = [CAGradientLayer layer];
    gradientBlue2.startPoint = CGPointMake(1, 0.5);
    gradientBlue2.endPoint = CGPointMake(0, 0.5);
    gradientBlue2.frame = CGRectMake(self.pkBattleUserView.frame.size.width/2, 0, self.pkBattleUserView.frame.size.width/2, self.pkBattleUserView.frame.size.height);
    gradientBlue2.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)UIColorFromRGB(0x0C82EE).CGColor];
    
    [self.pkBattleUserView.layer insertSublayer:gradientBlue2 atIndex:0];
        
        self.pkBattleUserLeftSingAnimation.frame = CGRectMake(self.pkBattleUserView.frame.origin.x+10, self.pkBattleUserView.frame.origin.y-20, 40, 70);
        
      
        self.pkBattleUserRightSingAnimation.frame = CGRectMake(self.pkBattleUserView.frame.origin.x+self.pkBattleUserView.frame.size.width-50, self.pkBattleUserView.frame.origin.y-20, 40, 70);
        self.pkBattleUserLeftSingAnimation.hidden = YES;
        self.pkBattleUserRightSingAnimation.hidden = YES;
        self.pkBattleUserRightSingAnimation.loopAnimation = YES;
        self.pkBattleUserLeftSingAnimation.loopAnimation = YES;
        [ self.pkBattleUserRightSingAnimation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
        }];
        [ self.pkBattleUserLeftSingAnimation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
        }];
    });
}
- (void) viewDidAppear:(BOOL)animated{
    self.animatedWebPImageView.frame = self.view.bounds;
    self.playerSvga.frame = self.view.bounds;
	 if (self.liveAnimation && !self.liveAnimation.isAnimationPlaying){
		  self.liveAnimation.loopAnimation = YES;
		  [ self.liveAnimation playWithCompletion:^(BOOL animationFinished) {
					// Do Something
		  }];
	 }
	 if (userSinging) {
         if ([userSinging.owner.facebookId isEqualToString:currentFbUser.facebookId]) {
             self.followButton.hidden = YES;
         }else 
		  if ([userSinging.owner.friendStatus isEqualToString:@"FRIEND"]) {
			   [self.followButton setImage:[UIImage imageNamed:@"ic_unfollow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
              self.followButton.hidden = YES;
              self.userInfoNameLabelLeftContrainst.constant = 5;
          }else {
              self.userInfoNameLabelLeftContrainst.constant = 30;
              self.followButton.hidden = NO;
			   [self.followButton setImage:[UIImage imageNamed:@"ic_follow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
		  }
	 }
    [self.giftStoreViewCollectionView reloadData];
    [self.sendLGCollectionView reloadData];
}
#pragma mark password
- (IBAction)pass1Change:(id)sender {
	 if (self.passLabel1.text.length==1) {
		  [self.passLabel2 becomeFirstResponder];
	 }

}
- (IBAction)pass2Change:(id)sender {
	 if (self.passLabel2.text.length==1) {
		  [self.passLabel3 becomeFirstResponder];
	 }
}
- (IBAction)pass3Change:(id)sender {
	 if (self.passLabel3.text.length==1) {
		  [self.passLabel4 becomeFirstResponder];
	 }
}
- (IBAction)pass4Change:(id)sender {
	 if (self.passLabel4.text.length==1) {
		  [self.passLabel4 resignFirstResponder];
	 }
	 if (self.passLabel1.text.length==1 && self.passLabel2.text.length==1 && self.passLabel3.text.length==1 && self.passLabel4.text.length==1) {

		  NSString * pass = [NSString stringWithFormat:@"%@%@%@%@",self.passLabel1.text,self.passLabel2.text,self.passLabel3.text,self.passLabel4.text];
		  if ([self.liveroom.password isEqualToString:pass]) {
			   self.passwordView.hidden = YES;
			   [self configureDatabase];
			   //[self addUserOnline];
			     [NSThread detachNewThreadSelector:@selector(addUserOnline) toTarget:self withObject:nil];
		  }else {
			   self.passNoticeLabel.text = AMLocalizedString(@"Mật khẩu không đúng\nVui lòng nhập lại mật khẩu!", nil);
		  }
	 }else {
		  self.passNoticeLabel.text = AMLocalizedString(@"Mật khẩu không đúng\nVui lòng nhập lại mật khẩu!", nil);
	 }

}
- (void)viewDidDisappear:(BOOL)animated {
   // self.navigationController.navigationBarHidden = NO;
    [super viewDidDisappear:animated];

	 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNoticeRoom:) object:[NSNumber numberWithBool:changeNotifi]];
	 if (isStartingLive){

		 // [self.playerLayerView removeFromSuperview];
		  [self.playerLayerView.playerLayer setPlayer:nil];
		 // self.playerLayerView=nil;
	 }
    self.animatedWebPImageView.hidden = YES;
    self.giftAnimationImageView.hidden = YES;
    playerSvga.hidden = YES;
}


- (void) configeDBRecordingStatusStream:(Recording *)recording{
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database

    NSString *url1=[NSString stringWithFormat: @"ikara/recordings/%@/process/",recording._id];
    [[ref child:url1] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSString * status=cmtdict[@"status"];
            NSString* message=cmtdict[@"message"];

            if ([status isEqualToString:@"MIXED"]) {

                NSLog(@"MIXED and out stream");
                [[ref child:url1] removeAllObservers];


                dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
                dispatch_async(queue, ^{

                    dispatch_async(dispatch_get_main_queue(), ^{


                            if (doNothingStreamTimer) {
                                [doNothingStreamTimer invalidate];
                                doNothingStreamTimer=nil;
                            }




                    });
                });


            }
        }else{

        }

    }];

}
- (void)loadStreamLive{

    NSLog(@"load Stream");
	 dispatch_async(dispatch_get_main_queue(), ^{
	 self.prepareRoomLoadingView.hidden = YES;
	 });
	 tell = 0;

	 if (!socket || !streamSVIsConnect) {
		   dispatch_async(dispatch_get_main_queue(), ^{
		   [self setupAssynSocket];
		   });
	 }

	// [self performSelector:@selector(sendRECEIVEStream) withObject:nil afterDelay:1];
	 do {
		  [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	 } while (!streamSVIsConnect  );
	 isReceiveLive = YES;
	 
	 [self sendRECEIVEStream];
	 [self sendSTOPSENDStream];
	  dispatch_async(dispatch_get_main_queue(), ^{


		  self.prepareRoomLoadingView.hidden = YES;
	 });
	 [[AVAudioSession sharedInstance]  setCategory: AVAudioSessionCategoryPlayback  error: nil];
	 NSError *error = nil;
	 if ( ![((AVAudioSession*)[AVAudioSession sharedInstance]) setActive:YES error:&error] ) {
		  NSLog(@"TAAE: Couldn't deactivate audio session: %@", error);
	 }
}
- (void)doNoThingStream{
	 if (isReceiveLive) {
		  [self sendDoNothingStream];
	 }



}

#pragma mark Firebase load
- (void)removeHandle {
    NSString *urlLG=[NSString stringWithFormat: @"livestream/rooms/%@/isLuckyGift",self.liveroom.roomId];
    [[self.ref child:urlLG] removeAllObservers];
    NSString *urlRedScore=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/redScore",self.liveroom._id];
    [[self.ref child:urlRedScore] removeObserverWithHandle:_refHandleQueueSongRS];
    [[self.ref child:urlRedScore] removeAllObservers];
    NSString *urlBlueScore=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/blueScore",self.liveroom._id];
    [[self.ref child:urlBlueScore] removeObserverWithHandle:_refHandleQueueSongBS];
    [[self.ref child:urlBlueScore] removeAllObservers];
    NSString *urlBlue=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/blueTeam",self.liveroom._id];
    [[self.ref child:urlBlue] removeObserverWithHandle:_refHandleQueueSongB];
    [[self.ref child:urlBlue] removeObserverWithHandle:_refHandleQueueSongB2];
    [[self.ref child:urlBlue] removeObserverWithHandle:_refHandleQueueSongB3];
    [[self.ref child:urlBlue] removeAllObservers];
    NSString *urlRed=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/redTeam",self.liveroom._id];
    [[self.ref child:urlRed] removeObserverWithHandle:_refHandleQueueSongR];
    [[self.ref child:urlRed] removeObserverWithHandle:_refHandleQueueSongR2];
    [[self.ref child:urlRed] removeObserverWithHandle:_refHandleQueueSongR3];
    [[self.ref child:urlRed] removeAllObservers];
    NSString *urlPkStatus=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/statusPK",self.liveroom._id];
    [[self.ref child:urlPkStatus] removeObserverWithHandle:_refHandlePKStatus];
    [[self.ref child:urlPkStatus] removeAllObservers];
    NSString *urlQ=[NSString stringWithFormat: @"livestream/roomPKTwoSong/%ld",self.liveroom._id];
    [[self.ref child:urlQ] removeObserverWithHandle:_refHandleQueueSongPK];
    [[self.ref child:urlQ] removeAllObservers];
    NSString *urlQT=[NSString stringWithFormat: @"livestream/roomPKQueueSongTemp/%ld",self.liveroom._id];
    [[self.ref child:urlQT] removeObserverWithHandle:_refHandleQueueSong];
    [[self.ref child:urlQT] removeObserverWithHandle:_refHandleQueueSong2];
    [[self.ref child:urlQT] removeObserverWithHandle:_refHandleQueueSong3];
    [[self.ref child:urlQT] removeAllObservers];
	 NSString *url=[NSString stringWithFormat: @"livestream/roomComments/%ld",self.liveroom._id];
	 [[self.ref child:url] removeObserverWithHandle:_refHandle];
	 [[self.ref child:url] removeAllObservers];
	  NSString *url2=[NSString stringWithFormat: @"livestream/roomStatus/%ld",self.liveroom._id];
	 [[self.ref child:url2] removeObserverWithHandle:_refHandleStatus];
	 [self.ref removeObserverWithHandle:_refHandleComment];
	 [[self.ref child:url2] removeAllObservers];
	 NSString *url3=[NSString stringWithFormat: @"livestream/roomUserOnline/%ld",self.liveroom._id];
	 [[self.ref child:url3] removeObserverWithHandle:_refHandleUserOnline];
	 [[self.ref child:url3] removeAllObservers];
	 NSString *url5=[NSString stringWithFormat: @"livestream/roomUserOnline/%ld",self.liveroom._id];
	  [[self.ref child:url5] removeObserverWithHandle:_refHandleRemoveUserOnline];
	 [[self.ref child:url5] removeAllObservers];
	 NSString *url4=[NSString stringWithFormat: @"livestream/roomShowTime/%ld",self.liveroom._id];
	 [[self.ref child:url4] removeObserverWithHandle:_refHandleShowTime];
	 [[self.ref child:url5] removeAllObservers];
	 NSString *urlImage=[NSString stringWithFormat: @"ikara/users/%@/images/",userSinging.owner.facebookId];
	 [[self.ref child:urlImage] removeAllObservers];
	  NSString *urlQ2=[NSString stringWithFormat: @"livestream/roomQueueSong/%ld",self.liveroom._id];
    NSString *url6=[NSString stringWithFormat: @"livestream/rooms/%@/isMC",self.liveroom.roomId];
    NSString *urlMC=[NSString stringWithFormat: @"livestream/rooms/%@/mcInfo",self.liveroom.roomId];
    [[self.ref child:urlMC] removeAllObservers];
    NSString *urlBackground=[NSString stringWithFormat: @"livestream/rooms/%@/backgroundId",self.liveroom.roomId];
    [[self.ref child:urlBackground] removeAllObservers];
    [[self.ref child:url6] removeObserverWithHandle:_refHandleMicMC];
	  [[self.ref child:urlQ2] removeObserverWithHandle:_refHandleQueueSong];
	   [[self.ref child:urlQ2] removeObserverWithHandle:_refHandleQueueSong2];
	  [[self.ref child:urlQ2] removeObserverWithHandle:_refHandleQueueSong3];
	  [[self.ref child:urlQ2] removeAllObservers];
	 [self.ref removeAllObservers];
}
RoomStatus *currentStatus1;
RoomStatus *currentStatus2;
RoomStatus *currentStatus3;
RoomStatus *currentStatusAnimate;
UIViewPropertyAnimator * animator1;
UIViewPropertyAnimator * animator2;
UIViewPropertyAnimator * animator3;
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimatedSVga];
    });
    currentStatusAnimate=nil;
}
- (void) checkShowGift {
    if (queueGifts.count>0) {
        RoomStatus * currentStatus = [queueGifts objectAtIndex:0];
        if ([currentStatus.giftType isEqualToString:GIFT_TYPE_ANIMATED] || currentStatus.isFinishCombo || currentStatusAnimate) {
            
            if (currentStatusAnimate==nil){
                currentStatusAnimate=currentStatus;
            NSLog(@"Gift animated");
            [queueGifts dequeue];
                 dispatch_async(dispatch_get_main_queue(), ^{
            if ([currentStatus.giftAnimatedUrl hasSuffix:@"svga"]) {
                SVGAParser *parser = [[SVGAParser alloc] init];
                [parser parseWithURL:[NSURL URLWithString:currentStatus.giftAnimatedUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                    if (videoItem != nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            playerSvga.videoItem = videoItem;
                            playerSvga.loops = 1;
                            playerSvga.hidden = NO;
                            [playerSvga startAnimation];
                        });
                        //[self performSelector:@selector(hideAnimatedSVga) withObject:nil afterDelay:10];
                    }else {
                        currentStatusAnimate=nil;
                    }
                } failureBlock:^(NSError * _Nullable error) {
                    currentStatusAnimate=nil;
                } ];
            }else if ([currentStatus.giftAnimatedUrl hasSuffix:@"webp"]) {
                
                NSURL *animatedWebPURL = [NSURL URLWithString:currentStatus.giftAnimatedUrl];
                    //NSURL *animatedWebPURL = [NSURL URLWithString:@"http://littlesvr.ca/apng/images/world-cup-2014-42.webp"];
                
                [self.animatedWebPImageView sd_setImageWithURL:animatedWebPURL placeholderImage:nil options:SDWebImageProgressiveLoad completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        NSLog(@"%@", @"Animated WebP load success");
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //self.animatedWebPImageView.shouldCustomLoopCount = YES;
                            //self.animatedWebPImageView.animationRepeatCount = 1;
                            self.animatedWebPImageView.player.animationLoopHandler = ^(NSUInteger loopCount) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                self.animatedWebPImageView.hidden = YES;
                                    [[SDImageCache sharedImageCache] clearMemory];
                                    currentStatusAnimate=nil;
                                });
                            };
                            self.animatedWebPImageView.hidden = NO;
                            //[self.animatedWebPImageView.player animationLoopHandler]
                            //[self performSelector:@selector(hideAnimatedWebp) withObject:nil afterDelay:10];
                        });
                    }else{
                        currentStatusAnimate=nil;
                    }
                        //self.animatedWebPImageView.hidden = YES;
                }];
            }else {
                NSURL *animatedWebPURL = [NSURL URLWithString:currentStatus.giftAnimatedUrl];
                [self.giftAnimationImageView sd_setImageWithURL:animatedWebPURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        int duration = image.duration;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.giftAnimationImageView.hidden = NO;
                            
                            self.giftAnimationImageView.animationRepeatCount = 1;
                            [self.giftAnimationImageView startAnimating];
                            NSLog(@"giftAnimationImageView %d",duration);
                            [self performSelector:@selector(hideAnimatedPNG) withObject:nil afterDelay:duration];
                        });
                    }else {
                        currentStatusAnimate=nil;
                    }
                }];
            }
            
            
                });
            }else {
                NSLog(@"full queue gift");
                [self performSelector:@selector(checkShowGift) withObject:nil afterDelay:2];
            }
        }else{
            BOOL combo1 = NO;
            BOOL combo2 = NO;
            BOOL combo3 = NO;
            if ([currentStatus.comboId isKindOfClass:[NSString class]] && [currentStatus1.comboId isKindOfClass:[NSString class]]) {
                if ([currentStatus.comboId isEqualToString:currentStatus1.comboId]){
                    combo1 = YES;
                }
            }
            if ([currentStatus.comboId isKindOfClass:[NSString class]] && [currentStatus2.comboId isKindOfClass:[NSString class]]) {
                if ([currentStatus.comboId isEqualToString:currentStatus2.comboId]){
                    combo2 = YES;
                }
            }
            if ([currentStatus.comboId isKindOfClass:[NSString class]] && [currentStatus3.comboId isKindOfClass:[NSString class]]) {
                if ([currentStatus.comboId isEqualToString:currentStatus3.comboId]){
                    combo3 = YES;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.statusView.isHidden || combo1) {
                    
                    currentStatus1= currentStatus;
                    [queueGifts dequeue];
                self.statusView.hidden = NO;
                    // self.statusViewLeftConstrainst.constant = 0;
                [self.statusViewGiftIcon sd_setImageWithURL:[NSURL URLWithString:currentStatus1.giftUrl] placeholderImage:nil  ];
                self.statusNogiftLabel.text = [NSString stringWithFormat:@"x%d",currentStatus1.noItemSent];
                self.statusViewUserNameLabel.text = [NSString stringWithFormat:@"%@",currentStatus1.userName];
                [self.statusUserProfileImage sd_setImageWithURL:[NSURL URLWithString:currentStatus1.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                self.statusViewUserType.hidden = NO;
                self.statusViewUserNameTopConstraint.constant = 10;
                    if ([self.liveroom.family isKindOfClass:[Family class]]){
                        if ([currentStatus1.userType isEqualToString:@"ADMIN"]) {
                            self.statusViewUserType.image = [UIImage imageNamed:@"ic_tocpho.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus1.userType isEqualToString:@"OWNER"]) {
                            self.statusViewUserType.image = [UIImage imageNamed:@"ic_toctruong.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus1.userType isEqualToString:@"VIP"]) {
                            self.statusViewUserType.image = [UIImage imageNamed:@"ic_thanhvien.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else {
                            self.statusViewUserType.hidden = YES;
                            self.statusViewUserNameTopConstraint.constant = 20;
                        }
                    }else
                if ([currentStatus1.userType isEqualToString:@"ADMIN"]) {
                    self.statusViewUserType.image = [UIImage imageNamed:@"icn_admin_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else if ([currentStatus1.userType isEqualToString:@"OWNER"]) {
                    self.statusViewUserType.image = [UIImage imageNamed:@"icn_owner_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else if ([currentStatus1.userType isEqualToString:@"VIP"]) {
                    self.statusViewUserType.image = [UIImage imageNamed:@"icn_vip_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                }else {
                    self.statusViewUserType.hidden = YES;
                    self.statusViewUserNameTopConstraint.constant = 20;
                }
                    //[self.view layoutIfNeeded];
                    self.statusNogiftLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                    if (animator1) {
                        [ animator1 stopAnimation:YES];
                        [animator1 finishAnimationAtPosition:UIViewAnimatingPositionEnd];
                    }
                    
                   animator1 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:0 options:UIViewAnimationCurveLinear animations:^{
                        self.statusViewLeftConstrainst.constant = 15;
                       if (combo1){
                          // self.statusNogiftLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                           NSLog(@"combo1");
                       }
                        [self.statusView layoutIfNeeded];
                    } completion:^(UIViewAnimatingPosition finalPosition) {
                        if (finalPosition == UIViewAnimatingPositionEnd) {
                            if (combo1) {
                                self.statusNogiftLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                    [UIView animateWithDuration:0.8f animations:^{
                                            //self.statusViewLeftConstrainst.constant = 15;
                                        self.statusNogiftLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                                        [self.statusView layoutIfNeeded];
                                        
                                    }completion:^(BOOL finished) {
                                        self.statusNogiftLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                        animator1 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                            self.statusViewLeftConstrainst.constant = - self.statusView.frame.size.width-20;
                                            
                                            [self.statusView layoutIfNeeded];
                                        } completion:^(UIViewAnimatingPosition finalPosition) {
                                            if (finalPosition == UIViewAnimatingPositionEnd) {
                                                self.statusView.hidden = YES;
                                                currentStatus1 = nil;
                                                animator1 = nil;
                                            }
                                        }];
                                        [animator1 startAnimation];
                                    }];
                                
                            }else {
                                animator1 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                    self.statusViewLeftConstrainst.constant = - self.statusView.frame.size.width-20;
                                    
                                    [self.statusView layoutIfNeeded];
                                } completion:^(UIViewAnimatingPosition finalPosition) {
                                    if (finalPosition == UIViewAnimatingPositionEnd) {
                                        self.statusView.hidden = YES;
                                        currentStatus1 = nil;
                                        animator1 = nil;
                                    }
                                }];
                                [animator1 startAnimation];
                            }
                       
                        }
                    }];
                    [animator1 startAnimation];
                    /*
                    if (combo1) {
                        //self.statusViewLeftConstrainst.constant = 15;
                        //[self.view layoutIfNeeded];
                        NSLog(@"combo1");
                        [UIView animateWithDuration:3.0f animations:^{
                                //self.statusViewLeftConstrainst.constant = 15;
                            self.statusNogiftLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                            [self.view layoutIfNeeded];
                            
                        }completion:^(BOOL finished) {
                            self.statusNogiftLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                        }];
                        
                        [UIView setAnimationDuration:0.4];
                        [UIView setAnimationDelegate:self];
                            //position off screen
                        [bucketView setCenter:CGPointMake(-160, 377)];
                        [UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
                            //animate off screen
                        [UIView commitAnimations];
                    }
                [UIView animateWithDuration:3.0f animations:^{
                    self.statusViewLeftConstrainst.constant = 15;
                    [self.view layoutIfNeeded];
                    
                    
                }completion:^(BOOL finished) {
                    double delayShowGift = 1 ;
                    self.statusView.hidden = NO;
                    [UIView animateWithDuration:3.0f delay:delayShowGift options:UIViewAnimationOptionTransitionNone animations:^{
                        self.statusViewLeftConstrainst.constant = - self.statusView.frame.size.width;
                        [self.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        self.statusView.hidden = YES;
                        currentStatus1 = nil;
                    }];
                    
                }];*/
                
                }else  if (self.statusView2.isHidden || combo2) {
                    currentStatus2 = currentStatus;
                    [queueGifts dequeue];
                    self.statusView2.hidden = NO;
                        // self.statusViewLeftConstrainst.constant = 0;
                    [self.statusViewGiftIcon2 sd_setImageWithURL:[NSURL URLWithString:currentStatus2.giftUrl] placeholderImage:nil  ];
                    self.statusNogiftLabel2.text = [NSString stringWithFormat:@"x%d",currentStatus2.noItemSent];
                    self.statusViewUserNameLabel2.text = [NSString stringWithFormat:@"%@",currentStatus2.userName];
                    [self.statusUserProfileImage2 sd_setImageWithURL:[NSURL URLWithString:currentStatus2.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                    self.statusViewUserType2.hidden = NO;
                    self.statusViewUserNameTopConstraint2.constant = 10;
                    if ([self.liveroom.family isKindOfClass:[Family class]]){
                        if ([currentStatus2.userType isEqualToString:@"ADMIN"]) {
                            self.statusViewUserType2.image = [UIImage imageNamed:@"ic_tocpho.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus2.userType isEqualToString:@"OWNER"]) {
                            self.statusViewUserType2.image = [UIImage imageNamed:@"ic_toctruong.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus2.userType isEqualToString:@"VIP"]) {
                            self.statusViewUserType2.image = [UIImage imageNamed:@"ic_thanhvien.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else {
                            self.statusViewUserType2.hidden = YES;
                            self.statusViewUserNameTopConstraint2.constant = 20;
                        }
                    }else
                    if ([currentStatus2.userType isEqualToString:@"ADMIN"]) {
                        self.statusViewUserType2.image = [UIImage imageNamed:@"icn_admin_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    }else if ([currentStatus2.userType isEqualToString:@"OWNER"]) {
                        self.statusViewUserType2.image = [UIImage imageNamed:@"icn_owner_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    }else if ([currentStatus2.userType isEqualToString:@"VIP"]) {
                        self.statusViewUserType2.image = [UIImage imageNamed:@"icn_vip_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    }else {
                        self.statusViewUserType2.hidden = YES;
                        self.statusViewUserNameTopConstraint2.constant = 20;
                    }
                        //[self.view layoutIfNeeded];
                    self.statusNogiftLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                    if (animator2) {
                        [ animator2 stopAnimation:YES];
                        [animator2 finishAnimationAtPosition:UIViewAnimatingPositionEnd];
                    }
                    
                    animator2 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:0 options:UIViewAnimationCurveLinear animations:^{
                        self.statusViewLeftConstrainst2.constant = 15;
                        if (combo2){
                                // self.statusNogiftLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                            NSLog(@"combo2");
                        }
                        [self.statusView2 layoutIfNeeded];
                    } completion:^(UIViewAnimatingPosition finalPosition) {
                        if (finalPosition == UIViewAnimatingPositionEnd) {
                            if (combo2) {
                                self.statusNogiftLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                [UIView animateWithDuration:0.8f animations:^{
                                        //self.statusViewLeftConstrainst.constant = 15;
                                    self.statusNogiftLabel2.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                                    [self.statusView2 layoutIfNeeded];
                                    
                                }completion:^(BOOL finished) {
                                    self.statusNogiftLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                    animator2 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                        self.statusViewLeftConstrainst2.constant = - self.statusView2.frame.size.width-20;
                                        
                                        [self.statusView2 layoutIfNeeded];
                                    } completion:^(UIViewAnimatingPosition finalPosition) {
                                        if (finalPosition == UIViewAnimatingPositionEnd) {
                                            self.statusView2.hidden = YES;
                                            currentStatus2 = nil;
                                            animator2 = nil;
                                        }
                                    }];
                                    [animator2 startAnimation];
                                }];
                                
                            }else {
                                animator2 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                    self.statusViewLeftConstrainst2.constant = - self.statusView2.frame.size.width-20;
                                    
                                    [self.statusView2 layoutIfNeeded];
                                } completion:^(UIViewAnimatingPosition finalPosition) {
                                    if (finalPosition == UIViewAnimatingPositionEnd) {
                                        self.statusView2.hidden = YES;
                                        currentStatus2 = nil;
                                        animator2 = nil;
                                    }
                                }];
                                [animator2 startAnimation];
                            }
                            
                        }
                    }];
                    [animator2 startAnimation];
                    /*
                    [UIView animateWithDuration:3.0f animations:^{
                        self.statusViewLeftConstrainst2.constant = 15;
                        if (combo2){
                            self.statusNogiftLabel2.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                            NSLog(@"combo2");
                        }
                        [self.view layoutIfNeeded];
                        
                        
                    }completion:^(BOOL finished) {
                        if (finished){
                        double delayShowGift = 3 ;
                        self.statusView2.hidden = NO;
                        
                        [UIView animateWithDuration:3.0f delay:delayShowGift options:UIViewAnimationOptionTransitionNone animations:^{
                            self.statusViewLeftConstrainst2.constant = - self.statusView2.frame.size.width;
                            if (combo2){
                                self.statusNogiftLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                            }
                            [self.view layoutIfNeeded];
                        } completion:^(BOOL finished) {
                            if (finished){
                            self.statusView2.hidden = YES;
                            currentStatus2 = nil;
                            }
                        }];
                        }
                        
                    }];*/
                }  else  if (self.statusView3.isHidden || combo3) {
                        currentStatus3= currentStatus;
                    [queueGifts dequeue];
                        self.statusView3.hidden = NO;
                            // self.statusViewLeftConstrainst.constant = 0;
                        [self.statusViewGiftIcon3 sd_setImageWithURL:[NSURL URLWithString:currentStatus3.giftUrl] placeholderImage:nil  ];
                        self.statusNogiftLabel3.text = [NSString stringWithFormat:@"x%d",currentStatus3.noItemSent];
                        self.statusViewUserNameLabel3.text = [NSString stringWithFormat:@"%@",currentStatus3.userName];
                        [self.statusUserProfileImage3 sd_setImageWithURL:[NSURL URLWithString:currentStatus3.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                        self.statusViewUserType3.hidden = NO;
                        self.statusViewUserNameTopConstraint3.constant = 10;
                    if ([self.liveroom.family isKindOfClass:[Family class]]){
                        if ([currentStatus3.userType isEqualToString:@"ADMIN"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"ic_tocpho.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus3.userType isEqualToString:@"OWNER"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"ic_toctruong.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus3.userType isEqualToString:@"VIP"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"ic_thanhvien.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else {
                            self.statusViewUserType3.hidden = YES;
                            self.statusViewUserNameTopConstraint3.constant = 20;
                        }
                    }else
                        if ([currentStatus3.userType isEqualToString:@"ADMIN"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"icn_admin_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus3.userType isEqualToString:@"OWNER"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"icn_owner_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if ([currentStatus3.userType isEqualToString:@"VIP"]) {
                            self.statusViewUserType3.image = [UIImage imageNamed:@"icn_vip_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else {
                            self.statusViewUserType3.hidden = YES;
                            self.statusViewUserNameTopConstraint3.constant = 20;
                        }
                            //[self.view layoutIfNeeded];
                    self.statusNogiftLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                    if (animator3) {
                        [ animator3 stopAnimation:YES];
                        [animator3 finishAnimationAtPosition:UIViewAnimatingPositionEnd];
                    }
                    
                    animator3 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:0 options:UIViewAnimationCurveLinear animations:^{
                        self.statusViewLeftConstrainst3.constant = 15;
                        if (combo3){
                                // self.statusNogiftLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                            NSLog(@"combo3");
                        }
                        [self.statusView3 layoutIfNeeded];
                    } completion:^(UIViewAnimatingPosition finalPosition) {
                        if (finalPosition == UIViewAnimatingPositionEnd) {
                            if (combo3) {
                                self.statusNogiftLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                [UIView animateWithDuration:0.8f animations:^{
                                        //self.statusViewLeftConstrainst.constant = 15;
                                    self.statusNogiftLabel3.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                                    [self.statusView3 layoutIfNeeded];
                                    
                                }completion:^(BOOL finished) {
                                    self.statusNogiftLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                                    animator3 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                        self.statusViewLeftConstrainst3.constant = - self.statusView3.frame.size.width-20;
                                        
                                        [self.statusView3 layoutIfNeeded];
                                    } completion:^(UIViewAnimatingPosition finalPosition) {
                                        if (finalPosition == UIViewAnimatingPositionEnd) {
                                            self.statusView3.hidden = YES;
                                            currentStatus3 = nil;
                                            animator3 = nil;
                                        }
                                    }];
                                    [animator3 startAnimation];
                                }];
                                
                            }else {
                                animator3 = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:3.0f delay:3.0f options:UIViewAnimationCurveLinear animations:^{
                                    self.statusViewLeftConstrainst3.constant = - self.statusView3.frame.size.width-20;
                                    
                                    [self.statusView3 layoutIfNeeded];
                                } completion:^(UIViewAnimatingPosition finalPosition) {
                                    if (finalPosition == UIViewAnimatingPositionEnd) {
                                        self.statusView3.hidden = YES;
                                        currentStatus3 = nil;
                                        animator3 = nil;
                                    }
                                }];
                                [animator3 startAnimation];
                            }
                            
                        }
                    }];
                    [animator3 startAnimation];
                    /*
                    if (combo3) {
                       // self.statusViewLeftConstrainst3.constant = 15;
                        //[self.view layoutIfNeeded];
                        NSLog(@"combo3");
                        [UIView animateWithDuration:3.0f animations:^{
                                //self.statusViewLeftConstrainst.constant = 15;
                            self.statusNogiftLabel3.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                            [self.view layoutIfNeeded];
                            
                        }completion:^(BOOL finished) {
                            self.statusNogiftLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
                        }];
                    }
                        [UIView animateWithDuration:3.0f animations:^{
                            self.statusViewLeftConstrainst3.constant = 15;
                            [self.view layoutIfNeeded];
                            
                            
                        }completion:^(BOOL finished) {
                            double delayShowGift = 3 ;
                            self.statusView3.hidden = NO;
                            [UIView animateWithDuration:3.0f delay:delayShowGift options:UIViewAnimationOptionTransitionNone animations:^{
                                self.statusViewLeftConstrainst3.constant = - self.statusView3.frame.size.width;
                                [self.view layoutIfNeeded];
                            } completion:^(BOOL finished) {
                                self.statusView3.hidden = YES;
                                currentStatus3 = nil;
                            }];
                            
                        }];*/
                }else {
                    NSLog(@"full queue gift");
                    [self performSelector:@selector(checkShowGift) withObject:nil afterDelay:2];
                }
            });
        }
    }
    
}
- (IBAction)hideGaveLGView:(id)sender {
    self.gaveLuckyGiftView.hidden = YES;
}
- (IBAction)hideSendLuckyGiftView:(id)sender {
    self.sendLuckyGiftView.hidden = YES;
}
- (IBAction)sendLuckyGift:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
    SendLuckyGiftRequest * request = [SendLuckyGiftRequest new];
    request.targetId = self.liveroom.liveRoomId;
    request.luckyGiftId = selectedLuckyGift._id;
    request.userId = [[LoadData2 alloc ] idForDevice];
    request.platform=@"IOS";
    request.language=Language;
    request.packageName=[[NSBundle mainBundle] bundleIdentifier];
    SendLuckyGiftResponse *sendLGRespone = [[LoadData2 alloc  ] SendLuckyGift:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[iToast makeText:sendLGRespone.message]
           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        self.sendLuckyGiftView.hidden = YES;
    });
    });
}
- (IBAction)showLuckyGiftGaveHistory:(id)sender {
    
    self.takeLuckyGiftView.hidden = YES;
    self.takeLuckyFirstView.hidden = YES;
    self.gaveLGInfoTableView.hidden = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
    
   allLuckyGiftsGave = [[LoadData2 alloc  ] GetAllLuckyGiftsGave:self.liveroom.liveRoomId];
        
   
        if (allLuckyGiftsGave.luckyGiftsGave.count==0){
            dispatch_async(dispatch_get_main_queue(), ^{
            self.gaveLGInfoStatus.hidden = NO;
            self.gaveLGInfoStatus.text = @"Các quà lì xì trong phòng bạn đã nhận hết!";
            self.gaveLGInfoView.hidden = NO;
            self.gaveLuckyGiftView.hidden = NO;
            });
        }else {
            int row = RAND_FROM_TO(0, allLuckyGiftsGave.luckyGiftsGave.count-1);
            LuckyGiftGave * lgH = [allLuckyGiftsGave.luckyGiftsGave objectAtIndex:row];
           
            luckyGiftGaveUserID = lgH.user.facebookId;
            luckyGiftGaveID = lgH._id;
            luckyGiftHistory = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
            self.gaveLGInfoStatus.hidden = YES;
                self.takeLuckyFirstView.hidden = NO;
                self.gaveLuckyGiftView.hidden = NO;
            self.takeLGFirstTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì", lgH.user.name];
            self.takeLGTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì",  lgH.user.name];
            [self.takeLGFirstUser sd_setImageWithURL:[NSURL URLWithString:lgH.user.profileImageLink] ];
            self.gaveLGInfoView.hidden = YES;
            self.takeLGLoading.hidden = YES;
            self.takeLGFirstEmptyNotice.hidden = YES;
            self.takeLGInfoButton.hidden = YES;
            self.takeLGFirstButton.hidden = NO;
            
            [self.takeLGTableView reloadData];
            });
            if ([currentFbUser.facebookId isEqualToString:luckyGiftGaveUserID]){
                dispatch_async(dispatch_get_main_queue(), ^{
                self.takeLGFirstFollow.hidden = YES;
                self.takeLGUserFollowButton.hidden = YES;
                self.takeLGFirstEmptyNotice.hidden = NO;
                self.takeLGFirstEmptyNotice.text = @"Bạn là người phát Lì xì này!";
                self.takeLGInfoButton.hidden = NO;
                self.takeLGFirstButton.hidden = YES;
                });
            }else {
           
            
                GetUserProfileResponse * userProfile = [[LoadData2 alloc ] GetUserProfile:currentFbUser.facebookId andOwnFacebookId:lgH.user.facebookId];
                if ([userProfile.user.friendStatus isEqualToString:@"FRIEND"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.takeLGFirstFollow.hidden = YES;
                        self.takeLGUserFollowButton.hidden = YES;
                    });
                   
                }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.takeLGFirstFollow.hidden = NO;
                self.takeLGUserFollowButton.hidden = NO;
                
            });
                }
                
            
            }
        
        }
       
        
    });
}
- (IBAction)showLuckyGiftHistory:(id)sender {
    self.takeLuckyFirstView.hidden = YES;
    self.takeLuckyGiftView.hidden = NO;
    /*if (takeLGRespone.status.length==2){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.takeLuckyGiftView.hidden = NO;
            [self.takeLGGiftImage sd_setImageWithURL:[NSURL URLWithString:takeLGRespone.gift.url]];
            self.takeLGNoGift.text = [NSString stringWithFormat:@"x %@",takeLGRespone.gift.noItem];
            self.takeLGEmptyLabel.hidden = YES;
            self.takeLGHadSend.hidden = NO;
            self.takeLGNoGift.hidden = NO;
            self.takeLGGiftImage.hidden = NO;
            
        });
       
    }else {
dispatch_async(dispatch_get_main_queue(), ^{*/
    self.takeLGEmptyLabel.text =@"Bạn là người phát Lì xì này!";
    self.takeLuckyGiftView.hidden = NO;
    self.takeLGEmptyLabel.hidden = NO;
    self.takeLGHadSend.hidden = YES;
    self.takeLGNoGift.hidden = YES;
    self.takeLGGiftImage.hidden = YES;
    
//});
  //  }
    [NSThread detachNewThreadSelector:@selector(loadLuckyGiftHistory) toTarget:self withObject:nil];
}
- (void) loadLuckyGiftHistory {
   luckyGiftHistory = [[LoadData2 alloc ] GetLuckyGiftsHistory:luckyGiftGaveID];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.takeLGStatusLabel.text = luckyGiftHistory.message;
        [self.takeLGTableView reloadData];
    });
}
- (IBAction)followTakeLuckyUser:(id)sender {
    
    dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
    dispatch_async(queue, ^{
         AddFriendResponse*res=   [[LoadData2 alloc ] AddFriend:luckyGiftGaveUserID];
        
        
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([res.status isEqualToString:@"FRIEND"]){
                 self.takeLGFirstFollow.hidden = YES;
                 self.takeLGUserFollowButton.hidden = YES;
                 for (User * userOn in  self->listUserOnline) {
                     if ([userOn.facebookId isEqualToString: luckyGiftGaveUserID]) {
                         userOn.friendStatus = @"FRIEND";
                         
                         break;
                     }
                 }
              }else {
                  
              }
         });
    });
}
- (IBAction)takeLuckyGiftGave:(id)sender {
    UIButton * button = (UIButton *)sender;
    int row = button.tag;
    LuckyGiftGave * lgH = [allLuckyGiftsGave.luckyGiftsGave objectAtIndex:row];
    self.takeLuckyFirstView.hidden = NO;
    luckyGiftGaveUserID = lgH.user.facebookId;
    luckyGiftGaveID = lgH._id;
    self.takeLGFirstTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì", lgH.user.name];
    self.takeLGTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì",  lgH.user.name];
    [self.takeLGFirstUser sd_setImageWithURL:[NSURL URLWithString:lgH.user.profileImageLink] ];
    self.gaveLGInfoView.hidden = YES;
    self.takeLGLoading.hidden = YES;
    self.takeLGFirstEmptyNotice.hidden = YES;
    self.takeLGInfoButton.hidden = YES;
    self.takeLGFirstButton.hidden = NO;
    luckyGiftHistory = nil;
    [self.takeLGTableView reloadData];
    if ([currentFbUser.facebookId isEqualToString:luckyGiftGaveUserID]){
        self.takeLGFirstFollow.hidden = YES;
        self.takeLGUserFollowButton.hidden = YES;
        self.takeLGFirstEmptyNotice.hidden = NO;
        self.takeLGFirstEmptyNotice.text = @"Bạn là người phát Lì xì này!";
        self.takeLGInfoButton.hidden = NO;
        self.takeLGFirstButton.hidden = YES;
    }else {
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
    
        GetUserProfileResponse * userProfile = [[LoadData2 alloc ] GetUserProfile:currentFbUser.facebookId andOwnFacebookId:lgH.user.facebookId];
        if ([userProfile.user.friendStatus isEqualToString:@"FRIEND"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.takeLGFirstFollow.hidden = YES;
                self.takeLGUserFollowButton.hidden = YES;
            });
           
        }else {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.takeLGFirstFollow.hidden = NO;
        self.takeLGUserFollowButton.hidden = NO;
        
    });
        }
        
    });
    }
}
- (IBAction)takeLuckyGift:(id)sender {
    self.takeLuckyFirstView.hidden = YES;
    self.takeLuckyGiftView.hidden = NO;
    luckyGiftHistory = nil;
    self.takeLGEmptyLabel.hidden = YES;
    self.takeLGHadSend.hidden = YES;
    self.takeLGNoGift.hidden = YES;
    self.takeLGGiftImage.hidden = YES;
    self.takeLGStatusLabel.text = @"";
    [self.takeLGTableView reloadData];
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
    
    takeLGRespone = [[LoadData2 alloc  ] TakeLuckyGift:luckyGiftGaveID];
        if (takeLGRespone.status.length==2 && [takeLGRespone.gift.url isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.takeLuckyGiftView.hidden = NO;
                
                [self.takeLGGiftImage sd_setImageWithURL:[NSURL URLWithString:takeLGRespone.gift.url]];
                self.takeLGNoGift.text = [NSString stringWithFormat:@"x %@",takeLGRespone.gift.noItem];
                self.takeLGEmptyLabel.hidden = YES;
                self.takeLGHadSend.hidden = NO;
                self.takeLGNoGift.hidden = NO;
                self.takeLGGiftImage.hidden = NO;
            });
           
        }else {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.takeLGEmptyLabel.text = takeLGRespone.message;
        self.takeLuckyGiftView.hidden = NO;
        self.takeLGEmptyLabel.hidden = NO;
        self.takeLGHadSend.hidden = YES;
        self.takeLGNoGift.hidden = YES;
        self.takeLGGiftImage.hidden = YES;
        
    });
        }
        [self loadLuckyGiftHistory];
    });
   
}

- (void)configureDatabase {
    
    self.ref= [[FIRDatabase database] reference];
    
    listQueueSing = [ NSMutableArray new];
    if (![[FIRAuth auth] currentUser]) {
        
        NSString *firebasetoken=[[NSUserDefaults standardUserDefaults] objectForKey:@"firebaseToken"];
        if (currentFbUser.firebaseToken.length>0) {
            firebasetoken = currentFbUser.firebaseToken;
        }
        if (firebasetoken.length>0) {
            [[FIRAuth auth] signInWithCustomToken:firebasetoken completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                
            }];
        }
    }
    NSString *urlBackground=[NSString stringWithFormat: @"livestream/rooms/%@/backgroundId",self.liveroom.roomId];
    FIRDatabaseQuery *recentPostsQueryBackground = [self.ref child:urlBackground]   ;
    [recentPostsQueryBackground observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.exists) {
            backgroundId = snapshot.value;
            if (backgroundId.length<6) {
                backgroundId = BACKGROUND1;
            }
            NSString *backgroundname =[NSString stringWithFormat:@"%@.png",backgroundId];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundImage.image = [UIImage imageNamed:backgroundname inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            });
                
        }else {
            backgroundId = BACKGROUND1;
            NSString *backgroundname =[NSString stringWithFormat:@"%@.png",backgroundId];
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.backgroundImage.image = [UIImage imageNamed:backgroundname inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                });
                
            
        }
    }];
    NSString *urlLG=[NSString stringWithFormat: @"livestream/rooms/%@/isLuckyGift",self.liveroom.roomId];
    FIRDatabaseQuery *recentPostsQueryLG = [self.ref child:urlLG]   ;
    [recentPostsQueryLG observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSNumber * cmtdict =  snapshot.value;
            if ([cmtdict boolValue]) {
                allLuckyGiftsGave = [[LoadData2 alloc  ] GetAllLuckyGiftsGave:self.liveroom.liveRoomId];
                     
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (allLuckyGiftsGave.luckyGiftsGave.count==0)
                         self.gaveLGInfoStatus.hidden = YES;
                     else
                         self.gaveLGInfoStatus.hidden = NO;
                     [self.gaveLGInfoTableView reloadData];
                     
                 });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.haveLGButton.hidden = NO;
                    });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.haveLGButton.hidden = YES;
                });
            }
        }else {
           
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.haveLGButton.hidden = YES;
            });
        }
    }];
    NSString *urlMC=[NSString stringWithFormat: @"livestream/rooms/%@/mcInfo",self.liveroom.roomId];
    FIRDatabaseQuery *recentPostsQueryMC = [self.ref child:urlMC]   ;
    [recentPostsQueryMC observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            if ([cmtdict isKindOfClass:[NSDictionary class]]) {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                userMC = [[User alloc] initWithString:jsonString error:&error];
                /* userMC =[ User new];
                 userMC.name=cmtdict[@"name"];
                 userMC.profileImageLink=cmtdict[@"profileImageLink"];
                 userMC.roomUserType=cmtdict[@"roomUserType"];
                 userMC.facebookId=cmtdict[@"facebookId"];
                 userMC.uid = [NSNumber numberWithLong: [cmtdict[@"uid"] longValue]] ;*/
                if ([userMC.profileImageLink isKindOfClass:[NSString class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.micMCImage sd_setImageWithURL:[NSURL URLWithString:userMC.profileImageLink] placeholderImage:[UIImage imageNamed:@"ic_micMC.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.micMCLabel.text = [NSString stringWithFormat:@"%@", userMC.name];
                            // self.micMCImage.layer.borderColor=[UIColorFromRGB(HeaderColor) CGColor];
                            // self.micMCImage.layer.borderWidth = 1;
                            //  self.micMCLabel.layer.masksToBounds = YES;
                            //self.micMCLabel.textColor = UIColorFromRGB(HeaderColor);
                            //  self.micMCAnimation.hidden = NO;
                    });
                }
                
                if ([userMC.facebookId isEqualToString:currentFbUser.facebookId]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.btnMicMCRecord.hidden = NO;
                        
                        self.btShareLeftConstrainst.constant = 68;
                        [self.view layoutIfNeeded];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.btnMicMCRecord.hidden = YES;
                        self.btShareLeftConstrainst.constant = 20;
                        [self.view layoutIfNeeded];
                    });
                }
            }
        }else {
            userMC = nil;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btnMicMCRecord.hidden = YES;
                    //self.micMCImage.layer.borderWidth = 0;
                    //self.micMCLabel.layer.masksToBounds = YES;
                self.micMCImage.image = [UIImage imageNamed:@"ic_micMC.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                self.micMCLabel.textColor = [UIColor whiteColor];
                self.btShareLeftConstrainst.constant = 20;
                self.micMCLabel.text = AMLocalizedString(@"Ghế MC", nil);
                    // self.micMCAnimation.hidden = YES;
                [self.view layoutIfNeeded];
            });
        }
    }];
    listQueueSingPKTemp =[ NSMutableArray new];
    listQueueSingPK = [NSMutableArray new];
    if ([self.liveroom.type isEqualToString:@"VERSUS"]){
#pragma mark roomQueueSongPK
        
        NSString *urlPkStatus=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/statusPK",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryPKstatus = [self.ref child:urlPkStatus]  ;
        _refHandlePKStatus = [recentPostsQueryPKstatus observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                pkStatus =(NSString*) snapshot.value;
                if (![pkStatus isKindOfClass:[NSString class]]) {
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.pkStartView.hidden = NO;
                            self.pkResultView.hidden = YES;
                            self.pkBattleView.hidden = YES;
                        });
                    
                }else
                if ([pkStatus isEqualToString:STARTPK] || [pkStatus isEqualToString:REDSTART] || [pkStatus isEqualToString:BLUESTART]){
                    isFirstNotEndPK = YES;
                    if ([pkStatus isEqualToString:STARTPK]) {
                        blueTeam = [NSMutableArray new];
                        redTeam = [NSMutableArray new];
                    }
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.ic_userPKSingingRight.hidden = YES;
                        self.ic_userPKSingingLeft.hidden = YES;
                        self.pkBattleUserLeftSingAnimation.hidden = YES;
                        self.pkBattleUserRightSingAnimation.hidden = YES;
                        [self.pkBattleUserL sd_setImageWithURL:[NSURL URLWithString:userPKRedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        [self.pkBattleUserR sd_setImageWithURL:[NSURL URLWithString:userPKBluedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleUserLTop1.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleUserLTop2.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleUserLTop3.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleUserRTop1.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleUserRTop2.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleUserRTop3.image = [UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        self.pkBattleFrameL1.hidden = YES;
                        self.pkBattleFrameL2.hidden = YES;
                        self.pkBattleFrameL3.hidden = YES;
                        self.pkBattleFrameR1.hidden = YES;
                        self.pkBattleFrameR2.hidden = YES;
                        self.pkBattleFrameR3.hidden = YES;
                        [self updatePKScore];
                        self.pkStartView.hidden = YES;
                        self.pkResultView.hidden = YES;
                        self.pkBattleView.hidden = NO;
                        self.pkBattleUserR.layer.borderWidth = 0;
                       
                        self.pkBattleUserR.layer.masksToBounds = YES;
                        self.pkBattleUserL.layer.borderWidth = 0;
                        
                        self.pkBattleUserL.layer.masksToBounds = YES;
                       
                            self.commentTableViewTopConstrainst.constant = 100;
                    });
                    if ([pkStatus isEqualToString:REDSTART] ){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.ic_userPKSingingLeft.hidden = NO;
                            self.ic_userPKSingingRight.hidden = YES;
                            self.pkBattleUserL.layer.borderWidth = 1;
                            self.pkBattleUserL.layer.borderColor = [UIColorFromRGB(0xFF5E5E) CGColor];
                            self.pkBattleUserL.layer.masksToBounds = YES;
                            self.pkBattleUserLeftSingAnimation.hidden = NO;
                            
                            self.commentTableViewTopConstrainst.constant = 100;
                        });
                    }else
                    if ([pkStatus isEqualToString:BLUESTART] ){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.ic_userPKSingingRight.hidden = NO;
                            self.ic_userPKSingingLeft.hidden = YES;
                            self.pkBattleUserR.layer.borderWidth = 1;
                            self.pkBattleUserR.layer.borderColor = [UIColorFromRGB(0xFF5E5E) CGColor];
                            self.pkBattleUserR.layer.masksToBounds = YES;
                            self.pkBattleUserRightSingAnimation.hidden = NO;
                            self.commentTableViewTopConstrainst.constant = 100;
                        });
                    }
                }else if ([pkStatus isEqualToString:ENDPK] && isFirstNotEndPK){
                    isFirstNotEndPK = NO;
                    listQueueSingPK = [NSMutableArray new];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
                    blueTeam = [NSMutableArray new];
                    redTeam = [NSMutableArray new];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.commentTableViewTopConstrainst.constant = 0;
                        self.ic_userPKSingingRight.hidden = YES;
                        self.ic_userPKSingingLeft.hidden = YES;
                        self.pkResultScoreL.text=[NSString stringWithFormat:@"%ld",userPKRedScore.totalScore  ];
                        self.pkResultScoreR.text=[NSString stringWithFormat:@"%ld",userPKBluedScore.totalScore  ];
                        if (userPKRedScore.totalScore>userPKBluedScore.totalScore){
                            self.pkResultIconL.image = [UIImage imageNamed:@"badge_win.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                            self.pkResultIconR.image = [UIImage imageNamed:@"badge_fail.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else if (userPKRedScore.totalScore<userPKBluedScore.totalScore){
                            self.pkResultIconR.image = [UIImage imageNamed:@"badge_win.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                            self.pkResultIconL.image = [UIImage imageNamed:@"badge_fail.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }else {
                            self.pkResultIconL.image = [UIImage imageNamed:@"badge_draw.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                            self.pkResultIconR.image = [UIImage imageNamed:@"badge_draw.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        }
                        if ([userPKRedScore.friendStatus isEqualToString:@"FRIEND"]) {
                            [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                            
                        }else {
                           
                            [self.pkResultFollowButtonL setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        }
                        if ([userPKBluedScore.friendStatus isEqualToString:@"FRIEND"]) {
                            [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_unfollow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        }else {
                            [self.pkResultFollowButtonR setBackgroundImage:[UIImage imageNamed:@"ic_follow_resultPK.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        }
                        if ([userPKRedScore.facebookId isEqualToString:currentFbUser.facebookId]){
                            self.pkResultFollowButtonL.hidden = YES;
                        }else {
                            self.pkResultFollowButtonL.hidden = NO;
                        }
                        if ([userPKBluedScore.facebookId isEqualToString:currentFbUser.facebookId]){
                            self.pkResultFollowButtonR.hidden = YES;
                        }else {
                            self.pkResultFollowButtonR.hidden = NO;
                        }
                        [self.pkResultUserL sd_setImageWithURL:[NSURL URLWithString:userPKRedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        [self.pkResultUserR sd_setImageWithURL:[NSURL URLWithString:userPKBluedScore.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkResultUserNameL.text = userPKRedScore.name;
                        self.pkResultUserNameR.text = userPKBluedScore.name;
                        self.pkStartView.hidden = YES;
                        self.pkResultView.hidden = NO;
                        self.pkBattleView.hidden = YES;
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkStartView.hidden = NO;
                        self.pkResultView.hidden = YES;
                        self.pkBattleView.hidden = YES;
                    });
                }
                NSLog(@"PK status %@",pkStatus );
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartView.hidden = NO;
                    self.pkResultView.hidden = YES;
                    self.pkBattleView.hidden = YES;
                });
            }
        }];
        
        NSString *urlQ=[NSString stringWithFormat: @"livestream/roomPKTwoSong/%ld",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryQ = [self.ref child:urlQ]  ;
        _refHandleQueueSongPK = [recentPostsQueryQ observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                Song * userSing = [[Song alloc] initWithString:jsonString error:&error];
                userSing.firebaseId= snapshot.key;
                
                [listQueueSingPK addObject:userSing];
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                [listQueueSingPK sortUsingDescriptors:sortDescriptors];
                if (listQueueSingPK.count>1) {
                    Song* songUserPKRed= [listQueueSingPK objectAtIndex:0];
                    Song* songUserPKBlued = [listQueueSingPK objectAtIndex:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserR sd_setImageWithURL:[NSURL URLWithString:songUserPKBlued.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        [self.pkBattleUserL sd_setImageWithURL:[NSURL URLWithString:songUserPKRed.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    });
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            }
            
            
        }];
        
        
      
        NSString *urlQT=[NSString stringWithFormat: @"livestream/roomPKQueueSongTemp/%ld",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryQT= [self.ref child:urlQT]  ;
        _refHandleQueueSong = [recentPostsQueryQT observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                Song * userSing = [[Song alloc] initWithString:jsonString error:&error];
                userSing.firebaseId= snapshot.key;
                
                [listQueueSingPKTemp addObject:userSing];
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                [listQueueSingPKTemp sortUsingDescriptors:sortDescriptors];
                if (listQueueSingPKTemp.count>0) {
                    Song *songL = [listQueueSingPKTemp objectAtIndex:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkStartUserL sd_setImageWithURL:[NSURL URLWithString:songL.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkStartUserNameL.text = songL.owner.name;
                        self.pkStartUserNameL.hidden = NO;
                        self.pkStartUserL.hidden = NO;
                        self.pkStartUserIconL.hidden = YES;
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkStartUserNameL.hidden = YES;
                        self.pkStartUserL.hidden = YES;
                        self.pkStartUserIconL.hidden = NO;
                    });
                }
                if (listQueueSingPKTemp.count>1) {
                    Song *songR = [listQueueSingPKTemp objectAtIndex:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkStartUserR sd_setImageWithURL:[NSURL URLWithString:songR.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkStartUserNameR.text = songR.owner.name;
                        self.pkStartUserNameR.hidden = NO;
                        self.pkStartUserR.hidden = NO;
                        self.pkStartUserIconR.hidden = YES;
                    });
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkStartUserNameR.hidden = YES;
                        self.pkStartUserR.hidden = YES;
                        self.pkStartUserIconR.hidden = NO;
                    });
                }
                if (listQueueSingPKTemp.count>1 && ([currentFbUser.roomUserType isEqualToString:@"OWNER"] || [currentFbUser.roomUserType isEqualToString:@"ADMIN"])) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkStartButtonImage.image = [UIImage imageNamed:@"match_start.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                        
                    });
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkStartButtonImage.image = [UIImage imageNamed:@"match_waiting.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    });
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            }
            
            
        }];
        
    
        FIRDatabaseQuery *recentPostsQueryQT2 =[self.ref child:urlQT] ;
        _refHandleQueueSong2 = [recentPostsQueryQT2 observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            Song * userSing = [[Song alloc] initWithString:jsonString error:&error];
            userSing.firebaseId= snapshot.key;
            
            for (Song * song in listQueueSingPKTemp) {
                if ([userSing.firebaseId isEqualToString: song.firebaseId] ) {
                    [listQueueSingPKTemp removeObject:song];
                    [listQueueSingPKTemp addObject:userSing];
                    break;
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [listQueueSingPKTemp sortUsingDescriptors:sortDescriptors];
            if (listQueueSingPKTemp.count>0) {
                Song *songL = [listQueueSingPKTemp objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkStartUserL sd_setImageWithURL:[NSURL URLWithString:songL.owner.profileImageLink]placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkStartUserNameL.text = songL.owner.name;
                    self.pkStartUserNameL.hidden = NO;
                    self.pkStartUserL.hidden = NO;
                    self.pkStartUserIconL.hidden = YES;
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartUserNameL.hidden = YES;
                    self.pkStartUserL.hidden = YES;
                    self.pkStartUserIconL.hidden = NO;
                });
            }
            if (listQueueSingPKTemp.count>1) {
                Song *songR = [listQueueSingPKTemp objectAtIndex:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkStartUserR sd_setImageWithURL:[NSURL URLWithString:songR.owner.profileImageLink]placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkStartUserNameR.text = songR.owner.name;
                    self.pkStartUserNameR.hidden = NO;
                    self.pkStartUserR.hidden = NO;
                    self.pkStartUserIconR.hidden = YES;
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartUserNameR.hidden = YES;
                    self.pkStartUserR.hidden = YES;
                    self.pkStartUserIconR.hidden = NO;
                });
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            
            
        }];
       
        FIRDatabaseQuery *recentPostsQueryQT3 =[self.ref child:urlQT] ;
        _refHandleQueueSong3 = [recentPostsQueryQT3 observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot *snapshot) {
            
            Song *cmt=[Song new];
            
            cmt.firebaseId=snapshot.key;
            for (Song * song in listQueueSingPKTemp) {
                if ([cmt.firebaseId isEqualToString: song.firebaseId] ) {
                    [listQueueSingPKTemp removeObject:song];
                    break;
                }
            }
            
            if (listQueueSingPKTemp.count>0) {
                Song *songL = [listQueueSingPKTemp objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkStartUserL sd_setImageWithURL:[NSURL URLWithString:songL.owner.profileImageLink]placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkStartUserNameL.text = songL.owner.name;
                    self.pkStartUserNameL.hidden = NO;
                    self.pkStartUserL.hidden = NO;
                    self.pkStartUserIconL.hidden = YES;
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartUserNameL.hidden = YES;
                    self.pkStartUserL.hidden = YES;
                    self.pkStartUserIconL.hidden = NO;
                });
            }
            if (listQueueSingPKTemp.count>1) {
                Song *songR = [listQueueSingPKTemp objectAtIndex:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkStartUserR sd_setImageWithURL:[NSURL URLWithString:songR.owner.profileImageLink]placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkStartUserNameR.text = songR.owner.name;
                    self.pkStartUserNameR.hidden = NO;
                    self.pkStartUserR.hidden = NO;
                    self.pkStartUserIconR.hidden = YES;
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartUserNameR.hidden = YES;
                    self.pkStartUserR.hidden = YES;
                    self.pkStartUserIconR.hidden = NO;
                });
            }
            if (listQueueSingPKTemp.count>1 && ([currentFbUser.roomUserType isEqualToString:@"OWNER"] || [currentFbUser.roomUserType isEqualToString:@"ADMIN"])) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartButtonImage.image = [UIImage imageNamed:@"match_start.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pkStartButtonImage.image = [UIImage imageNamed:@"match_waiting.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                });
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            
            
        }];
        NSString *urlRedScore=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/redScore",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryRedS = [self.ref child:urlRedScore]  ;
        _refHandleQueueSongRS = [recentPostsQueryRedS observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                
                
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                userPKRedScore = [[User alloc] initWithString:jsonString error:&error];
                for (int i = 0 ; i<listUserOnline.count; i++) {
                    User * userO = [listUserOnline objectAtIndex:i];
                  
                    if ([userPKRedScore.facebookId isKindOfClass:[NSString class]] && [userO.facebookId isKindOfClass:[NSString class]])
                        if ([userPKRedScore.facebookId isEqualToString:userO.facebookId]) {
                            userPKRedScore.friendStatus = userO.friendStatus;
                            break;
                        }
                }
                [self updatePKScore];
            }
        }];
        NSString *urlBlueScore=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/blueScore",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryBS = [self.ref child:urlBlueScore]  ;
        _refHandleQueueSongBS = [recentPostsQueryBS observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                
                
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                userPKBluedScore = [[User alloc] initWithString:jsonString error:&error];
         
                for (int i = 0 ; i<listUserOnline.count; i++) {
                    User * userO = [listUserOnline objectAtIndex:i];
                    
                    if ([userPKBluedScore.facebookId isKindOfClass:[NSString class]] && [userO.facebookId isKindOfClass:[NSString class]])
                        if ([userPKBluedScore.facebookId isEqualToString:userO.facebookId]) {
                            userPKBluedScore.friendStatus = userO.friendStatus;
                            break;
                        }
                }
                [self updatePKScore];
            }
        }];
        redTeam = [NSMutableArray new];
        blueTeam = [NSMutableArray new];
        NSString *urlRed=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/redTeam",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryRed = [self.ref child:urlRed]  ;
        _refHandleQueueSongR = [recentPostsQueryRed observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                
                
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                User * userSing = [[User alloc] initWithString:jsonString error:&error];
                
                
                [redTeam addObject:userSing];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                [redTeam sortUsingDescriptors:sortDescriptors];
                if (redTeam.count>0) {
                    User *userPKRed1 = [redTeam objectAtIndex:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserLTop1  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameL1.hidden = NO;
                    });
                }
                if (redTeam.count>1) {
                    User *userPKRed1 = [redTeam objectAtIndex:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserLTop2  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameL2.hidden = NO;
                    });
                }
                if (redTeam.count>2) {
                    User *userPKRed1 = [redTeam objectAtIndex:2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserLTop3  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameL3.hidden = NO;
                    });
                }
            }
            
            
        }];
        
        
        FIRDatabaseQuery *recentPostsQueryRed2 =[self.ref child:urlRed] ;
        _refHandleQueueSongR2 = [recentPostsQueryRed2 observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            User * userSing = [[User alloc] initWithString:jsonString error:&error];
            
            
            for (User * song in redTeam) {
                if ([userSing.facebookId isEqualToString: song.facebookId] ) {
                    [redTeam removeObject:song];
                    [redTeam addObject:userSing];
                    break;
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            
            
            [redTeam sortUsingDescriptors:sortDescriptors];
            if (redTeam.count>0) {
                User *userPKRed1 = [redTeam objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserLTop1  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameL1.hidden = NO;
                });
            }
            if (redTeam.count>1) {
                User *userPKRed1 = [redTeam objectAtIndex:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserLTop2  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameL2.hidden = NO;
                });
            }
            if (redTeam.count>2) {
                User *userPKRed1 = [redTeam objectAtIndex:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserLTop3  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameL3.hidden = NO;
                });
            }
            
            
            
        }];
        NSString *urlBlue=[NSString stringWithFormat: @"livestream/rooms/%ld/giftScorePK/blueTeam",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryBlue = [self.ref child:urlBlue]  ;
        _refHandleQueueSongB = [recentPostsQueryBlue observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                
                
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                User * userSing = [[User alloc] initWithString:jsonString error:&error];
                
                
                [blueTeam addObject:userSing];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                [blueTeam sortUsingDescriptors:sortDescriptors];
                if (blueTeam.count>0) {
                    User *userPKRed1 = [blueTeam objectAtIndex:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserRTop1  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameR1.hidden = NO;
                    });
                }
                if (blueTeam.count>1) {
                    User *userPKRed1 = [blueTeam objectAtIndex:1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserRTop2  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameR2.hidden = NO;
                    });
                }
                if (blueTeam.count>2) {
                    User *userPKRed1 = [blueTeam objectAtIndex:2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pkBattleUserRTop3  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                        self.pkBattleFrameR3.hidden = NO;
                    });
                }
            }
            
            
        }];
        
        
        FIRDatabaseQuery *recentPostsQueryBlue2 =[self.ref child:urlBlue] ;
        _refHandleQueueSongB2 = [recentPostsQueryBlue2 observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            User * userSing = [[User alloc] initWithString:jsonString error:&error];
            
            
            for (User * song in blueTeam) {
                if ([userSing.facebookId isEqualToString: song.facebookId] ) {
                    [blueTeam removeObject:song];
                    [blueTeam addObject:userSing];
                    break;
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            
            
            [blueTeam sortUsingDescriptors:sortDescriptors];
            if (blueTeam.count>0) {
                User *userPKRed1 = [blueTeam objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserRTop1  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameR1.hidden = NO;
                });
            }
            if (blueTeam.count>1) {
                User *userPKRed1 = [blueTeam objectAtIndex:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserRTop2  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameR2.hidden = NO;
                });
            }
            if (blueTeam.count>2) {
                User *userPKRed1 = [blueTeam objectAtIndex:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pkBattleUserRTop3  sd_setImageWithURL:[NSURL URLWithString:userPKRed1.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                    self.pkBattleFrameR3.hidden = NO;
                });
            }
            
            
        }];
    }else{
#pragma mark roomQueueSong
        NSString *urlQ=[NSString stringWithFormat: @"livestream/roomQueueSong/%ld",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryQ = [[self.ref child:urlQ] queryOrderedByChild:@"dateTime" ]  ;
        _refHandleQueueSong = [recentPostsQueryQ observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                
                
                
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                Song * userSing = [[Song alloc] initWithString:jsonString error:&error];
                userSing.firebaseId= snapshot.key;
                
                [listQueueSing addObject:userSing];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            }
            
            
        }];
        
        NSString *urlQ2=[NSString stringWithFormat: @"livestream/roomQueueSong/%ld",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryQ2 =[self.ref child:urlQ2] ;
        _refHandleQueueSong2 = [recentPostsQueryQ2 observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            Song * userSing = [[Song alloc] initWithString:jsonString error:&error];
            userSing.firebaseId= snapshot.key;
            
            for (Song * song in listQueueSing) {
                if ([userSing.firebaseId isEqualToString: song.firebaseId] ) {
                    [listQueueSing removeObject:song];
                    [listQueueSing addObject:userSing];
                    break;
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            [listQueueSing sortUsingDescriptors:sortDescriptors];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            
            
        }];
        NSString *urlQ3=[NSString stringWithFormat: @"livestream/roomQueueSong/%ld",self.liveroom._id];
        FIRDatabaseQuery *recentPostsQueryQ3 =[self.ref child:urlQ3] ;
        _refHandleQueueSong3 = [recentPostsQueryQ3 observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot *snapshot) {
            
            Song *cmt=[Song new];
            
            cmt.firebaseId=snapshot.key;
            for (Song * song in listQueueSing) {
                if ([cmt.firebaseId isEqualToString: song.firebaseId] ) {
                    [listQueueSing removeObject:song];
                    break;
                }
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
            
            
        }];
    }
        // Listen for new messages in the Firebase database
    endListComment=0;
    
    
    
    listComment=[NSMutableArray new];
    RoomComment *cmtA=[RoomComment new];
    endListComment++;
    cmtA.dateTime=0;
    if ([self.liveroom.bulletin isKindOfClass:[NSString class]] && self.liveroom.bulletin.length>5) {
        cmtA.message = self.liveroom.bulletin;
    }else {
        cmtA.message = AMLocalizedString(@"Xin chào mừng bạn vào phòng. Hãy cư xử văn minh, lịch sự!", nil);
    }
    cmtA.roomType=@"NOTICE";
    [self->listComment addObject:cmtA];
    [self.statusAndCommentTableView reloadData];
    noUpdateComment =0;
#pragma mark roomComments
    NSString *url=[NSString stringWithFormat: @"livestream/roomComments/%ld",self.liveroom._id];
    long timeNow = [[NSDate date] timeIntervalSince1970] ;// queryStartingAtValue:[NSNumber numberWithLong: timeNow*1000 ]
    FIRDatabaseQuery *recentPostsQuery = [[self.ref child:url ] queryOrderedByChild:@"dateTime"] ; //queryStartingAtValue:[NSNumber numberWithLong: timeNow*1000 ] ]  ;//queryLimitedToLast:1] ;
    _refHandle = [recentPostsQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            RoomComment *cmt = [[RoomComment alloc] initWithString:jsonString error:&error];
            endListComment++;
            cmt.commentId=snapshot.key;
            
            if (![cmt.userName isKindOfClass:[NSString class]]){
                NSLog(@"cmt user null");
            }
            
            if ([cmt.roomType isEqualToString:GIFT]) {
                
                NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                NSString *jsonString;
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                RoomStatus* currentStatus = [[RoomStatus alloc] initWithString:jsonString error:&error];
                
                if (currentStatus.noItemSent==0){
                    currentStatus.noItemSent = currentStatus.giftNoItem;
                }
                [queueGifts addObject:currentStatus];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self checkShowGift];
                });
                for (User * userOn in  self->listUserOnline) {
                    if ([userOn.facebookId isEqualToString: cmt.toFacebookId]) {
                        userOn.totalScore = cmt.totalScore;
                        if (userSinging){
                            if ([userSinging.owner.facebookId isEqualToString:userOn.facebookId]){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: userOn.totalScore ]];
                                });
                            }
                        }
                        break;
                    }
                }
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                
                [self->listUserOnline sortUsingDescriptors:sortDescriptors];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.userOnlineTableView reloadData];
                    [self.userOnlineCollectionView reloadData];
                });
            }else if ([cmt.roomType isEqualToString:NOTIFICATION]) {
                
                if ([cmt.userType isEqualToString:@"CHANGETYPEROOM"]) {
                    endSong = NO;
                    if (isStartingLive)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
                    UIAlertController* alertBlockChat=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"Thông báo", nil) message:[NSString stringWithFormat: cmt.message] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:AMLocalizedString(@"Xác nhận", nil)
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                    
                    if (ringBufferAudioLive)
                        ringBufferAudioLive->empty();
                        //  self.liveroom.noOnlineMembers --;
                    [self.roomShowTimeView removeFromSuperview];
                    
                    [self sendSTOPSENDStream];
                    [self removeHandle];
                    [self.playerLayerView removeFromSuperview];
                    [self.playerLayerView.playerLayer setPlayer:nil];
                    self.playerLayerView=nil;
                    [self.liveAnimation stop];
                    self.liveAnimation = nil;
                    demConnect = 1;
                    [socket disconnect];
                    socket.delegate=nil;
                    socket = nil;
                    [playerVideo pause];
                    isReceiveLive = NO;
                    isStartingLive = NO;
                    [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
                        // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
                    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
                    [audioEngine3 stopP];
                    audioEngine3.sendLive = NO;
                        //[audioEngine3 destroy];
                    audioEngine3 = nil;
                    if (doNothingStreamTimer) {
                        [doNothingStreamTimer invalidate];
                        doNothingStreamTimer=nil;
                    }
                    if (changeBGtimer) {
                        [changeBGtimer invalidate];
                        changeBGtimer=nil;
                    }
                    if (timerPlayer) {
                        [timerPlayer invalidate];
                        timerPlayer= nil;
                    }
                    userShowTime = nil;
                    [playerNode stop];
                        // playerNode = nil;
                    AVAudioSession *session = [ AVAudioSession sharedInstance ];
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"outLiveRoom"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"loadStreamLive"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"homePressLive"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"homeComebackLive"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"startAudiEngine"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:@"stopLive"
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:UIKeyboardWillShowNotification
                                                                  object:nil];
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                    name:UIKeyboardWillHideNotification
                                                                  object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
                    
                    isInLiveView = NO;
                    self.functions = nil;
                    [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
                    
                    
                    
                    }];
                    
                    [alertBlockChat addAction:yesButton];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertBlockChat animated:YES completion:nil];
                    });
                }else
                if ([cmt.userId isEqualToString:currentFbUser.facebookId]) {
                    if ([cmt.userType isEqualToString:@"INVITEFAMILY"] ) {
                        alertInviteMemberFamily = YES;
                        acceptInviteFromFBId = cmt.fromFacebookId;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.liveAlertHeightConstrainst.constant = 200;
                            [self.liveAlertYesButton setTitle:AMLocalizedString(@"Đồng ý", nil) forState:UIControlStateNormal];
                            self.liveAlertTitleLabel.text = AMLocalizedString(@"Xác nhận", nil);
                            self.liveAlertContentLabel.text = cmt.message;
                            self.liveAlertView.hidden = NO;
                        });
                    }else
                    if ([cmt.userType isEqualToString:@"BLOCK"]) {
                        
                        currentFbUser.roomUserType = cmt.userType;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[[iToast makeText:AMLocalizedString(@"Bạn đã bị chặn!", nil)]
                               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                            [self sendSTOPSENDStream];
                            [self removeHandle];
                                // self.liveroom.noOnlineMembers --;
                            demConnect = 1;
                            [socket disconnect];
                            socket.delegate=nil;
                            [playerVideo pause];
                            isReceiveLive = NO;
                            isStartingLive = NO;
                            [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
                                // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
                            [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
                            [audioEngine3 stopP];
                                //  [audioEngine3 destroy];
                            audioEngine3 = nil;
                                // [self.roomShowTimeView removeFromSuperview];
                            
                            [self.playerLayerView removeFromSuperview];
                            [self.playerLayerView.playerLayer setPlayer:nil];
                            self.playerLayerView=nil;
                            if (doNothingStreamTimer) {
                                [doNothingStreamTimer invalidate];
                                doNothingStreamTimer=nil;
                            }
                            if (changeBGtimer) {
                                [changeBGtimer invalidate];
                                changeBGtimer=nil;
                            }
                            if (timerPlayer) {
                                [timerPlayer invalidate];
                                timerPlayer= nil;
                            }
                            AVAudioSession *session = [ AVAudioSession sharedInstance ];
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"outLiveRoom"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"loadStreamLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"homePressLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"homeComebackLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"startAudiEngine"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"stopLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:UIKeyboardWillShowNotification
                                                                          object:nil];
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:UIKeyboardWillHideNotification
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
                            socket = nil;
                            isInLiveView = NO;
                            [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
                                //  [self.navigationController popViewControllerAnimated:YES];
                        });
                        return;
                    }else if ([cmt.userType isEqualToString:@"SERVERREMOVEUSER"]) {
                        currentFbUser.roomUserType = cmt.userType;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                                [[[[iToast makeText:AMLocalizedString(@"Kết nối với server bị gián đoạn!", nil)]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                          
                            [self sendSTOPSENDStream];
                            [self removeHandle];
                                // self.liveroom.noOnlineMembers --;
                            demConnect = 1;
                            [socket disconnect];
                            socket.delegate=nil;
                            [playerVideo pause];
                            isReceiveLive = NO;
                            isStartingLive = NO;
                            [NSThread detachNewThreadSelector:@selector(removeUserOnLine) toTarget:self withObject:nil];
                                // [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
                            [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
                            [audioEngine3 stopP];
                                //  [audioEngine3 destroy];
                            audioEngine3 = nil;
                                // [self.roomShowTimeView removeFromSuperview];
                            
                            [self.playerLayerView removeFromSuperview];
                            [self.playerLayerView.playerLayer setPlayer:nil];
                            self.playerLayerView=nil;
                            if (doNothingStreamTimer) {
                                [doNothingStreamTimer invalidate];
                                doNothingStreamTimer=nil;
                            }
                            if (timerPlayer) {
                                [timerPlayer invalidate];
                                timerPlayer= nil;
                            }
                            if (changeBGtimer) {
                                [changeBGtimer invalidate];
                                changeBGtimer=nil;
                            }
                            AVAudioSession *session = [ AVAudioSession sharedInstance ];
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"outLiveRoom"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"loadStreamLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"homePressLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"homeComebackLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"startAudiEngine"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:@"stopLive"
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:UIKeyboardWillShowNotification
                                                                          object:nil];
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:UIKeyboardWillHideNotification
                                                                          object:nil];
                            [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
                            socket = nil;
                            isInLiveView = NO;
                            [self dismissViewControllerAnimated:YES completion:nil];
                               // [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return;
                    }else if ([cmt.userType isEqualToString:@"REMOVESONG"]) {
                        userShowTime = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[[iToast makeText:AMLocalizedString(@"Bạn bị Quản lý phòng dừng bài hát!", nil)]
                               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                        
                    }else if ([cmt.userType isEqualToString:@"SWITCHUSER"]) {
                        userShowTime = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[[[iToast makeText:AMLocalizedString(@"Dừng hát vì mạng quá chậm!", nil)]
                               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                        });
                        
                    }
                    if ([cmt.userType isKindOfClass:[NSString class    ]]) {
                        if ([cmt.userType isEqualToString:@"EVERYONE"] || [cmt.userType isEqualToString:@"OWNER"] || [cmt.userType isEqualToString:@"ADMIN"] || [cmt.userType isEqualToString:@"VIP"]) {
                        currentFbUser.roomUserType = cmt.userType;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadQueueSing" object:nil];
                            if ([self.liveroom.type isEqualToString:@"VERSUS"]){
                        if (listQueueSingPKTemp.count>1 && ([currentFbUser.roomUserType isEqualToString:@"OWNER"] || [currentFbUser.roomUserType isEqualToString:@"ADMIN"])) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.pkStartButtonImage.image = [UIImage imageNamed:@"match_start.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                                
                            });
                            
                        }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.pkStartButtonImage.image = [UIImage imageNamed:@"match_waiting.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                            });
                        }
                            }
                        for (User * userOn in  self->listUserOnline) {
                            if ([userOn.facebookId isEqualToString: cmt.userId]) {
                                if ([cmt.userType isKindOfClass:[NSString class    ]]) {
                                    userOn.roomUserType = cmt.userType;
                                }
                                break;
                            }
                            
                        }
                            if ([self.liveroom.family isKindOfClass:[Family class]]){
                                /*FlutterMethodChannel* nativeCallChannel = [FlutterMethodChannel
                                                                           methodChannelWithName:@"moduleFlutter/nativeToFlutter"       binaryMessenger:flutterViewController.binaryMessenger];
                                
                                
                                ClientInfo * cInfo = [ClientInfo new];
                                cInfo.deviceId = [[LoadData2 alloc ] idForDevice];
                                cInfo.language = Language;
                                cInfo.platform = @"IOS";
                                cInfo.packageName =[[NSBundle mainBundle] bundleIdentifier];
                                
                                NSString *jClientInfo = [cInfo toJSONString];
                                
                                
                                [nativeCallChannel invokeMethod:@"sendClientInfo" arguments:jClientInfo result:^(id  _Nullable result) {
                                    NSLog(@"%@",result);
                                }];
                                NativeData * dataString = [NativeData new];
                                dataString.route = @"/family";
                                dataString.data = @"";
                                NSString *jClientInfo2 = [dataString toJSONString];
                                [nativeCallChannel invokeMethod:@"route" arguments:jClientInfo2 result:^(id  _Nullable result) {
                                    NSLog(@"%@",result);
                                }];*/
                            }
                        }
                    }
                    
                    
                }else {
                    if ([cmt.userType isKindOfClass:[NSString class    ]]) {
                        if ([cmt.userType isEqualToString:@"EVERYONE"] || [cmt.userType isEqualToString:@"OWNER"] || [cmt.userType isEqualToString:@"ADMIN"] || [cmt.userType isEqualToString:@"VIP"]) {
                    for (User * userOn in  self->listUserOnline) {
                        if ([userOn.facebookId isEqualToString: cmt.userId]) {
                            if ([cmt.userType isKindOfClass:[NSString class    ]]) {
                                userOn.roomUserType = cmt.userType;
                            }
                            break;
                        }
                        
                    }
                            if ([self.liveroom.family isKindOfClass:[Family class]]){
                                /*FlutterMethodChannel* nativeCallChannel = [FlutterMethodChannel
                                                                           methodChannelWithName:@"moduleFlutter/nativeToFlutter"       binaryMessenger:flutterViewController.binaryMessenger];
                                
                                
                                ClientInfo * cInfo = [ClientInfo new];
                                cInfo.deviceId = [[LoadData2 alloc ] idForDevice];
                                cInfo.language = Language;
                                cInfo.platform = @"IOS";
                                cInfo.packageName =[[NSBundle mainBundle] bundleIdentifier];
                                
                                NSString *jClientInfo = [cInfo toJSONString];
                                
                                
                                [nativeCallChannel invokeMethod:@"sendClientInfo" arguments:jClientInfo result:^(id  _Nullable result) {
                                    NSLog(@"%@",result);
                                }];
                                
                                NativeData * dataString = [NativeData new];
                                dataString.route = @"/family";
                                dataString.data = @"";
                                NSString *jClientInfo2 = [dataString toJSONString];
                                [nativeCallChannel invokeMethod:@"route" arguments:jClientInfo2 result:^(id  _Nullable result) {
                                    NSLog(@"%@",result);
                                }];*/
                            }
                        }
                    }
                }
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.commentId like %@",cmt.commentId ] ;
            NSArray * fillarray= [self->listComment filteredArrayUsingPredicate:predicate];
            if (fillarray.count==0) {
                if ([cmt.userType isEqualToString:@"SERVERREMOVEUSER"] || [cmt.userType isEqualToString:@"NOTADDCOMMENT"] ||[cmt.userType isEqualToString:@"BLOCK"]) {
                }else {
                    [self->listComment addObject:cmt];
                    noUpdateComment ++;
                }
            }
            
            
                //   [self.mytableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
                //  }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.statusAndCommentTableView reloadData];
                [self performSelector:@selector(scrollToBottomAnimated:) withObject:nil afterDelay:0.1];
                
                
            });
            
        }
    }];
    
    
    listUserOnline=[NSMutableArray new];
    NSString *url3=[NSString stringWithFormat: @"livestream/roomUserOnline/%ld",self.liveroom._id];
    FIRDatabaseQuery *recentPostsQuery3 = [[self.ref child:url3] queryOrderedByChild:@"totalScore"]   ;
    _refHandleUserOnline = [recentPostsQuery3 observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            User *cmt = [[User alloc] initWithString:jsonString error:&error];
            cmt.roomId=snapshot.key;
            
            [self->listUserOnline addObject:cmt];
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            [self->listUserOnline sortUsingDescriptors:sortDescriptors];
            dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
            
            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.noUserOnline.text = [NSString stringWithFormat:@"%lu",(unsigned long)self->listUserOnline.count];
                    self.noUserOnlineLabel.text = [NSString stringWithFormat:@"%lu Online",(unsigned long)self->listUserOnline.count];
                    [self.userOnlineTableView reloadData];
                    [self.userOnlineCollectionView reloadData];
                });
            });
            if (responeFriendStatus.friendsStatus.count>0){
                [self loadFriendStatus];
            }
            
        }
    }];
    
    NSString *url5=[NSString stringWithFormat: @"livestream/roomUserOnline/%ld",self.liveroom._id];
    FIRDatabaseQuery *recentPostsQuery5 = [self.ref child:url5]   ;
    _refHandleRemoveUserOnline = [recentPostsQuery5 observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            User *cmt = [[User alloc] initWithString:jsonString error:&error];
            cmt.roomId=snapshot.key;
            
            for (User * user in self->listUserOnline) {
                if ([cmt.facebookId isEqualToString:user.facebookId]) {
                    [self->listUserOnline removeObject:user];
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noUserOnline.text = [NSString stringWithFormat:@"%lu",(unsigned long)self->listUserOnline.count];
                self.noUserOnlineLabel.text = [NSString stringWithFormat:@"%lu Online",(unsigned long)self->listUserOnline.count];
                [self.userOnlineTableView reloadData];
                [self.userOnlineCollectionView reloadData];
            });
            
            
        }
    }];
#pragma mark roomShowTime
    NSString *url4=[NSString stringWithFormat: @"livestream/roomShowTime/%ld",self.liveroom._id];
    FIRDatabaseQuery *recentPostsQuery4 = [self.ref child:url4]   ;
    _refHandleShowTime = [recentPostsQuery4 observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            
            
            
            NSDictionary<NSString *, id > *cmtdict = snapshot.value;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cmtdict
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            userSinging = [[Song alloc] initWithString:jsonString error:&error];
            
            if ([userSinging.owner2.name isKindOfClass:[NSString class]]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userSingDuetView.hidden = NO;
                    self.giftViewInfo.hidden = YES;
                    self.userSingDuetName.text = userSinging.owner2.name;
                    [self.giftViewInfoImage sd_setImageWithURL:[NSURL URLWithString:userSinging.owner2.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userSingDuetView.hidden = YES;
                    self.giftViewInfo.hidden = NO;
                    self.giftViewInfoImage.image = [UIImage imageNamed:@"ic_Live_ScoreGift.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                    self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: userSinging.owner.totalScore]];
                });
                for (User * userOn in  self->listUserOnline) {
                    if ([userOn.facebookId isEqualToString: userSinging.owner.facebookId]) {
                       
                            if ([userSinging.owner.facebookId isEqualToString:userOn.facebookId]){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: userOn.totalScore ]];
                                });
                            }
                        
                        break;
                    }
                }
               
            }
            if ([userSinging.owner.facebookId isEqualToString:currentFbUser.facebookId]) {
                if (userSinging.status==4 ) {
                    userShowTime = [[Song alloc] init];
                    [userShowTime setValuesForKeysWithDictionary:[userSinging toDictionary]];
                    userShowTime.owner = userSinging.owner;
                    
                    demTimeHideRoomShowTime = 10;
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging._id]];
                    if ([userSinging.songUrl isKindOfClass:[NSString class]]){
                        if ([userSinging.songUrl hasSuffix:@"m4a"]) {
                            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",userSinging._id]];
                        }
                    }
                    if (userSinging.videoId.length>2){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",userSinging.videoId]];
                        
                    }
                    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
                    CMTime audioDuration = audioAsset.duration;
                    userSinging.duration = [NSNumber numberWithLong:CMTimeGetSeconds(audioDuration)*1000];
                    if (![userSinging.mp4link isKindOfClass:[NSString class]]) {
                        userSinging.mp4link = [[LoadData2 alloc] checkLinkMp4:userSinging.videoId];
                    }
                    if (![userSinging.mp4link isKindOfClass:[NSString class]]) {
                       
                        YoutubeMp4Respone *res=[[LoadData2 alloc] GetYoutubeMp4Link:userSinging.videoId];
                        if ([res isKindOfClass:[YoutubeMp4Respone class]]) {
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
                            NSArray *filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                            if (filteredArray.count>0) {
                                YoutubeMp4* linkMp4=filteredArray[0];
                                userSinging.mp4link=linkMp4.url;
                            }else{
                                predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                                filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                if (filteredArray.count>0) {
                                    YoutubeMp4* linkMp4=filteredArray[0];
                                    userSinging.mp4link=linkMp4.url;
                                }else{
                                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                                    filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                                    if (filteredArray.count>0) {
                                        YoutubeMp4* linkMp4=filteredArray[0];
                                        userSinging.mp4link=linkMp4.url;
                                    }
                                }
                            }
                            
                        }
                    }
                    NSLog(@"show xac nhan hat %@",userSinging);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isSendingMicMC || self.micMCRecordingView.isHidden==NO){
                            [self stopMC];
                            
                            self.micMCRecordingView.hidden = YES;
                            [self.micMCRecordingImage stopAnimating];
                            isSendingMicMC = NO;
                            if (isVoice && audioEngine3) {
                                [audioEngine3 playthroughSwitchChanged:NO];
                                
                                [audioEngine3 reverbSwitchChanged:NO];
                                
                            }
                            
                            
                            audioEngine3.sendLive = NO;
                            [audioEngine3 removeOutPutReceive];
                            [audioEngine3 stopP];
                            audioEngine3 =nil;
                           
                        }
                    });
                    if (audioEngine3){
                        if (isVoice && audioEngine3) {
                            [audioEngine3 playthroughSwitchChanged:NO];
                            
                            [audioEngine3 reverbSwitchChanged:NO];
                            
                        }
                        audioEngine3.sendLive = NO;
                        [audioEngine3 removeOutPutReceive];
                        [audioEngine3 stopP];
                        audioEngine3 =nil;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pkResultView.hidden = YES;
                        [self.view addSubview:self.roomShowTimeView];
                        [self.view.topAnchor constraintEqualToAnchor:self.roomShowTimeView.topAnchor constant:0].active = YES;
                        [self.view.bottomAnchor constraintEqualToAnchor:self.roomShowTimeView.bottomAnchor constant:0].active = YES;
                        [self.view.leadingAnchor constraintEqualToAnchor:self.roomShowTimeView.leadingAnchor constant:0].active = YES;
                        [self.view.trailingAnchor constraintEqualToAnchor:self.roomShowTimeView.trailingAnchor constant:0].active = YES;
                        
                       // self.roomShowTimeSubView.center = self.parentViewController.view.center;
                        [self.view setNeedsLayout];
                        
                        if (!hasHeadset) {
                            self.roomShowTimeStartButton.enabled = NO;
                            [self.roomShowTimeStartButton setBackgroundImage:[UIImage imageNamed:@"hinh_nen_25.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                            self.roomShowTimeHeadsetLabel.text = AMLocalizedString(@"Bạn chưa kết nối tai nghe, Vui lòng gắn tai nghe để có thể bắt đầu live!", nil);
                        }else {
                            [self.roomShowTimeStartButton setBackgroundImage:[UIImage imageNamed:@"hinh_nen_27.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                            self.roomShowTimeStartButton.enabled = YES;
                            self.roomShowTimeHeadsetLabel.text = @"";
                        }
                        self.roomShowTimeView.hidden = NO;
                        self.roomShowTimeTimerLabel.text =[NSString stringWithFormat:@"%@",[self convertTimeToString2:demTimeHideRoomShowTime]];
                    });
                    
                    [self performSelector:@selector(demTimeHideRoomShowTime) withObject:nil afterDelay:1];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self-> timerPlayer==nil) {
                            self->timerPlayer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimePlayer) userInfo:nil repeats:YES];
                        }
                        self.BeatInfoImageView.hidden = YES;
                        self.beatInfoImageBG.hidden = YES;
                        self.noBodySing.hidden = YES;
                        self.UserSingingInfoView.hidden = NO;
                        self.followButton.hidden = YES;
                        self.userInfoNameLabelLeftContrainst.constant = 5;
                        self.beatInfoView.hidden = NO;
                        self.notifiView.hidden = YES;
                        self.userNameLabel.text = userSinging.owner.name;
                        self.UserInfoLabel.text = [NSString stringWithFormat:@"ID %@",userSinging.owner.uid];
                        [self.userProfileImage sd_setImageWithURL:[NSURL URLWithString:userSinging.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                        self.playerToolbar.hidden = NO;
                        self.songNameLabel.text = userSinging.songName;
                    });
                }
            }else
                if (userSinging.status ==5) {
                    if (isStartingLive) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
                    }
                    tell = 0;
                    self->listImage=[NSMutableArray new];
                    [ringBufferData removeAllObjects];
                    for (User * user in self->listUserOnline) {
                        if ([userSinging.owner.facebookId isEqualToString:user.facebookId]) {
                            userSinging.owner.friendStatus = user.friendStatus;
                            break;
                        }
                        else if ([userSinging.owner2.facebookId isKindOfClass:[NSString class]]){
                            
                            if ([userSinging.owner2.facebookId isEqualToString:user.facebookId]) {
                                userSinging.owner2.friendStatus = user.friendStatus;
                                break;
                            }
                        }
                    }
                    NSString *urlImage=[NSString stringWithFormat: @"ikara/users/%@/images/",userSinging.owner.facebookId];
                    
                    FIRDatabaseQuery *recentPostsQueryImage=[[self.ref child:urlImage] queryOrderedByChild:@"dateTime" ] ;
                    [recentPostsQueryImage observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
                        NSDictionary<NSString *, id > *cmtdict = snapshot.value;
                        if (cmtdict[@"imageUrl"] ) {
                            [listImage insertObject:cmtdict[@"imageUrl"] atIndex:0];
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (listImage.count==1  ) {
                                    [self.beatInfoImageBG sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] ];
                                    [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:[listImage objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] ];
                                    demBglayer=1;
                                    
                                }
                            });
                        }
                    }];
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ( self->timerPlayer==nil) {
                            self->timerPlayer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimePlayer) userInfo:nil repeats:YES];
                        }
                        if ( self->changeBGtimer==nil) {
                            self->changeBGtimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(changeBGLayer) userInfo:nil repeats:YES];
                        }
                        
                        if ([userSinging.owner.friendStatus isEqualToString:@"FRIEND"]) {
                            [self.followButton setImage:[UIImage imageNamed:@"ic_unfollow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                            self.followButton.hidden = YES;
                            self.userInfoNameLabelLeftContrainst.constant = 5;
                        }else {
                            self.userInfoNameLabelLeftContrainst.constant = 30;
                            self.followButton.hidden = NO;
                            [self.followButton setImage:[UIImage imageNamed:@"ic_follow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        }
                        self.beatInfoView.hidden = NO;
                        self.notifiView.hidden = YES;
                       
                        
                        self.BeatInfoImageView.hidden = NO;
                        self.beatInfoImageBG.hidden = NO;
                        self.startStreamLoading.hidden = NO;
                        [self.BeatInfoImageView sd_setImageWithURL:[NSURL URLWithString:userSinging.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                        [self.beatInfoImageBG sd_setImageWithURL:[NSURL URLWithString:userSinging.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"anh_mac_dinh.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                        self.noBodySing.hidden = YES;
                        self.UserSingingInfoView.hidden = NO;
                        self.userNameLabel.text = userSinging.owner.name;
                        self.UserInfoLabel.text = [NSString stringWithFormat:@"ID %@",userSinging.owner.uid];
                        [self.userProfileImage sd_setImageWithURL:[NSURL URLWithString:userSinging.owner.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]  ];
                        self.userSingFrame.hidden = YES;
                        
                        self.playerToolbar.hidden = NO;
                        self.songNameLabel.text = userSinging.songName;
                    });
                    
                }
                //   [self.mytableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
                //  }];
            
        }else {
            if (isStartingLive) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
            }
            NSString *urlImage=[NSString stringWithFormat: @"ikara/users/%@/images/",userSinging.owner.facebookId];
            [[self.ref child:urlImage] removeAllObservers];
            dispatch_async(dispatch_get_main_queue(), ^{
                userSinging = nil;
                
                if (timerPlayer) {
                    [timerPlayer invalidate];
                    timerPlayer= nil;
                }
                self.beatInfoView.hidden = YES;
                self.notifiView.hidden = NO;
                //self.giftViewInfoImage.image = [UIImage imageNamed:@"ic_Live_ScoreGift.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                self.noGiftLabel.text = [NSString stringWithFormat:@"%@", [[LoadData2 alloc ] pretty: self.liveroom.totalGiftScore]];
                self.userSingDuetView.hidden = YES;
                self.giftViewInfo.hidden = NO;
                self.noBodySing.hidden = NO;
                self.UserSingingInfoView.hidden = YES;
                self.playerToolbar.hidden = YES;
            });
        }
    }];
    NSString *url6=[NSString stringWithFormat: @"livestream/rooms/%@/isMC",self.liveroom.roomId];
    FIRDatabaseQuery *recentPostsQuery6 = [self.ref child:url6]   ;
    _refHandleMicMC = [recentPostsQuery6 observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            BOOL isMC =[ snapshot.value boolValue];
            
            if (isMC) {
                
                if (userMC) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.micMCAnimation.hidden = NO;
                    });
                }
            }else {
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.micMCAnimation.hidden = YES;
                });
                
            }
                //   [self.mytableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
                //  }];
            
        }
    }];
}

- (void)updateTimePlayer {
	 if (userSinging) {
		  NSDate * dateNow = [NSDate date];
		  NSDate * datePlayer = [NSDate dateWithTimeIntervalSince1970:userSinging.dateTimeUpdatePosition/1000];

		  double timeSing = [userSinging.duration doubleValue]/1000- [[NSDate date] timeIntervalSinceDate:datePlayer];
         if (timeSing<0){
             timeSing = [[NSDate date] timeIntervalSinceDate:datePlayer];
         }
		  dispatch_async(dispatch_get_main_queue(), ^{
			   NSString * playTime = [NSString stringWithFormat:@"%@",[self convertTimeToString2:timeSing]];
			   self.timeLabel.text = playTime;
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePositionLive" object:playTime];
		  });
         
		  if (isStartingLive) {
              
			   if (audioEngine3.player.duration>0) {
					CGFloat progress = audioEngine3.player.currentTime/audioEngine3.player.duration;
					[_circleProgressBar setProgress:progress animated:YES];
			   }
			   // });
		  }
	 }
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
- (void)hideStatus{
    dispatch_async( dispatch_get_main_queue(),
    ^   {

    [UIView animateWithDuration: 10.5f animations:^{
        self.statusViewLeftConstrainst.constant =- self.view.frame.size.width;


    } completion:^(BOOL finish){
        self.statusViewLeftConstrainst.constant = -self.view.frame.size.width;

    }];
    });
}

- (IBAction)sendCommentPress:(id)sender {
	 NSString *textF=[self.commentTextField.text trimWhitespace];
	 if (textF.length>0) {
         printf("hello");
         NSString* te = @"Vao day ne";
         printf("Gia tri: %s", [te UTF8String]);
		  RoomComment *cmt1=[RoomComment new];
		  cmt1.userName=currentFbUser.name;
		  cmt1.userProfile=currentFbUser.profileImageLink;
		  cmt1.message=self.commentTextField.text;
		  [self.commentTextField setText:@""];
		  [self.commentTextField setPlaceholder:AMLocalizedString(@"Nói gì đi nào!", nil)];
		  [self.commentTextField resignFirstResponder];
		  cmt1.userId=currentFbUser.facebookId;
		  if (cmt1.userName.length==0) {
			   cmt1.userName=@"";

		  }if (cmt1.userProfile.length==0) {
			   cmt1.userProfile=@"";
		  }
         cmt1.targetName = userReply.name;
         cmt1.targetId = userReply.facebookId;
		  [self addComment:cmt1];
	 }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.commentTextField==textField) {
        NSString *textF=[textField.text trimWhitespace];
        if (textF.length>0) {


        RoomComment *cmt1=[RoomComment new];
        cmt1.userName=currentFbUser.name;
        cmt1.userProfile=currentFbUser.profileImageLink;
        cmt1.message=textField.text;
			 [textField setText:@""];
								[textField setPlaceholder:AMLocalizedString(@"Nói gì đi nào!", nil)];
								[textField resignFirstResponder];
        cmt1.userId=currentFbUser.facebookId;
        if (cmt1.userName.length==0) {
            cmt1.userName=@"";

        }if (cmt1.userProfile.length==0) {
            cmt1.userProfile=@"";
        }
            //if (userReply.facebookId.length>0) {
                cmt1.targetId = userReply.facebookId;
                cmt1.targetName = userReply.name;
          //  }
        [self addComment:cmt1];
        }
         userReply = nil;

    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     if (self.commentTextField==textField) {
           
     }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.commentTextFieldToolbar])
    {

        NSString *facebookId=currentFbUser.facebookId;
        if (facebookId.length>0  ) {
			 self.cmtView.hidden = NO;
            [self.commentTextField becomeFirstResponder];
           
            [self.commentTextField setPlaceholder:@"Nói gì đi nào!"];
            userReply = nil;
            return NO;
        }else{


            [[[[iToast makeText:AMLocalizedString(@"Bạn cần đăng nhập để sử dụng chức năng này", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
          
            return NO;
            //[[[[iToast makeText:AMLocalizedString( @"Bạn chưa đăng nhập không thể bình luận", @"")]
            // setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }
    return YES;
}
- (void) addComment:(RoomComment*)commen{
	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

			 dispatch_async(queue, ^{
				  commen.userType = currentFbUser.roomUserType;
	 commen.roomId = liveRoomID;

    NSString * url=[NSString stringWithFormat: @"livestream/roomComments/%ld",self.liveroom._id];
    FIRDatabaseReference *refDb=[[self.ref child:url] childByAutoId];
				  commen.commentId = refDb.key;
				 /* [self->listComment addObject:commen];
				  noUpdateComment ++;
				   dispatch_async(dispatch_get_main_queue(), ^{
				  [self.statusAndCommentTableView reloadData];
				 [self performSelector:@selector(scrollToBottomAnimated:) withObject:nil afterDelay:0.05];
				   });*/

					   AddCommentRequest *firRequest = [AddCommentRequest new];
					   firRequest.message = commen.message;
					   firRequest.roomId = commen.roomId;
					   firRequest.commentId = commen.commentId;
                 firRequest.targetId = commen.targetId;
					   NSString * requestString = [[firRequest toJSONString] base64EncodedString];
					   self.functions = [FIRFunctions functions];
					   __block BOOL isLoadFir = NO;
					   __block FirebaseFuntionResponse *getResponse=nil;
					   [[_functions HTTPSCallableWithName:Fir_AddComment] callWithObject:@{@"parameters":requestString}
																			  completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
							
							NSString *stringReply = (NSString *)result.data;

							getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
								 // Some debug code, etc.

							if (getResponse.status.length!=2) {
								 dispatch_async(dispatch_get_main_queue(), ^{
									  [[[[iToast makeText:getResponse.message]
										 setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
								 });
							}
					   }];

			 });



}

- (void) UpdateUserOnline{

		 //  }];
		
			 dispatch_async(dispatch_get_main_queue(), ^{
				 self.noUserOnline.text = [NSString stringWithFormat:@"%lu",(unsigned long)self->listUserOnline.count];
				 self.noUserOnlineLabel.text = [NSString stringWithFormat:@"%lu Online",(unsigned long)self->listUserOnline.count];
				 [self.userOnlineTableView reloadData];
				 [self.userOnlineCollectionView reloadData];
			 });
		




    [self performSelector:@selector(UpdateUserOnline) withObject:nil afterDelay:60];



}
- (void) sendMCRequest {
    isSendingMicMC = YES;
    NSString *original = [[LoadData2 alloc ] getMCStreamRequest:liveRoomID andFacebookID:currentFbUser.facebookId];
    NSLog(@"sendMCRequest %@",liveRoomID);
   NSMutableData *data = [original dataUsingEncoding:NSUTF8StringEncoding];
  short len=[data length]+1;
  //  char* head=(char *)&len;
   unsigned char byte_arr[3] ;
     byte_arr[2] = 0;
    byte_arr[0] =(len>>8) & 0x00FF;
    byte_arr[1] = len & 0x00FF;
   u.s=len;

   [data replaceBytesInRange:NSMakeRange(0, 0) withBytes:byte_arr length:3];
    char* bytes=(char *)[data bytes];
           u.bytes[0]=bytes[0];
           u.bytes[1]=bytes[1];
           long size=u.s;
             long leng=[data length];
           //  NSLog(@"socket read data %ld and size %d",leng,size);

           short status=(short)bytes[2];
   [socket writeData:data withTimeout:-1 tag:2];
}
- (IBAction)micMCRecordPress:(id)sender {
    if (!hasHeadset) {
       // dispatch_async(dispatch_get_main_queue(), ^{
            [[[[iToast makeText:AMLocalizedString(@"Vui lòng gắn tai nghe để nói", nil)]
               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        //});
    }else {
    self.micMCRecordingView.hidden = NO;
    [self.micMCRecordingImage startAnimating];
    [self startRecordMicMC];
    }
}
- (void)startRecordMicMC {
    
 //   dispatch_async(dispatch_get_main_queue(), ^{
   
        [self creatAudioEngine];
    audioEngine3.sendMicMC = YES;
    [audioEngine3 addOutPutReceive];
        if (audioEngine3.audioController.running==NO) {
            NSError* error;
            
            [audioEngine3.audioController start:&error];
        }
        if (ringBufferAudioLive)
            ringBufferAudioLive->empty();
        
        if (!isVoice && audioEngine3 && hasHeadset ) {
            [audioEngine3 playthroughSwitchChanged:YES];
           // [audioEngine3 setPlaythroughVolume:vocalVolumeLive];
            
            [audioEngine3 reverbSwitchChanged:YES];
            audioEngine3.sendLive = YES;
        }
       // [audioEngine3 addOutPutReceive];
    isSendingMicMC = YES;
        [NSThread detachNewThreadSelector:@selector(processDataMC) toTarget:self withObject:nil];
  //  });
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
        AddMCRequest *firRequest = [AddMCRequest new];
        firRequest.roomId = liveRoomID;
        NSString * requestString = [[firRequest toJSONString] base64EncodedString];
        self.functions = [FIRFunctions functions];
        __block FirebaseFuntionResponse *getResponse=nil;
        [[_functions HTTPSCallableWithName:Fir_StartMC] callWithObject:@{@"parameters":requestString}
                                                            completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
            
            NSString *stringReply = (NSString *)result.data;
            NSLog(@"Fir_StartMC %@",stringReply);
            getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
            if (getResponse.status.length ==2) {
                
            }else {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                  });
            }
        }];
        
    });
    
}
- (IBAction)micMCStopRecord:(id)sender {
    
    [self stopMC];
    self.micMCRecordingView.hidden = YES;
    [self.micMCRecordingImage stopAnimating];
    isSendingMicMC = NO;
    if (isVoice && audioEngine3) {
        [audioEngine3 playthroughSwitchChanged:NO];

        [audioEngine3 reverbSwitchChanged:NO];
       
    }
    //[audioEngine3 pause];
   // [playerVideo pause];
    [playerNode pause];
    [engine stop];
   
     audioEngine3.sendLive = NO;
    [audioEngine3 removeOutPutReceive];
    [audioEngine3 stopP];
     audioEngine3 =nil;
   /* [[AVAudioSession sharedInstance]  setCategory: AVAudioSessionCategoryPlayback  error: nil];
    NSError *error = nil;
    if ( ![((AVAudioSession*)[AVAudioSession sharedInstance]) setActive:YES error:&error] ) {
        NSLog(@"TAAE: Couldn't deactivate audio session: %@", error);
    }
    */
   
}
- (IBAction)micMCPress:(id)sender {
    if ([userMC isKindOfClass:[User class]]) {
        if ([userMC.facebookId isEqualToString:currentFbUser.facebookId]){
        alertRemoveMicMCShow = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.liveAlertHeightConstrainst.constant = 200;

             [self.liveAlertYesButton setTitle:AMLocalizedString(@"Có", nil) forState:UIControlStateNormal];
            [self.liveAlertNoButton setTitle:AMLocalizedString(@"Không", nil) forState:UIControlStateNormal];
             self.liveAlertTitleLabel.text = AMLocalizedString(@"Ghế MC", nil);
             self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn có muốn rời ghế MC?", nil);
             self.liveAlertView.hidden = NO;
            [self.view layoutIfNeeded];
        });
        }else  if ([currentFbUser.roomUserType isEqualToString:@"OWNER"]){
            alertRemoveMicMCShow = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveAlertHeightConstrainst.constant = 200;
                
                [self.liveAlertYesButton setTitle:AMLocalizedString(@"Có", nil) forState:UIControlStateNormal];
                self.liveAlertTitleLabel.text = AMLocalizedString(@"Ghế MC", nil);
                self.liveAlertContentLabel.text =[NSString stringWithFormat: AMLocalizedString(@"Bạn có muốn đẩy %@ khỏi ghế MC?", nil),userMC.name];
                self.liveAlertView.hidden = NO;
                [self.view layoutIfNeeded];
            });
        }else  {
            [[[[iToast makeText:[NSString stringWithFormat:@"Đã có bạn %@ giữ ghế MC",userMC.name]]
            setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }else {
                 alertAddMicMCShow = YES;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.liveAlertHeightConstrainst.constant = 200;

                      [self.liveAlertYesButton setTitle:AMLocalizedString(@"Có", nil) forState:UIControlStateNormal];
                     [self.liveAlertNoButton setTitle:AMLocalizedString(@"Không", nil) forState:UIControlStateNormal];
                      self.liveAlertTitleLabel.text = AMLocalizedString(@"Ghế MC", nil);
                      self.liveAlertContentLabel.text = AMLocalizedString(@"Bạn có muốn vào ngồi ghế MC?", nil);
                      self.liveAlertView.hidden = NO;
                     [self.view layoutIfNeeded];
                 });
             }
             
  
}
- (void)startMC {
    
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
        AddMCRequest *firRequest = [AddMCRequest new];
        firRequest.roomId = liveRoomID;
        NSString * requestString = [[firRequest toJSONString] base64EncodedString];
        self.functions = [FIRFunctions functions];
        
        [[_functions HTTPSCallableWithName:Fir_StartMC] callWithObject:@{@"parameters":requestString}
                                                          completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
            
            NSString *stringReply = (NSString *)result.data;
            NSLog(@"Fir_StartMC %@",stringReply);
            
        }];
        
    });
    
}
- (void)stopMC {
    
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    
    dispatch_async(queue, ^{
        AddMCRequest *firRequest = [AddMCRequest new];
        firRequest.roomId = liveRoomID;
        NSString * requestString = [[firRequest toJSONString] base64EncodedString];
        self.functions = [FIRFunctions functions];
        
        [[_functions HTTPSCallableWithName:Fir_StopMC] callWithObject:@{@"parameters":requestString}
                                                            completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
            
            NSString *stringReply = (NSString *)result.data;
            NSLog(@"Fir_StopMC %@",stringReply);
            
        }];
        
    });
    
}
- (void)addMC {
    [self sendMCRequest];
	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 dispatch_async(queue, ^{
		  AddMCRequest *firRequest = [AddMCRequest new];
		  firRequest.roomId = liveRoomID;
		  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
		  self.functions = [FIRFunctions functions];
         __block FirebaseFuntionResponse *getResponse=nil;
		  [[_functions HTTPSCallableWithName:Fir_AddMC] callWithObject:@{@"parameters":requestString}
																	   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {

			   NSString *stringReply = (NSString *)result.data;
              NSLog(@"Fir_AddMC %@",stringReply);
              getResponse = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
              if (getResponse.status.length ==2) {
                  
              }else {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [[[[iToast makeText:getResponse.message]
                         setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                  });
              }
		  }];

	 });

}
- (void)removeMC {

	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 dispatch_async(queue, ^{
		  AddMCRequest *firRequest = [AddMCRequest new];
		  firRequest.roomId = liveRoomID;
		  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
		  self.functions = [FIRFunctions functions];

		  [[_functions HTTPSCallableWithName:Fir_RemoveMC] callWithObject:@{@"parameters":requestString}
																	   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {

			   NSString *stringReply = (NSString *)result.data;

              NSLog(@"Fir_RemoveMC %@",stringReply);
		  }];

	 });
	
}
- (void)removeUserOnLine {
    if ([userMC isKindOfClass:[User class]]){
        if ([userMC.facebookId isEqualToString:currentFbUser.facebookId]) {
            [self removeMC];
        }
    }
	 dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

	 dispatch_async(queue, ^{
		  RemoveUserOnLineRequest *firRequest = [RemoveUserOnLineRequest new];
		  firRequest.roomId = liveRoomID;
		  NSString * requestString = [[firRequest toJSONString] base64EncodedString];
		  self.functions = [FIRFunctions functions];

		  [[_functions HTTPSCallableWithName:Fir_RemoveUserOnline] callWithObject:@{@"parameters":requestString}
																	   completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
			   
			   NSString *stringReply = (NSString *)result.data;
              NSLog(@"Fir_RemoveUserOnline %@",stringReply);

		  }];
         
	 });
	 /*
		if (respone.status.length!=2) {
			dispatch_async(dispatch_get_main_queue(), ^{
					   [[[[iToast makeText:respone.message]
					   setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
			});

		}*/
}
BOOL isPKRoom;
- (void) addUserOnline{
	 @autoreleasepool {


    minuteOnline = 0;
		  //dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		 // dispatch_async(queue, ^{
			   AddUserOnLineRequest *firRequest = [AddUserOnLineRequest new];
					//firRequest.minutesOnline = 0;
			   firRequest.userId = [[LoadData2 alloc ] idForDevice];
			   firRequest.platform=@"IOS";
			   firRequest.packageName=[[NSBundle mainBundle] bundleIdentifier];
			   firRequest.language=Language;
			   NSString * version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
			   firRequest.version=version;
			   firRequest.liveRoom = currentRoomLive;
         firRequest.user = currentFbUser;
         //firRequest.user.family.owner = nil;
         NSString* stringP = [firRequest toJSONString];
			   NSString * requestString = [stringP base64EncodedString];
			   self.functions = [FIRFunctions functions];
			   __block BOOL isLoadFir = NO;
			   __block AddUserOnlineResponse *respone=nil;
			   [[_functions HTTPSCallableWithName:Fir_AddUserOnline] callWithObject:@{@"parameters":requestString}
																		 completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
					
					NSString *stringReply = (NSString *)result.data;

					respone = [[AddUserOnlineResponse alloc] initWithString:stringReply error:&error];
					NSLog(@"Add user online %@ respone %@",[firRequest toJSONString],stringReply);
						 // Some debug code, etc.
				
					if (currentRoomLive.uid==100054){
						 dispatch_async(dispatch_get_main_queue(), ^{

							  [[[[iToast makeText:AMLocalizedString(@"data3.ikara.co:9192", nil)]
								 setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
						 });
						 serverLive =@"data3.ikara.co";//respone.domain;
						 portLive = 9192;//respone.port;
					}else
						 if (respone.domain.length>3 && respone.port>0	) {

							  serverLive =respone.domain;
							  portLive =respone.port;
                             
						 }

					if (respone.roomIsExpired && [currentFbUser.facebookId isEqualToString:self.liveroom.owner.facebookId]) {
						 currentFbUser.roomUserType = respone.roomUserType;
						 alertGiaHanShow = YES;
                        
						 dispatch_async(dispatch_get_main_queue(), ^{

                             self.liveAlertHeightConstrainst.constant = 240;
							  [self.liveAlertYesButton setTitle:AMLocalizedString(@"Gia hạn", nil) forState:UIControlStateNormal];
							  self.liveAlertTitleLabel.text = AMLocalizedString(@"Phòng hết hạn", nil);
							  self.liveAlertContentLabel.text = AMLocalizedString(@"Phòng live đã hết hạn! Bạn có muốn dùng 1500 iCoin để gia hạn phòng này?", nil);
							  self.liveAlertView.hidden = NO;
							  self.prepareRoomLoadingView.hidden = YES;
							  [NSThread detachNewThreadSelector:@selector(loadStreamLive) toTarget:self withObject:nil];
                             [self.view layoutIfNeeded];
							 // [[NSNotificationCenter defaultCenter] postNotificationName:@"loadStreamLive" object:nil];
						 });
					}else
						 if (respone.status.length!=2) {

							  dispatch_async(dispatch_get_main_queue(), ^{
										[self.roomShowTimeView removeFromSuperview];
								   [self removeHandle];
								   [self sendSTOPSENDStream];
								   [self removeHandle];
								   [self.playerLayerView removeFromSuperview];
								   [self.playerLayerView.playerLayer setPlayer:nil];
								   self.playerLayerView=nil;
								   demConnect = 1;
								   [socket disconnect];
								   socket.delegate=nil;
								   [playerVideo pause];
								   isReceiveLive = NO;
								   isStartingLive = NO;

										// [NSThread detachNewThreadSelector:@selector(clearAllSongOfUserQueue) toTarget:self withObject:nil];
								   [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(demTimeHideRoomShowTime) object:nil];
								   [audioEngine3 stopP];
										//[audioEngine3 destroy];
								   audioEngine3 = nil;
								   if (doNothingStreamTimer) {
										[doNothingStreamTimer invalidate];
										doNothingStreamTimer=nil;
								   }
								   if (timerPlayer) {
										[timerPlayer invalidate];
										timerPlayer= nil;
								   }

								   if (changeBGtimer) {
										[changeBGtimer invalidate];
										changeBGtimer=nil;
								   }
								   AVAudioSession *session = [ AVAudioSession sharedInstance ];
								   [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"outLiveRoom"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"loadStreamLive"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"homePressLive"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"homeComebackLive"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"startAudiEngine"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:@"stopLive"
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:UIKeyboardWillShowNotification
																				 object:nil];

								   [[NSNotificationCenter defaultCenter] removeObserver:self
																				   name:UIKeyboardWillHideNotification
																				 object:nil];
								   [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardDidChangeFrameNotification     object:nil];
								   socket = nil;
								   isInLiveView = NO;
                                  [self deallocLive];
        [self dismissViewControllerAnimated:YES completion:nil];
								  // [self.navigationController popViewControllerAnimated:YES];
								   [[[[iToast makeText:respone.message]
									  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
							  });

						 }else {
							 // dispatch_async(dispatch_get_main_queue(), ^{
								   self.prepareRoomLoadingView.hidden = YES;
							 // });
							  currentFbUser.roomUserType = respone.roomUserType;

							  NSLog(@"socket all");
                             if (listQueueSingPKTemp.count>1 && ([currentFbUser.roomUserType isEqualToString:@"OWNER"] || [currentFbUser.roomUserType isEqualToString:@"ADMIN"]) ) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.pkStartButtonImage.image = [UIImage imageNamed:@"match_start.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                                     
                                 });
                                 
                             }else {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.pkStartButtonImage.image = [UIImage imageNamed:@"match_waiting.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                                 });
                             }
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.userOnlineCollectionView reloadData];
                             });
							//  [self loadStreamLive];
							  [NSThread detachNewThreadSelector:@selector(loadStreamLive) toTarget:self withObject:nil];
							 // [[NSNotificationCenter defaultCenter] postNotificationName:@"loadStreamLive" object:nil];
                             [self sendMoreInfoStream];

						 }

			   }];

	 }




}
- (void) loadFriendStatus {
	 @autoreleasepool {
		  dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

		  dispatch_async(queue, ^{
		  self.listFriendStatusTmp = [NSMutableArray new];
		  for (int i = 0 ; i<listUserOnline.count; i++) {
			   User * userO = [listUserOnline objectAtIndex:i];
			   if (![userO.facebookId isKindOfClass:[NSString class]])
					userO.facebookId = @"";
			   [self.listFriendStatusTmp addObject:userO.facebookId];
		  }
		   responeFriendStatus = [[LoadData2 alloc ] GetFriendsStatus:self.listFriendStatusTmp];
		  if (responeFriendStatus.friendsStatus.count==listUserOnline.count && responeFriendStatus.friendsStatus.count>0) {
			   for (int i = 0 ; i<listUserOnline.count; i++) {
					User * userO = [listUserOnline objectAtIndex:i];
					NSString * Fstatus = [responeFriendStatus.friendsStatus objectAtIndex:i];
					userO.friendStatus = Fstatus;
					if ([userSinging.owner.facebookId isKindOfClass:[NSString class]] && [userO.facebookId isKindOfClass:[NSString class]])
					if ([userSinging.owner.facebookId isEqualToString:userO.facebookId]) {
						 userSinging.owner.friendStatus = userO.friendStatus;
						  dispatch_async(dispatch_get_main_queue(), ^{
						 if ([userSinging.owner.friendStatus isEqualToString:@"FRIEND"] || [userSinging.owner.facebookId isEqualToString:currentFbUser.facebookId]) {
							  [self.followButton setImage:[UIImage imageNamed:@"ic_unfollow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                             self.followButton.hidden = YES;
                         }else {
                             self.followButton.hidden = NO;
							  [self.followButton setImage:[UIImage imageNamed:@"ic_follow_liveroom.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
						 }
						  });
					}
			   }
		  }
		  });
	 }
}
- (void)scrollToBottomAnimated:(BOOL)animated
{

 dispatch_async(dispatch_get_main_queue(), ^{
	  if (self.statusAndCommentTableView.contentOffset.y>self.statusAndCommentTableView.contentSize.height- 300 - self.statusAndCommentTableView.frame.size.height){
		   noUpdateComment = 0;
		   self.cmtNotifyView.hidden = YES;
		   NSIndexPath *lastCell = [NSIndexPath indexPathForItem:([self.statusAndCommentTableView numberOfRowsInSection:0] - 1) inSection:0];
		   [self.statusAndCommentTableView scrollToRowAtIndexPath:lastCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	  }else {
		   if (noUpdateComment>0 && self.statusAndCommentTableView.contentSize.height> self.statusAndCommentTableView.frame.size.height) {
				self.cmtNotifyLabel.text = [NSString stringWithFormat:@"Có %d bình luận mới",noUpdateComment];
				self.cmtNotifyView.hidden = NO;
		   }
	  }
 });
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {



}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==self.topUserWeekTableView){
        return  [listTopUserWeek count];
    }
    if (tableView==self.topUserDayTableView){
        return  [listTopUserDay count];
    }
    if (tableView==self.topUserMonthTabelView){
        return  [listTopUserMonth count];
    }
    if (tableView==self.tagUserTableView) {
        return [tagUserList count];
    }
    if (tableView==self.userOnlineTableView) {
        return [listUserOnline count];
    }
    if (tableView==self.takeLGTableView){
        return  [luckyGiftHistory.luckyGiftsHistory count];
    }
    if (tableView==self.gaveLGInfoTableView){
        return  [allLuckyGiftsGave.luckyGiftsGave count];
    }
    return [listComment count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tagUserTableView) {
        return 40;
    }
    if (tableView==self.userOnlineTableView) {
        return 50;
    }
    if (tableView==self.takeLGTableView || tableView==self.gaveLGInfoTableView) {
        return 68;
    }
    if (tableView==self.topUserWeekTableView || tableView==self.topUserMonthTabelView || tableView==self.topUserDayTableView) {
        return 66;
    }
        return UITableViewAutomaticDimension;

}
/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.statusAndCommentTableView && listComment.count>3){
        
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
 
        
        CAGradientLayer *gradientBlue2 = [CAGradientLayer layer];
        gradientBlue2.startPoint = CGPointMake(0.5, 0.0);
        gradientBlue2.endPoint = CGPointMake(0.5, 1.0);
        gradientBlue2.frame = view.bounds;
        gradientBlue2.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor];
    [view.layer addSublayer:gradientBlue2]; //your background color...
    return view;
    }
    return [UIView new];
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier =[NSString stringWithFormat:@"Cell"];
    if (tableView==self.gaveLGInfoTableView){
          cellIdentifier =[NSString stringWithFormat:@"CellLGHistory"];// - %@",song.ids];
            
            LuckyGiftHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            LuckyGiftGave * lg=[allLuckyGiftsGave.luckyGiftsGave objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[LuckyGiftHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
        cell.userName.text = lg.user.name;
        cell.timeTakeLG.text = [[LoadData2 alloc ] thoigianHourFir: lg.addTime];
        [cell.userProfile sd_setImageWithURL:[NSURL URLWithString:lg.user.profileImageLink]];
        [cell.userFrame sd_setImageWithURL:[NSURL URLWithString:lg.user.frameUrl]];
       
            cell.takeLGButton.hidden = NO;
            cell.giftTaken.hidden = YES;
            cell.noGift.hidden = YES;
            [cell.takeLGButton addTarget:self action:@selector(takeLuckyGiftGave:) forControlEvents:UIControlEventTouchUpInside];
            cell.takeLGButton.tag = indexPath.row;
        if (indexPath.row == allLuckyGiftsGave.luckyGiftsGave.count-1)
            cell.line.hidden = YES;
        else cell.line.hidden = NO;
        return cell;
    }else
    if (tableView==self.takeLGTableView){
          cellIdentifier =[NSString stringWithFormat:@"CellLGHistory"];// - %@",song.ids];
            
            LuckyGiftHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            LuckyGiftHistory * lg=[luckyGiftHistory.luckyGiftsHistory objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[LuckyGiftHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
        cell.userName.text = lg.user.name;
        [cell.userProfile sd_setImageWithURL:[NSURL URLWithString:lg.user.profileImageLink]];
        [cell.userFrame sd_setImageWithURL:[NSURL URLWithString:lg.user.frameUrl]];
        cell.timeTakeLG.text =[[LoadData2 alloc ] thoigianHourFir: lg.addTime];
            cell.giftTaken.hidden = NO;
            cell.noGift.hidden = NO;
            [cell.giftTaken sd_setImageWithURL:[NSURL URLWithString:lg.gift.url]];
            cell.noGift.text = [NSString stringWithFormat:@"x %@",lg.gift.noItem];
            cell.takeLGButton.hidden = YES;
        if (indexPath.row == allLuckyGiftsGave.luckyGiftsGave.count-1)
            cell.line.hidden = YES;
        else cell.line.hidden = NO;
        return cell;
    }else
    if (tableView==self.topUserWeekTableView){
          cellIdentifier =[NSString stringWithFormat:@"CellWeek"];// - %@",song.ids];
            
            UserCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            User * user=[listTopUserWeek objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[UserCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            if (user.location.length==0) {
                user.location=@"";
            }
        if (user.name.length==0) {
            user.name=@"Không xác định";
        }
            cell.nameGroup.text=[NSString stringWithFormat:@"%@", user.name ];
           
            cell.descriptionGroup.text=[NSString stringWithFormat:@"%@",user.location];
            cell.score.text=[NSString stringWithFormat:@"%@",[[LoadData2 alloc ] pretty:user.totalScore ]];
            cell.scoreIcon.hidden=NO;
            [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:user.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_mac_dinh_profile5.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
            if ([user.frameUrl isKindOfClass:[NSString class]]) {
                [cell.frameImage sd_setImageWithURL:[NSURL URLWithString:user.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
                cell.frameImage.hidden=NO;
            }else{
                cell.frameImage.hidden=YES;
            }
            NSInteger rank=indexPath.row+1;
            if (rank==1) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==2) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong2.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==3) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong3.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;//
            }else {
                cell.rankLabel.text=[NSString stringWithFormat:@"%d",rank];
                cell.rankBG.hidden=YES;//=[UIImage imageNamed:@"hang_xam.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
            if (user.gender.length>0){
                if ([user.gender isEqualToString:@"male"])
                    cell.genderImage.image=[UIImage imageNamed:@"Nam_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                else if ([user.gender isEqualToString:@"female"])  cell.genderImage.image=[UIImage imageNamed:@"Nu_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
        cell.thumbnail.layer.cornerRadius=cell.thumbnail.frame.size.height/2;
        cell.thumbnail.layer.masksToBounds=YES;
            cell.actionButton.tag=indexPath.row;
            [cell.actionButton addTarget:self action:@selector(selectedRowWeek:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        
    }else  if (tableView==self.topUserMonthTabelView){
        cellIdentifier =[NSString stringWithFormat:@"CellMonth"];// - %@",song.ids];
            
            UserCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            User * user=[listTopUserMonth objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[UserCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            if (user.location.length==0) {
                user.location=@"";
            }
        if (user.name.length==0) {
            user.name=@"Không xác định";
        }
            if ([user.frameUrl isKindOfClass:[NSString class]]) {
                [cell.frameImage sd_setImageWithURL:[NSURL URLWithString:user.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
                cell.frameImage.hidden=NO;
            }else{
                cell.frameImage.hidden=YES;
            }
        cell.nameGroup.text=[NSString stringWithFormat:@"%@", user.name ];
            cell.descriptionGroup.text=[NSString stringWithFormat:@"%@",user.location];
            cell.score.text=[NSString stringWithFormat:@"%@",[[LoadData2 alloc ] pretty:user.totalScore ]];
            cell.scoreIcon.hidden=NO;
            [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:user.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_mac_dinh_profile5.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
            
            NSInteger rank=indexPath.row+1;
            if (rank==1) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==2) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong2.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==3) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong3.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;//
            }else {
                cell.rankLabel.text=[NSString stringWithFormat:@"%d",rank];
                cell.rankBG.hidden=YES;//=[UIImage imageNamed:@"hang_xam.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
            if (user.gender.length>0){
                if ([user.gender isEqualToString:@"male"])
                    cell.genderImage.image=[UIImage imageNamed:@"Nam_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                else if ([user.gender isEqualToString:@"female"])  cell.genderImage.image=[UIImage imageNamed:@"Nu_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
        cell.thumbnail.layer.cornerRadius=cell.thumbnail.frame.size.height/2;
        cell.thumbnail.layer.masksToBounds=YES;
            cell.actionButton.tag=indexPath.row;
            [cell.actionButton addTarget:self action:@selector(selectedRowMonth:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        
    }else if (self.topUserDayTableView==tableView){
        cellIdentifier =[NSString stringWithFormat:@"CellDay"];// - %@",song.ids];
            
            UserCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            User * user=[listTopUserDay objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[UserCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            if (user.location.length==0) {
                user.location=@"";
            }
        if (user.name.length==0) {
            user.name=@"Không xác định";
        }
            cell.nameGroup.text=[NSString stringWithFormat:@"%@", user.name ];
           
            cell.descriptionGroup.text=[NSString stringWithFormat:@"%@",user.location];
            cell.score.text=[NSString stringWithFormat:@"%@",[[LoadData2 alloc ] pretty:user.totalScore ]];
            cell.scoreIcon.hidden=NO;
            [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:user.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_mac_dinh_profile5.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
            if ([user.frameUrl isKindOfClass:[NSString class]]) {
                [cell.frameImage sd_setImageWithURL:[NSURL URLWithString:user.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
                cell.frameImage.hidden=NO;
            }else{
                cell.frameImage.hidden=YES;
            }
            NSInteger rank=indexPath.row+1;
            if (rank==1) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong1.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==2) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong2.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;
            }else if (rank==3) {
                cell.rankBG.image=[UIImage imageNamed:@"HuyChuong3.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                cell.rankLabel.text=@"";
                cell.rankBG.hidden=NO;//
            }else {
                cell.rankLabel.text=[NSString stringWithFormat:@"%d",rank];
                cell.rankBG.hidden=YES;//=[UIImage imageNamed:@"hang_xam.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
            if (user.gender.length>0){
                if ([user.gender isEqualToString:@"male"])
                    cell.genderImage.image=[UIImage imageNamed:@"Nam_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
                else if ([user.gender isEqualToString:@"female"])  cell.genderImage.image=[UIImage imageNamed:@"Nu_48.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }
        cell.thumbnail.layer.cornerRadius=cell.thumbnail.frame.size.height/2;
        cell.thumbnail.layer.masksToBounds=YES;
            cell.actionButton.tag=indexPath.row;
            [cell.actionButton addTarget:self action:@selector(selectedRowDay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        
    }else
    if (tableView==self.tagUserTableView) {
        UserOnlineRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        User * userOnline=(User *)[tagUserList objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[UserOnlineRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.name.text = userOnline.name;
        //cell.noUserOnline.text =  [NSString stringWithFormat:@"%@  ",[[LoadData2 alloc ] pretty:userOnline.totalScore]];
        [cell.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:userOnline.profileImageLink]  placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
        cell.actionButton.tag = indexPath.row;
        [cell.actionButton addTarget:self action:@selector(selectTagUserCmt:) forControlEvents:UIControlEventTouchUpInside];
        cell.userType.hidden = NO;
        cell.noUserOnline.hidden = YES;
        cell.thumbnailImage.layer.cornerRadius = cell.thumbnailImage.frame.size.height/2;
        cell.thumbnailImage.layer.masksToBounds = YES;
        
       
            cell.nameCenterConstraints.constant = 0;
            cell.userType.hidden = YES;
        
        return cell;
    }else if (tableView==self.userOnlineTableView) {
        UserOnlineRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UserOnlineRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        }
        if (indexPath.row>=listUserOnline.count) {
            return cell;
        }
        User * userOnline=[listUserOnline objectAtIndex:indexPath.row];
        
        cell.name.text = userOnline.name;
		 cell.noUserOnline.text =  [NSString stringWithFormat:@"%@  ",[[LoadData2 alloc ] pretty:userOnline.totalScore]];
         [cell.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:userOnline.profileImageLink]  placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
           cell.actionButton.tag = indexPath.row;
           [cell.actionButton addTarget:self action:@selector(selectUserOnline:) forControlEvents:UIControlEventTouchUpInside];
        cell.userType.hidden = NO;
        cell.thumbnailImage.layer.cornerRadius = cell.thumbnailImage.frame.size.height/2;
        cell.thumbnailImage.layer.masksToBounds = YES;
        if ([userOnline.frameUrl isKindOfClass:[NSString class]]) {
            [cell.userFrame sd_setImageWithURL:[NSURL URLWithString:userOnline.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]options:SDWebImageRetryFailed];
            cell.userFrame.hidden=NO;
        }else{
            cell.userFrame.hidden=YES;
        }
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            if ([userOnline.roomUserType isEqualToString:@"OWNER"]) {
                cell.nameCenterConstraints.constant = -7;
                cell.userType.image = [UIImage imageNamed:@"ic_toctruong.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else if ([userOnline.roomUserType isEqualToString:@"ADMIN"]) {
                cell.nameCenterConstraints.constant = -7;
                cell.userType.image = [UIImage imageNamed:@"ic_tocpho.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else if ([userOnline.roomUserType isEqualToString:@"VIP"]) {
                cell.nameCenterConstraints.constant = -7;
                cell.userType.image = [UIImage imageNamed:@"ic_thanhvien.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else {
                cell.nameCenterConstraints.constant = 0;
                cell.userType.hidden = YES;
            }
        }else
        if ([userOnline.roomUserType isEqualToString:@"OWNER"]) {
            cell.nameCenterConstraints.constant = -7;
            cell.userType.image = [UIImage imageNamed:@"icn_owner_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }else if ([userOnline.roomUserType isEqualToString:@"ADMIN"]) {
            cell.nameCenterConstraints.constant = -7;
            cell.userType.image = [UIImage imageNamed:@"icn_admin_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }else if ([userOnline.roomUserType isEqualToString:@"VIP"]) {
            cell.nameCenterConstraints.constant = -7;
            cell.userType.image = [UIImage imageNamed:@"icn_vip_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        }else {
            cell.nameCenterConstraints.constant = 0;
            cell.userType.hidden = YES;
        }
        return cell;
    }else {
     CommentLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     RoomComment * cmt=[listComment objectAtIndex:indexPath.row];
     if (cell == nil) {
         cell = [[CommentLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.contentLabel.preferredMaxLayoutWidth=cell.contentLabel.frame.size.width;
         cell.contentLabel.numberOfLines=0;

     }
       
        cell.frameImage.hidden = YES;
      
		 cell.statusView.hidden = YES;
		 cell.ownerIcon.hidden = NO;
        cell.luckyGiftView.hidden = YES;
        
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            if ([cmt.userType isEqualToString:@"OWNER"]) {
                cell.messageLeftContrainst.constant = 65;
                cell.ownerIcon.image = [UIImage imageNamed:@"ic_toctruong.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else if ([cmt.userType isEqualToString:@"ADMIN"]) {
                cell.messageLeftContrainst.constant = 65;
                cell.ownerIcon.image = [UIImage imageNamed:@"ic_tocpho.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else if ([cmt.userType isEqualToString:@"VIP"]) {
                cell.messageLeftContrainst.constant = 65;
                cell.ownerIcon.image = [UIImage imageNamed:@"ic_thanhvien.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
            }else {
                cell.messageLeftContrainst.constant = 10;
                cell.ownerIcon.hidden = YES;
            }
        }else
		 if ([cmt.userType isEqualToString:@"OWNER"]) {
			 cell.messageLeftContrainst.constant = 65;
			 cell.ownerIcon.image = [UIImage imageNamed:@"icn_owner_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
		 }else if ([cmt.userType isEqualToString:@"ADMIN"]) {
			 cell.messageLeftContrainst.constant = 65;
			 cell.ownerIcon.image = [UIImage imageNamed:@"icn_admin_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
		 }else if ([cmt.userType isEqualToString:@"VIP"]) {
			 cell.messageLeftContrainst.constant = 65;
			 cell.ownerIcon.image = [UIImage imageNamed:@"icn_vip_type_user.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
		 }else {
			 cell.messageLeftContrainst.constant = 10;
			 cell.ownerIcon.hidden = YES;
		 }
        if (cmt.userName.length==0) {
            cmt.userName=@"Không xác định";
        }
		 cell.noticeLabelTitle.text = @"";
        cell.thumbnailButton.hidden = NO;
        cell.messageLabel.hidden = NO;
		 cell.messageLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        if ([cmt.roomType isEqualToString:@"LUCKYGIFT"]) {
            cell.luckyGiftView.hidden = NO;
            cell.statusView.hidden = YES;
            cell.messageLabel.hidden = YES;
            cell.backGroundView.hidden=NO;
            cell.statusMessageLabel.text = @"";
            cell.messageLabel.text = @"";
            [cell.thumnailImage sd_setImageWithURL:[NSURL URLWithString:cmt.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
            cell.backGroundView.backgroundColor = [UIColor clearColor];
            [cell.luckyGiftImage sd_setImageWithURL:[NSURL URLWithString:cmt.message] ];
        }else
		 if ([cmt.roomType isEqualToString:@"NOTICE"]) {
			  cell.messageLabel.textColor = UIColorFromRGB(0xF6EB53);
			  cell.messageLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
			  cell.statusMessageLabel.text = @"";
			  if ([self.liveroom.bulletin isKindOfClass:[NSString class]] && self.liveroom.bulletin.length>5) {
				   cell.messageLabel.text = self.liveroom.bulletin;
			  }else {
                  
                  cell.messageLabel.text = AMLocalizedString(@"Xin chào mừng bạn vào phòng. Hãy cư xử văn minh, lịch sự!", nil);
			  }
			  cell.noticeLabelTitle.text = AMLocalizedString(@"Thông báo", nil);
			  cell.thumnailImage.image = [UIImage imageNamed:@"new_notice.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
			  cell.statusView.hidden=YES;
			  cell.backGroundView.hidden=NO;
			   cell.messageLeftContrainst.constant = 10;
			  cell.ownerIcon.hidden = YES;
		
			  cell.backGroundView.backgroundColor = [UIColor clearColor];
		 }else  if ([cmt.roomType isEqualToString:GIFT]) {
			  cell.statusView.hidden = YES;
             cell.thumbnailButton.hidden = YES;
			  cell.statusMessageLabel.text = @"";
			  cell.backGroundView.hidden = NO;
			  cell.messageLabel.textColor = [UIColor blackColor];
			  cell.messageLabel.text = [NSString stringWithFormat:@"%@: %@",cmt.userName, cmt.message];
			  [cell.thumnailImage sd_setImageWithURL:[NSURL URLWithString:cmt.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
			  cell.backGroundView.backgroundColor = UIColorFromRGB(0xF1C69C);
		  }else if ([cmt.roomType isEqualToString:NOTIFICATION]) {
			   cell.statusView.hidden = NO;
			   cell.messageLabel.text = @"";
			   cell.backGroundView.hidden = YES;
			   cell.statusMessageLabel.text =[NSString stringWithFormat:@" %@  ", cmt.message];
		  }else {
			  cell.statusView.hidden = YES;
			   cell.statusMessageLabel.text = @"";
			   cell.backGroundView.hidden = NO;
			   cell.messageLabel.textColor = [UIColor whiteColor];
              if ([cmt.targetId isKindOfClass:[NSString class]]) {
                  if ([cmt.targetId isEqualToString:currentFbUser.facebookId]) {
                      NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: @%@ %@",cmt.userName,cmt.targetName, cmt.message] attributes:nil];
                      NSString * fS=[NSString stringWithFormat:@"%@: ",cmt.userName];
                      NSString * fS2=[NSString stringWithFormat:@" %@", cmt.message];
                      NSString * qRT=[NSString stringWithFormat:@"@%@",cmt.targetName];
                      
                      NSRange linkRange = NSMakeRange(fS.length, qRT.length); // for the word "link" in the string above
                     
                      NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0xFFA500),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] };
                      
                      [attributedString setAttributes:linkAttributes range:linkRange];
                      cell.messageLabel.attributedText = attributedString;
                     
                  }else {
                      NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: @%@ %@",cmt.userName,cmt.targetName, cmt.message] attributes:nil];
                      NSString * fS=[NSString stringWithFormat:@"%@: ",cmt.userName];
                      NSString * fS2=[NSString stringWithFormat:@" %@", cmt.message];
                      NSString * qRT=[NSString stringWithFormat:@"@%@",cmt.targetName];
                      
                      NSRange linkRange = NSMakeRange(fS.length, qRT.length); // for the word "link" in the string above
                      
                      NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0xFFFFFF),
                                                         NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] };
                      
                      [attributedString setAttributes:linkAttributes range:linkRange];
                      cell.messageLabel.attributedText = attributedString;
                  }
              }else
			   cell.messageLabel.text = [NSString stringWithFormat:@"%@: %@",cmt.userName, cmt.message];
			   [cell.thumnailImage sd_setImageWithURL:[NSURL URLWithString:cmt.userProfile] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
			   cell.backGroundView.backgroundColor = [UIColor clearColor];
		  }
        // cell.userNameTopMargin.constant=7;
        cell.statusButton.tag=indexPath.row;
         [cell.statusButton addTarget:self action:@selector(selectCmt:) forControlEvents:UIControlEventTouchUpInside];
         [cell.actionButton addTarget:self action:@selector(selectCmt:) forControlEvents:UIControlEventTouchUpInside];
     cell.thumnailButton.tag=indexPath.row;
     cell.actionButton.tag=indexPath.row;
		 cell.thumbnailButton.tag = indexPath.row;
		 [cell.thumbnailButton addTarget:self action:@selector(selectUserCmt:) forControlEvents:UIControlEventTouchUpInside];

		 cell.statusMessageView.layer.cornerRadius = 5;
			 cell.statusMessageView.layer.masksToBounds=YES;
		 cell.statusMessageLabel.layer.cornerRadius = 5;
		 cell.statusMessageLabel.layer.masksToBounds=YES;
		 cell.backGroundView.layer.cornerRadius = 5;
			 cell.backGroundView.layer.masksToBounds=YES;
    cell.thumnailImage.layer.cornerRadius = cell.thumnailImage.frame.size.height/2;
     cell.thumnailImage.layer.masksToBounds=YES;
     return cell;
    }
}

- (void) replyComment:(NSNotification *) noti{
    userReply = (User *)noti.object;
    if ([userReply.name isKindOfClass:[NSString class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentTextField setPlaceholder:[NSString stringWithFormat:@"Trả lời @%@",userReply.name]];
            self.cmtView.hidden = NO;
            [self.commentTextField becomeFirstResponder];
            
        });
    }
}
- (IBAction)selectTagUserCmt:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    User * userO=[tagUserList objectAtIndex:row];
   
    userO.roomUserActionType = currentFbUser.roomUserType;
    userO.roomId = liveRoomID;
    NSString * text =[NSString stringWithFormat:@"%@ %@ ", [self.commentTextField.text substringToIndex:showTagUserView],userO.name];
    
    self.commentTextField.text = text;
    self.tagUserTableView.hidden = YES;
    showTagUserView = 0;
}
- (IBAction)selectCmt:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (row==0) return;
    RoomComment * cmt=[listComment objectAtIndex:row];
    if ([cmt.roomType isEqualToString:@"LUCKYGIFT"]){
        luckyGiftGaveID = cmt.luckyGiftGaveId;
        luckyGiftGaveUserID = cmt.userId;
        self.takeLGTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì", cmt.userName];
        self.takeLGFirstTitle.text = [NSString stringWithFormat:@"%@ tặng lì xì", cmt.userName];
        [self.takeLGFirstUser sd_setImageWithURL:[NSURL URLWithString:cmt.userProfile]];
        self.gaveLuckyGiftView.hidden = NO;
        self.takeLuckyFirstView.hidden = NO;
        self.gaveLGInfoView.hidden = YES;
        self.takeLuckyGiftView.hidden = YES;
        self.takeLGFirstEmptyNotice.hidden = YES;
        self.takeLGInfoButton.hidden = YES;
        self.takeLGLoading.hidden = YES;
        self.takeLGFirstEmptyNotice.hidden = YES;
        self.takeLGInfoButton.hidden = YES;
        self.takeLGFirstButton.hidden = NO;
        
        if ([currentFbUser.facebookId isEqualToString:cmt.userId]){
            self.takeLGFirstFollow.hidden = YES;
            self.takeLGUserFollowButton.hidden = YES;
            self.takeLGFirstEmptyNotice.hidden = NO;
            self.takeLGFirstEmptyNotice.text = @"Bạn là người phát Lì xì này!";
            self.takeLGInfoButton.hidden = NO;
            self.takeLGFirstButton.hidden = YES;
        }else {
        dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
        
        dispatch_async(queue, ^{
        
            GetUserProfileResponse * userProfile = [[LoadData2 alloc ] GetUserProfile:currentFbUser.facebookId andOwnFacebookId:cmt.userId];
            if ([userProfile.user.friendStatus isEqualToString:@"FRIEND"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.takeLGFirstFollow.hidden = YES;
                    self.takeLGUserFollowButton.hidden = YES;
                });
               
            }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.takeLGFirstFollow.hidden = NO;
            self.takeLGUserFollowButton.hidden = NO;
            
        });
            }
            
        });
        }
    }else {
    User *userO = [User new];
    userO.roomUserActionType = currentFbUser.roomUserType;
    userO.roomId = liveRoomID;
    userO.uid = [NSNumber numberWithLong: cmt.userUid];
    userO.name = cmt.userName;
    userO.facebookId = cmt.userId;
    userO.roomUserType = cmt.userType;
    userO.profileImageLink = cmt.userProfile;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"replyCommentLive" object:userO];
    self.userOnlineSubView.hidden = YES;
    [UIView animateWithDuration: 1 animations:^{
        self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;
        
        
    } completion:^(BOOL finish){
        self.userOnlineSubView.hidden = YES;
        self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;
        
    }];
    }
}
- (IBAction)selectUserCmt:(id)sender{
	 UIButton *button = (UIButton *)sender;
	 NSInteger row = button.tag;
	   RoomComment * cmt=[listComment objectAtIndex:row];
    if (row==0) return;
	 User *userO = [User new];
	 userO.roomUserActionType = currentFbUser.roomUserType;
	 userO.roomId = liveRoomID;
	 userO.uid = [NSNumber numberWithLong: cmt.userUid];
	 userO.name = cmt.userName;
	 userO.facebookId = cmt.userId;
	  userO.roomUserType = cmt.userType;
	  userO.profileImageLink = cmt.userProfile;
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
        }else
	 [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];
    }
	 self.userOnlineSubView.hidden = YES;
	 [UIView animateWithDuration: 1 animations:^{
		  self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;


	 } completion:^(BOOL finish){
		  self.userOnlineSubView.hidden = YES;
		  self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;

	 }];
}
- (IBAction)showUserShowTimeInfo:(id)sender {
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userSinging.owner];
        }else
	 [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userSinging.owner];
    }
}

- (IBAction)selectedRowMonth:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (row>=listTopUserMonth.count) return;
   
    User *userO = [listTopUserMonth objectAtIndex:row];
    userO.roomUserActionType = currentFbUser.roomUserType;
    userO.roomId = liveRoomID;
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
        }else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = -self.topUserSubView.frame.size.height;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topUserView.hidden = YES;
    }];
}


- (IBAction)selectedRowWeek:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (row>=listTopUserWeek.count) return;
   
    User *userO = [listTopUserWeek objectAtIndex:row];
    userO.roomUserActionType = currentFbUser.roomUserType;
    userO.roomId = liveRoomID;
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
        }else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = -self.topUserSubView.frame.size.height;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topUserView.hidden = YES;
    }];
}


- (IBAction)selectedRowDay:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (row>=listTopUserDay.count) return;
    
    User *userO = [listTopUserDay objectAtIndex:row];
    userO.roomUserActionType = currentFbUser.roomUserType;
    userO.roomId = liveRoomID;
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
        }else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.topUserViewBottomContrainst.constant = -self.topUserSubView.frame.size.height;
        [self.topUserView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topUserView.hidden = YES;
    }];
}

- (IBAction)selectUserOnline:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (row>=listUserOnline.count) return;
    User *userO = [listUserOnline objectAtIndex:row];
	 userO.roomUserActionType = currentFbUser.roomUserType;
	 userO.roomId = liveRoomID;
    if (!isStartingLive){
        if ([self.liveroom.family isKindOfClass:[Family class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUserFamily" object:userO];
        }else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenuUser" object:userO];
    }
    self.userOnlineSubView.hidden = YES;
    [UIView animateWithDuration: 1 animations:^{
                 self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;


             } completion:^(BOOL finish){
                 self.userOnlineSubView.hidden = YES;
                 self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;

             }];
}
#pragma mark CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.sendLGCollectionView==collectionView) {

            return [allLuckyGiftRespone.luckyGifts count];
    }
    if (self.giftStoreViewCollectionView==collectionView) {

			 return [allGiftRespone.gifts count];
	 }
    if (self.userOnlineCollectionView==collectionView) {
	 NSUInteger count = [listUserOnline count];
	 if (count<10) {
		  count = 10;
	 }
    return count;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize size= CGSizeMake(30  , 30      );
    if (self.sendLGCollectionView==collectionView) {
        return  CGSizeMake(310, 430);
    }
	 if (self.giftStoreViewCollectionView==collectionView) {
			int num=self.giftStoreViewCollectionView.frame.size.width/100;
			return CGSizeMake(self.giftStoreViewCollectionView.frame.size.width/num , 100      );
		}
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sendLGCollectionView==collectionView) {
        NSString *identifier2 = @"CellLG";

       LuckyGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
        
        LuckyGift *luckygift=[allLuckyGiftRespone.luckyGifts objectAtIndex:indexPath.row];

        cell.name.text = luckygift.name;
        cell.descript.text = [luckygift.descript stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        [cell.lgBackground sd_setImageWithURL:[NSURL URLWithString:luckygift.backgroundUrl] placeholderImage:[UIImage imageNamed:@"ic_LG_bg_red.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] ];
        cell.price.text = [NSString stringWithFormat:@"Tổng gói quà tốn: %d",luckygift.buyPrice];
        cell.gifts = luckygift.gifts;
        cell.giftTableView.hidden =NO;
        [cell.giftTableView reloadData];
        cell.titleLabel.text = luckygift.title;
        
       return cell;
    }else
	  if (self.giftStoreViewCollectionView==collectionView) {
		  NSString *identifier2 = @"Cell3";

		 GiftCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
          Gift *gift=[allGiftRespone.gifts objectAtIndex:indexPath.row];
          if ([gift.type isEqualToString:@"LG"]) {
              
              cell.giftImage.image = [UIImage imageNamed:@"ic_LG.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
              cell.iCoinImage.hidden = YES;
              cell.giftNoItems.hidden = YES;
             // cell.actionButton.tag=indexPath.row;
              //[cell.actionButton addTarget:self action:@selector(buyLuckyGift:) forControlEvents:UIControlEventTouchUpInside];
          }else {
              cell.giftNoItems.hidden = NO;
              cell.iCoinImage.hidden = NO;
		 //cell.imageV.layer.borderColor=[[UIColor redColor] CGColor];
		 // cell.imageV.layer.borderWidth=1;
		 
              [cell.giftImage sd_setImageWithURL:[NSURL URLWithString:gift.url] placeholderImage:nil ];
		 
		 cell.giftNoItems.text=[NSString stringWithFormat:@"%d",[gift.buyPrice integerValue]];
          }
		 if ([gift.giftId isEqualToString:selectedGift.giftId]) {
			 cell.background.hidden=NO;
            
             cell.giftName.text=gift.name;
             cell.giftNameHeight.constant = 15;
             cell.giftImageWidth.constant = 50;
		 }else{
             cell.giftNameHeight.constant = 0;
             cell.giftImageWidth.constant = 40;
             cell.giftName.text = @"";
			 cell.background.hidden=YES;
		 }
          if ([gift.type isEqualToString:@"LG"]) {
              cell.giftName.text=gift.name;
              cell.giftNameHeight.constant = 15;
              cell.giftImageWidth.constant = 50;
          }
          if ([gift.type isEqualToString:GIFT_TYPE_ANIMATED]){
              cell.giftType.hidden = NO;
              cell.giftType.text = @"Động";
              cell.giftType.backgroundColor = UIColorFromRGB(HeaderColor);
          }else if ([gift.type isEqualToString:@"COMBO"]){
              cell.giftType.hidden = NO;
              cell.giftType.text = @"Combo";
              cell.giftType.backgroundColor = UIColorFromRGB(HeaderColor);//0xF1C69C
          }else {
              cell.giftType.hidden = YES;
          }
          if ([gift.tag isEqualToString:GIFT_TAG_NEW]){
              cell.giftTag.hidden = NO;
          }else if ([gift.tag isEqualToString:GIFT_TAG_EVENT]){
              cell.giftTag.hidden = NO;
          }else {
              cell.giftTag.hidden = YES;
          }
		 cell.background.layer.cornerRadius=5;
		 cell.background.layer.masksToBounds=YES;
          cell.giftType.layer.cornerRadius=cell.giftType.frame.size.height/2;
          cell.giftType.layer.masksToBounds=YES;
		// cell.background.layer.borderColor=[UIColorFromRGB(0xFFD479) CGColor];//0xFFD479
		 //cell.background.layer.borderWidth=1;
		
              cell.actionButton.tag=indexPath.row;
              [cell.actionButton addTarget:self action:@selector(selectGift:) forControlEvents:UIControlEventTouchUpInside];
          
		
           //  [cell layoutIfNeeded];
		 return cell;
      }else  if (self.userOnlineCollectionView ==collectionView)  {
         NSString *identifier2 = @"Cell4";

        UserOnlineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];

        //cell.imageV.layer.borderColor=[[UIColor redColor] CGColor];
        // cell.imageV.layer.borderWidth=1;
          NSLog(@"row %d",indexPath.row);
		   if (indexPath.row>=listUserOnline.count) {
				cell.thumnailImage.image =[UIImage imageNamed:@"ic_sofafull.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
               cell.thumnailImage.hidden = YES;
               cell.ic_sofa.hidden = NO;
				cell.point.hidden = YES;
               cell.frameImage.hidden = YES;
               cell.actionButton.hidden = YES;
		   }else {
				cell.point.hidden = NO;
        User *userG=[listUserOnline objectAtIndex:indexPath.row];
               NSLog(@"%@ %d",userG.name,indexPath.row);
	 cell.point.text = [NSString stringWithFormat:@"%@  ",[[LoadData2 alloc ] pretty:userG.totalScore]] ;
               cell.frameImage.hidden = YES;
              /* if ([userG.frameUrl isKindOfClass:[NSString class]]){
                   cell.frameImage.hidden = NO;
                   [cell.frameImage sd_setImageWithURL:[NSURL URLWithString:userG.frameUrl] placeholderImage:[UIImage imageNamed:@"khungVip.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
               }else {
                   cell.frameImage.hidden = YES;
               }*/
               cell.thumnailImage.hidden = NO;
               cell.ic_sofa.hidden = YES;
               cell.actionButton.hidden = NO;
        [cell.thumnailImage sd_setImageWithURL:[NSURL URLWithString:userG.profileImageLink] placeholderImage:[UIImage imageNamed:@"icn_nguoi_dung_md.png"  inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageRefreshCached];
    cell.actionButton.tag = indexPath.row;
    [cell.actionButton addTarget:self action:@selector(selectUserOnline:) forControlEvents:UIControlEventTouchUpInside];
				//cell.thumnailImage.layer.cornerRadius=cell.thumnailImage.frame.size.width/2;
				//cell.thumnailImage.layer.masksToBounds=YES;
				//[cell layoutIfNeeded];
		   }
        //}
        return cell;
	  }
    return nil;
}
- (IBAction)hideOnlineTableView:(id)sender {
    [UIView animateWithDuration: 1 animations:^{
              self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;


          } completion:^(BOOL finish){
              self.userOnlineSubView.hidden = YES; self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;

          }];
}
- (IBAction)buyLuckyGift:(id)sender{
    
    self.sendLuckyGiftView.hidden = NO;
    [self.sendLGCollectionView reloadData];
    
}
- (IBAction)selectGift:(id)sender{
    UIButton *btn=(UIButton *) sender;
    NSInteger row=btn.tag;
    selectedGift=[allGiftRespone.gifts objectAtIndex:row];
    sendGiftRequest.comboId = nil;
    timeGiftCombo= 0;
    self.giftBuyComboView.hidden = YES;
    self.giftBuyComboButton.hidden = YES;
    
    
    self.giftBuyComboView.hidden = YES;
    self.giftBuyComboButton.hidden = YES;
    self.giftStoreViewBuyButton.hidden = NO;
    if ([selectedGift.type isEqualToString:@"LG"]) {
        if (allLuckyGiftRespone.luckyGifts.count==0){
            [[[[iToast makeText:AMLocalizedString(@"Quà lì xì chưa có", nil)]
                        setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else {
        selectedLuckyGift = [allLuckyGiftRespone.luckyGifts objectAtIndex:0];
        self.sendLGPageControl.currentPage = 0;
        self.sendLGPageControl.numberOfPages = [allLuckyGiftRespone.luckyGifts count];
        self.giftView.hidden = YES;
        self.sendLuckyGiftView.hidden = NO;
            [self.sendLGCollectionView setContentOffset:CGPointMake(0, 0)];
        [self.sendLGCollectionView reloadData];
        }
        self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"Gửi lì xì cho mọi người trong phòng"];

    }else
    self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
    [self.giftStoreViewCollectionView reloadData];
    
}
- (void)getAllGifts{
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);

    dispatch_async(queue, ^{
        allGiftRespone= [[LoadData2 alloc ] GetAllGifts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (allGiftRespone.gifts.count>0){
                selectedGift=[allGiftRespone.gifts objectAtIndex:0];
                self.giftViewLevelExpLabel.text = [NSString stringWithFormat:@"+%d kinh nghiệm sau khi tặng quà",selectedGift.score];
            }
           
            [self.giftStoreViewCollectionView reloadData];

        });
        allLuckyGiftRespone = [[LoadData2 alloc ] GetAllLuckyGifts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sendLGCollectionView reloadData];

        });
       
    });
}
- (void)sendLGpageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.sendLGCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.sendLGCollectionView setContentOffset:scrollTo animated:YES];
}
- (void)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.giftStoreViewCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.giftStoreViewCollectionView setContentOffset:scrollTo animated:YES];
}
- (IBAction)showOnlineTableView:(id)sender{
    self.userOnlineSubView.hidden = NO;
    [self.userOnlineTableView reloadData];
    self.noUserOnlineLabel.text = [NSString stringWithFormat:@"%lu Online",(unsigned long)listUserOnline.count];
    self.onlineSubViewLeftConstraint.constant = self.view.frame.size.width;
    [UIView animateWithDuration: 1 animations:^{
           self.onlineSubViewLeftConstraint.constant = 0;


       } completion:^(BOOL finish){
           self.onlineSubViewLeftConstraint.constant = 0;

       }];
}
- (CMTime)playerVideoDuration
{
    
    AVPlayerItem *thePlayerItem ;
   
        thePlayerItem= [playerVideo currentItem];
    
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
        {
        
        CMTime itemDuration = [thePlayerItem duration];
        if (CMTimeGetSeconds( itemDuration)>1260 ) {
            itemDuration=CMTimeMakeWithSeconds(1260, NSEC_PER_SEC);
        }
     
        return(itemDuration);
        }
    
    return(kCMTimeInvalid);
  
}
- (void)loadVideoLazy:(NSNotification *)object{
    NSString* urlL = (NSString* )object.object;
    
    [NSThread detachNewThreadSelector:@selector(loadVideo:) toTarget:self withObject:[NSString stringWithFormat:@"%@",urlL]];
}
- (void)loadVideo:(NSString *)urlL
{
    @autoreleasepool {
        NSLog(@"loadVideo: %@",urlL);
        urlVideoMp4 = urlL;
    /* Has the user entered a movie URL? */
    if (urlL.length > 0 )
    {
        NSError *sessionError = nil;
        //  [[AVAudioSession sharedInstance] setDelegate: self];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];

        NSURL *newMovieURL = [NSURL URLWithString:urlL];
        if ([newMovieURL scheme])	/* Sanity check on the URL. */
        {
            /*
             Create an asset for inspection of a resource referenced by a given URL.
             Load the values for the asset keys "tracks", "playable".
             */
            AVURLAsset* assetLoadmovie1 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];

            NSArray *requestedKeys = [NSArray arrayWithObjects:@"tracks", @"playable", nil];

            /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
            [assetLoadmovie1 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
             ^{
                 dispatch_async( dispatch_get_main_queue(),
                                ^{
                                    /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */

								   [self prepareToPlayAsset:assetLoadmovie1 withKeys:requestedKeys];


                     playerVideo.muted = YES;





                                });
             }];

        }
    }
    }
}
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

  //  self.playerLayerView.playerLayer.hidden = NO;
    //[self.playerLayerView.playerLayer setPlayer:playerVideo];

    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (playerItem)
    {
        /* Remove existing player item key value observers and notifications. */

         [playerItem removeObserver:self forKeyPath:@"status" context:PlayLiveStreamViewControllerPlayerItemStatusObserverContext];
   
       /*  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:AVPlayerItemDidPlayToEndTimeNotification
                                                 object:playerItem];*/
    }

    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem = [AVPlayerItem playerItemWithAsset:asset];

    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:PlayLiveStreamViewControllerPlayerItemStatusObserverContext];
   
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */


    seekToZeroBeforePlay1 = NO;

    /* Create new player, if we don't already have one. */


    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=playerVideo.currentItem;
    if (item != playerItem)
    {
       // [item.asset cancelLoading];
       // [item cancelPendingSeeks ];
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/

      //  playerVideo=nil;
        
    
        [playerVideo replaceCurrentItemWithPlayerItem:playerItem];
   
        item=nil;

    }
  
    /* At this point we're ready to set up for playback of the asset. */

   // [self initScrubberTimer];
    //[self enableScrubber];
   // [self enablePlayerButtons];

}
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLive" object:nil];
    playerVideo=[AVPlayer new];
    if (playerItem)
        {
        /* Remove existing player item key value observers and notifications. */
        
        [playerItem removeObserver:self forKeyPath:@"status" context:PlayLiveStreamViewControllerPlayerItemStatusObserverContext];
        playerItem = nil;
        /*  [[NSNotificationCenter defaultCenter] removeObserver:self
         name:AVPlayerItemDidPlayToEndTimeNotification
         object:playerItem];*/
        }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{

    /* AVPlayerItem "status" property value observer. */


    if (context == PlayLiveStreamViewControllerPlayerItemStatusObserverContext)
    {

        //[self syncPlayPauseButtons];

        NSLog(@"change status player");
        AVPlayerStatus status =(AVPlayerStatus) [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
               /* [self removePlayerTimeObserver];
                [self syncScrubber];

                [self disableScrubber];
                [self disablePlayerButtons];*/
            }

                break;

            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */


			//	   [self startAudiEngine];
			// [self performSelectorOnMainThread:@selector(startAudiEngine) withObject:nil waitUntilDone:NO];
           
			
				  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"startAudiEngine" object:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
				  playerVideo.muted = YES;
				 
					//self.playerLayerView.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                [self.playerLayerView.playerLayer setPlayer:playerVideo ];
                 
				  NSLog(@"%f %f",self.playerLayerView.playerLayer.videoRect.size.width,self.playerLayerView.playerLayer.videoRect.size.height);
				   
                
        });
         


			// [playerVideo seekToTime:CMTimeMakeWithSeconds(audioEngine3.player.currentTime, NSEC_PER_SEC)];




                // }

            }





                break;

            case AVPlayerStatusFailed:
            {
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];

            }
                break;

        }

    }else if (context == PlayLiveStreamViewControllerPlayerItemRateObserverContext)
        {
     
            NSLog(@"change rate player");
        
        }

    /* AVPlayer "rate" property value observer. */

    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */


    /* Observe the AVPlayer "currentItem.timedMetadata" property to parse the media stream
     timed metadata. */

    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }

    return;
}
- (IBAction)clickButtonSendComment:(id)sender {
}
@end

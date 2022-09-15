/*
 Copyright (C) 2019 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates converting audio using ExtAudioFile.
 */

#import "ExtendedAudioFileConvertOperation2.h"
#import "SoxEffects.h"
#import "LocalizationSystem.h"
@import Darwin;
@import AVFoundation;

#pragma mark- Convert
// our own error code when we cannot continue from an interruption
enum {
    kMyAudioConverterErr_CannotResumeFromInterruptionError = 'CANT'
};

typedef NS_ENUM(NSInteger, AudioConverterState) {
    AudioConverterStateInitial,
    AudioConverterStateRunning,
    AudioConverterStatePaused,
    AudioConverterStateDone
};

@interface ExtendedAudioFileConvertOperation2 ()

// MARK: Properties

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) AudioConverterState state;

@property (nonatomic) int echo; // [0 .. 100]
@property (nonatomic) int bass; // [-100 .. 100]
@property (nonatomic) int treble; // [-100 .. 100]

@property (nonatomic, assign) int volumeVideo;

@property (nonatomic, assign) int volumeAudio;

@property (nonatomic, assign) int delay;

@property (nonatomic, strong) SoxEffects *effects;


@end

@implementation ExtendedAudioFileConvertOperation2

// MARK: Initialization

- (instancetype)initWithSourceURL:(NSURL *)sourceURL destinationURL:(NSURL *)destinationURL sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat {
    
    if ((self = [super init])) {
        _sourceURL = sourceURL;
        _destinationURL = destinationURL;
        _sampleRate = sampleRate;
        _outputFormat = outputFormat;
        _state = AudioConverterStateInitial;
        
        _queue = dispatch_queue_create("com.example.apple-samplecode.ExtendedAudioFileConvertTest.ExtendedAudioFileConvertOperation.queue", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(0);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    
    return self;
}
- (instancetype)initWithSourceURL:(NSURL *)sourceURL sourceUrl2:(NSURL *)sourceURL2  sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat {
    
    if ((self = [super init])) {
        _sourceURL = sourceURL;
        _sourceURL2 = sourceURL2;
        NSString * mp3Path=[sourceURL.path stringByReplacingCharactersInRange:NSMakeRange(sourceURL.path.length-3, 3) withString:@"mp3"];
        _mp3URL=[NSURL fileURLWithPath:mp3Path];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *destinationFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Output.caf"]];
        _destinationURL = [NSURL fileURLWithPath:destinationFilePath];
        NSString * mp4Path=[sourceURL.path stringByReplacingCharactersInRange:NSMakeRange(sourceURL.path.length-3, 3) withString:@"mp4"];
        _mp4URL=[NSURL fileURLWithPath:mp4Path];
        _sampleRate = sampleRate;
        _outputFormat = outputFormat;
        _state = AudioConverterStateInitial;
        _volumeAudio=100;
        _volumeVideo=100;
        _delay=0;//297
        _queue = dispatch_queue_create("com.example.apple-samplecode.ExtendedAudioFileConvertTest.ExtendedAudioFileConvertOperation.queue", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(0);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    
    return self;
}


-(void) setEffect:(int)echo andBass:(int)bass andTreble:(int) treble andDelay:(int)delay{
    self.echo=echo;
    self.bass=bass;
    self.treble=treble;
    self.effects=[[SoxEffects alloc] initWithSoxEffects:echo Bass:bass Treble:treble];
    self.delay=delay;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    mixOfflineProssesing=NO;
}
-(void)getAudioFromVideo {
    
    float startTime = 0;
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *videoUrl =[NSURL fileURLWithPath: self.sourceURL.path];
    NSString *audioPath = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp.m4a"]];
    AVAsset *myasset;
    
    myasset = [AVAsset assetWithURL:self.sourceURL];
    CMTime audioDuration = myasset.duration;
    float endTime = CMTimeGetSeconds(audioDuration);
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
            mixOfflineProssesing=NO;
        }
        else {
            self.sourceURL=[NSURL fileURLWithPath:audioPath];
            if (![self mixAndConvert]){
                [self mergeAndSave: [[AVURLAsset alloc]initWithURL:videoUrl options:nil]];
            }else{
                mixOfflineProssesing=NO;
            }
            mixOfflineMessage=AMLocalizedString(@"Hoàn tất", nil);
        }
    }];
}
-(void)mergeAndSave:(AVURLAsset *)videoAsset
{
    mixOfflineMessage=AMLocalizedString(@"Nén hình ảnh bài thu…", nil);
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //Now first load your audio file using AVURLAsset. Make sure you give the correct path of your videos.
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:self.mp3URL options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    
    //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we will load video file.
    
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
    
    //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //decide the path where you want to store the final video created with audio and video merge.
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.mp4URL.path])
        [[NSFileManager defaultManager] removeItemAtPath:self.mp4URL.path error:nil];
    
    //Now create an AVAssetExportSession object that will save your final video at specified path.
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType =AVFileTypeMPEG4;
    _assetExport.outputURL = self.mp4URL;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         if (_assetExport.status==AVAssetExportSessionStatusFailed) {
             NSLog(@"mix video failed");
             mixOfflineProssesing=NO;
         }
         else {
             NSLog(@"mix video sussece");
             if ([self.delegate respondsToSelector:@selector(audioFileConvertOperation:didCompleteWithURL:)]) {
                 [self.delegate audioFileConvertOperation:self didCompleteWithURL:self.mp4URL];
             }
             mixOfflineProssesing=NO;
         }
     }
     ];
}
- (void)main {
    [super main];
    
    // This should never run on the main thread.
    assert(![NSThread isMainThread]);
    
    // Set the state to running.
    
    
    if ([self.sourceURL.path hasSuffix:@"mov"] && NO) {
        [self getAudioFromVideo];
    }else{
        if (![self mixAndConvert]) {
            if ([self.delegate respondsToSelector:@selector(audioFileConvertOperation:didCompleteWithURL:)]) {
                [self.delegate audioFileConvertOperation:self didCompleteWithURL:self.mp3URL];
            }
            mixOfflineProssesing=NO;
        }
        
        
        
    }
    // Set the state to done.
    
    
    
}
NSString *mixOfflineMessage;
- (BOOL) mixAndConvert{
    __weak __typeof__(self) weakSelf = self;
    mixOfflineMessage=AMLocalizedString(@"Nén âm thanh bài thu…", nil);
    dispatch_sync(self.queue, ^{
        weakSelf.state = AudioConverterStateRunning;
    });
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;   // GIVE YOUR SAMPLING RATE
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mBitsPerChannel = sizeof(float) * 8;
    audioFormat.mChannelsPerFrame = 2; // Mono
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * sizeof(float);  // == sizeof(Float32)
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame; // = sizeof(Float32)
    // Get the source files.
    ExtAudioFileRef sourceFile = 0;
    ExtAudioFileRef sourceFile2 = 0;
    
    if (![self checkError:ExtAudioFileOpenURL((__bridge CFURLRef _Nonnull)(self.sourceURL), &sourceFile) withErrorString:[NSString stringWithFormat:@"ExtAudioFileOpenURL failed for sourceFile with URL: %@", self.sourceURL]]) {
        return YES;
    }
    
    if (![self checkError:ExtAudioFileOpenURL((__bridge CFURLRef _Nonnull)(self.sourceURL2), &sourceFile2) withErrorString:[NSString stringWithFormat:@"ExtAudioFileOpenURL failed for sourceFile with URL: %@", self.sourceURL2]]) {
        return YES;
    }
    // Get the source data format.
    AudioStreamBasicDescription sourceFormat = {};
    UInt32 size = sizeof(sourceFormat);
    
    AudioStreamBasicDescription sourceFormat2 = {};
    UInt32 size2 = sizeof(sourceFormat2);
    
    if (![self checkError:ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileDataFormat, &size, &sourceFormat) withErrorString:@"ExtAudioFileGetProperty couldn't get the source data format"]) {
        return YES;
    }
    if (![self checkError:ExtAudioFileGetProperty(sourceFile2, kExtAudioFileProperty_FileDataFormat, &size2, &sourceFormat2) withErrorString:@"ExtAudioFileGetProperty couldn't get the source data format"]) {
        return YES;
    }
    // Setup the output file format.
    //sourceFormat.mFormatFlags=kAudioFormatFlagIsFloat;
    //sourceFormat2.mFormatFlags=kAudioFormatFlagIsFloat;
    AudioStreamBasicDescription destinationFormat = {};
    destinationFormat.mSampleRate = (self.sampleRate == 0 ? sourceFormat.mSampleRate : self.sampleRate);
    AudioStreamBasicDescription mp3Format = {};
    mp3Format.mSampleRate = (self.sampleRate == 0 ? sourceFormat.mSampleRate : self.sampleRate);
    ExtAudioFileRef mp3File = 0;
    if (self.outputFormat == kAudioFormatLinearPCM ) {
        // If the output format is PCM, create a 16-bit file format description.
        mp3Format.mFormatID = kAudioFormatMPEGLayer3;
        mp3Format.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
        //destinationFormat.mBitsPerChannel = sizeof(float) * 8;
        
        //destinationFormat.mFramesPerPacket = 1;
        //destinationFormat.mBytesPerPacket = destinationFormat.mFramesPerPacket * destinationFormat.mBytesPerFrame;
        // destinationFormat.mBytesPerFrame = destinationFormat.mChannelsPerFrame * sizeof(float);  // == sizeof(Float32)
        mp3Format.mFormatFlags = kAudioFormatFlagIsFloat;//kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger; // little-endian
        NSMutableDictionary *dictAudioQuality =[[NSMutableDictionary alloc]init];
        [dictAudioQuality setValue:@"High" forKey:@"audioquality"];
        [dictAudioQuality setValue:@"44100" forKey:@"samplerate"];
        [dictAudioQuality setValue:@"24" forKey:@"bitdepth"];
        [dictAudioQuality setValue:@"320" forKey:@"bitrate"];
        [dictAudioQuality setValue:@"2" forKey:@"channel"];
        AVAudioFormat *mp3Form=[[AVAudioFormat alloc] initWithCommonFormat:kLinearPCMFormatFlagIsSignedInteger sampleRate:44100 channels:2 interleaved:YES];
        
        /*if (![self checkError:ExtAudioFileCreateWithURL((__bridge CFURLRef _Nonnull)(self.mp3URL), kAudioFileCAFType, mp3Form.streamDescription, NULL, kAudioFileFlags_EraseFile, &mp3File) withErrorString:@"ExtAudioFileCreateWithURL MP3 failed!"]) {
            return YES;
        }*/
    } else {
        // This is a compressed format, need to set at least format, sample rate and channel fields for kAudioFormatProperty_FormatInfo.
        destinationFormat.mFormatID = self.outputFormat;
        
        // For iLBC, the number of channels must be 1.
        destinationFormat.mChannelsPerFrame = (self.outputFormat == kAudioFormatiLBC ? 1 : sourceFormat.mChannelsPerFrame);
        
        // Use AudioFormat API to fill out the rest of the description.
        size = sizeof(destinationFormat);
        if (![self checkError:AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &size, &destinationFormat) withErrorString:@"AudioFormatGetProperty couldn't fill out the destination data format"]) {
            return YES;
        }
    }
    destinationFormat=audioFormat;
    printf("Source file format:\n");
    [ExtendedAudioFileConvertOperation2 printAudioStreamBasicDescription:sourceFormat];
    printf("Destination file format:\n");
    [ExtendedAudioFileConvertOperation2 printAudioStreamBasicDescription:destinationFormat];
    
    // Create the destination audio file.
    ExtAudioFileRef destinationFile = 0;
    if (![self checkError:ExtAudioFileCreateWithURL((__bridge CFURLRef _Nonnull)(self.destinationURL), kAudioFileCAFType, &destinationFormat, NULL, kAudioFileFlags_EraseFile, &destinationFile) withErrorString:@"ExtAudioFileCreateWithURL failed!"]) {
        return YES;
    }
    
    /*
     set the client format - The format must be linear PCM (kAudioFormatLinearPCM)
     You must set this in order to encode or decode a non-PCM file data format
     You may set this on PCM files to specify the data format used in your calls to read/write
     */
    AudioStreamBasicDescription clientFormat;
    if (self.outputFormat == kAudioFormatLinearPCM) {
        clientFormat = audioFormat;
    } else {
        
        clientFormat.mFormatID = kAudioFormatLinearPCM;
        UInt32 sampleSize = sizeof(Float32);
        clientFormat.mFormatFlags = kAudioFormatFlagIsFloat;//kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
        clientFormat.mBitsPerChannel = 8 * sampleSize;
        clientFormat.mChannelsPerFrame = sourceFormat.mChannelsPerFrame;
        clientFormat.mFramesPerPacket = 1;
        clientFormat.mBytesPerPacket = clientFormat.mBytesPerFrame = sourceFormat.mChannelsPerFrame * sampleSize;
        clientFormat.mSampleRate = sourceFormat.mSampleRate;
    }
    
    printf("Client file format:\n");
    [ExtendedAudioFileConvertOperation2 printAudioStreamBasicDescription:clientFormat];
    
    size = sizeof(clientFormat);
    if (![self checkError:ExtAudioFileSetProperty(sourceFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat) withErrorString:@"Couldn't set the client format on the source file!"]) {
        return YES;
    }
    
    size = sizeof(clientFormat);
    if (![self checkError:ExtAudioFileSetProperty(sourceFile2, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat) withErrorString:@"Couldn't set the client format on the source  2 file!"]) {
        return YES;
    }
    
    size = sizeof(destinationFormat);
    if (![self checkError:ExtAudioFileSetProperty(destinationFile, kExtAudioFileProperty_ClientDataFormat, size, &destinationFormat) withErrorString:@"Couldn't set the client format on the destination file!"]) {
        return YES;
    }
    
    /* size = sizeof(mp3File);
     if (![self checkError:ExtAudioFileSetProperty(mp3File, kExtAudioFileProperty_ClientDataFormat, size, &mp3Format) withErrorString:@"Couldn't set the client format on the destination file!"]) {
     return;
     }*/
    // Get the audio converter.
    AudioConverterRef converter = 0;
    
    size = sizeof(converter);
    if (![self checkError:ExtAudioFileGetProperty(destinationFile, kExtAudioFileProperty_AudioConverter, &size, &converter) withErrorString:@"Failed to get the Audio Converter from the destination file."]) {
        return YES;
    }
    
    /*
     Can the Audio Converter resume after an interruption?
     this property may be queried at any time after construction of the Audio Converter (which in this case is owned by an ExtAudioFile object) after setting its output format
     there's no clear reason to prefer construction time, interruption time, or potential resumption time but we prefer
     construction time since it means less code to execute during or after interruption time.
     */
    BOOL canResumeFromInterruption = YES;
    UInt32 canResume = 0;
    size = sizeof(canResume);
    OSStatus error = AudioConverterGetProperty(converter, kAudioConverterPropertyCanResumeFromInterruption, &size, &canResume);
    
    if (error == noErr) {
        /*
         we recieved a valid return value from the GetProperty call
         if the property's value is 1, then the codec CAN resume work following an interruption
         if the property's value is 0, then interruptions destroy the codec's state and we're done
         */
        
        if (canResume == 0) {
            canResumeFromInterruption = NO;
        }
        
        printf("Audio Converter %s continue after interruption!\n", (!canResumeFromInterruption ? "CANNOT" : "CAN"));
        
    } else {
        /*
         if the property is unimplemented (kAudioConverterErr_PropertyNotSupported, or paramErr returned in the case of PCM),
         then the codec being used is not a hardware codec so we're not concerned about codec state
         we are always going to be able to resume conversion after an interruption
         */
        
        if (error == kAudioConverterErr_PropertyNotSupported) {
            printf("kAudioConverterPropertyCanResumeFromInterruption property not supported - see comments in source for more info.\n");
            
        } else {
            printf("AudioConverterGetProperty kAudioConverterPropertyCanResumeFromInterruption result %d, paramErr is OK if PCM\n", (int)error);
        }
        
        error = noErr;
    }
    
    // Setup buffers
    UInt32 bufferByteSize =4096* sizeof(float);
    char sourceBuffer[bufferByteSize];
    char sourceBuffer2[bufferByteSize];
    /*
     keep track of the source file offset so we know where to reset the source for
     reading if interrupted and input was not consumed by the audio converter
     */
    SInt64 sourceFrameOffset = 0;
    
    // Do the read and write - the conversion is done on and by the write call.
    printf("Converting...\n");
    SInt64 delay=self.delay*44.1;
    if (delay>0) {
        if (![self checkError:ExtAudioFileSeek(sourceFile,delay) withErrorString:@"ExtAudioFileSeek failed!"]) {
            return YES;
        }
    }else{
        if (![self checkError:ExtAudioFileSeek(sourceFile2,-delay) withErrorString:@"ExtAudioFileSeek failed!"]) {
            return YES;
        }
    }
    /*
    
    lame_t lame = lame_init();
    lame_set_in_samplerate(lame, 44100);
    lame_set_VBR(lame, vbr_default);
    lame_set_num_channels(lame, 2);
    lame_init_params(lame);
    */
    NSString* mp3path = [self.mp3URL.path stringByReplacingOccurrencesOfString:@"caf" withString:@"mp3"];
    //FILE *pcm=fopen([self.destinationURL.path UTF8String], "rb");
    FILE *mp3=fopen([mp3path UTF8String], "wb");
    const int MP3_SIZE = 4096*10;
    const int PCM_SIZE = 4096*10;
    float*  pcm_buffer = (float *)malloc(PCM_SIZE * 2 * sizeof(float));
    unsigned char * mp3_buffer= (unsigned char *)malloc(PCM_SIZE  * sizeof(unsigned char));
    int total = 0;
    int write  = 0;
    int read = 0;
    int dem=0;
    SInt64 totalFrames = -1;
    UInt32 dataSize = sizeof(totalFrames);
    
    OSStatus result = ExtAudioFileGetProperty(sourceFile, kExtAudioFileProperty_FileLengthFrames, &dataSize, &totalFrames);
    if(noErr != result)
        NSLog(@"Unable to determine total frames");
    while (YES) {
        dem++;
        // Set up output buffer list.
        AudioBufferList fillBufferList = {};
        fillBufferList.mNumberBuffers = 1;
        fillBufferList.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
        fillBufferList.mBuffers[0].mDataByteSize = bufferByteSize;
        fillBufferList.mBuffers[0].mData = sourceBuffer;
        
        AudioBufferList fillBufferList2 = {};
        fillBufferList2.mNumberBuffers = 1;
        fillBufferList2.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
        fillBufferList2.mBuffers[0].mDataByteSize = bufferByteSize;
        fillBufferList2.mBuffers[0].mData = sourceBuffer2;
        /*
         The client format is always linear PCM - so here we determine how many frames of lpcm
         we can read/write given our buffer size
         */
        UInt32 numberOfFrames = 0;
        if (clientFormat.mBytesPerFrame > 0) {
            // Handles bogus analyzer divide by zero warning mBytesPerFrame can't be a 0 and is protected by an Assert.
            numberOfFrames = bufferByteSize / clientFormat.mBytesPerFrame;
        }
        if (![self checkError:ExtAudioFileRead(sourceFile2, &numberOfFrames, &fillBufferList2) withErrorString:@"ExtAudioFileRead failed!"]) {
            return YES;
        }
        if (![self checkError:ExtAudioFileRead(sourceFile, &numberOfFrames, &fillBufferList) withErrorString:@"ExtAudioFileRead failed!"]) {
            return YES;
        }
        SInt64 currentFrame = -1;
        
        OSStatus result = ExtAudioFileTell(sourceFile, &currentFrame);
        if(noErr != result)
            NSLog(@"Unable to determine total frames");
       // percent=((float)currentFrame/totalFrames)*100;
        float *pDataL;
        float *pDataR2;
        float *pDataL2;
        float pD;
        if (self.effects ) {
            if (fillBufferList2.mNumberBuffers>1) {
                AudioBuffer *pBufferL = &fillBufferList.mBuffers[0];
                pDataL2 =(float *) pBufferL->mData;
                AudioBuffer *pBufferR = &fillBufferList.mBuffers[1];
                pDataR2 =(float *) pBufferR->mData;
                [self.effects  processFloatLeftInput:pDataL2 andRightInput:pDataR2 andLeftOutput:pDataL2 andRightOutput:pDataR2 andLength:numberOfFrames];
            }else{
                AudioBuffer *pBufferL = &fillBufferList.mBuffers[0];
                pDataL2 =(float *) pBufferL->mData;
                [self.effects processFloat:pDataL2 andOut:pDataL2 andLength:numberOfFrames];
            }
        }
        // float leftBuffer [numberOfFrames*fillBufferList.mBuffers[0].mNumberChannels];
        for (UInt32 i = 0; i < fillBufferList.mNumberBuffers; i++)
        {
            AudioBuffer *pBufferL = &fillBufferList.mBuffers[i];
            pDataL =(float *) pBufferL->mData;
            AudioBuffer *pBufferL2 = &fillBufferList2.mBuffers[i];
            pDataL2 =(float *) pBufferL2->mData;
            // NSLog(@"pdata a [1000] %f",leftBuffer[1000]);
            for (int i=0; i<numberOfFrames*fillBufferList.mBuffers[0].mNumberChannels; i++) {
                // leftBuffer[i]=(float ) pDataL[i];
                pD=(pDataL[i]*(self.volumeVideo/100.0)+pDataL2[i]*(self.volumeAudio/100.0));
                
                if (pD>1) {
                    pD=1;
                }else if (pD<-1){
                    pD=-1;
                }
                
                pDataL[i]=pD;
            }
            //NSLog(@"pdata b[1000] %f",leftBuffer[1000]);
        }
        if (!numberOfFrames) {
            // This is our termination condition.
            error = noErr;
            
            break;
        }
        
        sourceFrameOffset += numberOfFrames;
        
        BOOL wasInterrupted = [self checkIfPausedDueToInterruption];
        
        if ((error != noErr || wasInterrupted) && (!canResumeFromInterruption)) {
            // this is our interruption termination condition
            // an interruption has occured but the Audio Converter cannot continue
            error = kMyAudioConverterErr_CannotResumeFromInterruptionError;
            break;
        }
        
        // get left and right buffer
        
        
        //float *rightBuffer = (float *)fillBufferList.mBuffers[1].mData;
        //   AudioBuffer *pBufferL = &fillBufferList.mBuffers[0];
        //  pDataL =(float *) pBufferL->mData;
        //NSLog(@"pdata mp3 truoc [1000] %c",mp3_buffer[1000]);
        
        
        error = ExtAudioFileWrite(destinationFile, numberOfFrames, &fillBufferList);
        //  if (dem>1) {
        
       ///// write = lame_encode_buffer_interleaved_ieee_float(lame,(float*) fillBufferList.mBuffers[0].mData, numberOfFrames, mp3_buffer, MP3_SIZE);
       
       ///// fwrite(mp3_buffer, write, 1, mp3);
    
        // If we were interrupted in the process of the write call, we must handle the errors appropriately.
        if (error != noErr) {
            if (error == kExtAudioFileError_CodecUnavailableInputConsumed) {
                printf("ExtAudioFileWrite kExtAudioFileError_CodecUnavailableInputConsumed error %d\n", (int)error);
                
                /*
                 Returned when ExtAudioFileWrite was interrupted. You must stop calling
                 ExtAudioFileWrite. If the underlying audio converter can resume after an
                 interruption (see kAudioConverterPropertyCanResumeFromInterruption), you must
                 wait for an EndInterruption notification from AudioSession, then activate the session
                 before resuming. In this situation, the buffer you provided to ExtAudioFileWrite was successfully
                 consumed and you may proceed to the next buffer
                 */
            } else if (error == kExtAudioFileError_CodecUnavailableInputNotConsumed) {
                printf("ExtAudioFileWrite kExtAudioFileError_CodecUnavailableInputNotConsumed error %d\n", (int)error);
                
                /*
                 Returned when ExtAudioFileWrite was interrupted. You must stop calling
                 ExtAudioFileWrite. If the underlying audio converter can resume after an
                 interruption (see kAudioConverterPropertyCanResumeFromInterruption), you must
                 wait for an EndInterruption notification from AudioSession, then activate the session
                 before resuming. In this situation, the buffer you provided to ExtAudioFileWrite was not
                 successfully consumed and you must try to write it again
                 */
                
                // seek back to last offset before last read so we can try again after the interruption
                sourceFrameOffset -= numberOfFrames;
                if (![self checkError:ExtAudioFileSeek(sourceFile, sourceFrameOffset) withErrorString:@"ExtAudioFileSeek failed!"]) {
                    return YES;
                }
            } else {
                [self checkError:error withErrorString:@"ExtAudioFileWrite failed!"];
                return YES;
            }
        }
    }
    //
   // fclose(pcm);
    fclose(mp3);
    //lame_close(lame);
    NSDictionary * fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:self.mp3URL.path error:nil];
    unsigned long long filesize=[fileinfo fileSize];
    NSLog(@"Size mp3 file : %0.2f MB",filesize/1024.0/1024.0);
    fileinfo=[[NSFileManager defaultManager] attributesOfItemAtPath:self.destinationURL.path error:nil];
    filesize=[fileinfo fileSize];
    NSLog(@"Size des file : %0.2f MB",filesize/1024.0/1024.0);
    // Cleanup
    free(pcm_buffer);
    free(mp3_buffer);
    if (destinationFile) { ExtAudioFileDispose(destinationFile); }
    if (sourceFile) { ExtAudioFileDispose(sourceFile); }
    if (sourceFile2) { ExtAudioFileDispose(sourceFile2); }
    if (mp3File) { ExtAudioFileDispose(mp3File); }
    if (converter) { AudioConverterDispose(converter); }
    dispatch_sync(self.queue, ^{
        weakSelf.state = AudioConverterStateDone;
    });
    if (error==noErr) {
        return NO;
    }else{
        return YES;
    }
    
}
- (BOOL)checkError:(OSStatus)error withErrorString:(NSString *)string {
    if (error == noErr) {
        return YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(audioFileConvertOperation:didEncounterError:)]) {
        NSError *err = [NSError errorWithDomain:@"AudioFileConvertOperationErrorDomain" code:error userInfo:@{NSLocalizedDescriptionKey : string}];
        [self.delegate audioFileConvertOperation:self didEncounterError:err];
    }
    
    return NO;
}

- (BOOL)checkIfPausedDueToInterruption {
    __block BOOL wasInterrupted = NO;
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_sync(self.queue, ^{
        assert(weakSelf.state != AudioConverterStateDone);
        
        while (weakSelf.state == AudioConverterStatePaused) {
            dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
            
            wasInterrupted = YES;
        }
    });
    
    // We must be running or something bad has happened.
    assert(self.state == AudioConverterStateRunning);
    
    return wasInterrupted;
}

// MARK: Notification Handlers.

- (void)handleAudioSessionInterruptionNotification:(NSNotification *)notification {
    AVAudioSessionInterruptionType interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    printf("Session interrupted > --- %s ---\n", interruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
    
    __weak __typeof__(self) weakSelf = self;
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        dispatch_sync(self.queue, ^{
            if (weakSelf.state == AudioConverterStateRunning) {
                weakSelf.state = AudioConverterStatePaused;
            }
        });
    } else {
        
        NSError *error = nil;
        
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        if (error != nil) {
            NSLog(@"AVAudioSession setActive failed with error: %@", error.localizedDescription);
        }
        
        
        if (self.state == AudioConverterStatePaused) {
            dispatch_semaphore_signal(self.semaphore);
        }
        
        dispatch_sync(self.queue, ^{
            weakSelf.state = AudioConverterStateRunning;
        });
    }
}

+ (void)printAudioStreamBasicDescription:(AudioStreamBasicDescription)asbd {
    char formatID[5];
    UInt32 mFormatID = CFSwapInt32HostToBig(asbd.mFormatID);
    bcopy (&mFormatID, formatID, 4);
    formatID[4] = '\0';
    printf("Sample Rate:         %10.0f\n",  asbd.mSampleRate);
    printf("Format ID:           %10s\n",    formatID);
    printf("Format Flags:        %10X\n",    (unsigned int)asbd.mFormatFlags);
    printf("Bytes per Packet:    %10d\n",    (unsigned int)asbd.mBytesPerPacket);
    printf("Frames per Packet:   %10d\n",    (unsigned int)asbd.mFramesPerPacket);
    printf("Bytes per Frame:     %10d\n",    (unsigned int)asbd.mBytesPerFrame);
    printf("Channels per Frame:  %10d\n",    (unsigned int)asbd.mChannelsPerFrame);
    printf("Bits per Channel:    %10d\n",    (unsigned int)asbd.mBitsPerChannel);
    printf("\n");
}


@end


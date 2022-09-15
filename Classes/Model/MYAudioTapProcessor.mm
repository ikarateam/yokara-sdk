/*
 File: MYAudioTapProcessor.m
 Abstract: Audio tap processor using MTAudioProcessingTap for audio visualization and processing.
 Version: 1.0.1
 
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
 implied, are granted by Apple herein, including but not limited to any
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
 
 Copyright (C) 2019 Apple Inc. All Rights Reserved.
 
 */

#import "MYAudioTapProcessor.h"

#import <AVFoundation/AVFoundation.h>
#include "SuperpoweredDecoder.h"
#include "SuperpoweredSimple.h"
#include "SuperpoweredRecorder.h"
#include "SuperpoweredTimeStretching.h"
#include "SuperpoweredAudioBuffers.h"
#include "SuperpoweredFilter.h"
#include "SuperpoweredAnalyzer.h"
#import <MediaToolbox/MTAudioProcessingTap.h>
#include "RingBuffer.h"
#import "SoxEffects.h"
// This struct is used to pass along data between the MTAudioProcessingTap callbacks.
typedef struct AVAudioTapProcessorContext {
    BOOL supportedTapProcessingFormat;
    BOOL isNonInterleaved;
    Float64 sampleRate;
    AudioUnit audioUnit;
    Float64 sampleCount;
    float leftChannelVolume;
    float rightChannelVolume;
    void *self;
} AVAudioTapProcessorContext;

// MTAudioProcessingTap callbacks.
static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut);
static void tap_FinalizeCallback(MTAudioProcessingTapRef tap);
static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat);
static void tap_UnprepareCallback(MTAudioProcessingTapRef tap);
static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut);

// Audio Unit callbacks.
static OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);
const int kBufferSize = 88200;
@interface MYAudioTapProcessor ()
{
    AVAudioMix *_audioMix;
    @public    ExtAudioFileRef fileRef;
@public RingBuffer* ringBuffer;
@public SoxEffects *effects;
@public BOOL isRuning;
@public    NSLock * Lock;
}

@property ( assign, nonatomic)SuperpoweredDecoder *decoder;


@end

@implementation MYAudioTapProcessor

- (id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack andPlayer:(AVPlayer *) player andAudioPath:(NSString *)audioPath
{
    NSParameterAssert(audioAssetTrack && [audioAssetTrack.mediaType isEqualToString:AVMediaTypeAudio]);
    
    self = [super init];
    
    if (self)
    {
        _playerAV = player;
        _audioAssetTrack = audioAssetTrack;
        _centerFrequency = (4980.0f / 23980.0f); // equals 5000 Hz (assuming sample rate is 48k)
        _bandwidth = (500.0f / 11900.0f); // equals 600 Cents
        _audioPath = audioPath;
        _volumeAudio=100;
        _volumeVideo=100;
        
        //  TPCircularBufferInit(&_outputBuffer, kBufferSize*2);
    }
    
    return self;
}

#pragma mark - Properties
-(void) updateVolumeVideo:(int) volume{
    self.volumeVideo=volume;
}

-(void) updateVolumeAudio:(int )volume{
    self.volumeAudio=volume;
}

- (void) updateEffectBass:(int) bass{
    self.bass=bass;
    [effects updateBass:bass];
}
- (void) updateEffectTreble:(int) treble{
    self.treble=treble;
    [effects updateTreble:treble];
}
- (void) updateEffectEcho:(int) echo{
    self.echo=echo;
    [effects updateEcho:echo];
}
-(void) setEffect:(int)echo andBass:(int)bass andTreble:(int) treble{
    self.echo=echo;
    self.bass=bass;
    self.treble=treble;
    effects=[[SoxEffects alloc] initWithSoxEffects:echo Bass:bass Treble:treble];
}

- (AVAudioMix *)audioMix
{
    if (!_audioMix)
    {
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        if (audioMix)
        {
            //self.decoder = new SuperpoweredDecoder();
           // ringBuffer=new RingBuffer(4096*8);
            //const char *status=self.decoder->open([self.audioPath UTF8String], false, 0, 0);
            
            //self.delay=44100*0.313;
            self.currentTime=2837983;
            AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioAssetTrack];
             [self PrintFloatDataFromAudioFile];
            if (audioMixInputParameters)
            {
                MTAudioProcessingTapCallbacks callbacks;
                
                callbacks.version = kMTAudioProcessingTapCallbacksVersion_0;
                callbacks.clientInfo = (__bridge void *)self,
                callbacks.init = tap_InitCallback;
                callbacks.finalize = tap_FinalizeCallback;
                callbacks.prepare = tap_PrepareCallback;
                callbacks.unprepare = tap_UnprepareCallback;
                callbacks.process = tap_ProcessCallback;
                
                MTAudioProcessingTapRef audioProcessingTap;
                if (noErr == MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PostEffects, &audioProcessingTap))
                {
                    audioMixInputParameters.audioTapProcessor = audioProcessingTap;
                    
                    CFRelease(audioProcessingTap);
                    
                    audioMix.inputParameters = @[audioMixInputParameters];
                    
                    _audioMix = audioMix;
                }
            }
        }
    }
    
    return _audioMix;
}

- (void)setCenterFrequency:(float)centerFrequency
{
    if (_centerFrequency != centerFrequency)
    {
        _centerFrequency = centerFrequency;
        
        AVAudioMix *audioMix = self.audioMix;
        if (audioMix)
        {
            // Get pointer to Audio Unit stored in MTAudioProcessingTap context.
            MTAudioProcessingTapRef audioProcessingTap = ((AVMutableAudioMixInputParameters *)audioMix.inputParameters[0]).audioTapProcessor;
            AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(audioProcessingTap);
            AudioUnit audioUnit = context->audioUnit;
            if (audioUnit)
            {
                // Update center frequency of bandpass filter Audio Unit.
                Float32 newCenterFrequency = (20.0f + ((context->sampleRate * 0.5f) - 20.0f) * self.centerFrequency); // Global, Hz, 20->(SampleRate/2), 5000
                OSStatus status = AudioUnitSetParameter(audioUnit, kBandpassParam_CenterFrequency, kAudioUnitScope_Global, 0, newCenterFrequency, 0);
                if (noErr != status)
                    NSLog(@"AudioUnitSetParameter(kBandpassParam_CenterFrequency): %d", (int)status);
            }
        }
    }
}

- (void)setBandwidth:(float)bandwidth
{
    if (_bandwidth != bandwidth)
    {
        _bandwidth = bandwidth;
        
        AVAudioMix *audioMix = self.audioMix;
        if (audioMix)
        {
            // Get pointer to Audio Unit stored in MTAudioProcessingTap context.
            MTAudioProcessingTapRef audioProcessingTap = ((AVMutableAudioMixInputParameters *)audioMix.inputParameters[0]).audioTapProcessor;
            AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(audioProcessingTap);
            AudioUnit audioUnit = context->audioUnit;
            if (audioUnit)
            {
                // Update bandwidth of bandpass filter Audio Unit.
                Float32 newBandwidth = (100.0f + 11900.0f * self.bandwidth);
                OSStatus status = AudioUnitSetParameter(audioUnit, kBandpassParam_Bandwidth, kAudioUnitScope_Global, 0, newBandwidth, 0); // Global, Cents, 100->12000, 600
                if (noErr != status)
                    NSLog(@"AudioUnitSetParameter(kBandpassParam_Bandwidth): %d", (int)status);
            }
        }
    }
}

#pragma mark -

- (void)updateLeftChannelVolume:(float)leftChannelVolume rightChannelVolume:(float)rightChannelVolume
{
    @autoreleasepool
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Forward left and right channel volume to delegate.
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioTabProcessor:hasNewLeftChannelValue:rightChannelValue:)])
                [self.delegate audioTabProcessor:self hasNewLeftChannelValue:leftChannelVolume rightChannelValue:rightChannelVolume];
        });
    }
}
-(NSData *) readAudioFile:(NSString *)filePath fromOffset:(long long) offset readSize:(long)readSize {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    if(offset >= fileSize)
        return nil;
    
    NSFileHandle *fReadHandle = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle]                                                                          pathForResource:@"beat" ofType:@"mp3"]];
    [fReadHandle seekToFileOffset:offset];
    NSData *data = [fReadHandle readDataOfLength:readSize];
    [fReadHandle closeFile];
    return data;
}
- (NSMutableArray *) audioFileToBuffer{
    
    NSURL *inputFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                          pathForResource:@"beat" ofType:@"mp3"]];
    AVAudioFile * file=[[AVAudioFile alloc] initForReading:inputFileURL error:nil];
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;   // GIVE YOUR SAMPLING RATE
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mBitsPerChannel = sizeof(Float32) * 8;
    audioFormat.mChannelsPerFrame = 1; // Mono
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * sizeof(Float32);  // == sizeof(Float32)
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame;
    AVAudioFormat *format=[[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100 channels:1 interleaved:false];
    AVAudioPCMBuffer *buffer =[[AVAudioPCMBuffer alloc] initWithPCMFormat:format frameCapacity:1024];
    [file readIntoBuffer:buffer error:nil];
    
    NSMutableArray * floatArray=[[NSMutableArray alloc] init];
    // this makes a copy, you might not want that
    
    for (AVAudioFrameCount i = 0; i < buffer.frameLength; i++) {
        [floatArray addObject:@(buffer.floatChannelData[0][i])];
    }
    return floatArray;
}
- (void)offlineFilter:(NSURL *)url {
    // Open the input file.
    
    SuperpoweredDecoder *decoder = new SuperpoweredDecoder();
    const char *openError = decoder->open([[[NSBundle mainBundle]                                                                          pathForResource:@"beat" ofType:@"mp3"] UTF8String], false, 0, 0);
    if (openError) {
        NSLog(@"open error: %s", openError);
        delete decoder;
        return;
    };
    
    // Create the output WAVE file. The destination is accessible in iTunes File Sharing.
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SuperpoweredOfflineTest.wav"];
    FILE *fd = createWAV([destinationPath fileSystemRepresentation], decoder->samplerate, 2);
    if (!fd) {
        NSLog(@"File creation error.");
        delete decoder;
        return;
    };
    
    // Creating the filter.
    SuperpoweredFilter *filter = new SuperpoweredFilter(SuperpoweredFilter_Resonant_Lowpass, decoder->samplerate);
    filter->setResonantParameters(1000.0f, 0.1f);
    filter->enable(true);
    
    // Create a buffer for the 16-bit integer samples coming from the decoder.
    short int *intBuffer = (short int *)malloc(decoder->samplesPerFrame * 2 * sizeof(short int) + 32768);
    // Create a buffer for the 32-bit floating point samples required by the effect.
    float *floatBuffer = (float *)malloc(decoder->samplesPerFrame * 2 * sizeof(float) + 32768);
    
    // Processing.
    while (true) {
        // Decode one frame. samplesDecoded will be overwritten with the actual decoded number of samples.
        unsigned int samplesDecoded = decoder->samplesPerFrame;
        if (decoder->decode(intBuffer, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) break;
        if (samplesDecoded < 1) break;
        
        // Convert the decoded PCM samples from 16-bit integer to 32-bit floating point.
        //SuperpoweredShortIntToFloat(intBuffer, floatBuffer, samplesDecoded);
        
        // Apply the effect.
        //filter->process(floatBuffer, floatBuffer, samplesDecoded);
        
        // Convert the PCM samples from 32-bit floating point to 16-bit integer.
        //SuperpoweredFloatToShortInt(floatBuffer, intBuffer, samplesDecoded);
        
        // Write the audio to disk.
        fwrite(intBuffer, 1, samplesDecoded * 4, fd);
        
        // Update the progress indicator.
        
    };
    
    // iTunes File Sharing: https://support.apple.com/en-gb/HT201301
    NSLog(@"The file is available in iTunes File Sharing, and locally at %@.", destinationPath);
    
    // Cleanup.
    closeWAV(fd);
    delete decoder;
    delete filter;
    free(intBuffer);
    free(floatBuffer);
}

- (void) seekToZero{
    NSLog(@"seek Zero");
    
    ExtAudioFileSeek(self->fileRef,0);
    //self.decoder->seek(self.decoder->samplesPerFrame, NO);
    self.currentTime=9999999;
    self.relay=YES;
}
- (BOOL)checkError:(OSStatus)error withErrorString:(NSString *)string {
    if (error == noErr) {
        return YES;
    }
    
    
    
    return NO;
}
-(void) PrintFloatDataFromAudioFile {
    
    
    
    
    if (![self checkError: ExtAudioFileOpenURL((__bridge CFURLRef _Nonnull)( [NSURL fileURLWithPath: self.audioPath]), &fileRef) withErrorString:@"ExtAudioFileOpenURL couldn't get the source data format"]) {
        return ;
    }
    
    
    
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;   // GIVE YOUR SAMPLING RATE
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mBitsPerChannel = sizeof(float) * 8;
    audioFormat.mChannelsPerFrame = 2; // Mono
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * sizeof(float);  // == sizeof(Float32)
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * audioFormat.mBytesPerFrame;
    
    // 3) Apply audio format to the Extended Audio File
    UInt32 size = sizeof(audioFormat);
    
    if (![self checkError:ExtAudioFileSetProperty(
                                                  fileRef,
                                                  kExtAudioFileProperty_ClientDataFormat,
                                                  size, //= audioFormat
                                                  &audioFormat)  withErrorString:@"ExtAudioFileSetProperty couldn't get the source data format"]) {
        return ;
    }
    
    
    
}



@end

#pragma mark - MTAudioProcessingTap Callbacks

static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut)
{
    AVAudioTapProcessorContext* context =(AVAudioTapProcessorContext *) calloc(1, sizeof(AVAudioTapProcessorContext));
    
    // Initialize MTAudioProcessingTap context.
    context->supportedTapProcessingFormat = NO;
    context->isNonInterleaved = false;
    context->sampleRate = NAN;
    context->audioUnit = NULL;
    context->sampleCount = 0.0f;
    context->leftChannelVolume = 0.0f;
    context->rightChannelVolume = 0.0f;
    context->self = clientInfo;
    NSLog(@"tap_InitCallback");
    *tapStorageOut = context;
}

static void tap_FinalizeCallback(MTAudioProcessingTapRef tap)
{
    AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    NSLog(@"tap_FinalizeCallback");
    // Clear MTAudioProcessingTap context.
    context->self = nil;
    
    free(context);
}

static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat)
{
    AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    
    // Store sample rate for -setCenterFrequency:.
    context->sampleRate = processingFormat->mSampleRate;
    
    /* Verify processing format (this is not needed for Audio Unit, but for RMS calculation). */
    
    context->supportedTapProcessingFormat = true;
    
    if (processingFormat->mFormatID != kAudioFormatLinearPCM)
    {
        NSLog(@"Unsupported audio format ID for audioProcessingTap. LinearPCM only.");
        context->supportedTapProcessingFormat = false;
    }
    
    if (!(processingFormat->mFormatFlags & kAudioFormatFlagIsFloat))
    {
        NSLog(@"Unsupported audio format flag for audioProcessingTap. Float only.");
        context->supportedTapProcessingFormat = false;
    }
    
    if (processingFormat->mFormatFlags & kAudioFormatFlagIsNonInterleaved)
    {
        context->isNonInterleaved = true;
    }
    
    /* Create bandpass filter Audio Unit */
    
    AudioUnit audioUnit;
    
    AudioComponentDescription audioComponentDescription;
    audioComponentDescription.componentType = kAudioUnitType_Effect;
    audioComponentDescription.componentSubType = kAudioUnitSubType_BandPassFilter;
    audioComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioComponentDescription.componentFlags = 0;
    audioComponentDescription.componentFlagsMask = 0;
    
    AudioComponent audioComponent = AudioComponentFindNext(NULL, &audioComponentDescription);
    if (audioComponent)
    {
        if (noErr == AudioComponentInstanceNew(audioComponent, &audioUnit))
        {
            OSStatus status = noErr;
            
            // Set audio unit input/output stream format to processing format.
            if (noErr == status)
            {
                status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, processingFormat, sizeof(AudioStreamBasicDescription));
            }
            if (noErr == status)
            {
                status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, processingFormat, sizeof(AudioStreamBasicDescription));
            }
            
            // Set audio unit render callback.
            if (noErr == status)
            {
                AURenderCallbackStruct renderCallbackStruct;
                renderCallbackStruct.inputProc = AU_RenderCallback;
                renderCallbackStruct.inputProcRefCon = (void *)tap;
                status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &renderCallbackStruct, sizeof(AURenderCallbackStruct));
            }
            
            // Set audio unit maximum frames per slice to max frames.
            if (noErr == status)
            {
                UInt32 maximumFramesPerSlice = maxFrames;
                status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maximumFramesPerSlice, (UInt32)sizeof(UInt32));
            }
            
            // Initialize audio unit.
            if (noErr == status)
            {
                status = AudioUnitInitialize(audioUnit);
            }
            
            if (noErr != status)
            {
                AudioComponentInstanceDispose(audioUnit);
                audioUnit = NULL;
            }
            
            context->audioUnit = audioUnit;
        }
    }
}

static void tap_UnprepareCallback(MTAudioProcessingTapRef tap)
{
    AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    
    /* Release bandpass filter Audio Unit */
    
    if (context->audioUnit)
    {
        AudioUnitUninitialize(context->audioUnit);
        AudioComponentInstanceDispose(context->audioUnit);
        context->audioUnit = NULL;
    }
}


static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut)
{
    try {
    AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    
    OSStatus status;
    
    // Skip processing when format not supported.
        
        if ( context == nil || context == NULL) {
            
            return;
        }
        if (!context->supportedTapProcessingFormat)
        {
            NSLog(@"Unsupported tap processing format.");
            
            return;
        }
        if ( context->self == nil ||  context->self == NULL) {
            
            return;
        }
    
	 
        
		  MYAudioTapProcessor *self = ((__bridge MYAudioTapProcessor *)context->self);
		  if (![self isKindOfClass:[MYAudioTapProcessor class]]) {

			   return;
		  }
        if (self.playerAV==nil) {
            return;
        }
		  [self->Lock lock];
		  if (self->isRuning) {
			   [self->Lock unlock];
			   return;
		  }
		  self->isRuning=YES;
		  CMTimeRange timeRangeOut;
		  status = MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, &timeRangeOut, numberFramesOut);
		  if (noErr != status)
			  {
			   NSLog(@"MTAudioProcessingTapGetSourceAudio: %d", (int)status);
			   self->isRuning=NO;
			   [self->Lock unlock];
			   return;
			  }
			   //}
			   //short int *intBuffer = (short int *)malloc(numberFrames * 2 * sizeof(short int) + 32768);
			   // Create a buffer for the 32-bit floating point samples required by the effect.
			   //float *floatBuffer = (float *)malloc(numberFrames * 2 * sizeof(float) + 32768);
			   // float *floatBufferEffect = (float *)malloc(numberFrames * 2 * sizeof(float) + 32768);
		  float *floatBufferL = (float *)malloc(numberFrames * 2 * sizeof(float));
		  float *floatBufferR = (float *)malloc(numberFrames * 2 * sizeof(float) );
			   // float *floatBufferAudio = (float *)malloc(numberFrames*2  * sizeof(float) + 32768);


		  UInt32 samplesDecoded =(UInt32)numberFrames;// self.decoder->samplesPerFrame;

		  UInt32 sizePerPacket = sizeof(float)*2 ;//= 32bytes
		  UInt32 packetsPerBuffer = samplesDecoded;
		  UInt32 outputBufferSize = packetsPerBuffer * sizePerPacket;

			   // So the lvalue of outputBuffer is the memory location where we have reserved space
		  float *outputBuffer = (float *)malloc(sizeof(float ) * outputBufferSize);



		  AudioBufferList convertedData ;//= malloc(sizeof(convertedData));

		  convertedData.mNumberBuffers = 1;    // Set this to 1 for mono
		  convertedData.mBuffers[0].mNumberChannels =2;  //also = 1
		  convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
		  convertedData.mBuffers[0].mData = outputBuffer; //

		  float *samplesAsCArray;
		  double playerTime=CMTimeGetSeconds(timeRangeOut.start);
		  SInt64 sample=playerTime*44100/numberFrames;
		  SInt64 samplePosition=playerTime*44100-self.delay*44.1;

		  int check=playerTime*10;
		  SInt64 currentTime;
		  SInt64 time=0;

		  ExtAudioFileTell(self->fileRef, &time);
		  self.currentTime=time;
			   //NSLog(@"seek %f - %f ---currentTime %lld samplePostion %d lech %d",CMTimeGetSeconds(timeRangeOut.start),CMTimeGetSeconds(self.playerAV.currentTime),self.currentTime,samplePosition,self.currentTime-samplePosition);
		  SInt64 totalFrames = -1;
		  UInt32 dataSize = sizeof(totalFrames);

		  OSStatus result = ExtAudioFileGetProperty(self->fileRef, kExtAudioFileProperty_FileLengthFrames, &dataSize, &totalFrames);
		  if (CMTimeGetSeconds(timeRangeOut.start)==0) {
					// NSLog(@"seek %f ---currentTime %lld samplePostion %d lech %d",CMTimeGetSeconds(timeRangeOut.start),self.currentTime,samplePosition,self.currentTime-samplePosition);
			   if (-(self.delay)*44.1<0) {
					ExtAudioFileSeek(self->fileRef,0);
			   }else
					ExtAudioFileSeek(self->fileRef,-(self.delay)*44.1);

		  }else
			   if (abs(self.currentTime -samplePosition)>441 && samplePosition>0  && samplePosition+samplesDecoded<=totalFrames){
						 //NSLog(@"%f ---currentTime %lld samplePostion %d lech %d",CMTimeGetSeconds(timeRangeOut.start),self.currentTime,samplePosition,self.currentTime-samplePosition);
						 //NSLog(@"seek");
					self.currentTime=samplePosition+numberFrames;

					ExtAudioFileSeek(self->fileRef,samplePosition);
						 // self.decoder->seek(samplePosition, YES);
						 // self->ringBuffer->empty();
			   }


			   // while (true) {
		  status=  ExtAudioFileRead( self->fileRef,    &samplesDecoded,   &convertedData   );
			   //  if (self.decoder->decode(intBuffer, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) {
			   //   NSLog(@"error decode");
			   //  }
			   // SuperpoweredShortIntToFloat(intBuffer, floatBufferAudio, samplesDecoded,2);

			   // Convert the decoded PCM samples from 16-bit integer to 32-bit floating point.

		  AudioBuffer audioBuffer = convertedData.mBuffers[0];
		  samplesAsCArray = (float *)audioBuffer.mData; // CAST YOUR mData INTO FLOAT
         if (samplesDecoded==0) {
             NSLog(@"%ld - totalframe %ld",samplePosition,totalFrames);
         }
		  for (int i =0; i<samplesDecoded*2 /*numSamples */; i++) { //YOU CAN PUT numSamples INTEAD OF 1024

			   floatBufferL[i] = (float)samplesAsCArray[2*i] ; //PUT YOUR DATA INTO FLOAT ARRAY
			   floatBufferR[i] = (float)samplesAsCArray[2*i+1] ; //PUT YOUR DATA INTO FLOAT ARRAY



		  }


		  float *pDataL;
		  float *pDataR;

		  if (bufferListInOut->mNumberBuffers>1) {
			   AudioBuffer *pBufferL = &bufferListInOut->mBuffers[0];
			   pDataL =(float *) pBufferL->mData;
			   AudioBuffer *pBufferR = &bufferListInOut->mBuffers[1];
			   pDataR =(float *) pBufferR->mData;
			   if (self->effects)
					[self->effects processFloatLeftInput:pDataL andRightInput:pDataR andLeftOutput:pDataL andRightOutput:pDataR andLength:numberFrames];
		  }else{
			   AudioBuffer *pBufferL = &bufferListInOut->mBuffers[0];
			   pDataL =(float *) pBufferL->mData;
			   if (self->effects)
					[self->effects processFloat:pDataL andOut:pDataL andLength:numberFrames*pBufferL->mNumberChannels];
		  }

		  float maxL=0;
		  float maxR=0;
		  for (UInt32 i = 0; i < bufferListInOut->mNumberBuffers; i++)
			  {
			   AudioBuffer *pBuffer = &bufferListInOut->mBuffers[i];
			   UInt32 cSamples =(UInt32) numberFrames * (context->isNonInterleaved ? 1 : pBuffer->mNumberChannels);

			   float *pData =(float *) pBuffer->mData;


			   for (UInt32 j = 0; j < cSamples; j++)
				   {
					float pD;
					if (i==0) {
						 pD=(pDataL[j]*self.volumeVideo/100+floatBufferL[j]*self.volumeAudio/100);
						 maxL=MAX(maxL, abs( pD));
						 if (pD>1) {
							  pD=1;
						 }else if (pD<-1){
							  pD=-1;
						 }
						 pData[j]=pD;

					}else{
						 pD=(pDataR[j]*self.volumeVideo/100+floatBufferR[j]*self.volumeAudio/100);
						 maxR=MAX(maxR, abs( pD));
						 if (pD>1) {
							  pD=1;
						 }else if (pD<-1){
							  pD=-1;
						 }
						 pData[j]=pD;
					}

						 //rms += pData[j] * pData[j];

				   }

			  }

		  free(floatBufferL);
		  free(floatBufferR);
		  free(outputBuffer);
			   // Pass calculated left and right channel volume to VU meters.
			   //[self updateLeftChannelVolume:context->leftChannelVolume rightChannelVolume:context->rightChannelVolume];
		  [self updateLeftChannelVolume:maxL rightChannelVolume:maxR];
         [self->Lock unlock];
         self->isRuning=NO;
	 }catch (NSException *exception) {
		  NSLog(@"MYAudioTapProcessor %@", exception.reason);
	 }
    
    

}

#pragma mark - Audio Unit Callbacks

OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
{
    // Just return audio buffers from MTAudioProcessingTap.
    return 0;//MTAudioProcessingTapGetSourceAudio(inRefCon, inNumberFrames, ioData, NULL, NULL, NULL);
}


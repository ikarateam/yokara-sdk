/*
 Copyright (C) 2019 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates converting audio using ExtAudioFile.
 */

#import <Foundation/Foundation.h>
@import AudioToolbox;
@protocol ExtendedAudioFileConvertOperationDelegate;

@interface ExtendedAudioFileConvertOperation2 : NSOperation

- (instancetype)initWithSourceURL:(NSURL *)sourceURL destinationURL:(NSURL *)destinationURL sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat;
- (instancetype)initWithSourceURL:(NSURL *)sourceURL sourceUrl2:(NSURL *)sourceURL2  sampleRate:(Float64)sampleRate outputFormat:(AudioFormatID)outputFormat;

-(void) setEffect:(int)echo andBass:(int)bass andTreble:(int) treble andDelay:(int)delay;

@property ( nonatomic, strong) NSURL *sourceURL;

@property (readonly, nonatomic, strong) NSURL *sourceURL2;

@property (readonly, nonatomic, strong) NSURL *destinationURL;

@property (readonly, nonatomic, strong) NSURL *mp3URL;

@property (readonly, nonatomic, strong) NSURL *mp4URL;

@property (readonly, nonatomic, assign) Float64 sampleRate;

@property (readonly, nonatomic, assign) AudioFormatID outputFormat;

@property (nonatomic, weak) id<ExtendedAudioFileConvertOperationDelegate> delegate;


@end

@protocol ExtendedAudioFileConvertOperationDelegate <NSObject>

- (void)audioFileConvertOperation:(ExtendedAudioFileConvertOperation2 *)audioFileConvertOperation didEncounterError:(NSError *)error;

- (void)audioFileConvertOperation:(ExtendedAudioFileConvertOperation2 *)audioFileConvertOperation didCompleteWithURL:(NSURL *)destinationURL;


@end
extern BOOL mixOfflineProssesing;


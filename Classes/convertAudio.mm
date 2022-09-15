//
//  convertAudio.m
//  Yokara
//
//  Created by Rain Nguyen on 2/6/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "convertAudio.h"
#import "Constant.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Recording.h"
@implementation convertAudio
extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);
#pragma mark- ExtAudioFile
/*
- (void)convertAudio: (Recording*)record
{
    record->isConvert=YES;
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourceFilePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.aif",record.recordingTime]];
    NSString *destinationFilePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",record.recordingTime]];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    CFURLRef sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)sourceFilePath, kCFURLPOSIXPathStyle, false);
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath];
    if (haveS) {
    OSStatus error = DoConvertFile(sourceURL, destinationURL, kAudioFormatMPEG4AAC, 44100.0);
    
   
    if (error) {
        // delete output file if it exists since an error was returned during the conversion process
        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
        }
        
        printf("DoConvertFile failed! %ld\n", error);
        record->isConvert=NO;
        //[self performSelectorOnMainThread:(@selector(updateUI)) withObject:nil waitUntilDone:NO];
    } else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:sourceFilePath error:nil];
        }
        record->isConvert=NO;
        NSLog(@"Convert xong");
        //  [self performSelectorOnMainThread:(@selector(playAudio)) withObject:nil waitUntilDone:NO];
    }
    }
    [pool release];
        
}*/
- (void)convertAudio:(Recording *)record{
    self.record=record;
    self.doneConvert=NO;
    record->isConvert=YES;
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
     self.sourceFilePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.aif",record.recordingTime]];
    self.destinationFilePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord/%@.m4a",record.recordingTime]];
 
    self.operation = [[AudioFileConvertOperation alloc] initWithSourceURL: [NSURL fileURLWithPath:self.sourceFilePath] destinationURL: [NSURL fileURLWithPath:self.destinationFilePath] sampleRate:44100 outputFormat:kAudioFormatMPEG4AAC];
    
    self.operation.delegate = self;
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf.operation start];
    });
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (!self.doneConvert);
    record->isConvert=NO;
}
// MARK: AVAudioPlayerDelegate Protocol Methods.
- (void)audioFileConvertOperation:(AudioFileConvertOperation *)audioFileConvertOperation didCompleteWithURL:(NSURL *)destinationURL {
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        weakSelf.operation = nil;
        
        NSError *error = nil;
       
        
        if (error == nil) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:weakSelf.sourceFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:weakSelf.sourceFilePath error:nil];
            }
            self.record->isConvert=NO;
            NSLog(@"Convert xong");
            //hoan thanh
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:weakSelf.destinationFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:weakSelf.destinationFilePath error:nil];
            }
            
            printf("DoConvertFile failed! %ld\n", error);
            self.record->isConvert=NO;
        }
        self.doneConvert=YES;
    });
}

- (void)audioFileConvertOperation:(AudioFileConvertOperation *)audioFileConvertOperation didEncounterError:(NSError *)error {
    
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.operation = nil;
        
        NSLog(@"%@",error.description);
        if ([[NSFileManager defaultManager] fileExistsAtPath:weakSelf.destinationFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:weakSelf.destinationFilePath error:nil];
        }
        
        printf("DoConvertFile failed! %ld\n", error);
        self.record->isConvert=NO;
        self.doneConvert=YES;
    });
}

@end

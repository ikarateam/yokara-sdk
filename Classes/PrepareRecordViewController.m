//
//  PrepareRecordViewController.m
//  Yokara
//
//  Created by APPLE on 1/25/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "PrepareRecordViewController.h"
#import <sys/utsname.h>
#include <sys/xattr.h>
#import "Video.h"
#import <AKPickerView/AKPickerView.h>

#import "StreamingMovieViewController.h"
@interface PrepareRecordViewController ()<AKPickerViewDataSource, AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,strong) SCFilter *beautiFilter;

@end

@implementation PrepareRecordViewController
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
- (IBAction)changeCamera:(id)sender {
    if (canChangeCamera){
        canChangeCamera=NO;
        [recorder switchCaptureDevices];
        canChangeCamera=YES;
        self.deviceCamera=recorder.device;
       
    }
}
- (IBAction)back:(id)sender {
    //self.navigationController.navigationBarHidden=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:NO];
}
-(void)SGDownloadFail:(NSError*)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        waitTime=0;
        self.StatusWaitLabel.text=@"Đã xảy ra lỗi khi chuẩn bị bài thu. Vui lòng quay lại sau!";
        self.waitTimeLabel.hidden=YES;
    });
}
-(void)SGDownloadProgress:(float)progress Percentage:(NSInteger)percentage{
    self.processDownloadSong.progress=progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        //waitTime=30-percentage*30/100;
        self.waitTimeLabel.text=[NSString stringWithFormat:AMLocalizedString(@"Đang chuẩn bị phòng thu %0.f%%", nil),percentage];
    });
}
-(void)SGDownloadFinished:(NSData*)fileData{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
    if (self.song.videoId.length>2){
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song.videoId]];
        
    }
    if ([self.song.songUrl isKindOfClass:[NSString class]])
    if ([self.song.songUrl hasSuffix:@"m4a"]) {
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",self.song._id]];
    }
    if ([self.performanceType isEqualToString:@"DUET"]) {
        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
    }
    self.waitStatusView.hidden=YES;
    
    self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
    self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath]];
    [fileData writeToFile:filePath atomically:YES];
    self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
    self.StartButton2.hidden=NO;
    self.startButton.hidden=NO;
    
    
}
/*
- (void) saveLyric{
    @autoreleasepool {
        Lyric * lyr=[Lyric new];
        CGFloat ratemax = -1;
        if (![self.performanceType isEqualToString:@"DUET"]) {
            
            
            GetSongResponse *getSong = [[LoadData2 alloc] getDataSong:self.song._id];
            for (Lyric *lyric in getSong.song.lyrics) {
                ///  NSString *list=[NSString stringWithFormat:@"MS: %@",lyric.privatedId];
                
                
                
                
                int avgrate;
                if ([lyric.ratingCount intValue]==0) avgrate=3;
                else avgrate=[lyric.totalRating intValue]/[lyric.ratingCount intValue] ;
                if ([lyric.key isEqualToString:self.song.approvedLyric] && [lyric.type integerValue]==XML && avgrate>=3) {
                    lyr = lyric;
                    break;
                }
                if (avgrate > ratemax && [lyric.type integerValue]==XML && [lyric.key isKindOfClass:[NSString class]]) {
                    lyr = lyric;
                    ratemax = avgrate;
                }
                
            }
            if (![lyr.key isKindOfClass:[NSString class]]) {
                lyr=getSong.song.lyrics[0];
                if ([lyr.type integerValue]!=XML) {
                    
                    for (Lyric * lyri in getSong.song.lyrics) {
                        if ([lyri.type integerValue]==XML) {
                            lyr=lyri;
                            break;
                        }
                    }
                    
                    
                }
            }
        }else{
            lyr=self.recording.lyric;
        }
        GetLyricResponse *lyricRespone=[[LoadData2 alloc] getLyricData:lyr.key];
        lyr.content=[lyricRespone.content stringByReplacingOccurrencesOfString:@"'" withString:@"`"];
        if ([[DBHelperYokaraSDK alloc] insertLyric:lyr andSongID:[NSString stringWithFormat:@"%@", self.song._id ]]) NSLog(@"insert lyric sussecc");
    }
}*/
- (void) insertdownloadSong:(Song *) songDown{
    @autoreleasepool {
     
    }
}
- (void) animateStartButton{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        self.startButton.transform = CGAffineTransformMakeScale(1.1,1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.startButton.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
- (void) checkHeadSet{
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    AVAudioSessionPortDescription *input = [[session.currentRoute.outputs count]?session.currentRoute.outputs:nil objectAtIndex:0];
    NSLog(@"tai nghe doi%@",input.portType);
    NSRange bluetooth=[input.portType rangeOfString : @"Bluetooth"];
    
    NSRange headsetRange = [input.portType rangeOfString : @"Head"];
    if(headsetRange.location != NSNotFound) {
        // Don't change the route if the headset is plugged in.
        
        hasHeadset=YES;
        // if (isKaraokeTab){
        // controller.warningHeadset.hidden=YES;
        //}
        
    } else
    {
        hasHeadset=NO;
        // if (isKaraokeTab){
        //   controller.warningHeadset.hidden=NO;
        //}
        
        
        //if (playRecord
        // Change to play on the speaker
        //   NSLog(@"play on the speaker");
    }
}
- (IBAction)hideHeadphoneWarning:(id)sender {
    //[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    
    self.headphoneWarningView.hidden=YES;
    
    //} completion:^(BOOL finished) {
    
    //}];
}
- (void) loadYoutubeVieo{
    @autoreleasepool {
        
        /*NSString * content=[[LoadData2 alloc] getUrlWithYoutubeVideoId:videoId];
         //  songPlay.songUrl=urlSong;
         // [playerYoutube prepareToPlay];
         //  playerYoutube.view.frame = CGRectMake(0, 0, 350, 350);
         
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
         
         }*/
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.processDownloadSong.progress=downloadProgress.fractionCompleted;
            //waitTime=(NSInteger)(30-downloadProgress.fractionCompleted*30);
            self.waitTimeLabel.text=[NSString stringWithFormat:AMLocalizedString(@"Đang tải", nil)];//,[[LoadData2 alloc] convertTimeToString:10]];
        });
		 if (![self.song.videoId isKindOfClass:[NSString class]]){
			  return;
		 }
        YoutubeMp4Respone *res=[[LoadData2 alloc] GetYoutubeMp4Link:self.song.videoId];
        if ([res isKindOfClass:[YoutubeMp4Respone class]]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality like %@", @"480"];
            NSArray *filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
            if (filteredArray.count>0) {
                YoutubeMp4* linkMp4=filteredArray[0];
                self.song.mp4link=linkMp4.url;
            }else{
                predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"360"];
                filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                if (filteredArray.count>0) {
                    YoutubeMp4* linkMp4=filteredArray[0];
                    self.song.mp4link=linkMp4.url;
                }else{
                    predicate = [NSPredicate predicateWithFormat:@"SELF.quality == %@", @"720"];
                    filteredArray = [res.videos filteredArrayUsingPredicate:predicate];
                    if (filteredArray.count>0) {
                        YoutubeMp4* linkMp4=filteredArray[0];
                        self.song.mp4link=linkMp4.url;
                    }
                }
            }
            
        }
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
        if ([self.song.songUrl isKindOfClass:[NSString class]])
        if ([self.song.songUrl hasSuffix:@"m4a"]) {
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",self.song._id]];
        }
        if (self.song.videoId.length>2){
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song.videoId]];
            
        }
        if ([self.performanceType isEqualToString:@"DUET"]) {
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
        }
        
            //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswidutch_on.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
        
        BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if ([self.song.mp4link isKindOfClass:[NSString class]] && haveS){
            /*if (![self.song.mp4link containsString:@"okara.co"] && ![self.song.mp4link containsString:@"ikara.co"] && ![self.song.mp4link containsString:@"yokara.com"] && [VIPYokara isEqualToString:@"VIP"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil) message:AMLocalizedString(@"Bạn sẽ bị tính phí dữ liệu khi thu bài hát này. Bạn có muốn tiếp tục?", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"Tiếp tục thu", nil) otherButtonTitles:nil, nil];
                [alert show];
                    });
            }*/
            dispatch_async(dispatch_get_main_queue(), ^{
                self.waitStatusView.hidden=YES;
                self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
                self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);

                    // [fileData writeToFile:filePath atomically:YES];
                self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
                self.StartButton2.hidden=NO;
                self.startButton.hidden=NO;
            });
        }

    }
}
- (void) downloadSongMp3{
    @autoreleasepool{
		 NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		 NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
        if ([self.song.songUrl isKindOfClass:[NSString class]])
        if ([self.song.songUrl hasSuffix:@"m4a"]) {
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",self.song._id]];
        }
        if (self.song.videoId.length>2){
            filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song.videoId]];
            
        }
		 if ([self.performanceType isEqualToString:@"DUET"]) {
			 filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
		 }

		 //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswidutch_on.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
		 // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];

		 BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
		 if (haveS ){
			 dispatch_async(dispatch_get_main_queue(), ^{
				 self.processDownloadSong.progress=1;
                 self.processDownloadSong.hidden = YES;
			 });
             if ([self.performanceType isEqualToString:@"SOLO"] || [self.song.mp4link isKindOfClass:[NSString class]]) {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 self.waitStatusView.hidden=YES;
				 self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
				 self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
				 // [fileData writeToFile:filePath atomically:YES];
				 self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
				 self.StartButton2.hidden=NO;
				 self.startButton.hidden=NO;
			 });
             





			 if (!hasHeadset) {
				 dispatch_async(dispatch_get_main_queue(), ^{
					 self.headphoneWarningView.transform=CGAffineTransformMakeScale(0,0);

					 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
						 self.headphoneWarningView.transform=CGAffineTransformMakeScale(1,1);
						 self.headphoneWarningView.hidden=NO;

					 } completion:^(BOOL finished) {

					 }];
				 });
			 }
             }
		 }else
        if (![self.song.songUrl isKindOfClass:[NSString class]]) {
         
            GetYoutubeMp3LinkRespone *res= [[LoadData2 alloc] GetYoutubeMp3Link:self.song];
            if ([res.url isKindOfClass:[NSString class]]) {
                self.song.songUrl=res.url;
            }else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alertDisconnectStream=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                                                             message:AMLocalizedString(@"Bài hát bị lỗi vui lòng chọn bài hát khác. Hoặc liên hệ chúng tôi để được hỗ trợ!", nil)
                                                                                      preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:AMLocalizedString(@"OK", nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                    dispatch_async(dispatch_get_main_queue(), ^{ 
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordCancel" object:nil];
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                    });
                                            }];

                [alertDisconnectStream addAction:yesButton];
                [self presentViewController:alertDisconnectStream animated:YES completion:nil];
                 });
            }
        }
        if ([self.song.songUrl isKindOfClass:[NSString class]] || ([self.performanceType isEqualToString:@"DUET"] && [self.recording.onlineMp3Recording isKindOfClass:[NSString class]])) {
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
            if ([self.song.songUrl isKindOfClass:[NSString class]])
            if ([self.song.songUrl hasSuffix:@"m4a"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",self.song._id]];
            }
            if (self.song.videoId.length>2){
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song.videoId]];
                
            }
            if ([self.performanceType isEqualToString:@"DUET"]) {
                filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
            }
            
            //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswidutch_on.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
            
            BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (haveS ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.processDownloadSong.progress=1;
                    self.processDownloadSong.hidden = YES;
                });
                if ([self.performanceType isEqualToString:@"SOLO"] || [self.song.mp4link isKindOfClass:[NSString class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.waitStatusView.hidden=YES;
                    self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
                    self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
                    // [fileData writeToFile:filePath atomically:YES];
                    self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
                    self.StartButton2.hidden=NO;
                    self.startButton.hidden=NO;
                });
                }
                
                
                
                
                
                if (!hasHeadset) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headphoneWarningView.transform=CGAffineTransformMakeScale(0,0);
                        
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.headphoneWarningView.transform=CGAffineTransformMakeScale(1,1);
                            self.headphoneWarningView.hidden=NO;
                            
                        } completion:^(BOOL finished) {
                            
                        }];
                    });
                }
            }else{
                
                
                waitTime=0;
                
                // self.startButton.backgroundColor=UIColorFromRGB(0x959595);
                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                //  NSURL *URL = [NSURL URLWithString:fileURL];
                NSURLRequest *request ;
                if ([self.performanceType isEqualToString:@"DUET"]) {
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.recording.onlineMp3Recording]];
                }else{
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.song.songUrl]];
                }
                self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.processDownloadSong.progress=downloadProgress.fractionCompleted;
                        
                        waitTime=30-downloadProgress.fractionCompleted*30;
                        
                       self.waitTimeLabel.text=[NSString stringWithFormat:AMLocalizedString(@"Đang chuẩn bị phòng thu %0.f%%", nil),downloadProgress.fractionCompleted *100];
                        
                    });
                }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    //  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
                    if ([self.song.songUrl isKindOfClass:[NSString class]])
                    if ([self.song.songUrl hasSuffix:@"m4a"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",self.song._id]];
                    }
                    if (self.song.videoId.length>2){
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song.videoId]];
                        
                    }
                    if ([self.performanceType isEqualToString:@"DUET"]) {
                        filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
                    }
                    return [NSURL fileURLWithPath: filePath];
                    
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    if (error) {
                        
                    }else{
                        
                        
                        
                       
                        if ([self.performanceType isEqualToString:@"SOLO"] || [self.song.mp4link isKindOfClass:[NSString class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.processDownloadSong.hidden = YES;
                            self.waitStatusView.hidden=YES;
                            self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
                            self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
                            // [fileData writeToFile:filePath atomically:YES];
                            self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
                            self.StartButton2.hidden=NO;
                            self.startButton.hidden=NO;
                        });
                        
                        }
                        
                        
                        
                        
                        if (!hasHeadset) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.headphoneWarningView.transform=CGAffineTransformMakeScale(0,0);
                                
                                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                    self.headphoneWarningView.transform=CGAffineTransformMakeScale(1,1);
                                    self.headphoneWarningView.hidden=NO;
                                    
                                } completion:^(BOOL finished) {
                                    
                                }];
                            });
                        }
                        
                        
                        
                        
                    }
                }];
                [self.downloadTask resume];
                // [self.download startWithDelegate:self];
            }
        }
        else if ([self.song.mp4link isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.waitStatusView.hidden=YES;
                self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
                self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
                    // [fileData writeToFile:filePath atomically:YES];
                self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
                self.StartButton2.hidden=NO;
                self.startButton.hidden=NO;
            });
        }
    }
}
#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [self.titles objectAtIndex:item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
 return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (IBAction)beautyButtonPress:(id)sender {
    isEnableBeauty=!isEnableBeauty;
    if (isEnableBeauty) {
        
        if (filterView.selectedFilter.subFilters.count==0) {
            [filterView.selectedFilter addSubFilter:self.beautiFilter];
            
        }
        [self.beautyButton setImage:[UIImage imageNamed:@"beautiFace.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        if (filterView.selectedFilter.subFilters.count>0) {
            [filterView.selectedFilter removeSubFilter:self.beautiFilter];
            
        }
        [self.beautyButton setImage:[UIImage imageNamed: @"beautiFace-None.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
    currentFilter=filterView.selectedFilter;
}
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    //NSLog(@"%@", [self.titles objectAtIndex:item]);
    [filterView setSelectedFilter:[filterView.filters objectAtIndex:(item%filterView.filters.count)]];
    if (item>=filterView.filters.count*2) {
        [pickerView selectItem:(item%filterView.filters.count+filterView.filters.count) animated:NO];
        //[pickerView scrollToItem:filterView.filters.count animated:NO];
        
        //pickerView.selectedItem = filterView.filters.count;
    }
    if (isEnableBeauty) {
        if (filterView.selectedFilter.subFilters.count==0) {
            [filterView.selectedFilter addSubFilter:self.beautiFilter];
            
        }
        
    }else{
        if (filterView.selectedFilter.subFilters.count>0) {
            [filterView.selectedFilter removeSubFilter:self.beautiFilter];
            
        }
        
    }
}
- (void)swipeableFilterView:(SCSwipeableFilterView *__nonnull)swipeableFilterView didScrollToFilter:(SCFilter *__nullable)filter{
    NSInteger index=[ swipeableFilterView.filters indexOfObject:filter];
    [self.pickerView selectItem:(index+swipeableFilterView.filters.count) animated:YES];
    filterName=[filterNames objectAtIndex:index];
    if (isEnableBeauty) {
        
        if (filterView.selectedFilter.subFilters.count==0) {
            [filterView.selectedFilter addSubFilter:self.beautiFilter];
            
        }
        
    }else{
        if (filterView.selectedFilter.subFilters.count>0) {
            [filterView.selectedFilter removeSubFilter:self.beautiFilter];
            
        }
        
    }
    //[self hideTipVideoEffect];
}

/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */


- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
{
    label.textColor = [UIColor lightGrayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    //label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count saturation:1.0  brightness:1.0 alpha:1.0];
}


/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
 return CGSizeMake(40, 20);
 }
 */
- (void) hideTipVideoEffect{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipChangeEffectVideoView.hidden=YES;
    });
}
- (void) showTipVideoEffect{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipChangeEffectVideoView.hidden=NO;
    });
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipVideoEffect) object:nil];
    [self performSelector:@selector(hideTipVideoEffect) withObject:nil afterDelay:3];
}
BOOL videoRecord;
Recording * recordingPlaying;
double timeRecord;
- (void)viewDidLoad {
    NSLog(@"Prepare Record View");
    recordingPlaying=nil;
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath =[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/audioRecord"]];
    //TA01_record
    [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA01_record",@"description":@"Màn hình chọn thu âm"}];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
    }
    dataPath =[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/download"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dataPath]];
    }
    
    [[UISlider appearance] setMinimumTrackTintColor:UIColorFromRGB(ColorSlider)];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"thumb3.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushViewFromPrepare:)
                                                 name:@"pushViewFromPrepare" object:nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"sendDestroyStream" object:nil];
    //[NSThread detachNewThreadSelector:@selector(saveLyric) toTarget:self withObject:nil];
    self.MoLabel.hidden = YES;
    self.TatLabel.hidden = YES;
    //self.backViewlabel.text = AMLocalizedString(@"Đang lưu bài thu", nil);
    self.tipChangeEffectLabel.text = AMLocalizedString(@"Trượt để thay đổi hiệu ứng", nil);
    [self.startButton setTitle:AMLocalizedString(@"Bắt Đầu", nil) forState:UIControlStateNormal];
    self.headphoneTitleLabel.text = AMLocalizedString(@"Thông báo", nil);
    self.headphoneDesLabel.text = AMLocalizedString(@"Để thu âm có chất lượng cao,\nbạn hãy cắm tai nghe khi thu âm.\nLúc đó Yokara sẽ chỉ thu âm giọng hát của bạn và tự động trộn với nhạc nền gốc.", nil);
    self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
    self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
    isEnableBeauty=NO;
    self.beautyButton.hidden=YES;
    self.startButton.hidden = YES;
    canChangeCamera=YES;
    [self.beautyButton setImage:[UIImage imageNamed: @"beautiFace-None.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [self checkDeviceAuthorizationStatus];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.processDownloadSong.transform = transform;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width-50, self.view.frame.size.width, 50)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.maskDisabled = false;
    self.tipChangeEffectVideoView.layer.cornerRadius=self.tipChangeEffectVideoView.frame.size.height/2;
    self.tipChangeEffectVideoView.layer.masksToBounds=YES;
    
    
    [super viewDidLoad];
    recorder= [SCRecorder recorder]; // You can also use +[SCRecorder sharedRecorder]
    
    
    
    // Create a new session and set it to the recorder
    // recorder.session = [SCRecordSession recordSession];
    //recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    //   recorder.maxRecordDuration = CMTimeMake(10, 1);
    //    _recorder.fastRecordMethodEnabled = YES;
    
    recorder.autoSetVideoOrientation = NO; //YES causes bad orientation for video from camera roll
    
    //    audioPlayer.SCImageView = filterView;
    // [audioPlayer.SCImageView setContentMode:UIViewContentModeTopRight];
    
    //[self.previewLayer insertSubview:filterView atIndex:2];
    
    self.previewLayer.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    // filterView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    UIView *previewView = self.previewLayer;
    recorder.previewView = previewView;
    //recorder.previewView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    recorder.previewView.center=self.view.center;
    CGRect filterLabelFrame=self.filterLabel.frame;
    filterLabelFrame.origin.y=previewView.frame.origin.y-50;
    self.filterLabel.frame=filterLabelFrame;
    self.beautyButton.frame=CGRectMake(0, self.previewLayer.frame.origin.y, 50, 50);
    // Set the AVCaptureSessionPreset for the underlying AVCaptureSession.
    recorder.captureSessionPreset = AVCaptureSessionPresetMedium;
    
    // Set the video device to use
    recorder.device = AVCaptureDevicePositionFront;
    recorder.mirrorOnFrontCamera=YES;
    // Set the maximum record duration
    //recorder.maxRecordDuration = CMTimeMake(10, 1);
    
    // Listen to the messages SCRecorder can send
    //recorder.delegate = self;
    
    
    SCVideoConfiguration *video = recorder.videoConfiguration;
    //video.filter = currentFilter;
    // Whether the video should be enabled or not
    // video.enabled = YES;
    // The bitrate of the video video
    //video.bitrate = 2000000; // 2Mbit/s
    // video.scalingMode= AVVideoScalingModeFit;
    video.sizeAsSquare=YES;
    SCAudioConfiguration *audio = recorder.audioConfiguration;
    
    // Whether the audio should be enabled or not
    audio.enabled = NO;
    //YUCIHighPassSkinSmoothing* skinsmooth=[[YUCIHighPassSkinSmoothing alloc] init];
    //skinsmooth.inputAmount=[NSNumber numberWithFloat:0.6];
    // self.beautiFilter=[[SCFilter alloc] initWithCIFilter: skinsmooth];
    
    SCFilter *emptyFilter = [SCFilter emptyFilter];
    
    SCFilter *bloomF=[SCFilter filterWithCIFilterName:@"CIBloom"];
    [bloomF setParameterValue:@(0.5) forKey:kCIInputIntensityKey];
    [bloomF setParameterValue:@(10) forKey:kCIInputRadiusKey];
    filterView=[[SCSwipeableFilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*1.33333333)];
    filterView.filters = @[
                           emptyFilter,
                           
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"],
                           // Adding a filter created using CoreImageShop
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectMono"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectProcess"],
                           [SCFilter filterWithCIFilterName:@"CIPhotoEffectTransfer"]
                           ,[SCFilter filterWithCIFilterName:@"CISepiaTone"]
                           /*,
                            
                            [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]],
                            
                            [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HueTim" withExtension:@"cisf"]],
                            
                            [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HueBlue" withExtension:@"cisf"]]*/];
    filterNames=[NSMutableArray arrayWithObjects: @"",@"CIPhotoEffectNoir",@"CIPhotoEffectChrome",@"CIPhotoEffectInstant",@"CIPhotoEffectTonal",@"CIPhotoEffectFade",@"CIPhotoEffectMono",@"CIPhotoEffectProcess",@"CIPhotoEffectTransfer",@"CISepiaTone", nil];
    filterView.delegate=self;
    filterView.scaleAndResizeCIImageAutomatically=NO;
    filterView.contentMode=UIViewContentModeScaleAspectFit;
    filterView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    currentFilter=filterView.selectedFilter; self.titles=@[@"None",@"Noir",@"Chrome",@"Instant",@"Tonal",@"Fade",@"Mono",@"Process",@"Transfer",@"Sepia",@"None",@"Noir",@"Chrome",@"Instant",@"Tonal",@"Fade",@"Mono",@"Process",@"Transfer",@"Sepia",@"None",@"Noir",@"Chrome",@"Instant",@"Tonal",@"Fade",@"Mono",@"Process",@"Transfer",@"Sepia"];//,@"Organe",@"Purple",@"Emerald"
    
    [self.pickerView reloadData];
    [self.pickerView selectItem:filterView.filters.count animated:NO];
    [filterView addObserver:self forKeyPath:@"selectedFilter" options:NSKeyValueObservingOptionNew context:nil];
    //[filterView setContentMode:UIViewContentModeCenter];
    recorder.SCImageView = filterView;
    [self.previewLayer addSubview:filterView];
    self.tipChangeEffectVideoView.center=self.previewLayer.center;
    self.tipChangeEffectVideoView.hidden=NO;
    [self performSelector:@selector(hideTipVideoEffect) withObject:nil afterDelay:3];
    filterView.frame=CGRectMake(0, (self.previewLayer.frame.size.height-filterView.frame.size.height)/2, self.view.frame.size.width, filterView.frame.size.height);
    self.pickerView.frame=CGRectMake(0, self.previewLayer.frame.size.height-50-filterView.frame.origin.y, self.view.frame.size.width, 50);
    [filterView addSubview:self.pickerView];
    UITapGestureRecognizer *gest=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTipVideoEffect)];
    [filterView addGestureRecognizer:gest];
    //filterView.center=self.view.center;
    // filterView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);;
    //recorder.SCImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    UIButton *backButton= [[UIButton alloc]  initWithFrame:CGRectMake(0, 0, 30, 30)];
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 9.0f )
    {
        [[backButton.widthAnchor constraintEqualToConstant:30] setActive:YES];
        [[backButton.heightAnchor constraintEqualToConstant:30] setActive:YES];
    }//initWithImage:[UIImage imageNamed:@"Back White.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]
    
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Back White.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    backButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    backButton.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem =leftButtonItem;
    self.deviceCamera=recorder.device;
    
    if ([self.song.mp4link isKindOfClass:[NSString class]]) {
        if (![self.song.mp4link hasPrefix:@"http"]) {
            [NSThread detachNewThreadSelector:@selector(loadYoutubeVieo) toTarget:self withObject:nil];
        }
        
        
    }else{
        [NSThread detachNewThreadSelector:@selector(loadYoutubeVieo) toTarget:self withObject:nil];
    }
    [NSThread detachNewThreadSelector:@selector(downloadSongMp3) toTarget:self withObject:nil];
    if (![recorder startRunning]) {
        NSLog(@"Something wrong there: %@", recorder.error);
    }
    self.processDownloadSong.hidden=NO;
    VideoRecord=YES;
    self.toggleViewButtonChange = [[ToggleView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.width-90)/2, 90, 75) toggleViewType:ToggleViewTypeNoLabel toggleBaseType:ToggleBaseTypeChangeImage toggleButtonType:ToggleButtonTypeChangeImage];
    self.toggleViewButtonChange.backgroundColor=[UIColor clearColor];
    self.toggleViewButtonChange.transform=  CGAffineTransformMakeScale(0.8,0.8);
    
    self.toggleViewButtonChange.center=self.selectRecordButton.center;
    self.toggleViewButtonChange.toggleDelegate = self;
    [self.toggleViewButtonChange setSelectedButton:ToggleButtonSelectedRight];
    
    [self.OnOffCameraView addSubview:self.toggleViewButtonChange];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkMemory" object:nil];
    self.audioView.hidden=YES;
    [self checkHeadSet];
    //if ([self.performanceType isEqualToString:@"SOLO"]) {
    
    //}
    //[self.startButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    //[self.startButton.layer setBorderWidth:1];
    // [self.selectRecordButton setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_vswitch_mo.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]]];
    self.thumnailImage.layer.cornerRadius=self.thumnailImage.frame.size.width/2;
    self.thumnailImage.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.7] CGColor];
    self.thumnailImage.layer.borderWidth = 3;
    self.thumnailImage.layer.masksToBounds=YES;
    self.thumnailImageFrame.layer.cornerRadius=self.thumnailImageFrame.frame.size.width/2;
    self.thumnailImageFrame.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.4] CGColor];
    self.thumnailImageFrame.layer.borderWidth = 2;
    self.thumnailImageFrame.layer.masksToBounds=YES;
    self.headphoneSubView.layer.cornerRadius= 10;
    self.headphoneSubView.layer.masksToBounds=YES;
    // self.startButton.layer.borderWidth = 5;
    //  self.startButton.layer.borderColor=[UIColorFromRGB(0x1A1A1A) CGColor];
    // [self.startButton.layer addAnimation:border forKey:@"border"];
    // frame2=self.startButton.frame;
    if (self.view.frame.size.width>320) {
       // [self animateStartButton];
        waitTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animateStartButton) userInfo:nil repeats:YES];
    }
    self.startButton.layer.cornerRadius=self.startButton.frame.size.height/2;
    self.startButton.layer.masksToBounds=YES;
    self.headphoneWarningOkButton.layer.borderWidth=1;
    self.headphoneWarningOkButton.layer.borderColor=[UIColorFromRGB(0xD3D6DB) CGColor];
    [self.thumnailImage sd_setImageWithURL:[NSURL URLWithString:self.song.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"icn_mac_dinh_profile5.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] options:SDWebImageDelayPlaceholder];
    
    if ([self.song.songName isKindOfClass:[NSString class]])
        self.songName.text=self.song.songName;
    else self.songName.text=@"";
    if ([self.song.singerName isKindOfClass:[NSString class]] && [self.performanceType isEqualToString:@"DUET"])
        self.singerName.text=self.song.singerName;
    else self.singerName.text=@"";
    self.processDownloadSong.progressTintColor = UIColorFromRGB(HeaderColor);
    self.processDownloadSong.hidden = NO;
    self.gradient = [CAGradientLayer layer];
    
    self.gradient.frame = self.infoView.bounds;
    UIColor *topColor=[UIColor blackColor];
    UIColor *botColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.7];
    self.gradient.colors = @[(id)topColor.CGColor,(id)botColor.CGColor];
    self.gradient.startPoint=CGPointMake(0.7, 0.5);
    self.infoView.backgroundColor=[UIColor clearColor];
    self.toolBarView.backgroundColor=[UIColor clearColor];
    [self.infoView.layer insertSublayer:self.gradient atIndex:0];
    // [self.infoView setAlpha:0.9];
    self.gradient2 = [CAGradientLayer layer];
    
    self.gradient2.frame = self.toolBarView.bounds;
    self.gradient2.colors = @[(id)botColor.CGColor,(id)topColor.CGColor];
    self.gradient2.startPoint=CGPointMake(0.3, 0);
    [self.toolBarView.layer insertSublayer:self.gradient2 atIndex:0];
    //[self.toolBarView setAlpha:0.9];
    // Do any additional setup after loading the view.
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
- (IBAction)startRecord:(id)sender {
    demShowAlertRate+=2;

        if (VideoRecord) {
            [self startVideoRecordWithTone];
        }else{
            [self startAudioRecordWithTone];
        }
   
}

- (void)addFavorite:(Song *)theSong{
    @autoreleasepool {
       
    }
    
}
- (void)waitTimeChange{
    dispatch_async(dispatch_get_main_queue(), ^{
        waitTime++;
        self.waitTimeLabel.text=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"Thời gian chờ:", nil),[[LoadData2 alloc] convertTimeToString:waitTime]];
    });
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
NSString* recordVieoQuality;
- (void) setVideoRec{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    canChangeCamera=YES;
    // Setup the preview view
    [[self previewLayer] setSession:session];
    
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue 2", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async([self sessionQueue], ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        AVCaptureDevice *videoDevice;
        if (useBackCamera){
            videoDevice = [PrepareRecordViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        }else{
            videoDevice = [PrepareRecordViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
        }
        
        
        
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"setting camera error: %@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                [[(AVCaptureVideoPreviewLayer *)[[self previewLayer] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
                [(AVCaptureVideoPreviewLayer *)[[self previewLayer] layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                // self.previewView .frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                // [[[self previewLayer] layer] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
                //  CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
                // self.previewView.transform = transform;
            });
        }
        [session beginConfiguration];
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
        [session commitConfiguration];
        
        /*AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
         AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
         
         if (error)
         {
         NSLog(@"%@", error);
         }
         
         if ([session canAddInput:audioDeviceInput])
         {
         [session addInput:audioDeviceInput];
         }*/
        
        
    });
}

BOOL gotoXulyView;
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.toggleViewButtonChange.center=self.selectRecordButton.center;
    self.gradient.frame = self.infoView.frame;
}
- (void) pushViewFromPrepare:(NSNotification *) notification {
    @autoreleasepool {
        UIViewController *mainv=(UIViewController *)notification.object;
        
        mainv.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController  pushViewController:mainv animated:YES];
        
    }
}
- (void)viewWillAppear:(BOOL)animated{
    if (resetRecord) {
        resetRecord=NO;
        demShowAlertRate+=2;
        if (VideoRecord) {
            [self startVideoRecordWithTone];
        }else{
            [self startAudioRecordWithTone];
        }
    }
    if (gotoXulyView){
        gotoXulyView=NO;
       
        /*StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
        if (![songRec.performanceType isEqualToString:@"SOLO"]) {
            mainv.delayLyricDuet=[songRec.delay doubleValue]/1000;
        }
        [self.navigationController pushViewController:mainv animated:YES];
          dispatch_async([self sessionQueue], ^{
         if ([[self session] isRunning]){
         [[self session] stopRunning];
         [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
         [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
         
         //  [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
         //  [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.navigationController pushViewController:mainv animated:YES];
         });
         }else{
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.navigationController pushViewController:mainv animated:YES];
         });
         }
         });*/
    }
    
   
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    /* dispatch_async([self sessionQueue], ^{
     // [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
     //   [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
     
     __weak PrepareRecordViewController *weakSelf = self;
     [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
     PrepareRecordViewController *strongSelf = weakSelf;
     dispatch_async([strongSelf sessionQueue], ^{
     // Manually restarting the session since it must have been stopped due to an error.
     [[strongSelf session] startRunning];
     NSLog(@"Start camera session runtime error");
     //[[strongSelf recordButton] setTitle:AMLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
     });
     }]];
     [[self session] startRunning];
     
     });*/
    
    [super viewWillAppear:YES];
}
/*
- (void) demTGTone{
    if (demTimeTone==10 || demTimeTone==20 || demTimeTone==1 || demTimeTone==30){
        [demToneTimer invalidate];
        demToneTimer=nil;
        GetPitchShiftedSongLinkResponse * respone=[[LoadData2 alloc] GetPitchShiftedSongLink:self.song._id withPitchShift:[NSNumber numberWithInteger: self.toneOfSong*2]];
        if (respone.status.length>0){
            if ([respone.status isEqualToString:@"READY"]){
                // [demToneTimer invalidate];
                
                demTimeTone=30;
                
                [demToneTimer invalidate];
                demToneTimer=nil;
                
                self.song.songUrlOld=[NSString stringWithFormat:@"%@",self.song.songUrl];
                self.song.songUrl=respone.link;
                
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
}*/
- (void) finishGetTone{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@-Tone%d.mp3",self.song._id,self.toneOfSong]];
    
    
    //  [self.selectRecordButton setOnImage:[UIImage imageNamed:@"icn_vswitch_mo.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    // [self.selectRecordButton setOffImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    
    BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (haveS){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.startButton.hidden=NO;
            self.StartButton2.hidden=NO;
            self.waitStatusView.hidden=YES;
            self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
            self.processDownloadSong.progress=1;
            self.processDownloadSong.hidden = YES;
            self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
            self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
            if (!hasHeadset) {
                self.headphoneWarningView.transform=CGAffineTransformMakeScale(0,0);
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.headphoneWarningView.transform=CGAffineTransformMakeScale(1,1);
                    self.headphoneWarningView.hidden=NO;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        });
    }else{
        [NSThread detachNewThreadSelector:@selector(saveLyric) toTarget:self withObject:nil];
        waitTime=0;
        //
        self.startButton.hidden=YES;
        self.StartButton2.hidden=YES;
        // self.startButton.backgroundColor=UIColorFromRGB(0x959595);
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        //  NSURL *URL = [NSURL URLWithString:fileURL];
        NSURLRequest *request ;
        if ([self.performanceType isEqualToString:@"DUET"]) {
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.recording.onlineMp3Recording]];
        }else{
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.song.songUrl]];
        }
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.processDownloadSong.progress=downloadProgress.fractionCompleted;
                waitTime=(NSInteger)(30-downloadProgress.fractionCompleted*30);
               self.waitTimeLabel.text=[NSString stringWithFormat:AMLocalizedString(@"Đang chuẩn bị phòng thu %0.f%%", nil),downloadProgress.fractionCompleted*100];
            });
        }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            //  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            //NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //  NSString *filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.song._id]];
            //if ([self.performanceType isEqualToString:@"DUET"]) {
            //  filePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",self.recording.recordingId]];
            //}
            return [NSURL fileURLWithPath: filePath];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    waitTime=0;
                    self.StatusWaitLabel.text=@"Đã xảy ra lỗi khi chuẩn bị bài thu. Vui lòng quay lại sau!";
                    self.waitTimeLabel.hidden=YES;
                });
            }else{
                NSLog(@"File downloaded to: %@", filePath);
                self.waitStatusView.hidden=YES;
                self.processDownloadSong.hidden = YES;
                self.statusLabel.text=AMLocalizedString(@"Chuẩn bị phòng thu", nil);
                self.statusLabel2.text=AMLocalizedString(@"cho buổi ghi âm của bạn", nil);
                [self addSkipBackupAttributeToItemAtURL:filePath];
                // [fileData writeToFile:filePath atomically:YES];
                self.startButton.backgroundColor=UIColorFromRGB(HeaderColor);
                self.StartButton2.hidden=NO;
                self.startButton.hidden=NO;
                
                
              
                
                
                
                if (!hasHeadset) {
                    self.headphoneWarningView.transform=CGAffineTransformMakeScale(0,0);
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.headphoneWarningView.transform=CGAffineTransformMakeScale(1,1);
                        self.headphoneWarningView.hidden=NO;
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }
        }];
        [self.downloadTask resume];
        // [self.download startWithDelegate:self];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushViewFromPrepare" object:nil];
    [filterView removeObserver:self forKeyPath:@"selectedFilter"];
    [self setSession:nil];
    [self setSessionQueue:nil];
}
- (void) viewWillDisappear:(BOOL)animated{
    
    if (demToneTimer) {
        [demToneTimer invalidate];
        demToneTimer=nil;
    }
    //[recorder.session cancelSession:nil];
    // recorder=nil;
    //  [recorder stopRunning];
    [super viewWillDisappear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    });
    //  [[self previewLayer] setSession:nil];
    // [self.previewLayer removeFromSuperview];
    //self.previewLayer=nil;
    
    
    
    
    /*  dispatch_async([self sessionQueue], ^{
     if ([[self session] isRunning]){
     
     [[self session] stopRunning];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
     [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
     
     
     
     //[self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
     //  [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
     }
     });*/
    
    //  [self setSession:nil];
    //[self setSessionQueue:nil];
    if (waitTimer) {
        [waitTimer invalidate];
        waitTimer=nil;
    }
    // Setup the preview view
    
    
}
- (void) startVideoRecordWithTone{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (![[LoadData2 alloc]checkNetwork]) {
        return;
    }
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
                [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA04_record_start_video",@"description":@"Màn hình bắt đầu thu âm video"}];
                if (recorder) {
                    [recorder stopRunning];
                    [recorder unprepare];
                    recorder=nil;
                }
                
                
                videoRecord=YES;
                playTopRec=NO;
                playRecUpload=NO;
                songPlay= self.song;
                
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [dateFormatter setTimeZone:gmtZone];
                [dateFormatter setLocale:[NSLocale systemLocale]];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                //NSLog(@"%@",dateString);
                Recording *rec=[Recording new];
                rec.song=[Song new];
                rec.effects=[EffectsR new];
                rec.recordingTime=dateString;
                rec.songId=self.song._id;
                rec._id=self.song._id;
                rec.song.lyrics = self.song.lyrics;
                rec.song.videoId=self.song.videoId;
                rec.song._id=self.song._id;
                rec.song.songUrl=self.song.songUrl;
                rec.song.songName=self.song.songName;
                rec.song.singerName=self.song.singerName;
                rec.song.approvedLyric=self.song.approvedLyric;
                rec.song.videoId=self.song.videoId;
                rec.song.thumbnailUrl=self.song.thumbnailUrl;
                rec.song.likeCounter=self.song.likeCounter;
                rec.song.dislikeCounter=self.song.dislikeCounter;
                rec.song.duration=self.song.duration;
                rec.performanceType=self.performanceType;
                rec.owner2=self.recording.owner;
                rec.lyric=self.lyricForDuet;
                rec.thumbnailImageUrl=self.song.thumbnailUrl;
                rec.song.mp4link=self.song.mp4link;
                rec.owner = currentFbUser;
                rec.localDBId = localRecordId;
                if ([self.performanceType isEqualToString:@"DUET"]) {
                    rec.originalRecording=self.recording.recordingId;
                    rec.mixedRecordingVideoUrl=self.recording.mixedRecordingVideoUrl;
                    rec.song.singerName=self.recording.owner.name;
                    if (rec.song.singerName.length==0) {
                        rec.song.singerName=@"";
                    }
                    rec.sex=self.recording.sex;
                }else{
                    rec.sex=@"m";
                    NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                    if (gender.length>0) {
                        if ([gender isEqualToString:@"female"]) {
                            rec.sex=@"f";
                        }
                    }
                }
                songRec=rec;
                songRec.recordingType=@"VIDEO";
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
                dispatch_async(dispatch_get_main_queue(), ^{
                self.backView.hidden=NO;
                   
                StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
                // [mainv creatAudioEngine];
                if ([self.performanceType isEqualToString:@"DUET"]) {
                    mainv.delayLyricDuet=[self.recording.delay doubleValue]/1000;
                }
                if (currentFilter) {
                    if (!currentFilter.isEmpty) {
                        mainv.currentFilter=currentFilter;
                        mainv.currentFilterCIName=filterName;
                        mainv.enableBeauty=isEnableBeauty;
                    }
                    
                }
                mainv.deviceCamera=self.deviceCamera;
                [self.navigationController pushViewController:mainv animated:YES];
                    
                  });
                
            }
            
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                // We're in a background thread here, so jump to main thread to do UI work.
                dispatch_async(dispatch_get_main_queue(), ^{
                    alertOpenSetting= [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Mở quyền truy cập", nil)
                                                                 message:[NSString stringWithFormat: AMLocalizedString(@"Ứng dụng cần truy cập %@ để có thể thu âm. Bạn có thể mở quyền trong cài đặt ứng dụng", nil),AMLocalizedString(@"Micrô", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:AMLocalizedString(@"Xác nhận", nil)
                                                       otherButtonTitles:nil];
                    [alertOpenSetting show];
                });
            }
        }];
    }
}
- (void) startAudioRecordWithTone{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    if (![[LoadData2 alloc]checkNetwork]) {
        return;
    }
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
              
                if (recorder) {
                    [recorder stopRunning];
                    [recorder unprepare];
                    recorder=nil;
                }
                [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA04_record_start_audio",@"description":@"Màn hình bắt đầu thu âm audio"}];
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
                videoRecord=NO;
                playTopRec=NO;
                playRecUpload=NO;
                songPlay= self.song;
                
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                [dateFormatter setLocale:[NSLocale systemLocale]];
                NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [dateFormatter setTimeZone:gmtZone];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                //NSLog(@"%@",dateString);
                Recording *rec=[Recording new];
                rec.song=[Song new];
                rec.effects=[EffectsR new];
                rec.recordingTime=dateString;
                rec.songId=self.song._id;
                rec._id=self.song._id;
                rec.song.lyrics = self.song.lyrics;
                rec.song._id=self.song._id;
                rec.song.videoId=self.song.videoId;
                rec.song.songUrl=self.song.songUrl;
                rec.song.songName=self.song.songName;
                rec.song.singerName=self.song.singerName;
                rec.song.approvedLyric=self.song.approvedLyric;
                rec.song.videoId=self.song.videoId;
                rec.song.thumbnailUrl=self.song.thumbnailUrl;
                rec.song.likeCounter=self.song.likeCounter;
                rec.song.dislikeCounter=self.song.dislikeCounter;
                rec.song.duration=self.song.duration;
                rec.song.mp4link=self.song.mp4link;
                rec.owner2=self.recording.owner;
                rec.performanceType=self.performanceType;
                rec.lyric=self.lyricForDuet;
                rec.thumbnailImageUrl=self.song.thumbnailUrl;
                rec.owner = currentFbUser;
                rec.localDBId = localRecordId;
                if ([self.performanceType isEqualToString:@"DUET"]) {
                    rec.originalRecording=self.recording.recordingId;
                    rec.mixedRecordingVideoUrl=self.recording.mixedRecordingVideoUrl;
                    rec.song.singerName=self.recording.owner.name;
                    if (rec.song.singerName.length==0) {
                        rec.song.singerName=@"";
                    }
                    rec.sex=self.recording.sex;
                }else{
                    
                    rec.sex=@"m";
                    NSString *gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
                    if (gender.length>0) {
                        if ([gender isEqualToString:@"female"]) {
                            rec.sex=@"f";
                        }
                    }
                }
                songRec=rec;
                songRec.recordingType=@"AUDIO";
                isrecord=YES;
                playRecord=NO;
                playVideoRecorded=NO;
                //StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
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
                // UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.backView.hidden=NO;
                   
                    StreamingMovieViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Hát"];
                    
                    if ([self.performanceType isEqualToString:@"DUET"]) {
                        mainv.delayLyricDuet=[self.recording.delay doubleValue]/1000;
                    }
                    mainv.deviceCamera=self.deviceCamera;
                    [self.navigationController pushViewController:mainv animated:YES];
                    
                });
                // [[MainViewController alloc] initWithPlayer:self.song._id];
                // [self presentViewController:mainv animated:YES completion:nil];
                // [self.parentNavigationController presentViewController:mainv animated:YES completion:nil];
                //   }
                //
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                // We're in a background thread here, so jump to main thread to do UI work.
                dispatch_async(dispatch_get_main_queue(), ^{
                    alertOpenSetting= [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Mở quyền truy cập", nil)
                                                                 message:[NSString stringWithFormat: AMLocalizedString(@"Ứng dụng cần truy cập %@ để có thể thu âm. Bạn có thể mở quyền trong cài đặt ứng dụng", nil),AMLocalizedString(@"Micrô", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:AMLocalizedString(@"Xác nhận", nil)
                                                       otherButtonTitles:nil];
                    [alertOpenSetting show];
                });
            }
        }];
    }
}
#pragma mark - ToggleViewDelegate

- (void)selectLeftButton
{
    NSLog(@"LeftButton Selected");
    VideoRecord=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipChangeEffectVideoView.hidden=YES;
        self.previewLayer.hidden=YES;
        self.audioView.hidden=NO;
        self.cameraButton.hidden=YES;
        self.gradient.hidden=YES;
        self.gradient2.hidden=YES;
        //  self.startButton.layer.borderColor=[[UIColor whiteColor] CGColor];
        // [self.selectRecordButton setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]]];
        // self.toolBarView.backgroundColor=[UIColor whiteColor];
        // self.infoView.backgroundColor=UIColorFromRGB(0xf5f7f6);
        self.waitTimeLabel.textColor=[UIColor lightGrayColor];
        self.StatusWaitLabel.textColor=[UIColor darkGrayColor];
        self.waitTimeLoading.tintColor=[UIColor darkGrayColor];
        self.songName.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        self.singerName.textColor=[UIColor darkGrayColor];
        self.TatLabel.textColor=[UIColor lightGrayColor];
        self.MoLabel.textColor=[UIColor lightGrayColor];
        [self.closeButton setImage:[UIImage imageNamed:@"Dong_3.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    });
}

- (void)selectRightButton
{
    NSLog(@"RightButton Selected");
    VideoRecord=YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.previewLayer.hidden=NO;
        self.cameraButton.hidden=NO;
        self.audioView.hidden=YES;
        self.gradient.hidden=NO;
        self.gradient2.hidden=NO;
        //[self.selectRecordButton setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_vswitch_mo.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]]];
        // self.toolBarView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        // self.infoView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        self.songName.textColor=[UIColor whiteColor];
        self.singerName.textColor=[UIColor whiteColor];
        self.waitTimeLabel.textColor=[UIColor whiteColor];
        self.StatusWaitLabel.textColor=[UIColor whiteColor];
        self.waitTimeLoading.tintColor=[UIColor whiteColor];
        self.TatLabel.textColor=[UIColor whiteColor];
        self.MoLabel.textColor=[UIColor whiteColor];
        //self.startButton.layer.borderColor=[UIColorFromRGB(0x1A1A1A) CGColor];
        [self.closeButton setImage:[UIImage imageNamed:@"Dong_2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    });
    
}
- (IBAction)changeAudioVideoRecord:(id)sender {
    if (self.selectRecordButton.isOn) {
        self.previewLayer.hidden=NO;
        self.audioView.hidden=YES;
        self.gradient.hidden=NO;
        self.gradient2.hidden=NO;
        //[self.selectRecordButton setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_vswitch_mo.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]]];
        //self.toolBarView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        // self.infoView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        self.songName.textColor=[UIColor whiteColor];
        self.singerName.textColor=[UIColor whiteColor];
        self.waitTimeLabel.textColor=[UIColor whiteColor];
        self.StatusWaitLabel.textColor=[UIColor whiteColor];
        self.waitTimeLoading.tintColor=[UIColor whiteColor];
        self.TatLabel.textColor=[UIColor whiteColor];
        self.MoLabel.textColor=[UIColor whiteColor];
        //self.startButton.layer.borderColor=[UIColorFromRGB(0x1A1A1A) CGColor];
        [self.closeButton setImage:[UIImage imageNamed:@"Dong_2.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        self.tipChangeEffectVideoView.hidden=YES;
        self.previewLayer.hidden=YES;
        self.audioView.hidden=NO;
        self.gradient.hidden=YES;
        self.gradient2.hidden=YES;
        //  self.startButton.layer.borderColor=[[UIColor whiteColor] CGColor];
        // [self.selectRecordButton setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_vswitch_tat.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]]];
        // self.toolBarView.backgroundColor=[UIColor whiteColor];
        // self.infoView.backgroundColor=UIColorFromRGB(0xf5f7f6);
        self.waitTimeLabel.textColor=[UIColor lightGrayColor];
        self.StatusWaitLabel.textColor=[UIColor darkGrayColor];
        self.waitTimeLoading.tintColor=[UIColor darkGrayColor];
        self.songName.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.96];
        self.singerName.textColor=[UIColor darkGrayColor];
        self.TatLabel.textColor=[UIColor lightGrayColor];
        self.MoLabel.textColor=[UIColor lightGrayColor];
        [self.closeButton setImage:[UIImage imageNamed:@"Dong_3.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertOpenSetting==alertView){
        if (buttonIndex==0){
            [LoadData2 openSettings];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == filterView) {
        currentFilter=filterView.selectedFilter;
        /*self.filterLabel.hidden = NO;
         self.filterLabel.text =[NSString stringWithFormat:@"%@", filterView.selectedFilter.name];
         self.filterLabel.alpha = 0;
         [UIView animateWithDuration:0.3 animations:^{
         self.filterLabel.alpha = 1;
         } completion:^(BOOL finished) {
         if (finished) {
         [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
         self.filterLabel.alpha = 1;
         } completion:^(BOOL finished) {
         
         }];
         }
         }];*/
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end

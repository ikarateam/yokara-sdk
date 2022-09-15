//
//  UploadRecordingViewController.m
//  Yokara
//
//  Created by APPLE on 3/20/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "UploadRecordingViewController.h"
//#import "StatusUploadRecordingViewController.h"
#import "ExtendedAudioFileConvertOperation.h"
@interface UploadRecordingViewController ()


@end

@implementation UploadRecordingViewController
- (IBAction)back:(id)sender {
    [demperc invalidate];
    demperc=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinishNotPublic" object:songRec];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [super viewDidDisappear:YES];
    [self.userNameTextView removeObserver:self forKeyPath:@"contentSize"];
    if (buttonTimer) {
        [buttonTimer invalidate];
        buttonTimer=nil;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.userNameTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void) uploadFileToServerIkara:(Recording *)tmp{
    @autoreleasepool {
        if ([[LoadData2 alloc] checkNetwork] && !uploadProssesing) {
            NSLog(@"Start upload");
            mixOfflineProssesing=NO;
            mixOfflineMessage=@"";
            recordingCurrentUpload = tmp;
            //hasShowPushRecording=NO;
            uploadProssesing=YES;
            FIRDatabaseReference * ref = [[FIRDatabase database] reference];
            bgTask= [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"UploadTask" expirationHandler:^{
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
                               
                                NSString *stringReply = (NSString *)result.data;
                                NSLog(@"Fir_SetProcessRecording %@",stringReply);
                                FirebaseFuntionResponse *respone = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                                // Some debug code, etc.
                                
                                
                            }];
                            
                            
                            
                            
                            tmp->statusUpload=nil;
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinish" object:tmp];
                         
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                            });
                            
                            vitriuploadRec=99999999;
                            uploadProssesing=NO;
                            tmp->isUploading=NO;
                        }else{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, respone.message]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                            });
                            uploadProssesing=NO;
                            tmp->isUploading=NO;
                            
                        }
                    }else{
                        if ([respone.message isKindOfClass:[NSString class]]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, respone.message]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
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
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinish" object:tmp];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                    });
                                    tmp->statusUpload=nil;
                                    uploadProssesing=NO;
                                    tmp->isUploading=NO;
                                }else{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, respone.message]];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                    });
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
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, respone.message]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                });
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
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinish" object:tmp];
                              //  if (tmp.onlineMp3Recording.length>4 || tmp.mixedRecordingVideoUrl.length>4 || VipMember) {
                                    
                                 
                                    
                                    tmp->statusUpload=nil;
                                    
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionViewUser" object:tmp];
                                    
                                  
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                                    });
                                    vitriuploadRec=99999999;
                                //}//else
                                   // [self configeDBRecordingStatus:tmp];
                                
                                
                            }else{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, AMLocalizedString(@"Xử lý bài thu thất bại", nil)]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
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
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFailWithError" object:[NSString stringWithFormat:@"%@:%@",tmp.localDBId, AMLocalizedString(@"Bài thu quá ngắn hoặc không có trong máy", nil)]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:YES completion:nil];//[self.navigationController popToRootViewControllerAnimated:NO];
                            });
                        });
                    }
                }
                uploadProssesing=NO;
                NSLog(@"tmp.onlineVocalUrl: %@",tmp.onlineVocalUrl);
               
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
                [self processMixOffline:self.recording];
            }else
                [self  uploadFileToServerIkara:self.recording];
    }
}
- (void) dempercen{
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusView.hidden = NO;
            //[self.xulyButt setTitle:AMLocalizedString(@"Hủy",nil) forState:UIControlStateNormal];
            if (mixOfflineProssesing) {
                
                if (mixOfflineMessage.length>0) {
                    self.statusLabel.text=mixOfflineMessage;
                    recordingCurrentUpload->statusUpload = mixOfflineMessage;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                }else {
                    self.statusLabel.text=AMLocalizedString( @"Đang chờ xử lý…",nil);
                    recordingCurrentUpload->statusUpload = AMLocalizedString( @"Đang chờ xử lý…",nil);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                }
                if (percent<100) {
                    self.pt.text=[NSString stringWithFormat:@"%d%%", [[NSNumber numberWithFloat:percent] intValue]];
                }else{
                    self.pt.text=@"";
                }
                
            }else
                
                    if ([[NSNumber numberWithFloat:percent] intValue] < 100 && uploadProssesing){
                        self.statusLabel.text=AMLocalizedString( @"Đang upload bài thu",nil);
                        self.pt.text=[NSString stringWithFormat:@"%d%%", [[NSNumber numberWithFloat:percent] intValue]];
                        recordingCurrentUpload->statusUpload = [NSString stringWithFormat:@"%@ %d%%",AMLocalizedString( @"Đang upload bài thu",nil), [[NSNumber numberWithFloat:percent] intValue]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                      
                    }else {
                        if (uploadProssesing==NO) {
                            
                            
                            
                            self.pt.text=@"";
                            /* RecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"Thu âm"];
                             // [[MainViewController alloc] initWithPlayer:nil];
                             
                             [self.navigationController pushViewController:mainv animated:YES];*/
                            
                            if ([self.recording->hasUpload isEqualToString:@"YES"]) {
                                self.statusLabel.text=AMLocalizedString( @"Upload thành công!",nil);
                                
                                recordingCurrentUpload->statusUpload = AMLocalizedString( @"Upload thành công!",nil);
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                                percent = 100;
                            }else{
                               
                                //self.isLoading.hidden=YES;
                                self.statusLabel.text=AMLocalizedString( @"Upload bài thu thất bại vui lòng kiểm tra kết nối mạng! Và thử lại sau!",nil);
                                recordingCurrentUpload->statusUpload = AMLocalizedString( @"Upload bài thu thất bại vui lòng kiểm tra kết nối mạng! Và thử lại sau!",nil);
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                                percent = 0;
                            }
                            self.statusView.hidden = YES;
                            [demperc invalidate];
                            demperc=nil;
                            //  [self.navigationController popToRootViewControllerAnimated:NO];
                            //  [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabBar" object:nil];
                            
                            
                        }else{
                            self.statusLabel.text=AMLocalizedString(@"Đang chờ xử lý…",nil);
                            //self.pt.text=@"";
                            recordingCurrentUpload->statusUpload = AMLocalizedString(@"Đang chờ xử lý…",nil);
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"mixingOfflineWithStatus" object:recordingCurrentUpload];
                        }
                    }
        });
    }
}
- (void) processMixOffline:(Recording *)tmp{
    @autoreleasepool {
        if ([[LoadData2 alloc] checkNetwork] && !uploadProssesing) {
            mixOfflineProssesing=YES;
            NSLog(@"Start mix ofline");
            recordingCurrentUpload = tmp;
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
                        mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.m4a",tmp.song._id]];
                    }
                if (tmp.song.videoId.length>2){
                    mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",tmp.song.videoId]];
                    
                }
                if ([tmp.performanceType isEqualToString:@"DUET"]) {
                    mp3Path = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@.mp3",tmp.originalRecording]];
                }
                BOOL haveS= [[NSFileManager defaultManager] fileExistsAtPath:mp3Path];
                if (!haveS) {
                    mixOfflineProssesing=NO;
                    [[UIApplication sharedApplication] endBackgroundTask:bgMixTask];
                    bgMixTask = UIBackgroundTaskInvalid;
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

- (void)hideKeyboard{
    [self.userNameTextView resignFirstResponder];
    [self.messageTextView resignFirstResponder];
}
- (void) animateButton{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.xulyButton.transform = CGAffineTransformMakeScale(1.1,1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.xulyButton.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
- (void)viewDidLoad{
    self.title=AMLocalizedString(@"Lời nhắn", nil);
    self.privacyLabel.text = AMLocalizedString(@"Chế độ công khai", nil);
    [self.xulyButton setTitle:AMLocalizedString(@"Phát hành", nil) forState:UIControlStateNormal];
    self.statusView.hidden = YES;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.view.frame.size.width>320) {
    [self animateButton];
    buttonTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animateButton) userInfo:nil repeats:YES];
    }
    self.xulyButton.layer.cornerRadius=4;
    self.xulyButton.layer.masksToBounds=YES;
    self.navigationController.navigationBarHidden=NO;
    self.userNameTextView.delegate=self;
    self.messageTextView.delegate=self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   /* NSString * facebookId=[prefs objectForKey:@"facebookId"];
    if (facebookId.length>0){
        self.userNameTextView.text = [prefs objectForKey:@"userName"];
        self.userNameTextView.editable=NO;
        self.userNameLabel.hidden=YES;
    }else{
        if ([prefs objectForKey:@"nameUpload"]) {
            self.userNameTextView.text = [prefs objectForKey:@"nameUpload"];
            self.userNameTextView.editable=YES;
            self.userNameLabel.hidden=YES;
        }
        
    }
    if (self.userNameTextView.text.length==0) {
        self.userNameTextView.editable=YES;
        self.userNameLabel.hidden=NO;
    }*/
    UITapGestureRecognizer *tap119 = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap119];
    UITapGestureRecognizer *tap19 = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(hideKeyboard)];
  // [self.messageTextView addGestureRecognizer:tap19];
   
    if ([self.recording.privacyLevel isKindOfClass:[NSString class]]) {
        if ([self.recording.privacyLevel isEqualToString:@"PRIVATE"]) {
            privacyRecordingisPrivate=YES;
        }
    }
    if (!privacyRecordingisPrivate) {
        self.privacyImage.image=[UIImage imageNamed:@"da_check.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    }else{
        self.privacyImage.image=[UIImage imageNamed:@"khong_checked.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    }
      self.messageLabel.hidden=YES;
    //NSString * messeage=  [prefs objectForKey:@"messageToUpload"];

    
        self.messageTextView.text = AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil);
        self.messageTextView.textColor = [UIColor lightGrayColor]; //optional
    /*
    if ([self.recording.performanceType isEqualToString:@"SOLO"]) {
         self.messageTextView.text =[NSString stringWithFormat:@"Hãy đến nghe tôi hát %@ và nhận xét nhé",[self.recording.song.songName uppercaseString]];
      
    }else if ([self.recording.performanceType isEqualToString:@"DUET"]){
        NSString *owner=self.recording.owner2.name;
        if (owner.length==0 ) {
             self.messageTextView.text =[NSString stringWithFormat:@"Tôi và bạn tôi hợp ca bài %@, hãy đến nghe chúng tôi hát",[self.recording.song.songName uppercaseString]];
        }else{
         self.messageTextView.text =[NSString stringWithFormat:@"Tôi và %@ hợp ca bài %@, hãy đến nghe chúng tôi hát",self.recording.owner2.name,[self.recording.song.songName uppercaseString]];
        }
    }else{
         self.messageTextView.text =[NSString stringWithFormat:@"Hãy hợp ca bài hát %@ cùng tôi nhé",[self.recording.song.songName uppercaseString]];
    }*/
    
    self.messageTextView.layer.cornerRadius=4;
    self.messageTextView.layer.borderWidth=1;
    self.messageTextView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.messageTextView.layer.masksToBounds=YES;
    self.messageTextView.delegate=self;
    if ([self.messageTextView.text isEqualToString:AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil)]) {
        self.characterCount.text=[NSString stringWithFormat:@"0/280"];
    }else{
        self.characterCount.text=[NSString stringWithFormat:@"%d/280",self.messageTextView.text.length];
    }
    //[self.messageTextView becomeFirstResponder];
 
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor darkTextColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadRec:(id)sender {
    if (isExportingVideo ||  isExportingVideoWithEffect || uploadProssesing) {
        // [[[[iToast makeText:AMLocalizedString(@"iKara đang xử lý bài hát vui lòng chờ giây lát", @"")]
        //  setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Thông báo", nil)
                                                         message:AMLocalizedString(@"Yokara đang xử lý bài thu trước! Vui lòng chờ trong giây lát!", nil)
                                                        delegate:self
                                               cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alertV performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        [demperc invalidate];
        demperc=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordFinishNotPublic" object:songRec];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    if ([[LoadData2 alloc] checkNetwork]){
       
          
            /* [Answers logContentViewWithName:@"Process"
             contentType:@"Process Record"
             contentId:@"PRProcess"
             customAttributes:@{}];*/
            //uploadProssesing=YES;
           
            nameUp = self.userNameTextView.text;
            messUp= self.messageTextView.text;
            if (nameUp==nil) nameUp=@"";
            if (messUp == nil) messUp=@"";
        if ([self.messageTextView.text isEqualToString:AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil)]) {
            messUp=@"";
        }
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //self.NameUpload.text = [prefs objectForKey:@"nameUpload"];
            //self.messageUpload.text =[prefs objectForKey:@"messageUpload"];
            [prefs setObject:nameUp forKey:@"nameUpload"];
            //[prefs setObject:messUp forKey:@"messageToUpload"];
        if (messUp.length>0) {
            self.recording.message=messUp;
        }
            //messUp=@"Fun";
            if (privacyRecordingisPrivate) {
                self.recording.privacyLevel=@"PRIVATE";
            }else
                self.recording.privacyLevel=@"PUBLIC";
        demperc= [NSTimer    scheduledTimerWithTimeInterval:1      target:self    selector:@selector(dempercen)    userInfo:nil   repeats:YES];
           // if (currentFilter.isEmpty || currentFilter==nil) {
            [NSThread detachNewThreadSelector:@selector(uploadFileToS3) toTarget:self withObject:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"recordStartProgress" object:self.recording];
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popToRootViewControllerAnimated:NO];
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"showStatusView" object:nil];
               //
               // [NSThread detachNewThreadSelector:@selector(uploadFileToServerIkara:) toTarget:self withObject:self.recording];
            /*}else{
               // currentFilter=self.filter;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addEffectForVideo" object:self.recording];
                
            }*/
            /*StatusUploadRecordingViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrangThaiUploadBaithuView"];
            //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
            // [[MainViewController alloc] initWithPlayer:theSong.ids];
            recordingCurrentUpload=songRec;
            
            [self.navigationController pushViewController:mainv animated:NO];*/
      
        
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView==self.messageTextView){
        if ([self.messageTextView.text isEqualToString:AMLocalizedString(@"Vui lòng nhập lời nhắn cho bài thu", nil)]) {
          self.characterCount.text=[NSString stringWithFormat:@"0/280"];
        }else{
            self.characterCount.text=[NSString stringWithFormat:@"%d/280",self.messageTextView.text.length];
        }
        
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}
- (IBAction)privacyChange:(id)sender {
    if (privacyRecordingisPrivate) {
        privacyRecordingisPrivate=NO;
   
        dispatch_async(dispatch_get_main_queue(),^{
            self.privacyImage.image=[UIImage imageNamed:@"da_check.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        });
    }else {
        privacyRecordingisPrivate=YES;
     
        dispatch_async(dispatch_get_main_queue(),^{
            self.privacyImage.image=[UIImage imageNamed:@"khong_checked.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        });
    }
    [self hideKeyboard];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

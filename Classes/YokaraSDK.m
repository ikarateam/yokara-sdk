
#import "YokaraSDK.h"
#import "PrepareRecordViewController.h"
#import "Song.h"
#import "DuetLyricKaraViewController.h"
#import "Recording.h"
#import "NavigationTopViewController.h"
#import "StreamingMovieViewController.h"
#import "LiveViewController.h"
#import "LogcatLine.h"
#import "SetLogcatRequest.h"
#import "OpenLiveRoomModel.h"
@interface YokaraSDK ()
@property (strong, nonatomic) LiveViewController *liveView;
@property (strong ,nonatomic) Song *song;
@property (strong ,nonatomic) Recording *recording;
@property (strong ,nonatomic) LiveRoom * liveroom;

@end

@implementation YokaraSDK
static NavigationTopViewController * navLive;
- (NSString *) getAllRecordingDB{
    NSString *recordsJson = [[LoadData2 alloc] getAllRecordDB];
    NSLog(@"getAllRecordingDB\n%@",recordsJson);
    return recordsJson;
}
- (NSString *) getAllSongDB{
    NSString *songsJson = [[LoadData2 alloc] getAllSongDB];
    NSLog(@"getAllSongDB\n%@",songsJson);
    return songsJson;
}
#pragma mark Logcat
- (void) sendLogFirebaseDebug:(NSNotification *)notifi{
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps.4", 0);
    
    dispatch_async(queue, ^{
        NSNumber * uId= [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
        if ([currentFbUser.uid longLongValue]>0) {
            uId = currentFbUser.uid;
        }
        NSString *mess=(NSString *)notifi.object;
        if (enableSendLogFirebase && [uId longLongValue]>0 && [mess isKindOfClass:[NSString class]]) {
            
            
            if ([mess isKindOfClass:[NSString class]]) {
                LogcatLine * line = [LogcatLine new];
                line.tag = @"Yokara";
                line.level = @"W";
                line.msg = mess;
                line.pid = [[NSBundle mainBundle] bundleIdentifier];
                SetLogcatRequest *firRequest = [SetLogcatRequest new];
                
                firRequest.logcatLine = line;
                firRequest.lastUID = [NSString stringWithFormat:@"%@",currentFbUser.uid];
                
                NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                FIRFunctions * functions = [FIRFunctions functions];
                
                
                [[functions HTTPSCallableWithName:Fir_SetLogCat] callWithObject:@{@"parameters":requestString}
                                                                     completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                   
                    NSString *stringReply = (NSString *)result.data;
                    //NSLog(@"Fir_SetLogCat %@",stringReply);
                    // FirebaseFuntionResponse *respone = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                    
                    
                }];/*
                    FIRDatabaseReference * _ref = [[FIRDatabase database] reference];
                    FIRDatabaseReference *userLastOnlineRef = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat: @"ikara/logcat/%@/logs",uId]];
                    [[userLastOnlineRef childByAutoId] setValue:@{@"time":[FIRServerValue timestamp],@"level":@"W",@"tag":@"Yokara",@"msg":mess} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error==nil) {
                    
                    }
                    }];*/
            }
            
        }
    });
}
- (void) sendLogFirebaseInfo:(NSNotification *)notifi{
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps.2", 0);
    
    dispatch_async(queue, ^{
        NSNumber * uId= [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
        if ([currentFbUser.uid longLongValue]>0) {
            uId = currentFbUser.uid;
        }
        NSString *mess=(NSString *)notifi.object;
        if (enableSendLogFirebase && [uId longLongValue]>0 && [mess isKindOfClass:[NSString class]]) {
            LogcatLine * line = [LogcatLine new];
            line.tag = @"Yokara";
            line.level = @"D";
            line.msg = mess;
            line.pid = [[NSBundle mainBundle] bundleIdentifier];
            SetLogcatRequest *firRequest = [SetLogcatRequest new];
            
            firRequest.logcatLine = line;
            firRequest.lastUID = [NSString stringWithFormat:@"%@",currentFbUser.uid];
            
            NSString * requestString = [[firRequest toJSONString] base64EncodedString];
            FIRFunctions * functions = [FIRFunctions functions];
            
            
            [[functions HTTPSCallableWithName:Fir_SetLogCat] callWithObject:@{@"parameters":requestString}
                                                                 completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
               
                NSString *stringReply = (NSString *)result.data;
                //NSLog(@"Fir_SetLogCat %@",stringReply);
                // FirebaseFuntionResponse *respone = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                
                
            }];/*
                FIRDatabaseReference * _ref = [[FIRDatabase database] reference];
                
                
                FIRDatabaseReference *userLastOnlineRef = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat: @"ikara/logcat/%@/logs",uId]];
                [[userLastOnlineRef childByAutoId] setValue:@{@"time":[FIRServerValue timestamp],@"level":@"D",@"tag":@"Yokara",@"msg":mess} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error==nil) {
                
                }
                }];*/
        }
    });
}
- (void) sendLogFirebaseFile{
    dispatch_queue_t queue = dispatch_queue_create("com.vnapps", 0);
    dispatch_async(queue, ^{
        NSNumber * uId= [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
        if ([currentFbUser.uid longLongValue]>0) {
            uId = currentFbUser.uid;
        }
        if (enableSendLogFirebase && [uId longLongValue]>0) {
            
            NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [allPaths objectAtIndex:0];
            NSString *filepath = [documentsDirectory stringByAppendingPathComponent:@"LogErr.txt"];
            NSError *error;
            NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
            
            if (error){
                NSLog(@"Error reading file: %@", error.localizedDescription);
            }
            
            // maybe for debugging...
            
            NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
            for (NSInteger i=countLog; i<listArray.count-1; i++) {
                NSString *mess=(NSString *)listArray[i];
                if ([mess isKindOfClass:[NSString class]]) {
                    LogcatLine * line = [LogcatLine new];
                    line.tag = @"Yokara";
                    line.level = @"I";
                    line.msg = mess;
                    line.pid = [[NSBundle mainBundle] bundleIdentifier];
                    SetLogcatRequest *firRequest = [SetLogcatRequest new];
                    
                    firRequest.logcatLine = line;
                    firRequest.lastUID = [NSString stringWithFormat:@"%@",currentFbUser.uid];
                    
                    NSString * requestString = [[firRequest toJSONString] base64EncodedString];
                    FIRFunctions * functions = [FIRFunctions functions];
                    
                    
                    [[functions HTTPSCallableWithName:Fir_SetLogCat] callWithObject:@{@"parameters":requestString}
                                                                         completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
                        
                        NSString *stringReply = (NSString *)result.data;
                        //NSLog(@"Fir_SetLogCat %@",stringReply);
                        //FirebaseFuntionResponse *respone = [[FirebaseFuntionResponse alloc] initWithString:stringReply error:&error];
                        
                        
                    }];/*
                        FIRDatabaseReference * _ref = [[FIRDatabase database] reference];
                        
                        
                        FIRDatabaseReference *userLastOnlineRef = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat: @"ikara/logcat/%@/logs",uId]];
                        [[userLastOnlineRef childByAutoId] setValue:@{@"time":[FIRServerValue timestamp],@"level":@"I",@"tag":@"Yokara",@"msg":mess} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        if (error==nil) {
                        
                        }
                        }];*/
                }
            }
            countLog=listArray.count;
        }else{
            return;
        }
    });
    [self performSelector:@selector(sendLogFirebaseFile) withObject:nil afterDelay:10];
}
- (void) setLogcatFir {
    NSString * uId;
    if ([currentFbUser.uid longLongValue]>0) {
        uId = [NSString stringWithFormat:@"%@",currentFbUser.uid];
    }else {
        uId = [[LoadData2 alloc] idForDevice];
    }
    if (uId.length>0){
        FIRDatabaseReference *hand = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat: @"ikara/logcat/%@/properties/lastRun",uId]];
        [hand setValue:[FIRServerValue timestamp] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
        }];
        FIRDatabaseReference *userLastOnlineRefe = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat: @"ikara/logcat/%@/properties/sendLogcat",uId]];
        _refHandleF =  [userLastOnlineRefe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.exists) {
                if([snapshot.value boolValue]) {
                    // connection established (or I've reconnected after a loss of connection)
                    
                    // add this device to my connections list
                    // this value could contain info about the device or a timestamp instead of just true
                   // SLSetupConfiguration *slConfig = [[SLSetupConfiguration alloc] initWithKey:@"b833d5eb51e4a0ba54ac531bdcf8d701bb05634c"];
                   // [Smartlook setupAndStartRecordingWithConfiguration:slConfig];
                    NSLog(@"enable Send Log Firebase");
                    enableSendLogFirebase=YES;
                    // [self performSelector:@selector(sendLogFirebaseFile) withObject:nil afterDelay:10];
                }else{
                   // [Smartlook stopRecording];
                    NSLog(@"disable Send Log Firebase");
                    enableSendLogFirebase=NO;
                }
            }else{
                enableSendLogFirebase=NO;
            }
            
        }];
    }
}
- (void) dealloc {
    
}
- (void) mixingOfflineWithStatus:(NSNotification *)object{
    Recording * recordMix = (Recording *) object.object;
    NSLog(@"mixingOfflineWithStatus %@ %d",recordMix->statusUpload,[recordMix.localDBId intValue]);
    if ([self.delegate respondsToSelector:@selector(mixingOfflineWithStatus:withProcess:ofLocalRecordID:)]) {
       
                [self.delegate mixingOfflineWithStatus:recordMix->statusUpload withProcess:percent ofLocalRecordID:recordMix.localDBId];
                
    }
}
- (void) recordFailWithError:(NSNotification *)errorString {
    NSString * statusStr = (NSString *) errorString.object;
    if ([self.delegate respondsToSelector:@selector(recordFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           // UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
           // [view dismissViewControllerAnimated:YES completion:^{
                [self.delegate recordFailWithError:statusStr ];
                
          //  }];
        });
    }
    [self removeNoti];
}
- (void) setupNoti {
    if (isSetUpNoti) {
        return;
    }
    isSetUpNoti = YES;
    self.ref =  [[FIRDatabase database] reference];
    NSString *url5=[NSString stringWithFormat: @"ikara/streams/bestNettyServerDomain"];
    
    _refHandleF8 = [[self.ref child:url5] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.exists) {
            NSString *streamServe=snapshot.value;
            
            if ([streamServe hasPrefix:@"data"]) {
                streamServer=streamServe;
            }else{
                streamServer=@"data.ikara.co";
            }
        }
        
    }];
    NSString *url8=[NSString stringWithFormat: @"ikara/users/%@/totalIcoin/",currentFbUser.facebookId];
    
    [[_ref child:url8] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        
        
        if (snapshot.exists) {
                NSNumber *totalIcoin=snapshot.value;
            if (AccountVIPInfo==nil) {
                AccountVIPInfo = [GetAccountInfoResponse new];
            }
                AccountVIPInfo.totalIcoin=totalIcoin;
              
        }
        
    }];
    [self setLogcatFir];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDownloadProgress:)
                                                 name:@"updateDownloadProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePositionLive:)
                                                 name:@"updatePositionLive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showWallet:)
                                                 name:@"showWallet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRank:)
                                                 name:@"showRank" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPerson:)
                                                 name:@"showPerson" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exitLiveRoom:)
                                                 name:@"exitLiveRoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLiveRoomInfo:)
                                                 name:@"showLiveRoomInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xepluot:)
                                                 name:@"xepluot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendLogFirebaseFile)
                                                 name:@"sendLogFirebaseFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendLogFirebaseDebug:)
                                                 name:@"sendLogFirebaseDebug" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendLogFirebaseInfo:)
                                                 name:@"sendLogFirebaseInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordFinish:)
                                                 name:@"recordFinish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mixingOfflineWithStatus:)
                                                 name:@"mixingOfflineWithStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordFinishNotPublic:)
                                                 name:@"recordFinishNotPublic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordCancel:)
                                                 name:@"recordCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordFailWithError:)
                                                 name:@"recordFailWithError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordStartProgress:)
                                                 name:@"recordStartProgress" object:nil];
}
- (void) removeNoti {
    return;
    NSString *url5=[NSString stringWithFormat: @"ikara/streams/bestNettyServerDomain"];
    [[self.ref child:url5] removeObserverWithHandle:_refHandleF8];
    [[self.ref child:url5] removeAllObservers];
    NSString * uId;
    if ([currentFbUser.uid longLongValue]>0) {
        uId = [NSString stringWithFormat:@"%@",currentFbUser.uid];
    }else {
        uId = [[LoadData2 alloc] idForDevice];
    }
    if (uId.length>0){
      
        [[self.ref child:[NSString stringWithFormat: @"ikara/logcat/%@/properties/sendLogcat",uId]] removeObserverWithHandle:_refHandleF];
        [[self.ref child:[NSString stringWithFormat: @"ikara/logcat/%@/properties/sendLogcat",uId]] removeAllObservers];
    }
    NSString *url8=[NSString stringWithFormat: @"ikara/users/%@/totalIcoin/",currentFbUser.facebookId];
    [[self.ref child:url8] removeAllObservers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePositionLive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDownloadProgress" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showRank" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showWallet" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showPerson" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showLiveRoomInfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exitLiveRoom" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xepluot" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendLogFirebaseFile" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendLogFirebaseDebug" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendLogFirebaseInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mixingOfflineWithStatus" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordFinishNotPublic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordFailWithError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordStartProgress" object:nil];
}
- (void) recordFinish:(NSNotification *)object{
    Recording * recordF = (Recording *) object.object;
    if ([self.delegate respondsToSelector:@selector(recordFinish:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate recordFinish:[recordF toJSONString] ];
            
        });
    }
    [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA12_record_post",@"description":@"Đăng bài thu "}];
    [self removeNoti];
}
- (void) recordStartProgress:(NSNotification *)object{
    Recording * recordF = (Recording *) object.object;
    if ([self.delegate respondsToSelector:@selector(recordStartProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.delegate recordStartProgress:[recordF toJSONString] ];
            
        });
    }
    //[self removeNoti];
    
}
- (void) recordFinishNotPublic:(NSNotification *)object{
    Recording * recordF = (Recording *) object.object;
    if ([self.delegate respondsToSelector:@selector(recordFinishNotPublic:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
       
                [self.delegate recordFinishNotPublic:[recordF toJSONString] ];
                
        });
    }
    //[self removeNoti];
   
}
- (void) recordCancel:(NSNotification *)object{
    if ([self.delegate respondsToSelector:@selector(recordCancel)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
           // [view dismissViewControllerAnimated:YES completion:^{
                [self.delegate recordCancel ];
                
            //}];
        });
    }
   
}
+ (NSBundle *) resourceBundle {
    NSBundle* bun = [NSBundle bundleForClass:self];
    NSURL * bunUrl = [bun URLForResource:@"YokaraSDK" withExtension:@"bundle"];
    NSBundle * resourceBundle = [NSBundle bundleWithURL:bunUrl];
    return resourceBundle;
}
- (void) updateUser:(NSString *) userString  {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    currentFbUser = [[User alloc] initWithString:userString error:nil];
    if ([currentFbUser isKindOfClass:[User class]]){
        [prefs setObject:currentFbUser.facebookId forKey:@"facebookId"];
        [prefs setBool:YES forKey:@"ConnectFacebook"];
        [prefs setObject:currentFbUser.uid forKey:@"uid"];
        [prefs setObject:currentFbUser.password  forKey:@"password"];
        [prefs setObject:currentFbUser.jid forKey:@"jid"];
        [prefs setObject:currentFbUser.firebaseToken forKey:@"firebaseToken"];
        [prefs synchronize];
        [[FIRCrashlytics crashlytics] setUserID:[NSString stringWithFormat:@"%@", currentFbUser.uid]];
        [[FIRCrashlytics crashlytics] setCustomValue:[NSString stringWithFormat:@"%ld",(long)[currentFbUser.uid integerValue]] forKey:@"user_uid"];
        [[FIRCrashlytics crashlytics] setCustomValue:[NSString stringWithFormat:@"%@",currentFbUser.name] forKey:@"user_name"];
        [[FIRCrashlytics crashlytics] setCustomValue:[NSString stringWithFormat:@"%@",currentFbUser.facebookId] forKey:@"user_facebookid"];
        [FIRAnalytics setUserID:[[LoadData2 alloc] idForDevice]];
        [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",(long)[currentFbUser.uid integerValue]] forName:@"user_uid"];
        [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%@",currentFbUser.name] forName:@"user_name"];
        [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%@",currentFbUser.facebookId] forName:@"user_facebookid"];
    }
}
NSNumber * localRecordId;
- (void) sendLocalDBId:(NSNumber *) localId{
    localRecordId = localId;
    NSLog(@"sendLocalRecordID %d",[localRecordId intValue]);
    
}
- (void) recordSolo:(NSString *) songString {
    [self firstLoad];
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    PrepareRecordViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.song = [[Song alloc]  initWithString:songString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    VipMember = NO;
    mainv.song = self.song;
    mainv.recording = self.recording;
    mainv.performanceType = @"SOLO";
    mainv.toneOfSong = self.toneOfSong;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
- (void) recordSoloVIP:(NSString *) songString {
    [self firstLoad];
  
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    PrepareRecordViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.song = [[Song alloc]  initWithString:songString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
   
    VipMember = YES;
    mainv.song = self.song;
    mainv.recording = self.recording;
    mainv.performanceType = @"SOLO";
    mainv.toneOfSong = self.toneOfSong;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
- (void) recordDuet:(NSString *) recordString {
    [self firstLoad];
  
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    PrepareRecordViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.recording = [[Recording alloc]  initWithString:recordString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    VipMember = NO;
    NSMutableArray<Lyric> *lyrics=[NSMutableArray<Lyric> new];
    self.recording.lyric.type=[NSNumber numberWithInt:XML];
    self.recording.lyric.privatedId=@1;
    if ([self.recording.lyric isKindOfClass:[Lyric class]]) {
        [lyrics addObject:self.recording.lyric];
        
        self.recording.song.lyrics=lyrics;
    }
    if (self.recording.mixedRecordingVideoUrl.length>4) {
        self.recording.song.songUrl=self.recording.mixedRecordingVideoUrl;
        // videoRecord=YES;
    }else{
        self.recording.song.songUrl=self.recording.onlineMp3Recording;
        //videoRecord=NO;
    }
    mainv.song = self.recording.song;
    mainv.recording = self.recording;
    mainv.performanceType = @"DUET";
    mainv.toneOfSong = self.toneOfSong;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
- (void) showEditRecordView:(NSString *) recordString{
    [self firstLoad];
  
    UIStoryboard *storyboard ;
    
    [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA15_record_edit",@"description":@"Chỉnh sửa âm bài thu"}];
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    StreamingMovieViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"Hát"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.recording = [[Recording alloc]  initWithString:recordString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    songPlay = self.recording.song;
    songRec=self.recording;
        songRec.localDBId = localRecordId;
    if (self.recording.mixedRecordingVideoUrl.length>4 || self.recording.onlineMp3Recording.length>4) {
        songRec->hasUpload = @"YES";
        if (self.recording.mixedRecordingVideoUrl.length>4) {
            self.recording.song.songUrl=self.recording.mixedRecordingVideoUrl;
            // videoRecord=YES;
        }else{
            self.recording.song.songUrl=self.recording.onlineMp3Recording;
            //videoRecord=NO;
        }
    }
   
    playRecord=YES;
    //songRec.delay=[NSNumber numberWithInt:0];
  
        if ([self.recording.vocalUrl hasSuffix:@"mov"]|| [self.recording.vocalUrl hasSuffix:@"mp4"] || [self.recording.onlineVocalUrl hasSuffix:@"mov"] || [self.recording.onlineVocalUrl hasSuffix:@"mp4"]){
            playVideoRecorded=YES;
        }else playVideoRecorded=NO;
    
    
    
    isrecord=NO;
    videoRecord=NO;
    playTopRec=NO;
    playRecUpload =NO;
    unload =YES;
  
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
}
- (void) showEditRecordViewVIP:(NSString *) recordString{
    [self firstLoad];
    
    UIStoryboard *storyboard ;
    
    VipMember = YES;
    [FIRAnalytics logEventWithName:@"screen_views" parameters:@{@"screen_name":@"TA15_record_edit",@"description":@"Chỉnh sửa âm bài thu"}];
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    StreamingMovieViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"Hát"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.recording = [[Recording alloc]  initWithString:recordString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    songPlay = self.recording.song;
    songRec=self.recording;
    songRec.localDBId = localRecordId;
    if (self.recording.mixedRecordingVideoUrl.length>4 || self.recording.onlineMp3Recording.length>4) {
        songRec->hasUpload = @"YES";
        if (self.recording.mixedRecordingVideoUrl.length>4) {
            self.recording.song.songUrl=self.recording.mixedRecordingVideoUrl;
            // videoRecord=YES;
        }else{
            self.recording.song.songUrl=self.recording.onlineMp3Recording;
            //videoRecord=NO;
        }
    }
    
    playRecord=YES;
    //songRec.delay=[NSNumber numberWithInt:0];
    
    if ([self.recording.vocalUrl hasSuffix:@"mov"]|| [self.recording.vocalUrl hasSuffix:@"mp4"] || [self.recording.onlineVocalUrl hasSuffix:@"mov"] || [self.recording.onlineVocalUrl hasSuffix:@"mp4"]){
        playVideoRecorded=YES;
    }else playVideoRecorded=NO;
    
    
    
    isrecord=NO;
    videoRecord=NO;
    playTopRec=NO;
    playRecUpload =NO;
    unload =YES;
    
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
}
- (void) recordDuetVIP:(NSString *) recordString {
    [self firstLoad];
 
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    PrepareRecordViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.recording = [[Recording alloc]  initWithString:recordString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    NSMutableArray<Lyric> *lyrics=[NSMutableArray<Lyric> new];
    self.recording.lyric.type=[NSNumber numberWithInt:XML];
    self.recording.lyric.privatedId=@1;
    if ([self.recording.lyric isKindOfClass:[Lyric class]]) {
        [lyrics addObject:self.recording.lyric];
        
        self.recording.song.lyrics=lyrics;
    }
    if (self.recording.mixedRecordingVideoUrl.length>4) {
        self.recording.song.songUrl=self.recording.mixedRecordingVideoUrl;
        // videoRecord=YES;
    }else{
        self.recording.song.songUrl=self.recording.onlineMp3Recording;
        //videoRecord=NO;
    }
    VipMember = YES;
    mainv.song = self.recording.song;
    mainv.recording = self.recording;
    mainv.performanceType = @"DUET";
    mainv.toneOfSong = self.toneOfSong;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
- (void) recordAsk4Duet:(NSString *) songString {
    [self firstLoad];
   
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    DuetLyricKaraViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChonLoiSongCaView"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.song = [[Song alloc]  initWithString:songString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
  
    VipMember = NO;
    mainv.song = self.song;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
- (void) firstLoad {
    if (namColor==nil) namColor=UIColorFromRGB(0x25A0FE);
    if (nuColor==nil) nuColor=[UIColor colorWithRed:227/255.0 green:112/255.0 blue:237/255.0 alpha:1];
    if (songCaColor==nil) songCaColor=[UIColor greenColor];
    [self setupNoti];
    
}
- (void) recordAsk4DuetVIP:(NSString *) songString {
    [self firstLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
   
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    DuetLyricKaraViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChonLoiSongCaView"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.song = [[Song alloc]  initWithString:songString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    VipMember = YES;
    mainv.song = self.song;
    mainv.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    NavigationTopViewController *nav = [[NavigationTopViewController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
    // }
    
}
#pragma mark - Live
- (void) openLiveRoom:(NSString *)liveJson {
    NSError *error;
    self.liveroom = [[LiveRoom alloc] initWithString:liveJson error:&error];
    self.liveroom.roomId =  [NSString stringWithFormat:@"%ld",self.liveroom._id];
    [self firstLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
  
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    self.liveView = [storyboard instantiateViewControllerWithIdentifier:@"LiveView"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
   
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    VipMember = NO;
    self.liveView.liveroom = self.liveroom;
    self.liveView.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    //self.delegate.liveViewC = self.liveView;
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    navLive = [[NavigationTopViewController alloc]initWithRootViewController:self.liveView];
    navLive.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
   [view presentViewController:navLive animated:YES completion:nil];
}
- (UIViewController *)getLiveView{
    return self.liveView;
}
- (void) openLiveRoomVIP:(NSString *)liveJson {
    NSError *error;
    self.liveroom = [[LiveRoom alloc] initWithString:liveJson error:&error];
    self.liveroom.roomId =  [NSString stringWithFormat:@"%ld",self.liveroom._id];
    [self firstLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    UIStoryboard *storyboard ;
    
    
    
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:[YokaraSDK resourceBundle]];
    self.liveView = [storyboard instantiateViewControllerWithIdentifier:@"LiveView"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
    VipMember = YES;
    self.liveView.liveroom = self.liveroom;
    self.liveView.modalPresentationStyle = UIModalPresentationFullScreen;
    //self.providesPresentationContextTransitionStyle = YES;
    //self.definesPresentationContext = YES;
    UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    view.providesPresentationContextTransitionStyle = YES;
    view.definesPresentationContext = YES;
    
    //if ([view isKindOfClass:[UINavigationController class]]) {
    // [view.navigationController pushViewController:mainv animated:YES];
    // }else {
    navLive = [[NavigationTopViewController alloc]initWithRootViewController:self.liveView];
    navLive.modalPresentationStyle = UIModalPresentationFullScreen;
    // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:navLive animated:YES completion:nil];
}
- (void) exitLiveRoom:(NSNotification *) object{
    if ([self.delegate respondsToSelector:@selector(kara_exit:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate kara_exit:[self.liveroom toJSONString]];
            
        });
    }
    NSLog(@"exitLiveRoom %@",object.object);
    [self removeNoti];
}
- (void) xepluot:(NSNotification *) object{
    OpenLiveRoomModel * oLv = (OpenLiveRoomModel *)object.object;
    if ([self.delegate respondsToSelector:@selector(kara_waiting_song:withView:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate kara_waiting_song:[oLv toJSONString] withView:navLive];
            
        });
    }
}
- (void) showLiveRoomInfo:(NSNotification *) object{
    OpenLiveRoomModel * oLv = (OpenLiveRoomModel *)object.object;
    if ([self.delegate respondsToSelector:@selector(kara_room_info:withView:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            [self.delegate kara_room_info:[oLv toJSONString] withView:navLive];
            
        });
    }
}

- (void) updatePositionLive:(NSNotification *) object{
    NSString * pos = (NSString *)object.object;
    if ([self.delegate respondsToSelector:@selector(updatePlayerPositionLive:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.delegate updatePlayerPositionLive:pos];
            
        });
    }
}

- (void) showRank:(NSNotification *) object{
    User * userS = (User *)object.object;
    OpenLiveRoomModel * oLv = [OpenLiveRoomModel new];
    oLv.user = [userS toJSONString];
    if ([self.delegate respondsToSelector:@selector(showRank:withView:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.delegate showRank:[userS toJSONString] withView:navLive];
            
        });
    }
}

- (void) showWallet:(NSNotification *) object{
    User * userS = (User *)object.object;
    OpenLiveRoomModel * oLv = [OpenLiveRoomModel new];
    oLv.user = [userS toJSONString];
    if ([self.delegate respondsToSelector:@selector(showWallet:withView:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.delegate showWallet:[userS toJSONString]  withView:navLive];
            
        });
    }
}
- (void) showPerson:(NSNotification *) object{
    User * userS = (User *)object.object;
    OpenLiveRoomModel * oLv = [OpenLiveRoomModel new];
    oLv.user = [userS toJSONString];
    oLv.mainUser = [currentFbUser toJSONString];
    if ([self.delegate respondsToSelector:@selector(showPerson:withView:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.delegate showPerson:[oLv toJSONString] withView:navLive];
            
        });
    }
}

- (void) updateDownloadProgress:(NSNotification * )object {
    NSString * process = (NSString *)object.object;
    NSLog(@"updateDownloadProgress %@",process);
    if ([self.delegate respondsToSelector:@selector(downloadWithStatus:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.delegate downloadWithStatus:process];
            
        });
    }
}
- (void) downloadRecord:(NSString *) recordString {
    Recording * recordD = [[Recording alloc] initWithString:recordString error:nil];
    [NSThread detachNewThreadWithBlock:^{
        if ([[LoadData2 alloc] downloadRecord:recordD]) {
            NSLog(@"downloadSong complete %@",recordD.recordingId);
        }else {
            if ([self.delegate respondsToSelector:@selector(downloadWithStatus:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self.delegate downloadWithStatus:[NSString stringWithFormat:@"%@:-2",recordD.recordingId]];
                    
                });
            }
        }
    }];
}
- (void) downloadSong:(NSString *) songString{
    Song * songD = [[Song alloc] initWithString:songString error:nil];
    [NSThread detachNewThreadWithBlock:^{
        if ([[LoadData2 alloc] downloadSong:songD]) {
            NSLog(@"downloadSong complete %@",songD.videoId);
        }else {
            if ([self.delegate respondsToSelector:@selector(downloadWithStatus:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self.delegate downloadWithStatus:[NSString stringWithFormat:@"%@:-2",songD.videoId]];
                    
                });
            }
        }
    }];
    
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


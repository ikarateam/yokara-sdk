//
//  DuetLyricKaraViewController.m
//  Yokara
//
//  Created by APPLE on 9/7/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "DuetLyricKaraViewController.h"
#import "PrepareRecordViewController.h"
#import "LyricOneLine.h"
#import "LyricOneWord.h"
#import "LyricLine.h"
#import "LoadData2.h"
@interface DuetLyricKaraViewController ()


@end

@implementation DuetLyricKaraViewController
@synthesize movieTimeControl;
- (IBAction)StartDuet:(id)sender {
     self.lyric=[ _lyricView getLyric];
    if (self.lyric.content.length>0) {
        lyricJson=self.lyric.content;
        PrepareRecordViewController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
        //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
        // [[MainViewController alloc] initWithPlayer:theSong.ids];
        
        mainv.lyricForDuet=self.lyric;
        // [self.song.lyrics insertObject:self.lyric atIndex:0];
        mainv.song=self.song;
        mainv.performanceType=@"ASK4DUET";
        
        [self.navigationController pushViewController:mainv animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:self.lyric.content forKey:self.lyric.key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)markMeSing:(id)sender {

    [self.lyricView updateLyricMeSing:youtubePlayer.currentTime];

    [self.lyricView setNeedsDisplay];
}
- (IBAction)markDuet:(id)sender {
    [self.lyricView updateLyricDuetSing:youtubePlayer.currentTime];

    [self.lyricView setNeedsDisplay];
}
- (IBAction)markOtherSing:(id)sender {
    [self.lyricView updateLyricOtherSing:youtubePlayer.currentTime];

    [self.lyricView setNeedsDisplay];
}
/*
- (IBAction)markMeSing:(id)sender {
  
    [self.lyricView updateLyricMeSing:CMTimeGetSeconds([duetVideoPlayer currentTime])];
   
    [self.lyricView setNeedsDisplay];
}
- (IBAction)markDuet:(id)sender {
    [self.lyricView updateLyricDuetSing:CMTimeGetSeconds([duetVideoPlayer currentTime])];
    
    [self.lyricView setNeedsDisplay];
}
- (IBAction)markOtherSing:(id)sender {
    [self.lyricView updateLyricOtherSing:CMTimeGetSeconds([duetVideoPlayer currentTime])];
    
    [self.lyricView setNeedsDisplay];
}*/
- (IBAction)pause:(id)sender {
     if (youtubePlayer.playerState==kYTPlayerStatePlaying){
     [youtubePlayer pauseVideo];
     }
}
- (IBAction)play:(id)sender {
    if (youtubePlayer.playerState!=kYTPlayerStatePlaying && youtubePlayer) {
         [youtubePlayer playVideo];
    }

}
/*
- (IBAction)pause:(id)sender {
     if (duetVideoPlayer.rate!=0.0){
     [duetVideoPlayer pause];
     }
}
- (IBAction)play:(id)sender {
    if (duetVideoPlayer && duetVideoPlayer.rate!=1.0  ) {
        [duetVideoPlayer play];
    }
    
}*/
- (void) loadMp4{
    @autoreleasepool {


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
        if ([self.song.mp4link isKindOfClass:[NSString class]]){
            [NSThread detachNewThreadSelector:@selector(loadDuetVideo:) toTarget:self withObject:self.song.mp4link];
        }

    }
}
- (void)loadDuetVideo:(NSString *)urlL
{
    @autoreleasepool {

        NSLog(@"loadDuetVideo %@",urlL);
        /* Has the user entered a movie URL? */
        if (urlL.length > 0)
            {
            NSURL *newMovieURL = [NSURL URLWithString:urlL];
            if ([newMovieURL scheme])    /* Sanity check on the URL. */
                {
                /*
                 Create an asset for inspection of a resource referenced by a given URL.
                 Load the values for the asset keys "tracks", "playable".
                 */
                AVURLAsset* asset2 = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];

                NSArray *requestedKeys = [NSArray arrayWithObjects:@"tracks", @"playable", nil];

                /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
                [asset2 loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                 ^{
                     dispatch_async( dispatch_get_main_queue(),
                                    ^{
                                        /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */

                                            [self prepareToPlayAsset3:asset2 withKeys:requestedKeys];
                                        [duetVideoPlayer play];



                                            //if  ([self isPlaying] ) [audioPlayer play];


                                    });
                 }];
                }
            }
    }
}
static void *DuetLyricViewControllerRateObservationContext = &DuetLyricViewControllerRateObservationContext;
static void *DuetLyricViewControllerPlayerItemStatusObserverContext = &DuetLyricViewControllerPlayerItemStatusObserverContext;
- (void)viewDidDisappear:(BOOL)animated{
	 if (youtubePlayer) {
		 [youtubePlayer pauseVideo];
		 [youtubePlayer removeFromSuperview];
		 youtubePlayer.delegate=nil;
		 youtubePlayer=nil;
	 }/*
    if (duetVideoPlayer ){
        [duetVideoPlayer pause];
        [self.duetVideoLayer removeFromSuperview];
        [self.duetVideoLayer.playerLayer setPlayer:nil];
        self.duetVideoLayer=nil;
        if (playerItem3 )
            {
            @try {
                [duetVideoPlayer removeObserver:self forKeyPath:@"rate" context:DuetLyricViewControllerRateObservationContext];
                [playerItem3 removeObserver:self forKeyPath:@"status"];

                [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem3];
            }@catch (NSException *exception) {

            }
            }
    }*/
    [super viewDidDisappear:YES];
}
- (void) updateSlider:(UISlider *)slider withSize:(CGFloat) thumbSize andColor:(UIColor *)color{
    UIImage* thumbImage =[self  createThumbImage:thumbSize andColor: color];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
}

- (UIImage *) createThumbImage:(CGFloat )size andColor:(UIColor *)color {
    CGRect layerFrame = CGRectMake(0, 0, size, size);
    
    CAShapeLayer* shapeLayer =[[CAShapeLayer alloc] init];
    shapeLayer.path = CGPathCreateWithEllipseInRect(CGRectInset(layerFrame, 1, 1), nil);
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.strokeColor =[ [color colorWithAlphaComponent:0.65] CGColor];
    
    CALayer* layer = [[CALayer alloc] init];
    layer.frame = layerFrame;
    [layer addSublayer:shapeLayer];
    return [self imageFromLayer:layer];
}

-(UIImage *) imageFromLayer:(CALayer *)layer{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     // [[NSNotificationCenter defaultCenter] postNotificationName:@"stopAudioEngine" object:nil];
   
    [self.markDuetButton setTitle:AMLocalizedString(@"Song Ca", nil) forState:UIControlStateNormal];
    [self.markMeSingButton setTitle:AMLocalizedString(@"Tôi hát", nil) forState:UIControlStateNormal];
    [self.markCancelButton setTitle:AMLocalizedString(@"Bạn hát", nil) forState:UIControlStateNormal];
    [self.startButton setTitle:AMLocalizedString(@"Bắt Đầu", nil) forState:UIControlStateNormal];
    [self.chonLaiButton setTitle:AMLocalizedString(@"Mặc định", nil) forState:UIControlStateNormal];
    self.title = self.song.songName;
    self.markMeSingButton.layer.cornerRadius=5;
    self.markMeSingButton.layer.masksToBounds=YES;
    self.markDuetButton.layer.cornerRadius=5;
    self.markDuetButton.layer.masksToBounds=YES;
    self.markCancelButton.layer.cornerRadius=5;
    self.markCancelButton.layer.masksToBounds=YES;
    self.startButton.layer.cornerRadius=self.startButton.frame.size.height/2;
    self.startButton.layer.masksToBounds=YES;
    [movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
    [movieTimeControl setMaximumTrackTintColor:[UIColor clearColor]];
    [movieTimeControl setMinimumTrackTintColor:[UIColor clearColor]];
    
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
    // Do any additional setup after loading the view.
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                  @"rel":@0,
                                 @"modestbranding" : @1
                                 
                                 };

      youtubePlayer=[[YTPlayerView alloc] initWithFrame:CGRectMake(0, self.markView.frame.size.height  , self.view.frame.size.width, self.toolbarPlayerView.frame.origin.y-self.markView.frame.size.height)];
    youtubePlayer.backgroundColor=[UIColor clearColor];
    youtubePlayer.webView.backgroundColor=[UIColor blackColor];
    youtubePlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    youtubePlayer.hidden=YES;
    [self.view insertSubview:youtubePlayer atIndex:0];
   /* if ([self.song.mp4link isKindOfClass:[NSString class]]){
        [NSThread detachNewThreadSelector:@selector(loadDuetVideo:) toTarget:self withObject:self.song.mp4link];
    }else
    [NSThread detachNewThreadSelector:@selector(loadMp4) toTarget:self withObject:nil];*/
    self.view.backgroundColor=[UIColor blackColor];
    //self.startButton.enabled=NO;
	 self.duetVideoLayer.hidden = YES;
    youtubePlayer.delegate=self;
     [youtubePlayer loadWithVideoId:self.song.videoId playerVars:playerVars];
    UITapGestureRecognizer*  seekTime=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [movieTimeControl addGestureRecognizer:seekTime];
    [movieTimeControl addTarget:self action:@selector(slideChangeValue:) forControlEvents:UIControlEventValueChanged];
    NSString* gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    if (gender.length==0) {
       genderUser=@"m";
        self.markMeSingButton.backgroundColor=namColor;
        genderColor=namColor;
    }else if ([gender isEqualToString:@"male"]){
        self.markMeSingButton.backgroundColor=namColor;
        genderUser=@"m";
        genderColor=namColor;
    }else{
        genderUser=@"f";
        self.markMeSingButton.backgroundColor=nuColor;
        genderColor=nuColor;
    }
	 self.startButton.hidden = YES;
    meSingThumbImage=[self createThumbImage:12 andColor:genderColor];
    otherSingThumbImage=[self createThumbImage:12 andColor:[UIColor whiteColor]];
    duetSingThumbImage=[self createThumbImage:12 andColor:songCaColor];
    self.markCancelButton.backgroundColor=[UIColor whiteColor];
    self.duetLyricView.backgroundColor=[UIColor clearColor];
    self.movieTimeControl.center=self.duetLyricView.center;
     self.markDuetButton.backgroundColor=songCaColor;
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    //float progress = playTime/playerView.duration;
    //[self.movieTimeControl setValue:progress];
    double duration = playerView.duration;
    
    
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [movieTimeControl minimumValue];
        float maxValue = [movieTimeControl maximumValue];
        //double time = CMTimeGetSeconds([playerMain currentTime]);
        //delayRec=0.28;
        [movieTimeControl setValue:(maxValue - minValue) * playTime / duration + minValue];
        
        
        
        self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:playTime]];
        _durationLabel.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:duration]];
        UIColor *color=[UIColor whiteColor];
        int i;
        for ( i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
            ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
            if (ct.time<=playTime) {
                color=ct.color;
                
                break;
            }
        }
        if (i<self.lyricView.listColor.count-1) {
            ColorAndTime *ctnext=[self.lyricView.listColor objectAtIndex:i+1];
            if (ctnext.time<=playTime+1) {
                [self.lyricView removeLine:i+1];
                [self.lyricView setNeedsDisplay];
            }
        }
        if ([color isEqual:genderColor]) {
            [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
        }else if ([color isEqual:[UIColor whiteColor]]) {
            [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
        }else{
            [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
        }
       
    }
    
}
- (IBAction)loadLaiLyric:(id)sender {
    //[duetVideoPlayer pause];
	 [youtubePlayer pauseVideo];
    [self.lyricView resetLyric];
    
    [self.lyricView setNeedsDisplay];
}
- (void) loadLyric {
    @autoreleasepool {
        
        
        dispatch_queue_t queue = dispatch_queue_create("com.vnnapp.iKara", NULL);
        dispatch_async(queue, ^{
            if ([[LoadData2 alloc] checkNetwork]) {
                
                _lyric=[[Lyric alloc] init];
                _lyric.key=[NSString stringWithFormat:@"%@-%@",[[LoadData2 alloc] idForDevice],self.song.videoId];
                _lyric.owner=currentFbUser;
                _lyric.type=[NSNumber numberWithInteger:XML];
                if ([_lyric.key isKindOfClass:[NSString class]]) {
                    lyricJson=[[NSUserDefaults standardUserDefaults] objectForKey:_lyric.key];
                    if (lyricJson.length>4) {
                        _lyric.content=lyricJson;
                    }else{
                        LyricOneLine*lyr=[[LyricOneLine alloc] init];
                        LyricOneWord *word=[[LyricOneWord alloc] init];
                        word.startTime=[NSNumber numberWithDouble: 0];
                       
                        lyr.sex=genderUser;
                        word.text=@"";
                        
                        lyr.words=[[NSMutableArray<LyricOneWord> alloc] initWithObjects:word, nil];
                        LyricLine * lyricLine=[LyricLine new];
                        lyricLine.lines=[NSMutableArray<LyricOneLine> new];
                        [lyricLine.lines addObject:lyr];
                        _lyric.content=[lyricLine toJSONString];
                       
                    }
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSString *urlyric=_lyric.url;
                //NSLog(@"%@",urlyric);
              //  CMTime playerDuration = [self playerItemDuration];

              //  double duration = CMTimeGetSeconds(playerDuration);

               // self.lyricView=[[DuetLyricView alloc] initWithLyric:self.lyric andDuration:duration];
              self.lyricView=[[DuetLyricView alloc] initWithLyric:self.lyric andDuration:youtubePlayer.duration];

                self.lyricView.frame=CGRectMake(0, 0, self.duetLyricView.frame.size.width, self.duetLyricView.frame.size.height);
                [self.duetLyricView addSubview:self.lyricView];
               //  [self.movieTimeControl setThumbTintColor:self.lyricView.genderColor];
                
                    [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
               
            });
        });
        
        
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
- (IBAction)slideChangeValue:(id)sender{
    UISlider* slider = (UISlider*)sender;
    //if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    
  /*  CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
        {
        return;
        }
    
    double duration = CMTimeGetSeconds(playerDuration);*/
	 if (youtubePlayer.duration==0) {
			return;
		}

		double duration =youtubePlayer.duration;
    if (isfinite(duration) && (duration > 0))
        {
        float minValue = [slider minimumValue];
        float maxValue = [slider maximumValue];
        float value = [slider value];
        
        //double time = duration * (value - minValue) / (maxValue - minValue);
        //[duetVideoPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
		 double time = duration * (value - minValue) / (maxValue - minValue);
				[youtubePlayer seekToSeconds:time allowSeekAhead:YES];
        UIColor *color=[UIColor whiteColor];
        for (int i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
            ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
            if (ct.time<=time) {
                color=ct.color;
                break;
            }
        }
        if ([color isEqual:genderColor]) {
            [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
        }else if ([color isEqual:[UIColor whiteColor]]) {
            [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
        }else{
            [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
        }
    }
}
- (void)sliderTapped:(UIGestureRecognizer *)g
{
    /////////////// For TapCount////////////
    
    //tapCount = tapCount + 1;
    //NSLog(@"Tap Count -- %d",tapCount);
    
    /////////////// For TapCount////////////
    
    UISlider* s = (UISlider*)g.view;
    //if (s.highlighted)
    //     return; // tap on thumb, let slider deal with it
    CGPoint point = [g locationInView: s];
    CGFloat percentage = point.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat valueS = s.minimumValue + delta;
    [s setValue:valueS animated:YES];
    float minValue = [s minimumValue];
    float maxValue = [s maximumValue];
    float value = [s value];
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
        {
        return;
        }
    
    //double duration = CMTimeGetSeconds(playerDuration);
    //double timeSeek = duration * (value - minValue) / (maxValue - minValue);
     //[duetVideoPlayer seekToTime:CMTimeMakeWithSeconds(timeSeek, NSEC_PER_SEC)];
    double timeSeek = youtubePlayer.duration * (value - minValue) / (maxValue - minValue);
    [youtubePlayer seekToSeconds:timeSeek allowSeekAhead:YES];
    UIColor *color=[UIColor whiteColor];
    for (int i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
        ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
        if (ct.time<=timeSeek) {
            color=ct.color;
            break;
        }
    }
    if ([color isEqual:genderColor]) {
        [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
    }else if ([color isEqual:[UIColor whiteColor]]) {
        [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
    }else{
        [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
    }
    
    //NSString *str=[NSString stringWithFormat:@"%.f",[movieTimeControl value]];
    // self.lbl.text=str;
}
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    //self.startButton.enabled=YES;

	 dispatch_async( dispatch_get_main_queue(),
					 ^{
    youtubePlayer.hidden=NO;
	 self.startButton.hidden =NO;
					 self.isLoadingVideo.hidden = YES;
	//	  [youtubePlayer setMute:NO];
    // [self performSelector:@selector(playYoutube) withObject:nil afterDelay:2];
    [youtubePlayer playVideo];
	 });
	  [NSThread detachNewThreadSelector:@selector(loadLyric) toTarget:self withObject:nil];
}
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    [self syncPlayPauseButtons];
    switch (state) {
        case kYTPlayerStatePlaying:
            
            break;
        case kYTPlayerStatePaused:
            
            break;
        case kYTPlayerStateEnded:
          
            
            
           
            [self.movieTimeControl performSelectorOnMainThread:@selector(setValue:) withObject:0 waitUntilDone:NO];
            
            break;
        default:
            break;
    }
}
-(void)showStopButton
{
    self.playButt.hidden=YES;
    self.pauseBtt.hidden=NO;
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
    
    self.playButt.hidden=NO;
    self.pauseBtt.hidden=YES;
}
- (void)syncPlayPauseButtons
{
   if (youtubePlayer.playerState==kYTPlayerStatePlaying)// if (duetVideoPlayer.rate==1.0)
    {
        NSLog(@"is play");
        [self performSelectorOnMainThread:@selector(showStopButton) withObject:nil waitUntilDone:NO];
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showPlayButton) withObject:nil waitUntilDone:NO];
       
    }
}
- (CMTime)playerItemDuration
{

    AVPlayerItem *thePlayerItem ;

    thePlayerItem= [duetVideoPlayer currentItem];

    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
        {

        CMTime itemDuration = [thePlayerItem duration];
        if (CMTimeGetSeconds( itemDuration)>1000) {
            itemDuration=CMTimeMakeWithSeconds(500, NSEC_PER_SEC);
        }
        return(itemDuration);
        }

    return(kCMTimeInvalid);

}
#pragma mark Scrubber control

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
                       CMTime playerDuration = [self playerItemDuration];
                       if (CMTIME_IS_INVALID(playerDuration))
                           {
                           movieTimeControl.minimumValue = 0.0;
                           [self.progressBuffer setProgress:0.0];
                           return;
                           }

                       double duration = CMTimeGetSeconds(playerDuration);
                       if (isfinite(duration) && (duration > 0))
                           {
                           float minValue = [movieTimeControl minimumValue];
                           float maxValue = [movieTimeControl maximumValue];
                           double playTime = CMTimeGetSeconds([duetVideoPlayer currentTime]);
                               //delayRec=0.28;
                           [movieTimeControl setValue:(maxValue - minValue) * playTime / duration + minValue];
                               // NSLog(@"%f",[self  availableDuration]);

                               /// [self checkHeadset];

                           self.timeplay.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:playTime]];
                           _durationLabel.text=[NSString stringWithFormat:@"%@",[self convertTimeToString2:duration]];
                           UIColor *color=[UIColor whiteColor];
                           int i;
                           for ( i=(int)(self.lyricView.listColor.count-1);i>=0;i--) {
                               ColorAndTime * ct=[self.lyricView.listColor objectAtIndex:i];
                               if (ct.time<=playTime) {
                                   color=ct.color;

                                   break;
                               }
                           }
                           if (i<self.lyricView.listColor.count-1) {
                               ColorAndTime *ctnext=[self.lyricView.listColor objectAtIndex:i+1];
                               if (ctnext.time<=playTime+1) {
                                   [self.lyricView removeLine:i+1];
                                   [self.lyricView setNeedsDisplay];
                               }
                           }
                           if ([color isEqual:genderColor]) {
                               [self.movieTimeControl setThumbImage:meSingThumbImage forState:UIControlStateNormal];
                           }else if ([color isEqual:[UIColor whiteColor]]) {
                               [self.movieTimeControl setThumbImage:otherSingThumbImage forState:UIControlStateNormal];
                           }else{
                               [self.movieTimeControl setThumbImage:duetSingThumbImage forState:UIControlStateNormal];
                           }

                           }
                   });
}
-(void)initScrubberTimer
{


    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
        {
        return;
        }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
        {
        CGFloat width = CGRectGetWidth([movieTimeControl bounds]);
            //interval = 0.2f ;//* duration / width;
        }
        //if (interval > 0.1) interval=0.1;
        ///if (interval < 0.05) interval=0.05;
    /* Update the scrubber during normal playback. */
    if (!timeObserver ) {
        timeObserver = [duetVideoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(intervalRender, NSEC_PER_SEC)
                                                                  queue:NULL
                                                             usingBlock:
                         ^(CMTime time)
                         {
                         [self syncScrubber];
                         }];
    }



}
-(void)assetFailedToPrepareForPlayback:(NSError *)error
{



        //if (playerMain && ![Language hasSuffix:@"kara"]) playerMain=nil;

    /* Display the error. */
    NSLog(@"%@",error.description);
}
- (void)prepareToPlayAsset3:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
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

    /* At this point we're ready to set up for playback of the asset. */
    [self initScrubberTimer];
        //[self enableScrubber];
        //[self enablePlayerButtons];
    /*  if (playerItem3)
     {

     [playerItem3 removeObserver:self forKeyPath:@"status"];

     [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem3];
     }
     */
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    playerItem3 = [AVPlayerItem playerItemWithAsset:asset];

    /* Observe the player item "status" key to determine when it is ready to play. */
    [playerItem3 addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:DuetLyricViewControllerPlayerItemStatusObserverContext];

    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd3:)   name:AVPlayerItemDidPlayToEndTimeNotification  object:playerItem3];

        ///seekToZeroBeforePlay = NO;

    /* Create new player, if we don't already have one. */
    if ( duetVideoPlayer==nil)
        {
        /* Get a new AVPlayer initialized to play the specified player item. */
        duetVideoPlayer=[AVPlayer playerWithPlayerItem:playerItem3];

        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
            //[duetVideoPlayer addObserver:self  forKeyPath:kCurrentItemKey   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew  context:MyStreamingMovieViewControllerCurrentItemObservationContext];

        /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
            // [duetVideoPlayer addObserver:self  forKeyPath:kTimedMetadataKey    options:0 context:MyStreamingMovieViewControllerTimedMetadataObserverContext];

        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [duetVideoPlayer addObserver:self    forKeyPath:@"rate"   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew   context:DuetLyricViewControllerRateObservationContext];
        }

    /* Make our new AVPlayerItem the AVPlayer's current item. */
    AVPlayerItem *item=duetVideoPlayer.currentItem;
    if (item != playerItem3)
        {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [duetVideoPlayer replaceCurrentItemWithPlayerItem:playerItem3];
        item=nil;
            //[self syncPlayPauseButtons];
        }


}
- (void) playerItemDidReachEnd3:(NSNotification*) aNotification
{


        //tangLuotNghe=YES;
}
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
     if (context == DuetLyricViewControllerPlayerItemStatusObserverContext)
        {
            NSLog(@"change status duet");
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
                case AVPlayerStatusUnknown:
                {

                }
                break;

                case AVPlayerStatusReadyToPlay:
                {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
 [NSThread detachNewThreadSelector:@selector(loadLyric) toTarget:self withObject:nil];
                    NSLog(@"duet ready play");
				 dispatch_async( dispatch_get_main_queue(),
				 ^{
				 self.startButton.hidden =NO;
				 self.isLoadingVideo.hidden = YES;
                [self initScrubberTimer];
                        //  [self initScrubberTimer2];
                        //if (playVideoRecorded && playRecord){

                        // playerLayerViewRec.playerLayer.hidden = NO;


                        [self.duetVideoLayer.playerLayer setPlayer:duetVideoPlayer];

                        self.duetVideoLayer.playerLayer.hidden = NO;
                        self.duetVideoLayer.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
				 });


                        //[playerLayerViewRec.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                        //  }

                }
                break;

                case AVPlayerStatusFailed:
                {
                    AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                    [self performSelectorOnMainThread:@selector(assetFailedToPrepareForPlayback:) withObject:thePlayerItem.error waitUntilDone:NO];

                }
                break;
            }

        }else if (context == DuetLyricViewControllerRateObservationContext)
            {
            [self syncPlayPauseButtons];
            }else
                {
                [super observeValueForKeyPath:path ofObject:object change:change context:context];
                }
}
@end

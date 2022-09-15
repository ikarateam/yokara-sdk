//
//  DuetLyricKaraViewController.h
//  Yokara
//
//  Created by APPLE on 9/7/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>

#import "Lyric.h"
#import "YTPlayerView.h"
#import "DuetLyricView.h"
#import "GetSongResponse.h"
#import "Song.h"
#import "GetLyricResponse.h"
#import "MyPlayerLayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface DuetLyricKaraViewController : UIViewController<YTPlayerViewDelegate>{
    YTPlayerView *youtubePlayer;
    AVPlayerItem *playerItem3;
      NSString *lyricJson;
     LyricLine * lyricContent;
    NSString *genderUser;
    UIImage *meSingThumbImage;
    UIImage *otherSingThumbImage;
    UIImage *duetSingThumbImage;
    UIColor *genderColor;
    AVPlayer * duetVideoPlayer;
    id timeObserver;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isLoadingVideo;
@property (strong,nonatomic) DuetLyricView *lyricView;
@property (weak, nonatomic) IBOutlet MyPlayerLayerView *duetVideoLayer;
@property (weak, nonatomic) IBOutlet UIButton *chonLaiButton;
@property (strong,nonatomic)Song *song;
@property (strong,nonatomic) Lyric * lyric;
@property  (weak, nonatomic)  IBOutlet UIButton *markCancelButton;
@property  (weak, nonatomic)  IBOutlet UIButton *markDuetButton;
@property  (weak, nonatomic)  IBOutlet UIView *duetLyricView;
@property  (weak, nonatomic)  IBOutlet UIButton *markMeSingButton;
@property  (weak, nonatomic)  IBOutlet UIButton *startButton;
@property  (weak, nonatomic)  IBOutlet UIView *markView;
@property  (weak, nonatomic)  IBOutlet UIView *toolbarPlayerView;
@property  (weak, nonatomic)  IBOutlet UIImageView *bgLayer;
@property  (weak, nonatomic)  IBOutlet UILabel *durationLabel;
@property  (weak, nonatomic)  IBOutlet UILabel *timeplay;
@property  (weak, nonatomic)  IBOutlet UIProgressView *progressBuffer;
@property  (weak, nonatomic)  IBOutlet UIButton *playButt;
@property  (weak, nonatomic)  IBOutlet UIButton *pauseBtt;
@property  (weak, nonatomic)  IBOutlet UISlider *movieTimeControl;


@end

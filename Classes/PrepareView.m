//
//  PrepareViewController.m
//  YokaraKaraoke
//
//  Created by Admin on 03/06/2022.
//  Copyright © 2022 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "PrepareView.h"
#import "PrepareRecordViewController.h"
#import "Song.h"
#import "Recording.h"
@interface PrepareView ()

@property (strong ,nonatomic) Song *song;
@property (strong ,nonatomic) Recording *recording;
@end

@implementation PrepareView
- (void) dealloc {
   
}
- (void) recordFinish:(NSNotification *)object{
    Recording * recordF = (Recording *) object.object;
    if ([self.delegate respondsToSelector:@selector(recordFinish:)]) {
        UIViewController *view = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [view dismissViewControllerAnimated:YES completion:^{
            [self.delegate recordFinish:[recordF toJSONString] ];
            
        }];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recordFinish" object:nil];
}
- (void) recordSolo:(NSString *) songString {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordFinish:)
                                                 name:@"recordFinish" object:nil];
    UIStoryboard *storyboard ;
    NSBundle* bun = [YokaraSDK resourceBundle];
    storyboard = [UIStoryboard storyboardWithName:@"PrepareRecord" bundle:bun];
    PrepareRecordViewController *mainv = [storyboard instantiateViewControllerWithIdentifier:@"ChuanbiThuam"];
    //   UINavigationController *mainv = [self.storyboard instantiateViewControllerWithIdentifier:@"TrìnhChơiNhạc"];
    // [[MainViewController alloc] initWithPlayer:theSong.ids];
    NSError *error;
    self.song = [[Song alloc]  initWithString:songString error:&error];
    if (error){
        
        NSLog(@"Parse song bị lỗi %@",error.debugDescription);
    }
   
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
       UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainv];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
       // [view.navigationController pushViewController:mainv animated:YES];
    [view presentViewController:nav animated:YES completion:nil];
   // }
   
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

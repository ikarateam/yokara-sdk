//
//  NavigationTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//
#import "StreamingMovieViewController.h"
#import "NavigationTopViewController.h"
#import <Constant.h>
@implementation UINavigationBar (UINavigationBarCategory)
-(void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag{
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    aTabBarBackground.tag = bgTag;
    UIImage * imagee=[self imageWithImage:image scaledToSize:aTabBarBackground.frame.size];
    [self setBackgroundImage:imagee forBarMetrics:UIBarMetricsDefault];
   
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/* input: The tag you chose to identify the view */


@end
@implementation UINavigationController (overrides)
- (BOOL)shouldAutorotate
{
    id currentViewController = self.topViewController;
    
    if ([currentViewController isKindOfClass:[StreamingMovieViewController class]] && (videoRecord || playRecord))
        return NO;
    
    return YES;
}

@end
@implementation NavigationTopViewController
- (UIImage *)imageFromLayer:(CALayer *)layer
    {
        UIGraphicsBeginImageContext([layer frame].size);
        
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        [outputImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        UIGraphicsEndImageContext();
        
        return outputImage;
    }
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    UIStoryboard *storyboard;
    
    //[self showAlertMessage:@"Vui lòng chờ iKara tải dữ liệu lần đầu" withTitle:@"Welcome to iKara"];
 
   // self.navigationBar.tintColor=[UIColor colorWithRed:37/255.0 green:160/255.0 blue:254/255.0 alpha:1];
    //[self.navigationController.navigationBar.layer setContents:(id)[UIImage imageNamed:@"yeu_thich.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
    //self.navigationItem.hidesBackButton=YES;
    
    //UIImage *image = [UIImage imageNamed:@"aurora-480x320.jpg"];//@"background.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect bound=self.navigationBar.bounds;
    bound.size.height+=[UIApplication sharedApplication].statusBarFrame.size.height;
    gradient.frame = bound;
    gradient.startPoint=CGPointMake(0, 1);
    gradient.endPoint=CGPointMake(1, 0);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(BackGroundColor1) CGColor], (id)[UIColorFromRGB(BackGroundColor2) CGColor], nil];
   // gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.navigationBar setBackgroundImage:[self imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: UIColorFromRGB(0xFFFFFF) };
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.tabBarController.hidesBottomBarWhenPushed=YES;
   // [self.navigationItem.titleView.layer addSublayer:gradient];
    [super viewWillAppear:YES];
   
 // [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}
- (void)viewDidLoad{
    if (@available(iOS 15.0, *)) {
        /*CAGradientLayer *gradient = [CAGradientLayer layer];
        CGRect bound=self.navigationBar.bounds;
        bound.size.height+=[UIApplication sharedApplication].statusBarFrame.size.height;
        gradient.frame = bound;
        gradient.startPoint=CGPointMake(0, 1);
        gradient.endPoint=CGPointMake(1, 0);
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xF16041) CGColor], (id)[UIColorFromRGB(0xF02C6A) CGColor], nil];*/
        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
       // navBarAppearance.backgroundImage = [self imageFromLayer:gradient];
        [navBarAppearance configureWithOpaqueBackground];
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor] };
        navBarAppearance.backgroundColor = UIColorFromRGB(HeaderColor);
        self.navigationBar.standardAppearance = navBarAppearance;
        self.navigationBar.scrollEdgeAppearance = navBarAppearance;
    }
}
/*
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     UIViewController* presented = [[self viewControllers] lastObject];
    // You do not need this method if you are not supporting earlier iOS Versions
    return [presented shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}*/

- (BOOL)shouldAutorotate {
   // if (videoRecord){
     //   return YES;
  if (!isKaraokeTab) {
        return YES;
    }else
        return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
   // if (videoRecord) {
   //     return UIInterfaceOrientationMaskLandscapeLeft;
   // }
   // if ( !isKaraokeTab ) {
        return UIInterfaceOrientationMaskPortrait;
  //  }    else return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}

@end

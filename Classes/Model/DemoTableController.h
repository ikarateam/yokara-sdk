//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DemoTableController;
@protocol FPDemoTableControllerDelegate <NSObject>

@optional
-(void)popoverMenu:(DemoTableController *)tableController  selectedTableRow :(NSUInteger)rowNum ;

@end
@interface DemoTableController : UITableViewController
#if __has_feature(objc_arc)
@property(nonatomic,weak) id<FPDemoTableControllerDelegate> delegate;
#else
@property(nonatomic,assign) id<FPDemoTableControllerDelegate> delegate;
#endif
@property(nonatomic,strong) NSMutableArray * array;
@property(nonatomic,strong) NSMutableArray * arrayImage;
@property(nonatomic,strong) NSNumber *hideIcon;

@end

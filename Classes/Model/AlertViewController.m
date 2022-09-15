//
//  AlertViewController.m
//  Yokara
//
//  Created by Rain Nguyen on 7/11/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import "AlertViewController.h"

@interface AlertViewController ()


@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkboxLabel.text=@"\u2611";
    self.contentAdding.text=self.contentAdd;
    self.contentMessage.text=self.contentMess;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)okPress:(id)sender {
    
  
    if([self.delegate respondsToSelector:@selector(okPress:)])
    {
        [self.delegate okPress:YES];
    }
}
- (IBAction)huyPress:(id)sender {
    if([self.delegate respondsToSelector:@selector(okPress:)])
    {
        [self.delegate okPress:NO];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint([self.checkboxLabel frame], [touch locationInView:self.view]))
    {
        [self togglePaidStatus];
    }
}
-(void) togglePaidStatus
{
    NSString *untickedBoxStr = @"\u2610";
    NSString *tickedBoxStr = @"\u2611";
    
    if ([self.checkboxLabel.text isEqualToString:tickedBoxStr])
    {
        self.checkboxLabel.text = untickedBoxStr;
        if([self.delegate respondsToSelector:@selector(checkBoxChange:)])
        {
            [self.delegate checkBoxChange:NO];
        }
    }
    else
    {
        self.checkboxLabel.text = tickedBoxStr;
        if([self.delegate respondsToSelector:@selector(checkBoxChange:)])
        {
            [self.delegate checkBoxChange:YES];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

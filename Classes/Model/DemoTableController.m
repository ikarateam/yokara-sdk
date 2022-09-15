//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//


#import "DemoTableController.h"
#import <Constant.h>
#import "YokaraSDK.h"
@interface DemoTableController ()


@end

@implementation DemoTableController
@synthesize delegate=_delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.tableHeaderView.backgroundColor=[UIColor clearColor];
    self.title = @"";
  
}




#pragma mark - Table view data source
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *imageview=[[UIImageView alloc] init];
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.view.frame.size.width-70,30)];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        /// UIImage *image6 = [UIImage imageNamed:@"no_back.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil];
        
       
    }
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
   // cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    if ([self.hideIcon intValue]){
        label.frame=CGRectMake(10, 10, self.view.frame.size.width-10,30);
    }else{
    [cell.contentView addSubview:imageview];
    }
    
    
    label.textColor=UIColorFromRGB(0x69737f);//[UIColor lightGrayColor];
    [cell.contentView addSubview:label];
      [imageview setFrame:CGRectMake(18, 13, 24, 24)];
       UIImage* image = [UIImage new] ;
     label.text=[self.array objectAtIndex:indexPath.row];
   // if (self.arrayImage.count>indexPath.row) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.arrayImage objectAtIndex:indexPath.row]]   inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil] ;
        imageview.image=image;
    //}
       // cell.imageView.image = image6;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
   
    
        
      //  UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separate_duong.png" inBundle:[YokaraSDK resourceBundle] compatibleWithTraitCollection:nil]];
     //   imgView.frame = CGRectMake(0, 43, self.view.frame.size.width, 1);
       
    //[cell.textLabel setHighlighted:YES];
   // cell.textLabel.textColor=[UIColor lightGrayColor];// colorWithRed:194/255.0 green:201/255.0 blue:217/255.0 alpha:1];
     //   cell.textLabel.text=[self.array objectAtIndex:indexPath.row];
    

    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(popoverMenu:selectedTableRow:)])
    {
        [self.delegate popoverMenu:self selectedTableRow:indexPath.row];
    }
}





@end

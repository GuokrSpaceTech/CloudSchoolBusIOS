//
//  ETChildManagerViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-25.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETChildManagerViewController.h"
#import "ETKids.h"
#import "ETCoreDataManager.h"
#import "ETCommonClass.h"
#import "AppDelegate.h"
#import "ETBottomViewController.h"

@interface ETChildManagerViewController ()

@end

@implementation ETChildManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    
    
    
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13+ (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"childmanager", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT+ (ios7 ? 20 : 0), 320, self.view.frame.size.height - NAVIHEIGHT) style:UITableViewStyleGrouped];
    //        tv.backgroundView.backgroundColor = CELLCOLOR;
    mainTV.backgroundView = nil;
    mainTV.backgroundColor = CELLCOLOR;
    mainTV.delegate = self;
    mainTV.dataSource = self;
    [self.view addSubview:mainTV];
    [mainTV release];
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UserLogin *user = [UserLogin currentLogin];
    NSArray * arr = [ETCoreDataManager getUsers:user.regName];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }
    
    
    UserLogin *user = [UserLogin currentLogin];
    NSArray * arr = [ETCoreDataManager getUsers:user.regName];
    
    ETUser *u = [arr objectAtIndex:indexPath.row];
    
    NSLog(@"%@",u.nikename);
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imgV.center = CGPointMake(26, 22);
    [cell.contentView addSubview:imgV];
    [imgV release];
    
    if ([user.nickname isEqualToString:u.nikename] && [user.uid_class isEqualToString:u.uid_class])
    {
        imgV.image = [UIImage imageNamed:@"currentKids.png"];
        
    }
    else
    {
        imgV.image = [UIImage imageNamed:@"otherKids.png"];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, 200, 30)];
    label.text = [NSString stringWithFormat:@"%@   %@",u.nikename,u.classname];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    
    [cell.contentView addSubview:label];
    [label release];

    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserLogin *user = [UserLogin currentLogin];
    NSArray * arr = [ETCoreDataManager getUsers:user.regName];
    ETUser *u = [arr objectAtIndex:indexPath.row];
    
    if ([user.nickname isEqualToString:u.nikename] && [user.uid_class isEqualToString:u.uid_class])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        AppDelegate *delegate = SHARED_APP_DELEGATE;
        UIButton *btn = (UIButton *)[delegate.bottomVC.view viewWithTag:4444];
        btn.selected = NO;
        [delegate.bottomVC showDefaultController];
        
    }
    else
    {
        if(HUD==nil)
        {
            HUD=[[MBProgressHUD alloc]initWithView:self.view];
            
            [self.view addSubview:HUD];
            [HUD release];
            [HUD show:YES];
            
        }
        
//        UserLogin *user = [UserLogin currentLogin];
        
        ETCommonClass *com = [[ETCommonClass alloc] init];
        [com changeChildByClass:u.uid_class student:u.uid_student WithComplete:^(NSError *err) {
            
            if(HUD)
            {
                [HUD removeFromSuperview];
                HUD=nil;
            }
            
            if (err == nil) {
                
                [ETCommonClass clearUserMessage];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [delegate.bottomNav dismissModalViewControllerAnimated:NO];
                
                
                ETBottomViewController *bVC = [[ETBottomViewController alloc] init];
                delegate.bottomVC = bVC;
                [bVC release];
                
                ETBottomNavigationController *bNC = [[ETBottomNavigationController alloc] initWithRootViewController:delegate.bottomVC];
                delegate.bottomNav = bNC;
                [bNC release];
                
                [delegate.loginViewController presentModalViewController:delegate.bottomNav animated:YES];
            }
            
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

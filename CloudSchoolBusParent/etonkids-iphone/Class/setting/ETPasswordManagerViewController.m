//
//  ETPasswordManagerViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-8.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETPasswordManagerViewController.h"
#import "ETKids.h"
#import "ETRePassWordViewController.h"
#import "AppDelegate.h"

@interface ETPasswordManagerViewController ()

@end

@implementation ETPasswordManagerViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
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
    middleLabel.text=LOCAL(@"Password", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    if ([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"0"]) {
        n = 1;
    }
    else
    {
        n = 2;
    }
    
    
    mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT+ (ios7 ? 20 : 0), 320, self.view.frame.size.height - NAVIHEIGHT) style:UITableViewStyleGrouped];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return n;
            break;
        default:
            return 0;
            break;
    }
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
    
    
    NSArray *arr = [NSArray arrayWithObjects:@"changePWD",@"gesturePWD",@"changeGesturePWD", nil];
    cell.textLabel.text=LOCAL([arr objectAtIndex:indexPath.row + indexPath.section], @"");
        
    if (indexPath.row == 0 && indexPath.section == 1)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (gesSwitch == nil) {
            gesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210 + (ios7?45:0), 6, 60, 30)];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [gesSwitch setOn:([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"1"] ? YES : NO)];
            [gesSwitch addTarget:self action:@selector(switchGesture:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:gesSwitch];
            [gesSwitch release];
        }
        
    }
    else
    {
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if (gesSwitch != nil) {
//            [gesSwitch removeFromSuperview];
//            gesSwitch = nil;
//        }
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        ETRePassWordViewController *passViewController=[[ETRePassWordViewController alloc]initWithNibName:@"ETRePassWordViewController" bundle:nil];
//        AppDelegate *appDel = SHARED_APP_DELEGATE;
        [self.navigationController pushViewController:passViewController animated:YES];
        [passViewController release];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        ETChangeGestureViewController *cgVC = [[ETChangeGestureViewController alloc] init];
//        AppDelegate *appDel = SHARED_APP_DELEGATE;
        [self.navigationController pushViewController:cgVC animated:YES];
        [cgVC release];
    }
}

- (void)switchGesture:(id)sender
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if (gesSwitch.isOn)
    {
//        [userdefault setObject:@"1" forKey:SWITHGESTURE];
        n += 1;
        [mainTV insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
        ETChangeGestureViewController *cgVC = [[ETChangeGestureViewController alloc] init];
        [self.navigationController pushViewController:cgVC animated:YES];
        [cgVC release];
        
    }
    else
    {
        [userdefault setObject:@"0" forKey:SWITHGESTURE];
        [userdefault removeObjectForKey:GESTUREPASSWORD];
        n -= 1;
        [mainTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{
//    [mainTV reloadData];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"1"]) {
        n = 2;
        [gesSwitch setOn:YES];
    }
    else{
        n = 1;
        [gesSwitch setOn:NO];
    }
    
    [mainTV reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

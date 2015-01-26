//
//  ETBackgroundViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBackgroundViewController.h"
#import "ETKids.h"
#import "Modify.h"
#import "UserLogin.h"
#import "ETdefaultViewController.h"
@interface ETBackgroundViewController ()

@end

@implementation ETBackgroundViewController
@synthesize tableview,originImage;
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
    
    
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13+ (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"Background",@"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIHEIGHT+ (ios7 ? 20 : 0), 320, self.view.frame.size.height - NAVIHEIGHT) style:UITableViewStyleGrouped];
    tv.scrollEnabled = YES;
    tv.dataSource = self;
    tv.delegate = self;
//    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tv.backgroundView = nil;
    tv.backgroundColor = CELLCOLOR;
    [self.view addSubview:tv];
    [tv release];
    
    self.tableview = tv;
    
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];

    // Do any additional setup after loading the view from its nib.
}
-(void)leftButtonClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  ---tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
            break;
        default:
            return 0;
        break;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *CellIdentifier = @"section0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        for (UIView * view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
            
        }
        
        if (indexPath.row==0)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Choose a Wallpaper",@"");
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    else if(indexPath.section==1)
    {
        static NSString *CellIdentifier = @"section1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        for (UIView * view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
            
        }
        if (indexPath.row==0)
        {
//            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"choosePhoto",@"");
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
//            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"take",@"");
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        }
        return cell;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        if (indexPath.row==0)//选择背景图片
        {
            [self performSelector:@selector(pushup) withObject:nil];
        }
    }
    if (indexPath.section==1)//从手机相册中选择
    {
        if (indexPath.row==0)
        {
            [self local];
        }
        if (indexPath.row==1)//拍一张
        {
           
            [self takephoto];
        }
    }
}
-(void)pushup
{
    ETdefaultViewController *defaultViewControlle=[[ETdefaultViewController alloc]initWithNibName:@"ETdefaultViewController" bundle:nil];
    [self.navigationController  pushViewController:defaultViewControlle animated:YES];
    [defaultViewControlle release];
}
-(void)local
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    [picker release];
 
}
-(void)takephoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    [picker release];

}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
- (void)saveImage:(UIImage *)image
{
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
        
    }
    
    self.originImage = image;
    
    UserLogin *user = [UserLogin currentLogin];
    if ([user.skinid isEqualToString:@"-1"])
    {
        NSData *mydata=UIImageJPEGRepresentation(self.originImage, 0.5);
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:mydata forKey:@"HEADERBACKGROUND_DATA"];
        [userDefault synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEBACKGROUND" object:nil];
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }else
    {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"skinid", nil];
        [[EKRequest Instance] EKHTTPRequest:skinid parameters:param requestMethod:POST forDelegate:self];
    }
    
    
    
    

}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (method == skinid && code == 1)
    {
        if (originImage) {
            
            UserLogin *user = [UserLogin currentLogin];
            user.skinid = @"-1";
            
            NSData *mydata=UIImageJPEGRepresentation(self.originImage, 0.5);
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:mydata forKey:@"HEADERBACKGROUND_DATA"];
            [userDefault setObject:@"-1" forKey:@"HEADERBACKGROUND"];
            [userDefault synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEBACKGROUND" object:nil];
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
        }
        
        
        
    }
    else
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
    [alert show];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


-(void)dealloc
{
    self.originImage = nil;
    self.tableview = nil;
    [super dealloc];
}

@end

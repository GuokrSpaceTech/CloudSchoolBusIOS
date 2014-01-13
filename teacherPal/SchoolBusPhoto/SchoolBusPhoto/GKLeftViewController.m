//
//  GKLeftViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKLeftViewController.h"

#import "GKAppDelegate.h"
#import "GKClassViewController.h"
#import "GKLetterViewController.h"
#import "GKNoticeViewController.h"
#import "KKNavigationController.h"
#import "GKAlumbViewController.h"
#import "GKAboutViewController.h"
#import "GKLoaderManager.h"
@interface GKLeftViewController ()

@end

@implementation GKLeftViewController
//@synthesize arr;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
   // self.arr=nil;
    [usr removeObserver:self forKeyPath:@"badgeNumber" context:NULL];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%f",self.view.frame.size.height);
    self.view.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    UIView *backView=nil;
    if(ios7)
        backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0 + IOS7OFFSET, 320, self.view.frame.size.height)];
    else
        backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
   // backView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
    backView.backgroundColor=[UIColor colorWithRed:46/255.0 green:56/255.0 blue:64/255.0 alpha:1.0f];
    [self.view addSubview:backView];
    [backView release];
    
    
   // self.view.backgroundColor = [UIColor colorWithRed:44/255.0 green:57/255.0 blue:66/255.0 alpha:1.0f];
    UIImageView *_imageView=nil;
    if (ios7)
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0+IOS7OFFSET, 320, 46)];
    else
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    
    _imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(home:)];
    tap.numberOfTapsRequired=1;

    [_imageView addGestureRecognizer:tap];
    [tap release];
    
    

    _imageView.image=IMAGENAME(IMAGEWITHPATH(@"tou"));
    _imageView.userInteractionEnabled=YES;
    [self.view addSubview:_imageView];
    

    [_imageView release];
    
  
    UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(23, 5, 34, 34)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"home-1"))forState:UIControlStateNormal];
     [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"home-2")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(doClickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:buttom];
    
    self.navigationController.navigationBarHidden=YES;

    
//    "grade"="grade.png";
//    "gradeH"="gradeH.png";
//    "setting"="setting.png";
//    "settingH"="settingH.png";
    
//    classLeft.png
    NSLog(@"????? %@",NSLocalizedString(@"classLeft", @""));
     NSLog(@"????? %@",  NSLocalizedString(@"classLeftH", @""));
  
    NSArray *defArr = [NSArray arrayWithObjects:NSLocalizedString(@"notice", @""),NSLocalizedString(@"grade", @""), NSLocalizedString(@"home", @""),NSLocalizedString(@"setting", @""),nil];
    NSArray *selArr = [NSArray arrayWithObjects:NSLocalizedString(@"noticeH", @""),NSLocalizedString(@"gradeH", @""),NSLocalizedString(@"homeH", @""), NSLocalizedString(@"settingH", @""),  nil];
    totle=[defArr count];
    for (int i=0; i<[defArr count]; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[defArr objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[selArr objectAtIndex:i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[selArr objectAtIndex:i]] forState:UIControlStateSelected];
        if(ios7)
            button.frame = CGRectMake(0, IOS7OFFSET + 46 + 52*i, 320, 52);
        else
            button.frame=CGRectMake(0, 46 + 52*i, 320, 52);
        button.tag=i+1;
        button.selected=NO;
        [button addTarget:self action:@selector(doClickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
   
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height-48, 28, 28)];
    imageView.image=IMAGENAME(IMAGEWITHPATH(@"loginOUt"));
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *outButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
   
    [outButton setTitle:NSLocalizedString(@"out", @"") forState:UIControlStateNormal];
    outButton.titleLabel.textColor=[UIColor colorWithRed:236/255.0 green:203/255.0 blue:108/255.0 alpha:1];
    [outButton setTitleColor:[UIColor colorWithRed:236/255.0 green:203/255.0 blue:108/255.0 alpha:1] forState:UIControlStateNormal];
    outButton.frame = CGRectMake(20, self.view.frame.size.height-48-10, 536/2-50, 48);
   
    outButton.tag=[defArr count]+1;
    [outButton addTarget:self action:@selector(doClickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];

    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:0]];
        _selectIdnex = 0;
    }
    
    badgeView=[[GKBadgeView alloc]initWithFrame:CGRectMake(150, 75, 16, 16)];
    badgeView.backgroundColor=[UIColor clearColor];
    badgeView.bagde=0;
    [self.view addSubview:badgeView];
    [badgeView release];
    
 
    usr=[GKUserLogin currentLogin];
    
    [usr addObserver:self forKeyPath:@"badgeNumber" options:NSKeyValueObservingOptionNew context:NULL];
    usr=[GKUserLogin currentLogin];
    badgeView.bagde=[usr.badgeNumber integerValue];
    

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    usr=[GKUserLogin currentLogin];
    badgeView.bagde=[usr.badgeNumber integerValue];

}
-(void)home:(UITapGestureRecognizer *)tap
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag >= 1 && btn.tag <= totle) {
                btn.selected = NO;
                //                btn.userInteractionEnabled = YES;
            }
        }
    }
    
    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        if ( _selectIdnex == 0)
        {
            [delegate leftSideBarSelectWithController:nil];
        }
        else
        {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:0]];
        }
        
        _selectIdnex=0;
    }

}
-(void)doClickBottomBtn:(UIButton *)sender
{
    
    NSLog(@"click bottom button");
    
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            NSLog(@"%d",btn.tag);
            if (btn.tag >= 1 && btn.tag <= totle) {
                btn.selected = NO;
                //                btn.userInteractionEnabled = YES;
            }
        }
    }
    
    NSInteger tag=sender.tag;
    
        NSLog(@"click bottom button:%d",tag);
    if(tag==totle+1)
    {
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"confirmOut", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"out", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
        [alert show];
        [alert release];
 
        return;
    }
    sender.selected=YES;
    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        if ( _selectIdnex == tag)
        {
            [delegate leftSideBarSelectWithController:nil];
        }
        else
        {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:tag]];
        }
        
        _selectIdnex=tag;
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if([delegate respondsToSelector:@selector(loginOut)])
        {
            [delegate loginOut];
        }
    }
}
- (UINavigationController *)subConWithIndex:(int)index
{
    if(index==0)
    {
        
        GKAlumbViewController *alumbController=[[GKAlumbViewController alloc]init];
        
       // GKImagePickerViewController *con = [[GKImagePickerViewController alloc] init];
        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:alumbController];
       
        [alumbController release];

        return [nav autorelease];
    }
    if(index==1)
    {
        
        NSUserDefaults *defaultuser=[NSUserDefaults standardUserDefaults];
        [defaultuser setObject:[NSNumber numberWithInt:0]forKey:@"BADGE"];
        
        GKUserLogin *user=[GKUserLogin currentLogin];
        user.badgeNumber=[NSNumber numberWithInt:0];
        
        GKLetterViewController *letterVC=[[GKLetterViewController alloc]init];
        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:letterVC];
        [letterVC release];
        
        return [nav autorelease];
        

    }
    if(index==2)
    {
        GKClassViewController *classVC=[[GKClassViewController alloc]init];
        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:classVC];
        [classVC release];
        
        return [nav autorelease];
    }
    if(index==3)
    {
        
        GKNoticeViewController *noticeVC=[[GKNoticeViewController alloc]init];
        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:noticeVC];
        [noticeVC release];
        
        return [nav autorelease];
//        GKUpLoaderViewController *aboutVC=[[GKUpLoaderViewController alloc]init];
//        UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:aboutVC];
//        [aboutVC release];
//
//        return [nav autorelease];

    }
    if(index==4)
    {


        GKSettingViewController *settingVC=[[GKSettingViewController alloc]init];
        settingVC.delegate=self;
        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:settingVC];
        [settingVC release];

        return [nav autorelease];
        
    }
//    if(index==5)
//    {
//        
//        GKRePasswordViewController *repass=[[GKRePasswordViewController alloc]init];
//        repass.delegate=self;
//        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:repass];
//        [repass release];
//        
//        return [nav autorelease];
//        
//    
//        
//    }
//    if(index==6)
//    {
//        GKAboutViewController *aboutVC=[[GKAboutViewController alloc]initWithNibName:@"GKAboutViewController" bundle:nil];
//        KKNavigationController *nav= [[KKNavigationController alloc] initWithRootViewController:aboutVC];
//        [aboutVC release];
//        
//        return [nav autorelease];
//
//    }
    return nil;


}

-(void)settingLoginOut
{
    //[delegate loginOut];
    
    
    GKAppDelegate *_delegate= APPDELEGATE;
    
    _delegate.loginVC.passWord.text=@"";
    
    
    [GKUserLogin clearpassword];
    
    [[GKLoaderManager createLoaderManager]setQueueStop];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
   // [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

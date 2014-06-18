//
//  ETSendRecevieViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETSendRecevieViewController.h"
#import "ETKids.h"
#import "ETAddSendReceiveViewController.h"
#import "AppDelegate.h"
//#import "GKChildReceiver.h"
#import "UIImageView+WebCache.h"

@interface ETSendRecevieViewController ()

@end

@implementation ETSendRecevieViewController

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
    
    self.view.backgroundColor=[UIColor blackColor];
    
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
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = NSLocalizedString(@"receiver", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    
    _scrollerView_=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT+ (ios7 ? 20 : 0), self.view.frame.size.height, self.view.frame.size.height-NAVIHEIGHT-(ios7 ? 20 : 0))];
    _scrollerView_.backgroundColor=[UIColor clearColor];
    _scrollerView_.showsHorizontalScrollIndicator=NO;
    _scrollerView_.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollerView_];
    
    
    [self loadGirdUI];
    
    // Do any additional setup after loading the view.
}
-(void)loadGirdUI
{

    for (UIView *view in [_scrollerView_ subviews]) {
        if([view isKindOfClass:[ETSendReceiveView class]])
        {
            [view removeFromSuperview];
        }
    }

    for (int i=0; i<[self.receiverArr count]+1; i++) {
        
        int row=i/2;
        int col=i%2;
        
        if(i!=[self.receiverArr count])
        {
            GKChildReceiver *rece=[self.receiverArr objectAtIndex:i];
            ETSendReceiveView *sendView=[[ETSendReceiveView alloc]initWithFrame:CGRectMake(10+col*(140+20), row*(140+25+10), 140, (140+25))];
            sendView.namelabel.text=rece.relationship;
            [sendView.photoImageView setImageWithURL:[NSURL URLWithString:rece.filepath] placeholderImage:nil];
            sendView.delegate=self;
            sendView.receiver=rece;
            sendView.type=1;
            [_scrollerView_ addSubview:sendView];
            [sendView release];
        }
        else
        {
            if ([self.receiverArr count]==4) {
                return;
            }
            ETSendReceiveView *sendView=[[ETSendReceiveView alloc]initWithFrame:CGRectMake(10+col*(140+20),row*(140+25+10), 140, 140+25)];
            sendView.namelabel.text=NSLocalizedString(@"add1", @"");
            sendView.photoImageView.image=[UIImage imageNamed:@"addreceiver.png"];
            sendView.delegate=self;
            sendView.type=2;
            [_scrollerView_ addSubview:sendView];
            [sendView release];
        }
        

    }
     int row=([self.receiverArr count]+1)/2;
    
    _scrollerView_.contentSize=CGSizeMake(_scrollerView_.frame.size.width, row *(140+25+10));
    
}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapPressViewAddNewSendReceivePeople
{
    ETAddSendReceiveViewController *addSendVC=[[ETAddSendReceiveViewController alloc]init];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
 
    [appDel.bottomNav pushViewController:addSendVC animated:YES];
    [addSendVC release];
    [addSendVC successAddReceiver:^(NSDictionary *dic) {
        
        NSLog(@"1111%@",dic);
        
        
        GKChildReceiver *receiver=[[GKChildReceiver alloc]init];
        receiver.receiverid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        receiver.pid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]];
        receiver.relationship=[dic objectForKey:@"relationship"];
        receiver.filepath=[NSString stringWithFormat:@"http://%@",[dic objectForKey:@"filepath"]];
        [self.receiverArr addObject:receiver];
        [receiver release];
        
        
        [self loadGirdUI];

    }];
    
    
}
-(void)tapSendReceiver
{
    for (UIView * view in _scrollerView_.subviews ) {
        if([view isKindOfClass:[ETSendReceiveView class]])
        {
            ETSendReceiveView *sendView=(ETSendReceiveView *)view;
            [self stopShakeAnimationForView:sendView];
            
        }
    }

}
-(void)longPressView
{
    for (UIView * view in _scrollerView_.subviews ) {
        if([view isKindOfClass:[ETSendReceiveView class]])
        {
            ETSendReceiveView *sendView=(ETSendReceiveView *)view;
            if(sendView.type==1)
            {
                 [self shakeAnimationForView:sendView];
            }
           
            
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UIView * view in _scrollerView_.subviews ) {
        if([view isKindOfClass:[ETSendReceiveView class]])
        {
            ETSendReceiveView *sendView=(ETSendReceiveView *)view;
            [self stopShakeAnimationForView:sendView];
            
        }
    }

}
-(void)deleteRelation:(GKChildReceiver *)child
{
    self.wantDelete=child;
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:@"delete" message:@"确认删除" delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"ok", @"确定"), nil];
    [alert show];
    

}
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(index==0)
    {
        self.wantDelete=nil;
    }
    else
    {
        NSLog(@"delete");
        if(HUD==nil)
        {
            AppDelegate *appDel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            HUD=[[MBProgressHUD alloc]initWithView:appDel.window];
            HUD.labelText=LOCAL(@"load", @"加载");   //@"正在上传头像";
            [appDel.window addSubview:HUD];
            [HUD show:YES];
            [HUD release];
        }

        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.wantDelete.receiverid,@"id", nil];
        [[EKRequest Instance]EKHTTPRequest:deletereceiver parameters:dic requestMethod:POST forDelegate:self];
    }
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }

    if(method==deletereceiver)
    {
        if(code==1)
        {
            [self.receiverArr removeObject:self.wantDelete];
            [self loadGirdUI];
        }
        else if(code==-3)
        {
            
        }
        
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)shakeAnimationForView:(ETSendReceiveView *) view

{
    
  
    [view deleteBtnHidden:NO];
//        srand([[NSDate date] timeIntervalSince1970]);
//        float rand=(float)random();
//        CFTimeInterval t=rand*0.0000000001;
//        [UIView animateWithDuration:0.1 delay:t options:0  animations:^
//         {
//             view.transform=CGAffineTransformMakeRotation(-0.05);
//         } completion:^(BOOL finished)
//         {
//             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
//              {
//                  view.transform=CGAffineTransformMakeRotation(0.05);
//              } completion:^(BOOL finished) {}];
//         }];
    

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
     {
          view.transform=CGAffineTransformMakeRotation(-0.05);
         view.transform=CGAffineTransformMakeRotation(0.05);
     } completion:^(BOOL finished) {}];

    
    
}
-(void)stopShakeAnimationForView:(ETSendReceiveView *)view
{

  
        [view deleteBtnHidden:YES];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             view.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {}];
    

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView * view in _scrollerView_.subviews ) {
        if([view isKindOfClass:[ETSendReceiveView class]])
        {
            ETSendReceiveView *sendView=(ETSendReceiveView *)view;
            [self stopShakeAnimationForView:sendView];
            
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.scrollerView_=nil;
    self.receiverArr=nil;
    self.wantDelete=nil;
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

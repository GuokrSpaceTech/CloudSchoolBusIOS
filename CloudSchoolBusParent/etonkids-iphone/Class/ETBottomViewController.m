//
//  ETBottomViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBottomViewController.h"
#import "ActivityViewController.h"
#import "ETCalendarViewController.h"
#import "ETEducationViewController.h"


#import "ETFeedbackView.h"
#import "ETAboutView.h"
#import "ETCommonClass.h"
#import "ETFoodView.h"
#import "ETScheduleView.h"
#import "ETGestureCheckViewController.h"
#import "ETChangeGestureViewController.h"
#import "ETSettingsViewController.h"
#import "ETSettingView.h"
#import "ETChildViewController.h"
#import "ETMyAccountView.h"

#define PASSWordOrgin  998
#define LoginOutAlety 997
#define VersionAlert 996
#import "ETRePassWordViewController.h"
@interface ETBottomViewController ()

@end

@implementation ETBottomViewController
@synthesize leveyTBC,topView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShow:) name:@"UPDATEDATA" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openGesture) name:@"OPENGESTURE" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeGesture) name:@"CLOSEGESTURE" object:nil];
        
    }
    return self;
}
- (void)openGesture
{
    if (pan == nil) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPan:)];
        pan.delegate = self;
        [topView addGestureRecognizer:pan];
        [pan release];
    }
    
    if (swipe == nil) {
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [topView addGestureRecognizer:swipe];
        [swipe release];
    }
    
    if (swipe1 == nil) {
        swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
        swipe1.direction = UISwipeGestureRecognizerDirectionLeft;
        [topView addGestureRecognizer:swipe1];
        [swipe1 release];
    }
    
    
    [pan requireGestureRecognizerToFail:swipe];
    [pan requireGestureRecognizerToFail:swipe1];
}
- (void)closeGesture
{
    [topView removeGestureRecognizer:pan];
    [topView removeGestureRecognizer:swipe];
    [topView removeGestureRecognizer:swipe1];
    
    pan = nil;
    swipe = nil;
    swipe1 = nil;
}

- (void)updateShow:(NSNotification *)notifi
{
    
//    NSLog(@"%@,%@",[notifi object],notifi.userInfo);
    NSString *pushStr = [NSString stringWithFormat:@"%@",[notifi object]];
    
    //显示主页 tab
    UIButton *b = (UIButton *)[self.view viewWithTag:4444 + 9];
    [self changeView:b];
    
    if ([pushStr isEqualToString:@"attendance"])
    {
        
    }
    else if ([pushStr isEqualToString:@"menu"])
    {
        
    }
    else if ([pushStr isEqualToString:@"schedule"])
    {
        
    }
    else if ([pushStr isEqualToString:@"event"])
    {
        UIButton *b = (UIButton *)[self.view viewWithTag:4444 + 9];
        [self changeView:b];
        self.leveyTBC.selectedIndex = 2;    //活动报名
    }
    else if ([pushStr isEqualToString:@"info"])
    {
        
    }
    else if ([pushStr isEqualToString:@"article"])
    {
        [self showDefaultController];    //班级日志
    }
    else if ([pushStr isEqualToString:@"comment"])
    {
        
    }
    else if ([pushStr isEqualToString:@"notice"])
    {
        UIButton *b = (UIButton *)[self.view viewWithTag:4444 + 9];
        [self changeView:b];
        self.leveyTBC.selectedIndex = 1;    //消息通知
    }
    else if ([pushStr isEqualToString:@"birthday"])
    {
        
    }
    //显示
    
}

- (void)showDefaultController
{
    UIButton *b = (UIButton *)[self.view viewWithTag:4444 + 9];
    [self changeView:b];
    self.leveyTBC.selectedIndex = 0;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:44/255.0 green:57/255.0 blue:66/255.0 alpha:1.0f];
    
    
//    UserLogin *user=[UserLogin currentLogin];
    

    // ---------  bottom view  -----------
    
    
    
    
    UIImageView *blackBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
//    blackBar.backgroundColor = [UIColor blackColor];
    blackBar.image = [UIImage imageNamed:@"btm_black.png"];
    [self.view addSubview:blackBar];
    [blackBar release];
    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 60, 38)];
//    titleLab.center = CGPointMake(RIGHTMARGIN/2.0f + 15, 19 + (ios7 ? 20 : 0));
//    titleLab.text = LOCAL(@"home", @"");
//    titleLab.font = [UIFont systemFontOfSize:14.0f];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:titleLab];
//    [titleLab release];

    
    UIImageView *homeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    homeImgV.center = CGPointMake(40, NAVIHEIGHT/2.0f + (ios7 ? 20 : 0));
    homeImgV.image = [UIImage imageNamed:@"showMain.png"];
    [self.view addSubview:homeImgV];
    [homeImgV release];
    
    
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mainBtn setImage:[UIImage imageNamed:@"showMain.png"] forState:UIControlStateNormal];
//    mainBtn.backgroundColor = [UIColor redColor];
    mainBtn.frame = CGRectMake(0, 0 + (ios7 ? 20 : 0), RIGHTMARGIN, NAVIHEIGHT);
    mainBtn.tag = 4444 + 9;
    mainBtn.selected = YES;
    [mainBtn addTarget:self action:@selector(doClickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.center = CGPointMake(RIGHTMARGIN/2.0f, NAVIHEIGHT/2.0f + (ios7 ? 20 : 0));
    [self.view addSubview:mainBtn];
    
    
    NSArray *defArr = [NSArray arrayWithObjects:
                       @"mycounticon2.png",
                       @"bottomFoodDef.png",
                       @"bottomScheduleDef.png",
                       @"bottomSettingDef.png",
                       @"bottomFeedbackDef.png",
//                       @"bottomCommentDef.png",
//                       @"bottomNewVersionDef.png",
//                       @"bottomAboutDef.png",
                       @"bottomLogoutDef.png", nil];
    
//    NSArray *selArr = [NSArray arrayWithObjects:
//                       @"bottomFoodSel.png",
//                       @"bottomScheduleSel.png",
//                       @"bottomSettingSel.png",
//                       @"bottomFeedbackSel.png",
//                       @"bottomCommentSel.png",
//                       @"bottomNewVersionSel.png",
//                       @"bottomAboutSel.png",
//                       @"bottom_logout_selected.png", nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:
                         LOCAL(@"btm_myaccount",@""),
                         LOCAL(@"btm_food",@""),
                         LOCAL(@"btm_schedule",@""),
                         LOCAL(@"btm_setting",@""),
                         LOCAL(@"btm_feedback",@""),
//                         LOCAL(@"btm_score",@""),
//                         LOCAL(@"btm_newversion",@""),
//                         LOCAL(@"btm_about",@""),
                         LOCAL(@"btm_logout",@""), nil];
    
    for (int i = 0 ; i < 6; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i != 5) {
            [btn setImage:[UIImage imageNamed:@"bottomDef.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"bottomSel.png"] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"bottomSel.png"] forState:UIControlStateSelected];
        }
        
        btn.tag = 4444 + i;
        if (i == 5)
        {
            btn.frame = CGRectMake(0, 0, 320, 53);
//            btn.center = CGPointMake(160, ([UIScreen mainScreen].applicationFrame.size.height - 38 - 7*48)/2 + (38 + 7*48));
            btn.center = CGPointMake(160, [UIScreen mainScreen].applicationFrame.size.height - 24 - 20 + (ios7 ? 20 : 0));
        }
        else
        {
            btn.frame = CGRectMake(0, NAVIHEIGHT + 53*i + (ios7 ? 20 : 0), 320, 53);
        }
        
        [btn addTarget:self action:@selector(doClickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        label.backgroundColor = [UIColor clearColor];
        if (i == 5) {
            label.textColor = [UIColor colorWithRed: 232/255.0f green:203/255.0f blue:99/255.0f alpha:1.0f];
        }else{
            label.textColor = [UIColor colorWithRed:183/255.0f green:192/255.0f blue:199/255.0f alpha:1.0f];
        }
        
        label.text = [titleArr objectAtIndex:i];
//        label.font = [UIFont fontNamesForFamilyName:@""];
        label.tag = 6666 + i;
        label.center = CGPointMake(140, btn.center.y);
        [self.view addSubview:label];
        [label release];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        imgV.image = [UIImage imageNamed:[defArr objectAtIndex:i]];
//        imgV.backgroundColor = [UIColor yellowColor];
        imgV.tag = 5555 + i;
        imgV.center = CGPointMake(40, btn.center.y);
        [self.view addSubview:imgV];
        [imgV release];
        
        if (i != 5) {
            UIImageView *arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 13)];
            arrowImgV.image = [UIImage imageNamed:@"GO"];
            arrowImgV.tag = 7777 + i;
            arrowImgV.center = CGPointMake(238, btn.center.y);
            [self.view addSubview:arrowImgV];
            [arrowImgV release];
        }
        
        
        
    }
    
    
    UIView *topv = [[UIView alloc] initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, iphone5 ? 548 : 460)];
    topv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topv];
    [topv release];
    
    self.topView = topv;
    
    [self openGesture];
    
    // -----------  navigation -----------
    
    
    
    
    [self createMainViewByPresent:YES];
    
    
    
    //---------- 挡住屏幕右侧的界面 ----------
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, [UIScreen mainScreen].applicationFrame.size.height)];
    view.backgroundColor = CELLCOLOR;
    [self.view addSubview:view];
    [view release];
    UIImageView *topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
    topImgV.image = [UIImage imageNamed:@"navBackGround.png"];
    [view addSubview:topImgV];
    [topImgV release];
    
//    ETLoginViewController *loginViewController=[[ETLoginViewController alloc]initWithNibName:@"ETLoginViewController" bundle:nil];
//    [self presentModalViewController:loginViewController animated:YES];
//    [loginViewController release];
//    [self performSelector:@selector(startAction) withObject:nil afterDelay:0.0f];
    
    
    // 状态条背景
    if (ios7) {
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusBar];
        [statusBar release];
    }
    
    
    
    [ETCommonClass createHelpWithTag:1001 image:[UIImage imageNamed:iphone5 ? @"help_zhuye_568.png" : @"help_zhuye.png"]];
    
    
	// Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated
{
//    ETClassViewController *classVC = [self.leveyTBC.viewControllers objectAtIndex:0];
//    [classVC reloadTableViewData];
}



- (void)doSwipe:(UISwipeGestureRecognizer *)sender
{
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        
        [ETCommonClass createHelpWithTag:1000 image:[UIImage imageNamed:iphone5 ? @"help_cela_568.png" : @"help_cela.png"]];
        
        
        [UIView animateWithDuration:0.5f animations:^{
            sender.view.frame = CGRectMake(RIGHTMARGIN, sender.view.frame.origin.y, sender.view.frame.size.width, sender.view.frame.size.height);
        }completion:^(BOOL finished) {
            
            //加入半透明 遮挡
            
            if (![topView viewWithTag:3333]) {
                UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                             NAVIHEIGHT,
                                                                             topView.frame.size.width,
                                                                             topView.frame.size.height)];
                blackView.backgroundColor = [UIColor blackColor];
                blackView.alpha = 0.0;
                blackView.tag = 3333;
                [topView addSubview:blackView];
                [blackView release];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doClickLeftBtn:)];
                [blackView addGestureRecognizer:tap];
                [tap release];
                
                [UIView animateWithDuration:0.25f animations:^{
                    [topView viewWithTag:3333].alpha = 0.3f;
                }];
            }
            

        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            sender.view.frame = CGRectMake(0, sender.view.frame.origin.y, sender.view.frame.size.width, sender.view.frame.size.height);
        }completion:^(BOOL finished) {
            
            [self removeBlackViewWithFade];
            
        }];
    }
}

- (void)doPan:(UIGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = [sender locationInView:[UIApplication sharedApplication].keyWindow];

//        self.countTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startTime) userInfo:nil repeats:YES];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        
        int distanceX = p.x - beginPoint.x;
        
        if (sender.view.frame.origin.x + distanceX >= 0) {
            sender.view.frame = CGRectMake(sender.view.frame.origin.x + distanceX,
                                           sender.view.frame.origin.y,
                                           sender.view.frame.size.width,
                                           sender.view.frame.size.height);
        }
        
        beginPoint = p;
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
//        CGPoint p = [sender locationInView:[UIApplication sharedApplication].keyWindow];

//        [self.countTimer invalidate];
//        self.countTimer = nil;
        
        
//        float s = p.x - gesS;
        
        
        if (topView.frame.origin.x >= 190) {
            [UIView animateWithDuration:0.5f animations:^{
                sender.view.frame = CGRectMake(RIGHTMARGIN, sender.view.frame.origin.y, sender.view.frame.size.width, sender.view.frame.size.height);
            }completion:^(BOOL finished) {
                
                if (![topView viewWithTag:3333]) {
                    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 NAVIHEIGHT,
                                                                                 topView.frame.size.width,
                                                                                 topView.frame.size.height)];
                    blackView.backgroundColor = [UIColor blackColor];
                    blackView.alpha = 0.0f;
                    blackView.tag = 3333;
                    [topView addSubview:blackView];
                    [blackView release];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doClickLeftBtn:)];
                    [blackView addGestureRecognizer:tap];
                    [tap release];
                    
                    [UIView animateWithDuration:0.25f animations:^{
                        [topView viewWithTag:3333].alpha = 0.3f;
                    }];
                }
                
                
            }];
            
        }
        else
        {
            [UIView animateWithDuration:0.5f animations:^{
                sender.view.frame = CGRectMake(0, sender.view.frame.origin.y, sender.view.frame.size.width, sender.view.frame.size.height);
            }completion:^(BOOL finished) {
                
                [self removeBlackViewWithFade];
                
            }];
            
        }
        
    }
}

- (void)doClickLeftBtn:(id)sender
{
    
    
    if (topView.frame.origin.x == 0)
    {
        [UIView animateWithDuration:0.3f animations:^{
            topView.frame = CGRectMake(RIGHTMARGIN, topView.frame.origin.y, topView.frame.size.width, topView.frame.size.height);
        }completion:^(BOOL finished) {
            if (![topView viewWithTag:3333]) {
                UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                             NAVIHEIGHT,
                                                                             topView.frame.size.width,
                                                                             topView.frame.size.height)];
                blackView.backgroundColor = [UIColor blackColor];
                blackView.alpha = 0.0;
                blackView.tag = 3333;
                [topView addSubview:blackView];
                [blackView release];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doClickLeftBtn:)];
                [blackView addGestureRecognizer:tap];
                [tap release];
                
                [UIView animateWithDuration:0.25f animations:^{
                    [topView viewWithTag:3333].alpha = 0.3f;
                }];
            }
        }];
    }
    else if (topView.frame.origin.x == RIGHTMARGIN)
    {
        [UIView animateWithDuration:0.3f animations:^{
            topView.frame = CGRectMake(0, topView.frame.origin.y, topView.frame.size.width, topView.frame.size.height);
        }completion:^(BOOL finished) {
            [self removeBlackViewWithFade];
        }];
    }
}
- (void)doClickRightBtn:(id)sender
{
    
    ETCalendarViewController *cal = [[ETCalendarViewController alloc] init];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:cal animated:YES];
    [cal release];
    
}


- (void)createMainViewByPresent:(BOOL)isPresent
{
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0/*isPresent ? 0 : (ios7 ? 20 : 0)*/, topView.frame.size.width, topView.frame.size.height)];
    bView.tag = 1111;
    [topView addSubview:bView];
    [bView release];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    UIImageView *topBackImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, navigationView.frame.size.width, navigationView.frame.size.height)];
    topBackImgV.image = [UIImage imageNamed:@"navBackGround.png"];
    [navigationView addSubview:topBackImgV];
    [topBackImgV release];
    
    for (int i = 0 ; i < 2; i++) {
        
        UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [navBtn setImage:[UIImage imageNamed:@"navLeftBtn_default.png"] forState:UIControlStateNormal];
            [navBtn setImage:[UIImage imageNamed:@"navLeftBtn_selected.png"] forState:UIControlStateHighlighted];
            [navBtn addTarget:self action:@selector(doClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [navBtn setImage:[UIImage imageNamed:@"navRightBtn_default.png"] forState:UIControlStateNormal];
            [navBtn setImage:[UIImage imageNamed:@"navRightBtn_selected.png"] forState:UIControlStateHighlighted];
            [navBtn addTarget:self action:@selector(doClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        [navBtn setFrame:CGRectMake(0, 0, 50, 35)];
        [navBtn setCenter:CGPointMake(10 + 34/2 + 266 *i, navigationView.frame.size.height/2)];
        [navigationView addSubview:navBtn];
        
    }
    
    // --------- 创建tabbar -------------
    
    ETClassViewController *classViewController=[[ETClassViewController alloc]init];
    ETNoticeViewController *noticeViewController=[[ETNoticeViewController alloc]init];
    ActivityViewController *activeVC = [[ActivityViewController alloc] init];
//    ETEducationViewController *infoVC = [[ETEducationViewController alloc] init];
//    ETSettingsViewController *infoVC = [[ETSettingsViewController alloc] init];
    ETChildViewController *infoVC = [[ETChildViewController alloc] init];

    NSArray *ctrlArr = [NSArray arrayWithObjects:classViewController,noticeViewController,activeVC,infoVC,nil];
    
    [classViewController release];
    [noticeViewController release];
    [activeVC release];
    [infoVC release];
    
    
    
    NSArray *imgArr = [NSArray arrayWithObjects:LOCAL(@"tb_classshare", @""),LOCAL(@"tb_notice", @""),LOCAL(@"tb_activity", @""),LOCAL(@"tb_mychild", @""),nil];
    LeveyTabBarController *lTBC=[[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr withFrame:CGRectMake(0, 46, 320, iphone5 ? (548 - 46) : (460 - 46))];
    
//    lTBC.selectedIndex = isPresent;
//    NSLog(@"%d",[leveyTBC retainCount]);
    [bView addSubview:lTBC.view];
    [lTBC release];
    
    self.leveyTBC = lTBC;
    
    
    [bView addSubview:navigationView];
    [navigationView release];
    
}

- (void)changeView:(UIButton *)button
{
    int num = button.tag % 4444;
    BOOL selected = button.selected;
    
    [UIView animateWithDuration:0.1f animations:^{
        
        if (num != 5) {
            topView.frame = CGRectMake(320, topView.frame.origin.y, topView.frame.size.width, topView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        
        if (!selected)
        {
            if ( num != 5 ) {
                
                [[topView viewWithTag:1111] removeFromSuperview];
                self.leveyTBC = nil;
                
//                [self removeBlackViewWithFade];
                
            }
            
            UIView *vc;
            switch (num)
            {
                case 0://我的账户
                {
                    vc = [[ETMyAccountView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           [UIScreen mainScreen].applicationFrame.size.width,
                                                                           [UIScreen mainScreen].applicationFrame.size.height)];
                    
//                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"userid",@"",@"channelid", nil];
//                    [[EKRequest Instance] EKHTTPRequest:push parameters:param requestMethod:POST forDelegate:self];
                    
                    
                    break;
                }
                case 1://食谱
                {
                    vc = [[ETFoodView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      [UIScreen mainScreen].applicationFrame.size.width,
                                                                      [UIScreen mainScreen].applicationFrame.size.height)];
                    break;
                }
                case 2://课程表
                {
                    vc = [[ETScheduleView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          [UIScreen mainScreen].applicationFrame.size.width,
                                                                          [UIScreen mainScreen].applicationFrame.size.height)];
                    break;
                }
                case 3://设置
                {
                    vc = [[ETSettingView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         [UIScreen mainScreen].applicationFrame.size.width,
                                                                         [UIScreen mainScreen].applicationFrame.size.height)];
                    break;
                }
                case 4://意见反馈
                {
                    vc = [[ETFeedbackView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          [UIScreen mainScreen].applicationFrame.size.width,
                                                                          [UIScreen mainScreen].applicationFrame.size.height)];
                    
                    break;
                }
//                case 4://给我评分
//                {
//                    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=600478283"];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
//                    return;
//                }
//                case 5://发现新版本
//                {
//                    [self checkVersion];
//                    return;
//                }
//                case 6://关于我们
//                {
//                    
//                    vc = [[ETAboutView alloc] initWithFrame:CGRectMake(0,
//                                                                       0,
//                                                                       [UIScreen mainScreen].applicationFrame.size.width,
//                                                                       [UIScreen mainScreen].applicationFrame.size.height)];
//                    
//                    break;
//                }
                case 5://退出登录
                {
                    
                    
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:LOCAL(@"logout", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"btm_logout", @""), nil];
                    alert.delegate=self;
                    alert.tag=LoginOutAlety;
                    [alert show];
                    
                    
                    
                    return;
                }
                case 9:
                {
                    [self createMainViewByPresent:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADBADGE" object:nil];
                    break;
                }
                default:
                    return;
                    
            }
            
            if (num != 9) {
                vc.tag = 1111;
                
                [topView addSubview:vc];
                [vc release];
            }
        }

        [UIView animateWithDuration:0.3f animations:^{
            
            [self removeBlackViewWithFade];
            topView.frame = CGRectMake(0, topView.frame.origin.y, topView.frame.size.width, topView.frame.size.height);
            
        } completion:^(BOOL finished) {
                
        }];
        

        
    }];
}

- (void)doClickBottomBtn:(UIButton *)sender
{
    NSLog(@"click bottom button");
    int btnNum = sender.tag % 4444;
    
    
    [self changeView:sender];
    
    for (id obj in self.view.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)obj;
            if (btnNum != 5)
            {
                if (btn.tag >= 4444 && btn.tag <= 5000)
                {
                    btn.selected = NO;
                }
            }
        }
    }
    
    if (btnNum != 5) {
        sender.selected = YES;
    }
    

    
    

}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(alertView.tag==PASSWordOrgin)
    {
        
        if(index==1)
        {
            ETChangeGestureViewController *gesVC = [[ETChangeGestureViewController alloc] init];
            [self.navigationController pushViewController:gesVC animated:YES];
            [gesVC release];
            
//            ETRePassWordViewController  *et=[[ETRePassWordViewController alloc]initWithNibName:@"ETRePassWordViewController" bundle:nil];
//            [self.navigationController pushViewController:et animated:YES];
//            [et release];
        }
        return;
    }

    if(alertView.tag==LoginOutAlety)
    {
        if (index == 0)
        {
            
        }
        else if (index == 1)
        {
            if(HUD==nil)
            {
                HUD=[[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:HUD];
                [HUD release];
                [HUD show:YES];
                
            }
            
            [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
            
        }
    }
    if(alertView.tag==VersionAlert)
    {
        if(index == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/yun-zhong-xiao-che-jia-zhang/id600478283?mt=8"]];
        }
    }

}


- (void)checkVersion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL * url=[NSURL URLWithString:LOCAL(@"checkversion", @"")];
        
        NSData *data=  [NSData dataWithContentsOfURL:url];
        // NSString *string=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if(data)
            {
                NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                // NSLog(@"dic=%@",dic);
                
                NSArray * array=[dic objectForKey:@"results"];
                if ([array count]==0||array==nil) {
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:NSLocalizedString(@"currentVersion", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    return;
                }
                NSString * verson=[[array objectAtIndex:0]objectForKey:@"version"];
                NSString *releaseNode=nil;
                releaseNode=[[array objectAtIndex:0]objectForKey:@"releaseNotes"];
                if(releaseNode==nil)
                    releaseNode=[[array objectAtIndex:0]objectForKey:@"description"];
                // NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                NSRange range=[verson rangeOfString:currentVersion];
                
                if(range.location==NSNotFound)
                {
                    
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:releaseNode delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"shengji", @""), nil];
                    alert.delegate=self;
                    alert.tag=VersionAlert;
                    [alert show];
                    
                    
                }
                else
                {
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:NSLocalizedString(@"currentVersion", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                
                
            }
            
        });
        // [self performSelectorOnMainThread:@selector(uploadUI:) withObject:string waitUntilDone:YES];
        // [string release];
        
        
    });
    
    
}


- (void)removeBlackViewWithFade
{
    if ([topView viewWithTag:3333]) {
        
        [UIView animateWithDuration:0.25f animations:^{
            [topView viewWithTag:3333].alpha = 0.0f;
        }completion:^(BOOL finished) {
            [[topView viewWithTag:3333] removeFromSuperview];
        }];
        
    }
}


- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (method == signin && code == 1) {
        [ETCommonClass logoutAndClearUserMessage];
    }
    
    NSLog(@"error code %d",code);
    NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    
}
- (void)getErrorInfo:(NSError *)error
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATEDATA" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CLOSEGESTURE" object:nil];
    
//    self.leveyTBC = nil;
    self.topView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{

    return NO;

}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

@end

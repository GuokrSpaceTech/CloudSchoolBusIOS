//
//  CBLoginViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBLoginViewController.h"
#import "Masonry.h"
#import "EKRequest.h"
#import "CBDateBase.h"
#import "CBLoginInfo.h"
#import "School.h"
#import "Student.h"
#import "Tag.h"
#import "AppDelegate.h"
#import "FindCellTopView.h"
#import "UIColor+RCColor.h"
#import "KLCPopup.h"
#import "Reachability.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CBLoginViewController ()<EKProtocol, UITextFieldDelegate>
{
    KLCPopup* popup;
}


@property (weak) NSTimer *repeatingTimer;
@property NSUInteger timerCount;
@property (nonatomic,strong) UIButton *codeButton;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic,strong) UILabel *labelStatusNotice;
@property (nonatomic,assign) BOOL isNetworkAvailable;


- (void)countedTimerAction:(NSTimer*)theTimer;

@end

CGFloat animatedDistance;

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Do any additional setup after loading the view from its nib.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"登录";
    
    _labelStatusNotice = [[UILabel alloc]init];
    _labelStatusNotice.text=@"";
    _labelStatusNotice.font = [UIFont boldSystemFontOfSize:16];
    _labelStatusNotice.textColor = [UIColor redColor];
    _labelStatusNotice.backgroundColor = [UIColor lightGrayColor];
    _labelStatusNotice.textAlignment = NSTextAlignmentCenter;
    _labelStatusNotice.hidden = true;
    [self.view addSubview:_labelStatusNotice];

    UIImageView * bgImageView = [[UIImageView alloc]init];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"login_background"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    bgImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.view addSubview:bgImageView];
    
    UIImage *imageLogo = [UIImage imageNamed:@"云中校车logo-1"];
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView setImage:imageLogo];
    [self.view addSubview: iconImageView];
    
    UIImage * imageapp = [UIImage imageNamed:@"name_tag"];
    UIImageView *imageappView = [[UIImageView alloc] init];
    [imageappView setImage:imageapp];
    [self.view addSubview: imageappView];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"云中校车";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor colorWithHexString:@"1E5268" alpha:1.0f];
    [self.view addSubview:label];
    
    UIView * phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    _usernameField = [[UITextField alloc]init];
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.placeholder = @"输入手机号";
    _usernameField.keyboardType = UIKeyboardTypeNumberPad;
    [_usernameField setDelegate:self];
    [self.view addSubview:_usernameField];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeButton setBackgroundColor:[UIColor colorWithHexString:@"6FC8EF" alpha:1.0f]];
    [_codeButton setTitle:@"  获取验证码  " forState:UIControlStateNormal];
    _codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[_codeButton layer] setCornerRadius:0.5f];
    [_codeButton setClipsToBounds:true];
    [self.view addSubview:_codeButton];
    
    UIView * passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    _passwordField = [[UITextField alloc]init];
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.placeholder = @"输入验证码";
    [_passwordField setDelegate:self];
    _passwordField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_passwordField];
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor whiteColor];
    [registerButton setTitle:@"登录" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithHexString:@"1E5268" alpha:1.0f] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(verifyUserAction:) forControlEvents:UIControlEventTouchUpInside];
    //[registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    [_labelStatusNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
    }];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(10);
    }];
    
    [imageappView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).offset(-5);
        make.left.equalTo(label.mas_right).offset(5);
    }];
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
        make.top.equalTo(label.mas_bottom).offset(20);;
    }];
    
    [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left).offset(5);
        make.top.equalTo(phoneView.mas_top);
        make.bottom.equalTo(phoneView.mas_bottom);
        make.right.equalTo(_codeButton.mas_left).offset(-10);
    }];
    
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneView.mas_right).offset(-5);
        make.top.equalTo(phoneView.mas_top).offset(5);
        make.bottom.equalTo(phoneView.mas_bottom).offset(-5);
    }];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
        make.top.equalTo(phoneView.mas_bottom).offset(5);;
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left).offset(5);
        make.top.equalTo(passwordView.mas_top);
        make.bottom.equalTo(passwordView.mas_bottom);
        make.right.equalTo(passwordView.mas_right).offset(-5);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
        make.top.equalTo(passwordView.mas_bottom).offset(20);;
    }];
    
    /*
     * Init the popup alert
     */
    
    
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.yunxiaoche.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(void)verifyUserAction:(id)sender
{
    if(_isNetworkAvailable)
    {
        if([_usernameField.text isEqualToString:@""])
        {
            return;
        }
        
        NSDictionary * dic = @{@"mobile":_usernameField.text,@"verifycode":_passwordField.text};
        [[EKRequest Instance] EKHTTPRequest:verify parameters:dic requestMethod:POST forDelegate:self];
        

    }
}
-(void)registerAction:(id)sender
{
    if(_isNetworkAvailable)
    {
        NSDictionary * dic = @{@"mobile":_usernameField.text};
        
        [[EKRequest Instance] EKHTTPRequest:REGISTER parameters:dic requestMethod:GET forDelegate:self];
        
        [_passwordField becomeFirstResponder];

    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - NETWORK REQUEST AND RESPONSE
-(void)getSid:(NSDictionary *)parm
{
    [[EKRequest Instance] EKHTTPRequest:login parameters:parm requestMethod:POST forDelegate:self];
}
-(void)getBaseInfo
{
    [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:self];
//    [[CBDateBase sharedDatabase] selectFormTableBaseinfo];
}

-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    if(method == baseinfo)
    {
        if(code == 1)
        {
            //Save baseinfo to DB
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response
                                                               options:(NSJSONWritingOptions) 0
                                                                 error:&error];
            
            if (!jsonData) {
                NSLog(@"Json Serilisation: error: %@", error.localizedDescription);
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [[CBDateBase sharedDatabase] insertDataToBaseInfoTableWithBaseinfo:jsonString];
            }
            
            NSDictionary * baseinfo = response;
            NSArray * schoolarr = baseinfo[@"schools"];
            for (int i = 0; i < schoolarr.count; i++) {
                NSDictionary * schooldic = schoolarr[i];
                School * school = [[School alloc]initWithSchoolDic:schooldic];
                [info.schoolArr addObject:school];
            }
            
            NSArray * stuArr = baseinfo[@"students"];
            for (int i=0; i<stuArr.count; i++) {
                Student * st = [[Student alloc]initWithDic:stuArr[i]];
                if(i == 0)
                {
                    info.currentStudentId = st.studentid;
                }
                [info.studentArr addObject:st];
            }
            
            info.state = LoginOn;
            //进入主页面
            
            AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate makeMainViewController];
        }
    }
    else if(method == login && [[param allKeys] containsObject:@"token"])
    {
        if(code == 1)
        {
            NSDictionary * dic = response;
            NSString * sid = dic[@"sid"];
            info.sid = sid;
            info.rongToken = dic[@"rongtoken"];
            // 获得基本信息
            
            [[CBDateBase sharedDatabase] insertDataToLoginInfoTable:@([info.userid intValue]) token:info.token phone:info.phone sid:info.sid rong:info.rongToken];
            //[[CBDateBase sharedDatabase] insertDataToLoginInfoTable:@(info.userid integerValue]) token:info.token phone:in];
            [[CBLoginInfo shareInstance] connectRongYun];
            [self getBaseInfo];
        }
        else
        {
            
        }
    }
    else if(method == verify && [[param allKeys] containsObject:@"verifycode"])
    {
        //手机校验
        if(code == -1118)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"校验码错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if(code == 1)
        {
            NSDictionary * result = response;
            info.token = result[@"token"];
            info.phone = _usernameField.text;
            info.userid = [NSString stringWithFormat:@"%@",result[@"userid"]];
         
            NSDictionary * dic = @{@"mobile":_usernameField.text,@"token":result[@"token"]};
            [self getSid:dic];
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"未知错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    else if(method == REGISTER)
    {
        //获取验证码
        if(code == -1117)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"手机未在学校登记" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertview show];
            [_usernameField becomeFirstResponder];
        }
        else if(code == 1)
        {
            //Kick off the timer
            self.timerCount = 30;
            self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                   target:self selector:@selector(countedTimerAction:) userInfo:nil repeats:YES];
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"未知登陆错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"未知登陆错误，请稍后再试" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertview show];}

#pragma mark - TIMER Handles

-(void)countedTimerAction:(NSTimer *)timer
{
    self.timerCount --;
    
    if(self.timerCount<=0)
    {
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setEnabled:true];
        [timer invalidate];
        self.repeatingTimer = nil;
        return;
    }
    
    NSString *timeLeftStr = [[NSString alloc] initWithFormat:@"      %02d秒      ",(int)_timerCount];
    [_codeButton setTitle:timeLeftStr forState:UIControlStateNormal];
    [_codeButton setEnabled:false];
    

}

#pragma mark - Softkey Up and hide handles

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 110,
                                 oldFrame.size.width, oldFrame.size.height);
    
    [self.view setFrame:newFrame];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 110,
                                 oldFrame.size.width, oldFrame.size.height);
    [self.view setFrame:newFrame];
}

#pragma mark Reachability
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"网络不可用", @"Network access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            _isNetworkAvailable = false;
            _labelStatusNotice.hidden = false;
            _labelStatusNotice.text= statusString;
            break;
        }
            
        case ReachableViaWWAN:        {
            _labelStatusNotice.hidden = true;
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            _isNetworkAvailable = true;
            break;
        }
        case ReachableViaWiFi:        {
            _labelStatusNotice.hidden = true;
            _isNetworkAvailable = true;
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
//    if (connectionRequired)
//    {
//        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
//        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
//    }
}


@end

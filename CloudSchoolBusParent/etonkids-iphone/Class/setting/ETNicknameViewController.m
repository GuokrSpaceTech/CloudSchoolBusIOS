//
//  ETNicknameViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETNicknameViewController.h"
#import "ETKids.h"
#import "Modify.h"
#import "UserLogin.h"
#import "NetWork.h"
#import "ETApi.h"
#import "GTMBase64.h"
#import "keyedArchiver.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ETCommonClass.h"
#import "ETCoreDataManager.h"

@interface ETNicknameViewController ()

@end

@implementation ETNicknameViewController
@synthesize nicknametextfield,delegate,originName;
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
    
    self.view.backgroundColor=[UIColor blackColor];
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, ios7 ? 20 : 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"Nickname",@"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    
    
    UserLogin *user = [UserLogin currentLogin];
    
    nicknametextfield.delegate=self;
    nicknametextfield.placeholder = user.nickname;
    self.originName = [NSString stringWithFormat:@"%@",user.nickname];
    nicknametextfield.keyboardType=UIKeyboardTypeNamePhonePad;
    
    [nicknametextfield becomeFirstResponder];
    [middleLabel release];
    
    
    clearBtn.frame = CGRectMake(clearBtn.frame.origin.x,
                                clearBtn.frame.origin.y + (ios7 ? 20 : 0),
                                clearBtn.frame.size.width,
                                clearBtn.frame.size.height);
    
    nicknametextfield.frame = CGRectMake(nicknametextfield.frame.origin.x,
                                         nicknametextfield.frame.origin.y + (ios7 ? 20 : 0),
                                         nicknametextfield.frame.size.width,
                                         nicknametextfield.frame.size.height);
    
    calculateLabel.frame = CGRectMake(calculateLabel.frame.origin.x,
                                      calculateLabel.frame.origin.y + (ios7 ? 20 : 0),
                                      calculateLabel.frame.size.width,
                                      calculateLabel.frame.size.height);
    
    textfieldImgBack.frame = CGRectMake(textfieldImgBack.frame.origin.x,
                                        textfieldImgBack.frame.origin.y + (ios7 ? 20 : 0),
                                        textfieldImgBack.frame.size.width,
                                        textfieldImgBack.frame.size.height);
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nicknametextfield];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldChanged:(NSNotification *)notification
{
    int length = [self textLength:nicknametextfield.text];
    if (length > LIMIT_NICKNAME) {
        
        //            self.nicknametextfield.text = [toString substringToIndex:LIMIT_NICKNAME];
        //            ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"limitChar", @"字符少于10个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil] ;
        //            [alert show];
        //            return NO;
        
        calculateLabel.textColor = [UIColor redColor];
        
    }
    else
    {
        calculateLabel.textColor = [UIColor blackColor];
    }
    
    calculateLabel.text = [NSString stringWithFormat:@"%d/20",length];
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//    if ([toBeString length] > 12) {
//        textField.text = [toBeString substringToIndex:12];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"limitChar", @"字符少于12个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return NO;
//    }
//    
//    return YES;
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        
        return NO;
        
    }
    NSString * toString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    
    
    if (self.nicknametextfield == textField)  //判断是否时我们想要限定的那个输入框
    {
        
        int length = [self textLength:toString];
        if (length > LIMIT_NICKNAME) {
            
//            self.nicknametextfield.text = [toString substringToIndex:LIMIT_NICKNAME];
//            ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"limitChar", @"字符少于10个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil] ;
//            [alert show];
//            return NO;
            
            calculateLabel.textColor = [UIColor redColor];
            
        }
        else
        {
            calculateLabel.textColor = [UIColor blackColor];
        }
        
        calculateLabel.text = [NSString stringWithFormat:@"%d/20",length];
    }
    
    return YES;
    
}
*/

- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
//        NSLog(@"%d",[character lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number+=2;
        }
        else
        {
            number++;
        }
    }
    return number;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nicknametextfield == textField)  //判断是否时我们想要限定的那个输入框
    {
        
        int length = [self textLength:textField.text];
        if (length > LIMIT_NICKNAME) {
            
            //            self.nicknametextfield.text = [toString substringToIndex:LIMIT_NICKNAME];
            //            ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"limitChar", @"字符少于10个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil] ;
            //            [alert show];
            //            return NO;
            
            calculateLabel.textColor = [UIColor redColor];
            
        }
        else
        {
            calculateLabel.textColor = [UIColor blackColor];
        }
        
        calculateLabel.text = [NSString stringWithFormat:@"%d/20",length];
    }
   [textField resignFirstResponder];
   return YES;
}
-(void)leftButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonClick:(UIButton*)sender
{
    [self.nicknametextfield resignFirstResponder];
    
    if ([self.originName isEqualToString:nicknametextfield.text])
    {
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"noChangeInfo", @"未修改信息") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    if(![NetWork connectedToNetWork])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        [self.view setNeedsLayout];
        return;
    }
    
    int length = [self textLength:nicknametextfield.text];
    if (length > LIMIT_NICKNAME) {
        
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"limitChar", @"字符少于10个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil] ;
        [alert show];
        
        return;
        
    }
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        nicknametextfield.text = [nicknametextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:nicknametextfield.text ,@"nikename",nil];
        [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
        
    }];
    
    
   
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(method == student)
    {
        if(code == 1)
        {
            //更新孩子信息
            @try
            {
                UserLogin * user = [UserLogin currentLogin];
                user.nickname = self.nicknametextfield.text;
                
                [ETCoreDataManager saveUser];
                
                NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
                [center postNotificationName:@"CHILDINFO" object:nil];
                
            }
            @catch (NSException *exception)
            {
                NSLog(@"exception:%@",exception.description);
            }
            
            NSLog(@"%@",LOCAL(@"success", @"信息修改成功"));
            
            if (delegate && [delegate respondsToSelector:@selector(changeNicknameSuccess)]) {
                [delegate changeNicknameSuccess];
            }
            
            
    
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"信息修改成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            [self.view setNeedsLayout];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self LoginFailedresult:LOCAL(@"fail",  @"信息修改失败,稍后请重试")];
        }
    }
    

}

#pragma EKRequest_Delegate
-(void)LoginFailedresult:(NSString *)str
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nicknametextfield];
     
    [nicknametextfield release];
    [calculateLabel release];
    [clearBtn release];
    [textfieldImgBack release];
    [super dealloc];
}
- (void)viewDidUnload {
    [nicknametextfield release];
    nicknametextfield = nil;
    [calculateLabel release];
    calculateLabel = nil;
    [clearBtn release];
    clearBtn = nil;
    [textfieldImgBack release];
    textfieldImgBack = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}

- (IBAction)clearText:(id)sender {
    
    self.nicknametextfield.text = @"";
    calculateLabel.text = [NSString stringWithFormat:@"0/20"];
    
}
@end

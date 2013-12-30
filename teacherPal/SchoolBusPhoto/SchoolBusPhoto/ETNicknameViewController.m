//
//  ETNicknameViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETNicknameViewController.h"

#import "GTMBase64.h"
#import "GKUserLogin.h"
#define LIMIT_NICKNAME 14
@interface ETNicknameViewController ()

@end

@implementation ETNicknameViewController
@synthesize nicknametextfield,delegate,originName,cstudent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    _BGView.frame=CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y);
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 5, 34, 35)];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];
    [leftButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"backH" ofType:@"png"];
    [leftButton setImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:leftButton];
    

  
    titlelabel.text=NSLocalizedString(@"NickName", @"");
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(270, 5, 50, 35)];
    
    
    NSString *OKpath = [[NSBundle mainBundle] pathForResource:@"OKBtn" ofType:@"png"];
    [leftButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    NSString *OKselpath1 = [[NSBundle mainBundle] pathForResource:@"OKBtn_sel" ofType:@"png"];
    
//    [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageWithContentsOfFile:OKpath] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageWithContentsOfFile:OKselpath1] forState:UIControlStateHighlighted];
    [navigationView addSubview:rightButton];
    
    
//    UserLogin *user = [UserLogin currentLogin];
    
    nicknametextfield.delegate=self;
    nicknametextfield.placeholder = cstudent.enname;
    self.originName = [NSString stringWithFormat:@"%@",cstudent.enname];
    nicknametextfield.keyboardType=UIKeyboardTypeNamePhonePad;
    [self.view bringSubviewToFront:nicknametextfield];
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
////    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
////    
////    if ([toBeString length] > 12) {
////        textField.text = [toBeString substringToIndex:12];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"limitChar", @"字符少于12个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
////        [alert show];
////        [alert release];
////        return NO;
////    }
////    
////    return YES;
//    
//    if ([string isEqualToString:@"\n"]) {
//        
//        [textField resignFirstResponder];
//        
//        return NO;
//        
//    }
//    NSString * toString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//    
//    
//    if (self.nicknametextfield == textField)  //判断是否时我们想要限定的那个输入框
//    {
//        
//        int length = [self textLength:toString];
////        if (length > 24) {
////            
//////            self.nicknametextfield.text = [toString substringToIndex:LIMIT_NICKNAME];
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"words", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil] ;
////            [alert show];
////            return NO;
////        }
//        
//        calculateLabel.text = [NSString stringWithFormat:@"%d/24",length];
//    }
//    
//    return YES;
//    
//}

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
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"change", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    int length = [self textLength:nicknametextfield.text];
    if (length > LIMIT_NICKNAME) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"limitChar", @"字符少于10个字") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil, nil] ;
        [alert show];
        [alert release];
        
        return;
        
    }
    
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:nicknametextfield.text,@"enname",self.cstudent.studentid,@"studentid",nil];
        [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
    
    
    
   
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    
    if (code == -1113)
    {
//        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
//        [com mutiDeviceLogin];
        
    }
    else if(method == student)
    {
        if(code == 1)
        {
            //更新孩子信息
            
            GKUserLogin *user=[GKUserLogin currentLogin];
            for (Student *s in user.studentArr) {
                if (s.studentid.intValue == cstudent.studentid.intValue) {
                    s.enname = [NSString stringWithFormat:@"%@",[parm objectForKey:@"enname"]];
                    break;
                }
            }
    
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"success", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
            
//            [self.view setNeedsLayout];
            
            if (delegate && [delegate respondsToSelector:@selector(changeNicknameSuccess)]) {
                [delegate changeNicknameSuccess];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self LoginFailedresult:NSLocalizedString(@"modification", @"")];
        }
    }
    

}

#pragma EKRequest_Delegate
-(void)LoginFailedresult:(NSString *)str
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"")message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}
-(void) getErrorInfo:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:NSLocalizedString(@"network", @"") waitUntilDone:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [nicknametextfield release];
    [calculateLabel release];
    [clearBtn release];
    [textfieldImgBack release];
    [_BGView release];
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
    [self setBGView:nil];
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
    
}
@end

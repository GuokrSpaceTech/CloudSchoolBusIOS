//
//  WriteCommentsViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "WriteCommentsViewController.h"
//#define NAVIHEIGHT 44
#import "ETKids.h"
#import "NetWork.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "AppDelegate.h"
@interface WriteCommentsViewController ()

@end

@implementation WriteCommentsViewController
@synthesize textview;
@synthesize sharecontent;
@synthesize itemid,commentId,popRoot,delegate;
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
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 + (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"replyComment", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    
    
    textV=[[UITextView alloc]initWithFrame:CGRectMake(10,NAVIHEIGHT + 10 + (ios7 ? 20 : 0), 300, 180)];
    textV.font=[UIFont systemFontOfSize:15];
    textV.delegate=self;
    textV.text=LOCAL(@"please", @"");
    textV.textColor = [UIColor grayColor];
    textV.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.95 alpha:1.0];
    textV.userInteractionEnabled=YES;
    [self.view addSubview:textV];
    [textV release];
    
    self.textview = textV;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:LOCAL(@"please", @"")])
    {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = LOCAL(@"please", @"");
        textView.textColor = [UIColor grayColor];
    }
}

/// 回车键textview回收键盘.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        
//        return NO;
//        
//    }
//    NSString * toString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    
//    if (self.textview == textView)  //判断是否时我们想要限定的那个输入框
//    {
//        int length = [self textLength:toString];
//        
//        if (length > LIMIT_COMMENT) { //如果输入框内容大于70则弹出警告
//            
////            self.textview.text = [toString substringToIndex:70];
//            ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//    }
    
    return YES;
}

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

-(void)leftButtonClick:(UIButton*)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];

}


/// 发送评论.
-(void)rightButtonClick:(UIButton*)sender
{
    [self.textview resignFirstResponder];
    
    int length = [self textLength:textV.text];
    if ([self.textview.text isEqualToString:@""] || [self.textview.text isEqualToString:LOCAL(@"please", @"")])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"empty", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (length > LIMIT_COMMENT)
    {
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.loginStatus==LOGIN_OFF)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil,nil];
            [alert show];
            
            return;
        }
//        if(![NetWork connectedToNetWork])
//        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
//            
//            [self.view setNeedsLayout];
//            return;
//        }
        

        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"article",@"itemtype",self.itemid,@"itemid",self.textview.text,@"content",self.commentId,@"reply",nil];
        
        if (delegate && [delegate respondsToSelector:@selector(replyCommentByParam:)]) {
            [delegate replyCommentByParam:param];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)dealloc
{
    [textview release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextview:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

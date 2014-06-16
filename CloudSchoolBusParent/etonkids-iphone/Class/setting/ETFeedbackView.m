//
//  ETFeedbackView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-27.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETFeedbackView.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "ETCommonClass.h"

@implementation ETFeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        middleLabel.text=LOCAL(@"feedback", @"");

        
        UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
        [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2)];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
        [self addSubview:rightButton];
        
        
        UIImageView *txtBack = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + NAVIHEIGHT, 291, 160)];
        txtBack.image = [UIImage imageNamed:@"SetingContent.png"];
        [self addSubview:txtBack];
        [txtBack release];
        
        feedbackTV = [[UITextView alloc] initWithFrame:CGRectMake(20, NAVIHEIGHT + 15, 280, 150)];
//        feedbackTV.backgroundColor = [UIColor redColor];
        feedbackTV.textColor = [UIColor grayColor];
        feedbackTV.text = LOCAL(@"feedbackPlaceholder", @"");
        feedbackTV.delegate = self;
        feedbackTV.font = [UIFont systemFontOfSize:15];
        [self addSubview:feedbackTV];
        [feedbackTV release];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipe];
        [swipe release];
        
        
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([feedbackTV.text isEqualToString:LOCAL(@"feedbackPlaceholder", @"")]) {
        feedbackTV.text = @"";
        feedbackTV.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([feedbackTV.text isEqualToString:@""]) {
        feedbackTV.textColor = [UIColor grayColor];
        feedbackTV.text = LOCAL(@"feedbackPlaceholder", @"");
    }
}
- (void)textViewDidChange:(UITextView *)textView
{

}

- (void)rightButtonClick:(UIButton *)sender
{
    
    if (feedbackTV.text == nil || [feedbackTV.text isEqualToString:@""] || [feedbackTV.text isEqualToString:LOCAL(@"feedbackPlaceholder", @"")]) {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(HUD==nil)
    {
//        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:self];
        [self addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    
    [self endEditing:YES];
    UserLogin *user=[UserLogin currentLogin];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"email", feedbackTV.text, @"content",user.studentId,@"studentid",nil];
    [[EKRequest Instance] EKHTTPRequest:feedback parameters:param requestMethod:POST forDelegate:self];
    
}

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
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
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
    else if (method == feedback) {
        
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
        
        NSString *msg;
        if(code == 1)
        {
            msg = LOCAL(@"success",  @"发送成功");
            feedbackTV.textColor = [UIColor grayColor];
            feedbackTV.text = LOCAL(@"feedbackPlaceholder", @"");
        }
        else
            msg =LOCAL(@"fail",  @"发送失败,稍后请重试");
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:msg delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        
    }
    
    
}






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

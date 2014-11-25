//
//  WriteCommentsViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "WriteCommentsViewController.h"
#import "KKNavigationController.h"
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    

    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];

    

    
    
    UIButton *sendbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendbutton.frame=CGRectMake(260, 3, 60, 44);
    [sendbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"sendNotice")) forState:UIControlStateNormal];
    [sendbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"sendNoticeH")) forState:UIControlStateHighlighted];
    
    sendbutton.tag=102;
    [sendbutton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:sendbutton];

    
//    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
//    [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
//    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:rightButton];
    
    
    textV=[[UITextView alloc]initWithFrame:CGRectMake(10,navigationView.frame.size.height+navigationView.frame.origin.y + 10, 300, 180)];
    textV.font=[UIFont systemFontOfSize:15];
   // textV.delegate=self;
    textV.text=NSLocalizedString(@"please", @"");
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
    if ([textView.text isEqualToString:NSLocalizedString(@"please", @"")])
    {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"please", @"");
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
    if ([self.textview.text isEqualToString:@""] || [self.textview.text isEqualToString:NSLocalizedString(@"please", @"")])
    {
//        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"empty", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//        [alert show];
        
    }
    else if (length > 70)
    {
//        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//        [alert show];
    }
    
    else
    {
//        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
//        if(user.loginStatus==LOGIN_OFF)
//        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil,nil];
//            [alert show];
//            
//            return;
//        }
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

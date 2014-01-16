//
//  GKNoticeViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-15.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKNoticeViewController.h"
#import "KKNavigationController.h"
#import <QuartzCore/QuartzCore.h>
@interface GKNoticeViewController ()

@end

@implementation GKNoticeViewController
@synthesize _textView;
@synthesize stuArr;
@synthesize upData;
@synthesize isConform;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didLongPressStudentButton:(GKButton *)button
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
//-(void)clickConformClick:(UIButton *)btn
//{
//    if(!isConform)
//    {
//        isConform=YES;
//        
//        //打钩
//        
//        [btn setImage:[UIImage imageNamed:@"duihaohuizhi.png"] forState:UIControlStateNormal];
//        
//    }
//    else
//    {
//        [btn setImage:nil forState:UIControlStateNormal];
//        isConform=NO;
//    }
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isConform=NO;
    stuArr=[[NSMutableArray alloc]init];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height)];
    bgView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
    [self.view addSubview:bgView];
    [bgView release];
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, navigationView.frame.size.height+navigationView.frame.origin.y+5, 300, 120)];
    [self.view addSubview:_textView];
	// Do any additional setup after loading the view.
    _textView.delegate=self;
    _textView.text=@"";
    _textView.layer.cornerRadius=5;
    _textView.font=[UIFont systemFontOfSize:16];
    [_textView becomeFirstResponder];
    
    numberWord =[[UILabel alloc]initWithFrame:CGRectMake(10 , _textView.frame.size.height+_textView.frame.origin.y+5, 100, 20)];
    numberWord.text=@"";
    numberWord.backgroundColor=[UIColor clearColor];
    numberWord.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:numberWord];
    [numberWord release];
    //"check"="如需家长确认，请勾选。";
//    UILabel *  huizhiLabel =[[UILabel alloc]initWithFrame:CGRectMake(180 , _textView.frame.size.height+_textView.frame.origin.y+5, 120, 40)];
//    huizhiLabel.numberOfLines=2;
//    //huizhiLabel.text="该通知需要家长确认吗？"";
//    huizhiLabel.text=NSLocalizedString(@"check", @"");
//    huizhiLabel.backgroundColor=[UIColor clearColor];
//    huizhiLabel.textColor=[UIColor redColor];
//    huizhiLabel.font=[UIFont systemFontOfSize:14];
//    [self.view addSubview:huizhiLabel];
//    [huizhiLabel release];
//    
//    
//    UIButton * confromButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [confromButton setBackgroundImage:[UIImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
//    confromButton.frame=CGRectMake(150,  _textView.frame.size.height+_textView.frame.origin.y+15, 20, 20);
//    [confromButton addTarget:self action:@selector(clickConformClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confromButton];
    
    
    inputView=[[UIView alloc]initWithFrame:CGRectMake(0,_textView.frame.size.height+_textView.frame.origin.y, 320, 40)];
    
    UIImageView *tiaoview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    tiaoview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tiao" ofType:@"png"]];
    [inputView addSubview:tiaoview];
    [tiaoview release];
    selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    selectImageView.backgroundColor=[UIColor clearColor];
    [inputView addSubview:selectImageView];
    [selectImageView release];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
   // [button setTitle:@"选择学生" forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"addPerH")) forState:UIControlStateNormal];
      [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"addPer")) forState:UIControlStateHighlighted];
    button.frame=CGRectMake(205, 3, 43, 33);
    button.tag=100;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:button];
    
    UIButton *buttonPhoto=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonPhoto setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"addPic")) forState:UIControlStateNormal];
    [buttonPhoto setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"addPicH"))forState:UIControlStateHighlighted];

    buttonPhoto.frame=CGRectMake(260, 3, 43, 33);
    buttonPhoto.tag=101;
    [buttonPhoto addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:buttonPhoto];
    
    inputView.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:inputView];
    _textView.inputAccessoryView=inputView;
    [inputView release];
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
   // sendNoticeH.png
    UIButton *sendbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendbutton.frame=CGRectMake(260, 3, 60, 44);
    [sendbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"sendNotice")) forState:UIControlStateNormal];
    [sendbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"sendNoticeH")) forState:UIControlStateHighlighted];

    sendbutton.tag=102;
    [sendbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:sendbutton];

   // [_textView becomeFirstResponder];
    
    
   
    
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    int col=([user.studentArr count] )/4; //行
    //int row=([user.studentArr count] )%4;
    int y = MIN(col+1, 4);
    if (studentView == nil) {
        studentView=[[GKStudentView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-( y*50), 320,( y*50))];
        
        studentView.backgroundColor=[UIColor whiteColor];
        studentView.delegate=self;
        [self.view addSubview:studentView];
        [studentView release];
    }
    
    studentView.studentArr=user.studentArr;

    
    UIView *whiteView=[[UIView alloc] initWithFrame:CGRectMake(0,studentView.frame.origin.y-10, 320, 10)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView release];
    
    titlelabel.text=NSLocalizedString(@"homenoticetitle", @"");
    
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
- (void)textViewDidChange:(UITextView *)textView
{
    int cout=[self textLength:textView.text];
    numberWord.text=[NSString stringWithFormat:@"已输入%d字",cout];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *theImage;
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
     NSData *data= UIImageJPEGRepresentation(theImage, 0.5);
    
    self.upData=data;
    selectImageView.image=[UIImage imageWithData:data];
    [_textView becomeFirstResponder];
}

-(void)whitchSelected:(BOOL)selected uid:(NSString *)uid isAll:(int)an
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    if (an == 1)  // 选择全部
    {

       [stuArr removeAllObjects];
                              
       for (int i=0; i<[user.studentArr count]; i++) {
           Student *st=[user.studentArr objectAtIndex:i];
           [stuArr addObject:[NSString stringWithFormat:@"%@",st.studentid]];
       }
    }

    else if(an==0)
    {
        if([stuArr containsObject:uid])
        {
            [stuArr removeObject:uid];
        }
        else
        {
            [stuArr addObject:uid];
        }
    }
    else if(an==2)
    {
        [stuArr removeAllObjects];
    }

    
    

    NSLog(@"%@",stuArr);
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)leftClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    GKMainViewController *main=[GKMainViewController share];
//    if(main.state==0)
//    {
//
//    }
//    else
//    {
//        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
//            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
//            _textView.editable=YES;
//            [_textView becomeFirstResponder];
//        }
//    }
//
//}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101)
    {
        if (buttonIndex == 0) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"nosupport", @"")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                [alert show];
                
                
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSString *studentID=[self selectStudentID];
    
    NSString *key=[self createKey];
    NSString *createT=[self creattime];
    
    NSString *title=nil;
    if([_textView.text length]>10)
    {
        title=[_textView.text substringToIndex:10];
    }
    else
    {
        title=_textView.text;
    }
    
  
    if(self.upData)
    {
        NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:self.upData] encoding:NSUTF8StringEncoding];
        NSDictionary *picdic=[NSDictionary dictionaryWithObjectsAndKeys:key,@"pickey",[self getFileName:0],@"fname",[self numberSize:self.upData],@"fsize",base64,@"fbody",@"jpg",@"fext",@"notice",@"pictype", nil];
        NSLog(@"%@",picdic);
        
        [[EKRequest Instance]EKHTTPRequest:pic parameters:picdic requestMethod:POST forDelegate:self];
        [base64 release];
        
    }
    
    
    if(buttonIndex==0)
    {
        // 不确认
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:title,@"title",_textView.text,@"content",@"",@"createrid",studentID,@"slist",key,@"noticekey",createT,@"createtime",@"0",@"isconfirm", nil];
        [[EKRequest Instance]EKHTTPRequest:tnotice parameters:dic requestMethod:POST forDelegate:self];

    }
    if(buttonIndex==1)
    {
        // 确认
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:title,@"title",_textView.text,@"content",@"",@"createrid",studentID,@"slist",key,@"noticekey",createT,@"createtime",@"1",@"isconfirm", nil];
        [[EKRequest Instance]EKHTTPRequest:tnotice parameters:dic requestMethod:POST forDelegate:self];

    }
}
-(void)buttonClick:(UIButton *)btn
{
    if(btn.tag==100)
    {
        [_textView resignFirstResponder];
    }
    if(btn.tag==101)
    {
        
      //  NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choose", @"")
        
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"pic", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"")destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choose", @""), nil];
        [action showInView:self.view];
        action.tag=101;
        [action release];

        
    }
    if(btn.tag==102)
    {
        //发送、
        
       
        if([_textView.text isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;

        }
        if([stuArr count]==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"selectstuent", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        


        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"该通知需要家长确认吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"yes", @""), nil];
        [alertView show];
        [alertView release];
        


    }
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    
    NSLog(@"%d",code);
    if(code==1&&method==tnotice)
    {
        _textView.text=@"";
        [studentView setAllButtonSelect:NO];
        [stuArr removeAllObjects];
        
        numberWord.text=@"";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"sendsucess", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if(method==tnotice)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"sendfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    if(code==1 && method==pic)
    {
        self.upData=nil;
        selectImageView.image=nil;
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"sendfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(NSNumber *)numberSize:(NSData *)data
{
    NSLog(@"%lu",(unsigned long)[data length])  ;
    
    float aa=[data length]/1024.0;
    
    NSLog(@"%f",aa);
    return [NSNumber numberWithFloat:aa];;
    
}
-(NSString *)getFileName:(int)a
{
    NSDate *date=[NSDate date];
    NSTimeInterval time= [date timeIntervalSince1970];
    NSString *temp=[NSString stringWithFormat:@"%f",time];
    int x = arc4random() % 1000;
    int y = arc4random() % 1000;
    temp= [temp substringToIndex:10];
    NSString *string=[NSString stringWithFormat:@"%@%d%d%d",temp,x,y,a];
    
    return string;
    
}
-(NSString *)creattime
{
    NSDate *date=[NSDate date];
    NSTimeInterval time= [date timeIntervalSince1970];
    
    NSString *string=[NSString stringWithFormat:@"%f",time];
    string=[string substringToIndex:10];
    return string;
}
-(NSString *)createKey
{
    NSDate *date=[NSDate date];
    NSTimeInterval time= [date timeIntervalSince1970];
    NSString *temp=[NSString stringWithFormat:@"%f",time];
    int x = arc4random() % 1000;
    temp= [temp substringToIndex:10];
    NSString *string=[NSString stringWithFormat:@"%@%d",temp,x];
    
    return string;
    
}
-(NSMutableString *)selectStudentID
{
    NSMutableString *temp=[[NSMutableString alloc]init];
    
    for (int i=0; i<[stuArr count]; i++) {
        
        [temp appendFormat:@"%@,",[stuArr objectAtIndex:i]];
        
    }
    
    [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1)];
    
    NSLog(@"%@",temp);
    return [temp autorelease];
    
}
-(void)dealloc
{
    self._textView=nil;
    self.upData=nil;
    self.stuArr=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

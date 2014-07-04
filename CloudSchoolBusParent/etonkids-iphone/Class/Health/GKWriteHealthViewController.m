//
//  GKWriteHealthViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKWriteHealthViewController.h"
#import "ETKids.h"
#import "ASIFormDataRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserLogin.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
@interface GKWriteHealthViewController ()

@end

@implementation GKWriteHealthViewController
@synthesize _textView;
@synthesize sexLabel;
@synthesize _textField;
@synthesize keshilabel;
@synthesize delegate;
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
    // Do any additional setup after loading the view.

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
    
    
    
    self.sex=@"男";
    keshinumber=2;
    self.keshi=@"儿科";
    
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
    middleLabel.text = @"医生咨询";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  //  [rightButton setTitle:@"对号" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    
    
    
    
    _scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT)];
    [self.view addSubview:_scroller];
    [_scroller release];
    
    UIImageView *BGView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 15, 305, 143)];
    // cell.backgroundView=BGView;
    BGView.backgroundColor=[UIColor clearColor];
    BGView.image=[UIImage imageNamed:@"health_write_input.png"];
    [_scroller addSubview:BGView];
    [BGView release];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(7, 15, 305, 143)];
    
    // _textView.text=@"请您尽可能详细的描述";
    _textView.delegate=self;
    _textView.backgroundColor=[UIColor clearColor];
    _textView.tag=100;
    [_scroller addSubview:_textView];



    
    UIImageView *topView=[[UIImageView alloc]initWithFrame:CGRectMake(7, BGView.frame.size.height+BGView.frame.origin.y + 15, 305, 44)];
    topView.userInteractionEnabled=YES;
    topView.tag=3000;
    topView.image=[UIImage imageNamed:@"health_write_top.png"];
    topView.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:topView];
    [topView release];
    
    
    UITapGestureRecognizer *taptop=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    taptop.numberOfTapsRequired=1;
    [topView addGestureRecognizer:taptop];
    [taptop release];
    
    
    UILabel *_sexlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, BGView.frame.size.height+BGView.frame.origin.y + 15+12, 100, 20)];
    _sexlabel.text=@"性别";
    _sexlabel.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:_sexlabel];
    [_sexlabel release];

    sexLabel =[[UILabel alloc]initWithFrame:CGRectMake(200, _sexlabel.frame.origin.y, 100, 20)];
    sexLabel.text=@"男";
    sexLabel.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:sexLabel];

    UIImageView *arrowIamge=[[UIImageView alloc]initWithFrame:CGRectMake(305-19, BGView.frame.size.height+BGView.frame.origin.y + 15 + 15, 9, 15)];
    arrowIamge.image=[UIImage imageNamed:@"health_arrow.png"];
    arrowIamge.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:arrowIamge];
    [arrowIamge release];
    
    
    NSArray *labelArr=[NSArray arrayWithObjects:@"年龄",@"科室", nil];
    
    //health_arrow
    for (int i=0; i<2; i++) {
        UIImageView *midile=[[UIImageView alloc]initWithFrame:CGRectMake(7, topView.frame.size.height+topView.frame.origin.y+i*44, 305, 44)];
        midile.userInteractionEnabled=YES;
        midile.tag=i+3001;
        midile.image=[UIImage imageNamed:@"health_middle.png"];
        midile.backgroundColor=[UIColor clearColor];
        [_scroller addSubview:midile];
        [midile release];
        
        
        UITapGestureRecognizer *tapniddle=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tapniddle.numberOfTapsRequired=1;
        [midile addGestureRecognizer:tapniddle];
        [tapniddle release];
        
        
        UIImageView *arrowIamge=[[UIImageView alloc]initWithFrame:CGRectMake(305-19, topView.frame.size.height+topView.frame.origin.y+i*44 + 15, 9, 15)];
        arrowIamge.image=[UIImage imageNamed:@"health_arrow.png"];
        arrowIamge.backgroundColor=[UIColor clearColor];
        [_scroller addSubview:arrowIamge];
        [arrowIamge release];
        
        UILabel *templabel=[[UILabel alloc]initWithFrame:CGRectMake(20, topView.frame.size.height+topView.frame.origin.y+i*44 + 12, 100, 20)];
        templabel.text=[labelArr objectAtIndex:i];
        templabel.backgroundColor=[UIColor clearColor];
        [_scroller addSubview:templabel];
        [templabel release];
    }
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(150, topView.frame.size.height+topView.frame.origin.y +8, 100, 30)];
    _textField.text=@"";
    _textField.placeholder=@"年龄";
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.delegate=self;
    _textField.keyboardType=UIKeyboardTypeNumberPad;
    [_scroller addSubview:_textField];
    
    
    keshilabel =[[UILabel alloc]initWithFrame:CGRectMake(200, topView.frame.size.height+topView.frame.origin.y+44+12, 100, 20)];
    keshilabel.text=self.keshi;
    keshilabel.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:keshilabel];
    

    
    UIImageView *bottomView=[[UIImageView alloc]initWithFrame:CGRectMake(7, topView.frame.size.height+topView.frame.origin.y+2*44, 305, 305/2.0f)];
    bottomView.userInteractionEnabled=YES;
    bottomView.tag=3003;
    bottomView.image=[UIImage imageNamed:@"health_write_bottom.png"];
    bottomView.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:bottomView];
    [bottomView release];
    
    UITapGestureRecognizer *tapbottom=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tapbottom.numberOfTapsRequired=1;
    [bottomView addGestureRecognizer:tapbottom];
    [tapbottom release];
    
    
    UIImageView *arrowIamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(305-19, bottomView.frame.origin.y + 65, 9, 15)];
    arrowIamgeView.image=[UIImage imageNamed:@"health_arrow.png"];
    arrowIamgeView.backgroundColor=[UIColor clearColor];
    [_scroller addSubview:arrowIamgeView];
    [arrowIamgeView release];
    
    photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(bottomView.frame.origin.x+20, bottomView.frame.origin.y+10, 110, 125)];
    photoImageView.image=[UIImage imageNamed:@"health_uppic.png"];
    //photoImageView.backgroundColor=[UIColor grayColor];
    [_scroller addSubview:photoImageView];
    [photoImageView release];
    
    
    deleteImageView=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteImageView.frame=CGRectMake(bottomView.frame.origin.x+20+125+50, bottomView.frame.origin.y+10 + 45 , 34, 34);
    deleteImageView.hidden=YES;
    [deleteImageView setBackgroundImage:[UIImage imageNamed:@"health_write_delete.png"] forState:UIControlStateNormal];
    [deleteImageView addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_scroller addSubview:deleteImageView];
    
    
    
    _scroller.contentSize=CGSizeMake(_scroller.frame.size.width, bottomView.frame.size.height+bottomView.frame.origin.y +100);
    

}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    UIImageView *imageView=(UIImageView *)tap.view;
    int tag=imageView.tag;
    
    if(tag==3000)
    {
        //性别
        
        UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:LOCAL(@"Gender",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"prince",@""),LOCAL(@"Princess",@""), nil];
        [aa showInView:self.view];
        aa.tag = 102;
        [aa release];
    }
    if(tag==3001)
    {
        //年龄
    }
    if(tag==3002)
    {
        //科室
        UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:@"科室" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"妇产科",@"儿科",@"内科",@"皮肤性病科",@"内分泌科",@"营养科",@"骨科",@"男性泌尿科",@"外科",@"心血管科脑神经科",@"肿瘤科",@"中医科",@"口腔科",@"耳鼻喉科",@"眼科",@"整形美容科",@"心理科",@"脑神经科", nil];
        [aa showInView:self.view];
        aa.tag=103;
        [aa release];
    }
    if(tag==3003)
    {
        //图片
        
        UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:LOCAL(@"changeavadar",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") , nil];
        [aa showInView:self.view];
        aa.tag = 101;
        [aa release];
    }
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
-(void)rightButtonClick:(UIButton *)btn
{
    
    
    if([_textField.text isEqualToString:@""] || [_textView.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"确定") message:LOCAL(@"input", @"确定") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

        return;
    }
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
    
    if(self.photoImage)
    {
        //NSLog(@"%@",jsonstr);
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://yzxc.summer2.chunyu.me/files/upload"]];
       // NSData *dataa=UIImageJPEGRepresentation(_photoImage, 0.5);
        
        [request setPostValue:@"image" forKey:@"type"];
        [request addData:self.photoImage forKey:@"file"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(urlRequestFailed:)];
        [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"pic",@"pic", nil]];
       // [request buildRequestHeaders];
        [request startAsynchronous];
    }
    else
    {
        [self createProblem:@""];
    }

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)createProblem:(NSString *)url
{
    UserLogin *user=[UserLogin currentLogin];
    
    
    int time= [[NSDate date] timeIntervalSince1970];
    
    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,user.username,@"testchunyu"];
    
    NSString *sign=[self md5:string];

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",_textView.text,@"text", nil];
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"patient_meta",@"type",_textField.text,@"age",self.sex,@"sex", nil];
    
    NSArray *arr=nil;
    if(![url isEqualToString:@""])
    {
        NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",url,@"file", nil];
        arr=[NSArray arrayWithObjects:dic,dic1,dic3, nil];
    }
    else
    {
        arr=[NSArray arrayWithObjects:dic,dic1, nil];
    }
    
    NSData *jsondate=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstr=[[NSString alloc]initWithData:jsondate encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonstr);
    ASIFormDataRequest *resuest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem/create"]];
    [resuest setPostValue:user.username forKey:@"user_id"];
    
    [resuest setPostValue:jsonstr forKey:@"content"];
    [resuest setPostValue:sign forKey:@"sign"];
 
    [resuest setPostValue:[NSString stringWithFormat:@"%d",keshinumber] forKey:@"clinic_no"];
   
    [resuest setPostValue:[NSString stringWithFormat:@"%d",time] forKey:@"atime"];
    [resuest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"nopic",@"pic", nil]];
    [resuest setDelegate:self];
    //配置代理为本类
    [resuest setTimeOutSeconds:10];
    //设置超时
    [resuest setDidFailSelector:@selector(urlRequestFailed:)];
    [resuest setDidFinishSelector:@selector(urlRequestSucceeded:)];
    
    [resuest startAsynchronous];

}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"%@",request.error.description);
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];

    
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request
{
  //  NSLog(@"%@",request.responseData);
    
    NSString * key=[[request userInfo] objectForKey:@"pic"];
    if([key isEqualToString:@"pic"])
    {
        NSDictionary *dic= [NSJSONSerialization  JSONObjectWithData:request.responseData options:0 error:nil];
        NSString *url=[dic objectForKey:@"file"];
        
        
        [self createProblem:url];
    }
    else
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
        NSDictionary *dic= [NSJSONSerialization  JSONObjectWithData:request.responseData options:0 error:nil];
        NSString *error=[NSString stringWithFormat:@"%@",[dic objectForKey:@"error"]];
        if([error integerValue]==0)
        {
            
            NSLog(@"%@",[dic objectForKey:@"problem_id"]);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"创建成功" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [delegate refreshDetailVC];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"创建失败" message:[dic objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _scroller.contentOffset=CGPointMake(0, 100);
}


-(void)deletePhoto:(UIButton *)btn
{
    self.photoImage=nil;
        photoImageView.image=[UIImage imageNamed:@"health_uppic.png"];
    deleteImageView.hidden=YES;
}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101)
    {
        if (buttonIndex == 0) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
                [alert show];
                
                
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            
            AppDelegate *appDel = SHARED_APP_DELEGATE;
            [appDel.bottomNav presentModalViewController:picker animated:YES];
            [picker release];
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            
            AppDelegate *appDel = SHARED_APP_DELEGATE;
            [appDel.bottomNav presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
    else if (actionSheet.tag == 102)
    {
        if(buttonIndex==0)
        {
            self.sex=@"男";
            sexLabel.text=@"男";
        }
        if(buttonIndex==1)
        {
            self.sex=@"女";
             sexLabel.text=@"女";
        }
    
      
    }
    else if (actionSheet.tag == 103)
    {
        if(buttonIndex==18)
        {
            NSLog(@"aa");
        }
        else
        {
            NSArray *arr=[NSArray arrayWithObjects:@"妇产科",@"儿科",@"内科",@"皮肤性病科",@"内分泌科",@"营养科",@"骨科",@"男性泌尿科",@"外科",@"心血管科脑神经科",@"肿瘤科",@"中医科",@"口腔科",@"耳鼻喉科",@"眼科",@"整形美容科",@"心理科",@"脑神经科", nil];
            
            self.keshi=[arr objectAtIndex:buttonIndex];
            
            keshinumber=buttonIndex+1;
            keshilabel.text=[arr objectAtIndex:buttonIndex];
            
        }
   
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%@",info);
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  //  self.photoImage=image;
    //[_tableView reloadData];

    //deleteImageView.hidden=NO;
    
    NSData *dataa=UIImageJPEGRepresentation(image, 0.4);
  //  self.photoImage=image;
    
    
    self.photoImage=dataa;

    photoImageView.image=[UIImage imageWithData:dataa scale:0.5];
    
    if(self.photoImage)
    {
        deleteImageView.hidden=NO;
    }
  //  [_tableView reloadData];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}



-(void)dealloc
{

    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    self.tableView=nil;
    //self.labelArr=nil;
    self.photoImage=nil;
    self.sex=nil;
    self.keshi=nil;
    self.age=nil;
    self._textView=nil;
    self.sexLabel=nil;
    self._textField=nil;
    self.keshilabel=nil;
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

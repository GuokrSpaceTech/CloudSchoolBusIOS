//
//  GKHealthDetaiViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKHealthDetaiViewController.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "UserLogin.h"
#import <CommonCrypto/CommonDigest.h>
#import "ETPraiseViewController.h"
#import "ProblemDetail.h"
#import "ProblemContent.h"
#import "CYDoctorViewController.h"
#import "UIImageView+WebCache.h"
#import "ETPraiseViewController.h"
@interface GKHealthDetaiViewController ()

@end

@implementation GKHealthDetaiViewController
@synthesize _slimeView;
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
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)keyboarChange:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect1=[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    
    NSLog(@"%f---%f",rect1.size.width,rect1.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
        __tableView.frame= CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40-rect.size.height);

        if([_answerList count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_answerList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        
    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-57, 320, 57);
        __tableView.frame= CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40);
        if([_answerList count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_answerList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    
}
-(void)keyboarShow:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);

        __tableView.frame= CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40-rect.size.height);
        if([_answerList count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_answerList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }];
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[inputField11 resignFirstResponder];
    [inputField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
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
    middleLabel.text = NSLocalizedString(@"doctor_tiwendetail", @"提问详情");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    

    _answerList=[[NSMutableArray alloc]init];
    
    __tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40) style:UITableViewStylePlain];
    __tableView.backgroundView = nil;
    __tableView.backgroundColor = CELLCOLOR;
    __tableView.delegate = self;
    __tableView.dataSource = self;
    __tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:__tableView];
    

    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor blackColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    [__tableView addSubview:self._slimeView];

    
    [self loadAnswer];
    
    // [imageView];
  

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [self loadUI];
    [__tableView reloadData];
}
-(void)loadUI
{

    
    
    
        __tableView.tableFooterView=nil;
        if(![_problem.status isEqualToString:@"n"] &&![_problem.status isEqualToString:@"d"] && ![_problem.status isEqualToString:@"c"])
        {
            UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
            footView.backgroundColor=[UIColor clearColor];
            UILabel *pingjialabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
            pingjialabel.text=NSLocalizedString(@"doctor_solve", @"");
            pingjialabel.font=[UIFont systemFontOfSize:12];
            pingjialabel.backgroundColor=[UIColor clearColor];
            pingjialabel.textColor=[UIColor blueColor];
            [footView addSubview:pingjialabel];
            [pingjialabel release];
            
            
            UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseClick:)];
            tapClick.numberOfTapsRequired=1;
            pingjialabel.userInteractionEnabled=YES;
            [pingjialabel addGestureRecognizer:tapClick];
            [tapClick release];
            
            
            UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(10, 35, 300, 40)];
            contentView.backgroundColor=[UIColor whiteColor];
            [footView addSubview:contentView];
            [contentView release];
            
            UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 35, 290, 40)];
            contentLabel.text=NSLocalizedString(@"doctor_content", @"");
            contentLabel.font=[UIFont systemFontOfSize:12];
            contentLabel.numberOfLines=0;
            contentLabel.backgroundColor=[UIColor clearColor];
            contentLabel.textColor=[UIColor grayColor];
            [footView addSubview:contentLabel];
            [contentLabel release];
            __tableView.tableFooterView=footView;
            [footView release];
        }
        
    
    [inputView removeFromSuperview];
    inputView=nil;
    
        inputView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-57, 320, 57)];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
        imageView.image=[UIImage imageNamed:@"inputBG.png"];
        [inputView addSubview:imageView];
        [imageView release];
        
        if([_problem.status isEqualToString:@"c"])
        {
            
            
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(50, 10, 220, 37);
            [btn setTitle:NSLocalizedString(@"problem_solved", @"") forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"health_pingjia_btn.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
//            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
//            label.text=@"请评论";
//            label.textColor=[UIColor whiteColor];
//            if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
//                label.textAlignment=NSTextAlignmentCenter;
//            else
//                label.textAlignment=UITextAlignmentCenter;
            [inputView addSubview:btn];
          //  [label release];
            
        }
        else if([_problem.status isEqualToString:@"d"])
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
            label.text=NSLocalizedString(@"problem_closed", @"");
            label.textColor=[UIColor whiteColor];
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
                label.textAlignment=NSTextAlignmentCenter;
            else
                label.textAlignment=UITextAlignmentCenter;
            [inputView addSubview:label];
            [label release];
        }
        else
        {
            inputField=[[UITextField alloc]initWithFrame:CGRectMake(57, 15, 180, 27)];
            inputField.borderStyle=UITextBorderStyleRoundedRect;
            inputField.delegate=self;
            inputField.placeholder=NSLocalizedString(@"ask", @"");
            [inputView addSubview:inputField];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15, 13, 32, 32);
            [button setBackgroundImage:[UIImage imageNamed:@"pic-1.png"]forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"pic-1.png"] forState:UIControlStateHighlighted];
            button.titleLabel.font=[UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(picClick:) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:button];
            
            UIButton *upbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            upbutton.frame=CGRectMake(250, 13, 64, 30);
            [upbutton setTitle:NSLocalizedString(@"send", @"") forState:UIControlStateNormal];
            upbutton.titleLabel.font=[UIFont systemFontOfSize:12];
            [upbutton setBackgroundImage:[UIImage imageNamed:@"send_23.png"] forState:UIControlStateNormal];
            [upbutton setBackgroundImage:[UIImage imageNamed:@"send_24.png"] forState:UIControlStateHighlighted];
            [upbutton addTarget:self action:@selector(upClick:) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:upbutton];
            
        }
        
        
        
        
        
        [self.view addSubview:inputView];
        [inputView release];

   
}
-(void)praiseClick:(UIGestureRecognizer *)tap
{
    ETPraiseViewController *praiseVC=[[ETPraiseViewController alloc]init];
    praiseVC.problem=self.problem;
    praiseVC.delegate=self;
    [self.navigationController pushViewController:praiseVC animated:YES];
    [praiseVC release];
}
-(void)pingjia:(UIButton *)btn
{
    ETPraiseViewController *praiseVC=[[ETPraiseViewController alloc]init];
    praiseVC.problem=self.problem;
    praiseVC.delegate=self;
    [self.navigationController pushViewController:praiseVC animated:YES];
    [praiseVC release];
}
-(void)reloadDetailVC
{
    self.problem.status=@"d";
    [self loadUI];
}
-(void)loadAnswer
{
   // clinic_erke_lihuiling
    
    //测试问题详情
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
    
    NSString *urlstr=[NSString stringWithFormat:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem/%@/detail",self.problem.problemId];
    
  //  NSString *urlstr=[NSString stringWithFormat:@"http://yzxc.summer2.chunyu.me/partner/yzxc/doctor/%@/detail",@"clinic_erke_lihuiling"];
    UserLogin *user=[UserLogin currentLogin];
    ASIFormDataRequest *resuest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [resuest setPostValue:user.username forKey:@"user_id"];
    // [resuest set];
    [resuest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"data",@"pic", nil]];
    [resuest setDelegate:self];
    //配置代理为本类
    [resuest setTimeOutSeconds:10];
    //设置超时
    [resuest setDidFailSelector:@selector(urlRequestFailed:)];
    [resuest setDidFinishSelector:@selector(urlRequestSucceeded:)];
    
    [resuest startAsynchronous];
}
-(void)picClick:(UIButton *)btn
{
    
    
    [inputField resignFirstResponder];
//    
//
//    ETPraiseViewController * PraiseVC=[[ETPraiseViewController alloc]init];
//    [self.navigationController pushViewController:PraiseVC animated:YES];
//    [PraiseVC release];
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"changeavadar", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:NSLocalizedString(@"takePhoto", @"") otherButtonTitles:NSLocalizedString(@"choosePhoto", @""), nil];
    [sheet showInView:self.view];
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0)
    {
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.delegate=self;
        pickerController.allowsEditing=NO;
        NSLog(@"paiz");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
        [pickerController release];
        
    }
    if(buttonIndex==1)
    {
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.delegate=self;
        pickerController.allowsEditing=NO;
        NSLog(@"选取");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
        [pickerController release];
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
    
  //  [_ reloadData];
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=@"加载中";
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
   
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)upClick:(UIButton *)btn
{
    if([inputField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
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
    [inputField resignFirstResponder];
    [self createProblem:@""];
    
    
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
-(void)createProblem:(NSString *)url
{
    UserLogin *user=[UserLogin currentLogin];
    
    
    int time= [[NSDate date] timeIntervalSince1970];
    
    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,_problem.problemId,@"testchunyu"];
    
    NSString *sign=[self md5:string];
    
  
  //  NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"patient_meta",@"type",_textField.text,@"age",self.sex,@"sex", nil];
    
    NSArray *arr=nil;
    if([url isEqualToString:@""])
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",inputField.text,@"text", nil];
      
        arr=[NSArray arrayWithObjects:dic, nil];
    }
    else
    {
        NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",url,@"file", nil];
        arr=[NSArray arrayWithObjects:dic3, nil];
    }
    
    NSData *jsondate=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstr=[[NSString alloc]initWithData:jsondate encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonstr);
    ASIFormDataRequest *resuest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem_content/create"]];
    [resuest setPostValue:user.username forKey:@"user_id"];
    [resuest setPostValue:_problem.problemId forKey:@"problem_id"];
    [resuest setPostValue:jsonstr forKey:@"content"];
    [resuest setPostValue:sign forKey:@"sign"];

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
        NSLog(@"%@",request.responseString);
    NSString * key=[[request userInfo] objectForKey:@"pic"];
    if([key isEqualToString:@"pic"])
    {
        NSDictionary *dic= [NSJSONSerialization  JSONObjectWithData:request.responseData options:0 error:nil];
        NSString *url=[dic objectForKey:@"file"];
        
        
        [self createProblem:url];
    }
    else if([key isEqualToString:@"nopic"])
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

            [self loadAnswer];
            inputField.text=@"";
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[dic objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
  
    }
    else if([key isEqualToString:@"data"])
    {
           [_slimeView endRefresh];
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
        [_answerList removeAllObjects];
        NSDictionary *dic= [NSJSONSerialization  JSONObjectWithData:request.responseData options:0 error:nil];
        NSArray *contentDic=[dic objectForKey:@"content"];
        NSDictionary *doctorDic=[dic objectForKey:@"doctor"];
        CYDoctor *doc=[[CYDoctor alloc]init];
        doc.clinic=[doctorDic objectForKey:@"clinic"];
        doc.hospital=[doctorDic objectForKey:@"hospital"];
        doc.docid=[doctorDic objectForKey:@"id"];
        doc.image=[doctorDic objectForKey:@"image"];
        doc.level_title=[doctorDic objectForKey:@"level_title"];
        doc.name=[doctorDic objectForKey:@"name"];
        doc.title=[doctorDic objectForKey:@"title"];
        self.doctor=doc;
        [doc release];
        for (int i=0; i<[contentDic count]; i++) {
            NSDictionary *dic=[contentDic objectAtIndex:i];
            ProblemDetail *detail=[[ProblemDetail alloc]init];
            detail.contentid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            detail.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            detail.created_time_ms=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"created_time_ms"]] substringToIndex:10];
            NSString  *content=[dic objectForKey:@"content"];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *contentarr=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            for (int j=0; j<[contentarr count]; j++) {
                ProblemContent *content=[[ProblemContent alloc]init];
                NSString *type=[[contentarr objectAtIndex:j] objectForKey:@"type"];
                
                if([type isEqualToString:@"text"])
                {
                   NSString *text=[[contentarr objectAtIndex:j] objectForKey:@"text"];
                    content.text=text;
                }
                else
                {
                    NSString *text=[[contentarr objectAtIndex:j] objectForKey:@"file"];
                    content.text=text;
                }
                
             
                //NSString *type=@"image";
                content.type=type;
                
                [detail.contentArr addObject:content];
                [content release];
            }
            [_answerList addObject:detail];
            [detail release];
        }
        [self loadUI];
        [self._tableView reloadData];
        if([_answerList count]>0)
        [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_answerList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProblemDetail *_detail=[self.answerList objectAtIndex:indexPath.row];
    float cellheight=30;
    if([_detail.type isEqualToString:@"p"])
    {
        // 左气泡
        for (int i=0; i<[_detail.contentArr count]; i++) {
            ProblemContent *pro=[_detail.contentArr objectAtIndex:i];
      
            if([pro.type isEqualToString:@"text"])
            {
                CGSize size=[pro.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                cellheight+=(size.height+20+10);
 
            }
            else if([pro.type isEqualToString:@"image"])
            {
                cellheight+=(90+20);
            }
            
        }

        
    }
    else if ([_detail.type isEqualToString:@"d"])
    {
        for (int i=0; i<[_detail.contentArr count]; i++)
        {
            ProblemContent *pro=[_detail.contentArr objectAtIndex:i];
            if([pro.type isEqualToString:@"text"])
            {
                CGSize size=[pro.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 1000) lineBreakMode:NSLineBreakByWordWrapping];

                cellheight+=(size.height + 20 + 10);

                
                
                
            }
            else if([pro.type isEqualToString:@"image"])
            {
                cellheight+=(90+20);
            }
            
            
        }
     
    }

    return cellheight;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.answerList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    CYDetailCell *cell=(CYDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[CYDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
        cell.delegate=self;
    }

    ProblemDetail *detail=[self.answerList objectAtIndex:indexPath.row];
    cell.detail=detail;
    if(self.doctor)
    {
        //[cell.photoImageView setImageWithURL:[NSURL URLWithString:_doctor.image] placeholderImage:nil];
        [cell.photoImageView setImageWithURL:[NSURL URLWithString:_doctor.image] placeholderImage:[UIImage imageNamed:@"health_doctor.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            cell.photoImageView.userInteractionEnabled=YES;
        }];
        cell.namelabel.text=_doctor.name;
        cell.levelLabel.text=_doctor.title;
    
    }
   
   // cell.textLabel.text=detail.created_time_ms;
    
    return cell;
    
    
    
}
-(void)clickToDoctorDetailController
{
    CYDoctorViewController *doctVC=[[CYDoctorViewController alloc]init];
    doctVC.doctor=self.doctor;
    [self.navigationController pushViewController:doctVC animated:YES];
    [doctVC release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{

    [self loadAnswer];

    //  [self loadNotice:param];
    //theRefreshPos = EGORefreshHeader;
    //[self requestNoticeData:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    
}
-(void)dealloc
{    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    self._tableView=nil;
    self.photoImage=nil;
    self.problem=nil;
    self.answerList=nil;
    self.doctor=nil;
    self._slimeView=nil;
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

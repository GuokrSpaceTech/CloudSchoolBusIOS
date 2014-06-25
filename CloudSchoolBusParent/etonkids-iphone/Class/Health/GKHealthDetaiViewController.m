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
@interface GKHealthDetaiViewController ()

@end

@implementation GKHealthDetaiViewController

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
//        if(ios7)
//            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y+20);
//        else
//            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y);
        
        
    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-57, 320, 57);
//        __tableView.frame=CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-58);
    }];
    
}
-(void)keyboarShow:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
//        if(ios7)
//            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y+10);
//        else
//            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y);
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
    middleLabel.text = @"医生咨询";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    

    
    
    __tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStylePlain];
    __tableView.backgroundView = nil;
    __tableView.backgroundColor = CELLCOLOR;
    __tableView.delegate = self;
    __tableView.dataSource = self;
    __tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:__tableView];
    
    
    
    inputView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-57, 320, 57)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
    imageView.image=[UIImage imageNamed:@"inputBG.png"];
    [inputView addSubview:imageView];
    [imageView release];
    
    
    
    
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
    
    [self.view addSubview:inputView];
    [inputView release];
    
    
    // [imageView];
  

}
-(void)picClick:(UIButton *)btn
{
    
    
    [inputField resignFirstResponder];
    
//    UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:LOCAL(@"changeavadar",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") , nil];
//    [aa showInView:self.view];
//
//    [aa release];
    
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
    [self createProblem:inputField.text];
    
    
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
    
    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,@"12621049",@"testchunyu"];
    
    NSString *sign=[self md5:string];
    
  
  //  NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"patient_meta",@"type",_textField.text,@"age",self.sex,@"sex", nil];
    
    NSArray *arr=nil;
    if(![url isEqualToString:@""])
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
    [resuest setPostValue:@"12621049" forKey:@"problem_id"];
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
            
            //NSLog(@"%@",[dic objectForKey:@"problem_id"]);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"创建成功" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"创建失败" message:[dic objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 137+20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
    }
    
    return cell;
    
    
    
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
-(void)dealloc
{
    self._tableView=nil;
    self.photoImage=nil;
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

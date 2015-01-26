//
//  ETAddSendReceiveViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETAddSendReceiveViewController.h"
#import "ETKids.h"
#import "ETCustomAlertView.h"
#import "AppDelegate.h"
#import "GTMBase64.h"
#import "GKChildReceiver.h"
@interface ETAddSendReceiveViewController ()

@end

@implementation ETAddSendReceiveViewController
@synthesize completeBlack;
@synthesize photoImageView;
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
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = NSLocalizedString(@"add", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-50, (ios7 ? 20 : 0) + NAVIHEIGHT +20, 100, 100)];
    photoImageView.backgroundColor=[UIColor grayColor];
    photoImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [photoImageView addGestureRecognizer:tap];
    [tap release];
    
    [self.view addSubview:photoImageView];
  
    
    imagePhoto=[[UIImageView alloc]initWithFrame:CGRectMake(75, 80, 25, 20)];
    imagePhoto.image=[UIImage imageNamed:@"photo.png"];
    [photoImageView addSubview:imagePhoto];
    [imagePhoto release];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-80, photoImageView.frame.size.height+photoImageView.frame.origin.y+10, 160, 30)];
    _textField.font=[UIFont systemFontOfSize:14];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.delegate=self;
    _textField.placeholder=NSLocalizedString(@"relationshipchild", @"");
    [self.view addSubview:_textField];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)tapClick:(UIGestureRecognizer *)tap
{
    [_textField resignFirstResponder];
    MTCustomActionSheet *action=[[MTCustomActionSheet alloc]initWithTitle:LOCAL(@"changeavadar", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
    [action showInView:self.view.window];
    action.tag=101;
    [action release];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)rightButtonClick:(UIButton *)btn
{
    [_textField resignFirstResponder];

    if(self.base64str==nil )
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"firstimage", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
        [alert show];

        return;
    }
    if([_textField.text isEqualToString:@""])
    {
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input", @"输入不恩能够为空") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
        [alert show];
        return;
    }
    if(HUD==nil)
    {
        AppDelegate *appDel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:appDel.window];
        HUD.labelText=LOCAL(@"load", @"正在上传头像");   //@"正在上传头像";
        [appDel.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.base64str,@"fbody",_textField.text,@"relationship",@"jpg",@"fext", nil];
    [[EKRequest Instance] EKHTTPRequest:childreceiver parameters:param requestMethod:POST forDelegate:self];
}
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    if (actionSheet.tag == 101)
    {
        if (index == 0) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
                [alert show];
                
                
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            AppDelegate *appDel = SHARED_APP_DELEGATE;
            //[appDel.bottomNav presentModalViewController:picker animated:YES];
            [appDel.bottomNav presentViewController:picker animated:YES completion:^{
                
            }];
            [picker release];
        }
        else if (index == 1)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            AppDelegate *appDel = SHARED_APP_DELEGATE;
           // [appDel.bottomNav presentModalViewController:picker animated:YES];
            [appDel.bottomNav presentViewController:picker animated:YES completion:^{
                
            }];
            [picker release];
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    photoImageView.image=image;
    //    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    imgV.image = image;
    //    [self.view addSubview:imgV];
    //    [imgV release];
    
    
    [self saveImage:image];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)saveImage:(UIImage *)image
{
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    

    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    self.base64str=base64;
    
    [base64 release];
}
-(void)successAddReceiver:(CompleteBlock)black
{
    self.completeBlack=black;
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==childreceiver)
    {
        if(code==1)
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            if(dic)
            {
                self.completeBlack(dic);
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"receiversuccess", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        if(code==-6)
        {
            
//            "receiverfailed"="上传失败，请重试";
//            "receiversuccess"="上传成功";

            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"receiverfailed", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
            [alert show];
        }
        if(code==-3)
        {
            //ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"图片上传格式不对" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
           // [alert show];
        }
        if(code==-2)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"firstimage", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
            [alert show];
        }
        if(code==-4)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"morefour", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
            [alert show];
        }
        if(code==-5)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input", @"输入不恩能够为空") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil ,nil];
            [alert show];
        }
    }
   
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }

    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
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
-(void)dealloc
{
    self.textField=nil;
    self.base64str=nil;
    self.photoImageView=nil;
    self.completeBlack=nil;
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

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
    [rightButton setTitle:@"对号" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //UI
    

    
    self.labelArr=[NSArray arrayWithObjects:@"性别",@"年龄",@"科室", nil];
    
    
    
    downBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downBtn setTitle:@"下" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(keyboardDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];

}
-(void)keyBoardHidden:(NSNotification *)no
{
     downBtn.frame=CGRectMake(0,self.view.frame.size.height, 20, 20);
}
-(void)keyboardDown:(UIButton *)btn
{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}
-(void)keyBoardChange:(NSNotification *)no
{
    NSDictionary *info = [no userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    
    downBtn.frame=CGRectMake(self.view.frame.size.width-30,self.view.frame.size.height-keyboardSize.height-(ios7?20:0), 20, 20);
}
-(void)keyBoardShow:(NSNotification *)no
{
    NSDictionary *info = [no userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    downBtn.frame=CGRectMake(self.view.frame.size.width-30,self.view.frame.size.height-keyboardSize.height-(ios7?20:0), 20, 20);

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
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       // cell.backgroundColor=[UIColor clearColor];
       // cell.backgroundView=nil;
        
        if(indexPath.section==0)
        {
             _textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, 310, 140)];

           // _textView.text=@"请您尽可能详细的描述";
            _textView.delegate=self;
            _textView.backgroundColor=[UIColor redColor];
            _textView.tag=100;
            [cell.contentView addSubview:_textView];
            [_textView release];
        }
        if(indexPath.section==1)
        {

            if(indexPath.row==3)
            {
                photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 110, 125)];
                photoImageView.backgroundColor=[UIColor grayColor];
                [cell.contentView addSubview:photoImageView];
                [photoImageView release];
                
                
                deleteImageView=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                deleteImageView.frame=CGRectMake(280, 58, 20, 20);
                //deleteImageView.hidden=YES;
                [deleteImageView setTitle:@"x" forState:UIControlStateNormal];
                [deleteImageView addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deleteImageView];
                
           
                
            }
            else
            {
                UILabel * nameLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
                nameLable.text=@"";
                [cell.contentView addSubview:nameLable];
                nameLable.tag=101;
                [nameLable release];
                
                if(indexPath.row==1)
                {
                    _textField=[[UITextField alloc]initWithFrame:CGRectMake(200, 5, 100, 30)];
                    _textField.text=@"";
                    _textField.borderStyle=UITextBorderStyleRoundedRect;
                    _textField.delegate=self;
                    _textField.keyboardType=UIKeyboardTypeNumberPad;
                    [cell.contentView addSubview:_textField];
                    [_textField release];
                }
                else
                {
                    UILabel * realLabel=[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 60, 20)];
                    realLabel.text=@"";
                    [cell.contentView addSubview:realLabel];
                    realLabel.tag=102;
                    [realLabel release];

                }
            }
            
            
        }
    }
    
    if(indexPath.section==1)
    {
        if(indexPath.row==3)
        {
            if(self.photoImage)
            {
                photoImageView.image=[UIImage imageWithData:self.photoImage];
                deleteImageView.hidden=NO;
            }
            else
            {
                photoImageView.image=nil;
                deleteImageView.hidden=YES;
            }
        }
        else
        {
            UILabel *label=(UILabel *)[cell.contentView viewWithTag:101];
            label.text=[self.labelArr objectAtIndex:indexPath.row];
            
            UILabel *real=(UILabel *)[cell.contentView viewWithTag:102];
            if(indexPath.row==0)
            {
                real.text=self.sex;
            }
            if(indexPath.row==2)
            {
                real.text=self.keshi;
            }
          //  real.text=[self.labelArr objectAtIndex:indexPath.row];
            
        }
        
    }
    
    
    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 150;
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==3)
        {
            return 135;
        }
    }
        return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    
   if(indexPath.section==1)
   {
       if(indexPath.row==0)
       {
           UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:LOCAL(@"Gender",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"prince",@""),LOCAL(@"Princess",@""), nil];
           [aa showInView:self.view];
            aa.tag = 102;
           [aa release];
           
       }
       if(indexPath.row==1)
       {
           
       }
       if(indexPath.row==2)
       {
           UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:@"科室" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"妇产科",@"儿科",@"内科",@"皮肤性病科",@"内分泌科",@"营养科",@"骨科",@"男性泌尿科",@"外科",@"心血管科脑神经科",@"肿瘤科",@"中医科",@"口腔科",@"耳鼻喉科",@"眼科",@"整形美容科",@"心理科",@"脑神经科", nil];
           [aa showInView:self.view];
           aa.tag=103;
           [aa release];
       }
       if(indexPath.row==3)
       {
           
           UIActionSheet *aa=[[UIActionSheet alloc]initWithTitle:LOCAL(@"changeavadar",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") , nil];
           [aa showInView:self.view];
           aa.tag = 101;
           [aa release];
       }
   }
    
    
    
    
}
-(void)deletePhoto:(UIButton *)btn
{
    self.photoImage=nil;
    [_tableView reloadData];
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
        }
        if(buttonIndex==1)
        {
            self.sex=@"女";
        }
        [_tableView reloadData];
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
            
        }
        [_tableView reloadData];
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

    [_tableView reloadData];
    
    
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
    self.labelArr=nil;
    self.photoImage=nil;
    self.sex=nil;
    self.keshi=nil;
    self.age=nil;

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

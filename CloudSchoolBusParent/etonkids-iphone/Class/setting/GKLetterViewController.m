//
//  GKLetterViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKLetterViewController.h"
#import "GTMBase64.h"
#import "GKLetterData.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ETBottomViewController.h"
#import "GKShowReceiveBigImageViewController.h"
@interface GKLetterViewController ()

@end

@implementation GKLetterViewController
@synthesize _slimeView;
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)leftButtonClick:(id)sender
{
    AppDelegate *deletae=SHARED_APP_DELEGATE;
    NSArray *arr=deletae.bottomNav.viewControllers;
    for (int i=0; i<[arr count]; i++) {
        UIViewController *vc=[arr objectAtIndex:i];
        if([vc isKindOfClass:[ETBottomViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
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
        
        if([_dataArr count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        
    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-57, 320, 57);
        __tableView.frame= CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40);
        if([_dataArr count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    
}

-(void)clickImageViewLookImage:(NSString *)path
{
  
    GKShowReceiveBigImageViewController *showVC=[[GKShowReceiveBigImageViewController alloc]init];
    showVC.path=path;
    [self presentModalViewController:showVC animated:YES];
    [showVC release];
}
-(void)keyboarShow:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
        
        __tableView.frame= CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40-rect.size.height);
        if([_dataArr count]>0)
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
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
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    // [self loadUI];
//    [__tableView reloadData];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"PLAYINGSTOP" object:nil];
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
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = _contactObj.cnname;
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    _dataArr=[[NSMutableArray alloc]init];
    
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
    
    [self loadUI];
    [self loadData];
   // [self loadAnswer];
    
    // [imageView];
    
    
}
-(void)loadData
{
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",_contactObj.from_id,@"id", nil];
    [[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:GET forDelegate:self];
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
-(void)loadUI
{

    inputView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-57, 320, 57)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
    imageView.image=[UIImage imageNamed:@"inputBG.png"];
    [inputView addSubview:imageView];
    [imageView release];

    inputField=[[UITextField alloc]initWithFrame:CGRectMake(57, 15, 180, 27)];
    inputField.borderStyle=UITextBorderStyleRoundedRect;
    inputField.delegate=self;
    inputField.placeholder=@"说点什么";
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
    
    
}
-(void)upClick:(UIButton *)btn
{
    if([inputField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:inputField.text,@"content",@"txt",@"lettertype",_contactObj.from_id,@"id", nil];
    [[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:POST forDelegate:self];
    
    
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSLog(@"%d",code);
    [_slimeView endRefresh];
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==messageletter && code==1)
    {
        
        NSArray *parmArr= [param allKeys];
        if([parmArr containsObject:@"starttime"] || [parmArr containsObject:@"endtime"])
        {
            if([[param objectForKey:@"starttime"] isEqualToString:@"0"] && [[param objectForKey:@"endtime"] isEqualToString:@"0"])
            {
                [_dataArr removeAllObjects];
            }
            NSArray *arr= [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSLog(@"%@",arr);
            for (int i=0; i<[arr count]; i++) {
                NSLog(@"dfdsfdsf");
                
                Letter *letter=[[Letter alloc]init];
                letter.letterID=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"letterid"]];
                letter.letterContent=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"content"]];
                letter.letterTime=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"addtime"]];;
                
                letter.letterFromRole=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"from_role"]];
                letter.letterLetterType=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"letter_type"]];
                NSLog(@"%@",letter.letterFromRole);
                
                // if()
                
                NSDate *date=[NSDate dateWithTimeIntervalSince1970:[letter.letterTime integerValue]];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr=[formatter stringFromDate:date];
                [formatter release];
                
                BOOL found=NO;
                for (int j=0; j<[_dataArr count]; j++) {
                    GKLetterData *data=[_dataArr objectAtIndex:j];
                    
                    if([data.dateKey isEqualToString:dateStr])
                    {
                        found=YES;
                        [data.letterArr addObject:letter];
                        
                        break;
                    }
                    else
                    {
                        found=NO;
                    }
                    
                    
                }
                
                if(found==YES)
                {
                    
                }
                else
                {
                    GKLetterData *data=[[GKLetterData alloc]init];
                    data.dateKey=dateStr;
                    [data.letterArr addObject:letter];
                    [_dataArr addObject:data];
                    [data release];
                    
                }
                
                
                // [dataArr addObject:letter];
                [letter release];
                
            }
            
            
            
            if([[param objectForKey:@"starttime"] isEqualToString:@"0"] && [[param objectForKey:@"endtime"] isEqualToString:@"0"])
            {
                [self sortArr:YES];
            }
            else
            {
                [self sortArr:NO];
            }
            
            
            
        }
        else
        {
            inputField.text=@"";
            // Letter *letter=[dataArr objectAtIndex:0];
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",_contactObj.from_id,@"id", nil];
            //[[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:GET forDelegate:self];
            [[EKRequest Instance] EKHTTPRequest:messageletter parameters:dic requestMethod:GET forDelegate:self];
            // }
            
        }
        
        
        
    }
}
-(void)sortArr:(BOOL)isbool
{
    
    
    
    NSSortDescriptor *desc=[[NSSortDescriptor alloc]initWithKey:@"dateKey" ascending:YES];
    NSArray *arr=[NSArray arrayWithObjects:desc, nil];
    [desc release];
    
    [_dataArr sortUsingDescriptors:arr];
    
    
    for (int i=0; i<[_dataArr count]; i++) {
        GKLetterData *data=[_dataArr objectAtIndex:i];
        
        
        NSSortDescriptor *desc11=[[NSSortDescriptor alloc]initWithKey:@"letterTime" ascending:YES];
        NSArray *arr11=[NSArray arrayWithObjects:desc11, nil];
        [desc11 release];
        [data.letterArr sortUsingDescriptors:arr11];
    }
    
    [__tableView reloadData];
    if(isbool)
    {
        if([_dataArr count]>0)
        {
            GKLetterData *data=[_dataArr objectAtIndex:[_dataArr count]-1];
            [__tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[data.letterArr count] inSection:[_dataArr count]-1] atScrollPosition:0 animated:NO];
        }
        
    }
    
    
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    [_slimeView endRefresh];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GKLetterData *data=[_dataArr objectAtIndex:section];
    return [data.letterArr count]+1 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        static NSString *cell0=@"cel0l";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell0];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 1)];
            imageView.image=[UIImage imageNamed:@"letterLine.png"];
            [cell addSubview:imageView];
            [imageView release];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(135, 0, 120, 20)];
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:10];
            [cell addSubview:label];
            label.tag=1000;
            [label release];
            
            
        }
        UILabel *label=(UILabel *)[cell viewWithTag:1000];
        
        GKLetterData *data=[_dataArr objectAtIndex:indexPath.section];
        label.text=data.dateKey;
        
        return cell;
        
    }
    
    static NSString *cellIdentifier=@"cell";
    GKLetterCell *cell=(GKLetterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[GKLetterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.delegate=self;
    }
    
    GKLetterData *data=[_dataArr objectAtIndex:indexPath.section];
    cell.letter=[data.letterArr objectAtIndex:indexPath.row-1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  return 100;
    if(indexPath.row==0)
    {
        return 20;
    }
    GKLetterData *data=[_dataArr objectAtIndex:indexPath.section];
    Letter *letter=[data.letterArr objectAtIndex:indexPath.row -1 ];
    
    
    // 左气泡
    
    //CGRectMake(35, 20, 60, 20);
    
    CGSize size=[letter.letterContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    if([letter.letterLetterType isEqualToString:@"txt"])
    {
        return 20+ size.height+10 ;
    }
    else
    {
        return 120;
    }
    
    
    
    
    
    
    return 0;
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
    
    //@autoreleasepool {
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
    UIImage *theImage;
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    NSData *data= UIImageJPEGRepresentation(theImage, 0.2);
    
    UIImage *image=[UIImage imageWithData:data];
    NSData *dataqq=UIImageJPEGRepresentation(image, 1);
    NSString *base64=[[[NSString alloc]initWithData:[GTMBase64 encodeData:dataqq] encoding:NSUTF8StringEncoding] autorelease];
    
    int ftime=[[NSDate date]timeIntervalSince1970];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"img",@"lettertype",base64,@"fbody",[NSNumber numberWithInt:ftime],@"ftime",[NSNumber numberWithInt:[base64 length]],@"fsize",@"jpg",@"fext",_contactObj.from_id,@"id", nil];
    
    
   // NSLog(@"%@",dic);
    [[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:POST forDelegate:self];
    
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)selectPhoto:(UIImage *)img
{
 

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    
    if([_dataArr count]>0)
    {
        GKLetterData *data=[_dataArr objectAtIndex:0];
        NSString *time=[[data.letterArr objectAtIndex:0] letterTime];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:time,@"starttime",@"0",@"endtime",_contactObj.from_id,@"id", nil];
        [[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:GET forDelegate:self];
        
    }
    else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",_contactObj.from_id,@"id", nil];
        [[EKRequest Instance]EKHTTPRequest:messageletter parameters:dic requestMethod:GET forDelegate:self];
        
    }
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

    self.contactObj=nil;
    self.dataArr=nil;
    self._slimeView=nil;
    [super dealloc];
}
@end

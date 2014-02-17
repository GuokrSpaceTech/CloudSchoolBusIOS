//
//  GKStudentInfoViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKStudentInfoViewController.h"
#import "KKNavigationController.h"
#import "ETNicknameViewController.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"

#define TAGCELL 500

#define ACTIONTAG 600
@interface GKStudentInfoViewController ()

@end

@implementation GKStudentInfoViewController
@synthesize st;
@synthesize _tableView;
//@synthesize arr;
@synthesize tempSexOrBirthday;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titlelabel.text=NSLocalizedString(@"detail", @"");

    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
     _tableView.backgroundView=nil;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
  //  self.arr=[NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"生日", nil];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 2;
    else
        return 4;
}
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 11, 100, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.tag=TAGCELL;
        namelabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        
        
        UILabel *reallabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 11, 100, 20)];
        reallabel.backgroundColor=[UIColor clearColor];
        reallabel.tag=TAGCELL+1;
        if(IOSVERSION>=6.0)
            reallabel.textAlignment=NSTextAlignmentRight;
        else
            reallabel.textAlignment=UITextAlignmentRight;
        reallabel.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:reallabel];
        [reallabel release];
        
        if(indexPath.section==1)
        {
            if(indexPath.row==0)
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(230, 5, 50, 50)];
                imageView.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:imageView];
                imageView.tag=TAGCELL+2;
                [imageView release];
 
            }
        }
        
        
    }
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:TAGCELL];
    UILabel *realLabel=(UILabel *)[cell.contentView viewWithTag:TAGCELL+1];

    UIImageView *imageView=(UIImageView*)[cell.contentView viewWithTag:TAGCELL+2];


    if(indexPath.section==0)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row==0)
        {
            nameLabel.text=NSLocalizedString(@"realName", @"");
            realLabel.text=st.cnname;
        }
        else
        {
//            "state"="服务状态";
//            "Notservice"="尚未开通";
//            "Inservice"="已开通";
//            "renewal"="服务过期";
            nameLabel.text=NSLocalizedString(@"state", @"");
            
            if(st.orderendtime==nil)
            {
                realLabel.text=NSLocalizedString(@"Notservice", @"");
                realLabel.textColor=[UIColor redColor];
                
            }
            else
            {
                int time=[[NSDate date] timeIntervalSinceNow];
                if(time<[[st orderendtime] integerValue])
                {
                    realLabel.text=NSLocalizedString(@"Inservice", @"");
                    realLabel.textColor=[UIColor blackColor];
                }
                else
                {
                    realLabel.text=NSLocalizedString(@"renewal", @"");
                    realLabel.textColor=[UIColor redColor];
                }
                
            }

            
        }
      
    }
    else
    {
        
//        "Princess"="女孩";
//        "prince"="男孩";
//        "Gender"="性别";
        
          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                nameLabel.text=NSLocalizedString(@"avator", @"");
                //(10, 11, 100, 20)];
                [imageView setImageWithURL:[NSURL URLWithString:st.avatar] placeholderImage:nil options:SDWebImageRefreshCached];
                nameLabel.frame=CGRectMake(10, 20, 100, 20);
                
                break;
            case 1:
               
                nameLabel.text=NSLocalizedString(@"nickName1", @"");
                realLabel.text=st.enname;
                break;
            case 2:
                nameLabel.text=NSLocalizedString(@"Gender", @"");
                
                switch ([st.sex intValue]) {
                    case 2:
                      realLabel.text=NSLocalizedString(@"Princess", @"");
                        break;
                    case 1:
                      realLabel.text=NSLocalizedString(@"prince", @"");
                        break;
                        
                    default:
                        break;
                }
                break;
            case 3:
                
                nameLabel.text=NSLocalizedString(@"birthday", @"");
                realLabel.text=st.birthday;
                break;
            default:
                break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if(indexPath.section==1)
   {
       if(indexPath.row==1)
       {
           //修改昵称
           ETNicknameViewController *nickVC=[[ETNicknameViewController alloc]initWithNibName:@"ETNicknameViewController" bundle:nil];
           nickVC.cstudent=self.st;
           nickVC.delegate=self;
           [self.navigationController pushViewController:nickVC animated:YES];
           [nickVC release];
       }
       if(indexPath.row==0)
       {
           //修改头像
           UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"avatorM", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choose", @""), nil];
           [action showInView:self.view];
           action.tag=ACTIONTAG;
           [action release];
       }
       if(indexPath.row==2)
       {
           //修改性别
//           "Princess"="女孩";
//           "prince"="男孩";
//           "Gender"="性别";
           
           UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Gender", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"prince", @""),NSLocalizedString(@"Princess", @""), nil];
           [action showInView:self.view];
           action.tag=ACTIONTAG+1;
           [action release];
           
           
       }
       if(indexPath.row==3)
       {
           //修改生日
           
           NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
           [formate setDateFormat:@"yyyy-MM-dd"];
           NSDate *date=[formate dateFromString:st.birthday];
           MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:date];
           sheet._delegate = self;
           
           [sheet showInView:self.view.window];
           [sheet release];
       }
   }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            return 60;
        }
    }
    return 44;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTIONTAG)
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
    if(actionSheet.tag==ACTIONTAG+1)
    {
        NSLog(@"%d",buttonIndex);
        if(buttonIndex==0)
        {
            //男
            
            //    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:sex],@"sex",birthdayField.text,@"birthday",nickField.text,@"enname",_student.studentid,@"studentid"  ,nil];
            
            if([st.sex integerValue]==2 || [st.sex integerValue]==0)//如果学生是女
            {
                //修改为男
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"sex",st.studentid,@"studentid",st.uid,@"uid" , nil];
             
                [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
            }
           
     
        }
        else if(buttonIndex==1)
        {
            //女
            if([st.sex integerValue]==1|| [st.sex integerValue]==0)
            {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"sex",st.studentid,@"studentid",st.uid,@"uid" ,nil];
                [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
            }
     
        }
        else
        {
            
        }
    }
}
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    
}
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index selectDate:(NSDate *)date
{
    if (index == 1) {
        //        NSLog(@"%f",[date timeIntervalSinceNow]);
        if ([date timeIntervalSinceNow] > 0) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:NSLocalizedString(@"rightdate", @"请设置正确的生日日期") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
       // UserLogin *user = [UserLogin currentLogin];
        
        NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *birStr = [formatter stringFromDate:date];
        
        if ([st.birthday isEqualToString:birStr]) {
            return;
        }
        
            NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:birStr,@"birthday",st.studentid,@"studentid",st.uid,@"uid" ,nil];
            [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image];
}
- (void)saveImage:(UIImage *)image
{
//     param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",[NSString stringWithFormat:@"%d",CurrentStudentID],@"id",@"1",@"isstudent", nil];
    
    
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",@"2",@"isstudent",st.studentid,@"id",nil];
    [[EKRequest Instance] EKHTTPRequest:avatar parameters:param requestMethod:POST forDelegate:self];
    [base64 release];
}


- (void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    NSLog(@"error code : %d",code);
    if (method == avatar)
    {
        if(code == 1)
        {
            
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"avatorsuccess", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            st.avatar=result; // 把修改后的头像url 赋给 学生 之后刷新界面
            [_tableView reloadData];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"avatorfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    if(method==student)
    {
       // sex
        //@"birthday"
        
        if(code==1)
        {
            if([[parm allKeys] containsObject:@"sex"])
            {
                //修改性别成功
                NSString *sex=[parm objectForKey:@"sex"];
                st.sex=[NSNumber numberWithInt:[sex integerValue]];
                
            }
            if([[parm allKeys] containsObject:@"birthday"])
            {
                //修改生日成功
                
                NSString *birthday=[parm objectForKey:@"birthday"];
                st.birthday=birthday;;
                
                NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *birDate = [formatter dateFromString:birthday];
                int second = [[NSDate date] timeIntervalSinceDate:birDate];
              //  st.age =[NSString stringWithFormat:@"%d", second / (3600 * 24 * 365) + 1];
                st.age=[NSNumber numberWithInt:second / (3600 * 24 * 365) + 1];
                
            }
            
            [_tableView reloadData];
        }
        if(code==-2)
        {
            //
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"wrong", @"无uid 没有付费") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        if(code==-41)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"change", @"没有修改内容") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"avatorfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)changeNicknameSuccess
{
    //修改成功 刷新数据
    [_tableView reloadData];
}
-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidUnload
{
    [_tableView release];
    _tableView=nil;
    [super viewDidUnload];
}
-(void)dealloc
{
    self.st=nil;
    self._tableView=nil;
    //self.arr=nil;
    self.tempSexOrBirthday=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ETBaseMessageViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBaseMessageViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"
#import "ETCommonClass.h"
#import "ETCoreDataManager.h"
#import "GTMBase64.h"
@interface ETBaseMessageViewController ()

@end

@implementation ETBaseMessageViewController
@synthesize mainTV,delegate;

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
    // Do any additional setup after loading the view from its nib.
    
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
    
    self.view.backgroundColor=[UIColor blackColor];
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(doClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"basemessage", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UITableView *mainVC = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStyleGrouped];
    mainVC.backgroundView = nil;
    mainVC.backgroundColor = CELLCOLOR;
    mainVC.delegate = self;
    mainVC.dataSource = self;
    [self.view addSubview:mainVC];
    [mainVC release];
    
    self.mainTV = mainVC;
    
}
- (void)doClickCancel:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(reloadChildMessage)]) {
        [delegate reloadChildMessage];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if(cell==nil)
//    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
//    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UserLogin *user = [UserLogin currentLogin];
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Avatar", @"");
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
            //头像
            UIImageView * headImage=[[UIImageView alloc]initWithFrame:CGRectMake(190,15, 65, 65)];
            headImage.backgroundColor=[UIColor clearColor];
            headImage.tag=100;
//            headImage.layer.borderWidth=2;
//            headImage.layer.borderColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1].CGColor;
            
            if(user.avatar != nil)
                [headImage setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] options:SDWebImageRefreshCached|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    headImage.image = image;
                }];
            
            [cell.contentView addSubview:headImage];
            [headImage release];
            
        }
        else if (indexPath.row==1)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Nickname", @"");
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
            UILabel *nicknamelabel=[[UILabel alloc]initWithFrame:CGRectMake(100,10,170,20)];
            nicknamelabel.tag = 101;
            nicknamelabel.textAlignment=UITextAlignmentRight;
            [cell.contentView addSubview:nicknamelabel];
            nicknamelabel.backgroundColor=[UIColor clearColor];
            nicknamelabel.font=[UIFont systemFontOfSize:15];
            nicknamelabel.text=user.nickname;
            [nicknamelabel release];
            
            
        }
        else if(indexPath.row==2)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Gender", @"");
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
            UILabel *genderlabel=[[UILabel alloc]initWithFrame:CGRectMake(100,10,170,20)];
            genderlabel.textAlignment=UITextAlignmentRight;
            genderlabel.tag = 102;
            [cell.contentView addSubview:genderlabel];
            genderlabel.backgroundColor=[UIColor clearColor];
            genderlabel.font=[UIFont systemFontOfSize:15];
            [genderlabel release];
            
            
            if ([user.sex isEqualToString:@"1"])
            {
                genderlabel.text=LOCAL(@"prince",@"");
            }
            else if ([user.sex isEqualToString:@"2"])
            {
                genderlabel.text=LOCAL(@"Princess",@"");
            }
            
        }
        else if(indexPath.row==3)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Birthday",@"");
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
            
            birthdaylabel=[[UILabel alloc]initWithFrame:CGRectMake(100,10,170,20)];
            birthdaylabel.textAlignment=UITextAlignmentRight;
            [cell.contentView addSubview:birthdaylabel];
            birthdaylabel.tag = 103;
            birthdaylabel.backgroundColor=[UIColor clearColor];
            birthdaylabel.font=[UIFont systemFontOfSize:15];
            birthdaylabel.text = user.birthday;
            //            self.originDate = [NSString stringWithFormat:@"%@",self.birthdaylabel.text];
            [birthdaylabel release];
            
        }

        
    }
    else if (indexPath.section == 1) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Name", @"姓名");
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectedBackgroundView.backgroundColor=[UIColor blackColor];
            
            UILabel  *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(100,12,180,20)];
            namelabel.textAlignment=UITextAlignmentRight;
            namelabel.backgroundColor=[UIColor clearColor];
            namelabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
            namelabel.text = user.cnname;
            [cell.contentView addSubview:namelabel];
            [namelabel release];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Class", @"班级");
            
            UILabel  *classlabel=[[UILabel alloc]initWithFrame:CGRectMake(100,12,180,20)];
            classlabel.textAlignment=UITextAlignmentRight;
            [cell.contentView addSubview:classlabel];
            classlabel.backgroundColor=[UIColor clearColor];
            classlabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
            classlabel.text=user.className;
            [classlabel release];
            
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"School", @"学校");
            
            
            UILabel *schoollabel=[[UILabel alloc]init];
            [schoollabel setNumberOfLines:0];
            schoollabel.text = user.schoolname;
            UIFont  *font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
            schoollabel.font=font;
            CGSize constraint = CGSizeMake(180, 20000.0f);
            CGSize size = [schoollabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
            schoollabel.numberOfLines=0;
            [schoollabel setFrame:CGRectMake(100,12,180, size.height)];
            schoollabel.textAlignment=UITextAlignmentRight;
            [cell.contentView addSubview:schoollabel];
            schoollabel.backgroundColor=[UIColor clearColor];
            [schoollabel release];
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"fuwuzhuangtai", @"服务状态");
            
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:user.orderEndTime.integerValue];
            NSDateFormatter *f = [[[NSDateFormatter alloc] init] autorelease];
            [f setDateFormat:@"yyyy-MM-dd"];
            
            
            UILabel  *orderlabel=[[UILabel alloc]initWithFrame:CGRectMake(100,12,180,20)];
            orderlabel.textAlignment=UITextAlignmentRight;
            [cell.contentView addSubview:orderlabel];
            orderlabel.backgroundColor = [UIColor clearColor];
            orderlabel.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
            orderlabel.text = [NSString stringWithFormat:@"%@%@",[f stringFromDate:d],LOCAL(@"daoqi", @"到期")];
            [orderlabel release];
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if(indexPath.row==0)
        {
            MTCustomActionSheet *action=[[MTCustomActionSheet alloc]initWithTitle:LOCAL(@"changeavadar", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
            [action showInView:self.view.window];
            action.tag=101;
            [action release];
            
        }
        else if (indexPath.row==1)
        {
            ETNicknameViewController  *nicknameviewcontroller=[[ETNicknameViewController alloc]initWithNibName:@"ETNicknameViewController" bundle:nil];
            nicknameviewcontroller.delegate = self;
            AppDelegate *appDel = SHARED_APP_DELEGATE;
            [appDel.bottomNav pushViewController:nicknameviewcontroller animated:YES];
            [nicknameviewcontroller release];
            
        }
        else if (indexPath.row==2)
        {
            
            MTCustomActionSheet *action = [[MTCustomActionSheet alloc] initWithTitle:LOCAL(@"Gender",@"") delegate:self cancelButtonTitle:LOCAL(@"cancel",@"") otherButtonTitles:LOCAL(@"prince",@""),LOCAL(@"Princess",@""), nil];
            [action showInView:self.view.window];
            action.tag = 102;
            [action release];
            
        }
        else if (indexPath.row==3)
        {
            NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
            [formate setDateFormat:@"yyyy-MM-dd"];
            MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:[formate dateFromString:birthdaylabel.text]];
            sheet.delegate = self;
            
            [sheet showInView:self.view.window];
            [sheet release];
            //            NSString *lan= NSLocalizedString(@"Lanague", @"2");
            //            if([lan isEqualToString:@"1"])
            //            {
            //                datepick.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            //            }
            //            else
            //            {
            //                datepick.locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            //            }
            //            [datepick.locale release];
            //
        }
    }

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
            [appDel.bottomNav presentModalViewController:picker animated:YES];
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
            [appDel.bottomNav presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
    else if (actionSheet.tag == 102)
    {
        UserLogin *user=[UserLogin currentLogin];
        if ([user.sex isEqualToString:@"1"])
        {
            //如果性别是男 点击修改为女 发送数据
            if (index == 1)
            {
                ETCommonClass *com = [[[ETCommonClass alloc] init]autorelease];
                
                [com requestLoginWithComplete:^(NSError *err){
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"sex",nil];
                    [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
                }];
                
                
                
            }
            
        }
        else if ([user.sex isEqualToString:@"2"])
        {
            if (index == 0)
            {
                ETCommonClass *com = [[[ETCommonClass alloc] init]autorelease];
                
                [com requestLoginWithComplete:^(NSError *err){
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"sex",nil];
                    [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
                }];
            }
            
        }
    }
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    UserLogin *user = [UserLogin currentLogin];
    
    NSLog(@"error code   %d,%@",code,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    
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
    
    else if (method == student) {
        if (code == 1)
        {
            NSString *sex = [NSString stringWithFormat:@"%@",[param objectForKey:@"sex"]];
            NSString *birthday = [NSString stringWithFormat:@"%@",[param objectForKey:@"birthday"]];
            NSString *muti = [NSString stringWithFormat:@"%@",[param objectForKey:@"allow_muti_online"]];
            
            
            if ([sex isEqualToString:@"2"])
            {
                //成功修改为 女
                user.sex = @"2";
                
            }
            else if ([sex isEqualToString:@"1"])
            {
                //成功修改为 男
                
                user.sex = @"1";
                
            }
            
            if (![birthday isEqualToString:@"(null)"]) {
                user.birthday = birthday;
                
                NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *birDate = [formatter dateFromString:birthday];
                int second = [[NSDate date] timeIntervalSinceDate:birDate];
                user.age =[NSString stringWithFormat:@"%d", second / (3600 * 24 * 365) + 1];
                
                
            }
            
            if ([muti isEqualToString:@"1"])
            {
                user.allowmutionline = @"1";
                
                
            }
            else if ([muti isEqualToString:@"2"])
            {
                user.allowmutionline = @"2";
                
                
            }
            
            //            secure.userInteractionEnabled = YES;
            
            [ETCoreDataManager saveUser];
            
            [self.mainTV reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHILDINFO" object:nil];
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else
        {
            //            secure.userInteractionEnabled = YES;
            //            [secure setOn:!secure.isOn animated:YES];
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [self.mainTV reloadData];
        
    }
    
    else if (method == avatar)
    {
        if(code == 1)
        {
            
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            user.avatar = result;
            
            [ETCoreDataManager saveUser];
            
            [self.mainTV reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHILDINFO" object:nil];
            
        }
        else
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
    
    
    
}
- (void)getErrorInfo:(NSError *)error
{
    //    secure.userInteractionEnabled = YES;
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [self.mainTV reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    imgV.image = image;
    //    [self.view addSubview:imgV];
    //    [imgV release];
    
    
    [self saveImage:image];
    
    
}
- (void)saveImage:(UIImage *)image
{
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    
    if(HUD==nil)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
        HUD.labelText=LOCAL(@"upload", @"正在上传头像");   //@"正在上传头像";
        [delegate.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [[EKRequest Instance] EKHTTPRequest:avatar parameters:param requestMethod:POST forDelegate:self];
    [base64 release];
}



- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index selectDate:(NSDate *)date
{
    if (index == 1) {
//        NSLog(@"%f",[date timeIntervalSinceNow]);
        if ([date timeIntervalSinceNow] > 0) {
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"rightdate", @"请设置正确的生日日期") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        UserLogin *user = [UserLogin currentLogin];
        
        NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *birStr = [formatter stringFromDate:date];
        
        if ([birStr isEqualToString:user.birthday]) {
            return;
        }
        
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com requestLoginWithComplete:^(NSError *err){
            NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:birStr,@"birthday",nil];
            
            [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
        }];
    }
    
}

#pragma mark --------- ETNickNameViewController Delegate ----------
- (void)changeNicknameSuccess
{
    [self.mainTV reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

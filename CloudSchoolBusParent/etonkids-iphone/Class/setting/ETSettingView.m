//
//  ETSettingView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-26.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETSettingView.h"
#import "UserLogin.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#import "ETBackgroundViewController.h"
#import "ETRePassWordViewController.h"
#import "ETCoreDataManager.h"
#import "ETCommonClass.h"
#import "GTMBase64.h"
#import "ETPasswordManagerViewController.h"
#import "ETChildManagerViewController.h"
#import "AboutOursViewController.h"
#import "ETHelpViewController.h"
#import "GKMovieCache.h"

#define VersionAlert 996


@implementation ETSettingView

@synthesize mainTV,mutiOnline,imageViewHead,requestArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        middleLabel.text = LOCAL(@"Settings", @"");
        
//        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height) style:UITableViewStyleGrouped];
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.frame.size.height - NAVIHEIGHT) style:UITableViewStyleGrouped];
//        tv.backgroundView.backgroundColor = CELLCOLOR;
        tv.backgroundView = nil;
        tv.backgroundColor = CELLCOLOR;
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        [tv release];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipe];
        [swipe release];
        
        self.mainTV = tv;
        
        self.requestArray = [NSMutableArray array];
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 4;
            
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLogin *user = [UserLogin currentLogin];
    
    static NSString *CellIdentifier = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row==0)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Background",@"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//            if ([cell.contentView viewWithTag:345])
//            {
//                [[cell.contentView viewWithTag:345] removeFromSuperview];
//            }
        }
        if (indexPath.row==1)
        {
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=LOCAL(@"Password",@"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//            if ([cell.contentView viewWithTag:345])
//            {
//                [[cell.contentView viewWithTag:345] removeFromSuperview];
//            }
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = LOCAL(@"SecureSetting", @"");
            //              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (![cell.contentView viewWithTag:345]) {
                secure = [[UISwitch alloc] initWithFrame:CGRectMake(210 + (ios7?45:0), 6, 60, 30)];
                secure.tag = 345;
                
                UserLogin *user = [UserLogin currentLogin];
                
                if ([user.allowmutionline isEqualToString:@"1"]) {
                    //允许多人在线
                    [secure setOn:YES];
                }else{
                    [secure setOn:NO];
                }
                [secure addTarget:self action:@selector(doMutiOnline:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:secure];
                [secure release];
            }
            
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            float size = [GKMovieCache getSize]/1024.0f/1024.f;
            cell.textLabel.text = [NSString stringWithFormat:@"%@   ( %.2f M )", LOCAL(@"clearCache", @""),size];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = LOCAL(@"btm_newversion",@"");
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = LOCAL(@"About Us", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = LOCAL(@"setting_help", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    
    
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UserLogin *user = [UserLogin currentLogin];
    AppDelegate *app = SHARED_APP_DELEGATE;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            ETBackgroundViewController *bgVC = [[ETBackgroundViewController alloc] init];
            [app.bottomNav pushViewController:bgVC animated:YES];
            [bgVC release];
        }
        else if (indexPath.row == 1)
        {
            ETPasswordManagerViewController *pmVC = [[ETPasswordManagerViewController alloc] init];
            [app.bottomNav pushViewController:pmVC animated:YES];
            [pmVC release];
        }
        
    }
    if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"confirmClear", @"")  delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"ok", @""), nil];
            [alert show];
        }
        else if(indexPath.row == 1)
        {
            [self checkVersion];
        }
        else if (indexPath.row == 2)
        {
            AboutOursViewController *aboutVC = [[AboutOursViewController alloc] init];
            [app.bottomNav pushViewController:aboutVC animated:YES];
            [aboutVC release];
        }
        else if (indexPath.row == 3)
        {
            ETHelpViewController *aboutVC = [[ETHelpViewController alloc] init];
            [app.bottomNav pushViewController:aboutVC animated:YES];
            [aboutVC release];
        }
    }
    
    
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 1) {
        NSLog(@"clear cache ");
        [GKMovieCache clearDiskCache];
        
        [self.mainTV reloadData];
    }
}

- (void)checkVersion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL * url=[NSURL URLWithString:LOCAL(@"checkversion", @"")];
        
        NSData *data=  [NSData dataWithContentsOfURL:url];
        // NSString *string=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if(data)
            {
                NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                // NSLog(@"dic=%@",dic);
                
                NSArray * array=[dic objectForKey:@"results"];
                if ([array count]==0||array==nil) {
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"Check New Version", @"提示") message:NSLocalizedString(@"currentVersion", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    return;
                }
                NSString * verson=[[array objectAtIndex:0]objectForKey:@"version"];
                NSString *releaseNode=nil;
                releaseNode=[[array objectAtIndex:0]objectForKey:@"releaseNotes"];
                if(releaseNode==nil)
                    releaseNode=[[array objectAtIndex:0]objectForKey:@"description"];
                // NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//                NSRange range=[verson rangeOfString:currentVersion];
                
                if(![verson isEqualToString:currentVersion])
                {
                    
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"Check New Version", @"提示") message:releaseNode delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"shengji", @""), nil];
                    alert.delegate=self;
                    alert.tag = VersionAlert;
                    [alert show];
                    
                    
                }
                else
                {
                    ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:NSLocalizedString(@"Check New Version", @"提示") message:NSLocalizedString(@"currentVersion", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                
                
            }
            
        });
        // [self performSelectorOnMainThread:@selector(uploadUI:) withObject:string waitUntilDone:YES];
        // [string release];
        
        
    });
    
    
}



- (void)doMutiOnline:(UISwitch *)sender
{
    NSString *str;
    if (sender.isOn) {
        str = @"1";//允许多人.
    }
    else
    {
        str = @"2";//不允许.
    }
    
    secure.userInteractionEnabled = NO;
    
    ETCommonClass *com = [[[ETCommonClass alloc] init]autorelease];
    
    [com requestLoginWithComplete:^(NSError *err){
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"allow_muti_online", nil];
        [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
        
    }];
    
    
}

//- (void)leftButtonClick:(UIButton *)sender
//{
//    [UIView animateWithDuration:0.3f animations:^{
//        self.frame = CGRectMake(320, RIGHTMARGIN, self.frame.size.width, self.frame.size.height);
//    }completion:^(BOOL finished) {
////        [self removeFromSuperview];
//    }];
//}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    UserLogin *user = [UserLogin currentLogin];
    
    NSLog(@"error code   %d",code);
    
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
            
            secure.userInteractionEnabled = YES;
            
            [ETCoreDataManager saveUser];
                 
            [self.mainTV reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHILDINFO" object:nil];
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else
        {
            secure.userInteractionEnabled = YES;
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
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            user.avatar = result;
            
            [ETCoreDataManager saveUser];
            
            [self.mainTV reloadData];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"CHILDINFO" object:nil];
            
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
    secure.userInteractionEnabled = YES;
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [self.mainTV reloadData];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
    [self saveImage:image];

    
}
- (void)saveImage:(UIImage *)image
{
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [[EKRequest Instance] EKHTTPRequest:avatar parameters:param requestMethod:POST forDelegate:self];
    [base64 release];
}

#pragma mark --------- ETNickNameViewController Delegate ----------

- (void)changeNicknameSuccess
{
    [self.mainTV reloadData];
}




- (void)dealloc
{
    self.mainTV = nil;
    self.imageViewHead = nil;
    self.mutiOnline = nil;
    self.requestArray = nil;
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

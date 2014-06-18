

#import "ETTableViewHeaderView.h"
#import "UserLogin.h"
#import "UIImageView+WebCache.h"
#import "keyedArchiver.h"
#import "Modify.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import "ETCommonClass.h"
#import "GTMBase64.h"


@implementation ETTableViewHeaderView
@synthesize photoImageView,nameLabel,ageLabel,englishNameLabel,classLabel;
@synthesize delegate;
@synthesize schoolLabel,imageBgView,ageBack;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildBirthdayFrame) name:@"UPDATEBIRTHDAY" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildInfo:) name:@"CHILDINFO" object:nil];
        
       // UserLogin *user = [UserLogin currentLogin];
        
        
        UIImageView *infoBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 14 , 320, 28)];
        infoBar.image =[UIImage imageNamed:@"infoBar.png"];
        [self addSubview:infoBar];
        [infoBar release];
        

        photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, self.frame.size.height/2 - 38, 65, 65)];
        photoImageView.backgroundColor=[UIColor clearColor];
        photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        photoImageView.layer.borderWidth = 2;
        photoImageView.layer.cornerRadius = 20.0f;
        photoImageView.userInteractionEnabled=YES;
        photoImageView.layer.shouldRasterize = YES;
        photoImageView.layer.masksToBounds = YES;
        
        [self addSubview:photoImageView];
        [photoImageView release];
        
        
        
        
//        NSLog(@"%@,%@",user.birthday,[format stringFromDate:[NSDate date]]);

        
        birthdayImgV = [[UIImageView alloc] initWithFrame:CGRectMake(photoImageView.frame.origin.x + photoImageView.frame.size.width - 18,
                                                                     photoImageView.frame.origin.y - 6,
                                                                     24,
                                                                     24)];
        birthdayImgV.image = [UIImage imageNamed:@"birthdayIcon.png"];
        [self addSubview:birthdayImgV];
        [birthdayImgV release];

        nameLabel=[[UILabel alloc]init];
        nameLabel.frame = CGRectMake(95, self.frame.size.height/2 - 10, 90, 20);
        nameLabel.text=@"";
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:nameLabel];
        [nameLabel release];
        
        UserLogin *user = [UserLogin currentLogin];
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"MM-dd";
        
//        NSLog(@"user birthday : %@ , %@",[user.birthday substringFromIndex:5],[format stringFromDate:[NSDate date]]);
        
        if ([[user.birthday substringFromIndex:5] isEqualToString:[format stringFromDate:[NSDate date]]])
        {
//            nameLabel.frame = CGRectMake(120, self.frame.size.height/2 - 10, 90, 20);
            birthdayImgV.hidden = NO;
        }
        else
        {
//            nameLabel.frame = CGRectMake(95, self.frame.size.height/2 - 10, 90, 20);
            birthdayImgV.hidden = YES;
        }
        
        
        ageBack = [[UIImageView alloc] initWithFrame:CGRectMake(13,
                                                                photoImageView.frame.origin.y + photoImageView.frame.size.height + 10,
                                                                65,
                                                                20)];
        ageBack.image = [UIImage imageNamed:@"ageBack.png"];
        [self addSubview:ageBack];
        [ageBack release];
        
        
        ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(6,
                                                          -2,
                                                          50,
                                                          20)];
        ageLabel.text=@"";
        ageLabel.font=[UIFont systemFontOfSize:12];
        ageLabel.adjustsFontSizeToFitWidth = YES;
        ageLabel.textAlignment = UITextAlignmentCenter;
        ageLabel.textColor=[UIColor whiteColor];
        ageLabel.backgroundColor=[UIColor clearColor];
        [ageBack addSubview:ageLabel];
        
//        schoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(320 - 120, nameLabel.frame.origin.y, 120, 40)];
//        schoolLabel.backgroundColor=[UIColor clearColor];
//        schoolLabel.font=[UIFont systemFontOfSize:16];
//        schoolLabel.textColor=[UIColor whiteColor];
//        schoolLabel.lineBreakMode=NSLineBreakByCharWrapping
//        [schoolLabel setNumberOfLines:0];
//        schoolLabel.textAlignment=UITextAlignmentCenter;
//        schoolLabel.text=ModifyData.Schoolname;
//        [self addSubview:schoolLabel];
        
        
        classLabel=[[UILabel alloc]initWithFrame:CGRectMake(320 - 110, nameLabel.frame.origin.y, 100, 20)];
        classLabel.text=@"";
        classLabel.font=[UIFont systemFontOfSize:14];
        classLabel.textColor=[UIColor whiteColor];
        classLabel.backgroundColor=[UIColor clearColor];
        classLabel.textAlignment=UITextAlignmentRight;
        [self addSubview:classLabel];
        
        [classLabel release];
        
        
        
        UITapGestureRecognizer *Recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
        [photoImageView addGestureRecognizer:Recognizer];
        [Recognizer release];

    }
    return self;
}
-(void)backgroundImage:(NSNotification*)notification
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerimage = [userDefault objectForKey:@"HEADERBACKGROUND"];
    if(headerimage != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerimage];
        imageBgView.image=headerImg;
    }
}


-(void)back:(UIButton *)button
{
  if(delegate&&[delegate respondsToSelector:@selector(headerViewBackButtonClick)])
  {
      [delegate headerViewBackButtonClick];
  }
}


- (void)changePhoto:(UITapGestureRecognizer *)sender
{
    MTCustomActionSheet *action=[[MTCustomActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
    action.tag=2;
    [action showInView:self.window];
    [action release];
}

-(void)photo:(NSNotification *)no
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerData = [userDefault objectForKey:@"HEADERPHOTO"];
    if(headerData != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerData];
        [photoImageView setImage:headerImg];
    }
}
-(void)CHANGE:(NSNotification*)no
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerimage = [userDefault objectForKey:@"HEADERBACKGROUND"];
    if(headerimage != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerimage];
        imageBgView.image=headerImg;
    }
 
}
-(void)updateChildInfo:(NSNotification *) notification
{
    UserLogin * user = [UserLogin currentLogin];
    nameLabel.text = user.nickname;
    
    ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
    classLabel.text = user.className;
    
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"MM-dd";
    if ([[user.birthday substringFromIndex:5] isEqualToString:[format stringFromDate:[NSDate date]]])
    {
        birthdayImgV.hidden = NO;
    }
    else
    {
        birthdayImgV.hidden = YES;
    }
    
    
    NSLog(@"photo : %@",user.avatar);
    
    [photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] options:SDWebImageRefreshCached|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        photoImageView.image = image;
        
    }];
    
}

- (void)updateChildBirthdayFrame
{
    UserLogin *user = [UserLogin currentLogin];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"yyyy-MM-dd";
    if ([user.birthday isEqualToString:[format stringFromDate:[NSDate date]]])
    {
        nameLabel.frame = CGRectMake(120, nameLabel.frame.origin.y, 90, 20);
        birthdayImgV.hidden = NO;
    }
    else
    {
        nameLabel.frame = CGRectMake(95, nameLabel.frame.origin.y, 90, 20);
        birthdayImgV.hidden = YES;
    }
}


#pragma UIImagePickerController_Delegate
- (void)saveImage:(UIImage *)image
{
    
    if(HUD==nil)
    {
        AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:del.window];
        HUD.labelText=LOCAL(@"upload", @"正在上传头像");   //@"正在上传头像";
        [del.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    
    
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [base64 release];
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        [[EKRequest Instance] EKHTTPRequest:avatar parameters:param requestMethod:POST forDelegate:self];
    }];
    
    
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    UserLogin *user = [UserLogin currentLogin];
    
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
    else if(method ==avatar)
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
        if(code == 1)
        {
            
            //修改userlogin avatar
            
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            NSLog(@"photo : %@",result);
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            
            user.avatar = result;
            [result release];
            [ETCoreDataManager saveUser];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHILDINFO" object:nil];
            
            
        }
    }
    

}

- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    if(index==0)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
            return;
        }
        //TabBarHidden//0
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        AppDelegate *del= SHARED_APP_DELEGATE;
        [del.bottomNav presentModalViewController:picker animated:YES];
        [picker release];
        
        
    }
    if(index==1)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        AppDelegate *del= SHARED_APP_DELEGATE;
        [del.bottomNav presentModalViewController:picker animated:YES];
        [picker release];
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UPDATEBIRTHDAY" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CHILDINFO" object:nil];
    self.nameLabel=nil;
    self.englishNameLabel=nil;
    self.ageLabel=nil;
    self.classLabel=nil;
    self.photoImageView=nil;
    [super dealloc];
}

@end

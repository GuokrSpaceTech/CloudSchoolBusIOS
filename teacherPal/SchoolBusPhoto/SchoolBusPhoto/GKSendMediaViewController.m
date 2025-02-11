//
//  GKSendMediaViewController.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSendMediaViewController.h"
#import "GKUserLogin.h"
#import "GKFilterViewController.h"
#import "GKLoaderManager.h"

#import "DBManager.h"
#import "MovieDraft.h"


@interface GKSendMediaViewController ()

@end

@implementation GKSendMediaViewController
@synthesize stuList,sourcePicture,thumbnail,moviePath,isPresent;
@synthesize photoTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isPresent = NO;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isMove=NO;
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.moviePath != nil)
    {
        self.titlelabel.text =NSLocalizedString(@"MovieUp", @""); //@"上传视频";
    }
    else if (self.sourcePicture != nil)
    {
        self.titlelabel.text = NSLocalizedString(@"UpPic", @"");
    }
    self.istrain=@"0";
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame=CGRectMake(320 - 50, 5, 50, 35);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:sendButton];
    [sendButton addTarget:self action:@selector(uploadMedia:) forControlEvents:UIControlEventTouchUpInside];
    
    // 背景 框
    UIImageView *boardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    boardImageView.center = CGPointMake(160, navigationView.frame.origin.y + navigationView.frame.size.height + 15 + boardImageView.frame.size.height/2.0f);
    boardImageView.image = IMAGENAME(IMAGEWITHPATH(@"视频框(1)"));
    [self.view addSubview:boardImageView];
    [boardImageView release];
    
    // 缩略图
    thumbImgV = [[UIImageView alloc] initWithFrame:CGRectMake(boardImageView.frame.origin.x + 15, boardImageView.frame.origin.y + 15, 60, 60)];
    if (self.sourcePicture != nil)
    {
        thumbImgV.image = self.sourcePicture;
    }
    else
    {
        thumbImgV.image = self.thumbnail;
    }
    [self.view addSubview:thumbImgV];
    
    UIButton *presetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [presetBtn setFrame:thumbImgV.frame];
    if (self.moviePath != nil)
    {
        [presetBtn setImage:[UIImage imageNamed:@"moviepresetplay.png"] forState:UIControlStateNormal];
    }
    [presetBtn addTarget:self action:@selector(presetMedia:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presetBtn];

    
    contentTV = [[UITextView alloc] initWithFrame:CGRectMake(thumbImgV.frame.origin.x + thumbImgV.frame.size.width + 10, thumbImgV.frame.origin.y - 7, 200, 90)];
    contentTV.text = NSLocalizedString(@"descripe", @"");
    contentTV.delegate = self;
    contentTV.font = [UIFont systemFontOfSize:15];
    contentTV.textColor = [UIColor grayColor];
    contentTV.backgroundColor = [UIColor whiteColor];
    contentTV.returnKeyType = UIReturnKeyDone;
//    contentTV.inputAccessoryView = inputView;
//    [inputView release];
    [self.view addSubview:contentTV];
    
    // 计数 label
    calWordsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    calWordsLab.backgroundColor = [UIColor clearColor];
    calWordsLab.textAlignment = NSTextAlignmentCenter;
    calWordsLab.text = @"0/280";
    calWordsLab.font = [UIFont systemFontOfSize:15];
    calWordsLab.center = CGPointMake(thumbImgV.center.x, thumbImgV.frame.origin.y + thumbImgV.frame.size.height + 12);
    [self.view addSubview:calWordsLab];
    
    
      GKUserLogin *user=[GKUserLogin currentLogin];
    
    
    NSInteger col=([user.studentArr count] )/4; //行
    //int row=([user.studentArr count] )%4;
    NSInteger y = MIN(col+1, 4);
    
    
    GKStudentView *studentView=[[GKStudentView alloc]initWithFrame:CGRectMake(0, (iphone5 ? 548 : 460) + (ios7 ? 20 : 0) - (y*55), 320,( y*55))];
    studentView.backgroundColor=[UIColor whiteColor];
    studentView.delegate=self;
    studentView.studentArr=user.studentArr;
    [self.view addSubview:studentView];
    [studentView release];

    GKPhotoTagScrollView *tagView = [[GKPhotoTagScrollView alloc] initWithFrame:CGRectMake(boardImageView.frame.origin.x - 5, boardImageView.frame.origin.y + boardImageView.frame.size.height + 5, boardImageView.frame.size.width + 10,(iphone5 ? 548 : 460) + (ios7 ? 20 : 0)-studentView.frame.size.height-boardImageView.frame.size.height-boardImageView.frame.origin.y-5)];

    tagView.backgroundColor = [UIColor clearColor];
    tagView.tagDelegate = self;
    [self.view addSubview:tagView];
    [tagView release];
    
    
    
    //GKUserLogin *user=[GKUserLogin currentLogin];
    
    [tagView setPhotoTags:user.photoTagArray];
    

    if(user.istrain==1)
    {
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"register.png"] forState:UIControlStateNormal];
        [registerBtn setFrame:CGRectMake(10, 100, 50, 50)];
        [registerBtn addTarget:self action:@selector(registerBtbClicik:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
        [registerBtn addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchDragExit];
        [self.view addSubview:registerBtn];
    }
    

    self.photoTag=[NSMutableArray array];

    self.stuList = [NSMutableArray array];
    
}
-(void)registerBtbClicik:(UIButton *)btn
{
    if(isMove==NO)
    {
        if([self.istrain isEqualToString:@"0"])
        {
            self.istrain=@"1";
            [registerBtn setBackgroundImage:[UIImage imageNamed:@"registerH.png"] forState:UIControlStateNormal];
        }
        else
        {
            self.istrain=@"0";
            [registerBtn setBackgroundImage:[UIImage imageNamed:@"register.png"] forState:UIControlStateNormal];
        }
        NSLog(@"单击");
    }
    isMove=NO;
}
- (void) dragMoving: (UIControl *) c withEvent:(UIEvent *)ev
{
    NSLog(@"移动");
    isMove=YES;
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
}

- (void) dragEnded: (UIControl *) c withEvent:(UIEvent *)ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
}
- (void)endEdit:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"descripe", @"")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"descripe", @"");
        textView.textColor = [UIColor grayColor];
    }
    return YES;
}

- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        //        NSLog(@"%d",[character lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number+=2;
        }
        else
        {
            number++;
        }
    }
    return number;
}

- (void)textViewDidChange:(UITextView *)textView
{
    int a= [self textLength:textView.text];
    
//    NSLog(@"%d",a);
    calWordsLab.text=[NSString stringWithFormat:@"%d/280",a];
    
    if(a>280)
    {
        calWordsLab.textColor=[UIColor redColor];;
    }
    else
    {
        calWordsLab.textColor=[UIColor blackColor];
    }
}

- (void)showBigImage:(UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

- (void)presetMedia:(id)sender
{
    [self.view endEditing:YES];
    
    GKFilterViewController *fvc = [[GKFilterViewController alloc] init];
    fvc.isPreview = NO; // 不是预览页面.
    if (self.sourcePicture != nil)
    {
        //显示图片
        fvc.sourceImage = self.sourcePicture;
    }
    else
    {
        //播放视频
        
        NSArray *arr=[self.moviePath componentsSeparatedByString:@"/"];
        NSString *pathForName= [arr lastObject];
        
        NSArray *searchPathArr= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentpath=[searchPathArr objectAtIndex:0];
        NSString* filenamePath = [documentpath stringByAppendingPathComponent:pathForName];

        
        fvc.moviePath = filenamePath;
    }
    //[self presentModalViewController:fvc animated:YES];
    
    [self presentViewController:fvc animated:YES completion:^{
        
    }];
    [fvc release];
    
}

-(void)whitchSelected:(BOOL)selected uid:(NSString *)uid isAll:(int)an
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    
//    NSLog(@"%d,%d",selected,an);
    
    
    if (an == 0)    // 默认单选
    {
        
        if (selected) //选中
        {
            [stuList addObject:uid];
        }
        else     // 取消选中
        {
            [stuList removeObject:uid];
        }
        
    }
    else if (an == 1)  // 选择全部
    {
        [stuList removeAllObjects];
        
        for (int i=0; i<[user.studentArr count]; i++) {
            Student *st=[user.studentArr objectAtIndex:i];
            [stuList addObject:[NSString stringWithFormat:@"%@",st.studentid]];
        }
        
    }
    else if (an == 2)  //取消全部
    {
        [stuList removeAllObjects];
    }
    
    NSLog(@"%@",stuList);
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)uploadMedia:(id)sender
{
    
    [self.view endEditing:YES];
    
    if (![self checkContentLength])
    {
        return;
    }
    
    if (self.stuList.count == 0)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"selectstuent", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        return;
    }
    
    
    GKLoaderManager *manager = [GKLoaderManager createLoaderManager];
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    NSString *timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    
    NSString *filePath;
    NSInteger fise=0;
    if (self.sourcePicture != nil)
    { //上传图片.
        
        NSData *imageData = UIImageJPEGRepresentation(self.sourcePicture, 1.0);
        fise=[imageData length];
        NSArray *arr= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentpath=[arr objectAtIndex:0];
        NSString *filename=[NSString stringWithFormat:@"tempimage%@",timestamp];
        filePath=[NSString stringWithFormat:@"%@/%@",documentpath,filename];
        NSFileManager *fileManage=[NSFileManager defaultManager];
        if(![fileManage fileExistsAtPath:filePath])
        {
            [fileManage createFileAtPath:filePath contents:nil attributes:nil];
        }
        else
        {
            NSLog(@"image write path has been exist");
            return;
        }
        BOOL success = [imageData writeToFile:filePath atomically:YES];
        
        if (!success) {
            NSLog(@"image write path error ");
            return;
        }
    }
    else
    {
        //上传视频.
        // 计算文件大小
        NSFileManager *fileManage=[NSFileManager defaultManager];
        filePath = [NSString stringWithFormat:@"%@",self.moviePath];
        
        NSDictionary *fileAttributeDic=[fileManage attributesOfItemAtPath:filePath error:nil];
        
        fise= fileAttributeDic.fileSize;
        

        
    }
    
    NSString *students = [self.stuList componentsJoinedByString:@","];
    
   // NSLog(@"students %@ , photo tag : %@",students,(photoTag == nil ? @"" : photoTag));
    
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
   // textLabel.text = [format stringFromDate:createDate];
    
   // NSDateFormatter *data
    NSMutableString *temp=[[[NSMutableString alloc]init] autorelease];
    for (int i=0; i<[photoTag count]; i++) {
        NSString *str=[NSString stringWithFormat:@"%@",[photoTag objectAtIndex:i]];
        [temp appendFormat:@"%@,",str];
    }
    if([photoTag count]>0)
    [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1)];

    
    
    
    NSString *imageName=[format stringFromDate:createDate];//[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[timestamp intValue]]];
    NSNumber *teacherid=[NSNumber numberWithInteger:[user.teacher.teacherid integerValue]];
    [[DBManager shareInstance]insertObject:^(NSManagedObject *object) {
        UpLoader *aa=(UpLoader *)object;
        aa.image=filePath;
        aa.istrain=[NSNumber numberWithInteger:[self.istrain integerValue]];
        aa.nameID=[NSString stringWithFormat:@"draft%@",timestamp];
        aa.classUid=[NSNumber numberWithInteger:[user.classInfo.uid integerValue]];
        aa.name=imageName;
        aa.studentId=students;
        aa.fsize=[NSNumber numberWithInteger:fise];
        aa.ftime=[NSNumber numberWithInt:[timestamp intValue]];
        aa.introduce = ([contentTV.text isEqualToString:NSLocalizedString(@"descripe", @"")] ? @"" : contentTV.text);
        aa.tag=(([photoTag count]==0)?@"":temp);
        aa.isUploading=[NSNumber numberWithInt:1];
        aa.teacherid=teacherid;
        aa.smallImage=UIImageJPEGRepresentation(thumbImgV.image, 0.1);
        
    } entityName:@"UpLoader" success:^{
        
        NSLog(@"cccccfggggg");
        
        [manager addWraperToArr:filePath name:imageName iSloading:[NSNumber numberWithInt:1] nameId:[NSString stringWithFormat:@"draft%@",timestamp] studentId:students time:[NSNumber numberWithInt:[timestamp intValue]] fsize:[NSNumber numberWithInteger:fise] classID:[NSNumber numberWithInteger:[user.classInfo.uid integerValue]] intro:([contentTV.text isEqualToString:NSLocalizedString(@"descripe", @"")] ? @"" : contentTV.text) data:UIImageJPEGRepresentation(thumbImgV.image, 0.1) tag:(([photoTag count]==0)?@"":temp) teacherid:teacherid isregister:[NSNumber numberWithInteger:[self.istrain integerValue]]];
        
        
    } failed:^(NSError *err) {
        NSLog(@"ssssbbbbbbb");
    }];

   //[manager addNewPicToCoreData:filePath name:@"" iSloading:[NSNumber numberWithInt:1] nameId:[NSString stringWithFormat:@"draft%@",timestamp] studentId:students time:[NSNumber numberWithInt:[timestamp intValue]] fsize:[NSNumber numberWithInt:fise] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:contentTV.text data:UIImageJPEGRepresentation(thumbImgV.image, 0.1) tag:(photoTag == nil ? @"" : photoTag)] ;
    if (self.sourcePicture != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"zhaopianpinjiaruduilie",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"shipinjiaruduilie",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

    
    if (self.isPresent)
    {
      //  [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
       // [self.navigationController dismissModalViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    
    
    
    
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)doBack:(id)sender
{
    
    if (self.isPresent) {  //从视频草稿箱 推入界面
        
        if (![contentTV.text isEqualToString:@""] && ![contentTV.text isEqualToString:NSLocalizedString(@"descripe", @"")]) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"shifoutuichu",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease];
            [alert show];
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    
    if (self.moviePath != nil)
    {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"shifoubaocuncaogao",@"是否要保存到草稿箱") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"savedraft",@""),NSLocalizedString(@"dontsavedraft",@""), nil];
        [as showInView:self.view];
        [as release];
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // save draft
        NSString *stamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        
        GKUserLogin *user=[GKUserLogin currentLogin];
//        BOOL success = [GKCoreDataManager addMovieDraftWithUserid:[NSString stringWithFormat:@"%@", user.classInfo.classid] moviePath:self.moviePath dateStamp:stamp thumbnail:UIImageJPEGRepresentation(self.thumbnail, 0.1)];
//        NSLog(@"save draft : %d",success);
        
        [[DBManager shareInstance] insertObject:^(NSManagedObject *object) {
            
            MovieDraft *movie = (MovieDraft *)object;
            movie.createdate = stamp;
            movie.moviepath = self.moviePath;
            movie.userid = [NSString stringWithFormat:@"%@", user.classInfo.classid];
            movie.thumbnail = UIImageJPEGRepresentation(self.thumbnail, 0.1);
            
            
            
        } entityName:@"MovieDraft" success:^{
            
            NSLog(@"save draft success");
            
        } failed:^(NSError *err) {
            NSLog(@"save draft error %@",err);
        }];
        
        
       // [self.navigationController dismissModalViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else if (buttonIndex == 1)
    {
        //不保存
//        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] removeItemAtPath:self.moviePath error:nil];
        
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(void)didSelectPhotoTag:(NSInteger)tag tagstr:(NSString *)tagstr
{
    if([photoTag containsObject:[NSNumber numberWithInteger:tag]])
    {
        [photoTag removeAllObjects];
    }
    else
    {
        [photoTag addObject:[NSNumber numberWithInteger:tag]];
    }
    
    
    
}

//- (void)didSelectPhotoTag:(NSString *)tag
//{
//    self.photoTag = [NSString stringWithFormat:@"%@",tag];
//}

- (BOOL)checkContentLength
{
    int a = [self textLength:contentTV.text];
    if (a > 280) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    self.sourcePicture = nil;
    self.moviePath = nil;
    self.thumbnail = nil;
    self.stuList = nil;
    self.photoTag = nil;
    [super dealloc];
}

@end

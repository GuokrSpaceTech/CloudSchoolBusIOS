
//
//  GKShowViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-23.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKShowViewController.h"
#import "ETPhoto.h"
#import "GKLoaderManager.h"
#import "Student.h"
#import "GTMBase64.h"
#import "GKUpQueue.h"
#import "GKUserLogin.h"
#import "ETShowBigImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KKNavigationController.h"

#define TAG 1000

#define STUDENTCELLHEIGHT 50
@interface GKShowViewController ()

@end

@implementation GKShowViewController
@synthesize assetArr;
@synthesize type;
//alreadyArr@synthesize alreadyArr;
@synthesize stuList;
@synthesize delegate,tempStu,picTextArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
    
   //self.view.userInteractionEnabled=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    // 禁用 向左滑动
    UIPanGestureRecognizer*  recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    prePage=0;
    stuList = [[NSMutableArray alloc] init];
    picTextArr = [[NSMutableArray alloc] init];
    currentpage=0;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    

    
    photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame=CGRectMake(280, 5, 35, 35);
    [photobutton setBackgroundImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
    [photobutton setBackgroundImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
    [photobutton addTarget:self action:@selector(OKClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photobutton];
    
    titlelabel.text=NSLocalizedString(@"who", @"");
    [numbeLabel release];
    float aa=[[[UIDevice currentDevice]systemVersion]floatValue];
    if(aa>=6.0)
    {
        titlelabel.textAlignment=NSTextAlignmentCenter;
    }

    else
    {
        titlelabel.textAlignment=UITextAlignmentCenter;
        numbeLabel.textAlignment=UITextAlignmentRight;
    }
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    int col=([user.studentArr count] )/4; //行
    int y = MIN(col+1, 4);

    changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+46 + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)- (ios7 ? 20 : 0)-46)];
    changeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:changeView];
    [changeView release];
    
    UIView *txtView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, changeView.frame.size.width, changeView.frame.size.height)];
    txtView.tag = 1234;
    txtView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
    [changeView addSubview:txtView];
    [txtView release];

    picTxtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 320 - 20, txtView.frame.size.height - 100)];
    picTxtView.backgroundColor = [UIColor whiteColor];
    picTxtView.text = @"";
    picTxtView.font=[UIFont systemFontOfSize:16];
    picTxtView.layer.cornerRadius=5;
    picTxtView.delegate = self;
    [txtView addSubview:picTxtView];
    [picTxtView release];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    //apply
    [button setTitle:NSLocalizedString(@"apply", @"") forState:UIControlStateNormal];
    button.frame=CGRectMake(230, picTxtView.frame.origin.y+picTxtView.frame.size.height+5, 80, 40);
    
    UIImage *iamge=[[UIImage imageNamed:@"loginBtn"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
    
    [button setBackgroundImage:iamge forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(applyAll:) forControlEvents:UIControlEventTouchUpInside];
    [txtView addSubview:button];
    
    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, changeView.frame.size.width, changeView.frame.size.height)];
    picView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
    [changeView addSubview:picView];
    [picView release];
     
    if(ios7)
        _scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-IOS7OFFSET-46)];
    else
        _scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-IOS7OFFSET-46)];
    _scroller.backgroundColor=[UIColor whiteColor];
    [picView addSubview:_scroller];
    _scroller.contentSize=CGSizeMake([assetArr count] *320, _scroller.frame.size.height);
    _scroller.showsHorizontalScrollIndicator=NO;
    _scroller.showsVerticalScrollIndicator=NO;
    _scroller.pagingEnabled=YES;
    _scroller.delegate=self;
    [_scroller release];
    
    [self.view bringSubviewToFront:navigationView];
    
    
    if(ios7)
        textView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-20, self.view.frame.size.width, 20)];
    else
        textView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-20, self.view.frame.size.width, 20)];
    
    textView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:textView];
    [textView release];
    textView.hidden=YES;
 
    UIView * viewAlp=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    viewAlp.backgroundColor=[UIColor grayColor];
    viewAlp.alpha=0.8;
    [textView addSubview:viewAlp];
    [viewAlp release];

    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    label.backgroundColor=[UIColor clearColor];
    [textView addSubview:label];
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=[UIColor whiteColor];
    label.tag=9632;
    [label release];
    
    
    [self addImageViewToScroller:currentpage];
    
    
    if (studentView == nil) {
        studentView=[[GKStudentView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(y*STUDENTCELLHEIGHT), 320,y*STUDENTCELLHEIGHT)];
    
        studentView.backgroundColor=[UIColor whiteColor];
        studentView.delegate=self;
        [self.view addSubview:studentView];
        [studentView release];
    }
    
    studentView.studentArr=user.studentArr;
    

    numView=[[UIImageView alloc]initWithFrame:CGRectMake(320/2-58/2,navigationView.frame.size.height+navigationView.frame.origin.y+3, 58, 18)];
    numView.image=[UIImage imageNamed:@"photocount.png"];
    [self.view addSubview:numView];
    [numView release];
    
    numbeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 58, 18)];
    numbeLabel.backgroundColor=[UIColor clearColor];
    numbeLabel.text=[NSString stringWithFormat:@"1/%d",[assetArr count]];
    numbeLabel.font=[UIFont systemFontOfSize:15];
 
    if(IOSVERSION>=6.0)
        numbeLabel.textAlignment=NSTextAlignmentCenter;
    else
        numbeLabel.textAlignment=UITextAlignmentCenter;
    [numView addSubview:numbeLabel];
    [numbeLabel release];

    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"zhushi1.png"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"zhushi.png"] forState:UIControlStateHighlighted];
    [editBtn setFrame:CGRectMake(320 - 50, picView.frame.size.height-80, 50, 50)];
    [editBtn addTarget:self action:@selector(doEditText:) forControlEvents:UIControlEventTouchUpInside];
    [picView addSubview:editBtn];
    
    


}


-(void)applyAll:(UIButton *)btn
{
    if([picTxtView.text isEqualToString:@""])
    {
        return;
    }
    [picTextArr removeAllObjects];
    for (int i=0; i<[assetArr count]; i++) {
         NSString *key=[NSString stringWithFormat:@"%d",i];
         [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:picTxtView.text,key, nil]];
    }
    


}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    for (int i=0; i<[self.picTextArr count]; i++) {
        NSMutableDictionary *dic=[self.picTextArr objectAtIndex:i];
        NSString *keytemp = [[dic allKeys] objectAtIndex:0];
        if([key isEqualToString:keytemp])
        {
            [dic setObject:picTxtView.text forKey:key];
            break;
        }
        if (i == self.picTextArr.count - 1)
        {
            [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:picTxtView.text,key, nil]];
            break;
        }
    }
    if (self.picTextArr.count == 0) {

        [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:picTxtView.text,key, nil]];
    }
    
    NSLog(@"%@",self.picTextArr);
    
}

- (void)doEditText:(UIButton *)sender
    {
        [picTxtView resignFirstResponder];
        
        NSString *key=[NSString stringWithFormat:@"%d",currentpage];
        
        for (int i=0; i<[self.picTextArr count]; i++) {
            NSDictionary *dic=[self.picTextArr objectAtIndex:i];
            NSString *keytemp = [[dic allKeys] objectAtIndex:0];
            if([key isEqualToString:keytemp])
            {
                picTxtView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
                UILabel *label=(UILabel *)[textView viewWithTag:9632];
                label.text=[NSString stringWithFormat:@"%@",[dic objectForKey:key]];
                if([label.text isEqualToString:@""])
                        textView.hidden=YES;
                else
                      textView.hidden=NO;
            
                break;
            }
            picTxtView.text = @"";
        }
        UIView *visibleView = [[changeView subviews] objectAtIndex:1];
        if (visibleView.tag != 1234) {
            photobutton.hidden = YES;
            numView.hidden=YES;
            titlelabel.text=NSLocalizedString(@"story", @"");
            [picTxtView becomeFirstResponder];
            
              textView.hidden=YES;
        }
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:changeView cache:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [changeView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        [UIView commitAnimations];
    }

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101)
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
        else if (buttonIndex == 2)
        {
            ETNicknameViewController *nickVC = [[ETNicknameViewController alloc] init];
            nickVC.cstudent = self.tempStu;
            nickVC.delegate = self;
            [self.navigationController pushViewController:nickVC animated:YES];
            [nickVC release];
        }
    }
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
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",@"2",@"isstudent",tempStu.studentid,@"id",nil];
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
            
            GKUserLogin *user=[GKUserLogin currentLogin];
            for (Student *s in user.studentArr) {
                if (s.studentid.intValue == tempStu.studentid.intValue) {
                    s.avatar = result;
                 
                    break;
                }
            }
            studentView.studentArr = user.studentArr;
            [result release];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"avatorfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"avatorfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)didLongPressStudentButton:(GKButton *)button
{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"avatorM", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choose", @""),NSLocalizedString(@"NickName", @""), nil];
    [action showInView:self.view];
    action.tag=101;
    [action release];
    
    self.tempStu = button.student;
}

-(void)whitchSelected:(BOOL)selected uid:(NSString *)uid isAll:(int)an
{
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    if (an == 0)    // 默认单选
    {
        for (int i=0; i<[stuList count]; i++) {
            NSDictionary *dic=[stuList objectAtIndex:i];
            NSString *keytemp = [[dic allKeys] objectAtIndex:0];
            if([key isEqualToString:keytemp])
            {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:key]];
                
                if ([arr containsObject:uid]) {
                    [arr removeObject:uid];
                }else{
                    [arr addObject:uid];
                }
                
                
                NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:arr,key, nil];
                [stuList removeObject:dic];
                [stuList addObject:d];
                
                break;
            }
            if (i == stuList.count - 1)
            {
                [stuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:uid, nil],key, nil]];
                break;
            }
        }
        
        if (stuList.count == 0) {
            [stuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:uid, nil],key, nil]];
        }
        
    }
    else if (an == 1)  // 选择全部
    {
        for (int i=0; i<[stuList count]; i++) {
            NSDictionary *dic=[stuList objectAtIndex:i];
            NSString *keytemp = [[dic allKeys] objectAtIndex:0];
            if([key isEqualToString:keytemp])
            {
                [stuList removeObject:dic];
                break;
            }
        }
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<[user.studentArr count]; i++) {
            Student *st=[user.studentArr objectAtIndex:i];
            [arr addObject:[NSString stringWithFormat:@"%@",st.studentid]];
        }
        
        [stuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:arr,key, nil]];
    }
    else if (an == 2)  //取消全部
    {
        for (int i=0; i<[stuList count]; i++) {
            NSDictionary *dic=[stuList objectAtIndex:i];
            NSString *keytemp = [[dic allKeys] objectAtIndex:0];
            if([key isEqualToString:keytemp])
            {
                [stuList removeObject:dic];
                break;
            }
        }
    }
    
    NSLog(@"%@",stuList);

}


-(NSMutableString *)selectStudentID:(NSMutableArray *)arr
{
    NSMutableString *temp=[[NSMutableString alloc]init];
    for (int i=0; i<[arr count]; i++) {
        [temp appendFormat:@"%@,",[arr objectAtIndex:i]];
    }
    [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1)];
    return [temp autorelease];
}
-(void)addImageViewToScroller:(int)index
{
    if (index < 0 || index > self.assetArr.count - 1) {
        return;
    }
    UIImageView *iamgeView=(UIImageView *)[_scroller viewWithTag:index+TAG];
    if(iamgeView==nil)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(index*_scroller.frame.size.width, 0, _scroller.frame.size.width, _scroller.frame.size.height)];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.tag=index+TAG;
        //[self performSelectorInBackground:@selector(setPhotoImage:) withObject:imageView];
        if(type==1)
        {
            ETPhoto *photo=[assetArr objectAtIndex:index];
            NSData *data= UIImageJPEGRepresentation([UIImage imageWithCGImage:[[photo.asset defaultRepresentation] fullScreenImage]], 0.1);
            imageView.image=[UIImage imageWithData:data];
        }
        else
        {
            NSData *data= UIImageJPEGRepresentation([UIImage imageWithData:[assetArr objectAtIndex:index]], 0.1)   ;
            imageView.image= [UIImage imageWithData:data];
        }
   
        
        imageView.userInteractionEnabled = YES;
       // imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [_scroller addSubview:imageView];
        [imageView release];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
    }
    else
    {
        iamgeView.frame=CGRectMake(_scroller.frame.size.width*index, 0, _scroller.frame.size.width, _scroller.frame.size.height);
    }
}

- (void)showBigImage:(UIGestureRecognizer *)sender
{
    UIImageView *imgv = (UIImageView *)sender.view;
    ETShowBigImageViewController *showBigVC = [[ETShowBigImageViewController alloc] init];
    showBigVC.targetImage = imgv.image;
    [self presentModalViewController:showBigVC animated:YES];
    [showBigVC release];
}

//-(void)setPhotoImage:(UIImageView*)img
//{
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    if(type==1)
//    {
//        ETPhoto *photo=[assetArr objectAtIndex:img.tag - TAG];
//        NSData *data= UIImageJPEGRepresentation([UIImage imageWithCGImage:[[photo.asset defaultRepresentation] fullScreenImage]], 0.1);
//        img.image=[UIImage imageWithData:data];
//
//    }
//    else
//    {
//        NSData *data= UIImageJPEGRepresentation([UIImage imageWithData:[assetArr objectAtIndex:img.tag-TAG]], 0.1)   ;
//        img.image= [UIImage imageWithData:data];
//       
//    }
//    [pool release];
//    
//}
-(NSString *)fileName:(int)index
{
    int a=arc4random()%1000;
    NSDate *date=[NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d%d%d",(int)time,a,index];

}
-(void)OKClick:(UIButton *)btn
{
    // 吧改照片加入到coredata
    // 标记为正在上传
    for (int i=0; i<[stuList count]; i++) {
        
        NSDictionary *dic=[stuList objectAtIndex:i];
        
        NSMutableArray *arr=[dic objectForKey:[[dic allKeys] objectAtIndex:0]];
        if([arr count]==0)
        {
            // 有没有选择对象的
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"link", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return;
        }
    }
    
    if([stuList count] != [assetArr count])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"link", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    
    if(disappearView==nil)
    {
        disappearView=[[GKDisapperView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        disappearView.backgroundColor=[UIColor clearColor];
        disappearView.textLabel.text=NSLocalizedString(@"processing", @"");
        
        [[[[UIApplication sharedApplication] windows] lastObject]  addSubview:disappearView];
        [disappearView release];
    }
    [disappearView setactiveStop:NO];
    [self performSelectorInBackground:@selector(startUpLoaderInBackground) withObject:nil];
    NSLog(@"%d",currentpage);

 
}
-(void)startUpLoaderInBackground
{
    
    GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
    GKUserLogin *user=[GKUserLogin currentLogin];
    NSArray *arr= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath=[arr objectAtIndex:0];
    for (int i=0; i<[assetArr count]; i++)
    {

        if(type==1)
        {
            //相册
            
            ETPhoto *photo=[assetArr objectAtIndex:i];
            ALAssetRepresentation *representation = [photo.asset defaultRepresentation];
            NSString* filename = [documentpath stringByAppendingPathComponent:[representation filename]];
            UIImage *thumbiamge=[UIImage imageWithCGImage:photo.asset.thumbnail];
            [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
            NSOutputStream *outPutStream = [NSOutputStream outputStreamToFileAtPath:filename append:YES];
            [outPutStream open];
            long long offset = 0;
            long long bytesRead = 0;
            NSLog(@"%lld",representation.size);
            NSError *error;
            uint8_t * buffer = malloc(131072);
            while (offset<[representation size] && [outPutStream hasSpaceAvailable]) {
                bytesRead = [representation getBytes:buffer fromOffset:offset length:131072 error:&error];
                [outPutStream write:buffer maxLength:bytesRead];
                offset = offset+bytesRead;  
            }  
            [outPutStream close];  
            free(buffer);
           // NSLog(@"%@",photo.date);
            
                NSDate *date= [photo.asset valueForProperty:ALAssetPropertyDate];
//                photo.date=date;
            
            int ftime=[date timeIntervalSince1970];
            NSString *studentId=nil;
            NSString *key=[NSString stringWithFormat:@"%d",i];
            NSString *introduce = @"";
            
            for (int j=0; j<[stuList count]; j++)
            {
                NSDictionary *dic=[stuList objectAtIndex:j];
                NSString *tempKey=[[dic allKeys] objectAtIndex:0];
                if([key isEqualToString:tempKey])
                {
                    studentId=[self selectStudentID:[dic objectForKey:key]];
                    break;
                }
            }
            for (int j = 0; j < [picTextArr count]; j++) {
                NSDictionary *introduceDic = [picTextArr objectAtIndex:j];
                NSString *txtKey = [[introduceDic allKeys] lastObject];
                if([key isEqualToString:txtKey])
                {
                    if (txtKey != nil) {
                        introduce = [introduceDic objectForKey:txtKey];
                    }
                    break;
                }
            }
            
//            NSArray *keydd=[photo.asset valueForProperty:ALAssetPropertyRepresentations];
//            NSDictionary *dic=[photo.asset valueForProperty:ALAssetPropertyURLs];
//            NSString *pid= [NSString stringWithFormat:@"%@",[dic objectForKey:[keydd objectAtIndex:0]]];
            //               // NSLog(@"_____________%@",photo.nameId);
            
            
           // NSString *pid=[];
            [manager addNewPicToCoreData:filename name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5)];
            
            [manager addWraperToArr:filename name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5)];
            
            
            
   
            
            
        }
        else
        {
                NSData *data=[assetArr objectAtIndex:i];
                NSString *filename=[self fileName:i];
                NSString *path=[NSString stringWithFormat:@"%@/%@",documentpath,filename];
                NSFileManager *fileManage=[NSFileManager defaultManager];
                    if(![fileManage fileExistsAtPath:path])
                    {
                        [fileManage createFileAtPath:path contents:nil attributes:nil];
                    }
                [data writeToFile:path atomically:YES];
                int ftime=[[NSDate date]timeIntervalSince1970];
                NSLog(@"%d",ftime);
                
                NSDictionary *dic=[stuList objectAtIndex:0];
                NSString *studentId=[self selectStudentID:[dic objectForKey:[[dic allKeys] objectAtIndex:0]]];
            
                NSString *introduce = @"";
            
            if (picTextArr.count != 0) {
                NSDictionary *iDic = [picTextArr objectAtIndex:0];
                introduce = [iDic objectForKey:[[iDic allKeys] objectAtIndex:0]];
            }
            
            [manager addNewPicToCoreData:path name:filename iSloading:[NSNumber numberWithInt:1] nameId:filename studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:[data length]] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation([UIImage imageWithData:data], 0.1)] ;
            [manager addWraperToArr:path name:filename iSloading:[NSNumber numberWithInt:1] nameId:filename studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:[data length]] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation([UIImage imageWithData:data], 0.1)];
        }
    }
    
    [self performSelectorOnMainThread:@selector(toMainThread) withObject:nil waitUntilDone:YES];

}
-(void)toMainThread
{
    
    disappearView.textLabel.text=NSLocalizedString(@"processingafter", @"");
    [disappearView setactiveStop:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [delegate refreashPickViewController:assetArr] ;
    [self performSelector:@selector(delay) withObject:nil afterDelay:1];
    

}
-(void)delay
{
    
    if(disappearView!=nil)
    {
        [disappearView removeFromSuperview];
        disappearView=nil;
    }
  
    
}
-(void)upFinish
{

}
-(void)back:(UIButton *)btn
{
        UIView *visibleView = [[changeView subviews] objectAtIndex:1];
        if (visibleView.tag == 1234) {
            [picTxtView resignFirstResponder];
            photobutton.hidden = NO;
            titlelabel.text=NSLocalizedString(@"who", @"");
            numView.hidden=NO;
            [self doEditText:nil];
            
            
            
            
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"Cancelphotos", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
            [alert show];
            [alert release];
            
           // [self.navigationController popViewControllerAnimated:YES];
        }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [delegate refreashPickViewController:nil];
        [self.navigationController popViewControllerAnimated:YES];
  
    }
    else
    {
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    int x =scrollView.contentOffset.x;
    
    
    
    int num=x/_scroller.frame.size.width;
    
    int yu=x%(int)(_scroller.frame.size.width);
    
    if (yu == 0) {
        if(yu>_scroller.frame.size.width/2)
            num++;
        
        numbeLabel.text=[NSString stringWithFormat:@"%d/%d",++num,[assetArr count]];
        
        
        
        currentpage=num-1;
        
        if(prePage!=currentpage)
        {
            [studentView setAllButtonSelect:NO];
            
            prePage=currentpage;
        }
        
        
        // 设置 选过的页面
        //[self reloadScrollerImage];
        [self setAlreayStudent];
        
        [self addImageViewToScroller:currentpage - 1];
        [self addImageViewToScroller:currentpage];
        [self addImageViewToScroller:currentpage + 1];
        
        
        UIImageView * proV = (UIImageView*)[_scroller viewWithTag:TAG + currentpage];
        for ( UIImageView * item in _scroller.subviews ) {
            if ((item.tag - TAG < currentpage -1  ||item.tag - TAG > currentpage + 1)&&[item isKindOfClass:[UIImageView class]]&&proV != nil) {
                NSLog(@"removeFromSuperview---%d",item.tag);
                item.image=nil;
                [item removeFromSuperview];
                
                item = nil;
            }
        }

    }
    
    
    
}
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    return;
}
-(void)setAlreayStudent
{
    
  //  -(void)setAllButtonSelect:(BOOL)isselect;
     [studentView setAllButtonSelect:NO];
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    
    
       // label.tag=9632;//
    
    UILabel *label=(UILabel *)[textView viewWithTag:9632];
    
    
    NSString *introduce = @"";
    for (int j = 0; j < [picTextArr count]; j++) {
        NSDictionary *introduceDic = [picTextArr objectAtIndex:j];
        NSString *txtKey = [[introduceDic allKeys] lastObject];
        if([key isEqualToString:txtKey])
        {
            if (txtKey != nil) {
                introduce = [introduceDic objectForKey:txtKey];
            }
            break;
        }
    }

    label.text=introduce;
    if([label.text isEqualToString:@""])
        textView.hidden=YES;
    else
    textView.hidden=NO;
    
    for (int i=0;i<[stuList count] ; i++) {
        
        NSDictionary *dic=[stuList objectAtIndex:i];
        
        //NSString *str=[dic objectForKey:[[dic allKeys] objectAtIndex:0]] 
        NSString *str=[[dic allKeys]objectAtIndex:0];
        if([str isEqualToString:key])
        {
            [studentView setAlreadyStudent:[dic objectForKey:key]];
            break;
        }
        
    }
    
    
}

- (void)changeNicknameSuccess
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    studentView.studentArr = user.studentArr;
}

-(void)dealloc
{
//    [assetArr removeAllObjects];
    [stuList removeAllObjects];
    self.assetArr=nil;
    self.stuList=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

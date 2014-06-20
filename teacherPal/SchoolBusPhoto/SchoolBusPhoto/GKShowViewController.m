
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
#import "GKCommonClass.h"

#import "KKNavigationController.h"
#import "DBManager.h"
#define TAG 1000

#define STUDENTCELLHEIGHT 55
@interface GKShowViewController ()

@end

@implementation GKShowViewController
@synthesize assetArr;
@synthesize tag;
//@synthesize type;
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
    
    //[GKCommonClass createHelpWithTag:1004 image:[UIImage imageNamed:iphone5 ? @"thelp_upload_568.png" : @"thelp_upload.png"]];
    
    whichView=1;
    self.tag=@"";
    prePage=0;
    stuList = [[NSMutableArray alloc] init];
    picTextArr = [[NSMutableArray alloc] init];
    currentpage=0;
    

    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    

    
    photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame=CGRectMake(260, 0, 60, 45);
    [photobutton setImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
    [photobutton setImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
    [photobutton addTarget:self action:@selector(OKClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photobutton];
    
//    photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    photobutton.frame=CGRectMake(280, 5, 35, 35);
//    [photobutton setBackgroundImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
//    [photobutton setBackgroundImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
//    [photobutton addTarget:self action:@selector(OKClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navigationView addSubview:photobutton];
    
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
       // changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+46 + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height- (ios7 ? 20 : 0)-46)];
    
    changeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:changeView];
    [changeView release];
    
    
    
    sayView=[[GKSaySomethingView alloc]initWithFrame:CGRectMake(0, 0+46 + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height-(0+46 + (ios7 ? 20 : 0)))];
    //sayView.backgroundColor=[UIColor clearColor];
    sayView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
    sayView.delegate=self;
    sayView.hidden=YES;
    [self.view addSubview:sayView];
    [sayView release];
    
    
    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, changeView.frame.size.width, changeView.frame.size.height)];
    picView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
    [changeView addSubview:picView];
    [picView release];
     
    if(ios7)
        _scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-IOS7OFFSET-46)];
    else
        _scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-46)];
    _scroller.backgroundColor=[UIColor whiteColor];
    
    _scroller.clipsToBounds=YES;
    //NSLog(@"%f-------------%f",self.view.frame.size.width,self.view.frame.size.height-(5 + y*STUDENTCELLHEIGHT)-IOS7OFFSET-46);
    
    [picView addSubview:_scroller];
    
    NSLog(@"---------------------------------------------- count  %d",[assetArr count]);
    _scroller.contentSize=CGSizeMake([assetArr count] *320, _scroller.frame.size.height);
    _scroller.showsHorizontalScrollIndicator=NO;
    _scroller.showsVerticalScrollIndicator=NO;
    _scroller.pagingEnabled=YES;
    _scroller.scrollEnabled=YES;
    _scroller.delegate=self;
    [_scroller release];
    
    
    NSLog(@" contentsize%f -----------------%f",_scroller.contentSize.width,_scroller.contentSize.height);
    
   // [self.view bringSubviewToFront:navigationView];

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
// 计算字体长度
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

-(void)applyAll:(NSString *)str
{

    [picTextArr removeAllObjects];
    for (int i=0; i<[assetArr count]; i++) {
        NSString *key=[NSString stringWithFormat:@"%d",i];
        
        NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithObjectsAndKeys:self.tag,@"tag",str,@"text", nil];
        
        [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:dic,key, nil]];
    }

}

- (void)cancelApplyAll
{
    [picTextArr removeAllObjects];
}

-(void)tag:(NSString *)tagTxt
{
    self.tag=tagTxt;
    
    
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    
    for (int i=0; i<[self.picTextArr count]; i++) {
        NSDictionary *dic=[self.picTextArr objectAtIndex:i];
        NSString *keytemp = [[dic allKeys] objectAtIndex:0];
        if([key isEqualToString:keytemp])
        {
            //self.tag,@"tag",str,@"text", nil];

            NSMutableDictionary *tempDic=[dic objectForKey:key];
            
            [tempDic setObject:tagTxt forKey:@"tag"];
            
           // sayView.contextView.text=[[dic objectForKey:key] objectForKey:@"text"];
            break;
        }
         if (i == self.picTextArr.count - 1)
         {
             NSDictionary *addtag=[NSMutableDictionary dictionaryWithObjectsAndKeys:tagTxt,@"tag", nil];
             [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:addtag,key, nil]];

             break;
         }
    
    }
    if ([picTextArr count]==0)
    {
        NSDictionary *addtag=[NSMutableDictionary dictionaryWithObjectsAndKeys:tagTxt,@"tag", nil];
        [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:addtag,key, nil]];
        
        
    }


    
}
//-(void)applyAll:(UIButton *)btn
//{
//
//    if([picTxtView.text isEqualToString:@""])
//    {
//        return;
//    }
//    
//    if([self textLength:picTxtView.text] > 140)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"字数过长" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return;
//    }
//    [picTextArr removeAllObjects];
//    for (int i=0; i<[assetArr count]; i++) {
//         NSString *key=[NSString stringWithFormat:@"%d",i];
//         [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:picTxtView.text,key, nil]];
//    }
//    
//
//
//}

//- (void)textViewDidChange:(UITextView *)textView
//{
//
//    int a= [self textLength:picTxtView.text];
//  
//    NSLog(@"%d",a);
//
//   
//    labelNum.text=[NSString stringWithFormat:@"%d/140",a];
//    
//    if(a>140)
//    {
//        
//        labelNum.textColor=[UIColor redColor];;
//        
//    }
//    else
//    {
//        labelNum.textColor=[UIColor blackColor];
//        self.preStr=picTxtView.text;
//      
//    }
//}

- (void)doEditText:(UIButton *)sender
{
    

       // [picTxtView resignFirstResponder];
        sayView.tagStr=@"";;
        NSString *key=[NSString stringWithFormat:@"%d",currentpage];
        
        for (int i=0; i<[self.picTextArr count]; i++) {
            NSDictionary *dic=[self.picTextArr objectAtIndex:i];
            NSString *keytemp = [[dic allKeys] objectAtIndex:0];
            if([key isEqualToString:keytemp])
            {
                NSString *text=[[dic objectForKey:key] objectForKey:@"text"];
                sayView.contextView.text=text;
                // 设置 tag
                NSString *tagTemp=[[dic objectForKey:key] objectForKey:@"tag"];
                if(tagTemp==nil)
                {
                    tagTemp=@"";
                }
                sayView.tagStr=tagTemp;
                UILabel *label=(UILabel *)[textView viewWithTag:9632];
                NSString *labelstr=[NSString stringWithFormat:@"%@ %@",tagTemp,text];
                label.text=labelstr;
                if([tagTemp isEqualToString:@""]&&[text isEqualToString:@""])
                        textView.hidden=YES;
                else
                      textView.hidden=NO;
                break;
            }
            sayView.contextView.text = @"";
        }
//        UIView *visibleView = [[changeView subviews] objectAtIndex:1];
//        if (visibleView.tag != 1234) {
//            photobutton.hidden = YES;
//            numView.hidden=YES;
//            titlelabel.text=NSLocalizedString(@"story", @"");
//            [picTxtView becomeFirstResponder];
//            
//              textView.hidden=YES;
//        }
//        
        
    if(sender==nil)
    {
        whichView=1;
        changeView.hidden=NO;
        studentView.hidden=NO;
        sayView.hidden=YES;
        
        photobutton.hidden = NO;
        titlelabel.text=NSLocalizedString(@"who", @"");
        numView.hidden=NO;
        self.tag=@"";
    }
    else
    {
        whichView=2;
        titlelabel.text=NSLocalizedString(@"story", @"");
        changeView.hidden=YES;
        studentView.hidden=YES;
        sayView.hidden=NO;
        textView.hidden=YES;
        photobutton.hidden = YES;
        numView.hidden=YES;
    }
    
    if(sayView.hidden==YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:changeView cache:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [changeView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sayView cache:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [sayView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        [UIView commitAnimations];
    }

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
            nickVC.type=2;
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
        imageView.image=nil;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.tag=index+TAG;
        ETPhoto *photo=[assetArr objectAtIndex:index];
        NSData *data= UIImageJPEGRepresentation([UIImage imageWithCGImage:[[photo.asset defaultRepresentation] fullScreenImage]], 0.1);
        imageView.image=[UIImage imageWithData:data];

        imageView.userInteractionEnabled = YES;
       // imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        //[imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.clipsToBounds=YES;// 防止图片超过iamgeView 的区域
        // 1clipsToBounds
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
    GKShowBigImageViewController *showBigVC = [[GKShowBigImageViewController alloc] init];
    showBigVC.Image = imgv.image;
    showBigVC.type=1;
    showBigVC.delegate=self;
    [self presentModalViewController:showBigVC animated:YES];
    [showBigVC release];
}
// 删除图片
-(void)deletePhoto
{
    // 让 current 后面的图片key 的值赋给前一个
    //NSString *currentKey=[NSString stringWithFormat:@"%d",currentpage];
//    int a=currentpage;
//    int b=currentpage;
//
    
    // 找到当前照片的关联学生 然后删除
    
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    for (int i=0; i<[stuList count]; i++) {
        NSDictionary *dic=[stuList objectAtIndex:i];
        NSString *keytemp=[[dic allKeys]objectAtIndex:0];
        if([key isEqualToString:keytemp])
        {
            [stuList removeObject:dic];
            break;
        }
    }
    // 得到剩余stuList 所有key 如果key 大于 currentpage 使key 变为 key-1
    
    for (int i=0; i<[stuList count]; i++) {
        NSDictionary *dic=[stuList objectAtIndex:i];
        NSString *keytemp=[[dic allKeys]objectAtIndex:0];
        
        int keyInt=[keytemp integerValue];
        if(keyInt>currentpage)
        {
            id value=[dic objectForKey:keytemp];
            NSDictionary *dicNew=[NSDictionary dictionaryWithObjectsAndKeys:value,[NSString stringWithFormat:@"%d",keyInt-1], nil];
            [stuList replaceObjectAtIndex:i withObject:dicNew];
        }
        
        
    }

    // 找到当前照片的说点什么 然后删除
    
    //NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    for (int i=0; i<[picTextArr count]; i++) {
        NSDictionary *dic=[picTextArr objectAtIndex:i];
        NSString *keytemp=[[dic allKeys]objectAtIndex:0];
        if([key isEqualToString:keytemp])
        {
            [picTextArr removeObject:dic];
            break;
        }
    }
    // 得到剩余picTextArr 所有key 如果key 大于 currentpage 使key 变为 key-1
    
    for (int i=0; i<[picTextArr count]; i++) {
        NSMutableDictionary *dic=[picTextArr objectAtIndex:i];
        NSString *keytemp=[[dic allKeys]objectAtIndex:0];
        
        int keyInt=[keytemp integerValue];
        if(keyInt>currentpage)
        {
            id value=[dic objectForKey:keytemp];
            NSMutableDictionary *dicNew=[NSMutableDictionary dictionaryWithObjectsAndKeys:value,[NSString stringWithFormat:@"%d",keyInt-1], nil];
            [picTextArr replaceObjectAtIndex:i withObject:dicNew];
        }
        
        
    }
    


 //判断是否为最后一个 如果是 currentpage-1
    BOOL last=(currentpage==[assetArr count]-1)?YES:NO;
    [assetArr removeObjectAtIndex:currentpage];

    if(last)
        currentpage=currentpage-1;
        
    numbeLabel.text=[NSString stringWithFormat:@"%d/%d",currentpage+1,[assetArr count]];
    
     _scroller.contentSize=CGSizeMake([assetArr count] *320, _scroller.frame.size.height);
   // -(void)addImageViewToScroller:(int)index
    for (UIView *view in _scroller.subviews) {

        
            [view removeFromSuperview];
        
        
    }
    //currentpage=0;
    if([assetArr count]==0)
    {
        [delegate refreashPickViewController:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self setAlreayStudent];
    [self addImageViewToScroller:currentpage];
    
    
    
}

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
        disappearView.layer.cornerRadius=5;
       // [[[[UIApplication sharedApplication] windows] lastObject]  addSubview:disappearView];
         //[[[UIApplication sharedApplication] keyWindow]  addSubview:disappearView];
        [[[UIApplication sharedApplication].delegate window] addSubview:disappearView];
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
        
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
        
        ETPhoto *photo=[assetArr objectAtIndex:i];
        ALAssetRepresentation *representation = [photo.asset defaultRepresentation];
        NSString* filenamePath = [documentpath stringByAppendingPathComponent:[representation filename]];
        UIImage *thumbiamge=[UIImage imageWithCGImage:photo.asset.thumbnail];
        BOOL cureateSuccess= [[NSFileManager defaultManager] createFileAtPath:filenamePath contents:nil attributes:nil];
        if(!cureateSuccess)
        {
            NSLog(@"----------------------------创建文件失败");
            continue;
        }
        
        NSLog(@"----------------------------创建文件成功");
        NSOutputStream *outPutStream = [NSOutputStream outputStreamToFileAtPath:filenamePath append:YES];
        [outPutStream open];
        long long offset = 0;
        long long bytesRead = 0;
        //NSLog(@"%lld",representation.size);
        NSError *error=nil;
            
        // 增加写文件错误处理
        uint8_t * buffer = malloc(131072);
        while (offset<[representation size] && [outPutStream hasSpaceAvailable]) {
            bytesRead = [representation getBytes:buffer fromOffset:offset length:131072 error:&error];
            if(error || bytesRead==0) // 如果写文件出错 跳出改讯黄
            {
                break;
            }
            [outPutStream write:buffer maxLength:bytesRead];
            offset = offset+bytesRead;
               // NSLog(@" ------representationsize:%lld---------offset:%lld",representation.size, offset);
        }
            [outPutStream close];  
            free(buffer);
        
            NSLog(@"error:%@",error);
            if(error || offset==0)
            {
                // 如果写文件失败 跳过上传该文件
                NSLog(@"？？？？？？？？？？？？？？？？？？？？写文件失败");
                continue;
               // return;
            }
           NSLog(@"？？？？？？？？？？？？？？？？？？？？写文件成功");
     
           // NSLog(@"%@",photo.date);
            
            NSDate *date= [photo.asset valueForProperty:ALAssetPropertyDate];
//                photo.date=date;
            
            int ftime=[date timeIntervalSince1970];
            if(ftime==0)
            {
                 ftime=[[NSDate date]timeIntervalSince1970];
            }
            
            NSString *studentId=@"";
            NSString *key=[NSString stringWithFormat:@"%d",i];
            NSString *introduce = @"";
            NSString *tagcontent=@"";
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
        
        NSLog(@"studentId:??????????????????????????????????%@",studentId);
            for (int j = 0; j < [picTextArr count]; j++) {
                NSDictionary *introduceDic = [picTextArr objectAtIndex:j];
                NSString *txtKey = [[introduceDic allKeys] lastObject];
                if([key isEqualToString:txtKey])
                {
                    if (txtKey != nil) {
                        
                        NSString *tmptext=[[introduceDic objectForKey:txtKey] objectForKey:@"text"];
                        NSString *tmptag=[[introduceDic objectForKey:txtKey] objectForKey:@"tag"];
                        introduce = [introduceDic objectForKey:txtKey];
                        if(tmptext)
                            introduce=tmptext;
                        else
                            introduce=@"";
                        
                        if(tmptag)
                            tagcontent=tmptag;
                        else
                            tagcontent=@"";
                        
                    }
                    break;
                }
            }
        NSLog(@"introduce:??????????????????????????????????%@",introduce);
        

        NSNumber *teacherid=[NSNumber numberWithInt:[user.teacher.teacherid integerValue]];
        [[DBManager shareInstance]insertObject:^(NSManagedObject *object) {
            UpLoader *aa=(UpLoader *)object;
            aa.image=filenamePath; //路径
            aa.nameID=photo.nameId;
            aa.teacherid=teacherid;
            aa.classUid=[NSNumber numberWithInt:[user.classInfo.uid integerValue]];
            aa.name=representation.filename;
            aa.studentId=studentId;
            aa.fsize=[NSNumber numberWithInt:representation.size];
            aa.ftime=[NSNumber numberWithInt:ftime];
            aa.introduce=introduce;
            aa.tag=tagcontent;
            aa.isUploading=[NSNumber numberWithInt:1];
            aa.smallImage=UIImageJPEGRepresentation(thumbiamge, 0.5);
            
        } entityName:@"UpLoader" success:^{
            
            
            NSLog(@"写数据库成功 ----------------------上传数据");
            
        [manager addWraperToArr:filenamePath name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5) tag:tagcontent teacherid:teacherid];

            
        } failed:^(NSError *err) {
              NSLog(@"ssssbbbbbbb");
        }];
        
        //[manager addNewPicToCoreData:filename name:representation.filename iSloading:[NSNumber numberWithInt:1] nameId:photo.nameId studentId:studentId time:[NSNumber numberWithInt:ftime] fsize:[NSNumber numberWithInt:representation.size] classID:[NSNumber numberWithInt:[user.classInfo.uid integerValue]] intro:introduce data:UIImageJPEGRepresentation(thumbiamge, 0.5) tag:@""];// 图片tag
        
            [pool release];
        }
     
    

    
     NSLog(@"？？？？？？？？？？？？？？？？？？？？循环完毕");
    [self performSelectorOnMainThread:@selector(toMainThread) withObject:nil waitUntilDone:YES];

}
-(void)toMainThread
{
     NSLog(@"？？？？？？？？？？？？？？？？？？？进入主线程");
    disappearView.textLabel.text=NSLocalizedString(@"processingafter", @"");
    [disappearView setactiveStop:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [delegate refreashPickViewController:assetArr] ;
    [self performSelector:@selector(delay) withObject:nil afterDelay:1];
    

}
-(void)delay
{
     NSLog(@"？？？？？？？？？？？？？？？？？？？view  消失");
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
        //UIView *visibleView = [[changeView subviews] objectAtIndex:1];
        if (whichView == 2) {
            
        
            
            NSString *key=[NSString stringWithFormat:@"%d",currentpage];
            for (int i=0; i<[self.picTextArr count]; i++) {
                NSMutableDictionary *dic=[self.picTextArr objectAtIndex:i];
                NSString *keytemp = [[dic allKeys] objectAtIndex:0];
                if([key isEqualToString:keytemp])
                {
                    if([self textLength:sayView.contextView.text] > 280)
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"字数过长" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        return;
                        //return;
                       // picTxtView.text=self.preStr;
                    }
                    
                    NSMutableDictionary *tempDic=[dic objectForKey:key];
                    [tempDic setObject:sayView.contextView.text forKey:@"text"];
                    //[dic setObject:sayView.contextView.text forKey:key];
                    break;
                }
                if (i == self.picTextArr.count - 1)
                {
                    if([self textLength:sayView.contextView.text] > 280)
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"字数过长" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        return;
                            //picTxtView.text=self.preStr;
                    }
                    NSDictionary *adddic=[NSMutableDictionary dictionaryWithObjectsAndKeys:sayView.contextView.text,@"text", nil];
                    //[self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:sayView.contextView.text,key, nil]];
                    [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:adddic,key, nil]];
                    break;
                }
            }
            if (self.picTextArr.count == 0) {
                
                if([self textLength:sayView.contextView.text] > 280)
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"字数过长" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    return;
                    // picTxtView.text=self.preStr;
                }
                NSDictionary *adddic=[NSMutableDictionary dictionaryWithObjectsAndKeys:sayView.contextView.text,@"text", nil];
                [self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:adddic,key, nil]];
                //[self.picTextArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:sayView.contextView.text,key, nil]];
            }

            titlelabel.text=NSLocalizedString(@"who", @"");

            [sayView.contextView resignFirstResponder];
            [self doEditText:nil];
            
            
            
            
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"Cancelphotos", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"yes", @""), nil];
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
        numbeLabel.text=[NSString stringWithFormat:@"%d/%d",++num,[assetArr count]];
        
        currentpage=num-1;
        
        if(prePage!=currentpage)
        {
            [studentView setAllButtonSelect:NO];
            
            prePage=currentpage;
        }
        else
        {
            return;//没有划出本张图片时返回
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

-(void)setAlreayStudent
{
    
  //  -(void)setAllButtonSelect:(BOOL)isselect;
     [studentView setAllButtonSelect:NO];
    NSString *key=[NSString stringWithFormat:@"%d",currentpage];
    
    
       // label.tag=9632;//
    
    UILabel *label=(UILabel *)[textView viewWithTag:9632];
    
    
    NSString *introduce = @"";
    NSString *tagStr=@"";
    for (int j = 0; j < [picTextArr count]; j++) {
        NSDictionary *introduceDic = [picTextArr objectAtIndex:j];
        NSString *txtKey = [[introduceDic allKeys] lastObject];
        if([key isEqualToString:txtKey])
        {
            if (txtKey != nil) {
                
                //introduce = [introduceDic objectForKey:txtKey];
                introduce = [[introduceDic objectForKey:txtKey] objectForKey:@"text"];

                tagStr = [[introduceDic objectForKey:txtKey] objectForKey:@"tag"];
                if(tagStr==nil)
                {
                    tagStr=@"";
                }
                
            }
            break;
        }
    }

    label.text=[NSString stringWithFormat:@"%@ %@",tagStr,introduce]; ;
    if([tagStr isEqualToString:@""] && [introduce isEqualToString:@""])
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [sayView.contextView resignFirstResponder]; 
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
    self.tag=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

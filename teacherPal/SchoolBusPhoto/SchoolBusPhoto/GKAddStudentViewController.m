//
//  GKAddStudentViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKAddStudentViewController.h"
#import "KKNavigationController.h"
#import "GKAddStudentSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GKRelationViewController.h"
#import "Student.h"
#import "GKUserLogin.h"
#import "GTMBase64.h"
#define LABELTAG 500
@interface GKAddStudentViewController ()

@end

@implementation GKAddStudentViewController
@synthesize tel,name;
@synthesize telField,nameField,nickNameField;
@synthesize shipArr;
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
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    titlelabel.text=NSLocalizedString(@"addstudent", @"");
    
    UIScrollView *scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(navigationView.frame.size.height+navigationView.frame.origin.y))];
    scroller.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:scroller];
    [scroller release];
    
    //50/38
  
    
    
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-40, 20, 70, 70)];
    imageView.backgroundColor=[UIColor grayColor];
    imageView.userInteractionEnabled=YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 2;
    imageView.image=[UIImage imageNamed:@"headplaceholder_big.png"];
    imageView.layer.cornerRadius = 20.0f;
    imageView.userInteractionEnabled=YES;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.masksToBounds = YES;

    [scroller addSubview:imageView];
    //[self.view sendSubviewToBack:imageView];
    [imageView release];
    
    
    imagePhoto=[[UIImageView alloc]initWithFrame:CGRectMake(45, 50, 25, 20)];
    imagePhoto.image=[UIImage imageNamed:@"photo.png"];
    [imageView addSubview:imagePhoto];
    [imagePhoto release];
    
    UITapGestureRecognizer *tapPhoto=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto:)];
    tapPhoto.numberOfTapsRequired=1;
    [imageView addGestureRecognizer:tapPhoto];
    [tapPhoto release];
    

    
    contentView=[[UIView alloc] initWithFrame:CGRectMake(10, imageView.frame.size.height+imageView.frame.origin.y+10, 300, 250)];
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.tag=999;
    contentView.layer.cornerRadius=10;
    [scroller addSubview:contentView];
    [contentView release];


    NSArray *arr=[NSArray arrayWithObjects:NSLocalizedString(@"realName", @""),NSLocalizedString(@"phone", @""),NSLocalizedString(@"Relationship", @""),NSLocalizedString(@"Gender", @""),NSLocalizedString(@"birthday", @""),nil];
    self.shipArr=[NSArray arrayWithObjects:NSLocalizedString(@"father", @""),NSLocalizedString(@"mother", @""),NSLocalizedString(@"Grandpa", @""),NSLocalizedString(@"Grandma", @""),NSLocalizedString(@"other", @""), nil];
    for (int i=0; i<5; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10 + 50*i, 110, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[arr objectAtIndex:i];
        [contentView addSubview:label];
        [label release];
        if(i!=4)
        {
            UIImageView *imageLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50+50*i, 300, 1)];
            imageLine.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
            [contentView addSubview:imageLine];
            [imageLine release];
        }
        
    }
    
//    for (int i=0; i<3; i++) {
//        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(130, 10 + 50*i, 100, 30)];
//        textField.borderStyle=UITextBorderStyleRoundedRect;
//        [contentView addSubview:textField];
//        [textField release];
//    }
    
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(130, 10 , 150, 30)];
    nameField.borderStyle=UITextBorderStyleRoundedRect;
    nameField.text=self.name;
    nameField.delegate=self;
    [contentView addSubview:nameField];
    
//    nickNameField=[[UITextField alloc]initWithFrame:CGRectMake(130, 10 + 50, 150, 30)];
//    nickNameField.borderStyle=UITextBorderStyleRoundedRect;
//    nickNameField.delegate=self;
//    [contentView addSubview:nickNameField];
    
    telField=[[UITextField alloc]initWithFrame:CGRectMake(130, 10 + 50, 150, 30)];
    telField.borderStyle=UITextBorderStyleRoundedRect;
    telField.delegate=self;
    telField.text=tel;
    [contentView addSubview:telField];
    sex=1;
    NSArray *strArr=[NSArray arrayWithObjects:NSLocalizedString(@"mother", @""),NSLocalizedString(@"prince", @""),@"2012-01-01", nil];
    for (int i=0; i<3; i++) {
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(130, 110+50*i, 150, 30)];
        lable.backgroundColor=[UIColor clearColor];
        lable.tag=LABELTAG+i;
        if(IOSVERSION>=6.0)
        {
            lable.textAlignment=NSTextAlignmentCenter;
        }
        else
        {
            lable.textAlignment=UITextAlignmentCenter;
        }
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTapsRequired=1;
        [lable addGestureRecognizer:tap];
        [tap release];
        lable.userInteractionEnabled=YES;
        lable.text=[strArr objectAtIndex:i];
        [contentView addSubview:lable];
        [lable release];
    }
    
     NSString *nextstr=NSLocalizedString(@"next", @"");
    UIButton *addStudentBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    addStudentBtn.frame=CGRectMake(40,contentView.frame.size.height+contentView.frame.origin.y+10, 240, 40);
    [addStudentBtn setTitle:nextstr forState:UIControlStateNormal];
    [addStudentBtn setTintColor:[UIColor whiteColor]];
    UIImage *iamge=[UIImage imageNamed:@"loginBtn.png"];
    
    
    [addStudentBtn setBackgroundImage:[iamge resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 15, 25)] forState:UIControlStateNormal];
    [addStudentBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:addStudentBtn];
    
    scroller.contentSize=CGSizeMake(self.view.frame.size.width, addStudentBtn.frame.size.height+addStudentBtn.frame.origin.y+10);
    // Do any additional setup after loading the view.
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UILabel *tapLabel= (UILabel *)tap.view;
    
    if(tapLabel.tag==LABELTAG)
    {
        
     
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Relationship", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:[shipArr objectAtIndex:0],[shipArr objectAtIndex:1],[shipArr objectAtIndex:2],[shipArr objectAtIndex:3],[shipArr objectAtIndex:4], nil];
        [action showInView:self.view];
        action.tag=LABELTAG+100;
        [action release];
    }
    if(tapLabel.tag==LABELTAG+1)
    {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Gender", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"prince", @""),NSLocalizedString(@"Princess", @""), nil];
        [action showInView:self.view];
        action.tag=LABELTAG+101;
        [action release];
        
    }
    if(tapLabel.tag==LABELTAG+2)
    {
        NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[formate dateFromString:tapLabel.text];
        MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:date];
        sheet._delegate = self;
        
        [sheet showInView:self.view.window];
        [sheet release];
    }
    
    
}
-(void)tapPhoto:(UITapGestureRecognizer *)tap
{
    if(tap.state==UIGestureRecognizerStateEnded)
    {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"avatorM", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choose", @""), nil];
        [action showInView:self.view];
        action.tag=LABELTAG+102;
        [action release];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
  
    if (actionSheet.tag == LABELTAG+100)
    {
       if(buttonIndex==5)
           return;
        UILabel *label=(UILabel *)[contentView viewWithTag:LABELTAG];
      
        label.text=[shipArr objectAtIndex:buttonIndex];
        
    }
    if(actionSheet.tag==LABELTAG+101)
    {
        UILabel *label=(UILabel *)[contentView viewWithTag:LABELTAG+1];
        
       // label.text=[shipArr objectAtIndex:buttonIndex];
        if(buttonIndex==0)
        {
            //男
            label.text=NSLocalizedString(@"prince", @"");
            sex=1;
 
        }
        else if(buttonIndex==1)
        {
            //女
            label.text=NSLocalizedString(@"Princess", @"");
            sex=2;
        }
  
    }
    if(actionSheet.tag==LABELTAG+102)
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
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *date=UIImageJPEGRepresentation(image, 0.5);
    self.imagedata=date;
    if(self.imagedata!=nil)
    {
        imageView.image=image;
        imagePhoto.hidden=YES;
    }
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
        
        UILabel *label=(UILabel *)[contentView viewWithTag:LABELTAG+2];
        
        NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *birStr = [formatter stringFromDate:date];
        
        if ([label.text isEqualToString:birStr]) {
            return;
        }
        label.text=birStr;
        
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (BOOL)checkTel:(NSString *)str

{
    
    
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        
        
        return NO;
        
    }
    
    
    
    return YES;
    
}
-(void)nextStep:(UIButton *)btn
{
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"15152563235",@"tel", nil];
//    [[EKRequest Instance]EKHTTPRequest:mobileStudent parameters:dic requestMethod:GET forDelegate:self];
    

    if([nameField.text isEqualToString:@""] || [telField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        return;
    }
    if(![self checkTel:telField.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"telformat", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD release];
    }
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    UILabel *labelship=(UILabel *)[contentView viewWithTag:LABELTAG];
    UILabel *labelbir=(UILabel *)[contentView viewWithTag:LABELTAG+2];
    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:self.imagedata] encoding:NSUTF8StringEncoding];

    self.photoString=base64;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:labelship.text,@"relationship",nameField.text,@"name",self.telField.text,@"tel",[NSNumber numberWithInt:sex],@"sex",labelbir.text,@"birthday",base64,@"fbody", nil]; //增加孩子
    
    
    //NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
   
    
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:student.studentID,@"studentid",student.studentUID,@"studentuid",@"0",@"type",nil];
    [[EKRequest Instance]EKHTTPRequest:addStudent parameters:dic requestMethod:POST forDelegate:self];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);

    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==addStudent)
    {
        if(code==1)
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSString *key=[dic objectForKey:@"key"];
            if([key isEqualToString:@"1"])
            {
                //
                
                
                
                UILabel *labelbir=(UILabel *)[contentView viewWithTag:LABELTAG+2];
               
                
                GKRelationViewController *relationVC=[[GKRelationViewController alloc]init];
                relationVC.student=[NSString stringWithFormat:@"%@",[dic objectForKey:@"student"]];;
                relationVC.parentid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"parentid"]];;
           
                relationVC.tel=telField.text;
                relationVC.name=nameField.text;
                relationVC.sex=sex;
                relationVC.photoString=self.photoString;
                relationVC.birthday=labelbir.text;
                [self.navigationController pushViewController:relationVC animated:YES];
                [relationVC release];
                
                
                
            }
            else if([key isEqualToString:@"2"])
            {
                //增加成功
                
                GKUserLogin *user=[GKUserLogin currentLogin];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"successjoinclass", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                NSDictionary *studentdic=[dic objectForKey:@"student"];
                Student *student=[[Student alloc]init];
               
                student.age=[studentdic objectForKey:@"age"];
                student.avatar=[studentdic objectForKey:@"avatar"];
                student.birthday=[studentdic objectForKey:@"birthday"];
                student.cnname=[studentdic objectForKey:@"cnname"];
                student.enname=[studentdic objectForKey:@"enname"];
                student.filesize=[studentdic objectForKey:@"filesize"];
                student.orderendtime=[studentdic objectForKey:@"orderendtime"];
            
                student.mobile=[studentdic objectForKey:@"mobile"];
                student.sex=[studentdic objectForKey:@"sex"];
                student.studentid=[studentdic objectForKey:@"studentid"];
                student.studentno=[studentdic objectForKey:@"studentno"];
                student.sex=[studentdic objectForKey:@"sex"];
                
                student.uid=[studentdic objectForKey:@"uid_student"];
                
                student.username=[NSString stringWithFormat:@"%@",[studentdic objectForKey:@"username"]];
                student.parentid=[NSNumber numberWithInt:[[studentdic objectForKey:@"parentid"] integerValue]];
                [user.studentArr addObject:student];
                [student release];

                [self.navigationController popToRootViewControllerAnimated:YES];

//                for (UIViewController *temp in self.navigationController.viewControllers) {
//                    if ([temp isKindOfClass:[GKAddStudentSearchViewController class]]) {
//                        [self.navigationController popToViewController:temp animated:YES];
//                    }
//                }
        
                
               // [self.navigationController popToViewController:<#(UIViewController *)#> animated:<#(BOOL)#>];
                
            }
        }
        if(code==-3)
        {
            //不能创建 ，已在机构内
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:@"孩子已存在，不能创建孩子，请进行调班操作" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];

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
}
-(void)back:(UIButton *)btn
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
    self.tel=nil;
    self.name=nil;
    self.nickNameField=nil;
    self.telField=nil;
    self.nickNameField=nil;
    self.shipArr=nil;
    self.photoString=nil;
    self.imagedata=nil;
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

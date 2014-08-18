//
//  GKWriteReportViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-30.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKWriteReportViewController.h"
#import "KKNavigationController.h"
#import "GKUserLogin.h"

@interface GKWriteReportViewController ()

@end

@implementation GKWriteReportViewController
@synthesize model;
@synthesize jsonArr;
//@synthesize titleStr;
@synthesize stuidArr;
@synthesize studentselectStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.model=nil;
    self.jsonArr=nil;
  //  self.titleStr=nil;
    self.studentselectStr=nil;
    self.stuidArr=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
    
}
-(void)keyboarChange:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    //CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect1=[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    
    NSLog(@"%f---%f",rect1.size.width,rect1.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
     
            scroller.frame=CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, self.view.frame.size.height-rect1.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-30);
        
    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
      
       // scroller.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
       // scroller.frame=CGRectMake(0,scroller.frame.size.height+scroller.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-58);
        
        scroller.frame=CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-30);
    }];
    
}
-(void)keyboarShow:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        scroller.frame=CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, self.view.frame.size.height-rect.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-30);
       
    }];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    stuidArr=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    self.view.backgroundColor= [UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *sendbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendbutton.frame=CGRectMake(270, 5, 50, 35);
    [sendbutton setBackgroundImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [sendbutton setBackgroundImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];

    [sendbutton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:sendbutton];

    

    
    NSDate *date=[NSDate date];
    
    NSDateFormatter *dateFommart=[[NSDateFormatter alloc]init];
    [dateFommart setDateFormat:@"yyyy-MM-dd"];
    
    NSString *temp=[dateFommart stringFromDate:date];
    
    self.dateStr=temp;
    
    
    dateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.backgroundColor=[UIColor whiteColor];
    [dateButton setTitle:self.dateStr forState:UIControlStateNormal];
    dateButton.tag=100;

    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateButton.frame=CGRectMake(20, navigationView.frame.size.height+navigationView.frame.origin.y+5, 140, 30);
    [dateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateButton];
    

    
    stuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    stuButton.backgroundColor=[UIColor whiteColor];
    stuButton.tag=101;
   
    [stuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stuButton.frame=CGRectMake(160, navigationView.frame.size.height+navigationView.frame.origin.y+5, 140, 30);
    if([model.type intValue]==2)
    {
        
        
        GKUserLogin *user=[GKUserLogin currentLogin];
        
         [stuButton setTitle:[NSString stringWithFormat:@"全班%d人",[user.studentArr count]] forState:UIControlStateNormal];
        self.studentselectStr=[NSString stringWithFormat:@"全班%d人",[user.studentArr count]];
        for (int i=0; i<[user.studentArr count]; i++) {
            Student *st=[user.studentArr objectAtIndex:i];
            [stuidArr addObject:[NSString stringWithFormat:@"%@",st.studentid]];
        }

        
    }
    else
    {
        [stuButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
         [stuButton setTitle:@"选择学生" forState:UIControlStateNormal];
    }
   
    [self.view addSubview:stuButton];
    UIImageView *lineView1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0,dateButton.frame.origin.y , 1, dateButton.frame.size.height)];
    lineView1.backgroundColor=[UIColor colorWithRed:213/255.0 green:210/255.0 blue:204/255.0 alpha:1];
    //lineView1.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineView1];
    [lineView1 release];
    
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, stuButton.frame.size.height+stuButton.frame.origin.y+10, self.view.frame.size.width-1, 1)];
    // lineView.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
    lineView.image=[UIImage imageNamed:@"line.png"];
    [self.view addSubview:lineView];
    [lineView release];
    
    
    titlelabel.text=NSLocalizedString(@"reportpub", @"");
    jsonArr=[[NSMutableArray alloc]init];
    
    scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, dateButton.frame.origin.y+dateButton.frame.size.height, self.view.frame.size.width , self.view.frame.size.height-(dateButton.frame.origin.y+dateButton.frame.size.height))];
    
    scroller.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:scroller];
    [scroller release];
    
    
    for (int i=0; i<[model.questionArr count]; i++) {
        
        GKReportQuestion *question= [model.questionArr objectAtIndex:i];
        GKQuestionView *temp=[[GKQuestionView alloc]initWithFrame:CGRectMake(0, 70*i, 320, 70) index:i+1];
        temp.delegate=self;
        temp.backgroundColor=[UIColor clearColor];
        temp.question=question;
        [scroller addSubview:temp];
        
        if([question.type integerValue]==1)
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:question.title,@"title",question.op1,@"answer", nil];
            [jsonArr addObject:dic];
        }


        
    }
   
    scroller.contentSize=CGSizeMake(self.view.frame.size.width,[model.questionArr count]*70);
    
    [self.view sendSubviewToBack:scroller];
    // 共多少题
   // [model.questionArr count];

}

-(void)rightClick:(id)sender
{
    
    
    if([self.stuidArr count]==0)
    {
        //没有选择学生
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择学生" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if([self.jsonArr count]==0)
    {
        //至少选择一道题
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
    
    NSData *jsondate=[NSJSONSerialization dataWithJSONObject:self.jsonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstr=[[NSString alloc]initWithData:jsondate encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonstr);
    

    
    NSString *studeltlist=[self selectStudentID:[NSMutableArray arrayWithArray:self.stuidArr]];

   // NSString *titlestr=[NSString stringWithFormat:<#(NSString *), ...#>];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:self.dateStr];
    [dateFormatter release];
    int time=[date timeIntervalSince1970];
    
    NSString *timeStr=[NSString stringWithFormat:@"%d",time];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstr,@"content",self.studentselectStr,@"title",self.model.type,@"type",studeltlist,@"memberlist",timeStr,@"date",model.name,@"reportname", nil];
    
    [jsonstr release];
    [[EKRequest Instance]EKHTTPRequest:report parameters:dic requestMethod:POST forDelegate:self];
    //[NSJSONSerialization dataWithJSONObject:self.jsonArr options:<#(NSJSONWritingOptions)#> error:<#(NSError **)#>]
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==report && code==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
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
-(NSMutableString *)selectStudentID:(NSMutableArray *)arr
{
    NSMutableString *temp=[[NSMutableString alloc]init];
    for (int i=0; i<[arr count]; i++) {
        [temp appendFormat:@"%@,",[arr objectAtIndex:i]];
    }
    [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1)];
    return [temp autorelease];
}

-(void)buttonClick:(UIButton *)btn
{
    for (UIView *view in [self.view subviews]) {
        
        if([view isKindOfClass:[UIButton class]])
        {
            view.backgroundColor=[UIColor whiteColor];
            UIButton *btn1=(UIButton *)view;
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    btn.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(btn.tag==100)
    {
        NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[formate dateFromString:self.dateStr];
        MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:date];
        sheet._delegate = self;
        
        [sheet showInView:self.view.window];
        [sheet release];
        
    

    }
    else if(btn.tag==101)
    {
        GKReportStudentView *stView=[[GKReportStudentView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        stView.delegate=self;
        [self.view addSubview:stView];
        
        [stView animationstart];
        [stView release];
        
        [stView setStudentViewSelect:self.stuidArr];
    }
    
}
-(void)studentView:(GKReportStudentView *)_stuView studentIdList:(NSMutableArray *)stuIdList studentName:(NSString *)oneName
{
    self.stuidArr=stuIdList;
    
    if([self.stuidArr count]==1)
    {
        self.studentselectStr=oneName;
    }
    else
    self.studentselectStr=[NSString stringWithFormat:@"%@等%d人",oneName,[stuIdList count]];
    
    [stuButton setTitle:self.studentselectStr forState:UIControlStateNormal];
}
-(void)studentViewHidden:(GKReportStudentView *)_stuView
{
    [_stuView removeFromSuperview];
    _stuView=nil;
}
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index selectDate:(NSDate *)date
{

    NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *birStr = [formatter stringFromDate:date];
    self.dateStr=birStr;
    
    [dateButton setTitle:birStr forState:UIControlStateNormal];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *tmp in scroller.subviews) {
        
        if([tmp isKindOfClass:[GKQuestionView class]])
        {
            GKQuestionView *questview=(GKQuestionView *)tmp;
            
            [questview.contentField resignFirstResponder];
        }
    }
}
-(void)questionKeyBoard
{
    for (UIView *tmp in scroller.subviews) {
        
        if([tmp isKindOfClass:[GKQuestionView class]])
        {
            GKQuestionView *questview=(GKQuestionView *)tmp;
            
            [questview.contentField resignFirstResponder];
        }
    }

}
-(void)questionFielddbeginEdit:(int)_index
{
    if(_index>=2)
    scroller.contentOffset=CGPointMake(0, (_index -2)*70);
}
-(void)questionView:(GKQuestionView *)_questView questionTitle:(NSString *)questiontitle answer:(NSString *)_answer
{
   // NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_title,@"title",_answer,@"answer", nil];
    
    BOOL found=NO;
    for (int i=0; i<[jsonArr count]; i++) {
        NSDictionary *dic=[jsonArr objectAtIndex:i];
    
        if([[dic objectForKey:@"title"] isEqualToString:questiontitle])
        {
            found=YES;
            [jsonArr removeObject:dic];
            break;
        }
        
        
    }
    
    if(found==NO)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:questiontitle,@"title",_answer,@"answer", nil];
        [jsonArr addObject:dic];
    }
    else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:questiontitle,@"title",_answer,@"answer", nil];
        [jsonArr addObject:dic];
    }
    
    //[self.jsonDic setObject:<#(id)#> forKey:<#(id<NSCopying>)#>]
}
-(void)leftClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

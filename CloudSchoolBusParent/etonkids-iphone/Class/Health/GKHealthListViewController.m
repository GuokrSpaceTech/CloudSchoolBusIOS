//
//  GKHealthListViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKHealthListViewController.h"
#import "ETKids.h"
#import "GKHealthCell.h"
#import "MD5.h"
#import "GKWriteHealthViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "UserLogin.h"
#import "CYProblem.h"
#import "GKHealthDetaiViewController.h"
@interface GKHealthListViewController ()

@end

@implementation GKHealthListViewController
@synthesize _tableView;
@synthesize dateArr;
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
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = @"医生咨询";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"提问" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    dateArr=[[NSMutableArray alloc]init];
    [self loadData];
    

   


}

-(void)loadData
{
    int time= [[NSDate date] timeIntervalSince1970];
    UserLogin *user=[UserLogin currentLogin];
    

//    [resuest setPostValue:user.username forKey:@"user_id"];
    
    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,user.username,@"testchunyu"];
    //
    NSString *sign=[MD5 md5:string];
    
    NSString *atime= [NSString stringWithFormat:@"%d",time];
    NSString *parm=[NSString stringWithFormat:@"user_id=%@&sign=%@&atime=%@&start_num=%@&count=%@",user.username,sign,atime,@"0",@"20"];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem/list/my?%@",parm]];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];

    [request setDelegate:self];
    //    //配置代理为本类
    [request setTimeOutSeconds:10];
    //    //设置超时
    [request setDidFailSelector:@selector(urlRequestFailed:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
    //    
    [request startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request
{
    //NSLog(@"%@",request.responseData);
    NSLog(@"%@",request.responseString);
    
    NSArray * arr =[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    
    for (int i=0; i<[arr count]; i++) {
        CYProblem * problem=[[CYProblem alloc]init];
        NSDictionary *dic=[arr objectAtIndex:i];
        NSDictionary *dicinfo=[dic objectForKey:@"problem"];
        
        problem.status=[dicinfo objectForKey:@"status"];
        problem.created_time=[dicinfo objectForKey:@"created_time"];
        problem.ask=[dicinfo objectForKey:@"ask"];
        problem.problemId=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"id"]];
        problem.title=[dicinfo objectForKey:@"title"];
        problem.created_time_ms=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"created_time_ms"]];
        problem.clinic_name=[dicinfo objectForKey:@"clinic_name"];
        [dateArr addObject:problem];
        [problem release];
    }
    [_tableView reloadData];

}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"%@",request.error.description);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 137+20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateArr count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    GKHealthCell *cell=(GKHealthCell *)[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[GKHealthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
    }
    CYProblem *problem=[dateArr objectAtIndex:indexPath.row];
    
    cell.titleLatel.text=problem.clinic_name;
    cell.contentLatel.text=problem.ask;
    cell.timeLatel.text=[problem.created_time substringToIndex:10];
    return cell;

    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GKHealthDetaiViewController *healthDetailVC=[[GKHealthDetaiViewController alloc]init];
    
    AppDelegate *appDel=SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:healthDetailVC animated:YES];
    [healthDetailVC release];
    
}

-(void)rightButtonClick:(UIButton *)btn
{
    GKWriteHealthViewController * writeHealthVC=[[GKWriteHealthViewController alloc]init];
    
 
    AppDelegate *appDel=SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:writeHealthVC animated:YES];
    [writeHealthVC release];
    
}
- (void)leftButtonClick:(id)sender
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
    self._tableView=nil;
    self.dateArr=nil;
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

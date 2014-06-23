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
#import <CommonCrypto/CommonDigest.h>
#import "GKWriteHealthViewController.h"
#import "AppDelegate.h"
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

    
//    int time= [[NSDate date] timeIntervalSince1970];
//    
//    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,@"13581804688",@"testchunyu"];
//    
//    NSString *sign=[self md5:string];
//    NSLog(@"%@",sign);
//    
//    
//    
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",@"我的病情是这样的",@"text", nil];
//     NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"patient_meta",@"type",@"15",@"age",@"男",@"sex", nil];
//    
//    NSArray *arr=[NSArray arrayWithObjects:dic,dic1, nil];
//    NSData *jsondate=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonstr=[[NSString alloc]initWithData:jsondate encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",jsonstr);
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://yzxc.summer2.chunyu.me/partner/yzxc/create_vip"]];
//    [request setHTTPMethod:@"POST"];
//    
//    [request setValue:@"13581804688" forHTTPHeaderField:@"phone"];
//   // [request setValue:jsonstr forHTTPHeaderField:@"content"];
//    [request setValue:@"30" forHTTPHeaderField:@"days"];
//    
//    [request setValue:sign forHTTPHeaderField:@"sign"];
//    [request setValue:[NSString stringWithFormat:@"%d",time] forHTTPHeaderField:@"atime"];
//    NSError *error=nil;
//    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    if(error)
//    {
//        NSLog(@"%@",error.description);
//    }
//  
//
//    NSString *resstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",resstring);
    // Do any additional setup after loading the view.
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
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
    return 3;
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
    
    return cell;

    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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

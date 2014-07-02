//
//  CYDoctorViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-2.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "CYDoctorViewController.h"
#import "ETKids.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
@interface CYDoctorViewController ()

@end

@implementation CYDoctorViewController
@synthesize doctor;
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
    // Do any additional setup after loading the view.
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
    middleLabel.text = @"医生信息";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    __tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStyleGrouped];
    __tableView.backgroundView = nil;
    __tableView.backgroundColor = CELLCOLOR;
    __tableView.delegate = self;
    __tableView.dataSource = self;
   // __tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:__tableView];
    
    
    tableViewHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,__tableView.frame.size.width, 150)];
    
    UIImageView *photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 75, 75)];
    photoImageView.backgroundColor=[UIColor clearColor];
    photoImageView.tag=1003;
    [tableViewHeaderView addSubview:photoImageView];
    [photoImageView release];
    
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, __tableView.frame.size.width-90, 20)];
    nameLabel.backgroundColor=[UIColor clearColor];
    //nameLabel.text=@"你好吧";
    nameLabel.tag=1000;
    [tableViewHeaderView addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *levellabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, __tableView.frame.size.width-90, 20)];
    levellabel.backgroundColor=[UIColor clearColor];
    //levellabel.text=@"三级医院主治医师";
    levellabel.tag=1001;
    levellabel.font=[UIFont systemFontOfSize:15];
    [tableViewHeaderView addSubview:levellabel];
    [levellabel release];
    
    UILabel *hospatial=[[UILabel alloc]initWithFrame:CGRectMake(90, 50, __tableView.frame.size.width-90, 20)];
    hospatial.backgroundColor=[UIColor clearColor];
    //hospatial.text=@"北京市京坛医院";
    hospatial.tag=1002;
    hospatial.font=[UIFont systemFontOfSize:15];
    [tableViewHeaderView addSubview:hospatial];
    [hospatial release];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 85, __tableView.frame.size.width-10, 50)];
    imageView.backgroundColor=[UIColor whiteColor];

    [tableViewHeaderView addSubview:imageView];
    [imageView release];
    
    UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(5+10, 85+10, __tableView.frame.size.width-10-20, 30)];
    contentlabel.backgroundColor=[UIColor clearColor];
   
    contentlabel.tag=1004;
    contentlabel.font=[UIFont systemFontOfSize:15];
    [tableViewHeaderView addSubview:contentlabel];
    [contentlabel release];
    
    
    tableViewHeaderView.backgroundColor=[UIColor clearColor];
    __tableView.tableHeaderView=[tableViewHeaderView autorelease];
    
    NSString *urlStr=[NSString stringWithFormat:@"http://yzxc.summer2.chunyu.me/partner/yzxc/doctor/%@/detail",self.doctor.docid];
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setDelegate:self];
    //request代理为本类
    [request setTimeOutSeconds:10];
    [request setDidFailSelector:@selector(urlRequestFailed:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
    [request startAsynchronous];
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
}
-(void)urlRequestSucceeded:(ASIHTTPRequest *)request
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    NSLog(@"%@",request.responseHeaders);

    NSLog(@"%@",request.responseString);
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if(dic)
    {

   
      //  imageView.tag=1003;
       // contentlabel.tag=;
        
        
        UILabel *nameLabel=(UILabel *)[tableViewHeaderView viewWithTag:1000];
        nameLabel.text=[dic objectForKey:@"name"];
        
        UILabel *Level=(UILabel *)[tableViewHeaderView viewWithTag:1001];
        Level.text=[dic objectForKey:@"level_title"];
        
        UILabel *hosptatal=(UILabel *)[tableViewHeaderView viewWithTag:1002];
        hosptatal.text=[dic objectForKey:@"hospital"];
        
        UIImageView *iamgeViewp=(UIImageView *)[tableViewHeaderView viewWithTag:1003];
        //hosptatal.text=[dic objectForKey:@"hospital"];
        
        [iamgeViewp setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"doc_image"]] placeholderImage:nil];
        
        UILabel *content=(UILabel *)[tableViewHeaderView viewWithTag:1004];
        content.text=[dic objectForKey:@"welcome"];
        
        NSArray *arr=[dic objectForKey:@"index"];
        self.tuijianArr=arr;
//        "index": [
//                  {
//                      "trend": false,
//                      "rate": 86,
//                      "name": "推荐指数",
//                      "hint": "低于同行6.6%"
//                  },
//                  {
//                      "trend": false,
//                      "rate": 80,
//                      "name": "服务态度",
//                      "hint": "低于同行11.1%"
//                  },
//                  {
//                      "trend": false,
//                      "rate": 80,
//                      "name": "医术水平",
//                      "hint": "低于同行11.1%"
//                  }
//                  ],
    }
    
    [__tableView reloadData];
}
-(void)urlRequestFailed:(ASIHTTPRequest *)request
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    NSLog(@"%@",request.error.description);

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    return [_tuijianArr count];
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
       // cell.backgroundView=nil;

        UILabel *tuijianlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        tuijianlabel.backgroundColor=[UIColor clearColor];
        tuijianlabel.tag=100;
        
        [cell.contentView addSubview:tuijianlabel];
        [tuijianlabel release];
            
        UILabel *numlabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 50, 20)];
        numlabel.backgroundColor=[UIColor clearColor];
        numlabel.tag=101;
        numlabel.textColor=[UIColor redColor];
        [cell.contentView addSubview:numlabel];
        [numlabel release];
            

        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(190, 10, 10, 20)];
        iamgeView.backgroundColor=[UIColor redColor];
        iamgeView.tag=102;
        [cell.contentView addSubview:iamgeView];
        [iamgeView release];
        
        UILabel *contentlabgel=[[UILabel alloc]initWithFrame:CGRectMake(205, 10, 100, 20)];
        contentlabgel.backgroundColor=[UIColor clearColor];
        contentlabgel.tag=103;
        contentlabgel.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:contentlabgel];
        [contentlabgel release];
        
     
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=@"";
    UILabel * tuijianlabel=(UILabel *) [cell.contentView viewWithTag:100];
    UILabel * number=(UILabel *) [cell.contentView viewWithTag:101];
    UIImageView * iamgeVuiew=(UIImageView *) [cell.contentView viewWithTag:102];
    UILabel * contentlabel=(UILabel *) [cell.contentView viewWithTag:103];
    if(indexPath.section==0)
    {
        tuijianlabel.text=[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        tuijianlabel.frame=CGRectMake(10, 10, 80, 20);
    
        number.text=[NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"rate"]];
        number.frame=CGRectMake(90, 10, 50, 20);

        iamgeVuiew.frame=CGRectMake(190, 10, 10, 20);
        NSString *up= [NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"trend"]];
        if([up isEqualToString:@"0"])
        {
            // false
            
        }
        else
        {
            
        }

        contentlabel.frame=CGRectMake(205, 10, 100, 20);
        contentlabel.text=[NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"hint"]];
        
    }
    else if(indexPath.section==1)
    {
        tuijianlabel.frame=CGRectZero;
        number.frame=CGRectZero;
        iamgeVuiew.frame=CGRectZero;
        contentlabel.frame=CGRectZero;
        
        if(indexPath.row==0)
        {
            cell.backgroundColor=[UIColor colorWithRed:96/255.0 green:176/255.0 blue:198/255.0 alpha:1];
            
            cell.textLabel.text=@"认证信息";
        }
    }
    
    // cell.textLabel.text=detail.created_time_ms;
    
    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 40;
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
            return 40;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
        return 20;
    return 0;
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
    self.doctor=nil;
    self._tableView=nil;
    self.tuijianArr=nil;
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

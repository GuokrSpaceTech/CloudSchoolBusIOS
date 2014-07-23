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
    middleLabel.text =NSLocalizedString(@"doctor_infomation", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    __tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)) style:UITableViewStyleGrouped];
    __tableView.backgroundView = nil;
    __tableView.backgroundColor = CELLCOLOR;
    __tableView.delegate = self;
    __tableView.dataSource = self;
    __tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    nameLabel.textColor=[UIColor grayColor];
    nameLabel.tag=1000;
    [tableViewHeaderView addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *levellabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, __tableView.frame.size.width-90, 20)];
    levellabel.backgroundColor=[UIColor clearColor];
    //levellabel.text=@"三级医院主治医师";
    levellabel.textColor=[UIColor grayColor];
    levellabel.tag=1001;
    levellabel.font=[UIFont systemFontOfSize:15];
    [tableViewHeaderView addSubview:levellabel];
    [levellabel release];
    
    UILabel *hospatial=[[UILabel alloc]initWithFrame:CGRectMake(90, 50, __tableView.frame.size.width-90, 20)];
    hospatial.backgroundColor=[UIColor clearColor];
    //hospatial.text=@"北京市京坛医院";
    hospatial.textColor=[UIColor grayColor];
    hospatial.tag=1002;
    hospatial.font=[UIFont systemFontOfSize:15];
    [tableViewHeaderView addSubview:hospatial];
    [hospatial release];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 85, 282, 56)];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.image=[UIImage imageNamed:@"health_doctor_content.png"];
    [tableViewHeaderView addSubview:imageView];
    [imageView release];
    
    UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 85+10, 270, 40)];
    contentlabel.numberOfLines=0;
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
        
        [iamgeViewp setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"doc_image"]] placeholderImage:[UIImage imageNamed:@"health_doctor.png"]];
        
        UILabel *content=(UILabel *)[tableViewHeaderView viewWithTag:1004];
        content.text=[dic objectForKey:@"welcome"];
        
        NSArray *arr=[dic objectForKey:@"index"];
        self.tuijianArr=arr;
        
        
        NSString * desc=[dic objectForKey:@"description"];
        NSString *gootat=[dic objectForKey:@"good_at"];
        
    
    
        
        NSArray *temp=[NSArray arrayWithObjects:desc,gootat, nil];
        //description
        self.renzhenArr=temp;

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
    return ([_renzhenArr count]==0?0:([_renzhenArr count]+1));
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
       
            static NSString *cell1=@"cell1";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell1];
            if(cell==nil)
            {
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundView=nil;
                
                if(indexPath.row==0)
                {
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 50)];
                    iamgeView.backgroundColor=[UIColor clearColor];
                    iamgeView.image=[UIImage imageNamed:@"health__top.png"];
                    [cell.contentView addSubview:iamgeView];
                    [iamgeView release];
                }
                else if(indexPath.row==[self.tuijianArr count]-1)
                {
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 50)];
                    iamgeView.backgroundColor=[UIColor clearColor];
                    iamgeView.image=[UIImage imageNamed:@"health_bottom.png"];
                    [cell.contentView addSubview:iamgeView];
                    [iamgeView release];
                }
                else
                {
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 50)];
                    //iamgeView.backgroundColor=[UIColor redColor];
                    iamgeView.image=[UIImage imageNamed:@"health_middle"];
                    [cell.contentView addSubview:iamgeView];
                    [iamgeView release];
                }
                UILabel *tuijianlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 20)];
                tuijianlabel.backgroundColor=[UIColor clearColor];
                tuijianlabel.tag=100;
                [cell.contentView addSubview:tuijianlabel];
                [tuijianlabel release];
                
                UILabel *numlabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 15, 50, 20)];
                numlabel.backgroundColor=[UIColor clearColor];
                numlabel.tag=101;
                numlabel.textColor=[UIColor redColor];
                [cell.contentView addSubview:numlabel];
                [numlabel release];


                UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(190, 20, 8, 12)];
                iamgeView.backgroundColor=[UIColor clearColor];
                iamgeView.tag=102;
                [cell.contentView addSubview:iamgeView];
                [iamgeView release];

                UILabel *contentlabgel=[[UILabel alloc]initWithFrame:CGRectMake(205, 15, 100, 20)];
                contentlabgel.backgroundColor=[UIColor clearColor];
                contentlabgel.tag=103;
                contentlabgel.font=[UIFont systemFontOfSize:12];
                [cell.contentView addSubview:contentlabgel];
                [contentlabgel release];
            }
                UILabel * tuijianlabel=(UILabel *) [cell.contentView viewWithTag:100];
                UILabel * number=(UILabel *) [cell.contentView viewWithTag:101];
                UIImageView * iamgeVuiew=(UIImageView *) [cell.contentView viewWithTag:102];
                UILabel * contentlabel=(UILabel *) [cell.contentView viewWithTag:103];
            
            tuijianlabel.text=[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"name"];
           // tuijianlabel.frame=CGRectMake(10, 10, 80, 20);

            number.text=[NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"rate"]];
            //number.frame=CGRectMake(90, 10, 50, 20);

            //iamgeVuiew.frame=CGRectMake(190, 10, 10, 20);
            NSString *up= [NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"trend"]];
            if([up isEqualToString:@"0"])
            {
                // false
                iamgeVuiew.image=[UIImage imageNamed:@"health_doctor_down.png"];

            }
            else
            {
                 iamgeVuiew.image=[UIImage imageNamed:@"health_doctor_up.png"];
            }

            //contentlabel.frame=CGRectMake(205, 10, 100, 20);
            contentlabel.text=[NSString stringWithFormat:@"%@",[[self.tuijianArr objectAtIndex:indexPath.row] objectForKey:@"hint"]];
            //

              return cell;
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            static NSString *cell2=@"cell2";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell2];
            if(cell==nil)
            {
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.backgroundView=nil;
                  cell.selectionStyle=UITableViewCellSelectionStyleNone;
      

                if(indexPath.row==0)
                {
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 36)];
                    iamgeView.backgroundColor=[UIColor clearColor];
                    iamgeView.image=[UIImage imageNamed:@"health_topblue.png"];
                    [cell.contentView addSubview:iamgeView];
                    [iamgeView release];
                }
                
                UILabel *renzhenLabeel=[[UILabel alloc]initWithFrame:CGRectMake(20, 8, 100, 20)];
                renzhenLabeel.backgroundColor=[UIColor clearColor];
                renzhenLabeel.tag=200;
                renzhenLabeel.textColor=[UIColor whiteColor];
                renzhenLabeel.font=[UIFont systemFontOfSize:15];
                [cell.contentView addSubview:renzhenLabeel];
                [renzhenLabeel release];
                
            }
            UILabel * title=(UILabel *) [cell.contentView viewWithTag:200];
            title.text=NSLocalizedString(@"doctor_Authentication", @"");
            return cell;
        }
        else
        {
            static NSString *cell3=@"cell3";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell3];
            if(cell==nil)
            {
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell3] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.backgroundView=nil;
                  cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if(indexPath.row==[_renzhenArr count])
                {
                    // di
                    
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 50)];
                    iamgeView.backgroundColor=[UIColor clearColor];
                  //  iamgeView.image=[UIImage imageNamed:@"health_bottom.png"];
                    [cell.contentView addSubview:iamgeView];
                    iamgeView.tag=803;
                    [iamgeView release];
               
                }
                else
                {
                    //mid
                    
                    UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 306, 50)];
                    //iamgeView.backgroundColor=[UIColor redColor];
                    iamgeView.image=[UIImage imageNamed:@"health_middle"];
                     iamgeView.tag=804;
                    [cell.contentView addSubview:iamgeView];
                    [iamgeView release];
                }
                
                UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
                titleLabel.backgroundColor=[UIColor clearColor];
                titleLabel.tag=800;
                [cell.contentView addSubview:titleLabel];
                [titleLabel release];
                
                UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 280, 20)];
                contentlabel.backgroundColor=[UIColor clearColor];
                contentlabel.tag=801;
                contentlabel.numberOfLines=0;
                contentlabel.lineBreakMode=NSLineBreakByCharWrapping;
                contentlabel.font=[UIFont systemFontOfSize:15];
               // contentlabel.textColor=[UIColor clearColor];
                [cell.contentView addSubview:contentlabel];
                [contentlabel release];

                
                
            }
            UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:800];
            UILabel *contentlabel=(UILabel *)[cell.contentView viewWithTag:801];
            
            UIImageView *bottom=(UIImageView *)[cell.contentView viewWithTag:803];
            UIImageView *middle=(UIImageView *)[cell.contentView viewWithTag:804];
            
            if(indexPath.row==1)
            {
                titleLabel.text=@"个人信息:";
            }
            else
            {
                titleLabel.text=@"擅长领域:";
            }
     
              contentlabel.text=[_renzhenArr objectAtIndex:indexPath.row-1];
            CGSize size=[[_renzhenArr objectAtIndex:indexPath.row-1] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping];
          
            contentlabel.frame=CGRectMake(15, 30, 280, size.height);
            contentlabel.backgroundColor=[UIColor clearColor];

            middle.frame=CGRectMake(7, 0, 306, size.height + 20 +20);
        
            UIImage *image=[UIImage imageNamed:@"health_bottom.png"];
            [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
            bottom.frame=CGRectMake(7, 0, 306, size.height + 20 +20);
            bottom.image=image;
            //iamgeView.frame=
            //cell.textLabel.text=@"h";
            return cell;

        }
        

    }
    return nil;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 50;
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
            return 35;
        else
        {
          //  contentlabel.text=[_renzhenArr objectAtIndex:indexPath.row-1];
            CGSize size=[[_renzhenArr objectAtIndex:indexPath.row-1] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            
          //  contentlabel.frame=CGRectMake(10, 30, 280, size.height);
           // contentlabel.backgroundColor=[UIColor redColor];
            
            return size.height+20+20;
            

        }
    }
    return 0;
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
    self.renzhenArr=nil;
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

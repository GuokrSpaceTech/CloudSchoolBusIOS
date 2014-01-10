//
//  GKNoticeInfoViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-10.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeInfoViewController.h"
#import "GKNotice.h"
#import "KKNavigationController.h"
@interface GKNoticeInfoViewController ()

@end

@implementation GKNoticeInfoViewController
@synthesize notice;
@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y ) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
   // _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
    int height=0;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.text=notice.noticetitle;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [headView addSubview:titleLabel];
    titleLabel.font=[UIFont systemFontOfSize:16];
    [titleLabel release];
    CGSize size=[notice.noticetitle sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    // 10  10
    
    titleLabel.frame=CGRectMake(10, 10+height, 300, size.height);
    height+=size.height+5;
    
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.text=notice.noticecontent;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [headView addSubview:contentLabel];
    [contentLabel release];

    size=[notice.noticecontent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    contentLabel.frame=CGRectMake(20, 10+height, 280, size.height);
    height+=size.height+5;

//    plist =         (
//                     {
//                         filename = 13889686805313660;
//                         iscloud = 0;
//                         source = "http://v3.service.yunxiaoche.com/files/notice/2/57/360/201401/13889686805313660.jpg";
//                     }
//                     );

    // pic
    
    if([notice.plist count]==1)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(110,10+height,100,100)];
        imageView.backgroundColor=[UIColor redColor];
        [headView addSubview:imageView];
        [imageView release];
        
        height+=(100+5);
        

    }
    else if([notice.plist count]>1)
    {
        for (int i=0; i<[notice.plist count]; i++) {
            
            int row =i/4;
            int col=i%4;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12+col*(65+12), (10+height)+row*(65+10) , 65, 65)];
            imageView.backgroundColor=[UIColor redColor];
            [headView addSubview:imageView];
            [imageView release];
            
        }
        
        int row=(ceil([notice.plist count]/4.0));
        
        height+=(row*65) +(row-1)*10 +5;
        
    }
    

    
    headView.frame=CGRectMake(0, 0, 320,10+height);
    _tableView.tableHeaderView=headView;
    [headView release];
    
    
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([notice.isconfirm integerValue]==1)
    {
        return 2;
    }
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([notice.isconfirm integerValue]==1)
    {
        return [notice.sisconfirm count]==0?1:[notice.sisconfirm count];
    }
    else
        return [notice.slistname count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section==0)
    {
        if([notice.isconfirm integerValue]==1)
        {
            if([notice.sisconfirm count]==0)
            {
                cell.textLabel.text=@"暂无回执";
            }
            else
            {
                 cell.textLabel.text=[notice.sisconfirm objectAtIndex:indexPath.row];
            }
        }
        else
        {
              cell.textLabel.text=[notice.slistname objectAtIndex:indexPath.row];
        }

    }
    else
    {
         cell.textLabel.text=[notice.slistname objectAtIndex:indexPath.row];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:12];
   // cell.textLabel.text=[notice.slistname objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=[UIColor grayColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label release];
    
     if([notice.isconfirm integerValue]==1)
     {
        if(section==0)
        {
            label.text=@"谁回执给了你";
        }
        if(section==1)
        {
            label.text=@"你发给了谁";
        }
     }
    else
    {
        label.text=@"你发给了谁";
    }
    return [view autorelease];
}
-(void)dealloc
{
    self.notice=nil;
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

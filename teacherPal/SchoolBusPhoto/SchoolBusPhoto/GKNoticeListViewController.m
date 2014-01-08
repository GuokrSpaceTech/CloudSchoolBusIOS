//
//  GKNoticeListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeListViewController.h"
#import "KKNavigationController.h"

#import "GKNotice.h"
@interface GKNoticeListViewController ()

@end

@implementation GKNoticeListViewController
@synthesize noticeList;
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
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    noticeList=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y ) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    titlelabel.text=@"通知";
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];

    
     [[EKRequest Instance]EKHTTPRequest:tnotice parameters:param requestMethod:GET forDelegate:self];
  
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noticeList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    GKNotice *notice=[noticeList objectAtIndex:indexPath.row];
    cell.textLabel.text=notice.addtime;
    
    return cell;
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"sendfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(code==1&&method==tnotice)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",arr);
        
        for (int i=0; i<[arr count]; i++) {
            NSDictionary *dic=[arr objectAtIndex:i];
            GKNotice *notice=[[GKNotice alloc]init];
            
            notice.addtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
            notice.adduserid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adduserid"]];
            notice.isconfirm=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isconfirm"]];
            notice.noticecontent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticecontent"]];
            notice.noticeid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticeid"]];
            
            notice.noticetitle=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticetitle"]];
            notice.plist=[dic objectForKey:@"plist"];
            notice.slistname=[dic objectForKey:@"slistname"];
            [noticeList addObject:notice];
            [notice release];
        }
        
        [_tableView reloadData];
    }
}
-(void)dealloc
{
    self.noticeList=nil;
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

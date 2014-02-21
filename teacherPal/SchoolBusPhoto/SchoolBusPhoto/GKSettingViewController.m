//
//  GKSettingViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSettingViewController.h"
#import "GKMainViewController.h"
#import "KKNavigationController.h"
#import "GKWebViewController.h"
#import "GKRePasswordViewController.h"
#import "GKAboutViewController.h"
@interface GKSettingViewController ()

@end

@implementation GKSettingViewController
@synthesize _tableView;
@synthesize delegate;
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
    titlelabel.text=NSLocalizedString(@"leftSetting", @"");
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if(indexPath.row==0)
        cell.textLabel.text=NSLocalizedString(@"passwordalter", @"");
    else if(indexPath.row==1)
        cell.textLabel.text=NSLocalizedString(@"aboutus", @"");
    else if(indexPath.row==2)
        cell.textLabel.text=NSLocalizedString(@"helpSupport", @"");


    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0)
    {
        GKRePasswordViewController *passVC= [[GKRePasswordViewController alloc]init];
        passVC.delegate=self;
        [self.navigationController pushViewController:passVC animated:YES];
        [passVC release];
        
        return;
    }
    
    UIViewController *VC=nil;
    switch (indexPath.row) {
        case 0:
            VC=[[GKRePasswordViewController alloc]init];
            break;
        case 1:
            VC=[[GKAboutViewController alloc]initWithNibName:@"GKAboutViewController" bundle:nil];
          
           // VC.urlstr=@"http://cloud.yunxiaoche.com/html/privacy.html";
            
            //VC.titlestr=NSLocalizedString(@"privacy", @"");

            
            break;
        case 2:
            VC=[[GKWebViewController alloc]init];
            
            break;
              default:
            break;
    }
    if(indexPath.row==2)
    {
        GKWebViewController *web=(GKWebViewController *)VC;
        web.urlstr=@"http://www.yunxiaoche.com/help/teacher.html";
        web.titlestr=  titlelabel.text=NSLocalizedString(@"helpSupport", @"");;
        [self.navigationController pushViewController:web animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    [VC release];
    
}
-(void)loginout
{
    [delegate settingLoginOut];
}
-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}
-(void)viewDidUnload
{
    [_tableView release];
    _tableView=nil;
    [super viewDidUnload];
}
-(void)dealloc
{
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

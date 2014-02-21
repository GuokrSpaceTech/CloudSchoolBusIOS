//
//  GKClassViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKClassViewController.h"
#import "GKInfoViewController.h"
#import "GKUpLoaderViewController.h"
#import "GKStudentListViewController.h"
#import "GKMainViewController.h"
#import "GKDraftViewController.h"
@interface GKClassViewController ()

@end

@implementation GKClassViewController
@synthesize _tableView;
@synthesize arr;
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
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    titlelabel.text=NSLocalizedString(@"class", @"");
   // _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, <#CGFloat height#>) style:<#(UITableViewStyle)#>];
	// Do any additional setup after loading the view.
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    self.arr=[NSArray arrayWithObjects:NSLocalizedString(@"classFen", @""),NSLocalizedString(@"uploadQ", @""),NSLocalizedString(@"studentQ", @""), nil];
    

     //self.arr=[NSArray arrayWithObjects:@"班级积分",@"上传列表",@"班级学生", nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
      
    }
    if(indexPath.row==0)
        cell.imageView.image=[UIImage imageNamed:@"班级积分.png"];
    else if(indexPath.row==1)
        cell.imageView.image=[UIImage imageNamed:@"上传列表.png"];
    else if(indexPath.row == 2)
        cell.imageView.image=[UIImage imageNamed:@"班级学生.png"];
    else
        cell.imageView.image=[UIImage imageNamed:@"草稿箱.png"];
    cell.textLabel.text=[arr objectAtIndex:indexPath.row];
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *VC=nil;
    switch (indexPath.row) {
        case 0:
            VC=[[GKInfoViewController alloc]init];
            break;
        case 1:
            VC=[[GKUpLoaderViewController alloc]init];
            break;
        case 2:
            VC=[[GKStudentListViewController alloc]init];
            break;
        case 3:
            VC=[[GKDraftViewController alloc]init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
    
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
    self.arr=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

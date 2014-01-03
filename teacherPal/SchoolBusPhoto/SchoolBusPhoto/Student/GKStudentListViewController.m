//
//  GKStudentListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKStudentListViewController.h"
#import "GKUserLogin.h"
#import "Student.h"

#import "GKStudentInfoViewController.h"
@interface GKStudentListViewController ()

@end

@implementation GKStudentListViewController
@synthesize _tableView;
@synthesize studentArr;
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
    
   
    
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    self.studentArr= user.studentArr;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-57-10) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

	// Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [studentArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    Student *st=[studentArr objectAtIndex:indexPath.row];
    cell.textLabel.text=st.cnname;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Student *st=[studentArr objectAtIndex:indexPath.row];
    GKStudentInfoViewController *infoVC=[[GKStudentInfoViewController alloc]init];
    infoVC.st=st;
    [self.navigationController pushViewController:infoVC animated:YES];
    [infoVC release];
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
    self.studentArr=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

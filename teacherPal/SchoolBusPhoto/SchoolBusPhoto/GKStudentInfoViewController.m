//
//  GKStudentInfoViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKStudentInfoViewController.h"
#import "KKNavigationController.h"



#define TAGCELL 500


@interface GKStudentInfoViewController ()

@end

@implementation GKStudentInfoViewController
@synthesize st;
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
    
    titlelabel.text=@"详细资料";
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
    self.arr=[NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"生日", nil];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else
        return [arr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 11, 100, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.tag=TAGCELL;
        namelabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        
        
        UILabel *reallabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 11, 100, 20)];
        reallabel.backgroundColor=[UIColor clearColor];
        reallabel.tag=TAGCELL+1;
        if(IOSVERSION>=6.0)
            reallabel.textAlignment=NSTextAlignmentRight;
        else
            reallabel.textAlignment=UITextAlignmentRight;
        reallabel.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:reallabel];
        [reallabel release];
        
        
    }
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:TAGCELL];
    UILabel *realLabel=(UILabel *)[cell.contentView viewWithTag:TAGCELL+1];
    
    if(indexPath.section==0)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        nameLabel.text=@"姓名";
        realLabel.text=st.cnname;
    }
    else
    {
          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                nameLabel.text=@"头像";
                break;
            case 1:
                nameLabel.text=@"昵称";
                realLabel.text=st.enname;
                break;
            case 2:
                nameLabel.text=@"性别";
                
                switch ([st.sex intValue]) {
                    case 1:
                      realLabel.text=@"小公主";
                        break;
                    case 2:
                      realLabel.text=@"小王子";
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                nameLabel.text=@"生日";
                realLabel.text=st.birthday;
                break;
            default:
                break;
        }
    }
    return cell;
}
-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidUnload
{
    [_tableView release];
    _tableView=nil;
    [super viewDidUnload];
}
-(void)dealloc
{
    self.st=nil;
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

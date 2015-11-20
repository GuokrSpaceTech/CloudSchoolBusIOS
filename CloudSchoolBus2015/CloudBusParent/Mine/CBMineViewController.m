//
//  CBMineViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBMineViewController.h"
#import "MineHeaderView.h"
#import "Masonry.h"
#import "CBLoginInfo.h"
#import "Student.h"
#import "School.h"
#import "ClassObj.h"
#import "UIImageView+WebCache.h"
#import "MineCell.h"
#import "Calculate.h"
#import "CB.h"
#import "UIColor+RCColor.h"
@interface CBMineViewController ()
{
    MineHeaderView * headeView;
}
@end

@implementation CBMineViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"我的";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   [self.tableView registerClass:[MineCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 44;
    headeView = [[MineHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];

    [self currentStudent];
    
    self.tableView.tableHeaderView  = headeView;

    
    //退出按钮
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(0, 0, 100, 100);
    [button addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
   // [self.tableView bringSubviewToFront:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(SCREENWIDTH-40));
        make.top.equalTo(self.view.mas_top).offset(280);
        make.height.mas_equalTo(@(40));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}
-(void)quit:(UIButton *)btn
{
    
}
-(void)currentStudent
{
      CBLoginInfo * info = [CBLoginInfo shareInstance];
    
    Student * student = nil;
    
    for (Student *st in info.studentArr) {
        if([st.studentid isEqualToString:info.currentStudentId])
        {
            student = st;
            break;
        }
    }
    
    if(student != nil)
    {
        [headeView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:student.avatar] placeholderImage:nil];
        headeView.nameLabel.text = student.cnname;
        NSString * schoolname = @"";
        for(School * sc in info.schoolArr)
        {
            NSArray * arr = sc.classesArr;
            
            for (ClassObj * cla in arr) {
                //cla.studentidArr
            
                if([cla.studentidArr containsObject:info.currentStudentId])
                {
                    schoolname = [NSString stringWithFormat:@"%@",sc.schoolName];
                }
            }
        }
        
        //Resize the label
        headeView.schoolLabel.text = schoolname;
        CGRect labelRect = [schoolname
                            boundingRectWithSize:CGSizeMake(200, 0)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}
                            context:nil];
        headeView.schoolLabel.frame = labelRect;
        headeView.schoolLabel.font = [UIFont systemFontOfSize:16.0f];
        headeView.schoolLabel.textColor = [UIColor whiteColor];
        headeView.schoolLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        headeView.schoolLabel.textAlignment = NSTextAlignmentCenter;
        headeView.schoolLabel.adjustsFontSizeToFitWidth = YES;
        [headeView.schoolLabel.layer setCornerRadius:10.0];//Set corner radius of label to change the shape.
        [headeView.schoolLabel.layer setBorderWidth:2.0f];//Set border width of label.
        [headeView.schoolLabel  setClipsToBounds:YES];//Set its to YES for Corner radius to work.
        [headeView.schoolLabel.layer setBorderColor:[UIColor whiteColor].CGColor];//Set Border color.
        [headeView.schoolLabel  setBackgroundColor:[UIColor colorWithHexString:@"#ED7426" alpha:1.0f]];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.textLabel.text = @"dd";
    if(indexPath.row == 0)
    {
        cell.titleLabel.text = @"切换孩子";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_swap_horiz"];
        cell.iconImageView.contentMode = UIViewContentModeCenter;
        cell.detailLabel.text = @"";
    }
    else if(indexPath.row == 1)
    {
        cell.titleLabel.text = @"清除缓存";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_settings"];
        cell.iconImageView.contentMode = UIViewContentModeCenter;
        cell.detailLabel.text = [NSString stringWithFormat:@"%0.2fM",[Calculate checkTmpSize]];;
    }
    else
    {
        cell.titleLabel.text = @"关于我们";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_info_outline"];
        cell.iconImageView.contentMode = UIViewContentModeCenter;
        cell.detailLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        
    }
    else if(indexPath.row == 1)
    {
        [Calculate clearTmpPics:^{
             [self.tableView reloadData];
        }];
       
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

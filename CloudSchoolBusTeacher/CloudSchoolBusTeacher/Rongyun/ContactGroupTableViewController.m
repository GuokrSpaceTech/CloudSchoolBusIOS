//
//  ContactGroupTableViewController.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/23.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "ContactGroupTableViewController.h"
#import "TeacherViewController.h"
#import "ContactGroupTableViewCell.h"
#import "CBLoginInfo.h"
#import "ClassObj.h"
#import "RYMessage.h"
#import "JSBadgeView.h"
#import "MessageState.h"
#import "ContactGroup.h"

@interface ContactGroupTableViewController ()
{
}

@end

@implementation ContactGroupTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"联系人分组";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:@"MESSAGETEACHER" object:nil];
    
    //Register the Cell Class
    [self.tableView registerClass:[ContactGroupTableViewCell class] forCellReuseIdentifier:@"contactgroupcell"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [CBLoginInfo shareInstance].contactGroupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactgroupcell" forIndexPath:indexPath];
    
    ContactGroup *contactGroup = [CBLoginInfo shareInstance].contactGroupArr[indexPath.row];
    
    NSString *labelText = contactGroup.classname;
    
    if([contactGroup.role isEqualToString:@"parents"])
    {
        labelText = [labelText stringByAppendingString:@"家长"];
        [cell setIcon:[UIImage imageNamed:@"ic_group"]];
    }
    else
    {
        labelText =	 [labelText stringByAppendingString:@"教师"];
        [cell setIcon:[UIImage imageNamed:@"ic_school"]];
    }
    
    cell.groupNameLabel.text = labelText;
    
    if(contactGroup.messagecnt>0)
    {
        [cell setBadge:contactGroup.messagecnt];
    } else {
        [cell clearBadge];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactGroup *contactGroup = [CBLoginInfo shareInstance].contactGroupArr[indexPath.row];
    contactGroup.messagecnt = 0;
    
    [tableView reloadData];
    
    TeacherViewController *teacherVC = [[TeacherViewController alloc] init];
    teacherVC.contactArray = contactGroup.contactList;
    teacherVC.viewTitle = contactGroup.classname;
    
    // Push the view controller.
    [self.navigationController pushViewController:teacherVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    TeacherViewController *teacherVC = [[TeacherViewController alloc] init];
//    teacherVC.classInfo = contactGroupArr[indexPath.row];
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:teacherVC animated:YES];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark == Notification Receiver
-(void)receiveMessage:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end

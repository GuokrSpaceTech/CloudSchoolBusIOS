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

@interface ContactGroupTableViewController ()
{
    NSMutableArray *contactGroupArr;
}

@end

@implementation ContactGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
     * Load the contact group array
     */
    contactGroupArr = [[NSMutableArray alloc]init];
    for(ClassObj *classinfo in [CBLoginInfo shareInstance].classArr)
    {
        NSString *className = classinfo.className;
        NSString *classId   = classinfo.classid;
        
        //家长组
        NSArray *keyArr = [[NSArray alloc]initWithObjects:@"classname",@"classid",@"role",nil];
        NSArray *parentsObjectArr = [[NSArray alloc]initWithObjects:className,classId,@"parents", nil];
        NSDictionary *classParentsDict = [NSDictionary dictionaryWithObjects:parentsObjectArr forKeys:keyArr];
        [contactGroupArr addObject:classParentsDict];
        
        //教师组
        NSArray *teacherObjectArr = [[NSArray alloc]initWithObjects:className,classId,@"teacher", nil];
        NSDictionary *classTeacherDict = [NSDictionary dictionaryWithObjects:teacherObjectArr forKeys:keyArr];
        [contactGroupArr addObject:classTeacherDict];
        
    }
    
    //Register the Cell Class
    [self.tableView registerClass:[ContactGroupTableViewCell class] forCellReuseIdentifier:@"contactgroupcell"];
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
    return contactGroupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactgroupcell" forIndexPath:indexPath];
    
    NSString *labelText = [contactGroupArr[indexPath.row] objectForKey:@"classname"];
    if([[contactGroupArr[indexPath.row] objectForKey:@"role"] isEqualToString:@"parents"])
    {
        labelText = [labelText stringByAppendingString:@" 家长"];
    }
    else
    {
        labelText = [labelText stringByAppendingString:@" 教师"];
    }
    
    cell.groupNameLabel.text = labelText;
    
    return cell;
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TeacherViewController *teacherVC = [[TeacherViewController alloc] init];
    teacherVC.classInfo = contactGroupArr[indexPath.row];
    
    // Push the view controller.
    [self.navigationController pushViewController:teacherVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

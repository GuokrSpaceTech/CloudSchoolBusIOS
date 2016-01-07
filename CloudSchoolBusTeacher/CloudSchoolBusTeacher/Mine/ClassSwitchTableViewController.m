//
//  ClassSwitchTableViewController.m
//  CloudSchoolBusTeacher
//
//  Created by mactop on 1/7/16.
//  Copyright © 2016 BeiJingYinChuang. All rights reserved.
//

#import "ClassSwitchTableViewController.h"
#import "ClassTableViewCell.h"
#import "CBLoginInfo.h"

@interface ClassSwitchTableViewController ()

@end

@implementation ClassSwitchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title
    self.navigationItem.title = @"切换班级";
    
    //Cell Class
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"classcell"];
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
    return _classArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classcell" forIndexPath:indexPath];
    
    ClassObj *classinfo = [[CBLoginInfo shareInstance].classArr objectAtIndex:indexPath.row];
    
    NSString *schoolid = classinfo.schoolid;
    
    //Find the school
    for(int i=0; i<[CBLoginInfo shareInstance].schoolArr.count; i++)
    {
        School *school = [[CBLoginInfo shareInstance].schoolArr objectAtIndex:i];
        
        if([school.id isEqualToString:schoolid])
        {
            cell.schoolNameLabel.text = school.name;
            break;
        }
    }
    
    cell.classNameLabel.text = classinfo.className;
    
    if( [[CBLoginInfo shareInstance].currentClassId isEqualToString:classinfo.classid])
    {
        cell.selectionIndicatorImg.image = [UIImage imageNamed:@"checked"];
    } else {
        cell.selectionIndicatorImg.image = [UIImage imageNamed:@"unchecked"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBLoginInfo *info = [CBLoginInfo shareInstance];
    info.currentClassId = [[info.classArr objectAtIndex:indexPath.row] classid];
    
    ClassObj *classinfo = [[CBLoginInfo shareInstance].classArr objectAtIndex:indexPath.row];
    
    ClassTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if( [[CBLoginInfo shareInstance].currentClassId isEqualToString:classinfo.classid])
    {
        cell.selectionIndicatorImg.image = [UIImage imageNamed:@"checked"];
    } else {
        cell.selectionIndicatorImg.image = [UIImage imageNamed:@"unchecked"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchclass" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
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

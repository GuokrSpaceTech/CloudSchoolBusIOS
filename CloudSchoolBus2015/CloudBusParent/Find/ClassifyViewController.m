//
//  ClassifyViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/17.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassifyTableViewCell.h"
@interface ClassifyViewController ()
{
    NSArray *clasifyArr;
    NSArray *iconImageArr;
}
@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    clasifyArr = @[@"班级通知",@"今日考勤",@"视频公开课",@"班级报告",@"相册"];
    iconImageArr = @[ [UIImage imageNamed:@"notice"],[UIImage imageNamed:@"timecard"], [UIImage imageNamed:@"video"],[UIImage imageNamed:@"report"],[UIImage imageNamed:@"picture"] ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView registerClass:[ClassifyTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [clasifyArr count];;
}


- (ClassifyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassifyTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.imageIconView setImage:iconImageArr[indexPath.row]];
    cell.label.text = clasifyArr[indexPath.row];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.delegate selectedTableRow:indexPath.row];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

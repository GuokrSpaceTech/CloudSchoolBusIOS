//
//  CBFindTableViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBFindTableViewController.h"
#import "EKRequest.h"
#import "CBLoginInfo.h"
#import "Message.h"
#import "FindNoticeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FPPopoverController.h"
static NSString * cellidenty = @"listcell";
@interface CBFindTableViewController ()<EKProtocol>

@end

@implementation CBFindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"发现";
    _dataList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView registerClass:[FindNoticeTableViewCell class] forCellReuseIdentifier:cellidenty];
    self.tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    //判断是否登录

    // 右侧按钮
    
  //  UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"dd" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [[CBLoginInfo shareInstance] baseInfoIsExist:^(BOOL isExist) {
        if(isExist)
        {
            NSDictionary * dic = @{@"newid":@"0"};
            [[EKRequest Instance] EKHTTPRequest:getmessage parameters:dic requestMethod:GET forDelegate:self];

        }
    }];
    
}
-(void)itemClick:(id)sender
{
    UIViewController * vc = [[UIViewController alloc]init];
    vc.title = nil;
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:vc];
    popover.border = NO;
    popover.tint = FPPopoverWhiteTint;
    //the popover will be presented from the okButton view
    [popover presentPopoverFromPoint:CGPointMake(self.view.frame.size.width - 20, 20)];
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    if(method == getmessage && code == 1)
    {
        NSArray * arr = response;
        if(![arr isKindOfClass:[NSArray class]])
        {
            return;
        }
        for (int i = 0; i < arr.count; i++) {
            Message *message = [[Message alloc]initWithDic:arr[i]];
            [_dataList insertObject:message atIndex:0];
        }
        [self.tableView reloadData];
    }

}
- (void)refreshAction{
   
    
    // 请求数据

    // 结束刷新
   
    [self.refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenty forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fd_enforceFrameLayout = NO;
    Message *message = [_dataList objectAtIndex:indexPath.row];
//    cell.textLabel.text  =message.body;
    cell.messsage = message;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [_dataList objectAtIndex:indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:cellidenty configuration:^(FindNoticeTableViewCell * cell) {
        cell.fd_enforceFrameLayout = NO;
        cell.messsage = message;
        
    }];
    
    //return 120+20;
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

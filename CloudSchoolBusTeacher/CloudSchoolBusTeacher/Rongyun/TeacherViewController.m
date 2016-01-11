//
//  TeacherViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "TeacherViewController.h"
#import "CBLoginInfo.h"
#import "School.h"
#import "ClassObj.h"
#import "Teacher.h"
#import "Parents.h"
#import "CBTeacherTableViewCell.h"
#import "RCIM.h"
#import "CB.h"
#import "CBChatViewController.h"
#import "RYMessage.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString * cellinentify = @"teachercell";

@interface TeacherViewController ()
{
}

@end

@implementation TeacherViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:@"MESSAGETEACHER" object:nil];
    
    self.navigationItem.title = _viewTitle;
    [self.tableView registerClass:[CBTeacherTableViewCell class] forCellReuseIdentifier:cellinentify];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
//    self.refreshControl.tintColor = [UIColor grayColor];
//    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isIntoChat = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [_contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellinentify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contact = [_contactArray objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id contact = [_contactArray objectAtIndex:indexPath.row];
    NSString *username;
    NSString *userid;

    //家长用户
    if([contact isKindOfClass:[Parents class]])
    {
        Parents *parents = contact;
        parents.noReadCount = 0;
        username = parents.nickname;
        userid = parents.parentid;
    }
    //教师用户
    else
    {
        Teacher *teacher = contact;
        teacher.noReadCount = 0;
        username = teacher.nickname;
        userid = teacher.teacherid;
    }
    
    // 创建单聊视图控制器。
    RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:userid title:username completion:^(){
        // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
    isIntoChat = YES;
    }];

    //更新界面
    [self.tableView reloadData];
    
    // 把单聊视图控制器添加到导航栈。
    chatViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark == Receive Notification
-(void)receiveMessage:(NSNotification *)noti
{
    [self.tableView reloadData];
}

@end

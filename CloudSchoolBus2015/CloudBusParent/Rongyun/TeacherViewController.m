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
#import "CBTeacherTableViewCell.h"
#import "RCIM.h"
#import "CB.h"
#import "CBChatViewController.h"
#import "RYMessage.h"
static NSString * cellinentify = @"teachercell";


#import "UITableView+FDTemplateLayoutCell.h"

@interface TeacherViewController ()

@end

@implementation TeacherViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isIntoChat = NO;
}
-(void)loadTeacherArr
{
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    // 判断当前学生是哪个学校的
    for (int i = 0; i < info.schoolArr.count; i++) {
        School * school = info.schoolArr[i];
        NSArray * classarr = school.classesArr;
        for (int j = 0; j < classarr.count; j++) {
            ClassObj * classobj = classarr[j];
            NSArray * studentidArr = classobj.studentidArr;
            
            for (int z =0; z < studentidArr.count; z++) {
                NSString * studentid = studentidArr[z];
                if([studentid intValue] == [info.currentStudentId intValue])
                {
                    //当前用户
                    NSArray * teacherArr =  classobj.teacherArr;
                    
                    for (int y = 0; y<teacherArr.count; y++) {
                        Teacher * cteacher = teacherArr[y];
                        BOOL found = NO;
                        for (int q = 0; q < _tearcherArr.count; q++) {
                            Teacher * teacher = _tearcherArr[q];
                            if([teacher.teacherid isEqualToString:cteacher.teacherid])
                            {
                                found = YES;
                                break;
                                
                            }
                            else
                            {
                                found = NO;
                            }
                        }
                        
                        if(found == NO)
                        {
                            [_tearcherArr addObject:cteacher];
                        }
                        
                    }
                    
                }
            }
            
            
            
        }
    }
    if(_tearcherArr.count != 0)
    {
        info.teacherVCIsLoading = YES;
    }
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}
-(void)receiveMessage:(NSNotification *)noti
{
    RYMessage * message = noti.object;
    
    for (Teacher * teacher in _tearcherArr) {
        
        if([teacher.teacherid isEqualToString:message.senderid])
        {
            teacher.contentlatest = message.messagecontent;
            teacher.typeLatest = message.messagetype;
            teacher.latestTime = message.sendertime;
            if(isIntoChat == NO)
            {
                 teacher.noReadCount = teacher.noReadCount + 1;
            }
            else
            {
                
            }
        
           
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGETEACHER" object:message];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:@"MESSAGETEACHER" object:nil];
    
    self.navigationItem.title = @"班级教师";
    [self.tableView registerClass:[CBTeacherTableViewCell class] forCellReuseIdentifier:cellinentify];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    _tearcherArr = [[NSMutableArray alloc]init];
    
    
    
    
    [self loadTeacherArr];
    // Do any additional setup after loading the view.
}
- (void)refreshAction{
    
    
    // 请求数据
    
    // 结束刷新
    [self loadTeacherArr];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [_tearcherArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellinentify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  cell.fd_enforceFrameLayout = NO;
    Teacher *teacher = [_tearcherArr objectAtIndex:indexPath.row];

    cell.teacher = teacher;
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Teacher *teacher = [_tearcherArr objectAtIndex:indexPath.row];
//    return [tableView fd_heightForCellWithIdentifier:cellinentify configuration:^(CBTeacherTableViewCell * cell) {
//        cell.teacher = teacher;
//    }];
//    //return 60;
//
//    //return UITableViewAutomaticDimension;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isIntoChat = YES;
    Teacher *teacher = [_tearcherArr objectAtIndex:indexPath.row];
    teacher.noReadCount = 0;
    [self.tableView reloadData];
   // 此处处理连接成功。
        // 创建单聊视图控制器。
        RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:teacher.teacherid title:teacher.name completion:^(){
            // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
        }];
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

@end

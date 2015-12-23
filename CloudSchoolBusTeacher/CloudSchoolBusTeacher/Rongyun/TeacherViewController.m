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
static NSString * cellinentify = @"teachercell";


#import "UITableView+FDTemplateLayoutCell.h"

@interface TeacherViewController ()
{
    NSMutableArray *contactArray;
    NSString *classid;
}

@end

@implementation TeacherViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    contactArray = [[NSMutableArray alloc]init];
    
    [self loadContactsArray];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isIntoChat = NO;
}

-(void)loadContactsArray
{
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    
    NSString *role;
    if(_classInfo)
    {
        role = [_classInfo objectForKey:@"role"];
        classid = [_classInfo objectForKey:@"classid"];
    }
    
    //家长联系人
    if([role isEqualToString:@"parents"])
    {
        for(Parents *parents in info.parentsArr)
        {
            //找出该家长的孩子（孩子们）
            for(NSString *studentid in parents.studentids)
            {
                //找出孩子所在班级
                NSArray *classArr = [info findClassWithStudentid:studentid];
                for(ClassObj *classinfo in classArr)
                {
                    if([classinfo.classid isEqualToString:classid])
                    {
                        //添加这个家长到联系人列表
                        [contactArray addObject:parents];
                    }
                }
            }
        }
    }
    //教师联系人
    else
    {
        for(Teacher *teacher in info.teacherArr)
        {
            for(NSDictionary *classInfoTeacherDict in teacher.classes)
            {
                NSString *classIdTeacher = [classInfoTeacherDict objectForKey:@"classid"];
                if([classIdTeacher isEqualToString:classid])
                {
                    //添加这个教师到联系人列表
                    [contactArray addObject:teacher];
                }
            }
        }
    }

#if 0
    // 判断当前学生是哪个学校的
    for (int i = 0; i < info.schoolArr.count; i++) {
        School * school = info.schoolArr[i];
        NSArray * classarr = school.classArr;
        for (int j = 0; j < classarr.count; j++) {
            ClassObj * classobj = classarr[j];
            NSArray * studentidArr = classobj.studentidArr;
            
            for (int z =0; z < studentidArr.count; z++) {
                NSString * studentid = studentidArr[z];
                if([studentid intValue] == [info.currentClassId intValue])
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
#endif

    if(contactArray.count != 0)
    {
        info.teacherVCIsLoading = YES;
    }
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}
-(void)receiveMessage:(NSNotification *)noti
{
    RYMessage * message = noti.object;
    
    for (Teacher * teacher in contactArray) {
        
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

- (void)refreshAction{
    
    
    // 请求数据
    
    // 结束刷新
    [self loadContactsArray];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [contactArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellinentify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  cell.fd_enforceFrameLayout = NO;
    if([[_classInfo objectForKey:@"role"] isEqualToString:@"parents"])
    {
        Parents *parents = [contactArray objectAtIndex:indexPath.row];
        cell.classid = classid;
        cell.contact = parents;
    }
    else
    {
        Teacher *teacher = [contactArray objectAtIndex:indexPath.row];
        cell.classid = classid;
        cell.contact = teacher;
    }
    
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
    id contact = [contactArray objectAtIndex:indexPath.row];
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

@end

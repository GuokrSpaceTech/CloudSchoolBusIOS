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

static NSString * cellinentify = @"teachercell";


#import "UITableView+FDTemplateLayoutCell.h"

@interface TeacherViewController ()

@end

@implementation TeacherViewController
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
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"班级教师";
    [self.tableView registerClass:[CBTeacherTableViewCell class] forCellReuseIdentifier:cellinentify];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    _tearcherArr = [[NSMutableArray alloc]init];
    [self loadTeacherArr];
    // Do any additional setup after loading the view.
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
//    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] placeholderImage:nil];
//    cell.nameLabel.text = teacher.name;
//    cell.classNameLabel.text = teacher.className;
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

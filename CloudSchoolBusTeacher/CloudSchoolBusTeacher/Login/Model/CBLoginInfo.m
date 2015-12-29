//
//  CBLoginInfo.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBLoginInfo.h"
#import "School.h"
#import "Student.h"
#import "RCIM.h"
#import "CBDateBase.h"
#import "ClassObj.h"
#import "Parents.h"
#import "ContactGroup.h"

@implementation CBLoginInfo
static CBLoginInfo * logininfo = nil;
+ (CBLoginInfo*)shareInstance
{
    if(logininfo == nil)
    {
        logininfo = [[self alloc]init];
    }
    return logininfo;
}
-(void)getSid:(NSDictionary *)parm
{
    [[EKRequest Instance] EKHTTPRequest:login parameters:parm requestMethod:POST forDelegate:self];
}
-(void)getBaseInfo:(sessionNotOver)block
{
    //Try to load form DB first
    [[CBDateBase sharedDatabase] selectFormTableBaseinfo:block];
    
//    [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:self];
}

-(BOOL)parseBaseInfo:(NSDictionary *)baseinfo
{
    NSDictionary * schoolDictionary = baseinfo[@"schools"];
    [schoolDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        School * school = [[School alloc]initWithSchoolDic:obj];
        [self.schoolArr addObject:school];
    }];
    
    NSArray *classArr = baseinfo[@"classes"];
    for(int i=0; i<classArr.count; i++)
    {
        ClassObj *classObj = [[ClassObj alloc] initWithClassDic:classArr[i]];
        [self.classArr addObject:classObj];
    }
    
    NSArray *teacherArr = baseinfo[@"teachers"];
    for(int i=0; i<teacherArr.count; i++)
    {
        Teacher *teacher = [[Teacher alloc] initWithDic:teacherArr[i]];
        [self.teacherArr addObject:teacher];
    }
    
    NSArray *parentsArr = baseinfo[@"parents"];
    for(int i=0; i<parentsArr.count; i++)
    {
        Parents *parents = [[Parents alloc] initWithParentsDict:parentsArr[i]];
        [self.parentsArr addObject:parents];
    }
    
    NSArray * stuArr = baseinfo[@"students"];
    for (int i=0; i<stuArr.count; i++) {
        Student * st = [[Student alloc]initWithDic:stuArr[i]];
        
        //当前班级默认为第一个学生的班级
        if(i == 0)
        {
            self.currentClassId = st.classid;
        }
        
        [self.studentArr addObject:st];
    }
    
    [self buildUpContactGroups];
    
    return true;
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    if(method == login)
    {
        if(self.successBlock)
        {
            self.successBlock(NO);
        }
    }
    else if (method == baseinfo)
    {
        if(self.baseInfoBlock)
        {
            self.baseInfoBlock(NO);
        }
    }
}
//-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
//{
//    if(method == login && [[param allKeys] containsObject:@"token"])
//    {
//        if(code == 1)
//        {
//            
//            NSDictionary * dic = response;
//            NSString * sid = dic[@"sid"];
//           
//            NSString * rogngyuntoken =dic[@"rongtoken"];
//            self.rongToken = rogngyuntoken;
//        
//            _sid = sid;
//            _state = LoginOn;
//            [[CBDateBase sharedDatabase] insertDataToLoginInfoTable:@([self.userid intValue]) token:self.token phone:self.phone sid:self.sid rong:self.rongToken];
//            
//            [self connectRongYun];
//            self.successBlock(YES);
//        }
//        else
//        {
//            self.successBlock(NO);
//        }
//    }
//    else if(method == baseinfo)
//    {
//        if(code == 1)
//        {
//            NSDictionary * baseinfo = response;
//            
//            //Save baseinfo to DB
//            NSError *error;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response
//                                options:(NSJSONWritingOptions) 0
//                                error:&error];
//
//            if (!jsonData) {
//                NSLog(@"Json Serilisation: error: %@", error.localizedDescription);
//                self.baseInfoBlock(NO);
//            } else {
//                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                [[CBDateBase sharedDatabase] insertDataToBaseInfoTableWithBaseinfo:jsonString];
//            }
//            
//            NSArray * schoolarr = baseinfo[@"schools"];
//            [_schoolArr removeAllObjects];
//            for (int i = 0; i < schoolarr.count; i++) {
//                NSDictionary * schooldic = schoolarr[i];
//                School * school = [[School alloc]initWithSchoolDic:schooldic];
//                [_schoolArr addObject:school];
//            }
//            
//            NSArray * stuArr = baseinfo[@"students"];
//            [_studentArr removeAllObjects];
//            for (int i=0; i<stuArr.count; i++) {
//                Student * st = [[Student alloc]initWithDic:stuArr[i]];
//               
//                //默认班级为第一个学生的班级
//                if(i == 0)
//                {
//                    self.currentClassId = st.classid;
//                }
//                [_studentArr addObject:st];
//            }
//            
//            _hasValidBaseInfo = YES;
//            
//            [self buildUpContactGroups];
//            self.baseInfoBlock(YES);
//        }
//        else
//        {
//            self.baseInfoBlock(NO);
//        }
//    }
//
//
//}
-(void)destory
{
    logininfo = nil;
}
-(instancetype)init
{
    if(self = [super init])
    {
        _schoolArr = [[NSMutableArray alloc] init];
        _studentArr = [[NSMutableArray alloc] init];
        _classArr = [[NSMutableArray alloc] init];
        _teacherArr = [[NSMutableArray alloc] init];
        _parentsArr = [[NSMutableArray alloc] init];
        _contactGroupArr = [[NSMutableArray alloc]init];
        _state = LoginOff;
        _hasValidBaseInfo = NO;
        _teacherVCIsLoading = NO;
    }
    return self;
}
-(void)baseInfoIsExist:(sessionNotOver)block
{
    self.baseInfoBlock = block;
    
    [self loginSid:^(BOOL isLogin) {
        if(isLogin)
        {
            [self getBaseInfo:block];
//            if(_hasValidBaseInfo)
//            {
//                self.baseInfoBlock(YES);
//            }
//            else
//            {
//                [self getBaseInfo];
//            }
        }
    }];
    

    
}
-(void)loginSid:(loginSuccess)block
{
    self.successBlock = block;
    
    if(self.state == LoginOn)
    {
        block(YES);
    }
    else
    {
        NSDictionary * dic = @{@"mobile":self.phone,@"token":self.token};
        [self getSid:dic];
    }
}
-(void)getSid
{
}
-(void)connectRongYun
{
    [[RCIM sharedRCIM] disconnect];
    [RCIM connectWithToken:self.rongToken completion:^(NSString *userId) {
        NSLog(@"--------  %@ ------",userId);
    } error:^(RCConnectErrorCode status) {
        
    }];
}

#pragma mark
#pragma mark == 数据查询工具方法
-(NSArray *)findClassWithStudentid:(NSString *)studentid
{
    NSMutableArray *classArr = [[NSMutableArray alloc]init];
    NSArray *classids;
    
    //找到当前学生的班级（或多个班级
    for(Student *student in _studentArr)
    {
        if([student.studentid isEqualToString:studentid])
        {
            classids = student.classids;
            break;
        }
    }

    //根据班级id找到班级的对象
    for(ClassObj *classinfo in _classArr)
    {
        for(NSString *classid in classids)
        {
            if([classid isEqualToString:classinfo.classid])
            {
                //找到班级
                [classArr addObject:classinfo];
            }
        }
    }
    
    return classArr;
}

-(Teacher *)findMe
{
    for(Teacher *teacher in _teacherArr)
    {
        if([teacher.mobile isEqualToString:_phone])
        {
            return teacher;
        }
    }
    
    return nil;
}

-(NSString *)findRoleBasedOnId:(NSString *)userid
{
    NSString *role=@"";
    
    for(Teacher *teacher in _teacherArr)
    {
        if([teacher.teacherid isEqualToString:userid])
        {
            return @"teacher";
        }
    }
    
    for(Parents *parents in _parentsArr)
    {
        if([parents.parentid isEqualToString:userid])
        {
            return @"parents";
        }
    }
    
    return role;
}

-(void)buildUpContactGroups
{
    for(ClassObj *classinfo in _classArr)
    {
        NSString *className = classinfo.className;
        NSString *classId   = classinfo.classid;
        
        //家长联系人
        ContactGroup *contactGroupParents = [[ContactGroup alloc]init];
        contactGroupParents.classid = classId;
        contactGroupParents.classname = className;
        contactGroupParents.role = @"parents";
        contactGroupParents.messagecnt = 0;
        contactGroupParents.contactList = [[NSMutableArray alloc]init];
        for(Parents *parents in _parentsArr)
        {
            //找出该家长的孩子（孩子们）
            for(NSString *studentid in parents.studentids)
            {
                //找出孩子所在班级
                NSArray *classArr = [self findClassWithStudentid:studentid];
                for(ClassObj *classinfo in classArr)
                {
                    if([classinfo.classid isEqualToString:classId])
                    {
                        //添加这个家长到联系人列表
                        [contactGroupParents.contactList addObject:parents];
                    }
                }
            }
        }
        [_contactGroupArr addObject:contactGroupParents];
    
        //教师联系人
        ContactGroup *contactGroupTeacher = [[ContactGroup alloc]init];
        contactGroupTeacher.classid = classId;
        contactGroupTeacher.classname = className;
        contactGroupTeacher.role = @"teacher";
        contactGroupTeacher.messagecnt = 0;
        contactGroupTeacher.contactList = [[NSMutableArray alloc]init];
        for(Teacher *teacher in _teacherArr)
        {
            for(NSDictionary *classInfoTeacherDict in teacher.classes)
            {
                NSString *classIdTeacher = [classInfoTeacherDict objectForKey:@"classid"];
                if([classIdTeacher isEqualToString:classId])
                {
                    //添加这个教师到联系人列表
                    [contactGroupTeacher.contactList addObject:teacher];
                }
            }
        }
        [_contactGroupArr addObject:contactGroupTeacher];
    }
}

@end

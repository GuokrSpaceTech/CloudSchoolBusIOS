//
//  CBDateBase.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBDateBase.h"
#import "CBLoginInfo.h"
#import "School.h"
#import "Student.h"
@implementation CBDateBase

-(NSString *)datebasePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CloudBusParent.sqlite"];
}
-(id) init
{
    self = [super init];
    if(self){
        NSString *dbFilePath = [self datebasePath];
        NSLog(@"db_ _ _ _ _%@",dbFilePath);
        queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
        
        [self createTable];
    }
    return self;
    
}
-(void)createTable
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS loginInfo('c_id' int,'token' text,'phone' text,'sid' text,'rongtoken' text);";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"CREATE TABLE IF NOT EXISTS baseInfo('c_id' int, 'baseinfoJsonStr' text);";
        [db executeUpdate:sqlStr];
    
    }];
}
+(CBDateBase*) sharedDatabase
{
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
    
}
-(void)insertDataToLoginInfoTable:(NSNumber *)cid token:(NSString *)token phone:(NSString *)phone sid:(NSString *)sid rong:(NSString *)rongCloudToken
{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete  from loginInfo"];
        [db executeUpdate:@"insert into loginInfo(c_id,token,phone,sid,rongtoken) values(?,?,?,?,?)",cid,token,phone,sid,rongCloudToken];
    }];
}
-(void)selectFormTableLoginInfo
{
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:@"select * from loginInfo limit 1"];
        while ([set next]) {
            int cid = [set intForColumn:@"c_id"];
            NSString *token = [set stringForColumn:@"token"];
            NSString * phone = [set stringForColumn:@"phone"];
            NSString * sid = [set stringForColumn:@"sid"];
            NSString * rongtoken = [set stringForColumn:@"rongtoken"];
            
            CBLoginInfo * info = [CBLoginInfo shareInstance];
            info.userid = [NSString stringWithFormat:@"%@",@(cid)];
            info.token = token;
            info.phone = phone;
            info.sid = sid;
            info.rongToken = rongtoken;
        }
    }];
}

-(void)insertDataToBaseInfoTable:(NSNumber *)cid withBaseinfo:(NSString *)baseinfoString
{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from baseInfo"];
        [db executeUpdate:@"insert into baseInfo(c_id, baseinfoJsonStr) values(?,?)",cid,baseinfoString];
    }];
}

-(void)selectFormTableBaseinfo:(sessionNotOver)block
{
    __block NSString *baseinfoStr = nil;
    [queue inDatabase:^(FMDatabase *db) {
        BOOL isBaseInfoValid = false;
        FMResultSet * set = [db executeQuery:@"select * from baseInfo limit 1"];
        while ([set next]) {
            baseinfoStr = [set stringForColumn:@"baseinfoJsonStr"];
            
            //De-serialisation
            if(baseinfoStr)
            {
                NSError *jsonError;
                NSData *objectData = [baseinfoStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *baseinfoDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                              error:&jsonError];
                if(!baseinfoDict)
                {
                    NSLog(@"Json Deserialisation error %@", jsonError.localizedDescription);
                } else {
                    NSArray * schoolarr = baseinfoDict[@"schools"];
                    for (int i = 0; i < schoolarr.count; i++) {
                        NSDictionary * schooldic = schoolarr[i];
                        School *school = [[School alloc]initWithSchoolDic:schooldic];
                        [[[CBLoginInfo shareInstance] schoolArr] addObject:school];
                    }
                    
                    NSArray * stuArr = baseinfoDict[@"students"];
                    for (int i=0; i<stuArr.count; i++) {
                        Student * st = [[Student alloc]initWithDic:stuArr[i]];
                        if(i == 0)
                        {
                           [[CBLoginInfo shareInstance] setCurrentStudentId:st.studentid];
                        }
                        [[[CBLoginInfo shareInstance] studentArr] addObject:st];
                    
                        isBaseInfoValid = true;
                    }
                    
                    [[CBLoginInfo shareInstance] setHasValidBaseInfo:YES];
                    
                    block(YES);
                    
//                    self.baseInfoBlock(YES); //TBCorrected, check session expiration when server returns error
                }
            }
        } //End of while
        if([[CBLoginInfo shareInstance] hasValidBaseInfo] == NO)
        {
            [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:[CBLoginInfo shareInstance]];
        }
        
    }];
}
@end

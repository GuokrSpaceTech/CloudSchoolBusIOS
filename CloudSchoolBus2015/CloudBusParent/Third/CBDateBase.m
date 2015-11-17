//
//  CBDateBase.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBDateBase.h"
#import "CBLoginInfo.h"
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
        NSString * logininfosql = @"CREATE TABLE IF NOT EXISTS loginInfo('c_id' int,'token' text,'phone' text,'sid' text,'rongtoken' text)";
        [db executeUpdate:logininfosql];
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
        //[db executeUpdate:@"insert"]
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
@end

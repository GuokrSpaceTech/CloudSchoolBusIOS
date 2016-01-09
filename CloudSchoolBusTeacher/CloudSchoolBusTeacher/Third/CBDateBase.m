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
#import "Message.h"
@implementation CBDateBase

-(NSString *)datebasePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CloudSchoolBusTeacher.sqlite"];
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
        
        sqlStr = @"CREATE TABLE IF NOT EXISTS baseInfo('baseinfoJsonStr' text);";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"CREATE TABLE IF NOT EXISTS messagesTbl('messageid' int,'desc' text,'apptype' text,'ismass' text,'body' text, 'sendtime' text, 'title' text, 'tag' text, 'isconfirm' text, 'isreaded' text, 'senderid' int, 'studentid' text);";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"CREATE TABLE IF NOT EXISTS senderTbl('senderid' INT NOT NULL PRIMARY KEY, 'classname' text, 'name' text, 'role' text, 'avatar' text);";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"CREATE TABLE IF NOT EXISTS uploadRecordTbl('pickey' text NOT NULL, 'pictype' text, 'classid' text, 'fbody' text, 'teacherid' text, 'fname' text, 'ftime' text, 'status' text, 'content' text, 'studentids' text, 'tagids' text);";
        [db executeUpdate:sqlStr];
    }];
}

-(void)clearTable
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = @"delete from loginInfo;";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"delete from baseInfo;";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"delete from messagesTbl;";
        [db executeUpdate:sqlStr];
        
        sqlStr = @"delete from senderTbl;";
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

-(void)updateLoginInfoSid:(NSString *)sid rong:(NSString *)rongCloudToken
{
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE loginInfo SET sid=? AND rongtoken=?",sid,rongCloudToken];
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

-(void)insertDataToBaseInfoTableWithBaseinfo:(NSString *)baseinfoString
{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from baseInfo"];
        [db executeUpdate:@"insert into baseInfo(baseinfoJsonStr) values(?)",baseinfoString];
    }];
}

-(void)selectFormTableBaseinfo:(void (^)(BOOL isBaseInfoExist))completionHandle
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
                    
                    isBaseInfoValid = [[CBLoginInfo shareInstance] parseBaseInfo:baseinfoDict];
                    
                    [[CBLoginInfo shareInstance] setHasValidBaseInfo:YES];
                    
                    [[CBLoginInfo shareInstance] setBaseInfoJsonString:baseinfoStr];
                    
                    completionHandle(YES);
                }
            }
        } //End of while
        if([[CBLoginInfo shareInstance] hasValidBaseInfo] == NO)
        {
            [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:[CBLoginInfo shareInstance]];
        }
        
    }];
}

-(void)insertRecordToUploadQueue:(UploadRecord *)record
{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into uploadRecordTbl(pickey, pictype, classid, fbody, teacherid, fname, ftime, status, content, studentids, tagids) values(?,?,?,?,?,?,?,?,?,?,?)", record.pickey, record.pictype, record.classid, record.fbody,record.teacherid, record.fname,record.ftime, record.status,record.content, record.studentids,record.tagids];
    }];
}
-(void)fetchUploadRecord:(void (^)(UploadRecord *))postQueryHandle
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM uploadRecordTbl WHERE status = '%@' OR status = '%@' LIMIT 1", @"0", @"2" ];
        __block UploadRecord *record = [[UploadRecord alloc]init];
        FMResultSet *result = [db executeQuery:query];
        while([result next])
        {
            record.pickey = [result stringForColumn:@"pickey"];
            record.pictype = [result stringForColumn:@"pictype"];
            record.classid = [result stringForColumn:@"classid"];
            record.fbody = [result stringForColumn:@"fbody"];
            record.teacherid = [result stringForColumn:@"teacherid"];
            record.fname = [result stringForColumn:@"fname"];
            record.ftime = [result stringForColumn:@"ftime"];
            record.status = [result stringForColumn:@"status"];
            record.content = [result stringForColumn:@"content"];
            record.studentids = [result stringForColumn:@"studentids"];
            record.tagids = [result stringForColumn:@"tagids"];
            
            postQueryHandle(record);
        }
    }];
}

-(void)readUploadQueue:(void (^)(NSMutableArray *records))postQueryHandle
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM uploadRecordTbl ORDER BY pickey"];
        __block NSMutableArray *recordList = [[NSMutableArray alloc]init];
        FMResultSet *result = [db executeQuery:query];
        while([result next])
        {
            UploadRecord *record = [[UploadRecord alloc]init];
            record.pickey = [result stringForColumn:@"pickey"];
            record.pictype = [result stringForColumn:@"pictype"];
            record.classid = [result stringForColumn:@"classid"];
            record.fbody = [result stringForColumn:@"fbody"];
            record.teacherid = [result stringForColumn:@"teacherid"];
            record.fname = [result stringForColumn:@"fname"];
            record.ftime = [result stringForColumn:@"ftime"];
            record.status = [result stringForColumn:@"status"];
            record.content = [result stringForColumn:@"content"];
            record.studentids = [result stringForColumn:@"studentids"];
            record.tagids = [result stringForColumn:@"tagids"];
            
            [recordList addObject:record];
        }
        
        postQueryHandle(recordList);
    }];
}

-(void)countUnsentRecordsWithPickkey:(NSString *)pickey completion:(void (^)(int))handles
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM uploadRecordTbl WHERE status <> '%@' AND pickey = '%@'", @"1", pickey];
        int result = [db intForQuery:query];
        handles(result);
    }];
}

-(void)selectUploadRecordsWithKey:(NSString *)pickey completion:(void (^)(NSMutableArray *records))handles
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM uploadRecordTbl WHERE pickey = '%@'",pickey];
        __block UploadRecord *record = [[UploadRecord alloc]init];
        __block NSMutableArray *recordList = [[NSMutableArray alloc]init];
        FMResultSet *result = [db executeQuery:query];
        while([result next])
        {
            record.pickey = [result stringForColumn:@"pickey"];
            record.pictype = [result stringForColumn:@"pictype"];
            record.classid = [result stringForColumn:@"classid"];
            record.fbody = [result stringForColumn:@"fbody"];
            record.teacherid = [result stringForColumn:@"teacherid"];
            record.fname = [result stringForColumn:@"fname"];
            record.ftime = [result stringForColumn:@"ftime"];
            record.status = [result stringForColumn:@"status"];
            record.content = [result stringForColumn:@"content"];
            record.studentids = [result stringForColumn:@"studentids"];
            record.tagids = [result stringForColumn:@"tagids"];
            
            [recordList addObject:record];
        }
        
        handles(recordList);
    }];
}

-(void)updateUploadRecordPickey:(NSString *)pickey fileName:(NSString *)fname status:(NSString *)status
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr = [[NSString alloc] initWithFormat:@"UPDATE uploadRecordTbl SET status='%@' WHERE pickey='%@' AND fname='%@'",status,pickey,fname];
        [db executeUpdate:queryStr];
    }];
}

-(void)removeUploadRecordWithPickey:(NSString *)pickey
{
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM uploadRecordTbl WHERE pickey = ?", pickey];
    }];
}

-(void)insertMessagesData:(NSMutableArray *)messageArray
{
    for( Message *message in messageArray )
    {
        [queue inDatabase:^(FMDatabase *db) {
            NSNumber *messageid = [[NSNumber alloc] initWithInt:[message.messageid intValue]];
            NSNumber *senderid  = [[NSNumber alloc] initWithInt:[message.sender.senderid intValue]];

            [db executeUpdate:@"INSERT INTO messagesTbl(messageid, desc, apptype, ismass, body, sendtime, title, tag, isconfirm, isreaded, senderid, studentid) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", messageid, message.desc, message.apptype, message.ismass, message.body, message.sendtime, message.title, message.tag,message.isconfirm, message.isreaded, senderid, message.studentid];
            
            Sender *sender = message.sender;
            
            [db executeUpdate:@"INSERT OR REPLACE INTO senderTbl(senderid, classname, name, role, avatar) VALUES(?,?,?,?,?)", senderid, sender.classname, sender.name,sender.role, sender.avatar];
        }];
    }
}

-(void)updateMessageConfirmStatus:(NSString *)status withMessageId:(int)messageid
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr = [[NSString alloc] initWithFormat:@"UPDATE messagesTbl SET isconfirm=%@ WHERE messageid=%d",status,messageid];
        [db executeUpdate:queryStr];
    }];
}

-(void)selectLastestMessageId:(void (^)(int lastestMessageId))postQueryHandles
{
    [queue inDatabase:^(FMDatabase *db) {
        int messageid = 0;
        NSString *queryStr = @"SELECT MAX(messageid) AS messageid FROM messagesTbl";
        
        FMResultSet *resultSet = [db executeQuery:queryStr];
        while ([resultSet next]) {
            messageid = [resultSet intForColumn:@"messageid"];
        }
        
        postQueryHandles(messageid);
    }];
}

-(void)fetchMessagesFromDBfromMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr = [[NSString alloc] initWithFormat:@"SELECT * from (SELECT * FROM messagesTbl where messageid>%d ORDER BY messageid ASC LIMIT 100)"
                                                            "sub ORDER BY messageid DESC", messageid];
        FMResultSet * messageSet = [db executeQuery:queryStr];
        while ([messageSet next]) {
            int senderid = [[messageSet stringForColumn:@"senderid"] intValue];
            
            queryStr = [[NSString alloc] initWithFormat: @"SELECT * FROM senderTbl WHERE senderid = %d LIMIT 1", senderid];
            FMResultSet * senderSet = [db executeQuery:queryStr];
            
            Sender *sender = [[Sender alloc] init];
            while([senderSet next]){
                sender.senderid = [[NSString alloc] initWithFormat:@"%d",senderid];
                sender.classname = [senderSet stringForColumn:@"classname"];
                sender.name = [senderSet stringForColumn:@"name"];
                sender.role = [senderSet stringForColumn:@"role"];
                sender.avatar = [senderSet stringForColumn:@"avatar"];
            }
            
            Message *message = [[Message alloc] init];
            message.sender = sender;
            int messageid = [messageSet intForColumn:@"messageid"];
            message.messageid = [[NSString alloc] initWithFormat:@"%d",messageid];
            message.desc = [messageSet stringForColumn:@"desc"];
            message.apptype = [messageSet stringForColumn:@"apptype"];
            message.ismass = [messageSet stringForColumn:@"ismass"];
            message.body = [messageSet stringForColumn:@"body"];
            message.sendtime = [messageSet stringForColumn:@"sendtime"];
            message.title = [messageSet stringForColumn:@"title"];
            message.tag = [messageSet stringForColumn:@"tag"];
            message.isconfirm = [messageSet stringForColumn:@"isconfirm"];
            message.isreaded = [messageSet stringForColumn:@"isreaded"];
            message.studentid = [messageSet stringForColumn:@"studentid"];
            
            [messageArray addObject:message];
        }
        postMessageFetchHandles(messageArray);
    }];
}

-(void)fetchMessagesFromDBBeforeMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr = [[NSString alloc] initWithFormat:@"SELECT * FROM messagesTbl where messageid<%d ORDER BY messageid DESC LIMIT 100", messageid];
        FMResultSet * messageSet = [db executeQuery:queryStr];
        while ([messageSet next]) {
            int senderid = [[messageSet stringForColumn:@"senderid"] intValue];
            
            queryStr = [[NSString alloc] initWithFormat: @"SELECT * FROM senderTbl WHERE senderid=%d LIMIT 1", senderid];
            FMResultSet * senderSet = [db executeQuery:queryStr];
            
            Sender *sender = [[Sender alloc] init];
            while([senderSet next]){
                sender.senderid = [[NSString alloc] initWithFormat:@"%d",senderid];
                sender.classname = [senderSet stringForColumn:@"classname"];
                sender.name = [senderSet stringForColumn:@"name"];
                sender.role = [senderSet stringForColumn:@"role"];
                sender.avatar = [senderSet stringForColumn:@"avatar"];
            }
            
            Message *message = [[Message alloc] init];
            message.sender = sender;
            int messageid = [messageSet intForColumn:@"messageid"];
            message.messageid = [[NSString alloc] initWithFormat:@"%d",messageid];
            message.desc = [messageSet stringForColumn:@"desc"];
            message.apptype = [messageSet stringForColumn:@"apptype"];
            message.ismass = [messageSet stringForColumn:@"ismass"];
            message.body = [messageSet stringForColumn:@"body"];
            message.sendtime = [messageSet stringForColumn:@"sendtime"];
            message.title = [messageSet stringForColumn:@"title"];
            message.tag = [messageSet stringForColumn:@"tag"];
            message.isconfirm = [messageSet stringForColumn:@"isconfirm"];
            message.isreaded = [messageSet stringForColumn:@"isreaded"];
            message.studentid = [messageSet stringForColumn:@"studentid"];
            
            [messageArray addObject:message];
        }
        postMessageFetchHandles(messageArray);
    }];
}

-(void)fetchMessagesFromDBwithType:(NSString *)apptype fromMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr;
        
        if([apptype isEqualToString:@"All"]) {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * from (SELECT * FROM messagesTbl where messageid>%d ORDER BY messageid ASC LIMIT 100)"
                "sub ORDER BY messageid DESC", messageid];
        } else {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * from (SELECT * FROM messagesTbl where messageid>%d AND apptype='%@' ORDER BY messageid ASC LIMIT 100)"
                "sub ORDER BY messageid DESC", messageid, apptype];
        }
        
        FMResultSet * messageSet = [db executeQuery:queryStr];
        while ([messageSet next]) {
            int senderid = [[messageSet stringForColumn:@"senderid"] intValue];
            
            NSString *queryStr = [[NSString alloc] initWithFormat: @"SELECT * FROM senderTbl WHERE senderid = %d LIMIT 1 ", senderid];
            FMResultSet * senderSet = [db executeQuery:queryStr];
            
            Sender *sender = [[Sender alloc] init];
            while([senderSet next]){
                sender.senderid = [[NSString alloc] initWithFormat:@"%d",senderid];
                sender.classname = [senderSet stringForColumn:@"classname"];
                sender.name = [senderSet stringForColumn:@"name"];
                sender.role = [senderSet stringForColumn:@"role"];
                sender.avatar = [senderSet stringForColumn:@"avatar"];
            }
            
            Message *message = [[Message alloc] init];
            message.sender = sender;
            int messageid = [messageSet intForColumn:@"messageid"];
            message.messageid = [[NSString alloc] initWithFormat:@"%d",messageid];
            message.desc = [messageSet stringForColumn:@"desc"];
            message.apptype = [messageSet stringForColumn:@"apptype"];
            message.ismass = [messageSet stringForColumn:@"ismass"];
            message.body = [messageSet stringForColumn:@"body"];
            message.sendtime = [messageSet stringForColumn:@"sendtime"];
            message.title = [messageSet stringForColumn:@"title"];
            message.tag = [messageSet stringForColumn:@"tag"];
            message.isconfirm = [messageSet stringForColumn:@"isconfirm"];
            message.isreaded = [messageSet stringForColumn:@"isreaded"];
            message.studentid = [messageSet stringForColumn:@"studentid"];
            
            [messageArray addObject:message];
        }
        postMessageFetchHandles(messageArray);
    }];
}

-(void)fetchMessagesFromDBwithType:(NSString *)apptype belowMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr;
        
        if([apptype isEqualToString:@"All"]) {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * FROM messagesTbl WHERE messageid<%d ORDER BY messageid DESC LIMIT 100", messageid];
        } else {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * FROM messagesTbl WHERE messageid<%d AND apptype='%@' ORDER BY messageid DESC LIMIT 100", messageid, apptype];
        }
        
        FMResultSet * messageSet = [db executeQuery:queryStr];
        while ([messageSet next]) {
            int senderid = [[messageSet stringForColumn:@"senderid"] intValue];
            
            NSString *queryStr = [[NSString alloc] initWithFormat: @"SELECT * FROM senderTbl WHERE senderid = %d LIMIT 1 ", senderid];
            FMResultSet * senderSet = [db executeQuery:queryStr];
            
            Sender *sender = [[Sender alloc] init];
            while([senderSet next]){
                sender.senderid = [[NSString alloc] initWithFormat:@"%d",senderid];
                sender.classname = [senderSet stringForColumn:@"classname"];
                sender.name = [senderSet stringForColumn:@"name"];
                sender.role = [senderSet stringForColumn:@"role"];
                sender.avatar = [senderSet stringForColumn:@"avatar"];
            }
            
            Message *message = [[Message alloc] init];
            message.sender = sender;
            int messageid = [messageSet intForColumn:@"messageid"];
            message.messageid = [[NSString alloc] initWithFormat:@"%d",messageid];
            message.desc = [messageSet stringForColumn:@"desc"];
            message.apptype = [messageSet stringForColumn:@"apptype"];
            message.ismass = [messageSet stringForColumn:@"ismass"];
            message.body = [messageSet stringForColumn:@"body"];
            message.sendtime = [messageSet stringForColumn:@"sendtime"];
            message.title = [messageSet stringForColumn:@"title"];
            message.tag = [messageSet stringForColumn:@"tag"];
            message.isconfirm = [messageSet stringForColumn:@"isconfirm"];
            message.isreaded = [messageSet stringForColumn:@"isreaded"];
            message.studentid = [messageSet stringForColumn:@"studentid"];
            
            [messageArray addObject:message];
        }
        postMessageFetchHandles(messageArray);
    }];
}


-(void)initMessageQueueWithType:(NSString *)apptype postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryStr;
        
        //查询总数
        if([apptype isEqualToString:@"All"]) {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT count(messageid) FROM messagesTbl ORDER BY messageid DESC"];
        } else {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT count(messageid) FROM messagesTbl WHERE apptype='%@'ORDER BY messageid DESC", apptype];
        }
        
        int count = [db intForQuery:queryStr];
        
        //计算显示数据门限，本地消息记录在200以内全部显示消息，否则只显示头100条数据
        int rowStart;
        int limitNumber;
        
        if(count == 0) //Nothing
        {
            rowStart=0;
            limitNumber=0;
        }
        else if(count < 200) //All records
        {
            rowStart = 0;
            limitNumber = 200;
        }
        else //Latest 100
        {
            rowStart = 0;
            limitNumber = 100;
        }
        
        //查询出需要在界面显示的熟路
        if([apptype isEqualToString:@"All"]) {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * FROM messagesTbl ORDER BY messageid DESC LIMIT %d, %d",rowStart, limitNumber];
        } else {
            queryStr = [[NSString alloc] initWithFormat:@"SELECT * FROM messagesTbl WHERE apptype='%@' ORDER BY messageid DESC LIMIT %d, %d", apptype, rowStart, limitNumber];
        }
        
        FMResultSet * messageSet = [db executeQuery:queryStr];
        
        while ([messageSet next]) {
            int senderid = [[messageSet stringForColumn:@"senderid"] intValue];
            
            NSString *queryStr = [[NSString alloc] initWithFormat: @"SELECT * FROM senderTbl WHERE senderid = %d LIMIT 1 ", senderid];
            FMResultSet * senderSet = [db executeQuery:queryStr];
            
            Sender *sender = [[Sender alloc] init];
            while([senderSet next]){
                sender.senderid = [[NSString alloc] initWithFormat:@"%d",senderid];
                sender.classname = [senderSet stringForColumn:@"classname"];
                sender.name = [senderSet stringForColumn:@"name"];
                sender.role = [senderSet stringForColumn:@"role"];
                sender.avatar = [senderSet stringForColumn:@"avatar"];
            }
            
            Message *message = [[Message alloc] init];
            message.sender = sender;
            int messageid = [messageSet intForColumn:@"messageid"];
            message.messageid = [[NSString alloc] initWithFormat:@"%d",messageid];
            message.desc = [messageSet stringForColumn:@"desc"];
            message.apptype = [messageSet stringForColumn:@"apptype"];
            message.ismass = [messageSet stringForColumn:@"ismass"];
            message.body = [messageSet stringForColumn:@"body"];
            message.sendtime = [messageSet stringForColumn:@"sendtime"];
            message.title = [messageSet stringForColumn:@"title"];
            message.tag = [messageSet stringForColumn:@"tag"];
            message.isconfirm = [messageSet stringForColumn:@"isconfirm"];
            message.isreaded = [messageSet stringForColumn:@"isreaded"];
            message.studentid = [messageSet stringForColumn:@"studentid"];
            
            [messageArray addObject:message];
        }
        postMessageFetchHandles(messageArray);
    }];
}



@end

//
//  CBDateBase.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CBLoginInfo.h"
#import "UploadRecord.h"
@interface CBDateBase : NSObject
{
    FMDatabaseQueue *queue;
}
+(CBDateBase *)sharedDatabase;

-(void)insertDataToLoginInfoTable:(NSNumber *)cid token:(NSString *)token phone:(NSString *)phone sid:(NSString *)sid rong:(NSString *)rongCloudToken;
-(void)selectFormTableLoginInfo;
-(void)updateLoginInfoSid:(NSString *)sid rong:(NSString *)rongCloudToken;


-(void)insertDataToBaseInfoTableWithBaseinfo:(NSString *)baseinfoString;
-(void)selectFormTableBaseinfo:(sessionNotOver)block;

-(void)insertMessagesData:(NSMutableArray *)messageArray;
-(void)updateMessageConfirmStatus:(NSString *)status withMessageId:(int)messageid;
-(void)selectLastestMessageId:(void (^)(int lastestMessageId))postQueryHandles;

-(void)fetchMessagesFromDBfromMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;
-(void)fetchMessagesFromDBBeforeMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;

-(void)fetchMessagesFromDBwithType:(NSString *)apptype fromMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;
-(void)fetchMessagesFromDBwithType:(NSString *)apptype belowMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;

-(void)initMessageQueueWithType:(NSString *)apptype postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;

-(void)countUnsentRecordsWithPickkey:(NSString *)pickey completion:(void (^)(int))handles;
-(void)fetchUploadRecord:(void (^)(UploadRecord *))postQueryHandle;
-(void)insertRecordToUploadQueue:(UploadRecord *)record;
-(void)updateUploadRecordPickey:(NSString *)pickey fileName:(NSString *)fname status:(NSString *)status;
-(void)removeUploadRecordWithPickey:(NSString *)pickey;
-(void)readUploadQueue:(void (^)(NSMutableArray *recordList))postQueryHandle
;

-(void)clearTable;
@end

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
@interface CBDateBase : NSObject
{
    FMDatabaseQueue *queue;
}
+(CBDateBase *)sharedDatabase;

-(void)insertDataToLoginInfoTable:(NSNumber *)cid token:(NSString *)token phone:(NSString *)phone sid:(NSString *)sid rong:(NSString *)rongCloudToken;
-(void)selectFormTableLoginInfo;

-(void)insertDataToBaseInfoTable:(NSNumber *)cid withBaseinfo:(NSString *)baseinfoString;
-(void)selectFormTableBaseinfo:(sessionNotOver)block;

-(void)insertMessagesData:(NSMutableArray *)messageArray;
-(void)fetchMessagesFromDBfromMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;
-(void)fetchMessagesFromDBwithType:(NSString *)apptype fromMessageId:(NSNumber *)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;
-(void)fetchMessagesFromDBBeforeMessageId:(int)messageid postHandle:(void (^)(NSMutableArray *messageArray))postMessageFetchHandles;
@end

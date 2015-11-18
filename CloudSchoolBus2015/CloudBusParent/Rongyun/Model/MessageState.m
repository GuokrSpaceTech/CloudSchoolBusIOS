//
//  MessageState.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/18.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "MessageState.h"
static NSMutableArray * listArr = nil;
@implementation MessageState
+(void)addObjectToArr:(RYMessage *)message
{
    if(listArr == nil)
    {
        listArr = [[NSMutableArray alloc]init];
    }

    [listArr addObject:message];
}
-(NSMutableArray *)getMessage
{
    return listArr;
}
@end

//
//  GKFindWraper.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKFindWraper.h"
static NSMutableDictionary *dic=nil;
@implementation GKFindWraper
+(void) addUpWrapper:(GKUpWraper *)wraper Key:(NSString *)_key
{
    if(dic==nil)
    {
        dic=[[NSMutableDictionary alloc]init];
    }
    [dic setObject:wraper forKey:_key];

}
+(void)RemoveBookWrapperForKey:(NSString *)_key
{
    [dic removeObjectForKey:_key];

}
+(GKUpWraper *)getBookWrapper:(NSString *)_key
{
    GKUpWraper * Wrapper=[dic objectForKey:_key];
    return Wrapper;
}
@end

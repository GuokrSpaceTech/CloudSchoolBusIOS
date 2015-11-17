//
//  Calculate.h
//  CloudBusParent
//
//  Created by wenpeifang on 15/11/13.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculate : NSObject
+(NSString *)dateFromTimeStamp:(int)timeStamp;
+ (float)checkTmpSize;//计算sdimageView 缓存大小
+ (void)clearTmpPics:(void(^)(void))complect; //清除sdimgeview 缓存
@end

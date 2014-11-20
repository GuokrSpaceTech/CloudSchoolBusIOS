//
//  GKAttentanceObj.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-17.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKAttentanceObj : NSObject

@property (nonatomic,retain) NSString *stuentid;
@property (nonatomic,retain) NSString *cnname;
@property (nonatomic)BOOL isAttence;
@property (nonatomic,retain) NSMutableArray *attendanceArr;
@end

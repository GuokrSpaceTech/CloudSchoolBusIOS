//
//  GKAttentance.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKAttentance : NSObject
{
    
}
@property (nonatomic,retain)NSString *studentId;
@property (nonatomic,retain)NSString *studentName;
@property (nonatomic,retain)NSString *intime;
@property (nonatomic,retain)NSString *outtime;
@property (nonatomic,retain)NSString *inavater;
@property (nonatomic,retain)NSString *outavater;
@property (nonatomic,assign)BOOL isAttence;
@end

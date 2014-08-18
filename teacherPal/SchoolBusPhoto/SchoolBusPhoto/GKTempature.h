//
//  GKTempature.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKTempature : NSObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *studentid;
@property (nonatomic,retain)NSString * tempature;
@property (nonatomic,retain)NSString *state;
@property (nonatomic,retain)NSString *otherstate;

@property (nonatomic,assign)BOOL isTempature;
@end

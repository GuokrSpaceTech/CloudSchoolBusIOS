//
//  GKReport.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKReport : NSObject
@property (nonatomic,retain)NSString *reportid;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSMutableArray *contentArr;
@property (nonatomic,retain)NSString *createtime;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *teachername;
@property (nonatomic,retain)NSString *studentname;
@property (nonatomic,retain)NSString *reporttime;
@property (nonatomic,retain)NSString *reportname;
@end

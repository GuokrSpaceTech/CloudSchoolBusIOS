//
//  GKReportModel.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-30.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKReportModel : NSObject
@property (nonatomic,retain)NSString *reportid;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSMutableArray *questionArr;
@property (nonatomic,retain)NSString *name;
@end

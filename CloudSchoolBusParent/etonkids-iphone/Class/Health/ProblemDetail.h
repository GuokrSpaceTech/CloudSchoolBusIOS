//
//  ProblemDetail.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemDetail : NSObject
@property (nonatomic,retain)NSString *created_time_ms;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *contentid;
@property (nonatomic,retain)NSMutableArray *contentArr;

@end

//
//  CYProblem.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYProblem : NSObject
@property (nonatomic,retain)NSString *status;
//@property (nonatomic,assign)BOOL to_doc;
//@property (nonatomic,assign)int start;
//@property (nonatomic,assign)float price;
@property (nonatomic,retain)NSString *created_time;
@property (nonatomic,retain)NSString *ask;
@property (nonatomic,retain)NSString *problemId;
//@property (nonatomic,assign)BOOL need_assess;
@property (nonatomic,retain)NSString *title;
//@property (nonatomic,assign)BOOL is_viewed;
@property (nonatomic,retain)NSString *created_time_ms;
//@property (nonatomic,retain)NSString *clinic_no;
@property (nonatomic,retain)NSString *clinic_name;
@end

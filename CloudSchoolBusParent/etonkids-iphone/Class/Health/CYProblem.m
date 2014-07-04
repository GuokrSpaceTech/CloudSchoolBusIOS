//
//  CYProblem.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "CYProblem.h"

@implementation CYProblem
-(void)dealloc
{
    
    self.status=nil;
    //@property (nonatomic,assign)BOOL to_doc;
    //@property (nonatomic,assign)int start;
    //@property (nonatomic,assign)float price;
    self.created_time=nil;
    self.ask=nil;
    self.problemId=nil;;
    //@property (nonatomic,assign)BOOL need_assess;
    self.title=nil;
    //@property (nonatomic,assign)BOOL is_viewed;
    self.created_time_ms=nil;
    //@property (nonatomic,retain)NSString *clinic_no;
    self.clinic_name=nil;;
    [super dealloc];
}
@end

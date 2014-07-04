//
//  CYDoctor.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "CYDoctor.h"

@implementation CYDoctor
-(void)dealloc
{
    self.docid=nil;
     self.name=nil;
     self.image=nil;
     self.title=nil;
    self.hospital=nil;
     self.level_title=nil;
     self.clinic=nil;
    [super dealloc];
}
@end

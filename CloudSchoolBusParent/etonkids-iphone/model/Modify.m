//
//  Modify.m
//  etonkids-iphone
//
//  Created by Simon on 13-6-26.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "Modify.h"

@implementation Modify
static  Modify *modifyData = nil;
+(Modify*)getNeskyData;
{
    if (modifyData== nil)
    {
       modifyData=[[Modify alloc]init];
    }
    return modifyData;
}

- (id)init
{
    
    if (self = [super init])
        
        
    {
      
    }
    
    return self;
}
@end

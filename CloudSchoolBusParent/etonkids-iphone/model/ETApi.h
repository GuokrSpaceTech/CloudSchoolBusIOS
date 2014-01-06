//
//  ETApi.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 3/8/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETKids.h"



@interface ETApi : NSObject

+ (NSString*)errStrFromCode:(NSInteger)errCode;

+ (NSString *)askUrl:(NSString *)Name;


+ (id)requestData:(NSString *)urlString
                         httpMethod:(NSString *)method
                httpBody:(id)bodyData;
@end

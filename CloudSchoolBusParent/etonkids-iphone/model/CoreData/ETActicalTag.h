//
//  ETActicalTag.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETClassShare;

@interface ETActicalTag : NSManagedObject

@property (nonatomic, retain) NSString * articleid;
@property (nonatomic, retain) NSString * tagid;
@property (nonatomic, retain) NSString * tagname;
@property (nonatomic, retain) NSString * tagname_en;
@property (nonatomic, retain) NSString * tagnamedesc;
@property (nonatomic, retain) NSString * tagnamedesc_en;
@property (nonatomic, retain) ETClassShare *tags;

@end

//
//  ETSchedule.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETSchedule : NSManagedObject

@property (nonatomic, retain) NSString * course;
@property (nonatomic, retain) NSString * scheduletime;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * snum;

@end

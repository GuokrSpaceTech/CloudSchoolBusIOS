//
//  ETCalendar.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-15.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETCalendar : NSManagedObject

@property (nonatomic, retain) NSString * yearmonth;
@property (nonatomic, retain) NSString * festival;
@property (nonatomic, retain) NSString * date;

@end

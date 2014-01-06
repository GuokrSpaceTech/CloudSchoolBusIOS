//
//  ETAttendance.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-15.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETAttendance : NSManagedObject

@property (nonatomic, retain) NSString * attendanceday;
@property (nonatomic, retain) NSString * attendancetypeid;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * yearmonth;

@end

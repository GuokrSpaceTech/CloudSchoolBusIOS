//
//  ETAttendanceType.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETAttendanceType : NSManagedObject

@property (nonatomic, retain) NSString * typekey;
@property (nonatomic, retain) NSString * typevalue;

@end

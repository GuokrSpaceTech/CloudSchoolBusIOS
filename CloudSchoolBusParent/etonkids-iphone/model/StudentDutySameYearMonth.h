//
//  StudentDutySameYearMonth.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentDutySameYearMonth : NSObject
{
    int  year;
    int  month;
    
    NSMutableArray *dutyList;
    NSMutableArray *monthDay;
    
}
@property(nonatomic,retain)NSMutableArray *dutyList;
@property(nonatomic,retain)NSMutableArray *monthDay;
@property int year;
@property int month;
@end

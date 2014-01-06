//
//  StudentDuty.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentDuty : NSObject
{
    NSString *inTime;
    NSString *outTime;
    NSString *date;
    NSString *result;
    
    
    int year;
    int month;
    int day;
    
}
@property int year;
@property int month;
@property int day;
@property(nonatomic,retain)NSString *inTime;
@property(nonatomic,retain)NSString *outTime;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSString *result;
@end

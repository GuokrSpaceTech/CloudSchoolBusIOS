//
//  Student.h
//  etonkids-iphone
//
//  Created by wpf on 1/29/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property(nonatomic,retain)NSString *studentId;
@property(nonatomic,retain)NSString *studentName;
@property(nonatomic,retain)NSString *studentSex;
@property(nonatomic,retain)NSString *studentClassName;
@property(nonatomic,retain)NSString *SchoolId;
@property(nonatomic,retain)NSString *StudentPaperType;
@property(nonatomic,retain)NSString *StudentPaperNum;
@property(nonatomic,retain)NSString *studentAge;
@property(nonatomic,retain)NSString *StudentClassNum;
@property(nonatomic,retain)NSString * StudentFatherName;
@property(nonatomic,retain)NSString * StudentFatherNum;
@property(nonatomic,retain)NSString * StudentMotherName;
@property(nonatomic,retain)NSString * StudentMotherNum;
@property(nonatomic,retain)NSString * Address;
@property(nonatomic,retain)NSString *InSchoolState;

@property(nonatomic,retain)NSString *photoImage;
@end

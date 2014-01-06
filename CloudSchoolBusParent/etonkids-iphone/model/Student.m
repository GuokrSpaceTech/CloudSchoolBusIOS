//
//  Student.m
//  etonkids-iphone
//
//  Created by wpf on 1/29/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "Student.h"
//@property(nonatomic,retain)NSString *studentId;
//@property(nonatomic,retain)NSString *studentSex;
//@property(nonatomic,retain)NSString *studentClassName;
//@property(nonatomic,retain)NSString *SchoolId;
//@property(nonatomic,retain)NSString *StudentPaperType;
//@property(nonatomic,retain)NSString *StudentPaperNum;
//@property(nonatomic,retain)NSString *studentAge;
//
//@property(nonatomic,retain)NSString * StudentFatherName;
//@property(nonatomic,retain)NSString * StudentFatherNum;
//@property(nonatomic,retain)NSString * StudentMotherName;
//@property(nonatomic,retain)NSString * StudentMotherNum;
//@property(nonatomic,retain)NSString * Address;
//@property(nonatomic,retain)NSString *InSchoolState;
@implementation Student
@synthesize studentAge,studentClassName,studentId,studentSex,StudentFatherName,StudentFatherNum,StudentMotherName,StudentMotherNum,StudentPaperNum,StudentPaperType,SchoolId,Address,studentName,StudentClassNum,photoImage;


-(void)dealloc
{
    
    self.StudentClassNum=nil;
    self.StudentPaperNum=nil;
    self.StudentMotherName=nil;
    self.StudentMotherNum=nil;
    self.studentAge=nil;
    self.studentClassName=nil;
    self.studentId=nil;
    self.studentSex=nil;
    self.StudentFatherName=nil;
    self.StudentFatherNum=nil;
    self.StudentPaperType=nil;
    self.SchoolId=nil;
    self.Address=nil;
    self.studentName=nil;
    self.photoImage=nil;
    [super dealloc];
}
@end

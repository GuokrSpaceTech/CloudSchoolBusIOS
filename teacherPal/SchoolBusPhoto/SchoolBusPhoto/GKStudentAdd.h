//
//  GKStudentAdd.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKStudentAdd : NSObject
@property(nonatomic,retain)NSString *classUID;
@property (nonatomic,retain)NSString *classID;
@property (nonatomic,retain)NSString *studentID;
@property (nonatomic,retain)NSString *studentUID;
@property (nonatomic,retain)NSString *studentName;
@property (nonatomic,retain)NSString *parentTel;
@property (nonatomic,retain)NSString *birthday;
@property (nonatomic,assign)int sex;
@property (nonatomic,assign)int  age;
@property (nonatomic,retain)NSString *className;
@property (nonatomic,assign)BOOL isSelect;
@end

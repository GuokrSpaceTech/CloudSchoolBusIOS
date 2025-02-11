//
//  Parents.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/9/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parents : NSObject
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *parentid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSArray  *studentids;
@property (nonatomic,copy) NSString *relationship;
@property (nonatomic,copy) NSString *pictureid;
@property (nonatomic,copy) NSString *lastestIM;

// 收到融云消息
@property (nonatomic,copy)NSString * contentlatest;
@property (nonatomic,assign) int noReadCount;
@property (nonatomic,copy)NSString * typeLatest;
@property (nonatomic,copy) NSString * latestTime;

-(instancetype)initWithParentsDict:(NSDictionary *)parentsDict;
@end

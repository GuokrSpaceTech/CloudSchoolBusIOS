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

-(instancetype)initWithParentsDict:(NSDictionary *)parentsDict;
@end

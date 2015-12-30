//
//  ContactGroup.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/29/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactGroup : NSObject

@property (strong, nonatomic) NSString * classname;
@property (strong, nonatomic) NSString * classid;
@property (strong, nonatomic) NSString * role;
@property (assign, nonatomic) int messagecnt;
@property (strong, nonatomic) NSMutableArray *contactList;

@end

//
//  Letter.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Letter : NSObject
@property (nonatomic,retain)NSString *letterID;
@property (nonatomic,retain)NSString *letterContent;
@property (nonatomic,retain)NSMutableArray *picArr;
@property (nonatomic,retain)NSString *letterTime;
@property (nonatomic,retain)NSString *letterFromRole;
@property (nonatomic,retain)NSString *letterFromRoleID;

@property (nonatomic,retain)NSString *letterLetterType;

@property (nonatomic,retain)NSString *letterToRole;
@property (nonatomic,retain)NSString *letterToRoleID;
@end

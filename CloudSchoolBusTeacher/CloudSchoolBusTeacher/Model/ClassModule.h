//
//  ClassModule.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/8/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModule : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * url;
-(instancetype)initWithModuleDict:(NSDictionary *)classModule;
@end

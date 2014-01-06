//
//  ETClass.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETClass : NSManagedObject

@property (nonatomic, retain) NSString * classid;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * classname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * schoolname;

@end

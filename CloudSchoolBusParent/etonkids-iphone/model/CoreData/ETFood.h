//
//  ETFood.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-12-2.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETFood : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * typename;

@end

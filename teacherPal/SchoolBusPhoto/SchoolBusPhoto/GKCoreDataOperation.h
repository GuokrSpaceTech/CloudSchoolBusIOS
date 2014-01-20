//
//  GKCoreDataOperation.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-20.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

enum Method{Insert,Delete};

@interface GKCoreDataOperation :NSOperation

@property (nonatomic,assign) enum Method type;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain)NSString *entryStr;


- (id)initWithData:(NSMutableArray *)parseData entry:(NSString *)entry;
@end

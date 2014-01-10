//
//  MovieDraft.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-9.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MovieDraft : NSManagedObject

@property (nonatomic, retain) NSString * createdate;
@property (nonatomic, retain) NSString * moviepath;
@property (nonatomic, retain) NSString * userid;

@end

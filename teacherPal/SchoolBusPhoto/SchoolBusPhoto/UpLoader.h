//
//  UpLoader.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UpLoader : NSManagedObject

@property (nonatomic, retain) NSNumber * classUid;
@property (nonatomic, retain) NSNumber * fsize;
@property (nonatomic, retain) NSNumber * ftime;
@property (nonatomic, retain) NSString * image;// 路径
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSNumber * isUploading;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameID;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) NSString * studentId;
@property (nonatomic, retain) NSString * tag;

@end

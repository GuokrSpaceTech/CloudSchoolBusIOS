//
//  UpLoader.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 15-2-10.
//  Copyright (c) 2015年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UpLoader : NSManagedObject

@property (nonatomic, retain) NSNumber * classUid;
@property (nonatomic, retain) NSNumber * fsize;
@property (nonatomic, retain) NSNumber * ftime;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSNumber * isUploading;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameID;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) NSString * studentId;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * teacherid;
@property (nonatomic, retain) NSNumber * istrain;

@end

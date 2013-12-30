//
//  UpLoader.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-18.
//  Copyright (c) 2013年 mactop. All rights reserved.
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
@property (nonatomic, retain) NSString * studentId;
@property (nonatomic, retain) NSData * smallImage;

@end

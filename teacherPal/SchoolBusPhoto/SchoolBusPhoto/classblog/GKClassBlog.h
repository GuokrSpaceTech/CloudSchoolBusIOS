//
//  GKClassBlog.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-22.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKClassBlog : NSObject
@property(nonatomic,retain)NSString *audio;
@property(nonatomic,retain)NSString *shareId;
@property(nonatomic,retain)NSArray *shareidArr;
@property(nonatomic,retain)NSString *shareTitle;
@property(nonatomic,retain)NSString *shareContent;
@property(nonatomic,retain)NSString *sharePic;
@property(nonatomic,retain)NSArray * sharePicArr;
@property(nonatomic,retain)NSArray * tagArr;
@property (nonatomic, retain)NSString *shareKey;
@property BOOL isMore;
@property (nonatomic)NSInteger isregister;
@property(nonatomic,retain)NSString *shareTime;
@property(nonatomic,retain)NSString *checkuserid;
@property(nonatomic,retain)NSNumber *upnum;
@property(nonatomic,retain)NSNumber *havezan;
@property(nonatomic,retain)NSNumber *commentnum;
@property (nonatomic, retain) NSString *publishtime;
@end

//
//  GKUpWraper.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-21.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myProgressView.h"
//#import "ASIFormDataRequest.h"
@interface GKUpWraper : NSObject
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * isUploading;//区分改对象是否正在下载 标记为10
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameid;
@property (nonatomic, retain) NSString * tid;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * fize;
@property (nonatomic, retain) NSNumber * classid;
@property (nonatomic, retain) NSNumber * teacherid;
@property (nonatomic, retain) NSNumber * isregister;
@property (nonatomic,retain)NSString *intro;
@property (nonatomic,retain)myProgressView *_progressView;
@property (nonatomic,retain)NSData *imageData;
@property (nonatomic, retain) NSString *tag;

//path name  nameId tid time fize classid

//@property(nonatomic,retain)ASIFormDataRequest *request;

//-(void)wraperUploader;
@end

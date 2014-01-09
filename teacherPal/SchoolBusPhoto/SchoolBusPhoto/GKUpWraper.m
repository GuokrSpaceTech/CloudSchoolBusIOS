//
//  GKUpWraper.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-21.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKUpWraper.h"

#import "GKUserLogin.h"
#import "GTMBase64.h"
#import "GKLoaderManager.h"

@implementation GKUpWraper
@synthesize path,isUploading,name;
//@synthesize request;
@synthesize nameid;
@synthesize tid,time,fize,classid;
@synthesize _progressView;
@synthesize intro;
@synthesize imageData,tag;
-(void)dealloc
{
    self.path=nil;
    self.isUploading=nil;
    self.name=nil;
    self.nameid=nil;
  //  self.request=nil;
    self.time=nil;
    self.fize=nil;
    self.classid=nil;
    self.tid=nil;
    [_progressView release];
    self.intro=nil;
    self.imageData=nil;
    self.tag = nil;
    [super dealloc];
}
-(id)init
{
    if(self=[super init])
    {
        _progressView=[[myProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    }
    return self;
}

@end

//
//  GKNotice.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNotice.h"

@implementation GKNotice
@synthesize addtime,adduserid,isconfirm,noticecontent,noticeid,noticetitle,plist,slistname;

-(id)init
{
    if(self=[super init])
    {
        NSMutableArray *tempPlist=[[NSMutableArray alloc]init];
        [self setPlist:tempPlist];
        [tempPlist release];
        
        NSMutableArray *tempSlistName=[[NSMutableArray alloc]init];
        [self setSlistname:tempSlistName];
        [tempSlistName release];
        
        
        
    }
    return self;
}

-(void)dealloc
{
    self.adduserid=nil;
    self.addtime=nil;
    self.isconfirm=nil;
    self.noticetitle=nil;
    self.noticeid=nil;
   
    self.noticecontent=nil;
    self.slistname=nil;

    self.plist=nil;
    [super dealloc];
}
@end

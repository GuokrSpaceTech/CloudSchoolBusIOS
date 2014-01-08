//
//  GKNotice.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKNotice : NSObject
{
    
}

@property (nonatomic,retain)NSString *addtime;
@property (nonatomic,retain)NSString *adduserid;
@property (nonatomic,retain)NSString *isconfirm;
@property (nonatomic,retain)NSString *noticecontent;
@property (nonatomic,retain)NSString *noticeid;
@property (nonatomic,retain)NSString *noticekey;
@property (nonatomic,retain)NSString *noticetitle;
@property (nonatomic,retain)NSMutableArray *plist;
@property (nonatomic,retain)NSMutableArray *sisconfirm;
@property (nonatomic,retain)NSMutableArray *slist;
@property (nonatomic,retain)NSMutableArray *slistname;

@end

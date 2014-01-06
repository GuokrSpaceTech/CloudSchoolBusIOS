//
//  Infomation.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   Infomation
 *  @brief  教育资讯类
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <Foundation/Foundation.h>

@interface Infomation : NSObject
{
    NSString * content;
    NSNumber * infoId;
    NSString *linkage;
    NSString *publishTime;
    NSString *thumbnail;
    NSString *title;
    NSString  *htmlurl;
    
    BOOL isCollect;
    
    BOOL isCollected;
    
}
@property  BOOL isCollect;
@property  BOOL isCollected;
@property(nonatomic,retain)NSString * content;
@property(nonatomic,retain)NSNumber * infoId;
@property(nonatomic,retain)NSString * linkage;
@property(nonatomic,retain)NSString * publishTime;
@property(nonatomic,retain)NSString * thumbnail;
@property(nonatomic,retain)NSString * title;
@property(nonatomic,retain)NSString  *htmlurl;
@end

//
//  NoticeInfo.h
//  etonkids-iphone
//
//  Created by wpf on 1/22/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfo : NSObject
@property(nonatomic,retain)NSString *noticeId;
@property(nonatomic,retain)NSString *noticeTitle;
@property(nonatomic,retain)NSString *noticeContent;
@property(nonatomic,retain)NSString *noticeTime;
@property(nonatomic,retain)NSString *shortContent;
@property(nonatomic,retain)NSString *isconfirm;
@property(nonatomic,retain)NSString *noticekey;
@property(nonatomic,retain)NSString *haveisconfirm;
@property BOOL isMore;
@property (nonatomic, retain) NSArray *pictures;
@property (nonatomic, retain) NSString *addtime;


@end

//
//  ShareContent.h
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareContent : NSObject
{
    NSString *shareId;
    NSString *shareTitle;
    NSString *shareContent;
    NSString *sharePic;
    NSString *shareTime;
    NSArray * sharePicArr;
    NSArray * tagArr;
    
}
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
@property(nonatomic,retain)NSString *shareTime;
@property(nonatomic,retain)NSString *checkuserid;
@property(nonatomic,retain)NSNumber *upnum;
@property(nonatomic,retain)NSNumber *havezan;
@property(nonatomic,retain)NSNumber *commentnum;
@property (nonatomic, retain) NSString *publishtime;


@end

//
//  ETPhoto.h
//  SchoolBusParents
//
//  Created by wen peifang on 13-8-26.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ETPhoto : NSObject
@property BOOL isSelected;
@property (nonatomic,retain)NSString *nameId;
@property (nonatomic,retain)ALAsset *asset;
@property (nonatomic,retain)NSDate *  date;
@end


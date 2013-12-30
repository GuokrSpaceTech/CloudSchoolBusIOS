//
//  GKLetterData.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKLetterData : NSObject
{
    NSString *dateKey;
    NSMutableArray *letterArr;
}

@property (nonatomic,retain)NSString *dateKey;
@property (nonatomic,retain)NSMutableArray *letterArr;
@end

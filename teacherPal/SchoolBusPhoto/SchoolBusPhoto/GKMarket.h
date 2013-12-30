//
//  GKMarket.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKMarket : NSObject
{
    NSString *marketUrl;
    NSString *marketName;
    NSString *marketCredits;
    
   
}

@property (nonatomic,retain)NSString *marketUrl;
@property (nonatomic,retain)NSString *marketName;
@property (nonatomic,retain)NSString *marketCredits;

@property (nonatomic,retain)NSString *marketId;
@property (nonatomic,retain)NSString *marketIntro;

@property (nonatomic,retain)NSString *marketfext;




@property (nonatomic,retain)NSString *addtime;
@property (nonatomic,retain)NSString *status;
@property (nonatomic,retain)NSString *num;
@end

//
//  GKBuyCountView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GKBuyCountView : UIView
{
    UILabel *countLabel;
    
    int count;
    
    
    void (^buyCount)(int);
}

@property (nonatomic,copy) void (^buyCount)(int);
@end

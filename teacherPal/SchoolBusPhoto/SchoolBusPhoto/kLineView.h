//
//  kLineView.h
//  ssssss
//
//  Created by CaiJingPeng on 13-11-7.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINTINTERVAL 50   //点与点间隔距离.
#define MARGINBOTTOM 40   //距底部距离
#define MARGINTOP 40        //距顶部距离
#define MARGINLEFT 40          //距左边距离

@interface kLineView : UIView
{
    float yRate;
}

@property (nonatomic, retain)NSArray *dataArr;
@property (nonatomic, retain)NSArray *dateTitleArr;

@end

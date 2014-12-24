//
//  KLineScrollView.m
//  ssssss
//
//  Created by CaiJingPeng on 13-11-7.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "KLineScrollView.h"
#import "kLineView.h"

@implementation KLineScrollView

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data xTitle:(NSArray *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        int interval = 30; //点与点间隔距离.
        NSInteger pointNum = data.count; //点数量
        
        self.contentSize = CGSizeMake(pointNum*POINTINTERVAL + 10, frame.size.height);
        
        kLineView *kline = [[kLineView alloc] initWithFrame:CGRectMake(0, 0, MAX(320, pointNum*POINTINTERVAL + 20), frame.size.height)];
        kline.backgroundColor = [UIColor clearColor];
        kline.dataArr = data;
        kline.dateTitleArr = title;
        
        [self addSubview:kline];
        [kline release];
        
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

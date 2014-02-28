//
//  kLineView.m
//  ssssss
//
//  Created by CaiJingPeng on 13-11-7.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "kLineView.h"


@implementation kLineView
@synthesize dataArr,dateTitleArr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor redColor];
        
        yRate = 1.0f; //纵坐标与实际frame高度比例
        
        
        
    }
    return self;
}

- (void)setDataArray:(NSArray *)array
{
    [array retain];
    if (dataArr != nil) {
        [dataArr release];
    }
    dataArr = array;
    
    [self setNeedsDisplay];
    
}

- (void)setDateTitleArr:(NSArray *)titleArr
{
    [titleArr retain];
    if (dateTitleArr != nil) {
        [dateTitleArr release];
    }
    dateTitleArr = titleArr;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    int max = 0;
    
    //获取数组中最大值.
    for (int i = 0; i<dataArr.count; i++) {
        int n = [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:i]].intValue;
        if (n>max) {
            max = n;
        }
    }
    
    // 计算缩放比例
    int visibleY = self.frame.size.height - MARGINBOTTOM - MARGINTOP; //可视高度.
    if (max > visibleY) {
        yRate = max / visibleY + 1.0f;
    }else{
        yRate = 1;
    }
    
    
    
//    int interval = 30; //点与点间隔距离.
    int pointNum = dataArr.count; //点数量
    
//    self.contentSize = CGSizeMake(pointNum*interval + 20, self.frame.size.height);
    
    for (int i = 0; i < pointNum-1; i++) {
        
        int yValue = [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:i]].intValue;
        
        int yNextValue = [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:i+1]].intValue;
        
        float h = self.frame.size.height - (yValue/yRate + MARGINBOTTOM);
        float hNext = self.frame.size.height - (yNextValue/yRate + MARGINBOTTOM);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:252/255.0f green:180/255.0f blue:43/255.0f alpha:1.0f].CGColor);
        CGContextMoveToPoint(context, MARGINLEFT + POINTINTERVAL*i, h);
        CGContextAddLineToPoint(context, MARGINLEFT + POINTINTERVAL*(i+1), hNext);
        CGContextStrokePath(context);
        

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 23, 23)];
        [btn setImage:[UIImage imageNamed:@"scoreBtn_default.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"scoreBtn_selected.png"] forState:UIControlStateHighlighted];
        [btn setCenter:CGPointMake(MARGINLEFT + POINTINTERVAL*i, h)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(doClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == pointNum - 2) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 23, 23)];
            [btn setCenter:CGPointMake(MARGINLEFT + POINTINTERVAL*(i+1), hNext)];
            [btn setImage:[UIImage imageNamed:@"scoreBtn_default.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"scoreBtn_selected.png"] forState:UIControlStateHighlighted];
            btn.tag = 100 + i + 1;
            [btn addTarget:self action:@selector(doClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        
        if (self.dateTitleArr != nil) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.center = CGPointMake(MARGINLEFT + POINTINTERVAL*i, self.frame.size.height - 20);
            label.text = [self.dateTitleArr objectAtIndex:i];
            label.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f];
            [self addSubview:label];
            [label release];
            
            if (i == pointNum - 2) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:15];
                label.center = CGPointMake(MARGINLEFT + POINTINTERVAL*(i + 1), self.frame.size.height - 20);
                label.text = [self.dateTitleArr objectAtIndex:i+1];
                label.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f];
                [self addSubview:label];
                [label release];
            }
            
        }
        
        
        
        
//        CGContextRef context = UIGraphicsGetCurrentContext();
        //纵向蓝线
//        CGContextSetLineWidth(context, 1.0);
//        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f].CGColor);
//        CGContextMoveToPoint(context, MARGINLEFT + POINTINTERVAL*i, MARGINTOP);
//        CGContextAddLineToPoint(context, MARGINLEFT + POINTINTERVAL*i, self.frame.size.height - 30);
//        CGContextStrokePath(context);
//        if (i == pointNum - 2) {
//            CGContextSetLineWidth(context, 1.0);
//            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f].CGColor);
//            CGContextMoveToPoint(context, MARGINLEFT + POINTINTERVAL*(i+1), MARGINTOP);
//            CGContextAddLineToPoint(context, MARGINLEFT + POINTINTERVAL*(i+1), self.frame.size.height - 30);
//            CGContextStrokePath(context);
//        }
        
    }
    
    if (pointNum == 1) {
        
        int yValue = [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:0]].intValue;
        float h = self.frame.size.height - (yValue/yRate + MARGINBOTTOM);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 23, 23)];
        [btn setImage:[UIImage imageNamed:@"scoreBtn_default.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"scoreBtn_selected.png"] forState:UIControlStateHighlighted];
        [btn setCenter:CGPointMake(MARGINLEFT , h)];
        btn.tag = 100 ;
        [btn addTarget:self action:@selector(doClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (self.dateTitleArr != nil) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.center = CGPointMake(MARGINLEFT + POINTINTERVAL*0, self.frame.size.height - 20);
            label.text = [self.dateTitleArr objectAtIndex:0];
            label.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f];
            [self addSubview:label];
            [label release];
        }
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:0.5f].CGColor);
    CGContextMoveToPoint(context, 0, self.frame.size.height - 30);
    CGContextAddLineToPoint(context, MAX(320, self.frame.size.width), self.frame.size.height - 30);
    CGContextStrokePath(context);
    
    
    
    UIButton *btn = (UIButton *)[self viewWithTag:100 + self.dateTitleArr.count - 1];
    if (btn != nil) {
        [self doClickBtn:btn];
    }
    
    
}

- (void)doClickBtn:(UIButton *)sender
{
    NSLog(@"%@",[self.dataArr objectAtIndex:sender.tag%100]);
    
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)obj;
            if (b.tag >= 100 && b.tag <=100 + self.dataArr.count) {
                [b setImage:IMAGENAME(IMAGEWITHPATH(@"scoreBtn_default")) forState:UIControlStateNormal];
                [b setImage:IMAGENAME(IMAGEWITHPATH(@"scoreBtn_selected")) forState:UIControlStateHighlighted];
            }
        }
    }
    
    [sender setImage:IMAGENAME(IMAGEWITHPATH(@"scoreBtn_selected"))  forState:UIControlStateNormal];
    [sender setImage:IMAGENAME(IMAGEWITHPATH(@"scoreBtn_default")) forState:UIControlStateHighlighted];
    
    UIView *v = [self viewWithTag:999];
    
    if (v != nil) {
        [UIView animateWithDuration:0.2f animations:^{
            v.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
    
    
    
    NSString *text = [NSString stringWithFormat:@"%@",[self.dataArr objectAtIndex:sender.tag%100]];
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CGSize tsize = [text sizeWithFont:font constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tsize.width + 2*10, tsize.height + 2*5)];
    scoreView.backgroundColor = [UIColor colorWithRed:252/255.0f green:180/255.0f blue:43/255.0f alpha:1.0f];
    scoreView.tag = 999;
    scoreView.center = CGPointMake(sender.center.x, sender.center.y - 30);
    scoreView.alpha = 0.0f;
    //scoreView.layer.cornerRadius = 10;
    [self addSubview:scoreView];
    [scoreView release];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tsize.width, tsize.height)];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.center = CGPointMake(scoreView.frame.size.width/2.0f, scoreView.frame.size.height/2.0f);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [scoreView addSubview:label];
    [label release];
    
    
    
    [UIView animateWithDuration:0.2f animations:^{
        scoreView.alpha = 1.0f;
    }];
    
    
    
}


@end

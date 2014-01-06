//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import "LeveyTabBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
        
		self.backgroundColor = [UIColor clearColor];
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundView];
		
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
		CGFloat width = 80;
		for (int i = 0; i < [imageArray count]; i++)
		{
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
//			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i;
			btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
			[btn setBackgroundImage:nil forState:UIControlStateNormal];
			[btn setBackgroundImage:[UIImage imageNamed:@"tabbarSelected.png"] forState:UIControlStateHighlighted];
			[btn setBackgroundImage:[UIImage imageNamed:@"tabbarSelected.png"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
			[self.buttons addObject:btn];
			[self addSubview:btn];
            
            
            
//            UIImageView *buttomImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_buttom.png"]];
//            buttomImageView.frame=CGRectMake(0, frame.size.height-5, 320, 5);
//            [self addSubview:buttomImageView];
//            [buttomImageView release];
            
            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_badge.png"]];
            imageView.frame=CGRectMake((80-18)+width*i, -7, 19, 19);
            imageView.hidden=YES;
            imageView.tag=i+1000;
            [self addSubview:imageView];
            [imageView release];
            
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
            label.backgroundColor=[UIColor clearColor];
//            label.text=@"11";
            label.tag = 2000 + i;
            label.textColor=[UIColor whiteColor];
            label.font=[UIFont systemFontOfSize:12];
            label.textAlignment=UITextAlignmentCenter;
            [imageView addSubview:label];
            [label release];
            
		}
    }
    return self;
}


-(void)setLabelText:(NSString *)num Function:(int) which
{
    
    UIImageView *imageView=(UIImageView *)[self viewWithTag:(which+1000)];
    imageView.hidden=NO;
    
    for (UILabel *label in imageView.subviews) {
        label.text=num;
    }
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scale.duration =0.25;
    scale.fromValue = [NSNumber numberWithFloat:0];
    scale.toValue = [NSNumber numberWithFloat:1.2];
    scale.autoreverses = YES;
    [imageView.layer addAnimation:scale forKey:@"1"];
    
    
}//applicationIconBadgeNumber
-(void)setBadgeNumber:(NSDictionary *)info
{
//    NSLog(@"%@",info);
//    info = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"article",@"88",@"notice", nil];
    
    NSArray *arr = [NSArray arrayWithObjects:@"article",@"notice",@"events", nil];
    
    for (int i = 0 ; i < 3 ; i++) {
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:(i + 1000)];
        UILabel *label = (UILabel *)[imageView viewWithTag:(i + 2000)];
        
        NSString *str = [NSString stringWithFormat:@"%@",[info objectForKey:[arr objectAtIndex:i]]];
        
        if ([str isEqualToString:@"(null)"] || [str isEqualToString:@"0"]) {
            imageView.hidden = YES;
            continue;
        }
        imageView.hidden = NO;
//        int num = [str intValue];
        label.text = str;
        
        
        
        CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"opacity"];
        scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scale.duration =0.25;
        scale.fromValue = [NSNumber numberWithFloat:0];
        scale.toValue = [NSNumber numberWithFloat:1];
        scale.autoreverses = YES;
        [imageView.layer addAnimation:scale forKey:@"myopacity"];
        
        CABasicAnimation *an=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        an.duration =0.25;
        an.repeatCount = 1;
        an.autoreverses = YES;
        an.fromValue = [NSNumber numberWithFloat:0.8];
        an.toValue = [NSNumber numberWithFloat:1.2];
        [imageView.layer addAnimation:an forKey:@"myscale"];
    }
    
}

- (void)setBadgeViewHidden:(int)type
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:(type + 1000)];
    
    CABasicAnimation *an=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    an.duration =0.5f;
//    an.repeatCount = 1;
//    an.autoreverses = YES;
    an.fromValue = [NSNumber numberWithFloat:1];
    an.toValue = [NSNumber numberWithFloat:0];
    [imageView.layer addAnimation:an forKey:@"myscale1"];
    
    [self performSelector:@selector(badgeHidden:) withObject:[NSString stringWithFormat:@"%d",type] afterDelay:0.45f];
}
- (void)badgeHidden:(NSString *)type
{
//    NSLog(@"%d",type);
    UIImageView *imageView = (UIImageView *)[self viewWithTag:(type.intValue + 1000)];
    imageView.hidden = YES;
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
    
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
    
    NSLog(@"Select index: %d",btn.tag);
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
		b.userInteractionEnabled = YES;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
	btn.userInteractionEnabled = NO;
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = 320.0f / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = 320.0f / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RELOADBADGE" object:nil];
    
    [_backgroundView release];
    [_buttons release];
    [super dealloc];
}

@end

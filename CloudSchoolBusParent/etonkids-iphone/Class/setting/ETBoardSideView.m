//
//  ETBoardSideView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-17.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBoardSideView.h"
#import "ETKids.h"

@implementation ETBoardSideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, self.frame.size.height - 40)];
        b.backgroundColor = CELLCOLOR;
        [self addSubview:b];
        [b release];
        
        navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
        navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
        [self addSubview:navigationBackView];
        [navigationBackView release];
        
        
        leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
        [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2)];
        [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        
        middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13, 100, 20)];
        middleLabel.textAlignment=UITextAlignmentCenter;
        middleLabel.textColor=[UIColor whiteColor];
//        middleLabel.text=LOCAL(@"Settings", @"");
        middleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:middleLabel];
        [middleLabel release];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPan:)];
//        pan.delegate = self;
//        [self addGestureRecognizer:pan];
//        [pan release];
        
        
        
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:swipe];
//        [swipe release];
//        
//        UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
//        swipe1.direction = UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:swipe1];
//        [swipe1 release];
//        
//        [pan requireGestureRecognizerToFail:swipe];
//        [pan requireGestureRecognizerToFail:swipe1];
        
    }
    return self;
}
- (void)doSwipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [UIView animateWithDuration:0.5f animations:^{
            sender.view.superview.frame = CGRectMake(RIGHTMARGIN,
                                                     sender.view.superview.frame.origin.y,
                                                     sender.view.superview.frame.size.width,
                                                     sender.view.superview.frame.size.height);
        }completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            sender.view.superview.frame = CGRectMake(0,
                                                     sender.view.superview.frame.origin.y,
                                                     sender.view.superview.frame.size.width,
                                                     sender.view.superview.frame.size.height);
        }];
        
    }
}

- (void)doPan:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        
        int distanceX = p.x - beginPoint.x;
//        int distanceY = p.y - beginPoint.y;

        if (sender.view.superview.frame.origin.x + distanceX >= 0) {
            sender.view.superview.frame = CGRectMake(sender.view.superview.frame.origin.x + distanceX,
                                                     sender.view.superview.frame.origin.y,
                                                     sender.view.superview.frame.size.width,
                                                     sender.view.superview.frame.size.height);
        }
        
        beginPoint = p;
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
//        CGPoint p = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        
        
        if (self.superview.frame.origin.x >= 190) {
            [UIView animateWithDuration:0.5f animations:^{
                sender.view.superview.frame = CGRectMake(RIGHTMARGIN,
                                                         sender.view.superview.frame.origin.y,
                                                         sender.view.superview.frame.size.width,
                                                         sender.view.superview.frame.size.height);
            }];
            
        }
        else
        {
            [UIView animateWithDuration:0.5f animations:^{
                sender.view.superview.frame = CGRectMake(0,
                                                         sender.view.superview.frame.origin.y,
                                                         sender.view.superview.frame.size.width,
                                                         sender.view.superview.frame.size.height);
            }];
            
        }
        
    }
}


- (void)leftButtonClick:(UIButton *)sender
{
    
    [self endEditing:YES];
    [UIView animateWithDuration:0.3f animations:^{
        if (self.superview.frame.origin.x == RIGHTMARGIN) {
            self.superview.frame = CGRectMake(0,
                                              self.superview.frame.origin.y,
                                              self.superview.frame.size.width,
                                              self.superview.frame.size.height);
        }else{
            self.superview.frame = CGRectMake(RIGHTMARGIN,
                                              self.superview.frame.origin.y,
                                              self.superview.frame.size.width,
                                              self.superview.frame.size.height);
        }
        
    }completion:^(BOOL finished) {
        
        if (self.superview.frame.origin.x == RIGHTMARGIN) {
            if (![self.superview viewWithTag:3333]) {
                UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                             NAVIHEIGHT,
                                                                             self.superview.frame.size.width,
                                                                             self.superview.frame.size.height)];
                blackView.backgroundColor = [UIColor blackColor];
                blackView.alpha = 0.0;
                blackView.tag = 3333;
                [self.superview addSubview:blackView];
                [blackView release];
                
                [UIView animateWithDuration:0.25f animations:^{
                    blackView.alpha = 0.3f;
                }];
            }
        }
        else
        {
            if ([self.superview viewWithTag:3333]) {
                
                [UIView animateWithDuration:0.25f animations:^{
                    [self.superview viewWithTag:3333].alpha = 0.0f;
                }completion:^(BOOL finished) {
                    [[self.superview viewWithTag:3333] removeFromSuperview];
                }];
                
            }
        }
        
    }];
}

- (void)dealloc
{
    
    [super dealloc];
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

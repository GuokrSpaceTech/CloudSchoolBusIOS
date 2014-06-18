//
//  ETCustomAlertView.m
//  ssssss
//
//  Created by CaiJingPeng on 13-9-18.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "ETCustomAlertView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define MAXWIDTH 220

#define VIEWWIDTH 270

#define TITLEFONT   [UIFont boldSystemFontOfSize:17.0f]
#define MSGFONT     [UIFont systemFontOfSize:16.0f]

#define BUTTONHEIGHT 40


#define TOPMARGIN 10
#define BETWEENMARGIN 5

@implementation ETCustomAlertView

@synthesize buttonTitles,delegate,myMessage,myTitle,cancelBtnTitle,otherBtnTitles;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitlesArray:(NSArray *)titles
{
    
    self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        self.cancelBtnTitle = cancelButtonTitle;
        
        self.myTitle = title;
        self.myMessage = message;
        self.delegate = delegate;
        
//        self.windowLevel = UIWindowLevelStatusBar+1;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:titles];
        
        
        if (titles.count == 1)
        {
            [array insertObject:cancelButtonTitle atIndex:0];
        }
        else
        {
            [array addObject:cancelButtonTitle];
        }
        
        
        
        self.buttonTitles = array;
        
        [self createAlert];
        
    }
    return self;
    
    
    
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
    self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        self.cancelBtnTitle = cancelButtonTitle;
        self.otherBtnTitles = otherButtonTitles;
        
        self.myTitle = title;
        self.myMessage = message;
        self.delegate = delegate;
        
//        self.windowLevel = UIWindowLevelStatusBar+1;
        
        NSMutableArray* arrays = [[NSMutableArray alloc] init];
        
        
        
        va_list argList;
        
        if (otherButtonTitles) {
            [arrays addObject:otherButtonTitles];
            va_start(argList, otherButtonTitles);
            
            NSString *arg;
            while ((arg = va_arg(argList, NSString *))) {
                
                if (arg) {
//                    NSString *str=[NSString stringWithFormat:@"%@",arg];
                    [arrays addObject:arg];
                }
            }
            va_end(argList);
            
        }
        
        if (arrays.count == 1)
        {
            [arrays insertObject:cancelButtonTitle atIndex:0];
        }
        else
        {
            if (cancelButtonTitle != nil) {
                [arrays addObject:cancelButtonTitle];
            }
        }
        
        
        
        self.buttonTitles = arrays;
        [arrays release];
        
//        NSLog(@"$$$ %@",self.buttonTitles);
        
        [self createAlert];
        
        
        
//        UILabel *titleLab = [UILabel alloc] initWithFrame:CGRectMake(, ;, , )
        
        
    }
    
    return self;
}


- (void)createAlert
{
    CGSize titleSize = [self.myTitle sizeWithFont:TITLEFONT constrainedToSize:CGSizeMake(MAXWIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize msgSize = [self.myMessage sizeWithFont:MSGFONT constrainedToSize:CGSizeMake(MAXWIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    float btnHeight = (self.buttonTitles.count == 1 || self.buttonTitles.count == 2) ? (BUTTONHEIGHT + 5) : (self.buttonTitles.count * (BUTTONHEIGHT + 5));
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         VIEWWIDTH + 6,
                                                         (titleSize.height == 0 ? 0 : titleSize.height + BETWEENMARGIN) +
                                                         (msgSize.height == 0 ? 0 : msgSize.height + BETWEENMARGIN) +
                                                         TOPMARGIN +
                                                         btnHeight + 6)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.center = CGPointMake(160, ([UIScreen mainScreen].applicationFrame.size.height + 20) / 2);
    [self addSubview:whiteView];
    [whiteView release];
    
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(3,
                                                        3,
                                                        VIEWWIDTH,
                                                        (titleSize.height == 0 ? 0 : titleSize.height + BETWEENMARGIN) +
                                                        (msgSize.height == 0 ? 0 : msgSize.height + BETWEENMARGIN) +
                                                        TOPMARGIN +
                                                        btnHeight)];
    
    mainView.backgroundColor = [UIColor colorWithRed:147/255.0f green:222/255.0f blue:239/255.0f alpha:1.0f];
    //        mainView.center = CGPointMake(160, ([UIScreen mainScreen].applicationFrame.size.height + 20) / 2);
    
    [whiteView addSubview:mainView];
    [mainView release];
    
    
    
    
    if (self.myTitle != nil)
    {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((mainView.frame.size.width - MAXWIDTH)/2, TOPMARGIN, MAXWIDTH, titleSize.height)];
        titleLab.text = self.myTitle;
        titleLab.numberOfLines = 0;
        titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        titleLab.font = TITLEFONT;
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:titleLab];
        [titleLab release];
    }
    
    if (self.myMessage != nil)
    {
        UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake((mainView.frame.size.width - MAXWIDTH)/2, TOPMARGIN + (titleSize.height == 0 ? 0 : titleSize.height + BETWEENMARGIN), MAXWIDTH, msgSize.height)];
        msgLab.text = self.myMessage;
        msgLab.numberOfLines = 0;
        msgLab.lineBreakMode = NSLineBreakByWordWrapping;
        msgLab.font = MSGFONT;
        msgLab.textAlignment = NSTextAlignmentCenter;
        msgLab.backgroundColor = [UIColor clearColor];
        [mainView addSubview:msgLab];
        [msgLab release];
    }
    
    
    int h = TOPMARGIN + (titleSize.height == 0 ? 0 : titleSize.height + BETWEENMARGIN) + (msgSize.height == 0 ? 0 : msgSize.height + BETWEENMARGIN);
    
    for (int i = 0; i < self.buttonTitles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.buttonTitles.count == 2)
        {
            [btn setFrame:CGRectMake(13 + (MAXWIDTH + 30)/2*i, h, (MAXWIDTH + 30)/2 - 5, BUTTONHEIGHT)];
        }
        else
        {
            [btn setFrame:CGRectMake(20, h + i * (BUTTONHEIGHT + 5), (MAXWIDTH + 10), BUTTONHEIGHT)];
        }
        
        if (self.buttonTitles.count > 2 && i == self.buttonTitles.count - 1) {
            [btn setBackgroundImage:[UIImage imageNamed:@"cancelDeep.png"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
        }
        
        btn.tag = 333 + i;
        [btn addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *str = [NSString stringWithFormat:@"%@",[self.buttonTitles objectAtIndex:i]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:str forState:UIControlStateNormal];
        
        [mainView addSubview:btn];
        
    }
}

- (void)doClick:(UIButton *)sender
{
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *btn = (UIButton *)[mainView viewWithTag:333+i];
        btn.userInteractionEnabled = NO;
    }
    
    NSLog(@"%d",sender.tag%333);
    if (delegate && [delegate respondsToSelector:@selector(alertView:didSelectButtonAtIndex:)]) {
        [delegate alertView:self didSelectButtonAtIndex:sender.tag%333];
    }
    
    [self remove];
}

- (void)remove
{
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scale.duration =0.25;
    scale.fromValue = [NSNumber numberWithFloat:1];
    scale.toValue = [NSNumber numberWithFloat:0.8];
    
    CABasicAnimation *opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration = 0.25;
    opacity.fromValue = [NSNumber numberWithFloat:1];
    opacity.toValue = [NSNumber numberWithFloat:0];
    
    
    [whiteView.layer addAnimation:scale forKey:@"sc"];
    [whiteView.layer addAnimation:opacity forKey:@"op"];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
    }];
    
    [self performSelector:@selector(clear) withObject:nil afterDelay:0.20];
//    [self removeFromSuperview];
}
- (void)clear
{
//    [self resignKeyWindow];
    [self release];
    [self removeFromSuperview];
}

- (void)show
{
//    AppDelegate *d = [UIApplication sharedApplication].delegate.window;
//    NSLog(@"%@,%@",self.window,self);
//    [[UIApplication sharedApplication].delegate.window addSubview:self];
//    [self makeKeyAndVisible];
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scale.duration =0.25;
    scale.fromValue = [NSNumber numberWithFloat:2];
    scale.toValue = [NSNumber numberWithFloat:1];
    
    CABasicAnimation *opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration =0.25;
    opacity.fromValue = [NSNumber numberWithFloat:0];
    opacity.toValue = [NSNumber numberWithFloat:1];
    
    
    [whiteView.layer addAnimation:scale forKey:@"sc"];
    [whiteView.layer addAnimation:opacity forKey:@"op"];
    
    
    if (self.cancelBtnTitle == nil && self.otherBtnTitles == nil) {
        [self performSelector:@selector(remove) withObject:nil afterDelay:1.0f];
    }
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end

//
//  MTCustomActionSheet.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-6.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "MTCustomActionSheet.h"
#define CELLCOLOR [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f]

@implementation MTCustomActionSheet
@synthesize _delegate,buttons;

- (id)initWithFrame:(CGRect)frame andImageArr:(NSArray *)imgArr nameArray:(NSArray *)nameArr orientation:(UIInterfaceOrientation)orientation
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            self.frame = CGRectMake(0, 0, (iphone5 ? 568 : 480), 300);
        }else{
            self.frame = CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) + (ios7 ? 20 : 0));
        }
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 275)];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        [mainView release];
        
        count = imgArr.count;
        for (int i = 0; i<imgArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(i%3*96 + 35, 30 + i/3 * 100, 58, 58)];
            
            if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                if(iphone5)
                    button.frame=CGRectMake(i%3*96 +150, 30 + i/3 * 100, 58, 58);
                else
                    button.frame=CGRectMake(i%3*96 +110, 30 + i/3 * 100, 58, 58);
            }else{
                button.frame=CGRectMake(i%3*96 + 35, 30 + i/3 * 100, 58, 58);
            }
            
            button.tag = 777 + i;
            [button addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30)];
//            if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//                label.frame=CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30);
//            }else{
            label.frame=CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30);
//            }
            label.text = [nameArr objectAtIndex:i];
            label.font = [UIFont systemFontOfSize:10];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.tag = 888 + i;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.textAlignment = UITextAlignmentCenter;
            [mainView addSubview:label];
            [label release];
        }
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(0, 0, 240, 40)];
        
        [cancelBtn setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            [cancelBtn setCenter:CGPointMake((iphone5 ? 568 : 480) / 2,240)];
        }else{
            [cancelBtn setCenter:CGPointMake(160,240)];
        }
        
        cancelBtn.tag = 777 + imgArr.count;
        [cancelBtn addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cancelBtn];
        
        
//        [self reloadFrame:orientation];
        
        
        
        
        
    }
    return self;
}
- (id)initWithTitle:(NSString *)title delegate:(id<MTCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, (iphone5 ? 568 : 480));
        
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        NSMutableArray* arrays = [NSMutableArray array];
        
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
        
        if (cancelButtonTitle != nil) {
            [arrays addObject:cancelButtonTitle];
        }
        
        self._delegate = delegate;
        //[self set_delegate:delegate];
        self.buttons = arrays;
        
        mainView = [[UIView alloc] initWithFrame:CGRectZero];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        [mainView release];
        
        int h = 10; // 计算高度.
        
        if (title != nil)
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 320 - 50, 30)];
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = UITextAlignmentCenter;
            [mainView addSubview:titleLabel];
            [titleLabel release];
            
            h += 30;
        }
        
        for (int i = 0;i < self.buttons.count;i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[self.buttons objectAtIndex:i] forState:UIControlStateNormal];
            
            if (cancelButtonTitle != nil && i == self.buttons.count - 1)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"cancelDeep.png"] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
            }
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(30, h + 10 + (40 + (i == self.buttons.count - 1 ? 13 : 10)) * i, 320 - 60, 45)];
            btn.tag = 777 + i;
            [btn addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:btn];
        }
        
        
        mainView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, h + self.buttons.count * 50 + 10 + 13);
        
        
        
        
        
        
    }
    return self;
}



- (id)initWithDatePicker:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, (iphone5 ? 568 : 480));
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 320, 216 + 40)];
        mainView.backgroundColor = CELLCOLOR;
        [self addSubview:mainView];
        [mainView release];
        
        
        datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
        datepicker.datePickerMode = UIDatePickerModeDate;
        if(date!=nil)
        datepicker.date = date;
        [mainView addSubview:datepicker];
        [datepicker release];
        
        NSArray *arr = [NSArray arrayWithObjects:NSLocalizedString(@"cancel", @""),NSLocalizedString(@"OK", @""), nil];
        for (int i = 0; i < 2; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setBackgroundImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:101/255.0f green:184/255.0f blue:206/255.0f alpha:1.0];
            [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.frame = CGRectMake(10 + i*(320 - 50 - 20), 5, 50, 30);
            btn.tag = 777 + i;
            [btn addTarget:self action:@selector(doClickByDatePicker:) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:btn];
            
            
        }
        
        
    }
    
    return self;
}


- (void)doCancel:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        mainView.frame = CGRectMake(0,
                                    (iphone5 ? 548 : 460) + mainView.frame.size.height,
                                    320,
                                    mainView.frame.size.height);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        mainView.frame = CGRectMake(0,
                                    view.frame.size.height - mainView.frame.size.height,
                                    view.frame.size.width,
                                    mainView.frame.size.height);
    }completion:^(BOOL finished) {
        
    }];
}

- (void)doClick:(UIButton *)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickButtonByIndex:)]) {
        [_delegate actionSheet:self didClickButtonByIndex:sender.tag%777];
    }
    
    [self doCancel:nil];
}

- (void)doClickByDatePicker:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickButtonByIndex:selectDate:)]) {
        [_delegate actionSheet:self didClickButtonByIndex:sender.tag%777 selectDate:datepicker.date];
    }
    [self doCancel:nil];
}

- (void)reloadFrame:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.frame = CGRectMake(0, 0, (iphone5 ? 568 : 480), 300);
        mainView.frame = CGRectMake(0, self.frame.size.height - 275, self.frame.size.width, 275);
        
        
        //     [button setFrame:CGRectMake(i%3*96 + 35, 30 + i/3 * 100, 58, 58)];
        //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30)];
        
        for (int i=0; i<count; i++) {
            UIButton *button=(UIButton *)[mainView viewWithTag:i+777];
            
            UILabel *label=(UILabel *)[mainView viewWithTag:i+888];
            
            
            if(iphone5)
                button.frame=CGRectMake(i%3*96 +150, 30 + i/3 * 100, 58, 58);
            else
                button.frame=CGRectMake(i%3*96 +110, 30 + i/3 * 100, 58, 58);
            
            label.frame=CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30);
            
        }
        
        [cancelBtn setCenter:CGPointMake((iphone5 ? 568 : 480) / 2,240)];
        
    }else{
        self.frame = CGRectMake(0, 0, 320, (iphone5 ? 548 : 460));
        mainView.frame = CGRectMake(0, self.frame.size.height - 275, self.frame.size.width, 275);
        
        for (int i=0; i<count; i++) {
            UIButton *button=(UIButton *)[mainView viewWithTag:i+777];
            button.frame=CGRectMake(i%3*96 + 35, 30 + i/3 * 100, 58, 58);
            UILabel *label=(UILabel *)[mainView viewWithTag:i+888];
            label.frame=CGRectMake(button.center.x - 29, button.frame.origin.y + button.frame.size.height, 58, 30);
        }
        
        [cancelBtn setCenter:CGPointMake(160,240)];
    }
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

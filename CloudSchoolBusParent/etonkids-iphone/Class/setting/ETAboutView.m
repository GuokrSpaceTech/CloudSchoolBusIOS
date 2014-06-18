//
//  ETAboutView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-27.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETAboutView.h"
#import "ETKids.h"
#import "ETPrivateViewController.h"
#import "AppDelegate.h"

@implementation ETAboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = CELLCOLOR;
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AboutOurView" owner:self options:nil];
        UIView * v = [arr objectAtIndex:0];
        
        if (iphone5) {
            v.center = CGPointMake(v.center.x, v.center.y + 30);
        }
        
        [self insertSubview:v belowSubview:navigationBackView];
        
        
        middleLabel.text=LOCAL(@"About Us", @"");
        
        
        [leftButton addTarget:self action:@selector(doClickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)doClickLeftButton:(id)sender
{
}

- (void)drawRect:(CGRect)rect
{
    aboutLogo.image = [UIImage imageNamed:LOCAL(@"aboutlogo", @"")];
    
    [privateBtn setTitle:LOCAL(@"private", @"") forState:UIControlStateNormal];
    [privateBtn setTitle:LOCAL(@"private", @"") forState:UIControlStateHighlighted];
}


- (IBAction)doCall:(UIButton *)sender {
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:[sender titleForState:UIControlStateNormal] delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"call", @""), nil];
    [alert show];
    
}

- (IBAction)doClickURL:(id)sender {
//    NSLog(@"url");
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://www.guokrspace.com"]];
}

- (IBAction)doClickGuoKr:(id)sender {
//    NSLog(@"guokr url");
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://www.guokrspace.com"]];
}

- (IBAction)doClickPrivate:(id)sender {
//    cloud.yunxiaoche.com/html/privacy.html
    
    ETPrivateViewController *passViewController=[[ETPrivateViewController alloc]init];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:passViewController animated:YES];
    [passViewController release];
}


- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 1) {
        //NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",[teleButton titleForState:UIControlStateNormal]];
        NSString *num = [NSString stringWithFormat:@"tel://%@",[teleButton titleForState:UIControlStateNormal]];
        UIApplication *app = [UIApplication sharedApplication];
        [app openURL:[NSURL URLWithString:num]];
    }
}



- (void)dealloc {
    [teleButton release];
    [aboutLogo release];
    [privateBtn release];
    [super dealloc];
}
@end

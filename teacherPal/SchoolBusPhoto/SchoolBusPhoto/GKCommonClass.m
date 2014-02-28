//
//  GKCommonClass.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-2-28.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCommonClass.h"
#import "GKAppDelegate.h"

@implementation GKCommonClass

+ (void)createHelpWithTag:(int)tag image:(UIImage *)img
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"help_%d",tag]];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    //判断文件是否存在，判断是否第一次运行程序
    if ([fm fileExistsAtPath:path] == NO)
    {
        GKAppDelegate *del = (GKAppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIWindow *w = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, del.window.frame.size.width, del.window.frame.size.height)];
//        w.backgroundColor = [UIColor clearColor];
        w.windowLevel = UIWindowLevelStatusBar + 1;
        w.tag = tag;
        
        UIImageView *helpImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, del.window.frame.size.width, del.window.frame.size.height)];
        helpImgV.userInteractionEnabled = YES;
//        helpImgV.tag = tag;
        helpImgV.image = img;
        [w addSubview:helpImgV];
        [helpImgV release];
        
        
        [del.window addSubview:w];
        [w release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[GKCommonClass class] action:@selector(removeHelp:)];
        [w addGestureRecognizer:tap];
        [tap release];
        
        [w makeKeyAndVisible];
        
    }
}
+ (void)removeHelp:(UIGestureRecognizer *)sender
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"help_%d",sender.view.tag]];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}

@end

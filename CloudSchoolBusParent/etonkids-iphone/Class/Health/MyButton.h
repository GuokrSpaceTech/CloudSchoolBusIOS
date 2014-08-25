//
//  MyButton.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
{
    
}

@property (nonatomic,retain)UIImageView *animArrImage;
@property (nonatomic,retain)NSString *path;
-(void)startAnimation;
-(void)stopAnimation;
-(void)anSubView;
@end

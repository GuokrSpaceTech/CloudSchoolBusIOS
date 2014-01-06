//
//  ETViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETViewController
 *  @brief  带有navigation的基类
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
@interface ETViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>
{

    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIImageView *middleView;
    UIButton *rightButton;
    UILabel *middleLabel;
    UIScrollView  *scrollview;

}

/// 设置导航条左右按钮图片.
-(void)setNavigationleftImage:(UIImage *)left rightImage:(UIImage *)right ;

/// 设置导航条左右按钮高亮图片.
-(void)setGaoliamngleftImage:(UIImage *)left right:(UIImage *)right ;

/// 设置导航条左右按钮标题.
-(void)setLeftTitle:(NSString *)left RightTitle:(NSString*)right;

/// 设置导航条标题.
-(void)setMiddleText:(NSString *)str;


/**
 *	设置右侧按钮图片 并要求是否可以点击.
 *
 *	@param 	right 	按钮图片.
 *	@param 	isEn 	是否可点击.
 */
-(void)setRightButton:(UIImage *)right isEn:(BOOL)isEn;

@end

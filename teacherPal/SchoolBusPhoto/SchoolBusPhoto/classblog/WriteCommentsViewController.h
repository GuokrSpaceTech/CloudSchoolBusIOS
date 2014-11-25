//
//  WriteCommentsViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-8-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   WriteCommentsViewController
 *  @brief  写评论页面.
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "GKClassBlog.h"
#import "GKBaseViewController.h"
typedef enum
{
    WriteType,
    ReplyType
    
}CommentType;

@protocol WriteCommentsViewControllerDelegate <NSObject>
@optional
- (void)replyCommentByParam:(NSDictionary *)param;

@end

@interface WriteCommentsViewController : GKBaseViewController

{
    UIButton *rightButton;
    MBProgressHUD *HUD;
    UITextView *textV;

}


@property (retain, nonatomic) IBOutlet UITextView *textview;

/// 评论的内容.
@property(retain,nonatomic)GKClassBlog *sharecontent;
@property(retain,nonatomic)NSString *itemid;

/// 评论的类型 写评论、回复评论.

@property (nonatomic, retain) NSString *commentId;

/// 是否返回根目录.
@property (nonatomic, assign) BOOL popRoot;
@property (nonatomic, assign) id<WriteCommentsViewControllerDelegate> delegate;


@end

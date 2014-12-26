//
//  ETShowBigImageViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-5.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETShowBigImageViewController
 *  @brief  显示大图界面.
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETShowBigImageView.h"
#import "WeiboSignIn.h"
#import "TCWBEngine.h"
#import <MessageUI/MessageUI.h>

@interface ETShowBigImageViewController : UIViewController<ETShowBigImageViewDelegate,WeiboSignInDelegate,WeiboRequestDelegate,MFMailComposeViewControllerDelegate>
{
    WeiboSignIn *_weiboSignIn;
    TCWBEngine   *wbEngine;
    ETShowBigImageView *bigImgV;
    
//    MFMailComposeViewController *mc;
}


@property (nonatomic, retain)NSArray *picArr;
@property (nonatomic, assign) NSInteger showNum;
@property (nonatomic, retain) TCWBEngine *tcEngine;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain)UIImage *targetImage;

@end

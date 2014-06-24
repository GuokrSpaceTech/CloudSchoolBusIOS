//
//  ETClassViewController.h
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

/**
 *	@file   ETClassViewController
 *  @brief  班级分享界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETBaseViewController.h"

#import "MBProgressHUD.h"

//#import <MessageUI/MessageUI.h>
#import "ShareContent.h"
#import "EKRequest.h"
#import <AVFoundation/AVFoundation.h>
#import "MTAuthCode.h"
#import "ClassShareCell.h"
#import "SDWebImageManager.h"

#import "CommentDetailViewController.h"

@interface ETClassViewController : ETBaseViewController<WeiboSignInDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ETCustomAlertViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,EKProtocol,ClassShareCellDelegate,classdetailViewControllderdelegate>
{
    MBProgressHUD *HUD;
    int  currentIndex;
    AVPlayer *player;
   
    BOOL isMore;

    ShareContent *shareContent;
    EGORefreshPos theRefreshPos;
    int currentTag;
    UIImage  *headImage;
    
//    UILabel  *defaultlabel;
    
    RequestType reqType;
    
    BOOL isVisible; // 判断当前页面是否可见
    
}
@property (nonatomic,assign)id<ClassShareCellDelegate>delegate;
@property(nonatomic,retain)ShareContent *shareContent;
//@property(nonatomic,retain)ShareContent *sharec;
@property BOOL isLoading;
@property(nonatomic,retain)NSMutableArray *list;

@property(nonatomic,retain)UIImage *headImage;




- (void)loadData;

//- (void)slimeStartLoading;


@end




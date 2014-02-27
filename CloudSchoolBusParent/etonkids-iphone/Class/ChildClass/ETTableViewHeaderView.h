//
//  ETTableViewHeaderView.h
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

/**
 *	@file   ETTableViewHeaderView
 *  @brief  班级分享,通知消息界面 tabelview header
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ETCoreDataManager.h"
#import "MTCustomActionSheet.h"

@protocol headerViewdelegate <NSObject>
@optional
-(void)headerViewBackButtonClick;


@end
@interface ETTableViewHeaderView : UIView<UIActionSheetDelegate,EKProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MTCustomActionSheetDelegate>
{
    UIImageView *photoImageView;
    UILabel *nameLabel;
    UILabel *englishNameLabel;
    UILabel *classLabel;
    UILabel *ageLabel;
    UILabel  *schoolLabel;
    UIImageView *imageBgView;
    UIImageView *ageBack;
    UIImageView *birthdayImgV;
    
    id<headerViewdelegate>delegate;
    
    MBProgressHUD *HUD;

}
@property(nonatomic,assign) id<headerViewdelegate>delegate;
@property(nonatomic,retain)UIImageView *photoImageView;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)  UILabel *englishNameLabel;
@property(nonatomic,retain)UILabel *classLabel;
@property(nonatomic,retain)UILabel *ageLabel;
@property(nonatomic,retain)UILabel *schoolLabel;
@property(nonatomic,retain) UIImageView *imageBgView;
@property (nonatomic, retain)UIImageView *ageBack;

//-(void)hiddenbackButton:(BOOL) hidden;
@end



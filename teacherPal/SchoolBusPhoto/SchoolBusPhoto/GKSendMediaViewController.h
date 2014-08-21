//
//  GKSendMediaViewController.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKStudentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GKPhotoTagScrollView.h"

@interface GKSendMediaViewController : GKBaseViewController<UIActionSheetDelegate,studentViewDelegate,UITextViewDelegate,GKPhotoTagScrollViewDelegate,UIAlertViewDelegate>
{
    
    UITextView *contentTV;
    UILabel *calWordsLab;
    UIImageView *thumbImgV;
}

@property (nonatomic, retain) UIImage *sourcePicture;
@property (nonatomic, retain) NSString *moviePath;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSMutableArray *stuList;
@property (nonatomic, retain) NSMutableArray *photoTag;


@property (nonatomic, assign) BOOL isPresent; //判断是从草稿箱进入的页面 还是拍摄后进入的页面

@end

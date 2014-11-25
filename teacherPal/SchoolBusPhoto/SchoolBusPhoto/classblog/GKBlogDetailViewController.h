//
//  GKBlogDetailViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GKClassBlog.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "EKRequest.h"
@interface GKBlogDetailViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,EKProtocol>
{
    UITextView *commentTF;
    UIButton *upBtn;
    int deleteRow;
}
@property (nonatomic, retain) NSMutableArray *list;

@property (nonatomic,retain)UITableView *tableview;
@property (nonatomic, retain) GKClassBlog *shareContent;
@property (nonatomic, retain) UIView *movieBackView;
@property (nonatomic, retain) MDRadialProgressView *radial;
@property (nonatomic, retain) MPMoviePlayerController *mPlayer;
@end

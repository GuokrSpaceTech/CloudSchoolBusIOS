//
//  CommentDetailViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-8-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   CommentDetailViewController
 *  @brief  评论详细（正文）页面.
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ClassShareCell.h"
#import "DetailContentCell.h"
#import "WriteCommentsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GKMovieDownloader.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"


@interface CommentDetailViewController : UIViewController<EKProtocol,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,DetailContentCellDelegate,UIActionSheetDelegate,UITextViewDelegate,WriteCommentsViewControllerDelegate,MTCustomActionSheetDelegate,GKMovieDownloaderDelegate>
{
    UIImageView *navigationBackView;
    UIButton *leftButton;
//    UIImageView *middleView;
    UILabel *middleLabel;
    CGFloat floatheight;
    
    BOOL isCommentList;//判断是否是评论列表
    
//    RequestMethod reqMethod;
    
    
    UIImageView *topImgV;
    
    NSString *currentComId;
    int deleteRow;
    int tableHeight;
    int tableHeaderHeight;
    
    UITextView *commentTF;
    
    
    UIButton *upBtn;
    
    
    UIActivityIndicatorView *upAI;
    UIActivityIndicatorView *cmtAI;
    
    RequestType reqType;
    
}
@property(nonatomic,retain)NSString  *titilestring;
@property(nonatomic,retain)NSString  *timestring;
@property(nonatomic,retain)NSString  *connetstring;
@property(nonatomic,retain)NSString  *havezanstring;
@property(nonatomic,retain)NSNumber  *upnumnumber;
@property(nonatomic,retain)NSNumber  *commentnumnumber;
@property(nonatomic,retain)NSString  *Picstring;
@property(nonatomic,retain)NSArray   *PicArr;
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,retain) NSMutableArray *sImgArr;

/// 正文详细信息.
@property (nonatomic, retain) ShareContent *shareContent;

@property (nonatomic, retain) NSMutableArray *comList;
@property (nonatomic, retain) NSMutableArray *upList;


@property (nonatomic, retain) UIActivityIndicatorView *upAI;
@property (nonatomic, retain) UIActivityIndicatorView *cmtAI;

@property (nonatomic, retain) UIView *movieBackView;
@property (nonatomic, retain) MDRadialProgressView *radial;
@property (nonatomic, retain) GKMovieDownloader *downloader;
@property (nonatomic, retain) MPMoviePlayerController *mPlayer;


@end

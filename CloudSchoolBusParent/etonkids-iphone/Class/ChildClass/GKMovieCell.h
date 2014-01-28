//
//  GKMovieCell.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-15.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "UserLogin.h"
#import "ETKids.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GKMovieDownloader.h"
#import "ClassShareCell.h"
#import "EKRequest.h"



@interface GKMovieCell : UITableViewCell<GKMovieDownloaderDelegate,EKProtocol>

@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *contentLabel;
@property(nonatomic,retain) UILabel *timeLabel;


@property(nonatomic,retain) UIButton *praiseButton;
@property(nonatomic,retain) UIButton *commentsButton;
@property(nonatomic,retain) UILabel *praiseLab;
@property(nonatomic,retain) UILabel *commentLab;
@property(nonatomic, retain) UIImageView *commentImgV;
@property(nonatomic, retain) UIImageView *praiseImgV;
@property (nonatomic, retain) UIImageView *backImgV;

@property (nonatomic, retain)UIImageView *line;

@property (nonatomic, retain) UIImageView *triangle;

@property (nonatomic, retain) MPMoviePlayerController *mPlayer;
@property (nonatomic, retain) GKMovieDownloader *downloader;

@property (nonatomic, retain) UIView *contentBackView;
@property (nonatomic, retain) UIImageView *movieThumbnailImgV;



@property (nonatomic, assign) id<ClassShareCellDelegate> delegate;
@property(nonatomic,retain) ShareContent *theShareCtnt;
@property (nonatomic, retain) MDRadialProgressView *radia;

@property (nonatomic, retain) NSString *canceledURL;
@property (nonatomic, retain) NSString *currentURL;



- (void)setMovieURL:(NSString *)url;

- (void)addPraiseNumber;
- (void)subPraiseNumber;

- (void)playMovie;

@end

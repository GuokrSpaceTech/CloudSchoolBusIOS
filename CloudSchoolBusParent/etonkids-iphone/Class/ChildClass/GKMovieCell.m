//
//  GKMovieCell.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-15.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieCell.h"


#import "GKMovieCache.h"
#import "ETKids.h"
#import "ETCommonClass.h"
#import "MDRadialProgressTheme.h"
#import "GKMovieManager.h"

#define BUTTONTAG 888


@implementation GKMovieCell
@synthesize titleLabel,contentLabel,timeLabel,backImgV;
@synthesize praiseButton;
@synthesize commentsButton;
@synthesize praiseLab,commentLab,praiseImgV,commentImgV,triangle,mPlayer,delegate,theShareCtnt,radia,currentURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        // Initialization code
        self.contentView.backgroundColor = CELLCOLOR;
        self.backgroundColor = CELLCOLOR;
        self.backgroundView.backgroundColor = CELLCOLOR;
        
        UIImageView *carImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 23)];
        carImgV.image = [UIImage imageNamed:@"car.png"];
        [self addSubview:carImgV];
        [carImgV release];
        
        
        UILabel *tLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 250, 23)];
        tLabel.backgroundColor=[UIColor clearColor];
        tLabel.lineBreakMode = UILineBreakModeWordWrap|NSLineBreakByTruncatingTail;
        tLabel.numberOfLines = 0;
        tLabel.font=[UIFont systemFontOfSize:TITLEFONTSIZE];
        [self addSubview:tLabel];
        [tLabel release];
        
        self.titleLabel = tLabel;
        
        
        UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 16)];
        timeLab.backgroundColor=[UIColor clearColor];
        timeLab.font=[UIFont systemFontOfSize:TIMEFONTSIZE];
        timeLab.textColor = TIMETEXTCOLOR;
        //        self.timeLabel.textAlignment=UITextAlignmentRight;
        [self addSubview:timeLab];
        [timeLab release];
        
        self.timeLabel = timeLab;
        
        UIImageView *tImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        tImgV.image = [UIImage imageNamed:@"triangle.png"];
        [self addSubview:tImgV];
        [tImgV release];
        
        self.triangle = tImgV;
        
        UIImageView *bImgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 270, 0)];
        //        UIImage *img = [UIImage imageNamed:@"popback"];
        //        backImgV.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, 15)];
        bImgV.backgroundColor = [UIColor whiteColor];
        bImgV.layer.cornerRadius = 10;
        [self addSubview:bImgV];
        [bImgV release];
        
        self.backImgV = bImgV;
        
        
        UILabel *ctntLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        ctntLabel.backgroundColor=[UIColor clearColor];
        ctntLabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        ctntLabel.textColor = CONTENTTEXTCOLOR;
        ctntLabel.numberOfLines = 0;
        ctntLabel.lineBreakMode=UILineBreakModeWordWrap|NSLineBreakByTruncatingTail;
        [self addSubview:ctntLabel];
        [ctntLabel release];
        
        self.contentLabel = ctntLabel;
        
        
        UIImageView *pImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        pImgV.image = [UIImage imageNamed:@"cellPraise.png"];
        [self addSubview:pImgV];
        [pImgV release];
        
        self.praiseImgV = pImgV;
        
        UILabel *pLab = [[UILabel alloc] initWithFrame:CGRectZero];
        pLab.backgroundColor=[UIColor clearColor];
        pLab.textAlignment = NSTextAlignmentCenter;
        //        praiseLab.adjustsFontSizeToFitWidth = YES;
        pLab.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        pLab.textColor = CONTENTTEXTCOLOR;
        [self addSubview:pLab];
        [pLab release];
        
        self.praiseLab = pLab;
        
        UIImageView *cmtImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        cmtImgV.image = [UIImage imageNamed:@"cellComment.png"];
        [self addSubview:cmtImgV];
        [cmtImgV release];
        
        self.commentImgV = cmtImgV;
        
        UILabel *cmtLab = [[UILabel alloc] initWithFrame:CGRectZero];
        cmtLab.backgroundColor=[UIColor clearColor];
        cmtLab.textAlignment = NSTextAlignmentCenter;
        //        commentLab.adjustsFontSizeToFitWidth = YES;
        cmtLab.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        cmtLab.textColor = CONTENTTEXTCOLOR;
        [self addSubview:cmtLab];
        [cmtLab release];
        
        self.commentLab = cmtLab;
        
        
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pButton setFrame:CGRectMake(185, 0, 70, 30)];
        //        praiseButton.backgroundColor = [UIColor redColor];
        [pButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pButton];
        
        self.praiseButton = pButton;
        
        UIButton *cmtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        commentsButton.backgroundColor = [UIColor blueColor];
        [cmtButton setFrame:CGRectMake(255, 0, 70, 30)];
        //        commentsButton.alpha = 0.2f;
        //        commentsButton.hidden = NO;
        [cmtButton addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cmtButton];
        
        self.commentsButton = cmtButton;
        
        UIView *ctntView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, MOVIESIZE, MOVIESIZE)];
        ctntView.backgroundColor = [UIColor clearColor];
        [self addSubview:ctntView];
        [ctntView release];
        
        self.contentBackView = ctntView;
        
        UIImageView *mthumbImgV = [[UIImageView alloc] initWithFrame:ctntView.bounds];
        mthumbImgV.backgroundColor = [UIColor whiteColor];
        [ctntView addSubview:mthumbImgV];
        [mthumbImgV release];
        
        self.movieThumbnailImgV = mthumbImgV;
        
        
        MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
        newTheme.completedColor = [UIColor colorWithRed:45/255.0 green:117/255.0 blue:140/255.0 alpha:1.0];
        newTheme.incompletedColor = [UIColor colorWithRed:110/255.0 green:191/255.0 blue:210/255.0 alpha:1.0];
        newTheme.centerColor = [UIColor clearColor];
        //        newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
        newTheme.sliceDividerHidden = YES;
        newTheme.labelColor = [UIColor whiteColor];
        newTheme.labelShadowColor = [UIColor whiteColor];
        
        CGRect frame = CGRectMake(self.contentBackView.frame.size.width/2.0f - 35, self.contentBackView.frame.size.height/2.0f - 35, 70, 70);
        MDRadialProgressView *radialView7 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
        radialView7.hidden = YES;
        [self.contentBackView addSubview:radialView7];
        [radialView7 release];
        
        self.radia = radialView7;
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:nil];//写入url
        player.controlStyle = MPMovieControlStyleNone;
        player.movieSourceType = MPMovieSourceTypeFile;
        player.view.hidden = YES;
        [player.view setFrame:self.contentBackView.bounds];
        [self.contentBackView addSubview:player.view];
        //    [player prepareToPlay];
        self.mPlayer = player;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChangeState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mPlayer];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:nil forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = BUTTONTAG;
        [btn addTarget:self action:@selector(controlMovie:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:self.contentBackView.bounds];
        [self.contentBackView addSubview:btn];
        
        UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectZero];
        l.image = [UIImage imageNamed:@"cellline.png"];
        [self addSubview:l];
        [l release];
        
        self.line = l;
    }
    return self;
}

- (void)setMovieURL:(NSString *)url
{
    @synchronized(self)
    {
        if (self.mPlayer)
        {
            NSLog(@"ssssssssssssssssssssssssssssssssssssssssssssssssss ,%f",self.frame.origin.y);
            [self.mPlayer stop];
            self.mPlayer.contentURL = nil;
            
            self.radia.hidden = YES;
            UIButton *b = (UIButton *)[self.contentBackView viewWithTag:BUTTONTAG];
            [b setImage:nil forState:UIControlStateNormal];
        }
    }
    
    self.currentURL = url;
    
    
    
    // 延时下载
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelegte = SHARED_APP_DELEGATE;
    
    
    
    
    if (([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"] && appDelegte.networkStatus != ReachableViaWWAN) // wifi下自动播放
        || [[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"2"])// 始终自动播放
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadMovie:) object:self.canceledURL];
        [self performSelector:@selector(downloadMovie:) withObject:url afterDelay:0.5f];
        self.canceledURL = url;//记录请求过的url  供取消使用
    }
    else // 关闭自动播放  或其他
    {
        UIButton *b = (UIButton *)[self.contentBackView viewWithTag:BUTTONTAG];
        [b setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
    }
    
    
    
}
- (void)downloadMovie:(NSString *)url
{
    
    [[GKMovieManager shareManager] downloadMovieWithURL:url progress:^(unsigned long long size, unsigned long long total, NSString *downloadingPath)
    {
        NSString *filename = [[downloadingPath componentsSeparatedByString:@"/"] lastObject];
        NSString *curName = [[self.currentURL componentsSeparatedByString:@"/"] lastObject];
        if ([curName isEqualToString:filename])
        {
            self.radia.hidden = NO;
            self.radia.progressCounter = size;
            self.radia.progressTotal = total;
        }
        else
        {
//            self.radia.hidden = YES;
        }
    }
    complete:^(NSString *path, NSError *error)
    {
        NSLog(@"############# %f",self.frame.origin.y);
        
        
        NSString *filename = [[path componentsSeparatedByString:@"/"] lastObject];
        NSString *curName = [[self.currentURL componentsSeparatedByString:@"/"] lastObject];
        
//        NSLog(@"############# %@,%@",filename,self.currentURL);
        
        if ([curName isEqualToString:filename])   //
        {
            self.radia.hidden = YES;
            self.mPlayer.contentURL = [NSURL fileURLWithPath:path];
//            self.mPlayer.initialPlaybackTime = -1;
            
            //下载完成后谁优先谁播放
//            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//            if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"])
//            {//如果设置自动播放
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MOVIEDOWNLOADCOMPLETE" object:nil];
//            }
//            else
//            {
//                UIButton *b = (UIButton *)[self.contentBackView viewWithTag:BUTTONTAG];
//                [b setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
//            }
            
            
        }
        
    }];
}



- (void)playbackChangeState:(MPMediaPickerController *)player
{
//    @synchronized(self)
//    {
    
//        NSLog(@"player %@",player);
        
        UIButton *b = (UIButton *)[self.contentBackView viewWithTag:BUTTONTAG];
        
        if (self.mPlayer.playbackState == MPMoviePlaybackStatePaused)
        {
            
            NSLog(@"pause %f",self.frame.origin.y);
//            self.mPlayer.view.hidden = NO;
            [b setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
        }
        else if (self.mPlayer.playbackState == MPMoviePlaybackStateStopped)
        {
            NSLog(@"stop %f",self.frame.origin.y);
            self.mPlayer.view.hidden = YES;
            [b setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
        }
        else if (self.mPlayer.playbackState == MPMoviePlaybackStatePlaying)
        {
            NSLog(@"playing %f",self.frame.origin.y);
            self.mPlayer.view.hidden = NO;
            [b setImage:nil forState:UIControlStateNormal];
        }
//    }
    
}

- (void)controlMovie:(UIButton *)sender
{
    GKMovieManager *mm = [GKMovieManager shareManager];
    if (self.mPlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        mm.playingCell = nil;
        [self.mPlayer pause];
        [sender setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
    }
    else if (self.mPlayer.playbackState == MPMoviePlaybackStatePaused)
    {
        [mm toggleMoviePlayingWithCell:self];
        [sender setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:nil forState:UIControlStateNormal];
        [self downloadMovie:self.currentURL];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/// 点击赞事件.
-(void)praise:(UIButton*)sender
{
    
    CABasicAnimation *an=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    an.duration =0.15;
    an.repeatCount = 1;
    an.autoreverses = YES;
    an.fromValue = [NSNumber numberWithFloat:0.8];
    an.toValue = [NSNumber numberWithFloat:1.2];
    [praiseImgV.layer addAnimation:an forKey:@"dfdf"];
    
    
    if (delegate && [delegate respondsToSelector:@selector(clickPraise:)]) {
        [delegate clickPraise:self];
    }

}



- (void)addPraiseNumber
{
    self.praiseLab.text = [NSString stringWithFormat:@"%d",self.praiseLab.text.intValue + 1];
    
    self.praiseImgV.image = [UIImage imageNamed:@"myzan.png"];
}
- (void)subPraiseNumber
{
    self.praiseLab.text = [NSString stringWithFormat:@"%d",self.praiseLab.text.intValue - 1];
    
    if (self.praiseLab.text.intValue == 0)
    {
        self.praiseLab.text = LOCAL(@"upText", @"");
    }
    
    self.praiseImgV.image = [UIImage imageNamed:@"cellPraise.png"];
}

/// 点击评论.
-(void)comments:(UIButton*)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickComment:)]) {
        [delegate clickComment:self.theShareCtnt];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mPlayer];
    self.titleLabel = nil;
    self.contentLabel = nil;
    self.timeLabel = nil;
    self.praiseButton = nil;
    self.commentsButton = nil;
    self.praiseLab = nil;
    self.commentLab = nil;
    self.commentImgV = nil;
    self.praiseImgV = nil;
    self.backImgV = nil;
    self.line = nil;
    self.triangle = nil;
    self.mPlayer = nil;
    self.downloader = nil;
    self.contentBackView = nil;
    self.movieThumbnailImgV = nil;
    [super dealloc];
}

@end

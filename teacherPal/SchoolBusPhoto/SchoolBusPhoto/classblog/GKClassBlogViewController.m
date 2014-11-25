//
//  GKZClassBlogViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-19.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKClassBlogViewController.h"
#import "KKNavigationController.h"
#import "GKMainViewController.h"
//#import "GKClassBlog.h"
#import "GKShowBigImageViewController.h"
#import "UIImageView+WebCache.h"
#import "GTMBase64.h"
#import "NSDate+convenience.h"
#import <MediaPlayer/MediaPlayer.h>

#import "GKMovieManager.h"
@interface GKClassBlogViewController ()

@end

@implementation GKClassBlogViewController
@synthesize _tableView;
@synthesize _slimeView;;
@synthesize _refreshFooterView;
@synthesize isLoading;
@synthesize isMore;
@synthesize list;
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
      isVisible = YES;
}
-(void)setisVisiblebecomeYES
{
    isVisible=YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    isVisible = NO;
    
    GKMovieManager *mm = [GKMovieManager shareManager];
    //    NSLog(@"@@@@@@@@@@@@@@@@@   %@,%d",mm.playingCell,mm.playingCell.mPlayer.playbackState);
    if (mm.playingCell && mm.playingCell.mPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [mm.playingCell.mPlayer stop];
    }
}
-(void)dealloc
{

    self._tableView=nil;
    self._slimeView=nil;
    self.list=nil;
    self._refreshFooterView=nil;
    [super dealloc];
}
-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}
- (void)movieDownloadCompleteNotification:(NSNotification *)noti
{
    [self controlVisibleCellPlay];
}

- (void)controlVisibleCellPlay
{
    
    if (!isVisible) {
        return;
    }
    
    NSArray *cells = [_tableView visibleCells];
    
    GKMovieManager *mm = [GKMovieManager shareManager];
    //    NSMutableArray *tempDownloadingArray = [NSMutableArray arrayWithArray:mm.downloadList];
    
    //    NSLog(@"%@",cells);
    
    GKMovieCell *cell;
    
    int minDis = 1000;
    
    for (int i = cells.count - 1 ; i>=0 ; i--) {
        id obj = [cells objectAtIndex:i];
        
        if ([obj isKindOfClass:[GKMovieCell class]])
        {
            GKMovieCell *tempCell = (GKMovieCell *)obj;
            
            int dis = ABS(tempCell.frame.origin.y - (_tableView.contentOffset.y));
            if (dis < minDis) {
                minDis = dis;
                cell = tempCell;
            }
            
        }
        
    }
    
    
    
    if (minDis != 1000)
    {
        if (cell.mPlayer.playbackState == MPMoviePlaybackStateStopped || cell.mPlayer.playbackState == MPMoviePlaybackStatePaused)
        {
            
            [mm toggleMoviePlayingWithCell:cell];
        }
    }
    
    
    
}

- (void)reloadTable:(NSNotification *)noti
{
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDownloadCompleteNotification:) name:@"MOVIEDOWNLOADCOMPLETE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"NOTIFICELL" object:nil];
    // Do any additional setup after loading the view.
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    

    
    list=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y ) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor blackColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    [_tableView addSubview:self._slimeView];
    
    titlelabel.text=@"班级分享";
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
    
    [self requestArticalData:param];
   // NSDictionary *dic

}
-(void) requestArticalData:(NSDictionary *) param
{
    [[EKRequest Instance] EKHTTPRequest:article parameters:param requestMethod:GET forDelegate:self];
}
#pragma mark  网络代理
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(method==article)
    {
        isLoading = NO;
        if(code==1)
        {
            NSDictionary *result =[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSArray *arr = [result objectForKey:@"articlelist"];
            
            if([[parm objectForKey:@"starttime"] isEqualToString:@"0"] && [[parm objectForKey:@"endtime"] isEqualToString:@"0"])
            {
                [self.list removeAllObjects];
            }
            if (arr.count <15)
            {
                isMore = NO;
            }
            else
            {
                isMore = YES;
            }
            
            
            for (int i=0; i<[arr count]; i++)
            {
                NSDictionary *myDic=(NSDictionary *)[arr objectAtIndex:i];
                
                GKClassBlog *share=[[GKClassBlog alloc]init];
                share.shareId=[myDic objectForKey:@"articleid"];
                
                NSArray * plists = [myDic objectForKey:@"plist"];
                if(plists.count >0)
                {
                    share.sharePicArr = plists;
                    NSDictionary * plist = [plists objectAtIndex:0];
                    if(plist != nil && plist.count > 0)
                        share.sharePic=[plist objectForKey:@"source"];
                }
                
                NSArray * tagList=[myDic objectForKey:@"taglist"];
                share.tagArr=tagList;
                share.shareContent=[myDic objectForKey:@"content"];
                share.shareTitle=[myDic objectForKey:@"title"];
                share.upnum=[myDic objectForKey:@"upnum"];
                share.shareKey = [myDic objectForKey:@"articlekey"];
                share.havezan=[myDic objectForKey:@"havezan"];
                share.commentnum=[myDic objectForKey:@"commentnum"];
                NSDateFormatter * format = [[[NSDateFormatter alloc] init] autorelease];
                [format setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[myDic objectForKey:@"publishtime"] doubleValue]];
                NSString * dateStr = [format stringFromDate:date];
                
                
                share.shareTime=dateStr;
                share.isMore=NO;
                share.publishtime = [myDic objectForKey:@"publishtime"];
                
                
                [self.list addObject:share];
                
                [share release];
            }


        }

        
        if(self._refreshFooterView)
        {
            [self._refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
            [self removeFooterView];
        }
        [_slimeView endRefresh];
        [_tableView reloadData];
            
        
    }
    else if(method==comment)
    {
        if(code == 1)
        {
            
            NSString *key = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
            
            NSString *shareId = [parm objectForKey:@"itemid"];
            
            for (int i = 0; i<self.list.count; i++) {
                GKClassBlog *share = [self.list objectAtIndex:i];
                if ([share.shareId isEqualToString:shareId])
                {
                    share.havezan = [NSNumber numberWithInt:key.intValue];
                    share.upnum = [NSNumber numberWithInt:share.upnum.intValue + 1];
                    
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    NSDictionary *fDic = [share.sharePicArr objectAtIndex:0];
                    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
                    //        NSString *source = @"http://yunxiaoche.blob.core.windows.net/article-source/39958_1389601724_644558.mp4";
                    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject];
                    
                    if ([ext isEqualToString:@"mp4"]) {
                        GKMovieCell *cell = (GKMovieCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell addPraiseNumber];
                    }
                    else
                    {
                        ClassShareCell *cell = (ClassShareCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell addPraiseNumber];
                    }
                    
                    
                    
                    break;
                }
            }
            
        }
 
    }
    else if(method==deleteF)
    {
        if (code==1)
        {
            //            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"cancelPraiseSuccess",@"取消赞成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            //            [alert show];
            
            NSString *key = [parm objectForKey:@"key"];
            
            for (int i = 0; i<self.list.count; i++) {
                GKClassBlog *share = [self.list objectAtIndex:i];
                if (share.havezan.intValue == key.intValue)
                {
                    share.havezan = [NSNumber numberWithInt:0];
                    share.upnum = [NSNumber numberWithInt:share.upnum.intValue - 1];
                    
                    
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    NSDictionary *fDic = [share.sharePicArr objectAtIndex:0];
                    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
                    //        NSString *source = @"http://yunxiaoche.blob.core.windows.net/article-source/39958_1389601724_644558.mp4";
                    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject];
                    
                    if ([ext isEqualToString:@"mp4"]) {
                        GKMovieCell *cell = (GKMovieCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell subPraiseNumber];
                    }
                    else
                    {
                        ClassShareCell *cell = (ClassShareCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell subPraiseNumber];
                    }
                    
                    
                    
                    break;
                }
            }
            
            
        }

    }
    
    
}

-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    isLoading = NO;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1=@"cell";
    
    
    GKClassBlog *sContent=[self.list objectAtIndex:indexPath.row];
    NSDictionary *fDic = [sContent.sharePicArr objectAtIndex:0];
    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
    
    
    if ([ext isEqualToString:@"mp4"])
    {
        CellIdentifier1 = @"movieCell";
        GKMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell == nil)
        {
            cell= [[[GKMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            cell.delegate = self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row==[self.list count]-1)
        {
            if(isMore)
                [self setFooterView];
            else
                [self removeFooterView];
        }
        if(self.list.count > 0)
        {
            cell.tag = indexPath.row;
            GKClassBlog *sContent=[self.list objectAtIndex:indexPath.row];
            
            
            int calculateHeight = 0; // add up height.
            
            CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
            // 内容高度 contentsize.height
            [cell.contentLabel setFrame:CGRectMake(10,
                                                   calculateHeight + 5, //the distance is between title and content,
                                                   contentSize.width,
                                                   contentSize.height)];
            
            if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
                calculateHeight=0;
            else
                calculateHeight = calculateHeight+ 5 + contentSize.height;
            
            
            
            
            cell.contentLabel.text = sContent.shareContent;
            
            
            
            // --------   加载视频   --------
            
            cell.contentBackView.frame = CGRectMake(cell.contentBackView.frame.origin.x,
                                                    calculateHeight+5 ,
                                                    cell.contentBackView.frame.size.width,
                                                    cell.contentBackView.frame.size.height);
            [cell setMovieURL:source];
            //                NSLog(@"%@",source);
            
            [cell.movieThumbnailImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",source]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
             {
                 
                 cell.movieThumbnailImgV.image = image;
             }];
            
            calculateHeight = calculateHeight +5+ cell.contentBackView.frame.size.height ;
            
            
            // calculateHeight += 10;
            
            cell.timeLabel.frame = CGRectMake(10, calculateHeight+5, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
            
            calculateHeight=calculateHeight+5+20;
            //----- calculate time -----------
            NSString *time = sContent.publishtime;
            
            int cDate = [[NSDate date] timeIntervalSince1970];
            NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
            int sub = cDate - time.intValue;
            
            NSString *dateStr;
            
            if (sub < 60*60)//小于一小时
            {
                dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,NSLocalizedString(@"minutesago", @"")];
            }
            else if (sub < 12*60*60 && sub >= 60*60)
            {
                dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),NSLocalizedString(@"hoursago", @"")];
            }
            else if (pDate.year == [NSDate date].year)
            {
                NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
                format.dateFormat = @"MM-dd HH:mm";
                dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
            }
            else if (pDate.year < [NSDate date].year)
            {
                NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
                format.dateFormat = @"yyyy-MM-dd HH:mm";
                dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
            }
            else
            {
                dateStr = [NSString stringWithFormat:@"error time"];
            }
            
            
            if (time !=nil) {
                cell.timeLabel.text = dateStr;
            }
            
            // -----------------------
            
            int centerHeight = calculateHeight -15+ cell.timeLabel.frame.size.height/2;
            
            cell.praiseButton.frame = CGRectMake(cell.praiseButton.frame.origin.x, centerHeight - cell.praiseButton.frame.size.height/2, cell.praiseButton.frame.size.width, cell.praiseButton.frame.size.height);
            cell.commentsButton.frame = CGRectMake(cell.commentsButton.frame.origin.x, centerHeight - cell.commentsButton.frame.size.height/2, cell.commentsButton.frame.size.width, cell.commentsButton.frame.size.height);
            cell.praiseImgV.frame = CGRectMake(cell.praiseButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
            if (sContent.havezan.intValue == 0)
            {
                cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise.png"];
            }
            else
            {
                cell.praiseImgV.image = [UIImage imageNamed:@"myzan.png"];
            }
            cell.theShareCtnt = sContent;
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0]; //获得当期语言.
            cell.praiseLab.frame = CGRectMake(cell.praiseButton.frame.origin.x + 25, centerHeight - 7, 35, 14);
            cell.praiseLab.text = [NSString stringWithFormat:@"%@", (sContent.upnum.intValue == 0 ? NSLocalizedString(@"upText", @"") : sContent.upnum)];
            if (sContent.upnum.intValue == 0)
            {
                if([currentLanguage isEqualToString:@"en"])
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:8];
                }
                else
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:12];
                }
            }
            else
            {
                cell.praiseLab.font = [UIFont systemFontOfSize:15];
            }
            cell.commentImgV.frame = CGRectMake(cell.commentsButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
            cell.commentLab.frame = CGRectMake(cell.commentsButton.frame.origin.x + 25, centerHeight - 7 , 38, 14);
            cell.commentLab.text = [NSString stringWithFormat:@"%@",(sContent.commentnum.intValue == 0 ? NSLocalizedString(@"comText", @"") : sContent.commentnum)];
            if (sContent.commentnum.intValue == 0)
            {
                if([currentLanguage isEqualToString:@"en"])
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:8];
                }
                else
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:12];
                }
            }
            else
            {
                cell.commentLab.font = [UIFont systemFontOfSize:15];
            }
            
            cell.line.frame = CGRectMake(0, calculateHeight + 5, 320, 2);
            
            
            
//            UserLogin *user = [UserLogin currentLogin];
//            
//            if (user.can_comment != nil && [user.can_comment isEqualToString:@"1"]) {
//                //                cell.commentsButton.enabled = YES;
//                cell.commentImgV.image = [UIImage imageNamed:@"cellComment.png"];
//            }else{
//                //                cell.commentsButton.enabled = NO;
//                cell.commentImgV.image = [UIImage imageNamed:@"cellComment_disable.png"];
//            }
//            
//            if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
//                //                cell.praiseButton.enabled = YES;
//            }else{
//                //                cell.praiseButton.enabled = NO;
//                cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise_disable.png"];
//            }
            
        }
        
        
        return cell;
        
        
    }
    else
    {
        CellIdentifier1 = @"classCell";
        ClassShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell == nil)
        {
            cell= [[[ClassShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1 cellMode:Normal] autorelease];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row==[self.list count]-1)
        {
            if(isMore)
                [self setFooterView];
            else
                [self removeFooterView];
        }
        if(self.list.count >0)
        {
            cell.tag = indexPath.row;
            GKClassBlog *sContent=[self.list objectAtIndex:indexPath.row];
            float calculateHeight = 0; // add up height.
            
            
            CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
            //
            [cell.contentLabel setFrame:CGRectMake(10,
                                                   calculateHeight + 5, //the distance is between title and content,
                                                   contentSize.width,
                                                   contentSize.height)];
            
            if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
                calculateHeight=0;
            else
                calculateHeight = calculateHeight+ 5 + contentSize.height;
            
            
            
            cell.contentLabel.text = sContent.shareContent;
            
            
            
            if ([CellIdentifier1 isEqualToString:@"movieCell"]) {  // 判断是否是视频
                
                cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x,
                                                    calculateHeight + 10,
                                                    cell.contentView.frame.size.width,
                                                    cell.contentView.frame.size.height);
                
            }
            
            
            int picCount = sContent.sharePicArr.count;
            
            // __block float picHeight=0;
            if(picCount>=1)
            {
                NSDictionary *dic = [sContent.sharePicArr objectAtIndex:0];
                NSString *picURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"source"]];
                picURL = [picURL stringByAppendingString:@".small.jpg"];
                
                [cell.picImageView setImageWithURL:[NSURL URLWithString:picURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if (error) {
                        
                        //cell.picImageView.image = [UIImage imageNamed:@"imageerror.png"];
                        //  cell.picImageView.frame = CGRectMake(5, calculateHeight + 10 , _tableView.frame.size.width-10, 150);
                    }
                    else
                    {
                        // cell.picImageView.image = image;
                        
                        //  float picHeight=image.size.height*(300 /image.size.width);
                        
                        
                        if (cacheType == 0) { // request url
                            CATransition *transition = [CATransition animation];
                            transition.duration = 1.0f;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            
                            [cell.picImageView.layer addAnimation:transition forKey:nil];
                        }
                    }
                    
                    
                }];
                
                cell.picImageView.frame = CGRectMake(5, calculateHeight + 10 , _tableView.frame.size.width-10, 200);
                
            }
            else
            {
                cell.picImageView.image = nil;
                cell.picImageView.frame = CGRectZero;
                
            }
            
            
            
            if (sContent.sharePicArr.count == 1)
            {
                calculateHeight = calculateHeight+ 5+ 200 ;
            }
            
            
            
            cell.timeLabel.frame = CGRectMake(10, calculateHeight+10, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
            calculateHeight = calculateHeight+ 5 +20;
            //----- calculate time -----------
            NSString *time = sContent.publishtime;
            
            int cDate = [[NSDate date] timeIntervalSince1970];
            NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
            int sub = cDate - time.intValue;
            
            NSString *dateStr;
            
            if (sub < 60*60)//小于一小时
            {
                dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,NSLocalizedString(@"minutesago", @"")];
            }
            else if (sub < 12*60*60 && sub >= 60*60)
            {
                dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),NSLocalizedString(@"hoursago", @"")];
            }
            else if (pDate.year == [NSDate date].year)
            {
                NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
                format.dateFormat = @"MM-dd HH:mm";
                dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
            }
            else if (pDate.year < [NSDate date].year)
            {
                NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
                format.dateFormat = @"yyyy-MM-dd HH:mm";
                dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
            }
            else
            {
                dateStr = [NSString stringWithFormat:@"error time"];
            }
            
            
            if (time !=nil) {
                cell.timeLabel.text = dateStr;
            }
            
            // -----------------------
            //calculateHeight+ 5 +20
            int centerHeight = calculateHeight-15 + cell.timeLabel.frame.size.height/2;
            
            cell.praiseButton.frame = CGRectMake(cell.praiseButton.frame.origin.x, centerHeight - cell.praiseButton.frame.size.height/2, cell.praiseButton.frame.size.width, cell.praiseButton.frame.size.height);
            
            
            cell.commentsButton.frame = CGRectMake(cell.commentsButton.frame.origin.x, centerHeight - cell.commentsButton.frame.size.height/2, cell.commentsButton.frame.size.width, cell.commentsButton.frame.size.height);
            
            
            cell.praiseImgV.frame = CGRectMake(cell.praiseButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
            
            if (sContent.havezan.intValue == 0)
            {
                cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise.png"];
            }
            else
            {
                cell.praiseImgV.image = [UIImage imageNamed:@"myzan.png"];
            }
            
            
            
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0]; //获得当期语言.
            
            cell.praiseLab.frame = CGRectMake(cell.praiseButton.frame.origin.x + 25, centerHeight - 7, 35, 14);
            cell.praiseLab.text = [NSString stringWithFormat:@"%@", (sContent.upnum.intValue == 0 ? NSLocalizedString(@"upText", @"") : sContent.upnum)];
            if (sContent.upnum.intValue == 0)
            {
                if([currentLanguage isEqualToString:@"en"])
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:8];
                }
                else
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:12];
                }
                
            }
            else
            {
                cell.praiseLab.font = [UIFont systemFontOfSize:15];
            }
            
            cell.commentImgV.frame = CGRectMake(cell.commentsButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
            cell.commentLab.frame = CGRectMake(cell.commentsButton.frame.origin.x + 25, centerHeight - 7 , 38, 14);
            cell.commentLab.text = [NSString stringWithFormat:@"%@",(sContent.commentnum.intValue == 0 ? NSLocalizedString(@"comText", @"") : sContent.commentnum)];
            if (sContent.commentnum.intValue == 0)
            {
                
                if([currentLanguage isEqualToString:@"en"])
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:8];
                }
                else
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:12];
                }
                
            }
            else
            {
                cell.commentLab.font = [UIFont systemFontOfSize:15];
            }
            
            cell.line.frame = CGRectMake(0, calculateHeight + 5, 320, 2);
            
            
            cell.theShareCtnt = sContent;
            
            
//            UserLogin *user = [UserLogin currentLogin];
//            
//            if (user.can_comment != nil && [user.can_comment isEqualToString:@"1"]) {
//                //                cell.commentsButton.enabled = YES;
//                cell.commentImgV.image = [UIImage imageNamed:@"cellComment.png"];
//            }else{
//                //                cell.commentsButton.enabled = NO;
//                cell.commentImgV.image = [UIImage imageNamed:@"cellComment_disable.png"];
//            }
//            
//            if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
//                //                cell.praiseButton.enabled = YES;
//            }else{
//                //                cell.praiseButton.enabled = NO;
//                cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise_disable.png"];
//            }
            
        }
        
        
        return cell;
        
    }
    
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.list.count == 0) return (iphone5 ? 568 : 460) - 46 - 57 - 135;
    
    GKClassBlog *sContent=[self.list objectAtIndex:indexPath.row];
    
    int calculateHeight = 0; // add up height.
    
    CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
        calculateHeight=0;
    else
        calculateHeight = calculateHeight+ 5 + contentSize.height;
    
    
    
    
    
    NSDictionary *fDic = [sContent.sharePicArr objectAtIndex:0];
    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
    
    
    if ([ext isEqualToString:@"mp4"])
    {
        calculateHeight = calculateHeight+5 + 300 + 5 + 20 + 5 +2;
    }
    else
    {
        
        
        
        // ClassShareCell*cell=(ClassShareCell *)[tableView cellForRowAtIndexPath:indexPath];
        //
        NSDictionary *dic = [sContent.sharePicArr objectAtIndex:0];
        NSString *picURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"source"]];
        picURL = [picURL stringByAppendingString:@".small.jpg"];
        
        
        if (sContent.sharePicArr.count == 1)
        {
            calculateHeight = calculateHeight +5+  200 + 5 + 20 + 5+2;
        }
        
        //        calculateHeight = calculateHeight + 10 + (sContent.sharePicArr.count == 0 ? 0 : ((sContent.sharePicArr.count-1)/3 + 1) * (75 + 10)) + 10 + 26;
    }
    
    
    //    NSLog(@"index path %d,    %d",indexPath.row,calculateHeight);
    
    return calculateHeight;
    
}

#pragma mark 班级日志cell 代理
- (void)clickComment:(GKClassBlog *)content
{
   
    
//    if (user.can_comment == nil || [user.can_comment isEqualToString:@"0"]) // pinglun
//    {
//        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return;
//    }
//    
//    CommentDetailViewController *detailviewcontroller=[[CommentDetailViewController alloc]init];
//    detailviewcontroller.shareContent = content;
//    detailviewcontroller.shareContent.isMore = YES;
//    //    [self.navigationController pushViewController:detailviewcontroller animated:YES];
//    AppDelegate *appDel = SHARED_APP_DELEGATE;
//    [appDel.bottomNav pushViewController:detailviewcontroller animated:YES];
//    
//    [detailviewcontroller release];
}
- (void) shareCell:(ClassShareCell *)_notice share:(GKClassBlog *)info
{}

- (void) clickPraise:(UITableViewCell *)cell
{
    
//    UserLogin *user = [UserLogin currentLogin];
//    
//    if (user.can_comment_action == nil || [user.can_comment_action isEqualToString:@"0"]) // zan
//    {
//        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return;
//    }
    
    
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    
    GKClassBlog *sContent=[self.list objectAtIndex:indexpath.row];

    if([sContent.havezan integerValue]==0)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:sContent.shareId,@"itemid",@"article",@"itemtype", @"1",@"isup",nil];
        
        [[EKRequest Instance] EKHTTPRequest:comment parameters:dic requestMethod:POST forDelegate:self];
        
        // 没攒的情况下 操作
        
        // 没攒
    }
    else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"comment_action",@"type",sContent.havezan,@"key",nil];
        //取消赞.
        
        [[EKRequest Instance] EKHTTPRequest:deleteF parameters:dic requestMethod:POST forDelegate:self];
        
    }
        
  
    
}
- (void) didTapImageWithImagecontent:(GKClassBlog *)content
{
    
    NSDictionary *dic=[content.sharePicArr objectAtIndex:0];
    NSString * path = [dic objectForKey:@"source"];
    //NSURL *url = [NSURL URLWithString:path];

    
    GKShowBigImageViewController *show=[[GKShowBigImageViewController alloc]init];
    show.path=path;
    [self.navigationController presentViewController:show animated:YES completion:^{
        
    }];
    [show release];
}


-(void)playAudioStreamView:(ClassShareCell *)viewCell Info:(GKClassBlog *)info
{
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKClassBlog *_shareContent=[self.list objectAtIndex:indexPath.row];
    GKBlogDetailViewController *detailviewcontroller=[[GKBlogDetailViewController alloc]init];
    detailviewcontroller.shareContent = _shareContent;
//    detailviewcontroller.delegate=self;
//    detailviewcontroller.shareContent.isMore = YES;
    [self.navigationController pushViewController:detailviewcontroller animated:YES];
    [detailviewcontroller release];
    
    
  
   
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
    
    [self requestArticalData:param];
}
-(void)setFooterView
{
    
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        _refreshFooterView.hidden = NO;
        _refreshFooterView.frame = CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height);
    }
    else
    {
        LoadMoreTableFooterView *refreshFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        refreshFooterView.delegate = self;
        [_tableView addSubview:refreshFooterView];
        [refreshFooterView release];
        
        self._refreshFooterView = refreshFooterView;
        self._refreshFooterView.backgroundColor=[UIColor clearColor];
    }
    
}
-(void)removeFooterView
{
    //_refreshFooterView.hidden = YES;
    
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}



- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    
    GKClassBlog *sc = [self.list lastObject];
    NSString *lastTime = sc.publishtime;
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",nil];
    
    [self requestArticalData:param];
    isLoading=YES;
    
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self reloadTableViewDataSource:aRefreshPos];
}


- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return isLoading; // should return if data source model is reloading
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[super scrollViewDidEndDecelerating:scrollView];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"] || [[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"2"])
    {//如果设置自动播放
        
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlVisibleCellPlay) object:nil];
        [self performSelector:@selector(controlVisibleCellPlay) withObject:nil afterDelay:0.1f];
        
        
        
    }
}
//返回刷新时间的回调方法
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

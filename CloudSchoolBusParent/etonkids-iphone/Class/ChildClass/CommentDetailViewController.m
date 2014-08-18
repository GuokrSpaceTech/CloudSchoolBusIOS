//
//  CommentDetailViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-14.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "CommentDetailViewController.h"

#import "ETKids.h"
#import "NetWork.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "Modify.h"
#import "ETReplyViewController.h"
#import "ContentUpCell.h"
#import "ETCommonClass.h"
#import "NSDate+convenience.h"
#import "GKMovieManager.h"
#import "GKMovieCache.h"
#define BUTTONTAG  777
#define VIDEOTAG   8888
#define TAPIMAGETAG 111
@interface CommentDetailViewController ()

@end

@implementation CommentDetailViewController
@synthesize titilestring,
timestring,
connetstring,
havezanstring,
upnumnumber,
commentnumnumber,
Picstring,
tableview,
sImgArr,
PicArr,shareContent,comList,upList,upAI,cmtAI,movieBackView,radial,downloader,mPlayer;

@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChangeState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{

//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
//    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [super viewDidLoad];
    
    [ETCommonClass createHelpWithTag:1002 image:[UIImage imageNamed:iphone5 ? @"help_detail_568.png" : @"help_detail.png"]];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
      
//    middleView =[[UIImageView alloc]initWithFrame:CGRectZero];
//    [self.view addSubview:middleView];
//    middleView.hidden=YES;
//    [middleView release];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"body", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, self.view.bounds.size.height-NAVIHEIGHT-44 - (ios7 ? 20 : 0)) style:UITableViewStylePlain];
    tableview.scrollEnabled = YES;
    tableview.backgroundColor = CELLCOLOR;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    [tableview release];
    
    
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    contentView.backgroundColor = CELLCOLOR;
    
    CGSize size=[shareContent.shareTitle sizeWithFont:[UIFont systemFontOfSize:TITLEFONTSIZE] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 280, size.height)];
    labelTitle.backgroundColor=[UIColor clearColor];
    labelTitle.numberOfLines=0;
//    labelTitle.textColor = [UIColor colorWithRed:0 green:80/255.0f blue:146/255.0f alpha:1.0f];
    labelTitle.lineBreakMode=UILineBreakModeWordWrap;
    labelTitle.font=[UIFont systemFontOfSize:TITLEFONTSIZE];
    labelTitle.text=shareContent.shareTitle;
    [contentView addSubview:labelTitle];
    [labelTitle release];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    
    
    //calculate time
    
    NSString *time = shareContent.publishtime;
    
    int cDate = [[NSDate date] timeIntervalSince1970];
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    int sub = cDate - time.intValue;
    
    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,LOCAL(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60)
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),LOCAL(@"hoursago", @"")];
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
        timeLabel.text = dateStr;
    }

    
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:TIMEFONTSIZE];
    timeLabel.textColor = TIMETEXTCOLOR;
    timeLabel.textAlignment=UITextAlignmentLeft;
    [contentView addSubview:timeLabel];
    [timeLabel release];
    
    
    size=[shareContent.shareContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, labelTitle.frame.origin.y + labelTitle.frame.size.height + 5, 280, size.height)];
    contentLabel.numberOfLines=0;
    contentLabel.textColor = CONTENTTEXTCOLOR;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.lineBreakMode=UILineBreakModeWordWrap;
    contentLabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
    contentLabel.text=shareContent.shareContent;
    [contentView addSubview:contentLabel];
    [contentLabel release];
    
    
    
    float heightorign=contentLabel.frame.origin.y+contentLabel.frame.size.height;
    
    int row=[shareContent.tagArr count]/3;
    int col=[shareContent.tagArr count]%3;
   
    
    int num= ((col==0)?row:(row+1));
    
    for (int i=0; i<[shareContent.tagArr count]; i++) {
        
        NSDictionary *dic=[shareContent.tagArr objectAtIndex:i];
        int row=i/3;
        int col=i%3;
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
        btn.frame=CGRectMake(25 + col * (90 + 10), heightorign +5 + row *(20 +5) , 90, 20);
        [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+3210;
        
        //"systemLan"="cn";
        
        if([NSLocalizedString(@"systemLan", @"") isEqualToString:@"en"])
        {
            NSString *title=[dic objectForKey:@"tagname_en"];
            if([title isEqualToString:@""] || title==nil)
                title=[dic objectForKey:@"tagname"];
            [btn setTitle:title forState:UIControlStateNormal];
        }
        else
        {

            
            NSString *title=[dic objectForKey:@"tagname"];
            [btn setTitle:title forState:UIControlStateNormal];
        }
        
        [contentView addSubview:btn];
    }
    
    
    int originY=heightorign + 5 + num * 20 + (num-1)*5;
    NSDictionary *fDic = [shareContent.sharePicArr objectAtIndex:0];
    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
    //        NSString *source = @"http://yunxiaoche.blob.core.windows.net/article-source/39958_1389601724_644558.mp4";
    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
    
    
    if ([ext isEqualToString:@"mp4"])
    {
        UIView *ctntView = [[UIView alloc] initWithFrame:CGRectMake(10, originY+5, MOVIESIZE, MOVIESIZE)];
        ctntView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:ctntView];
        [ctntView release];
        
        self.movieBackView = ctntView;
        
        UIImageView *mthumbImgV = [[UIImageView alloc] initWithFrame:ctntView.bounds];
        mthumbImgV.backgroundColor = [UIColor whiteColor];
        [ctntView addSubview:mthumbImgV];
        [mthumbImgV release];
        [mthumbImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",source]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             mthumbImgV.image = image;
         }];
        
        
        MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
        newTheme.completedColor = [UIColor colorWithRed:45/255.0 green:117/255.0 blue:140/255.0 alpha:1.0];
        newTheme.incompletedColor = [UIColor colorWithRed:110/255.0 green:191/255.0 blue:210/255.0 alpha:1.0];
        newTheme.centerColor = [UIColor clearColor];
        newTheme.sliceDividerHidden = YES;
        newTheme.labelColor = [UIColor whiteColor];
        newTheme.labelShadowColor = [UIColor whiteColor];
        
        
        CGRect frame = CGRectMake(self.movieBackView.frame.size.width/2.0f - 30, self.movieBackView.frame.size.height/2.0f - 30, 70, 70);
        MDRadialProgressView *radialView7 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
        radialView7.hidden = YES;
        [self.movieBackView addSubview:radialView7];
        [radialView7 release];
        
        self.radial = radialView7;
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:nil];//写入url
        player.controlStyle = MPMovieControlStyleNone;
        player.movieSourceType = MPMovieSourceTypeFile;
        player.view.hidden = YES;
        [player.view setFrame:self.movieBackView.bounds];
        [self.movieBackView addSubview:player.view];
        self.mPlayer = player;
        
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:nil forState:UIControlStateNormal];
        btn.tag = BUTTONTAG;
        [btn addTarget:self action:@selector(controlMovie:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:self.movieBackView.bounds];
        [self.movieBackView addSubview:btn];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveMovie:)];
        [btn addGestureRecognizer:longPress];
        [longPress release];
        
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"] || [[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"2"])
        {//如果设置自动播放
            [self performSelector:@selector(downloadMovie:) withObject:source afterDelay:0.0f];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
        }
        
        
        
        timeLabel.frame = CGRectMake(30, originY + 10 + MOVIESIZE + 5, 100, 16);
        contentView.frame=CGRectMake(0, 0, 320, originY+10 +MOVIESIZE+5 + 16 );
        
    }
    else
    {
        if([shareContent.sharePicArr count]>1)
        {
            
            for (int i=0; i<[shareContent.sharePicArr count]; i++) {
                int row= i/3;
                int colom=i%3;
                NSDictionary * dic = [shareContent.sharePicArr objectAtIndex:i];
                NSString *path=[NSString stringWithFormat:@"%@.tiny.jpg",[dic objectForKey:@"source"]];
                UIImageView *imageViewPic=[[UIImageView alloc]initWithFrame:CGRectMake(40 + colom*(75+5), originY+5 + row *(75+5), 75, 75)];
                
                [imageViewPic setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"imageplaceholder.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                    if (error) {
                        imageViewPic.image = [UIImage imageNamed:@"imageerror.png"];
                    }else{
                        imageViewPic.image = image;
                    }
                    
                }];
                imageViewPic.tag = 5555+i;
                imageViewPic.backgroundColor=[UIColor clearColor];
                imageViewPic.userInteractionEnabled = YES;
                [contentView addSubview:imageViewPic];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
                [imageViewPic addGestureRecognizer:tap];
                [tap release];
                
            }
            int height=0;
            if([shareContent.sharePicArr count]<=3)
                height=75;
            else if([shareContent.sharePicArr count]<=6)
                height=75+5+75;
            else if([shareContent.sharePicArr count]<=9)
                height=75+5+75 + 5 + 75;
            
            timeLabel.frame = CGRectMake(30, originY + 10 + height + 5, 100, 16);
            
            contentView.frame=CGRectMake(0, 0, 320, originY+10 +height+5 + 16 );
        }
        else if ([shareContent.sharePicArr count] > 0 && [shareContent.sharePicArr count]<=1)
        {
            NSDictionary * dic = [shareContent.sharePicArr objectAtIndex:0];
            NSString *path=[NSString stringWithFormat:@"%@.small.jpg",[dic objectForKey:@"source"]];
            UIImageView *imageViewPic=[[UIImageView alloc]initWithFrame:CGRectMake(40 , originY+5, 150, 150)];
            
            [imageViewPic setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"imageplaceholder.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                if (error) {
                    imageViewPic.image = [UIImage imageNamed:@"imageerror.png"];
                }else{
                    imageViewPic.image = image;
                }
                
            }];
            imageViewPic.tag = 5555;
            imageViewPic.backgroundColor=[UIColor clearColor];
            imageViewPic.userInteractionEnabled = YES;
            [contentView addSubview:imageViewPic];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
            [imageViewPic addGestureRecognizer:tap];
            [tap release];
            
            timeLabel.frame = CGRectMake(30, originY + 10 + 150 + 5, 100, 16);
            
            contentView.frame=CGRectMake(0, 0, 320, originY+10 + 150 +5 + 16 );
            
        }
        else
        {
            timeLabel.frame = CGRectMake(30, originY + 10, 100, 16);
            contentView.frame=CGRectMake(0, 0, 320, originY+10 + 16);
        }
    }
    
    
    
    tableview.tableHeaderView=contentView;
    [contentView release];
    
    
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y + tableview.frame.size.height, 320, 44)];
    [self.view addSubview:bView];
    [bView release];
    
    UIImageView *bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bottomImgV.image = [UIImage imageNamed:@"bottomBack.png"];
    [bView addSubview:bottomImgV];
    [bottomImgV release];
    
    UIImageView *textImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 260, 30)];
    textImgV.image = [UIImage imageNamed:@"textBack.png"];
    [bView addSubview:textImgV];
    [textImgV release];
    
    upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setFrame:CGRectMake(320 - 10 - 35, 5, 35, 35)];
    if (self.shareContent.havezan.intValue == 0) {
        [upBtn setImage:[UIImage imageNamed:@"upBtn.png"] forState:UIControlStateNormal];
    }
    else
    {
        [upBtn setImage:[UIImage imageNamed:@"upBtnSel.png"] forState:UIControlStateNormal];
    }
    
    [upBtn addTarget:self action:@selector(doSendUp:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:upBtn];
    
    commentTF = [[UITextView alloc] initWithFrame:CGRectMake(5, 7, 260, 27)];
    commentTF.backgroundColor = [UIColor clearColor];
    commentTF.textColor = [UIColor grayColor];
    commentTF.font = [UIFont systemFontOfSize:14.0f];
    commentTF.showsVerticalScrollIndicator = NO;
    commentTF.delegate = self;
    commentTF.tag = 456;
    commentTF.text = LOCAL(@"CommentPlaceholder", @"");
    [bView addSubview:commentTF];
    [commentTF release];
    
    
    
    // ----------------  input view -------------
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    
    UIImageView *ipBottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    ipBottomImgV.image = [UIImage imageNamed:@"bottomBack.png"];
    ipBottomImgV.tag = 459;
    [inputView addSubview:ipBottomImgV];
    [ipBottomImgV release];
    
    UIImageView *ipTextImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 260, 34)];
    ipTextImgV.image = [UIImage imageNamed:@"textBack.png"];
    ipTextImgV.tag = 458;
    [inputView addSubview:ipTextImgV];
    [ipTextImgV release];
    
    UIButton *ipSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ipSendBtn setFrame:CGRectMake(320 - 53, 7, 50, 35)];
    [ipSendBtn setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [ipSendBtn setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [ipSendBtn addTarget:self action:@selector(doSendComment:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:ipSendBtn];
    
    UITextView *ipTF = [[UITextView alloc] initWithFrame:CGRectMake(5, 7, 260, 34)];
    ipTF.backgroundColor = [UIColor clearColor];
    ipTF.textColor = [UIColor grayColor];
    ipTF.font = [UIFont systemFontOfSize:14];
//    ipTF.showsVerticalScrollIndicator = NO;
    ipTF.delegate = self;
    ipTF.tag = 457;
    [inputView addSubview:ipTF];
    [ipTF release];
    
    
    commentTF.inputAccessoryView = inputView;
    
    
    [self loadData];
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    
    UserLogin *user = [UserLogin currentLogin];
    if (user.can_comment == nil && [user.can_comment isEqualToString:@"0"]) { // pinglun
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        btn.frame = commentTF.frame;
        [btn addTarget:self action:@selector(nofun:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:btn];
    }
    if (user.can_comment_action == nil && [user.can_comment_action isEqualToString:@"0"]) {     // zan
        [upBtn setImage:[UIImage imageNamed:@"upBtn_disable.png"] forState:UIControlStateNormal];
    }
    
    
    
}
- (void)nofun:(id)sender
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == commentTF) {
        UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
//        if ([commentTF.text isEqualToString:LOCAL(@"CommentPlaceholder", @"")]) {
//            t.text = @"";
//        }
        [t becomeFirstResponder];
        
        if (![self.view viewWithTag:1234]) {
            UIControl *c = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
            c.backgroundColor = [UIColor clearColor];
            c.tag = 1234;
            [c addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:c];
            [c release];
        }
        
        
    }
}
// 点击标签事件
-(void)tagClick:(UIButton *)btn
{
    int i=btn.tag-3210;
    
    NSDictionary *dic=[self.shareContent.tagArr objectAtIndex:i];
    
    NSString *tagdesc=[dic objectForKey:@"tagnamedesc"];
    if([NSLocalizedString(@"systemLan", @"") isEqualToString:@"en"])
    {
        tagdesc=[dic objectForKey:@"tagnamedesc_en"];
        if([tagdesc isEqualToString:@""] || tagdesc==nil)
            tagdesc=[dic objectForKey:@"tagnamedesc"];
      
    }
    else
    {
        tagdesc=[dic objectForKey:@"tagnamedesc"];
        
        
    }

    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:tagdesc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)endEdit:(id)sender
{
    UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
    commentTF.text = t.text;
    
    [t resignFirstResponder];
    [commentTF resignFirstResponder];
    [sender removeFromSuperview];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == commentTF) {
        if ([commentTF.text isEqualToString:@""]) {
            commentTF.text = LOCAL(@"CommentPlaceholder", @"");
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.tag == 457) { // input textview
//        float h = textView.font.lineHeight;
        
//        NSLog(@"%f,%f,%f",h,textView.font.lineHeight,textView.font.leading);
        NSLog(@"%f",textView.contentSize.height);
        if (textView.contentSize.height <= 34*2) {
//            [UIView animateWithDuration:0.1f animations:^{
                textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.contentSize.height);
                UIImageView *t = (UIImageView *)[commentTF.inputAccessoryView viewWithTag:458];
                t.frame = CGRectMake(t.frame.origin.x, t.frame.origin.y, t.frame.size.width, textView.contentSize.height);
                
                UIImageView *b = (UIImageView *)[commentTF.inputAccessoryView viewWithTag:459];
                b.frame = CGRectMake(b.frame.origin.x, b.frame.origin.y, b.frame.size.width, textView.contentSize.height + 15);
                
                commentTF.inputAccessoryView.frame = CGRectMake(textView.inputAccessoryView.frame.origin.x,
                                                               textView.inputAccessoryView.frame.origin.y,
                                     
                                                                textView.inputAccessoryView.frame.size.width,
                                                               textView.contentSize.height + 15);
                
//            }];
            
        }
        
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //    if ([text isEqualToString:@"\n"]) {
    //
    //        [textView resignFirstResponder];
    //
    //        return NO;
    //
    //    }
//    NSString * toString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    
//    if (textView.tag == 457)  //判断是否时我们想要限定的那个输入框
//    {
//        int length = [self textLength:toString];
//        
//        if (length > LIMIT_COMMENT) { //如果输入框内容大于70则弹出警告
//            
//            //            self.textview.text = [toString substringToIndex:70];
//            
//            ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//    }
    
    return YES;
}
- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        //        NSLog(@"%d",[character lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number+=2;
        }
        else
        {
            number++;
        }
    }
    return number;
}


- (void)doSendUp:(UIButton *)sender
{
    UserLogin *user = [UserLogin currentLogin];
    
    if (user.can_comment_action == nil || [user.can_comment_action isEqualToString:@"0"]) // zan
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        
        if([shareContent.havezan integerValue]==0)
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:shareContent.shareId,@"itemid",@"article",@"itemtype", @"1",@"isup",nil];
            
            [[EKRequest Instance] EKHTTPRequest:comment parameters:dic requestMethod:POST forDelegate:self];
            
            // 没攒的情况下 操作
            
            // 没攒
        }
        else
        {
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"comment_action",@"type",shareContent.havezan,@"key",nil];
            //取消赞.
            
            [[EKRequest Instance] EKHTTPRequest:delete parameters:dic requestMethod:POST forDelegate:self];
            
        }
        
    }];
    
    
//    UserLogin *user = [UserLogin currentLogin];
    if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
        upBtn.userInteractionEnabled = NO; //重置 防止点击多次
    }
    
    CABasicAnimation *an=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    an.duration =0.15;
    an.repeatCount = 1;
    an.autoreverses = YES;
    an.fromValue = [NSNumber numberWithFloat:0.8];
    an.toValue = [NSNumber numberWithFloat:1.2];
    [sender.layer addAnimation:an forKey:@"dfdf"];
}

- (void)doSendComment:(UIButton *)sender
{

    UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
    
    
    //stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
    
    NSString *str=[t.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([str isEqualToString:@""] )
    {
        NSLog(@"发送内容为空");
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"empty", @"发送内容为空") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    int length = [self textLength:t.text];
    if (length > LIMIT_COMMENT)
    {
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [t resignFirstResponder];
    [commentTF resignFirstResponder];
    
    
    if ([self.view viewWithTag:1234]) {
        //删除uicontrol
        [[self.view viewWithTag:1234] removeFromSuperview];
    }
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"article",@"itemtype",self.shareContent.shareId,@"itemid",t.text,@"content",nil];
        [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:POST forDelegate:self];
    }];
    
    
    
}


- (void)loadData
{
    if (self.upAI == nil) {
        UITableViewCell *c = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIActivityIndicatorView *up = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (c != nil) {
            
            CGPoint p = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].center;
            up.center = CGPointMake(p.x, p.y + 5) ;
            
        }
        else
        {
            up.center = CGPointMake(1000, 1000);
        }
        
        [tableview addSubview:up];
        [up release];
        
        self.upAI = up;
        
        
        
    }
    
    [self.upAI startAnimating];
    
    
    
    if (self.cmtAI == nil) {
        
        UITableViewCell *c = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        UIActivityIndicatorView *cmt = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (c != nil) {
            
//            CGPoint p = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].center;
            cmt.center = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].center;
            
        }
        else
        {
            cmt.center = CGPointMake(1000, 1000);
        }
        
        [tableview addSubview:cmt];
        [cmt release];
        
        self.cmtAI = cmt;
        
    }
    
    [self.cmtAI startAnimating];
    
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        
        NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"iszan",@"article",@"itemtype",self.shareContent.shareId,@"itemid", nil];
        [[EKRequest Instance] EKHTTPRequest:comment parameters:param1 requestMethod:GET forDelegate:self];
        
    }];
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.mPlayer && self.mPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self.mPlayer stop];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICELL" object:nil];//通知cell 更新下载进度
}
- (void)viewWillAppear:(BOOL)animated
{
   
}

/// 显示大图.
- (void)doTap:(UITapGestureRecognizer *)sender
{
    int target = sender.view.tag % 5555;
    
    ETShowBigImageViewController *showBigVC = [[ETShowBigImageViewController alloc] init];
    showBigVC.picArr = self.shareContent.sharePicArr;
    showBigVC.showNum = target;
    showBigVC.content=self.shareContent.shareContent;
    //[self presentModalViewController:showBigVC animated:YES];
    AppDelegate *aDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aDelegate.bottomNav presentModalViewController:showBigVC animated:YES];
    [showBigVC release];
}

-(void)requestFailedresult:(NSString *)str
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.upAI != nil) {
        UITableViewCell *c = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (c != nil) {
            CGPoint p = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].center;
            self.upAI.center = CGPointMake(p.x, p.y + 5) ;
        }
        
        
    }
    
    if (self.cmtAI != nil) {
        UITableViewCell *c = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (c != nil) {
            self.cmtAI.center = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].center;
        }
    }
}

#pragma mark ----   request delegate  --------

-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    
    UserLogin * user = [UserLogin currentLogin];
    
    if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
        upBtn.userInteractionEnabled = YES; //重置 防止点击多次
    }
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else if (method == comment) {
        
        if (code == 1) {
            
            NSString *isGet = [NSString stringWithFormat:@"%@",[param objectForKey:@"iszan"]];
            
            NSString *isup = [NSString stringWithFormat:@"%@",[param objectForKey:@"isup"]];
            
            NSString *sendCmt = [NSString stringWithFormat:@"%@",[param objectForKey:@"itemtype"]];
            NSString *replyCmt = [NSString stringWithFormat:@"%@",[param objectForKey:@"reply"]];
            
            NSArray *result =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            
            NSLog(@"%@", result);
            
            if ([isGet isEqualToString:@"0"]) {
                // 评论列表.
                [cmtAI stopAnimating];
                self.comList = [NSMutableArray arrayWithArray:result];
                
//                self.shareContent.commentnum = [NSNumber numberWithInt:self.comList.count];
                
                
                                
            }
            else if ([isGet isEqualToString:@"1"]) {
                // 赞列表.
                
                [upAI stopAnimating];
                self.upList = [NSMutableArray arrayWithArray:result];
                
                self.shareContent.upnum = [NSNumber numberWithInt:self.upList.count];
                
//                NSLog(@"%@",self.upList);
                
                //获取评论列表
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"iszan",@"article",@"itemtype",self.shareContent.shareId,@"itemid", nil];
                [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:GET forDelegate:self];
                
                
            }
            else if ([isup isEqualToString:@"1"]) {
                // 点击赞.
                
                NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                
                self.shareContent.havezan = [NSNumber numberWithInt:[str integerValue]];
                [upBtn setImage:[UIImage imageNamed:@"upBtnSel.png"] forState:UIControlStateNormal];
                
                [self loadData];
                
                [ETCoreDataManager updateArticalData:self.shareContent ById:self.shareContent.shareId];
                
            }
            else if ([sendCmt isEqualToString:@"article"] && [replyCmt isEqualToString:@"(null)"])
            {
                // 发送评论.
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue + 1];
                [ETCoreDataManager updateArticalData:self.shareContent ById:self.shareContent.shareId];
                
//                UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
////                if ([commentTF.text isEqualToString:LOCAL(@"CommentPlaceholder", @"")]) {
//                    t.text = @"";
////                }

                
                //刷新数据.
                
                UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
                t.text = @"";
                [t resignFirstResponder];
                [commentTF resignFirstResponder];
                
                commentTF.text = LOCAL(@"CommentPlaceholder", @"");
                commentTF.textColor = [UIColor grayColor];
                
                
                [self loadData];
                
            }
            else if ([sendCmt isEqualToString:@"article"] && ![replyCmt isEqualToString:@"(null)"])
            {
                // 回复评论.
                
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue + 1];
                [ETCoreDataManager updateArticalData:self.shareContent ById:self.shareContent.shareId];
                
                ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"replySuccess", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
                [self loadData];
            }
            
            
            
            
            
            
        }
        else if (code == -3)
        {
            
            NSArray *result =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];

            NSString *isGet = [NSString stringWithFormat:@"%@",[param objectForKey:@"iszan"]];
            
            NSString *isup = [NSString stringWithFormat:@"%@",[param objectForKey:@"isup"]];
            
            if ([isGet isEqualToString:@"0"]) {
                // 评论列表.
                [cmtAI stopAnimating];
                self.comList = [NSMutableArray arrayWithArray:result];
                
                
            }
            else if ([isGet isEqualToString:@"1"]) {
                // 赞列表.
               
                [upAI stopAnimating];
                
                self.upList = [NSMutableArray arrayWithArray:result];
                
                //获取评论列表
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"iszan",@"article",@"itemtype",self.shareContent.shareId,@"itemid", nil];
                [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:GET forDelegate:self];
                
            }
            else if ([isup isEqualToString:@"1"]) {
                
                
                
            }
        }
        else
        {
            NSString *isGet = [NSString stringWithFormat:@"%@",[param objectForKey:@"iszan"]];
            
            NSString *isup = [NSString stringWithFormat:@"%@",[param objectForKey:@"isup"]];
            
            if ([isGet isEqualToString:@"0"]) {
                // 评论列表.
                [cmtAI stopAnimating];
                
                
                
            }
            else if ([isGet isEqualToString:@"1"]) {
                // 赞列表.

                [upAI stopAnimating];
                [cmtAI stopAnimating];
                
            }
            else if ([isup isEqualToString:@"1"]) {

                // 点击赞.
                
            }
            
            [self performSelectorOnMainThread:@selector(requestFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
            // 提示错误信息.
            
        }
        
        [tableview reloadData];
        
        
    }
    else if(method==delete)
    {
        if (code == 1) {
            
            NSString *isDelUp = [NSString stringWithFormat:@"%@",[param objectForKey:@"type"]];
            
            if ([isDelUp isEqualToString:@"comment"]) {
                //删除评论.
                [self.comList removeObjectAtIndex:deleteRow - 1];
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue - 1];
                [self.tableview reloadData];
                
                ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"deleteSuccess", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([isDelUp isEqualToString:@"comment_action"])
            {
                
                [self loadData];
                
                //取消赞.
                self.shareContent.upnum = [NSNumber numberWithInt:self.shareContent.upnum.intValue - 1];
                self.shareContent.havezan = [NSNumber numberWithInt:0];
                [upBtn setImage:[UIImage imageNamed:@"upBtn.png"] forState:UIControlStateNormal];
                
                
            }
            [ETCoreDataManager updateArticalData:self.shareContent ById:self.shareContent.shareId];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(requestFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
        }
        
    }
    
    
}

-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction)method
{
    [self performSelectorOnMainThread:@selector(requestFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
    [upAI stopAnimating];
    [cmtAI stopAnimating];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.comList.count == 0) {
        return 2;
    }
    return self.comList.count + 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.upList.count <= HEADMAXCOUNT)
        {
            return 55;
        }
        else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.upList objectAtIndex:0]];
            NSMutableString *names = [NSMutableString stringWithString:[dic objectForKey:@"nickname"]];
            
            for (int i = 1; i < self.upList.count; i++)
            {
                NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:[self.upList objectAtIndex:i]];
                [names appendFormat:@",%@",[dic1 objectForKey:@"nickname"]];
            }
            
            CGSize size = [names sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
            return MAX(55, size.height + 25 + 5);
        }
        
    }
    
//    NSLog(@"%@",self.comList);
    
    if (!self.comList || self.comList.count == 0) {
        return 45;
    }
    
    NSDictionary *dic = [self.comList objectAtIndex:indexPath.row - 1];
    NSString *replyName = [dic objectForKey:@"replynickname"];
    NSString *content;
    if (replyName != nil && ![replyName isKindOfClass:[NSNull class]])
    {
        content = [NSString stringWithFormat:@"回复 %@：%@",replyName,[dic objectForKey:@"content"]];
    }
    else
    {
        content = [dic objectForKey:@"content"];
    }
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return MAX(size.height + 28,45);
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier1 = @"up";
        ContentUpCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell==nil)
        {
            cell = [[[ContentUpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//            cell.contentView.backgroundColor = [UIColor cyanColor];
        }
        
//        NSLog(@"$$$$ %@",self.upList);
        
        if (!self.upList || self.upList.count == 0)
        {
            for (UIImageView *obj in cell.contentView.subviews) {
                if (obj.tag >= 222 && obj.tag < 222 + HEADMAXCOUNT)
                {
                    obj.frame = CGRectZero;
                }
            }
            cell.nameLab.frame = CGRectMake(DETAILLEFTMARGIN, 22, 250, 20);
            if (self.upList != nil) {
                cell.nameLab.text = LOCAL(@"likenumber0", @"");
            }
            
            
        }
        else if (self.upList.count > 0 && self.upList.count <= HEADMAXCOUNT)
        {
            for (UIImageView *obj in cell.contentView.subviews) {
                if (obj.tag >= 222 && obj.tag < 222 + self.upList.count)
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.upList objectAtIndex:obj.tag%222]];
                    
//                    NSLog(@"%d %@",obj.tag , dic);
                    if (dic != nil) {
                        NSString *url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
                        if (url.length > 6) {
                            [obj setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"headplaceholder_small.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                obj.image = image;
                            }];
                        }
                        else
                        {
                            obj.image = [UIImage imageNamed:@"headplaceholder_small.png"];
                        }
                        
                        int i = obj.tag%222;
                        obj.frame = CGRectMake(DETAILLEFTMARGIN + i * 35, 13 + 5, 30, 30);
                    }
                    
                
                }
                else if (obj.tag >= 222 + self.upList.count && obj.tag < 222 + HEADMAXCOUNT)
                {
                    obj.frame = CGRectZero;
                }
            }
            
            cell.nameLab.frame = CGRectZero;
        }
        else if (self.upList.count > HEADMAXCOUNT)
        {
            for (UIView *obj in cell.subviews) {
                if (obj.tag >= 222 && obj.tag < 222 + HEADMAXCOUNT) {
                    obj.frame = CGRectZero;
                }
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.upList objectAtIndex:0]];
            NSMutableString *names = [NSMutableString stringWithString:[dic objectForKey:@"nickname"]];
        
            for (int i = 1; i < self.upList.count; i++)
            {
                NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:[self.upList objectAtIndex:i]];
                [names appendFormat:@",%@",[dic1 objectForKey:@"nickname"]];

            }
            
            CGSize size = [names sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            cell.nameLab.frame = CGRectMake(DETAILLEFTMARGIN, 20 + 5, size.width, size.height);
            cell.nameLab.text = names;
            cell.bView.frame = CGRectMake(cell.bView.frame.origin.x,
                                          cell.bView.frame.origin.y,
                                          cell.bView.frame.size.width,
                                          MAX(45, size.height + 25 + 5 - 10));
        
            cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x,
                                             MAX(size.height + 25 + 5 - 1, 54),
                                             cell.lineView.frame.size.width,
                                             cell.lineView.frame.size.height);

        }
        
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"comment";
        DetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell=[[[DetailContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        
        if (!self.comList || self.comList.count == 0) {
            cell.titleLabel.text = @"";
            cell.headImgV.hidden = YES;
            cell.contentLabel.text = @"";
            cell.timeLabel.text = @"";
            cell.bView.frame = CGRectMake(cell.bView.frame.origin.x,
                                          cell.bView.frame.origin.y,
                                          cell.bView.frame.size.width,
                                          45);
            
            if (self.comList != nil) {
                cell.contentLabel.text = LOCAL(@"commentnumber0", @"");
                cell.contentLabel.frame = CGRectMake(DETAILLEFTMARGIN, 12, 250, 20);
            }
            
            return cell;
        }
        
        NSDictionary *dic = [self.comList objectAtIndex:indexPath.row - 1];
        
        if (indexPath.row == 1)
        {
            cell.comImgV.hidden = NO;
        }
        else
        {
            cell.comImgV.hidden = YES;
        }
            
        NSString *replyName = [dic objectForKey:@"replynickname"];
        NSString *isStudent = [dic objectForKey:@"isstudent"];
        NSString *head = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        NSString *time = [dic objectForKey:@"addtime"];
        
//        int a = [[NSDate date] timeIntervalSince1970];
//        
//        NSString *time = [NSString stringWithFormat:@"%d",a - 4];
        
        if ([isStudent isEqualToString:@"0"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@老师", [dic objectForKey:@"nickname"]];
        }else if ([isStudent isEqualToString:@"1"]){
            cell.titleLabel.text = [NSString stringWithFormat:@"%@的家长", [dic objectForKey:@"nickname"]];
        }
            
            
            
        NSString *content;
        if (replyName != nil && ![replyName isKindOfClass:[NSNull class]])
        {
            content = [NSString stringWithFormat:@"回复 %@：%@",replyName,[dic objectForKey:@"content"]];
        }
        else
        {
            content = [dic objectForKey:@"content"];
        }
        
        if (head != nil && ![head isKindOfClass:[NSNull class]]) {
            cell.headImgV.hidden = NO;
            
            if (head.length > 6) {
                [cell.headImgV setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"headplaceholder_small.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    cell.headImgV.image = image;
                }];
            }
            else
            {
                cell.headImgV.image = [UIImage imageNamed:@"headplaceholder_small.png"];
            }
            
            
        }else{
            cell.headImgV.hidden = YES;
        }
            
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
        cell.contentLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x , cell.titleLabel.frame.origin.y + cell.titleLabel.frame.size.height + 3, size.width, size.height);
            
        cell.contentLabel.text = content;
        cell.delegate = self;
        
        //calculate time
        
        int cDate = [[NSDate date] timeIntervalSince1970];
        NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
        int sub = cDate - time.intValue;
        
        NSString *dateStr;
//        NSLog(@"$$$$$$$$$  %d",sub);
        if (sub < 60*60)//小于一小时
        {
            dateStr = [NSString stringWithFormat:@"%d %@",sub/60 <= 0 ? 1 : sub/60,LOCAL(@"minutesago", @"")];
        }
        else if (sub < 12*60*60 && sub >= 60*60)
        {
            dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),LOCAL(@"hoursago", @"")];
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
        
        
        cell.bView.frame = CGRectMake(cell.bView.frame.origin.x,
                                      cell.bView.frame.origin.y,
                                      cell.bView.frame.size.width,
                                      MAX(size.height + 28,45));
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x,
                                         MAX(size.height + 27,44),
                                         cell.lineView.frame.size.width,
                                         cell.lineView.frame.size.height);
        
    
        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 || self.comList.count == 0) {
        return;
    }
    
    NSDictionary *dic = [self.comList objectAtIndex:indexPath.row - 1];

    NSString *isStudent = [dic objectForKey:@"isstudent"];
    NSString *senderId = [dic objectForKey:@"adduserid"];
    currentComId = [dic objectForKey:@"commentid"];

    UserLogin *user = [UserLogin currentLogin];

   
    if (isStudent && [senderId isEqualToString:user.studentId]) {

        MTCustomActionSheet *action = [[MTCustomActionSheet alloc] initWithTitle:LOCAL(@"alert", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"delete", @""), nil];
        action.tag = 333 + indexPath.row;
        [action showInView:self.view];
        [action release];
        
    }
    else
    {
        MTCustomActionSheet *action = [[MTCustomActionSheet alloc] initWithTitle:LOCAL(@"alert", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"replyComment", @""), nil];
        action.tag = 4444;
        [action showInView:self.view];
        [action release];
    }
    
}

- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    if (actionSheet.tag >= 333 && actionSheet.tag < 4444)
    {
        if (index == 0)
        {
            [self deleteCommentById:currentComId withRow:actionSheet.tag%333];
        }
        
        
    }
    else if (actionSheet.tag == 4444)
    {
        if (index == 0)
        {
            [self replyCommentByCommentId:currentComId];
        }
    }
    else if (actionSheet.tag == VIDEOTAG)
    {
        if (index == 0)
        {
            
            NSDictionary *fDic = [shareContent.sharePicArr objectAtIndex:0];
            NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
            if ([GKMovieCache isContainMovieByURL:source]) {
                
                NSLog(@"保存视频");
                NSString *p = [self.mPlayer.contentURL path];
                //        UISaveVideoAtPathToSavedPhotosAlbum(p, nil, nil, nil);
                UISaveVideoAtPathToSavedPhotosAlbum(p, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                //        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(p);
            }
            else
            {
                //        NSLog(@"no download");
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"nofinished", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
    }
}


/// 点击回复评论 回调.

//- (void)didClickComments:(DetailContentCell *)cell
//{
//    NSIndexPath *index = [tableview indexPathForCell:cell];
//    
//    NSDictionary *dic = [self.dataList objectAtIndex:index.row];
//    NSString *commentId = [dic objectForKey:@"commentid"];
//    
//    [self replyCommentByCommentId:commentId];
//    
//    
//    
//}


/**
 *	@brief  弹出回复评论.
 *
 *	@param 	comId 	要回复评论的id.
 */
- (void)replyCommentByCommentId:(NSString *)comId
{
    WriteCommentsViewController *wtritecommnet=[[WriteCommentsViewController alloc]init];
    wtritecommnet.delegate = self;
    wtritecommnet.itemid=self.shareContent.shareId;
    wtritecommnet.commentId = comId;
    [self.navigationController pushViewController:wtritecommnet animated:YES];
    [wtritecommnet release];
}

- (void)replyCommentByParam:(NSDictionary *)param
{
//    NSDictionary *paramDic = [[NSDictionary alloc] initWithDictionary:param];
    
//    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
//    [com requestLoginWithComplete:^(NSError *err){
        [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:POST forDelegate:self];
//    }];

}



/**
 *	@brief  删除指定评论.
 *
 *	@param 	comId 	删除评论的id.
 *	@param 	row 	删除评论的行号.
 */
- (void)deleteCommentById:(NSString *)comId withRow:(int)row

{
    deleteRow = row;

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"comment",@"type",comId,@"key", nil];
    [[EKRequest Instance]EKHTTPRequest:delete parameters:dic requestMethod:POST forDelegate:self];
}



-(void)leftButtonClick:(UIButton*)Sender
{
    if(delegate&& [delegate respondsToSelector:@selector(setisVisiblebecomeYES)])
    {
        [delegate setisVisiblebecomeYES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)downloadMovie:(NSString *)url
{
//    GKMovieManager *man = [GKMovieManager shareManager];
//    if ([man downloadListContainsURL:url])
//    {
//        return;
//    }
    
    
    [[GKMovieManager shareManager] downloadMovieWithURL:url progress:^(unsigned long long size, unsigned long long total, NSString *downloadingPath)
    {
        self.radial.hidden = NO;
        self.radial.progressCounter = size;
        self.radial.progressTotal = total;
         
    }
    complete:^(NSString *path, NSError *error)
    {
        UIButton *b = (UIButton *)[self.movieBackView viewWithTag:BUTTONTAG];
        [b setImage:nil forState:UIControlStateNormal];
        self.mPlayer.view.hidden = NO;
        self.radial.hidden = YES;
        self.mPlayer.contentURL = [NSURL fileURLWithPath:path];
        [self.mPlayer play];

    }];
    
}


- (void)playbackChangeState:(MPMediaPickerController *)player
{
    UIButton *b = (UIButton *)[self.movieBackView viewWithTag:BUTTONTAG];
    
    if (self.mPlayer.playbackState == MPMoviePlaybackStatePaused || self.mPlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [b setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
    }
    else
    {
        [b setImage:nil forState:UIControlStateNormal];
        self.mPlayer.view.hidden = NO;
    }
}
- (void)controlMovie:(UIButton *)sender
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"0"] && !self.mPlayer.contentURL)
    {
        NSDictionary *fDic = [shareContent.sharePicArr objectAtIndex:0];
        NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
        [self performSelector:@selector(downloadMovie:) withObject:source afterDelay:0.0f];
    }
    
    
    
    if (self.mPlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self.mPlayer pause];
        [sender setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.mPlayer play];
        [sender setImage:nil forState:UIControlStateNormal];
    }
}

- (void)saveMovie:(UIGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        MTCustomActionSheet *action = [[MTCustomActionSheet alloc] initWithTitle:LOCAL(@"alert", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"baocunshipin", @""), nil];
        action.tag = VIDEOTAG;
        [action showInView:self.view];
        [action release];
    }
    
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    NSLog(@"%@",videoPath);
    
    NSLog(@"%@",error);
    
    NSString *info;
    
    if (error) {
        info = @"保存失败";
        if(error.code==-3310)
        {
            info=NSLocalizedString(@"privacy", @"");
        }
        
    }
    else
    {
        info = @"保存成功";
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    self.shareContent = nil;
    self.comList = nil;
    self.upList = nil;
    self.cmtAI = nil;
    self.upAI = nil;
    self.movieBackView = nil;
    self.radial = nil;
    self.downloader = nil;
    self.mPlayer = nil;
    
    self.titilestring=nil;
    self.timestring=nil;
    self.connetstring=nil;
    self.havezanstring=nil;
    self.upnumnumber=nil;
    self.commentnumnumber=nil;
    self.Picstring=nil;
    self.PicArr=nil;
    [super dealloc];
}



- (BOOL)shouldAutorotate
{
    return NO;
}


@end

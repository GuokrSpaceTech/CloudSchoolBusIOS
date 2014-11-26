//
//  GKBlogDetailViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKBlogDetailViewController.h"
#import "KKNavigationController.h"
#import "NSDate+convenience.h"
#import "UIImageView+WebCache.h"
#import "GKMovieManager.h"
#import "GKMovieCache.h"
#import "GKCommentObject.h"
#import "GKLikeObject.h"
#import "GKUserLogin.h"
#define VIDEOTAG   8888
#define BUTTONTAG  777
@interface GKBlogDetailViewController ()

@end

@implementation GKBlogDetailViewController
@synthesize tableview;
@synthesize shareContent;
@synthesize movieBackView;
@synthesize radial;
@synthesize mPlayer;
@synthesize list;
@synthesize currentComId;
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChangeState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
   
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y-44 ) style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableview];
    titlelabel.text=@"详情";
    
    
    list=[[NSMutableArray alloc]init];
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    contentView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
    CGSize size=[shareContent.shareTitle sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 280, size.height)];
    labelTitle.backgroundColor=[UIColor clearColor];
    labelTitle.numberOfLines=0;
    labelTitle.lineBreakMode=UILineBreakModeWordWrap;
    labelTitle.font=[UIFont systemFontOfSize:16];
    labelTitle.text=shareContent.shareTitle;
    [contentView addSubview:labelTitle];
    [labelTitle release];
    NSString *time = shareContent.publishtime;
    NSString *timeStr=[self timeConvert:time];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:12];
    timeLabel.text=timeStr;
    timeLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0f];
    timeLabel.textAlignment=UITextAlignmentLeft;
    [contentView addSubview:timeLabel];
    [timeLabel release];
    size=[shareContent.shareContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, labelTitle.frame.origin.y + labelTitle.frame.size.height + 5, 280, size.height)];
    contentLabel.numberOfLines=0;
    contentLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
    contentLabel.font=[UIFont systemFontOfSize:15];
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

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
        btn.frame=CGRectMake(25 + col * (90 + 10), heightorign +5 + row *(20 +5) , 90, 20);
        [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+3210;
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
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
    int originY=heightorign + 5 + num * 20 + (num-1)*5 +5;
    NSDictionary *fDic = [shareContent.sharePicArr objectAtIndex:0];
    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
     NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
    if ([ext isEqualToString:@"mp4"])
    {
        UIView *ctntView = [[UIView alloc] initWithFrame:CGRectMake(10, originY+5, 300, 300)];
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
        [btn setImage:[UIImage imageNamed:@"movieplay.png"] forState:UIControlStateNormal];
        timeLabel.frame = CGRectMake(30, originY + 10 + 300 + 5, 100, 16);
        contentView.frame=CGRectMake(0, 0, 320, originY+10 +300+5 + 16 );
        
    }
    else
    {
        if ([shareContent.sharePicArr count] ==1 )
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
    
    
    
    btnPinglun=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPinglun.frame=CGRectMake(self.view.frame.size.width-100, timeLabel.frame.origin.y-5, 24, 19);
    [btnPinglun setBackgroundImage:[UIImage imageNamed:@"cellComment.png"] forState:UIControlStateNormal];
   // [btnPinglun setBackgroundImage:[UIImage imageNamed:@"cellComment_disable.png"] forState:UIControlStateHighlighted];
   // [btnPinglun setBackgroundImage:[UIImage imageNamed:@"cellComment_disable.png"] forState:UIControlStateSelected];
    [btnPinglun addTarget:self action:@selector(pinglunLoad:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnPinglun];
    
    
    btnZan=[UIButton buttonWithType:UIButtonTypeCustom];
    btnZan.frame=CGRectMake(self.view.frame.size.width-100+40, timeLabel.frame.origin.y-5, 24, 19);
    [btnZan setBackgroundImage:[UIImage imageNamed:@"cellPraise.png"] forState:UIControlStateNormal];
    [btnZan addTarget:self action:@selector(zanLoad:) forControlEvents:UIControlEventTouchUpInside];
  //  [btnZan setBackgroundImage:[UIImage imageNamed:@"cellPraise_disable.png"] forState:UIControlStateSelected];
    [btnZan setBackgroundImage:[UIImage imageNamed:@"cellPraise_disable.png"] forState:UIControlStateNormal];
 
    [contentView addSubview:btnZan];
    
    [self initInputView];
    

    [self loadCommentList];
}

-(void)pinglunLoad:(UIButton *)btn
{
    [btnPinglun setBackgroundImage:[UIImage imageNamed:@"cellComment.png"] forState:UIControlStateNormal];
    [btnZan setBackgroundImage:[UIImage imageNamed:@"cellPraise_disable.png"] forState:UIControlStateNormal];
    
    [self loadCommentList];
}
-(void)zanLoad:(UIButton *)btn
{
    [btnPinglun setBackgroundImage:[UIImage imageNamed:@"cellComment_disable.png"] forState:UIControlStateNormal];
    [btnZan setBackgroundImage:[UIImage imageNamed:@"cellPraise.png"] forState:UIControlStateNormal];
    
    [self loadData];
}
- (void)loadData
{
    
    // 赞列表
    NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"iszan",@"article",@"itemtype",self.shareContent.shareId,@"itemid", nil];
    [[EKRequest Instance] EKHTTPRequest:comment parameters:param1 requestMethod:GET forDelegate:self];
    
}
-(void)loadCommentList
{
    //获得评论列表
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"iszan",@"article",@"itemtype",self.shareContent.shareId,@"itemid", nil];
    [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:GET forDelegate:self];
}
-(void)initInputView
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y + tableview.frame.size.height, self.view.frame.size.width, 44)];
    bView.backgroundColor=[UIColor redColor];
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
    commentTF.text = @"评论";
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
}
- (void)doSendUp:(UIButton *)sender
{


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
            
            [[EKRequest Instance] EKHTTPRequest:deleteF parameters:dic requestMethod:POST forDelegate:self];
            
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
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    int length = [self textLength:t.text];
    if (length > 70)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"内容过长" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

        return;
    }
    
    
    [t resignFirstResponder];
    [commentTF resignFirstResponder];
    
    
    if ([self.view viewWithTag:1234]) {
        //删除uicontrol
        [[self.view viewWithTag:1234] removeFromSuperview];
    }
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"article",@"itemtype",self.shareContent.shareId,@"itemid",t.text,@"content",nil];
    [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:POST forDelegate:self];
    
    
    
    
}

-(void)tagClick:(UIButton *)btn
{
    int i=btn.tag-3210;
    
    NSDictionary *dic=[self.shareContent.tagArr objectAtIndex:i];
    
    NSString *tagdesc=[dic objectForKey:@"tagnamedesc"];
    NSString *tagname=[dic objectForKey:@"tagname"];
    
    
    
    if([NSLocalizedString(@"systemLan", @"") isEqualToString:@"en"])
    {
        tagdesc=[dic objectForKey:@"tagnamedesc_en"];
        tagname=[dic objectForKey:@"tagname_en"];
        if([tagdesc isEqualToString:@""] || tagdesc==nil)
            tagdesc=[dic objectForKey:@"tagnamedesc"];
        
        if([tagname isEqualToString:@""] || tagname==nil)
            tagname=[dic objectForKey:@"tagname"];
        
    }
    else
    {
        tagdesc=[dic objectForKey:@"tagnamedesc"];
        
        tagname=[dic objectForKey:@"tagname"];
    }
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:tagname message:tagdesc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
 
    NSString *info;
    
    if (error) {
        info = @"保存失败";
        if(error.code==-3310)
        {
            info=@"无法保存到相册，请打开设备\"设置\"--\"隐私\"--\"照片\"，开启\"教师助手\"访问权限。";
        }
        
    }
    else
    {
        info = @"保存成功";
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];

    
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    upBtn.userInteractionEnabled = YES;
    if(method==comment)
    {
        if(code==1)
        {
            NSString *isGet = [NSString stringWithFormat:@"%@",[parm objectForKey:@"iszan"]];
            
            NSString *isup = [NSString stringWithFormat:@"%@",[parm objectForKey:@"isup"]];
            
            NSString *sendCmt = [NSString stringWithFormat:@"%@",[parm objectForKey:@"itemtype"]];
            NSArray *result =[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            

            NSLog(@"%@",result);
            
            if ([isGet isEqualToString:@"0"]) {
                // 评论列表.
                [list removeAllObjects];
                //self.comList = [NSMutableArray arrayWithArray:result];
                for (int i=0; i<[result count]; i++) {
                    NSDictionary *dic=[result objectAtIndex:i];
                    GKCommentObject *comment=[[GKCommentObject alloc]init];
                    comment.addtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                    comment.adduserid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adduserid"]];
                    comment.isstudent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isstudent"]];
                    comment.commentid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentid"]];
                    comment.content=[dic objectForKey:@"content"];
                    comment.nickname=[dic objectForKey:@"nickname"];
                    comment.avatar=[dic objectForKey:@"avatar"];
                    comment.replynickname=[dic objectForKey:@"replynickname"];
                    [list addObject:comment];
                    [comment release];
                    
                }
                
            }
            else if([isGet isEqualToString:@"1"])
            {
                [list removeAllObjects];
                //self.upList = [NSMutableArray arrayWithArray:result];
              //  self.shareContent.upnum = [NSNumber numberWithInt:self.upList.count];
                for (int i=0; i<[result count]; i++) {
                    NSDictionary *dic=[result objectAtIndex:i];
                    GKLikeObject *like=[[GKLikeObject alloc]init];
                    like.addtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                    like.adduserid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adduserid"]];
                    like.isstudent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isstudent"]];
                    like.actionid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"actionid"]];
                    like.avatar=[dic objectForKey:@"avatar"];
                    like.nickname=[dic objectForKey:@"nickname"];
      
                    [list addObject:like];
                    [like release];
                    
                }

          
            }
            else if([isup isEqualToString:@"1"])
            {
                NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                
                self.shareContent.havezan = [NSNumber numberWithInt:[str integerValue]];
                [str release];
                [upBtn setImage:[UIImage imageNamed:@"upBtnSel.png"] forState:UIControlStateNormal];
                
                //[self loadData];
                
            }
            else if([sendCmt isEqualToString:@"article"] && ![[parm allKeys]containsObject:@"reply"])
            {
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue + 1];
                
                UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
                t.text = @"";
                [t resignFirstResponder];
                [commentTF resignFirstResponder];
                
                commentTF.text = @"评论";
                commentTF.textColor = [UIColor grayColor];
                
                
                [self loadCommentList];
                
            }
            else if([sendCmt isEqualToString:@"article"] && [[parm allKeys]containsObject:@"reply"])
            {
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue + 1];
             
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"回复成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
                [self loadCommentList];

            }
            
        }

        [tableview reloadData];
    }
    else if(method==deleteF)
    {
        if (code == 1) {
            
            NSString *isDelUp = [NSString stringWithFormat:@"%@",[parm objectForKey:@"type"]];
            
            if ([isDelUp isEqualToString:@"comment"]) {
                //删除评论.
                //[self.comList removeObjectAtIndex:deleteRow - 1];
                self.shareContent.commentnum = [NSNumber numberWithInt:self.shareContent.commentnum.intValue - 1];
                //[self.tableview reloadData];
                [self loadCommentList];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
                
            }
            else if ([isDelUp isEqualToString:@"comment_action"])
            {
                
                [self loadData];
                
                //取消赞.
                self.shareContent.upnum = [NSNumber numberWithInt:self.shareContent.upnum.intValue - 1];
                self.shareContent.havezan = [NSNumber numberWithInt:0];
                [upBtn setImage:[UIImage imageNamed:@"upBtn.png"] forState:UIControlStateNormal];
                
                
            }
            
        }
     
        
    }

}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==VIDEOTAG)
    {
        if(buttonIndex==0)
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
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"视频缓冲中，请稍后进行保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
           
            }
        }
    }
    else if (actionSheet.tag >= 333 && actionSheet.tag < 4444)
    {
        if (buttonIndex == 0)
        {
            [self deleteCommentById:currentComId withRow:actionSheet.tag%333];
        }
        
        
    }
    else if (actionSheet.tag == 4444)
    {
        if (buttonIndex == 0)
        {
            [self replyCommentByCommentId:currentComId];
        }
    }
}
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
    [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:POST forDelegate:self];
}


- (void)deleteCommentById:(NSString *)comId withRow:(int)row

{
    deleteRow = row;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"comment",@"type",comId,@"key", nil];
    [[EKRequest Instance]EKHTTPRequest:deleteF parameters:dic requestMethod:POST forDelegate:self];
}
- (void)saveMovie:(UIGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存视频", nil];
        action.tag=VIDEOTAG;
        [action showInView:self.view];
        [action release];
        
//         *action = [[MTCustomActionSheet alloc] initWithTitle:LOCAL(@"alert", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"baocunshipin", @""), nil];
//        action.tag = VIDEOTAG;
//        [action showInView:self.view];
//        [action release];
    }
    
    
}
- (void)downloadMovie:(NSString *)url
{
    
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
- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
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
            commentTF.text =@"评论";
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == commentTF) {
        UITextView *t = (UITextView *)[commentTF.inputAccessoryView viewWithTag:457];
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.tag == 457) { // input textview
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

            
        }
        
    }
    
}
- (void)controlMovie:(UIButton *)sender
{
    if  (!self.mPlayer.contentURL)
    {
        NSDictionary *fDic = [shareContent.sharePicArr objectAtIndex:0];
        NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
        [self performSelector:@selector(downloadMovie:) withObject:source afterDelay:0.0f];
        
        return;
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
-(NSString *)timeConvert:(NSString *)time
{
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
    
    return dateStr;

}
- (void)playbackChangeState:(MPMediaPickerController *)player
{
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cell";
    UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:cellidentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier] autorelease];
        cell.backgroundColor=[UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
        UIImageView *photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        photoImageView.backgroundColor=[UIColor clearColor];
        photoImageView.tag=99999;
        [cell.contentView addSubview:photoImageView];
        [photoImageView release];
        
        
        UILabel *nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        nickNameLabel.backgroundColor=[UIColor clearColor];
        nickNameLabel.font=[UIFont systemFontOfSize:15];
        nickNameLabel.tag=100000;
        [cell.contentView addSubview:nickNameLabel];
        [nickNameLabel release];
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 0, 0)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.font=[UIFont systemFontOfSize:13];
        contentLabel.numberOfLines=0;
        contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        contentLabel.tag=100001;
        [cell.contentView addSubview:contentLabel];
        [contentLabel release];
        
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 0, 0)];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:13];
        timeLabel.lineBreakMode=NSLineBreakByWordWrapping;
        timeLabel.tag=100002;
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        
    }
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:99999];
    UILabel *namelabel=(UILabel *)[cell.contentView viewWithTag:100000];
    UILabel *contentlabel=(UILabel *)[cell.contentView viewWithTag:100001];
    
    UILabel *timetlabel=(UILabel *)[cell.contentView viewWithTag:100002];
    id obj=[self.list objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKLikeObject class]])
    {
        GKLikeObject *like=(GKLikeObject *)obj;
        [imageView setImageWithURL:[NSURL URLWithString:like.avatar] placeholderImage:nil];
        namelabel.text=like.nickname;
        contentlabel.text=@"";
        timetlabel.frame=CGRectMake(200, 5, 100, 20);
        imageView.frame=CGRectMake(5, 5, 30, 30);
        namelabel.frame=CGRectMake(40, 10, 200, 20);
        contentlabel.frame=CGRectZero;
    }
    else if([obj isKindOfClass:[GKCommentObject class]])
    {
        GKCommentObject *comment=(GKCommentObject *)obj;
        [imageView setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:nil];
        
        if([comment.isstudent isEqualToString:@"1"])
        {
            namelabel.text=[NSString stringWithFormat:@"%@ 的家长",comment.nickname];
        }
        else
        {
            namelabel.text=[NSString stringWithFormat:@"%@ 老师",comment.nickname];
        }
        timetlabel.text=[self timeConvert:comment.addtime];
        //namelabel.text=comment.nickname;
        NSString *content;
        if (![comment.replynickname isEqualToString:@""])
        {
            content = [NSString stringWithFormat:@"回复 %@：%@",comment.replynickname,comment.content];
        }
        else
        {
            content = comment.content;
        }
        CGSize size=[content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(250, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        contentlabel.text=content;
        timetlabel.frame=CGRectMake(200, 5, 100, 20);
        imageView.frame=CGRectMake(5, 10, 30, 30);
        namelabel.frame=CGRectMake(40, 5, 200, 20);
        contentlabel.frame=CGRectMake(40, 30, 250, size.height);
        
    }
    
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj=[self.list objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKLikeObject class]])
    {
        return 40;
    }
    else if([obj isKindOfClass:[GKCommentObject class]])
    {
        GKCommentObject *comment=(GKCommentObject *)obj;
        
        NSString *content;
        if (![comment.replynickname isEqualToString:@""])
        {
            content = [NSString stringWithFormat:@"回复 %@：%@",comment.replynickname,comment.content];
        }
        else
        {
            content = comment.content;
        }
        CGSize size=[content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(250, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        
      //  CGSize size=[comment.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(250, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
        return size.height + 30+5;
        
        
    }
    return 0;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj=[self.list objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKLikeObject class]])
    {
        return;
    }
    else if([obj isKindOfClass:[GKCommentObject class]])
    {
        
    
        GKCommentObject *comment=(GKCommentObject *)obj;
        self.currentComId=comment.commentid;
        GKUserLogin *user=[GKUserLogin currentLogin];
        if(![comment.isstudent isEqualToString:@"1"] && [comment.adduserid isEqualToString:user.teacher.teacherid])
        {
            
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            sheet.tag=333+indexPath.row;
            [sheet showInView:self.view];
            [sheet release];
        }
        else
        {
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", nil];
            sheet.tag=4444;
            [sheet showInView:self.view];
            [sheet release];
        }
        
    }
    
}
-(void)leftButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    self.tableview=nil;
    self.shareContent=nil;
    self.movieBackView=nil;
    self.mPlayer=nil;
    self.list=nil;
    self.currentComId=nil;

    [super dealloc];
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

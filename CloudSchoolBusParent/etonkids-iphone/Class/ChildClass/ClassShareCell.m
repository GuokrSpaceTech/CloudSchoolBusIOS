
#import "ClassShareCell.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import "ImageScaleView.h"
#import "UIImageView+WebCache.h"
#import "CommentDetailViewController.h"
#import "WriteCommentsViewController.h"
#import "ETCommonClass.h"

#define ImageTag 1000
#define ImageButtom 2000
#define TAPIMAGETAG 111
#define AUDIOBUTTONTAG 9999
#define Viewtag  2002



@implementation ClassShareCell
@synthesize titleLabel,contentLabel,timeLabel,backImgV;
@synthesize theShareCtnt;
@synthesize delegate;
@synthesize praiseButton;
@synthesize commentsButton;
@synthesize praiseLab,commentLab,praiseImgV,commentImgV,photoImgVArr,triangle;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellMode:(CellMode)mode
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // self.contentView.backgroundColor=[UIColor redColor];
        
        self.contentView.backgroundColor = CELLCOLOR;
        
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
        
        
        self.photoImgVArr = [NSMutableArray array];
        
        for (int i = 0; i < MAX_IMAGECOUNT; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
            imgV.userInteractionEnabled = YES;
//            imgV.contentMode = UIViewContentModeScaleAspectFit;
            imgV.tag = TAPIMAGETAG + i;
            [self addSubview:imgV];
            [imgV release];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imgV addGestureRecognizer:tap];
            [tap release];
            
            [self.photoImgVArr addObject:imgV];
        }
        
        UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectZero];
        l.image = [UIImage imageNamed:@"cellline.png"];
        [self addSubview:l];
        [l release];
        
        self.line = l;
    
      
    }
    return self;
}

- (void)doTap:(UIGestureRecognizer *)sender
{
    
}


/// 点击赞事件.
-(void)praise:(UIButton*)sender
{

//    NSLog(@"cell  praise");
    
    

    
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


/// 点击评论.
-(void)comments:(UIButton*)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickComment:)]) {
        [delegate clickComment:self.theShareCtnt];
    }
    
}
-(void)playAudio:(UIButton *)button
{
    if(delegate&&[delegate respondsToSelector:@selector(playAudioStreamView:Info:)])
    {
        [delegate playAudioStreamView:self Info:self.theShareCtnt];
    }
}
-(void)shareAnimation:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [UIView beginAnimations:nil context:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"post1.png"] forState:UIControlStateNormal];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:btn cache:YES];
    
    [UIView commitAnimations];
    [btn removeTarget:self action:@selector(shareAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)share:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [delegate shareWeibo:self.theShareCtnt withTag:self.tag];
    [btn removeTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(shareAnimation:) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)loadMore:(UIButton *)button
//{
//    // button.selected=!button.selected;
//    
//    NSString *more=LOCAL(@"more", @"更多");
//    NSString *up=LOCAL(@"up", @"收起");
//    
//    if([button.titleLabel.text isEqualToString:more])
//    {
//        [button.titleLabel.text isEqualToString:up];
//    }
//    else
//    {
//        [button.titleLabel.text isEqualToString:more];
//    }
//    if(delegate&&[delegate respondsToSelector:@selector(shareCell:share:)])
//    {
//        [delegate shareCell:self share:self.theShareCtnt];
//    }
//
//}
-(void)dealloc
{
    self.titleLabel=nil;
    self.contentLabel=nil;
    self.timeLabel=nil;
    self.theShareCtnt=nil;
    
    
    self.delegate = nil;
    self.theShareCtnt = nil;
    self.praiseButton = nil;
    self.commentsButton = nil;
    self.praiseLab = nil;
    self.commentLab = nil;
    self.commentImgV = nil;
    self.praiseImgV = nil;
    self.backImgV = nil;
    self.photoImgVArr = nil;
    self.line = nil;
    
    self.triangle = nil;
    
    [super dealloc];
    
}

//-(void)showHUD:(BOOL) animation
//{
//    if(animation)
//    {
//        if(HUD==nil)
//        {
//            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            HUD=[[MBProgressHUD alloc]initWithView:app.window];
//            [app.window addSubview:HUD];
//            [HUD show:YES];
//            [HUD release];
//        }
//        
//    }
//    else
//    {
//        if(HUD)
//        {
//            [HUD removeFromSuperview];
//            HUD=nil;
//        }
//    }
//}
//-(void)tapClick:(UITapGestureRecognizer *)tap
//{
//    [self showHUD:YES];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^(void)
//                   {
//                       NSMutableArray * imgArr  = [[NSMutableArray alloc] initWithCapacity:1];
//                       dispatch_group_t group = dispatch_group_create();
//                       __block dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//                       for(int i=0;i<self.theShareCtnt.sharePicArr.count;i++)
//                       {
//                           dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//                           
//                           dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^(void)
//                                                {
//                                                    NSDictionary * dic = [self.theShareCtnt.sharePicArr objectAtIndex:i];
//                                                    NSString * path = [dic objectForKey:@"source"];
//                                                    NSString * bigerUrl = path;
//                                                    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bigerUrl]];
//                                                    UIImage * image = [UIImage imageWithData:data];
//                                                    if(image!=nil)
//                                                        [imgArr addObject:image];
//                                                    
//                                                    dispatch_semaphore_signal(sem);
//                                                });
//                       }
//                       dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//                       dispatch_group_notify(group, dispatch_get_main_queue(), ^(void)
//                                             {
//                                                 [self showHUD:NO];
//                                                 
//                                                 if(imgArr.count ==0)
//                                                 {
//                                                     dispatch_release(group);
//                                                     [imgArr release];
//                                                     return;
//                                                 }
//                                                 
//                                                 AppDelegate *delegate11=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//                                                 
//                                                 CGRect frame=[[UIScreen mainScreen]applicationFrame];
//                                                 
//                                                 ImageScaleView *ivew=[[ImageScaleView alloc]initWithFrame:CGRectMake(0,frame.size.height,frame.size.width , frame.size.height) image:imgArr];
//                                                 [delegate11.window addSubview:ivew];
//                                                 
//                                                 [UIView animateWithDuration:0.5 animations:^{
//                                                     ivew.frame=CGRectMake(0, 20, frame.size.width, frame.size.height);
//                                                 } completion:^(BOOL finished) {
//                                                     
//                                                     dispatch_release(group);
//                                                     [imgArr release];
//                                                     
//                                                 }];
//                                             });
//                       
//                   });  
//    
//}


- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    
    if (delegate && [delegate respondsToSelector:@selector(didTapImageWithImageArray:showNumber:content:)]) {
        
        [delegate didTapImageWithImageArray:self.theShareCtnt.sharePicArr showNumber:MAX(0,sender.view.tag - TAPIMAGETAG) content:self.theShareCtnt];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

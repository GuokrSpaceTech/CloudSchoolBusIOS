
#import "ClassShareCell.h"

//#import "AppDelegate.h"
//#import "ImageScaleView.h"
#import "UIImageView+WebCache.h"
//#import "CommentDetailViewController.h"
//#import "WriteCommentsViewController.h"
//#import "ETCommonClass.h"

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
@synthesize praiseLab,commentLab,praiseImgV,commentImgV,triangle;

@synthesize picImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellMode:(CellMode)mode
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:227/255.0f alpha:1.0f];
        
        UILabel *tLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 250, 23)];
        tLabel.backgroundColor=[UIColor clearColor];
        tLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        tLabel.numberOfLines = 0;
        tLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:tLabel];
        [tLabel release];
        
        self.titleLabel = tLabel;
        
        
        UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 16)];
        timeLab.backgroundColor=[UIColor clearColor];
        timeLab.font=[UIFont systemFontOfSize:12];
        timeLab.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0f];
//        self.timeLabel.textAlignment=UITextAlignmentRight;
        [self addSubview:timeLab];
        [timeLab release];
        
        self.timeLabel = timeLab;
        
        
        UILabel *ctntLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        ctntLabel.backgroundColor=[UIColor clearColor];
        ctntLabel.font=[UIFont systemFontOfSize:15];
        ctntLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
        ctntLabel.numberOfLines = 0;
        ctntLabel.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
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
        pLab.font=[UIFont systemFontOfSize:15];
        pLab.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
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
        cmtLab.font=[UIFont systemFontOfSize:15];
        cmtLab.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
        [self addSubview:cmtLab];
        [cmtLab release];
        
        self.commentLab = cmtLab;
        
        
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pButton setFrame:CGRectMake(185, 0, 70, 30)];
        [pButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pButton];
        
        self.praiseButton = pButton;
        
        UIButton *cmtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cmtButton setFrame:CGRectMake(255, 0, 70, 30)];
        [cmtButton addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cmtButton];
        
        self.commentsButton = cmtButton;
        
        
        
        picImageView= [[UIImageView alloc] initWithFrame:CGRectZero];
        picImageView.userInteractionEnabled = YES;
        picImageView.contentMode = UIViewContentModeScaleAspectFill;
        picImageView.tag = TAPIMAGETAG;
        picImageView.clipsToBounds=YES;
        [self addSubview:picImageView];
        [picImageView release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [picImageView addGestureRecognizer:tap];
        [tap release];

        UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectZero];
        l.image = [UIImage imageNamed:@"cellline.png"];
        [self addSubview:l];
        [l release];
        
        self.line = l;
    //114/92
        _photoRegisterView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 41)];
        _photoRegisterView.image=[UIImage imageNamed:@"photo_register.png"];
        [self addSubview:_photoRegisterView];
       // photoImageView.hidden=YES;
        [_photoRegisterView release];
    }
    return self;
}

- (void)doTap:(UIGestureRecognizer *)sender
{
    
}


/// 点击赞事件.
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
        self.praiseLab.text = NSLocalizedString(@"upText", @"");
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
   // self.photoImgVArr = nil;
    self.line = nil;
    self.picImageView=nil;
    self.triangle = nil;
    self.photoRegisterView=nil;
    [super dealloc];
    
}


- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    
    if (delegate && [delegate respondsToSelector:@selector(didTapImageWithImagecontent:)]) {
        
        [delegate didTapImageWithImagecontent:self.theShareCtnt];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

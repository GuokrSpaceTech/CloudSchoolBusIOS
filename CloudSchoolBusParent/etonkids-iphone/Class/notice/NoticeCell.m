//
//  NoticeCell.m
//  etonkids-iphone
//
//  Created by wpf on 1/22/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "NoticeCell.h"
#import "ETKids.h"

#define ImageVTag 1111
#define ImageTTag 2222
#define ButtonTag 33333
#define ButtomImage 4444
#define Buttonreceipt 5555
#define TitleBottomLine 6666

#define TAPIMAGETAG 111

@implementation NoticeCell
@synthesize noticeContentLabel,noticeTimeLabel,noticeTitleLabel;
@synthesize notice;
@synthesize delegate;
@synthesize buttonMore;
@synthesize buttonreceipt;
@synthesize redlabel,backImgV,lineImgV,photoImgVArr,line,triangle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        self.contentView.backgroundColor = CELLCOLOR;
        
        

        
        UIImageView *carImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 23)];
        carImgV.image = [UIImage imageNamed:@"car.png"];
        [self.contentView addSubview:carImgV];
        [carImgV release];
        
        
        UILabel *nTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 250, 23)];
        nTitleLabel.backgroundColor=[UIColor clearColor];
        nTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
        nTitleLabel.numberOfLines = 0;
        nTitleLabel.font=[UIFont systemFontOfSize:TITLEFONTSIZE];
        [self.contentView addSubview:nTitleLabel];
        [nTitleLabel release];
        
        self.noticeTitleLabel = nTitleLabel;
        
        
        UILabel *nTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 16)];
        nTimeLabel.backgroundColor=[UIColor clearColor];
        nTimeLabel.font=[UIFont systemFontOfSize:TIMEFONTSIZE];
        nTimeLabel.textColor = TIMETEXTCOLOR;
        [self.contentView addSubview:nTimeLabel];
        [nTimeLabel release];
        
        self.noticeTimeLabel = nTimeLabel;
        
        UIImageView *tImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        tImgV.image = [UIImage imageNamed:@"triangle.png"];
        [self addSubview:tImgV];
        [tImgV release];
        
        self.triangle = tImgV;
        
        
        UIImageView *bImgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 270, 0)];
//        UIImage *img = [UIImage imageNamed:@"popback"];
//        bImgV.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, 15)];
        bImgV.backgroundColor = [UIColor whiteColor];
        bImgV.layer.cornerRadius = 10;
        [self.contentView addSubview:bImgV];
        [bImgV release];
        
        self.backImgV = bImgV;
        
        
        HTCopyableLabel *nctntLabel=[[HTCopyableLabel alloc] initWithFrame:CGRectZero];
        nctntLabel.backgroundColor = [UIColor clearColor];
        nctntLabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        nctntLabel.textColor = CONTENTTEXTCOLOR;
        nctntLabel.numberOfLines = 0;
        nctntLabel.lineBreakMode=UILineBreakModeWordWrap|NSLineBreakByTruncatingTail;
        [self.contentView addSubview:nctntLabel];
        [nctntLabel release];
        
        self.noticeContentLabel = nctntLabel;
        
        
        UIImageView *lImgV1 = [[UIImageView alloc]initWithFrame:CGRectMake(backImgV.frame.origin.x, 0, backImgV.frame.size.width, 1)];
        lImgV1.image=[UIImage imageNamed:@"line.png"];
        lImgV1.tag = TitleBottomLine;
        [self.contentView addSubview:lImgV1];
        [lImgV1 release];
        
        self.lineImgV = lImgV1;
        
        
        self.photoImgVArr = [NSMutableArray array];
        
        for (int i = 0; i < MAX_IMAGECOUNT; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
            imgV.userInteractionEnabled = YES;
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            imgV.tag = TAPIMAGETAG + i;
            [self.contentView addSubview:imgV];
            [imgV release];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imgV addGestureRecognizer:tap];
            [tap release];
            
            [self.photoImgVArr addObject:imgV];
        }
        
        
        
        

        
        
        UIButton *btnMore=[UIButton buttonWithType:UIButtonTypeCustom];

        btnMore.tag=ButtonTag;
        [btnMore setFrame:CGRectMake(40, 0, 270, 30)];
//        btnMore.backgroundColor = [UIColor redColor];
        [btnMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        btnMore.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [btnMore setTitleColor:[UIColor colorWithHue:220.0/360.0 saturation:0.40 brightness:0.59 alpha:1.0] forState:UIControlStateNormal];
        [self.contentView addSubview:btnMore];
        
        self.buttonMore = btnMore;
        
        
        UIButton *btnreceipt=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnreceipt setFrame:CGRectMake(0, 0, 65, 25)];
        [btnreceipt setTitle:LOCAL(@"confrom", @"") forState:UIControlStateNormal];
        btnreceipt.titleLabel.font = [UIFont systemFontOfSize:13];
//        [buttonreceipt setBackgroundImage:[UIImage  imageNamed:LOCAL(@"huizhi", @"")] forState:UIControlStateNormal];
        btnreceipt.backgroundColor = [UIColor colorWithRed:101/255.0f green:184/255.0f blue:206/255.0f alpha:1.0];
        [btnreceipt addTarget:self action:@selector(Receipt:) forControlEvents:UIControlEventTouchUpInside];
        btnreceipt.tag=Buttonreceipt;
        [self.contentView addSubview:btnreceipt];
        
        self.buttonreceipt = btnreceipt;
        

        UIImageView *lImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        lImgV.image = [UIImage imageNamed:@"cellline.png"];
        [self.contentView addSubview:lImgV];
        [lImgV release];
        
        self.line = lImgV;
    
    }
    return self;
}


-(void)loadMore:(UIButton*)button
{
    button.selected=!button.selected;
    if(delegate&&[delegate respondsToSelector:@selector(noticeCell:notice:)])
    {
        [delegate noticeCell:self notice:self.notice];
    }
}
-(void)Receipt:(UIButton*)button
{
    
    if (delegate && [delegate respondsToSelector:@selector(clickComfirmNoticeCell:)]) {
        [delegate clickComfirmNoticeCell:self];
    }
    
}
- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    
    if (delegate && [delegate respondsToSelector:@selector(didTapImageWithImageArray:showNumber:content:)]) {
        
        [delegate didTapImageWithImageArray:self.notice.pictures showNumber:MAX(0,sender.view.tag - TAPIMAGETAG) content:self.notice];
    }
    
}

-(void)dealloc
{
    self.noticeContentLabel=nil;
    self.noticeTimeLabel=nil;
    self.noticeTitleLabel=nil;
    self.notice=nil;
    self.line = nil;
    self.buttonMore = nil;
    self.buttonreceipt = nil;
    self.backImgV = nil;
    self.lineImgV = nil;
    self.photoImgVArr = nil;
    self.triangle = nil;
    
    [super dealloc];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

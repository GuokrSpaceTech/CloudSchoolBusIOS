//
//  GKAlreadyCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKAlreadyCell.h"
#import "UIImageView+WebCache.h"
@implementation GKAlreadyCell
@synthesize nameLabel,timeLabel,jifenlabel,stateLabel,goodsImageView;
@synthesize market;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        goodsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35  , 35)];
        goodsImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:goodsImageView];
        
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        //nameLabel.text=@"fdfdfdffdfdfsdfsdfdsfsdfdsfsdfds";
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.textColor=[UIColor colorWithRed:110/255.0 green:165/255.0 blue:174/255.0 alpha:1];
        [self.contentView addSubview:nameLabel];
        
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, 200, 20)];
        timeLabel.backgroundColor=[UIColor clearColor];
        //timeLabel.text=@"fdfdfdffdfdfsdfsdfdsfsdfdsfsdfds";
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeLabel];
        
        
        jifenlabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 110, 20)];
        jifenlabel.backgroundColor=[UIColor clearColor];
        //jifenlabel.text=@"-5000积分";
        jifenlabel.font=[UIFont systemFontOfSize:12];
        if (IOSVERSION>=6.0) {
            jifenlabel.textAlignment=NSTextAlignmentRight;
        }
        else
        {
             jifenlabel.textAlignment=UITextAlignmentRight;
        }
        [self.contentView addSubview:jifenlabel];
        
        stateLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 30, 110, 20)];
        stateLabel.backgroundColor=[UIColor clearColor];
        //stateLabel.text=@"等待处理";
        if (IOSVERSION>=6.0) {
            stateLabel.textAlignment=NSTextAlignmentRight;
        }
        else
        {
            stateLabel.textAlignment=UITextAlignmentRight;
        }

        stateLabel.textColor=[UIColor redColor];
        stateLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:stateLabel];
        
        
        UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 53, 320, 2)];
        NSString *linestr=[[NSBundle mainBundle]pathForResource:@"line" ofType:@"png"];
        lineImage.image=[UIImage imageWithContentsOfFile:linestr];
        [self.contentView addSubview:lineImage];
        [lineImage release];

        
    }
    return self;
}

-(void)setMarket:(GKMarket *)_market
{
    [market release];
    market=[_market retain];
    
    nameLabel.text=market.marketName;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[market.addtime integerValue]];
    timeLabel.text=[date.description substringToIndex:10];
    jifenlabel.text=[NSString stringWithFormat:@"%@x%@积分",market.num,market.marketCredits];
    stateLabel.text=[self stateStr:[market.status integerValue]];
    
    [goodsImageView setImageWithURL:[NSURL URLWithString:market.marketUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
}
-(NSString *)stateStr:(int )a
{
    switch (a) {
        case 1:
        {
            stateLabel.textColor=[UIColor grayColor];
            return NSLocalizedString(@"cancel", @"");
        }
        break;
        case 2:
            stateLabel.textColor=[UIColor grayColor];
             return NSLocalizedString(@"success", @"");
            break;
        case 3:
            stateLabel.textColor=[UIColor redColor];
            return NSLocalizedString(@"inprocess", @"");
            break;
        case 4:
            stateLabel.textColor=[UIColor redColor];
             return NSLocalizedString(@"comfirming", @"");
            break;
            
     
        default:
            break;
    }
    return nil;
}
-(void)dealloc
{
    self.nameLabel=nil;
    self.timeLabel=nil;
    self.jifenlabel=nil;
    self.stateLabel=nil;
    self.market=nil;
    self.goodsImageView=nil;
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

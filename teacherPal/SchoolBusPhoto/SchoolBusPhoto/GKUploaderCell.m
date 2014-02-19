//
//  GKUploaderCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-18.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKUploaderCell.h"
#import "GKFindWraper.h"
#import "TestFlight.h"

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@implementation GKUploaderCell
@synthesize upwraper;
@synthesize imageView;
@synthesize process;

@synthesize sizeLabel,nameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imageView];
        
        
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 250, 25)];
        nameLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        nameLabel.font=[UIFont systemFontOfSize:12];
        sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 250, 30)];
        sizeLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:sizeLabel];
        sizeLabel.font=[UIFont systemFontOfSize:12];
        sizeLabel.textColor=[UIColor grayColor];
        
    }
    return self;
}
-(void)setUpwraper:(GKUpWraper *)_upwraper
{
    [upwraper release];
    upwraper=[_upwraper retain];
    
    for (UIView *view in  [self.contentView subviews]) {
        
        if([view isKindOfClass:[myProgressView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    //GKUpWraper *wra= [GKFindWraper getBookWrapper:_upwraper.nameid];
    
      upwraper._progressView.frame=CGRectMake(270, 10, 40, 40);
    //        [cell addSubview:wraper._progressView];
    
    [self addSubview:upwraper._progressView];
    
    imageView.image=[UIImage imageWithData:upwraper.imageData];
    
    
    nameLabel.text=upwraper.name;
    
    
    sizeLabel.text=[NSString stringWithFormat:@"%.3fM",[upwraper.fize integerValue]/1024/1024.0];
//    DACircularProgressView *processView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(200, 10, 20, 20)];
//    [self addSubview:processView];
//    [processView release];
//    processView.progress=upwraper._progressView.progress;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.upwraper=nil;
    self.process=nil;
    self.nameLabel=nil;
    self.sizeLabel=nil;
    [super dealloc];
}
@end

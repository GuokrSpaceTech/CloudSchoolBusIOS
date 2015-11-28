//
//  AttendanceView.m
//  CloudBusParent
//
//  Created by macbook on 15/11/28.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "AttendanceView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface AttendanceView()
{
    BOOL hasValidPicture;
}
@end

@implementation AttendanceView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

-(void)setMessage:(Message *)message{
    
    _message = message;
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = _message.title;
    [self addSubview:_timeLabel];
    
    NSDictionary *bodyDict = [_message bodyObject];
    NSString *picUrlStr = bodyDict[@"picture"];
    
    if(![picUrlStr isEqual:[NSNull null]])
    {
        _timeCardImageView = [[UIImageView alloc] init];
        _timeCardImageView.clipsToBounds = YES;
        _timeCardImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_timeCardImageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr]
                      placeholderImage:nil completed:^(UIImage *image, NSError *error,
                                                   SDImageCacheType cacheType, NSURL *imageURL){
                          NSLog(@"");
                      }];
        
        [self addSubview:_timeCardImageView];
        hasValidPicture = true;
        _height = @240;
    } else {
        hasValidPicture = false;
        _height = @40;
    }
}

-(void)updateConstraints
{
    for(NSLayoutConstraint *constraint in _timeCardImageView.constraints)
    {
        if([constraint.identifier isEqualToString:@"image_height"]){
            if(hasValidPicture)
                constraint.constant = 200;
            else
                constraint.constant = 0;
        }
    }
    
    [super updateConstraints];
}

@end

//
//  NoticeView.m
//  CloudBusParent
//
//  Created by mactop on 11/24/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "NoticeView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIColor+RCColor.h"
@interface NoticeView()
{
    NSArray *picArray;
    bool hasValidImage;
}
@end

@implementation NoticeView

@synthesize imageView = _imageView;
@synthesize title = _title;
@synthesize content = _content;
@synthesize confirmButton = _confirmButton;

-(void)setMessage:(Message *)message
{
    float VERTICAL_SPACING = 10;

    _message = message;
    _title.text = message.title;
    _content.text = message.desc;
    
    NSDictionary *bodyDict = [_message bodyObject];
    picArray = bodyDict[@"PList"];
    
    if([picArray count] > 0)
    {
        for(NSString *picUrlStr in picArray)
        {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr]
                         placeholderImage:nil completed:^(UIImage *image, NSError *error,
                         SDImageCacheType cacheType, NSURL *imageURL){
                             NSLog(@"");
                             if(error!=nil & image==nil)
                             {
                                 hasValidImage = false;
                             } else {
                                 hasValidImage = true;
                             }
                         }];
        }
    }
    _confirmButton.backgroundColor = [UIColor colorWithHexString:@"2661F7" alpha:1.0f];
    
    
    CGRect titleRect = [_title.text
                        boundingRectWithSize:CGSizeMake(200, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}
                        context:nil];
    CGRect contentRect = [_title.text
                          boundingRectWithSize:CGSizeMake(200, 0)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}
                          context:nil];
    
    float imageHeight;
    
    if(hasValidImage)
        imageHeight = 60;
    else{
        imageHeight = 0;
    }
    
    self.height = @(VERTICAL_SPACING + titleRect.size.height + VERTICAL_SPACING + contentRect.size.height + imageHeight+VERTICAL_SPACING+_confirmButton.frame.size.height);
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    if(hasValidImage)
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@60);
    }];
    else{
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
            make.width.mas_equalTo(@0);
        }];
    }
}
@end

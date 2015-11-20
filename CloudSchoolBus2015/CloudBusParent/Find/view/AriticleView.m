//
//  AriticleView.m
//  CloudBusParent
//
//  Created by mactop on 11/20/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "AriticleView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "Masonry.h"

#define PICWIDTH 75
#define PADDING 10

@implementation AriticleView

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

-(void)setMessage:(Message *)message
{
    _message = message;
    NSDictionary * dic = [_message bodyObject];
    NSArray * picArr = dic[@"PList"];
    if(![picArr isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    //Add all ImageViews
    _imageViews = [[NSMutableArray alloc] init];
    int i = 0;
    for(NSString *picPath in picArr){
        if([picPath containsString:@"://"])
        {
            UIImageView * imageView = [[UIImageView alloc]init];
            NSMutableString *thumbUrlStr =  [[NSMutableString alloc] initWithString:picArr[i]];
            [thumbUrlStr appendString:@".tiny.jpg"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]
                       placeholderImage:nil completed:^(UIImage *image, NSError *error,
                       SDImageCacheType cacheType, NSURL *imageURL) {}];
            
            [self addSubview:imageView];
            
            [_imageViews addObject:imageView];
        }
        i++;
    }
    
    NSUInteger numPics = [_imageViews count];
    float multiPicWidth = (([UIScreen mainScreen].bounds.size.width - 80) - PADDING * 2) / 3.0;
    float singlePicWidth = [UIScreen mainScreen].bounds.size.width / 3.0;
    
    if((int)numPics == 1){
        self.width = @(singlePicWidth);
        self.height = @(singlePicWidth);
    }else if((int)numPics == 4){
        self.width = @(multiPicWidth * 2 + PADDING);
        self.height = @(multiPicWidth * 2 + PADDING);
    }else{
        int col = 3;
        int row = (numPics % 3 == 0)?(int)(numPics/3):(int)(numPics/3 + 1);
        self.width = @(multiPicWidth * col + PADDING * (col-1));
        self.height = @(multiPicWidth * row + PADDING * (row -1));
    }
}

-(void)updateConstraints
{
    NSUInteger numPics = [_imageViews count];
    
    int col=0;
    int row=0;
    float picWidth = 0;

    if(numPics == 1) {
        col = 1;
        row = 1;
        picWidth = [UIScreen mainScreen].bounds.size.width / 3.0;
    } else if(numPics == 4) {
        picWidth = (([UIScreen mainScreen].bounds.size.width - 80) - PADDING * 2) / 3.0;
        col = 2;
        row = 2;
    } else if(numPics > 1) {
        picWidth = (([UIScreen mainScreen].bounds.size.width - 80) - PADDING * 2) / 3.0;
        col = 3;
        row = 3;
    } else {
        NSLog(@"Invalid number of pictures");
    }
    
    int i = 0;
    for( UIImageView *imageView in _imageViews)
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            float left = 50 + (picWidth + PADDING)*(i%col);
            float top = (picWidth + PADDING)*(i/row);
            make.left.equalTo(self.mas_left).offset(left);
            make.top.equalTo(self.mas_top).offset(top);;
            make.width.mas_equalTo(@(picWidth));
            make.height.mas_equalTo(@(picWidth));
        }];
        
        i++;
    }
    
    [super updateConstraints];
}
@end

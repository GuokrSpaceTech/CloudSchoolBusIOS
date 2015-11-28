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
    float BUTTON_HEIGHT = 25;

    _message = message;
    _title.text = _message.title;
    _content.text = _message.desc;
    
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
    
    
    CGRect titleRect = [_message.title
                        boundingRectWithSize:CGSizeMake(300, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}
                        context:nil];
    
    //http://stackoverflow.com/questions/20602491/boundingrectwithsize-does-not-respect-word-wrapping
    CGRect contentRect = [_message.desc
                          boundingRectWithSize:CGSizeMake(300, 0)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}
                          context:nil];
    
    float imageHeight;
    
    if(hasValidImage){
        imageHeight = 60;
    }else{
        imageHeight = 0;
    }
    
    self.height = @(VERTICAL_SPACING + ceil(titleRect.size.height) + VERTICAL_SPACING + ceil(contentRect.size.height) + imageHeight + VERTICAL_SPACING + BUTTON_HEIGHT + 25);
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    for(NSLayoutConstraint *constraint in _imageView.constraints)
    {
        if([constraint.identifier isEqualToString:@"image_height"]){
            if(hasValidImage)
                constraint.constant = 60;
            else
                constraint.constant = 0;
        }
    }
}


@end

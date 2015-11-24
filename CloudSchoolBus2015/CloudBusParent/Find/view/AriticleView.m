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
#import "CBLoginInfo.h"
#import "School.h"
#import "Tag.h"

#define PICWIDTH 60
#define PADDING 10
#define COL_TAG 4
#define COL_PIC 3

@interface AriticleView()
{
    NSMutableArray *picArray;
    NSArray *tagArrary;
}
@end

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
    picArray = dic[@"PList"];
    if(![picArray isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    //Add all ImageViews
    _imageViews = [[NSMutableArray alloc] init];
    int i = 0;
    for(NSString *picPath in picArray){
        if([picPath containsString:@"://"])
        {
            UIImageView * imageView = [[UIImageView alloc]init];
            NSMutableString *thumbUrlStr =  [[NSMutableString alloc] initWithString:picArray[i]];
            [thumbUrlStr appendString:@".tiny.jpg"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]
                       placeholderImage:nil completed:^(UIImage *image, NSError *error,
                       SDImageCacheType cacheType, NSURL *imageURL){
            }];
            
            UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick:)];
            
            [imageView setUserInteractionEnabled:YES];
            [imageView addGestureRecognizer:newTap];
            [imageView setTag:i];
        
            
            [self addSubview:imageView];
            
            [_imageViews addObject:imageView];
        }
        i++;
    }
    
    //Calculate the height and width needed
    NSUInteger numPics = [_imageViews count];
    float multiPicWidth = (([UIScreen mainScreen].bounds.size.width - 100) - PADDING * 2) / 3.0;
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
    
    //Add all tags if have any
    _tagButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tagIds = [[NSMutableArray alloc] init];
    NSString *tagIdStr = [_message tag];
    if(tagIdStr!=nil && [tagIdStr length]!=0)
    {
        if([tagIdStr containsString:@","]){
            [tagIds addObjectsFromArray:[tagIdStr componentsSeparatedByString:@","]];
        }else{
            [tagIds addObject:tagIdStr];
        }
    }
    
    BOOL isFound = false;
    i = 0;
    for(NSString *tagid in tagIds)
    {
        School *school = [[[CBLoginInfo shareInstance] schoolArr] objectAtIndex:0];
        tagArrary = [school tagsArr];
        for(Tag *tag in tagArrary)
        {
            if( [[tag tagid] compare:tagid] == NSOrderedSame )
            {
                UIButton *tagButton = [[UIButton alloc] init];
                tagButton.tag = i;
                [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [tagButton setTitle:[tag tagname] forState:UIControlStateNormal];
                tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
                tagButton.backgroundColor = [UIColor colorWithHexString:@"#C3C3C3" alpha:1.0f];

                [self addSubview:tagButton];
                [_tagButtons addObject:tagButton];
                
                isFound = true;
            }
        }
        i++;
    }
    
    if(isFound)
    {
        float buttonHeight = 20;
        int numTags = (int)[_tagButtons count];
        int numRows = (numTags - 1)/COL_TAG + 1;
        float toatalButtonHeight = numRows * (buttonHeight + PADDING);
        self.height = @([self.height intValue] + toatalButtonHeight);
    }
    
    //Add Description if have any
    if(_message.desc!=nil && [_message.desc length]>0)
    {
        float descHeight = 20 + PADDING;
        _descLabel = [[UILabel alloc]init];
        _descLabel.numberOfLines = 0;
        _descLabel.text = _message.desc;
        _descLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 100;
        self.height = @([self.height intValue] + descHeight );
        [self addSubview:_descLabel];
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
        picWidth = (([UIScreen mainScreen].bounds.size.width - 100) - PADDING * 2) / 3.0;
        col = 2;
        row = 2;
    } else if(numPics > 1) {
        picWidth = (([UIScreen mainScreen].bounds.size.width - 100) - PADDING * 2) / 3.0;
        col = COL_PIC;
        row = COL_PIC;
    } else {
        NSLog(@"Invalid number of pictures");
    }
    
    int i = 0;
    for( UIImageView *imageView in _imageViews)
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            float left = 30 + (picWidth + PADDING)*(i%col);
            float top = (picWidth + PADDING)*(i/row);
            make.left.equalTo(self.mas_left).offset(left);
            make.top.equalTo(self.mas_top).offset(top);
            make.width.mas_equalTo(@(picWidth));
            make.height.mas_equalTo(@(picWidth));
        }];
        i++;
    }
    
    i = 0;
    float buttonWidth = 50;
    float buttonHeight = 20;
    for( UIButton *button in _tagButtons)
    {
        float left = 30 + (buttonWidth + PADDING)* (i%COL_TAG);
        int row = i / COL_TAG;
        float top  = PADDING * (row + 1) + buttonHeight * (row);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            UIImageView *lastImageView = [_imageViews lastObject];
            make.left.equalTo(self).offset(left);
            make.top.equalTo(lastImageView.mas_bottom).offset(top);
            make.width.mas_equalTo(@(buttonWidth));
            make.height.mas_equalTo(@(buttonHeight));
        }];
        
        i++;
    }
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if([_tagButtons count]>0)
        {
            UIButton *button = [_tagButtons lastObject];
            make.top.equalTo(button.mas_bottom).offset(10);
        } else {
            UIImageView *lastImageView = [_imageViews lastObject];
            make.top.equalTo(lastImageView.mas_bottom).offset(10);
        }
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [super updateConstraints];
}

-(void)tagButtonClick:(id)sender
{
    UIButton *button = sender;
    int index = (int)button.tag;
    NSString *tagDesc = [[tagArrary objectAtIndex:index] tagnamedesc];
    [_delegate userSelectedTag:tagDesc];
}

-(void)pictureClick:(id)sender
{
    UIImageView *view = (UIImageView *)[sender view];
    int index = (int)view.tag;
    [_delegate userSelectedPicture:[picArray objectAtIndex:index] pictureArray:picArray indexAt:index];
}
@end

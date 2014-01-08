//
//  GKPhotoTagScrollView.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKPhotoTagScrollView.h"

#define TOPMARGIN 5
#define LEFTMARGIN 5
#define DISTANCE 5  // 间距.

#define BUTTON_HEIGHT 30

#define TITLEFONT [UIFont systemFontOfSize:13]

@implementation GKPhotoTagScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotoTags:(NSArray *)tags
{
    int x = LEFTMARGIN; // 标记当前插入位置.
    int y = TOPMARGIN;
    
    for (int i = 0 ; i < tags.count; i++) {
        
        int originX;
        int originY;
        int width; /*按钮宽度*/
        
        NSString *title = [tags objectAtIndex:i];
        CGSize titleSize = [title sizeWithFont:TITLEFONT constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByWordWrapping];
        width = titleSize.width + 10;
        
        if (self.frame.size.width >= x + width + DISTANCE)
        {
            originX = x;
            originY = y;
            
            x = originX + width + DISTANCE;
        }
        else
        {
            originX = LEFTMARGIN;
            originY = y + DISTANCE + BUTTON_HEIGHT;
            x = LEFTMARGIN;
            y = originY;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(originX, originY, width, BUTTON_HEIGHT)];
        btn.titleLabel.font = TITLEFONT;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    self.contentSize = CGSizeMake(self.frame.size.width, y + BUTTON_HEIGHT + DISTANCE);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

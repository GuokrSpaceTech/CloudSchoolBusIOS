//
//  ETImageView.m
//  jiesuo
//
//  Created by wen peifang on 13-9-25.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "ETImageView.h"

@implementation ETImageView
@synthesize choose;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       
    }
    return self;
}
-(void)setChoose:(BOOL)_ch
{
    choose=_ch;
    if(choose==YES)
    {
        self.image=[UIImage imageNamed:@"03.png"];
    }
    else
    {
         self.image=[UIImage imageNamed:@"02.png"];
    }
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

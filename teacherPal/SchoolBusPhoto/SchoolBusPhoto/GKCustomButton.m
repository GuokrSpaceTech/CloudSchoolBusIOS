//
//  GKCustomButton.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-2-12.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCustomButton.h"

@implementation GKCustomButton
@synthesize titleRect,imageRect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
 
        
    }
    return self;
}
//- (CGRect)backgroundRectForBounds:(CGRect)bounds
//{
//    
//}
//- (CGRect)contentRectForBounds:(CGRect)bounds
//{
//    
//}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if(!CGRectIsEmpty(titleRect))
    {
        return titleRect;
    }
    else
        return contentRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if(!CGRectIsEmpty(imageRect))
    {
        return imageRect;
    }
    else
        return contentRect;
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

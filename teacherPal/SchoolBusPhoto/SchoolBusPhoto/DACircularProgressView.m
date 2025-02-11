//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation DACircularProgressView

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;
-(void)dealloc
{
    self.trackTintColor=nil;
    self.progressTintColor=nil;
    [super dealloc];
}
- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = radius * 0.3f;
    
    CGFloat radians = DEGREES_2_RADIANS((self.progress*359.9)-90);
    // CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    // CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    //  CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.trackTintColor setFill];
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if(_progress!=0)
    {
        [self.progressTintColor setFill];
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
        //
        CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
        CGContextFillPath(context);
    }
    
    //
    //        CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
    //        CGContextFillPath(context);
    //
    CGContextSetBlendMode(context, kCGBlendModeClear);;
    CGFloat innerRadius = radius * 0.7;
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
    CGContextFillPath(context);
    
    
}

#pragma mark - Property Methods

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        self.trackTintColor = [UIColor colorWithRed:74/255.0 green:154/255.0 blue:177/255.0 alpha:1];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        self.progressTintColor = [UIColor colorWithRed:168/255.0 green:232/255.0 blue:254/255.0 alpha:1];
    }
    return _progressTintColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end

//
//  underLineButton.m
//  etonkids-iphone
//
//  Created by NEO on 13-5-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "underLineButton.h"

@implementation underLineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
	CGFloat R = 0.0f, G = 0.0f, B = 0.0f;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGSize fontSize =[self.currentTitle sizeWithFont:self.titleLabel.font
											forWidth:self.bounds.size.width
									   lineBreakMode:UILineBreakModeTailTruncation];
    
	UIColor *uiColor = self.titleLabel.textColor;
	CGColorRef color = [uiColor CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		R = components[0];
		G = components[1];
		B = components[2];
	}
	CGContextSetRGBStrokeColor(ctx, R, G, B, 1.0f);
    
	CGContextSetLineWidth(ctx, 1.0f);
    
	CGPoint l = CGPointMake(self.frame.size.width/2.0 - fontSize.width/2.0,
							self.frame.size.height/2.0 +fontSize.height/2.0);
	CGPoint r = CGPointMake(self.frame.size.width/2.0 + fontSize.width/2.0,
							self.frame.size.height/2.0 + fontSize.height/2.0);
    
	CGContextMoveToPoint(ctx, l.x, l.y);
	CGContextAddLineToPoint(ctx, r.x, r.y);
	CGContextStrokePath(ctx);
	[super drawRect:rect];
}

@end

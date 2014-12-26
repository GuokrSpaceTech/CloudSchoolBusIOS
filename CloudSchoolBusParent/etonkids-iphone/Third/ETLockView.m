//
//  ETLockView.m
//  jiesuo
//
//  Created by wen peifang on 13-9-25.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "ETLockView.h"

@implementation ETLockView
@synthesize arr;
@synthesize selectPointArr;
@synthesize currentImage;
@synthesize state;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        arr=[[NSMutableArray alloc]init];
        selectPointArr=[[NSMutableArray alloc]init];
        
        self.backgroundColor = [UIColor clearColor];
        
        bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:bgImageView];
        for (int i=0; i<9; i++) {
            
        
            ETImageView *imageView=[[ETImageView alloc] initWithFrame:CGRectMake((i/3)*(70+20), (i%3)*(20+70), 70, 70)];
            imageView.tag=1000+i;
            [self addSubview:imageView];
            [imageView release];
            
            imageView.choose=NO;
        }
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}
-(UIImage *)drawImage
{
    
    
    UIImage *image = nil;
    
    UIColor *color = [UIColor yellowColor];
    CGFloat width = 10.0f;
    CGSize imageContextSize =bgImageView.frame.size;
    
    UIGraphicsBeginImageContext(imageContextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    if(self.currentImage==nil)
    {
        return nil;
    }
    else
    {
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
        for (int i=0  ;i<[selectPointArr count];i++) {
            CGPoint btnCenter = [[selectPointArr objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(context, btnCenter.x, btnCenter.y);
            CGContextMoveToPoint(context, btnCenter.x, btnCenter.y);
        }
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        
        CGContextStrokePath(context);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image;

    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    UITouch *touch=[touches anyObject];
    if(touch.tapCount==1)
    {
        for (UIView *view in self.subviews) {
            
            if([view isKindOfClass:[ETImageView class]])
            {
                ETImageView *imageview=(ETImageView *)view;
                
                CGPoint currentpoint=[touch locationInView:self];
                
                if(CGRectContainsPoint(imageview.frame, currentpoint))
                {
                    beginPoint=imageview.center;
                    self.currentImage=imageview;
                    imageview.choose=YES;
                    [arr addObject:[NSNumber numberWithInt:imageview.tag-1000]];
                    
                    [selectPointArr addObject:[NSValue valueWithCGPoint:beginPoint]];
                    
                    return;
                }
                
                
            }
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    if(touch.tapCount==1)
    {
        for (UIView *view in self.subviews) {
            
            if([view isKindOfClass:[ETImageView class]])
            {
                ETImageView *imageview=(ETImageView *)view;
               
              
                CGPoint currentpoint=[touch locationInView:self];
                
                
                
                nextPoint=currentpoint;
                
                if(CGRectContainsPoint(imageview.frame, currentpoint))
                {
                   // beginPoint=currentpoint;
                    BOOL found=YES;
                    for (int i=0; i<[arr count]; i++)
                    {
                        NSInteger a=[[arr objectAtIndex:i] integerValue];
                        
                        if(a==imageview.tag-1000)
                        {
                            found=YES;
                            break;
                            
                        }
                        else
                        {
                            found=NO;
                        }
                                                
                        
                        
                    }
                    
                    if(found==NO)
                    {
                        if(self.currentImage!=nil)
                        {
                            self.currentImage=imageview;
                            [arr addObject:[NSNumber numberWithInteger:imageview.tag-1000]];
                            imageview.choose=YES;
                            //beginPoint=imageview.center;
                            
                            [selectPointArr addObject:[NSValue valueWithCGPoint:imageview.center]];
                        }
                        
                        
                    }

                   
                }
                
                
            }
        }
    }
    
    bgImageView.image=[self drawImage];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // beginPoint=CGPointZero;
    
    NSString *str = [arr componentsJoinedByString:@""];
    
    NSLog(@"%@",str);
    
//    if (str.length >= 4) {
        if (delegate && [delegate respondsToSelector:@selector(gesturePassword:)])
        {
            [delegate gesturePassword:str];
        }
//    }
    
    
    
    [arr removeAllObjects];
    [selectPointArr removeAllObjects];
    self.currentImage=nil;
    
    for (UIView *view in self.subviews) {

    
        if([view isKindOfClass:[ETImageView class]])
        {
            ETImageView *imageview=(ETImageView *)view;
            imageview.choose=NO;
        }
    }
    
    bgImageView.image=[self drawImage];

}
@end

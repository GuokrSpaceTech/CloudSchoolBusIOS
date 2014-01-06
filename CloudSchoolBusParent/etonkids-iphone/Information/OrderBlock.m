//
//  OrderBlock.m
//  ssssss
//
//  Created by CaiJingPeng on 13-9-2.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "OrderBlock.h"

@implementation OrderBlock

@synthesize delegate,orderImageView,obType;

- (id)initWithFrame:(CGRect)frame AndImage:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgV.image = img;
        self.orderImageView = imgV;
        [self addSubview:imgV];
        [imgV release];
        
        lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)];
        [self addGestureRecognizer:lpGes];
        [lpGes release];
        
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapPress:)];
//        [self addGestureRecognizer:tapGes];
//        [tapGes release];

        
        status = NormalStatus;
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"deleteTag.png"] forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(0, 0, 20, 20)];
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
//        UIControl *ctl = [[UIControl alloc] initWithFrame:self.bounds];
//        [ctl addTarget:self action:@selector(doDown) forControlEvents:UIControlEventTouchDown];
//        [ctl addTarget:self action:@selector(doUp) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:ctl];
//        [ctl release];
        
        
    }
    return self;
}

- (void)doTapPress:(UIGestureRecognizer *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didTapPressBlock:)] && status != DeleteStatus) {
        [delegate didTapPressBlock:self];
    }
}

- (void)doLongPress:(UIGestureRecognizer *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didLongPressBlock:)] && status != DeleteStatus) {
        [delegate didLongPressBlock:self];
    }
}

- (void)setDeleteStatus
{
    status = DeleteStatus;
    
    [self removeGestureRecognizer:lpGes];
    lpGes = nil;
    
    deleteBtn.hidden = NO;
    
    float rand=(float)random();
    CFTimeInterval t=rand*0.0000000001f;
    [UIView animateWithDuration:0.1 delay:t options:0  animations:^
     {
         self.transform=CGAffineTransformMakeRotation(-0.02);
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
          {
              self.transform=CGAffineTransformMakeRotation(0.02);
          } completion:^(BOOL finished) {}];
     }];
}

- (void)resetNormalStatus
{
    status = NormalStatus;
    [self setIdentity];
    
    if (lpGes == nil) {
        lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)];
        [self addGestureRecognizer:lpGes];
        [lpGes release];
    }
    
    deleteBtn.hidden = YES;
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
         self.transform=CGAffineTransformIdentity;
         
    } completion:^(BOOL finished) {
    
    }];
    
}

- (void)doDelete:(UIButton *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
        [delegate didClickDeleteButton:self];
    }
}

- (void)setBig
{
    [UIView animateWithDuration:0.2f animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0.5f;
    }];
    
    
}
- (void)setIdentity
{
    [UIView animateWithDuration:0.2f animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0f;
    }];
}


- (void)doDown
{
    [self setBig];
}
- (void)doUp
{
    [self setIdentity];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (status == DeleteStatus) {
        UITouch *touch = [touches anyObject];
        startPos = [touch locationInView:[UIApplication sharedApplication].keyWindow];
        
        [self setBig];
    }

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (status == DeleteStatus) {
        UITouch *touch = [touches anyObject];
        CGPoint pos = [touch locationInView:[UIApplication sharedApplication].keyWindow];
        
        [self setBig];
        
        self.center = CGPointMake(self.center.x + (pos.x - startPos.x),
                                  self.center.y + (pos.y - startPos.y));
        
//        NSLog(@"%f,%f",self.center.x,self.center.y);
//        NSLog(@"%f,%f    %f,%f",pos.x,pos.y,startPos.x,startPos.y);
        
        startPos = pos;
        
        if (delegate && [delegate respondsToSelector:@selector(moveBlock:Position:touchPos:)]) {
            [delegate moveBlock:self Position:self.center touchPos:pos];
        }
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (status == DeleteStatus) {
        [self setIdentity];
        [self setDeleteStatus];
        
        if (delegate && [delegate respondsToSelector:@selector(endMoveBlock:)])
        {
            [delegate endMoveBlock:self];
        }
    }
    
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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

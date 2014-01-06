//
//  CustomActionSheet.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-1.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "CustomActionSheet.h"
#import "ETKids.h"
@implementation CustomActionSheet

@synthesize view;

@synthesize toolBar,cDelegate;

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title
{
    self = [super init];
    
    if (self)
    {
        
        int theight = height - 40;
        
        int btnnum = theight/50;
        
        for(int i=0; i<btnnum; i++)
            
        {
            
            [self addButtonWithTitle:@" "];
            
        }
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:LOCAL(@"ok", @"确定")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(done)];
        
        UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithTitle:LOCAL(@"cancel", @"取消")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(docancel)];

        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                target:nil
                                                                action:nil];

        NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,fixedButton,rightButton,nil];
        [toolBar setItems: array];
        [leftButton  release];
        [rightButton release];
        [fixedButton release];
        [array       release];
        [self addSubview:toolBar];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, height-44)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
    }
    
    return self;
    
}

-(void)done
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    if (cDelegate && [cDelegate respondsToSelector:@selector(customActionSheetDidClickOKButton:)]) {
        [cDelegate customActionSheetDidClickOKButton:self];
    }

}

-(void)docancel
{
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    if (cDelegate && [cDelegate respondsToSelector:@selector(customActionSheetDidClickCancelButton:)]) {
        [cDelegate customActionSheetDidClickCancelButton:self];
    }
    
}

-(void)dealloc

{
    
    [view release];
    
    [super dealloc];
    
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

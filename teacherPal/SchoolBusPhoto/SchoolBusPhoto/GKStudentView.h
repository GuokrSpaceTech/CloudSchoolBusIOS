//
//  GKStudentView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-23.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKButton.h"

@protocol studentViewDelegate ;
@interface GKStudentView : UIView<UIActionSheetDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSMutableArray *studentArr;
    
    UIScrollView *scroller;
}
@property (nonatomic,assign)id<studentViewDelegate>delegate;
@property (nonatomic,retain)NSMutableArray *studentArr;

-(void)setAllButtonSelect:(BOOL)isselect;
-(void)setAlreadyStudent:(NSArray *)arr;
@end

@protocol studentViewDelegate <NSObject>

-(void)whitchSelected:(BOOL)selected uid:(NSString *)uid isAll:(int)an;
@optional
- (void)didLongPressStudentButton:(GKButton *)button;

@end
//
//  GKStudentView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-23.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKStudentView.h"
#import "Student.h"

#import "UIButton+WebCache.h"
#define BTNTAG 50
#define BUTONHEIGHT 40
@implementation GKStudentView
@synthesize studentArr;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        iamgeView.image=[UIImage imageNamed:@"guanlianbottom.png"];
//        [self addSubview:iamgeView];
//        [iamgeView release];
        

        scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scroller.showsHorizontalScrollIndicator=NO;
        scroller.showsVerticalScrollIndicator=NO;
        scroller.pagingEnabled = YES;
        scroller.backgroundColor=[UIColor clearColor];
        [self addSubview:scroller];
        [scroller release];

    }
    return self;
}


-(void)setStudentArr:(NSMutableArray *)_studentArr
{
    [studentArr release];
    studentArr=[_studentArr retain];
    
    // 一行四个
    
    int col=([studentArr count] )/4; //行
    //int row=([studentArr count] )%4;
    
    //int y = MIN(col+1, 4);

   // scroller.frame=CGRectMake(0, 0, 320, self.frame.size.height);
    
    NSLog(@"%d",[studentArr count]);
    
    
    if (studentArr.count != 0) {
        
        if (![scroller viewWithTag:777]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"谁在照片里_03.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"谁在照片里_09.png"] forState:UIControlStateSelected];
            btn.tag = 777;
            btn.frame=CGRectMake(3 , 0 , 74, 40);
            [btn addTarget:self action:@selector(doClickAll:) forControlEvents:UIControlEventTouchUpInside];
            [scroller addSubview:btn];
        }
        
        
        
    }
    
    
    for (int i=1; i<[studentArr count]+1 ; i++) {
        
        int col=i/4; //行
        int row=i%4;
        Student *st=[studentArr objectAtIndex:i-1];
        
        if (![scroller viewWithTag:(i + BTNTAG - 1)]) {
            GKButton *button=[GKButton buttonWithType:UIButtonTypeCustom];
           // button.titleLabel.font=[UIFont boldSystemFontOfSize:10];
            button.layer.cornerRadius = 7;
            button.layer.masksToBounds = YES;
            
            //button.frame=CGRectMake(3 +row*(74+6), 5 + col/4*185 + col%4*(45+5), 74, 40);
            button.frame=CGRectMake(3 +row*(74+6), col *(50), 74, 40);
            
           
            
            
            
            [button setBackgroundImageWithURL:[NSURL URLWithString:st.avatar] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
            }];
            
            [button setImage:[UIImage imageNamed:@"谁在照片里_05.png"] forState:UIControlStateNormal];
            
//            
//            if(IOSVERSION>=6.0)
//                button.titleLabel.textAlignment=NSTextAlignmentRight;
//            else
//                button.titleLabel.textAlignment=NSTextAlignmentRight;
            
            //[button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            //[button setTitle:[NSString stringWithFormat:@"%@",st.enname] forState:UIControlStateNormal];
            button.student=st;
            
            
            button.tag = i + BTNTAG - 1;
            
            button.isSelect=NO;
            [button addTarget:self action:@selector(clickStudent:) forControlEvents:UIControlEventTouchUpInside];
            [scroller addSubview:button];
            
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+40, 74, 10)];
            label.font=[UIFont systemFontOfSize:10];
            label.tag= i + BTNTAG - 1 + 10000;
            if(IOSVERSION>=6.0)
                label.textAlignment=NSTextAlignmentCenter;
            else
                label.textAlignment=UITextAlignmentCenter;
            label.text=st.enname;
            [scroller addSubview:label];
            [label release];
            label.textColor=[UIColor orangeColor];

            
            UILongPressGestureRecognizer *l = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)];
//            l.minimumPressDuration = 1;
//            l.delegate = self;
            NSLog(@"add ges %d",i);
            [button addGestureRecognizer:l];
            [l release];
        }
        else
        {
            UILabel *label=(UILabel *)[self viewWithTag: i + BTNTAG - 1 + 10000];
            GKButton *button = (GKButton *)[scroller viewWithTag:(i + BTNTAG - 1)];
            [button setBackgroundImageWithURL:[NSURL URLWithString:st.avatar] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
            }];
            label.text=[NSString stringWithFormat:@"%@",st.enname];
            [button setTitle:[NSString stringWithFormat:@"%@",st.enname] forState:UIControlStateNormal];
        }
        
        
        
        
    }
    
    if (col < 4)
    {
        scroller.contentSize=scroller.frame.size;
    }
    else
    {
        scroller.contentSize=CGSizeMake(scroller.frame.size.width, (col/4+1)*scroller.frame.size.height);
    }
    
}
-(void)setAlreadyStudent:(NSMutableArray *)arr
{
    for (int i=0; i<[arr count]; i++) {
        NSString *uid=[arr objectAtIndex:i];
        
        for (UIView *view in scroller.subviews) {
            
            if([view isKindOfClass:[GKButton class]])
            {
                GKButton *button=(GKButton *)view;
                
                if([button.student.studentid integerValue] == [uid integerValue])
                {
                    button.isSelect=YES;
                }
            }
        }
        
    }
}
-(void)setAllButtonSelect:(BOOL)isselect
{
    
    for (UIView *view in scroller.subviews) {
        if([view isKindOfClass:[GKButton class]])
        {
            GKButton *btn=(GKButton *)view;
            
            
            
            btn.isSelect=isselect;
           // [delegate whitchSelected:btn.isSelect uid:[NSString stringWithFormat:@"%@",btn.student.uid]];
        }
    }

}

- (void)doClickAll:(UIButton *)sender
{
    
    for (UIView *view in scroller.subviews) {
        if([view isKindOfClass:[GKButton class]])
        {
            GKButton *btn=(GKButton *)view;
            if (!btn.isSelect) {
                [self setAllButtonSelect:YES];
                [delegate whitchSelected:0 uid:nil isAll:1];
                return;
            }
        }
    }
    [delegate whitchSelected:0 uid:nil isAll:2];
    [self setAllButtonSelect:NO];
    
}

-(void)clickStudent:(GKButton *)btn
{
//    if(btn.tag==0 + BTNTAG)
//    {
//        [self setAllButtonSelect:YES];
//        
//        [delegate whitchSelected:YES uid:@"" isAll:YES];
//    }
    //else
    //{
        Student *st=btn.student;
        btn.isSelect=!btn.isSelect;
        [delegate whitchSelected:btn.isSelect uid:[NSString stringWithFormat:@"%@",st.studentid] isAll:0];
    //}
   
}


- (void)doLongPress:(UIGestureRecognizer *)sender
{
    
    
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            
            if (delegate && [delegate respondsToSelector:@selector(didLongPressStudentButton:)]) {
                [delegate didLongPressStudentButton:(GKButton *)sender.view];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        default:
            break;
    }
    
    
    
    
    
    
}




-(void)dealloc
{
    self.studentArr=nil;
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

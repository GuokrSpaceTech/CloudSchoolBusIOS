//
//  GKReportStudentView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-1.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportStudentView.h"
#import "GKUserLogin.h"
@implementation GKReportStudentView
@synthesize stuArr;
@synthesize delegate;
@synthesize studentName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        
        UIImageView *imageBGView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageBGView.backgroundColor=[UIColor blackColor];
        imageBGView.alpha=0.6;
        
        [self addSubview:imageBGView];
        [imageBGView release];
        
        
        GKUserLogin *user=[GKUserLogin currentLogin];
        int col=([user.studentArr count] )/4; //行
        int y = MIN(col+1, 4);
        
      //  GKUserLogin *user=[GKUserLogin currentLogin];
        studentView=[[GKStudentView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, 320,y*55)];
        
        studentView.backgroundColor=[UIColor whiteColor];
        studentView.delegate=self;
        [self addSubview:studentView];
        [studentView release];
        
        studentView.studentArr=user.studentArr;
        
        
        stuArr=[[NSMutableArray alloc]init];
        

        
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(delegate&&[delegate respondsToSelector:@selector(studentViewHidden:)])
    {
        GKUserLogin *user=[GKUserLogin currentLogin];
        int col=([user.studentArr count] )/4; //行
        int y = MIN(col+1, 4);
        
        [UIView animateWithDuration:0.3 animations:^{
             studentView.frame=CGRectMake(0, self.frame.size.height, 320,y*55);
        } completion:^(BOOL finished) {
               [delegate studentViewHidden:self];
        }];
//        [UIView animateWithDuration:0.2 animations:^{
//        
//            //
//        }];
        
    }
}
-(void)setStudentViewSelect:(NSArray *)uidArr
{
    self.stuArr=[NSMutableArray arrayWithArray:uidArr];
    [studentView setAlreadyStudent:uidArr];
    
}
-(void)animationstart
{
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    int col=([user.studentArr count] )/4; //行
    int y = MIN(col+1, 4);
    
    [UIView animateWithDuration:0.2 animations:^{
       studentView.frame=CGRectMake(0, self.frame.size.height-(y*55), 320,y*55);
       //
    }];
   
    
}
-(void)whitchSelected:(BOOL)selected uid:(NSString *)uid isAll:(int)an
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    if (an == 1)  // 选择全部
    {
        
        [stuArr removeAllObjects];
        
        for (int i=0; i<[user.studentArr count]; i++) {
            Student *st=[user.studentArr objectAtIndex:i];
            [stuArr addObject:[NSString stringWithFormat:@"%@",st.studentid]];
        }
    }
    
    else if(an==0)
    {
        if([stuArr containsObject:uid])
        {
            [stuArr removeObject:uid];
        }
        else
        {
            [stuArr addObject:uid];
        }
    }
    else if(an==2)
    {
        [stuArr removeAllObjects];
    }
    
    
    if([stuArr count]>0)
    {
        NSString *stid=[stuArr objectAtIndex:0];
        
        for (int i=0; i<[user.studentArr count]; i++) {
            Student *st=[user.studentArr objectAtIndex:i];
            if([st.studentid intValue]==[stid intValue])
            {
                self.studentName=st.cnname;
            }
        }

    }
    else
    {
        self.studentName=@"";
    }
    

    if(delegate&&[delegate respondsToSelector:@selector(studentView:studentIdList:studentName:)])
    {
        [delegate studentView:self studentIdList:self.stuArr studentName:self.studentName];
    }
}
-(void)dealloc
{
    self.stuArr=nil;
    self.studentName=nil;
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

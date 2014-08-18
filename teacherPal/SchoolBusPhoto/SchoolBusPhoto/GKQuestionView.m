//
//  GKQuestionView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-31.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKQuestionView.h"

@implementation GKQuestionView
@synthesize question;
@synthesize titleLabel;
@synthesize index;
@synthesize op1Button,op3Button,op2Button,contentField;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame index:(int)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.index=count;
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 300, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:titleLabel];
        
        
        op1Button=[UIButton buttonWithType:UIButtonTypeCustom];
        op1Button.frame=CGRectMake(10, 25, 90, 30);
        op1Button.tag=1;
        [op1Button addTarget:self action:@selector(opClick:) forControlEvents:UIControlEventTouchUpInside];
      //  op1Button.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
        [op1Button setBackgroundImage:[UIImage imageNamed:@"report_writeselect.png"] forState:UIControlStateNormal];

        [op1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:op1Button];
        
        op2Button=[UIButton buttonWithType:UIButtonTypeCustom];
        op2Button.frame=CGRectMake(115, 25, 90, 30);
        op2Button.tag=2;
        [op2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [op2Button addTarget:self action:@selector(opClick:) forControlEvents:UIControlEventTouchUpInside];
       [op2Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
        [self addSubview:op2Button];
        
        op3Button=[UIButton buttonWithType:UIButtonTypeCustom];
        op3Button.frame=CGRectMake(220, 25, 90, 30);
        op3Button.tag=3;
        [op3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [op3Button addTarget:self action:@selector(opClick:) forControlEvents:UIControlEventTouchUpInside];
      //  op3Button.backgroundColor= [UIColor grayColor];
        [op3Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
        [self addSubview:op3Button];
        
       
        contentField=[[UITextField alloc]initWithFrame:CGRectMake(10, 25, 300, 30)];
        contentField.borderStyle=UITextBorderStyleRoundedRect;
        contentField.delegate=self;
        contentField.text=@"";
        [self addSubview:contentField];
        
        
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 69, self.frame.size.width-4, 1)];
       // lineView.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
        lineView.image=[UIImage imageNamed:@"line.png"];
        [self addSubview:lineView];
        [lineView release];
        
        
        
    }
    return self;
}
-(void)opClick:(UIButton *)btn
{
    int tag=btn.tag;
    
    if(delegate&& [delegate respondsToSelector:@selector(questionView:questionTitle:answer:)])
    {
        if(tag==1)
        {
//            op1Button.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
//            op2Button.backgroundColor= [UIColor grayColor];
//            op3Button.backgroundColor= [UIColor grayColor];
            
            [op1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [op2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [op3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [op1Button setBackgroundImage:[UIImage imageNamed:@"report_writeselect.png"] forState:UIControlStateNormal];
            [op2Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            [op3Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            [delegate questionView:self questionTitle:question.title answer:question.op1];
        }
        else if(tag==2)
        {
//            op1Button.backgroundColor=[UIColor grayColor];
//            op3Button.backgroundColor= [UIColor grayColor];
//            op2Button.backgroundColor=[UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
//
            [op1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [op2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [op3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [op2Button setBackgroundImage:[UIImage imageNamed:@"report_writeselect.png"] forState:UIControlStateNormal];
            [op1Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            [op3Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            
            [delegate questionView:self questionTitle:question.title answer:question.op2];
        }
        else
        {
            op1Button.backgroundColor=[UIColor grayColor];
            op2Button.backgroundColor= [UIColor grayColor];
            op3Button.backgroundColor= [UIColor colorWithRed:97/355.0 green:177/255.0 blue:200/255.0 alpha:1];
            
            [op1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [op2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [op3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            [op1Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            [op2Button setBackgroundImage:[UIImage imageNamed:@"report_writenormal.png"] forState:UIControlStateNormal];
            [op3Button setBackgroundImage:[UIImage imageNamed:@"report_writeselect.png"] forState:UIControlStateNormal];
            [delegate questionView:self questionTitle:question.title answer:question.op3];
        }
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(delegate&& [delegate respondsToSelector:@selector(questionFielddbeginEdit:)])
    {
        [delegate questionFielddbeginEdit:self.index];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if(delegate&& [delegate respondsToSelector:@selector(questionView:questionTitle:answer:)])
     {
         [delegate questionView:self questionTitle:question.title answer:contentField.text];
     }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [delegate questionKeyBoard];
}
-(void)setQuestion:(GKReportQuestion *)_question
{
    [question release];
    question=[_question retain];
    
    titleLabel.text=[NSString stringWithFormat:@"%d、%@",self.index,_question.title];
    
    if([question.type integerValue]==1)
    {
        contentField.hidden=YES;
        op1Button.hidden=NO;
        op2Button.hidden=NO;
        [op1Button setTitle:question.op1 forState:UIControlStateNormal];
        [op2Button setTitle:question.op2 forState:UIControlStateNormal];
        if([question.op3 isEqualToString:@""])
        {
            op3Button.hidden=YES;
        }
        else
        {
            op3Button.hidden=NO;
            [op3Button setTitle:question.op3 forState:UIControlStateNormal];
        }
        
    }
    else
    {
        contentField.hidden=NO;
        op1Button.hidden=YES;
        op2Button.hidden=YES;
        op3Button.hidden=YES;
    }
}
-(void)dealloc
{
    self.question=nil;
    self.titleLabel=nil;
    self.op2Button=nil;
    self.op1Button=nil;
    self.op3Button=nil;
    self.contentField=nil;
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

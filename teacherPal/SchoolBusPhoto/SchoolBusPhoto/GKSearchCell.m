//
//  GKSearchCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSearchCell.h"

@implementation GKSearchCell
@synthesize nameLabel=_nameLabel;
@synthesize telLabel=_telLabel;
@synthesize delegate;
@synthesize agelabel=_agelabel,sexLabel=_sexLabel,classLabel=_classLabel;
@synthesize student;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *BGView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 6, 305, 88)];
        BGView.image=[UIImage imageNamed:@"searchCellContent.png"];
        [self.contentView addSubview:BGView];
        [BGView release];
        
//        UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 48, 240, 1)];
//        lineImageView.backgroundColor=[UIColor grayColor];
//        [self.contentView addSubview:lineImageView];
//        [lineImageView release];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 100, 20)];
        _nameLabel.font=[UIFont systemFontOfSize:17];
        _nameLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        _telLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 18, 120, 20)];
        _telLabel.font=[UIFont systemFontOfSize:17];
        _telLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_telLabel];
        
        _agelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 40, 20)];
        _agelabel.font=[UIFont systemFontOfSize:17];
        _agelabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_agelabel];
        
        _sexLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 60, 60, 20)];
        _sexLabel.font=[UIFont systemFontOfSize:17];
        _sexLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_sexLabel];
        
        _classLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 60, 100, 20)];
        _classLabel.font=[UIFont systemFontOfSize:17];
        _classLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_classLabel];
        
        
        seleBtn=[UIButton buttonWithType:UIButtonTypeCustom];

        seleBtn.frame=CGRectMake(260, 27, 32, 32);
        [seleBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:seleBtn];
        [seleBtn setSelected:NO];
        
        
    }
    return self;
}
-(void)setStudent:(GKStudentAdd *)_student
{
    [student release];
    student=[_student retain];
    //UIButton *btn=(UIButton *)[self.contentView viewWithTag:100];
    if(student.isSelect)
    {
         [seleBtn setBackgroundImage:[UIImage imageNamed:@"searchselected.png"] forState:UIControlStateNormal];
    }
    else
    {
         [seleBtn setBackgroundImage:[UIImage imageNamed:@"searchselect.png"] forState:UIControlStateNormal];
    }
}
-(void)select:(UIButton *)btn
{

    self.student.isSelect=!self.student.isSelect;
    if(delegate&& [delegate respondsToSelector:@selector(cell:student:)])
    {
        [delegate cell:self  student:student];
    }
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:student.studentID,@"studentid",student.studentUID,@"studentuid",@"0",@"type",nil];
//    [[EKRequest Instance]EKHTTPRequest:inclass parameters:dic requestMethod:GET forDelegate:self];
}
//-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
//{
//    NSLog(@"%d",code);
//}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)dealloc
{
    self.nameLabel=nil;
    self.telLabel=nil;
    self.agelabel=nil;
    self.sexLabel=nil;
    self.classLabel=nil;
    self.student=nil;
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

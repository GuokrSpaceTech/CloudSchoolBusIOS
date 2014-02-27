//
//  ETPhotoCell.m
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-31.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "ETPhotoCell.h"

@implementation ETPhotoCell
@synthesize imageView1,imageView2,imageView3,imageView4;
@synthesize delegate;
@synthesize isSelect1,isSelect2,isSelect3,isSelect4;

//-(void)shadeoffset:(UIImageView *)iamgeView
//{
//    iamgeView.layer.borderColor=[UIColor whiteColor].CGColor;
//    iamgeView.layer.borderWidth=2;
//    iamgeView.layer.shadowColor=[UIColor blackColor].CGColor;
//    iamgeView.layer.shadowOffset=CGSizeMake(1, 1);
//    iamgeView.layer.shadowOpacity=0.5;
//    iamgeView.layer.shadowRadius=1;
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
     
        isSelect1=NO;
        isSelect2=NO;
        isSelect3=NO;
        isSelect4=NO;
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(4, 2, 75, 75)];
        [self.contentView addSubview:imageView1];
        imageView1.backgroundColor=[UIColor clearColor];
        imageView1.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView1:)];
        tap1.numberOfTapsRequired=1;
        [imageView1 addGestureRecognizer:tap1];
        [tap1 release];
        
        imageView11=[[UIImageView alloc]initWithFrame:CGRectMake(55, 55, 20, 20)];
        
        NSString *imagestr=[[NSBundle mainBundle]pathForResource:@"duihao" ofType:@"png"];
        imageView11.image=[UIImage imageWithContentsOfFile:imagestr];
        [imageView1 addSubview:imageView11];
        [imageView11 release];
        
        
        imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(83, 2, 75, 75)];
        imageView2.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imageView2];
        imageView2.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView2:)];
        tap2.numberOfTapsRequired=1;
        [imageView2 addGestureRecognizer:tap2];
        [tap2 release];
        
        
        imageView21=[[UIImageView alloc]initWithFrame:CGRectMake(55, 55, 20, 20)];
        imageView21.image=[UIImage imageWithContentsOfFile:imagestr];
        [imageView2 addSubview:imageView21];
        [imageView21 release];
        
        
        imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(162, 2, 75, 75)];
        imageView3.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imageView3];
        imageView3.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView3:)];
        tap3.numberOfTapsRequired=1;
        [imageView3 addGestureRecognizer:tap3];
        [tap3 release];
        
        imageView31=[[UIImageView alloc]initWithFrame:CGRectMake(55, 55, 20, 20)];
        imageView31.image=[UIImage imageWithContentsOfFile:imagestr];
        [imageView3 addSubview:imageView31];
        [imageView31 release];
        
        imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(241, 2, 75, 75)];
        imageView4.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imageView4];
        imageView4.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView4:)];
        tap4.numberOfTapsRequired=1;
        [imageView4 addGestureRecognizer:tap4];
        [tap4 release];
        
        imageView41=[[UIImageView alloc]initWithFrame:CGRectMake(55, 55, 20, 20)];
        imageView41.image=[UIImage imageWithContentsOfFile:imagestr];
        [imageView4 addSubview:imageView41];
        [imageView41 release];
   
        
//        [self shadeoffset:imageView1];
//        [self shadeoffset:imageView2];
//        [self shadeoffset:imageView3];
//        [self shadeoffset:imageView4];
        
        imageView11.hidden=YES;
        imageView21.hidden=YES;
        imageView31.hidden=YES;
        imageView41.hidden=YES;
        
    }
    return self;
}
-(void)setIsSelect1:(BOOL)_isSelect1
{
    isSelect1=_isSelect1;
    
    if(isSelect1)
    {
        imageView11.hidden=NO; 
    }
    else
    {
        imageView11.hidden=YES;
    }
}

-(void)setIsSelect2:(BOOL)_isSelect2
{
    isSelect2=_isSelect2;
    
    if(isSelect2)
    {
        imageView21.hidden=NO;
    }
    else
    {
        imageView21.hidden=YES;
    }
}


-(void)setIsSelect3:(BOOL)_isSelect3
{
    isSelect3=_isSelect3;
    
    if(isSelect3)
    {
        imageView31.hidden=NO;
    }
    else
    {
        imageView31.hidden=YES;
    }
}


-(void)setIsSelect4:(BOOL)_isSelect4
{
    isSelect4=_isSelect4;
    
    if(isSelect4)
    {
        imageView41.hidden=NO;
    }
    else
    {
        imageView41.hidden=YES;
    }
}

-(void)imageView1:(UITapGestureRecognizer *)tap
{

    if(isSelect1==NO)
    {
        isSelect1=YES;
        imageView11.hidden=NO;
    }
    else
    {
        isSelect1=NO;
         imageView11.hidden=YES;
    }
    [delegate selectPhoto:imageView1.tag select:isSelect1];
}
-(void)imageView2:(UITapGestureRecognizer *)tap
{
    if(isSelect2==NO)
    {
        isSelect2=YES;
         imageView21.hidden=NO;
    }
    else
    {
        isSelect2=NO;
         imageView21.hidden=YES;
    }
    [delegate selectPhoto:imageView2.tag select:isSelect2];
}
-(void)imageView3:(UITapGestureRecognizer *)tap
{
    if(isSelect3==NO)
    {
         imageView31.hidden=NO;
        isSelect3=YES;
    }
    else
    {
        isSelect3=NO;
         imageView31.hidden=YES;
    }
    [delegate selectPhoto:imageView3.tag select:isSelect3];
}
-(void)imageView4:(UITapGestureRecognizer *)tap
{
    if(isSelect4==NO)
    {
        isSelect4=YES;
         imageView41.hidden=NO;
    }
    else
    {
        isSelect4=NO;
         imageView41.hidden=YES;
    }
    [delegate selectPhoto:imageView4.tag select:isSelect4];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.imageView4=nil;
    self.imageView3=nil;
    self.imageView2=nil;
    self.imageView1=nil;
    [super dealloc];
}
@end

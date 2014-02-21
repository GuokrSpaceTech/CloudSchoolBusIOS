//
//  GKLetterCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKLetterCell.h"
#import "UIImageView+WebCache.h"
#define BGTAG 100
#define PICTAG 1000
@implementation GKLetterCell
@synthesize letter,labelcontent;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        UIImageView *BGImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        BGImageView.backgroundColor=[UIColor clearColor];
        BGImageView.tag=BGTAG;
        [self.contentView addSubview:BGImageView];
        [BGImageView release];
        
//        labelWho=[[UILabel alloc]initWithFrame:CGRectZero];
//        labelWho.backgroundColor=[UIColor clearColor];
//        labelWho.font=[UIFont systemFontOfSize:12];
//        labelWho.textColor=[UIColor whiteColor];
//        [self.contentView addSubview:labelWho];
//        
//        labeTime=[[UILabel alloc]initWithFrame:CGRectZero];
//        labeTime.backgroundColor=[UIColor clearColor];
//        labeTime.font=[UIFont systemFontOfSize:12];
//        labeTime.textColor=[UIColor whiteColor];
//        [self.contentView addSubview:labeTime];
//        
        
        labelcontent=[[HTCopyableLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        labelcontent.backgroundColor=[UIColor clearColor];
        labelcontent.font=[UIFont systemFontOfSize:14];
        labelcontent.textColor=[UIColor blackColor];
        labelcontent.userInteractionEnabled=YES;
        
           
        labelcontent.numberOfLines=0;
        if(IOSVERSION>=6.0)
            labelcontent.lineBreakMode=NSLineBreakByWordWrapping;
        else
            labelcontent.lineBreakMode=UILineBreakModeWordWrap;
        [self.contentView addSubview:labelcontent];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLetter:(Letter *)_letter
{
    [letter release];
    letter=[_letter retain];
    
    labelcontent.frame=CGRectZero;
    for (UIView *view in [self.contentView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView=(UIImageView *)view;
            if(imageView.tag>=PICTAG)
            {
                [imageView removeFromSuperview];
            }
        }
    }
    if([_letter.letterFromRole isEqualToString:@"admin"])
    {
        // 左气泡
        

        if([_letter.letterLetterType isEqualToString:@"txt"])
        {
            CGSize size=[letter.letterContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            labelcontent.text=letter.letterContent;
            labelcontent.backgroundColor=[UIColor clearColor];
            labelcontent.frame=CGRectMake(22, 20 , size.width, size.height);
            
            
            UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
            bgView.frame=CGRectMake(10, 10, size.width+20, labelcontent.frame.origin.y + labelcontent.frame.size.height);
            //(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
            bgView.backgroundColor=[UIColor clearColor];
            UIImage *iamge=[[UIImage imageNamed:@"qipao1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 10, 8, 8)];
            bgView.image=iamge;
        }
        else
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(22 , 15 , 75, 100)];
            imageView.backgroundColor=[UIColor clearColor];
    
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            tap.numberOfTapsRequired=1;
            [imageView addGestureRecognizer:tap];
            [tap release];
            NSString *imagestr=[NSString stringWithFormat:@"%@.small.jpg",letter.letterContent];
            
            [imageView setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                imageView.userInteractionEnabled=YES;
                
                CGSize size=image.size;
                
                float rate=(float)size.width/size.height;
                float width=0;
                float height=0;
                if(rate>1)
                {
                    width=100;
                    height=width * (1/rate);
                    
                }
                else
                {
                    height=100;
                    width=height * rate;
                    
                }
                
                
                imageView.frame=CGRectMake(22, 15 ,width, height);
                
               // imageView.frame=CGRectMake(22, 15, size.width, size.height);
                
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(10, 10, width+20, height+10);
                bgView.backgroundColor=[UIColor clearColor];
                UIImage *iamge=[[UIImage imageNamed:@"qipao1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 10, 8, 8)];
                bgView.image=iamge;

                
        
            }];
            imageView.tag=PICTAG;
            [self.contentView addSubview:imageView];
            [imageView release];
            
            
        }
        


        
    }
    if([_letter.letterFromRole isEqualToString:@"teacher"])
    {
         // 左气泡
//        labelWho.frame=CGRectMake(120, 20, 60, 20);

    
        
        if([_letter.letterLetterType isEqualToString:@"txt"])
        {
            CGSize size=[letter.letterContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            labelcontent.text=letter.letterContent;
            
            labelcontent.frame=CGRectMake(320-20-size.width-2, 20 , size.width, size.height);
            
           // 5 8 12  10
            UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
            bgView.frame=CGRectMake(320-size.width-30, 10, size.width +20, labelcontent.frame.origin.y + labelcontent.frame.size.height);
            UIImage *iamge=[[UIImage imageNamed:@"qipao22.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 12, 11)];
             //UIImage *iamge=[UIImage imageNamed:@"qipao22.png"];
            bgView.image=iamge;

        }
        else
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(320-20-77, 15 , 75, 100)];
            imageView.backgroundColor=[UIColor clearColor];
            imageView.tag=PICTAG;
             NSString *imagestr=[NSString stringWithFormat:@"%@.small.jpg",letter.letterContent];
            [imageView setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                imageView.userInteractionEnabled=YES;
                
                CGSize size=image.size;
                
                float rate=(float)size.width/size.height;
                float width=0;
                float height=0;
                if(rate>1)
                {
                    width=100;
                    height=width * (1/rate);
                    
                }
                else
                {
                    height=100;
                    width=height * rate;
                    
                }
                
               
                imageView.frame=CGRectMake(320-20-width, 15 ,width, height);
                
                
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(320-width-28, 10, width +20, height+10);
                UIImage *iamge=[[UIImage imageNamed:@"qipao22.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 12, 11)];
                // UIImage *iamge=[UIImage imageNamed:@"qipao22.png"];
                bgView.image=iamge;

                
            }];
   
            [self.contentView addSubview:imageView];
            [imageView release];
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            tap.numberOfTapsRequired=1;
            [imageView addGestureRecognizer:tap];
            [tap release];
      
            
        }

        
    }
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    [delegate clickImageViewLookImage:letter.letterContent];
}
-(void)dealloc
{
    self.letter=nil;
//    self.labeTime=nil;
//    self.labelWho=nil;
    self.labelcontent=nil;
    
    [super dealloc];
}
//@property (nonatomic,retain)UILabel *labelWho;
//@property (nonatomic,retain)UILabel *labeTime;
//@property (nonatomic,retain)UILabel *labelcontent;
//
//@property (nonatomic,retain)Letter *letter;

@end

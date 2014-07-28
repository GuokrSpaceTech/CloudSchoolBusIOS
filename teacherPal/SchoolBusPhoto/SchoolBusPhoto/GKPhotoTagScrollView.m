//
//  GKPhotoTagScrollView.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKPhotoTagScrollView.h"
#import "GKSchoolTag.h"
#import "GKButtonTag.h"
#define TOPMARGIN 5
#define LEFTMARGIN 5
#define DISTANCE 5  // 间距.

#define BUTTON_HEIGHT 40

#define TAG 999

#define TITLEFONT [UIFont systemFontOfSize:13]

@implementation GKPhotoTagScrollView
@synthesize tagDelegate,photoTags;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotoTags:(NSArray *)tags
{
    photoTags = tags;
    int x = LEFTMARGIN; // 标记当前插入位置.
    int y = TOPMARGIN;
    
    for (int i = 0 ; i < tags.count; i++) {
        
        int originX;
        int originY;
        int width; /*按钮宽度*/
        GKSchoolTag *phototag=[tags objectAtIndex:i];
         NSString *title=@"";
        
        
        NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        NSLog(@"%@",strLanguage);
        if ([strLanguage isEqualToString:@"zh-Hans"])
        {
             title=phototag.tagname;
        }
        else
        {
             title=phototag.tagname_en;
        }
       // NSString *title = [tags objectAtIndex:i];
        //NSString *title=tag.tagname;
        //CGSize titleSize = [title sizeWithFont:TITLEFONT constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByWordWrapping];
        width = 95; //固定长度
//        width = titleSize.width + 10;
        
        if (self.frame.size.width >= x + width + DISTANCE)
        {
            originX = x;
            originY = y;
            
            x = originX + width + DISTANCE;
        }
        else
        {
            originX = LEFTMARGIN;
            originY = y + DISTANCE + BUTTON_HEIGHT;
            x = originX + width + DISTANCE;  //
            y = originY;
        }
        
        GKButtonTag *btn = [GKButtonTag buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.numberOfLines = 2;
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateSelected];
        btn.phototag=phototag;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(originX, originY, width, BUTTON_HEIGHT)];
        btn.titleLabel.font = TITLEFONT;
        btn.tag = TAG + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    self.contentSize = CGSizeMake(self.frame.size.width, y + BUTTON_HEIGHT + DISTANCE);
}

- (void)clickButton:(GKButtonTag *)btn
{
    
    btn.selected=!btn.selected;
    
    if(tagDelegate && [tagDelegate respondsToSelector:@selector(didSelectPhotoTag:tagstr:)])
    {
        NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        NSLog(@"%@",strLanguage);
        if ([strLanguage isEqualToString:@"zh-Hans"])
        {
          //  title=phototag.tagname;
            [tagDelegate didSelectPhotoTag:[btn.phototag.tagid integerValue] tagstr:btn.phototag.tagname];
            
        }
        else
        {
            [tagDelegate didSelectPhotoTag:[btn.phototag.tagid integerValue] tagstr:btn.phototag.tagname_en];
        }

        
    
    }
    
    
//    for (int i = 0; i < photoTags.count; i++) {
//        //重置所有按钮.
//        
//        UIButton *btn = (UIButton *)[self viewWithTag:TAG + i];
//        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//    
//    if (sender.tag != selectedTag)
//    {
//        // 未激活为黑色  激活为白色
//        [sender setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
//        
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        if (tagDelegate && [tagDelegate respondsToSelector:@selector(didSelectPhotoTag:)]) {
//            [tagDelegate didSelectPhotoTag:sender.titleLabel.text];
//        }
//        
//        selectedTag = sender.tag;
//    }
//    else
//    {
//        selectedTag = 0;
//        // 取消激活.
//        if (tagDelegate && [tagDelegate respondsToSelector:@selector(didSelectPhotoTag:)]) {
//            [tagDelegate didSelectPhotoTag:@""];
//        }
//    }
//
//    
    
}
-(void)setAlreadyTag:(NSMutableArray *)arr
{
    for (int i = 0; i < photoTags.count; i++) {
        //重置所有按钮.
        
        GKButtonTag *btn = (GKButtonTag *)[self viewWithTag:TAG + i];
        btn.selected=NO;
        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        for (int j=0; j<[arr count]; j++) {
            int tag=[[arr objectAtIndex:j] integerValue];
            if(tag==[btn.phototag.tagid integerValue])
            {
                [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
                btn.selected=YES;
                selectedTag = btn.tag;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }
        
//        if([btn.titleLabel.text isEqualToString:tagstr])
//        {
//            
//        }
        
        
    }

}
//-(void)setSelectTag:(NSString *) tagstr
//{
//    for (int i = 0; i < photoTags.count; i++) {
//        //重置所有按钮.
//        
//        UIButton *btn = (UIButton *)[self viewWithTag:TAG + i];
//        [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        if([btn.titleLabel.text isEqualToString:tagstr])
//        {
//            [btn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-blue-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
//            selectedTag = btn.tag;
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//        
//        
//    }
//    if([tagstr isEqualToString:@""])
//    {
//        selectedTag=0;
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

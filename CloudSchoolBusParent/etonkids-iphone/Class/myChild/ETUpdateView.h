//
//  ETUpdateView.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ETUpdateView;
@protocol UpdateViewdelegate <NSObject>

-(void)clickView:(ETUpdateView *)_view;

@end
@interface ETUpdateView : UIView
{
    UILabel *titleLabel;
    UIImageView *imageView;
    id<UpdateViewdelegate>delegate;
}
@property(nonatomic,retain)  UILabel *titleLabel;
@property(nonatomic,assign)  id<UpdateViewdelegate>delegate;
@end



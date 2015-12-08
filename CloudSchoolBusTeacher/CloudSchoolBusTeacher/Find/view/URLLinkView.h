//
//  URLLinkView.h
//  CloudBusParent
//
//  Created by macbook on 15/11/25.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol URLLinkViewDelegate <NSObject>
@required

-(void) userTapHandles:(NSString *)title withURL:(NSString *)urlString;

@end

@interface URLLinkView : UIView
@property (nonatomic,strong) IBOutlet UILabel *title;
@property (nonatomic,strong) IBOutlet UILabel *desc;
@property (nonatomic,strong) IBOutlet UIImageView *iconImage;
@property (nonatomic,strong) IBOutlet UIView *containerView;

@property (nonatomic,strong) Message *message;
@property (nonatomic,weak)   id<URLLinkViewDelegate> delegate;
@end

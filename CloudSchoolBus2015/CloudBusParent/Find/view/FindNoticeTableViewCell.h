//
//  FindNoticeTableViewCell.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindCellTopView.h"
#import "Message.h"
#import "AriticleView.h"
#import "URLLinkView.h"

@interface FindNoticeTableViewCell : UITableViewCell
{
    UIImageView * currentImageView; //记录第几个图片
}
@property (nonatomic,strong) FindCellTopView * topView;
@property (nonatomic,strong) Message *messsage;
@property (nonatomic,strong) AriticleView *articleView;
@property (nonatomic,strong) URLLinkView *linkView;
@end

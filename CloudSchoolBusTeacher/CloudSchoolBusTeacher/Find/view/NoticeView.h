//
//  NoticeView.h
//  CloudBusParent
//
//  Created by mactop on 11/24/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol NoticeViewDelegate <NSObject>
@required

-(void) userConfirm:(NSString *)messageid;
-(void) pictureClick:(NSArray *)pictureUrlArray;

@end

@interface NoticeView : UIView
@property (nonatomic,strong) IBOutlet UILabel *title;
@property (nonatomic,strong) IBOutlet UILabel *content;
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) IBOutlet UIButton *confirmButton;

@property (nonatomic,strong) Message *message;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *width;

@property (nonatomic,weak)   id<NoticeViewDelegate> delegate;
@end

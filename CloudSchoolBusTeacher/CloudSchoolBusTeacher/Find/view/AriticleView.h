//
//  AriticleView.h
//  CloudBusParent
//
//  Created by mactop on 11/20/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol ArticleViewDelegate <NSObject>
@required

-(void) userSelectedPicture:(NSString *)picture pictureArray:(NSMutableArray *)picArray indexAt:(int)index withComments:(NSString *)comments;
-(void) userSelectedTag:(NSString *)tagDesc onButton:(UIButton *)button;

@end

@interface AriticleView : UIView
@property (nonatomic,strong) Message *message;
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) NSMutableArray *tagButtons;
@property (nonatomic,strong) UILabel  *descLabel;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *width;

@property (nonatomic, weak) id <ArticleViewDelegate> delegate;
@end
